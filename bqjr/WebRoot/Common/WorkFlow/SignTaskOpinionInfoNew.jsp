<%@page import="com.amarsoft.app.billions.CommonUtils"%>
<%@page import="com.amarsoft.webclient.RunID5"%>
<%@page import="com.amarsoft.webclient.RenZhengBao"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150424 CCS-724 弹出取消选项框后，再点击关闭，停留在当前页面
					 xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
					 xswang 20150505 CCS-637 PRM-293 审核过程中审核要点功能维护
					 xswang 2015/05/25 CCS-808 系统全流程电子化改造：文件质量检查
					 xswang 20150615 CCS-900 审核中的任务不能被暂停
	 */
	%>
<%/*~END~*/%>

<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("PhaseNo"));
	String sFlowNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("FlowNo"));
	String sRet = DataConvert.toRealString(iPostChange,CurComp.getParameter("Ret"));
	if(sRet==null)sRet="";
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	
	String sToday = StringFunction.getTodayNow();
	
	//获取最新的字段数据
	String sSql = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
	sSerialNo = Sqlca.getString(new SqlObject(sSql)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo));
	if(sSerialNo == null) sSerialNo = "";
	sSql = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo).setParameter("SerialNo", sSerialNo));
	if(sPhaseNo == null) sPhaseNo = "";
	
	String sCustomerID = Sqlca.getString("select customerid from Business_Contract where SerialNo = '"+sObjectNo+"'");
	if(sCustomerID == null) sCustomerID = "";
	//
	String sCheckPoint = Sqlca.getString("select checkpoint from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"'");
	if(sCheckPoint == null) sCheckPoint = "";
	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	if(ssuretype==null)	ssuretype="";
	
	String sLineMaxButton = "7";//设置当前页面每行最大按钮数量为8
	CurPage.setAttribute("ButtonsLineMax",sLineMaxButton);
	String sAPPUrl4pdf = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String sAPPUrl4photo = CodeCache.getItem("PrintAppUrl","0011").getItemAttribute();
	String sAPPUrl4record = CodeCache.getItem("PrintAppUrl","0012").getItemAttribute();
	String sJQMUrl4pdf = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String sAPPUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0014").getItemAttribute();
	String sFCUrl4pdf = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	String sFCUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0016").getItemAttribute();

%>
<!-- 
	<textarea type=textfield  bgcolor="#FDFDF3" readonly style='width:100%;height:100px;resize: none;'>
【审核要点提示】：<%="\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sCheckPoint%>
	</textarea>
	 -->
<%
	
	
	String sDoNo = "SignTaskOpinionInfo";
	boolean bUserId5 = true;
	/* 是否需要弹出页面选择意见 */
	boolean needPage = false;
	//暂时把各个阶段的显示模板编号配置到PHASEATTRIBUTE字段上(对应流程配置中的'阶段属性')
	/* {DONO:xxxInfo}{NEEDPAGE:true}  */
	String str = Sqlca.getString("select PHASEDESCRIBE from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"' and PHASEDESCRIBE is not null  ");
	System.out.println("*********"+str);
	if( ! StringX.isEmpty(str)){
		String[] strs = StringX.parseArray(str);
		for(String s: strs){
			if(s == null) s = "";
			String tempStr = s.replace(" ", "");
			if(tempStr == null) tempStr = "";
			if(tempStr.substring(0, 4).equalsIgnoreCase("DONO")){
				sDoNo = tempStr.substring(5);
			}else if(tempStr.substring(0,8).equalsIgnoreCase("NEEDPAGE")){
				needPage = StringX.parseBoolean(tempStr.substring(9));
			}
		}
	}
	
	/*  ID5 AREA  add by tbzeng 2014/07/31 START PART1*/
	String reqHeader="", reqData = "", sDbTip = "", sOpinionId = "010";
  	String renzhengbao="K";//是否已经调用了认证宝
	String imgpath = CurConfig.getConfigure("ImageFolder");// imgpath 用于头像保存路径  by linhai 20150519 CCS-757
	String savepath = CurConfig.getConfigure("XmlFolder");//CCS-757 by linhai
	String sCompSatus="", sCompResult="", status2="", sworkAddName="",sworkCorp="", sindWorkAddName="",sindWorkCorp="", sphoneName="",snewAdd="", sindPhoneName="", sindNewAdd="",bBFDbAccess="success";
	boolean bFamilyTel = true;
	if (savepath == null || savepath.length()<=0) {
		savepath = sResourcesPath;
	}
		try{
	renzhengbao = Sqlca.getString(new SqlObject("select status from business_renzhengbao where 1='1'"));//认证宝开关，Y表示启用，N表示不启用
	}catch(Exception e) {
		
	}
	String sCheckPhaseName = Sqlca.getString(new SqlObject("SELECT PHASENAME FROM FLOW_TASK WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sSerialNo));
	if (sCheckPhaseName == null) sCheckPhaseName = "";
	sCheckPhaseName = sCheckPhaseName.trim();
	if ("NCIIC信息自动检查".equals(sCheckPhaseName)) {
		
		try {
			reqData = Sqlca.getString(new SqlObject("SELECT CUSTOMERNAME||'@'||CERTID FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID")
								 .setParameter("CUSTOMERID", sCustomerID));
		} catch(Exception e) {
			bBFDbAccess = "error";
		}
		//"reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum
		reqHeader = "1A020201";
		if(!"timeOut".equals(sRet)){
		sRet = RunID5.runParserId5(Sqlca, sCustomerID, reqHeader, reqData, savepath, "010",imgpath); //imgpath 用于头像保存路径  by linhai 20150519 CCS-757
		}
	} else if (("ID5办公电话检查".equals(sCheckPhaseName) || "ID5办公电话核查".equals(sCheckPhaseName)) && bUserId5) {
		
		reqData = Sqlca.getString(new SqlObject("SELECT WORKTEL FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID")
								.setParameter("CUSTOMERID", sCustomerID));
		if(reqData == null) reqData = "";	
		reqData = reqData.replace("-", "");
		reqHeader = "1C1G01";
		/** update 修改连接ID5校验超时“ID5_XML_ELE_VAL”锁表问题 tangyb 20150826 start
		// 检查是否超过30天，超过则需要重新获取
		String sExists = null;
		try {
			sExists = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
		} catch (Exception e) {
			bBFDbAccess = "error";
			sExists = null;
		}
		if (sExists != null) {
			double overDayCmp = Sqlca.getDouble(new SqlObject("SELECT (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30)) AS ID5DATE FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO")
				.setParameter("SERIALNO", reqHeader+"#"+reqData));
			if (overDayCmp > 0) {	// 已经超过30天
				Sqlca.executeSQL(new SqlObject("DELETE  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
			}
		}
		update 修改连接ID5校验超时“ID5_XML_ELE_VAL”锁表问题 tangyb 20150826 end**/
		if(!"timeOut".equals(sRet)){
		sRet = RunID5.runParserId5(Sqlca, sCustomerID, reqHeader, reqData, savepath, "020",imgpath);//imgpath 用于头像保存路径  by linhai 20150519
		}
	} else if (("ID5家庭电话检查".equals(sCheckPhaseName) || "ID5家庭电话核查".equals(sCheckPhaseName)) && bUserId5) {
		try {
			reqData = Sqlca.getString(new SqlObject("SELECT FAMILYTEL FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID")
				.setParameter("CUSTOMERID", sCustomerID));
		} catch(Exception e) {
			bBFDbAccess = "error";
		}
		if (reqData == null) {
			reqData = "";
			bFamilyTel = false;
		}
		reqData = reqData.replace("-", "");
		reqHeader = "1C1G01";
		
		// 检查是否超过30天，超过则需要重新获取
		//String sExists = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
		
		if (bFamilyTel) {
			/* 修改连接ID5校验超时“ID5_XML_ELE_VAL”锁表问题 
			if (sExists != null) {
				double overDayCmp = Sqlca.getDouble(new SqlObject("SELECT (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30)) AS ID5DATE FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO")
					.setParameter("SERIALNO", reqHeader+"#"+reqData));
				if (overDayCmp > 0) {	// 已经超过30天
					Sqlca.executeSQL(new SqlObject("DELETE  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
				}
			}
			 */
			if(!"timeOut".equals(sRet)){
			sRet = RunID5.runParserId5(Sqlca, sCustomerID, reqHeader, reqData, savepath, "020",imgpath);//imgpath 用于头像保存路径  by linhai 20150519 CCS-757
			}
		} 
		/** update 修改连接ID5校验超时“ID5_XML_ELE_VAL”锁表问题 tangyb 20150826 end**/
	}
	
	System.out.println("xxxxxxxxoooooo---"+sCheckPhaseName +":  " + sRet);
	//  设置页码提示值
	try {
		
		// 设置显示数据来源
		String sRetHeader = "";
		if (sRet==null || sRet.length()<=0) {
			sRetHeader = "900";
		} else {
			sRetHeader = sRet.substring(0, 3);
		}
		// 如果家庭电话未空
		if (!bFamilyTel) {
			sRetHeader = "900";
		}
		if ("010".equals(sRetHeader)) {
			//sDbTip = "<font class=\"ecrmpt9\">&nbsp;信息来源于佰仟数据库&nbsp;</font>";
			sDbTip = "信息来源于佰仟数据库";
		} else if("020".equals(sRetHeader)) {
			//sDbTip = "<font class=\"ecrmpt9\">&nbsp;信息来源于ID5数据库&nbsp;</font>";
			sDbTip = "信息来源于ID5数据库";
		} else if ("900".equals(sRetHeader)) {
			sDbTip = "未输入家庭电话号";
		}
		if ("error".equals(sRet)) {
			sDbTip = "ID5访问失败";
		}
		if ("timeOut".equals(sRet)) {
			   sDbTip = "信息来源于人工模式";
			  
		}
		if("Y".equals(renzhengbao)&&!"010".equals(sRetHeader)){
		try{
					 //开通认证宝时，因认证宝没有查询办公电话功能，无论数据库中是否有超过30天合同，数据来源都显示佰仟数据库或者访问失败  qlm 20151221
		  	if (!"NCIIC信息自动检查".equals(sCheckPhaseName)) {
		  		sDbTip ="信息来源于人工模式";
		  		sCompResult="访问失败";
		  		  sOpinionId = "070"; 
		  	}else{
		    sDbTip = "信息来源于认证宝";
		 	String 	identification=	Sqlca.getString(new SqlObject("SELECT certid FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID").setParameter("CUSTOMERID", sCustomerID));
		 	String 	customerName=	Sqlca.getString(new SqlObject("SELECT customername FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID").setParameter("CUSTOMERID", sCustomerID));
		 	String  result=	RenZhengBao.simpleCheckByJson(Sqlca,identification,customerName,"bqjr_admin","baiqian123",CurUser.getUserID());
		      if("一致".equals(result)){
		    	  sOpinionId = "010";
		      }else if("一致，但库中无认证人照片".equals(result)){
		    	  sOpinionId = "030"; 
		      }else if("不一致".equals(result)){
		    	  sOpinionId = "020";
		      }else if("库中无此号".equals(result)){
		    	  sOpinionId = "040";
		      }else if("一致_1".equals(result)){
		    	  sDbTip = "信息来源于佰仟数据库 认证宝";
		    	  sOpinionId = "010";
		    	  result="一致";
		      }else if("一致，但库中无认证人照片_1".equals(result)){
		    	  sDbTip = "信息来源于佰仟数据库 认证宝";
		    	  sOpinionId = "030";
		    	  result="一致，但库中无认证人照片";
		      }else if("不一致_1".equals(result)){
		    	  sDbTip = "信息来源于佰仟数据库 认证宝";
		    	  sOpinionId = "020";
		    	  result="不一致";
		      }else if("库中无此号_1".equals(result)){
		    	  sDbTip = "信息来源于佰仟数据库 认证宝";
		    	  sOpinionId = "040";
		    	  result="库中无此号";
		      }else{
		    	  sOpinionId = "050";
		    	  sDbTip = "认证宝访问失败";
		      }
		        sCompResult=result;
		        }
		}catch(Exception e) {
			
		}
	}else{
		// 判断意见逻辑
		ASResultSet id5Rs = Sqlca.getASResultSet(new SqlObject("SELECT STATUS2, VALUE2,COMPRESULT,COMPSTATUS,CHECKPHOTO,QUERYTYPE, CORPTEL,QUERYRESULT,TELINPUT, CORPNAME,AREACODE,CORPADDRESS,Z_NAME,HOMEADDRESS,INPUTDATE,CUSTOMERID  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO")
			.setParameter("SERIALNO", reqHeader+"#"+reqData));
		if (id5Rs.next()) {	// 查询国政通返回数据
			if ("NCIIC信息自动检查".equals(sCheckPhaseName)) {
				
				sCompSatus = id5Rs.getString("COMPSTATUS");
				sCompResult = id5Rs.getString("COMPRESULT");
				if(sCompSatus == null) sCompSatus = "";	
				if(sCompResult == null) sCompResult = "";	
				if ("3".equals(sCompSatus)) {
					sOpinionId = "010";
				} else if ("2".equals(sCompSatus) || "07".equals(sCompSatus)){
					sOpinionId = "020";
				}else if ("1".equals(sCompSatus)) {
					sOpinionId = "040";
				} 
				String sPhotoPath = id5Rs.getString("CHECKPHOTO");
				if(sPhotoPath == null) sPhotoPath = "";
				if ("010".equals(sOpinionId) && (sPhotoPath==null || sPhotoPath.trim().length()<=0)) {
					sOpinionId = "030";
				}
			} else if (("ID5办公电话检查".equals(sCheckPhaseName) || "ID5办公电话核查".equals(sCheckPhaseName)) && bUserId5) {
				
				status2 = id5Rs.getString("STATUS2");
				if(status2 == null) status2 = "";	
				if ("1".equals(status2)) {
					sOpinionId = "030";
				} else if ("0".equals(status2)) {
					sworkCorp = CommonUtils.replaceIllegalChar(id5Rs.getString("CORPNAME"));
					sworkAddName = CommonUtils.replaceIllegalChar(id5Rs.getString("AREACODE")+id5Rs.getString("CORPADDRESS"));
					System.out.println("Corpname: " + sworkCorp + ", WorkAddName: " + sworkAddName);
				}
			} else if (("ID5家庭电话核查".equals(sCheckPhaseName) || "ID5家庭电话检查".equals(sCheckPhaseName)) && bFamilyTel && bUserId5) {
				status2 = id5Rs.getString("STATUS2");
				if(status2 == null) status2 = "";	
				if ("1".equals(status2)) {
					sOpinionId = "040";
				} else if ("0".equals(status2)) {
					//String sQueryType = id5Rs.getString("QUERYTYPE");
					/* if ("0001".equals(sQueryType)) {
						sphoneName = id5Rs.getString("CORPNAME");
						snewAdd = id5Rs.getString("AREACODE")+id5Rs.getString("CORPADDRESS");
					}  else { */
					sphoneName = CommonUtils.replaceIllegalChar(id5Rs.getString("CORPNAME"));
					snewAdd = CommonUtils.replaceIllegalChar(id5Rs.getString("AREACODE")+id5Rs.getString("CORPADDRESS"));
					//}
					
				}
			}
		}
		
		// 关闭结果集
		if (id5Rs != null) id5Rs.getStatement().close();
		}
	} catch (Exception e) {
		Sqlca.rollback();
		e.printStackTrace();
	}
	/*  ID5 AREA  add by tbzeng 2014/07/31 END   PART1*/
	
	/* 验证dono编号 */
	sSql = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
	sSerialNo = Sqlca.getString(new SqlObject(sSql)	.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo));
	sSql = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo).setParameter("SerialNo", sSerialNo));
	str = Sqlca.getString("select PHASEDESCRIBE from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"' and PHASEDESCRIBE is not null  ");
	if( ! StringX.isEmpty(str)){
		String[] strs = StringX.parseArray(str);
		for(String s: strs){
			if(s == null) s = "";	
			String tempStr = s.replace(" ", "");
			if(tempStr == null) tempStr = "";	
			if(tempStr.substring(0, 4).equalsIgnoreCase("DONO")){
				sDoNo = tempStr.substring(5);
			}
		}
	}
	System.out.println("ID5 Debug Check====== UserID: "+CurUser.getUserID()+",Dono: "+sDoNo + ", Serialno: " + sSerialNo + ", PhaseNo: " + sPhaseNo + ", FlowNo: " + sFlowNo + ", ObjectNo: " + sObjectNo);
	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDoNo,Sqlca);
	
	// 专家审核隐藏用户字段
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) {
		doTemp.setVisible("InputUserName,InputTime,InputOrgName", false);
	}
	
	//PBOC检查取消意见提示
	boolean bFlow = true;
	String sPhasename = Sqlca.getString(new SqlObject("select PhaseName from FLow_Model where FlowNo = :Flowno and PhaseNo =:PhaseNo")
					.setParameter("Flowno", sFlowNo).setParameter("PhaseNo", sPhaseNo));
	if(sPhasename == null) sPhasename = "";	
	if(sPhasename.startsWith("PBOC")){
		bFlow =false;
	}
	
	// 修改人工信息审核阶段模板 add by tbzeng 2014/08/04 修改人工审核选择项
	/* if ("NCIIC信息人工检查".equals(sCheckPhaseName) || "NCIIC信息人工核查".equals(sCheckPhaseName)) {
		doTemp.setVRadioCode("PhaseOpinion", "NCIICMunallChick2");
	} */
	
	/*  ID5 AREA  add by tbzeng 2014/07/31 START PART2*/
	if(sRet == null) sRet = "";	
	if ("NCIIC信息自动检查".equals(sCheckPhaseName)) {
		doTemp.setVisible("ID5", true);
		if(!"timeOut".equals(sRet)){
		doTemp.setReadOnly("PhaseOpinion", true);
		}
		if (!"error".equals(sRet)) {
			doTemp.setVisible("CompResult", true);
		}
		//doTemp.setUpdateable("ID5", true);
	} else if (("ID5办公电话检查".equals(sCheckPhaseName) || "ID5办公电话核查".equals(sCheckPhaseName)) && bUserId5) {
		doTemp.setVisible("ID5", true);
		if (!"error".equals(sRet)) {
			doTemp.setVisible("IndName,HomeAddr", true);
		}
	}else if (("ID5家庭电话检查".equals(sCheckPhaseName) || "ID5家庭电话核查".equals(sCheckPhaseName)) && bUserId5) {
		if (!"error".equals(sRet)) {
			doTemp.setVisible("ID5,IndName,HomeAddr", true);
		}
	}
	// 如果未输入家庭电话
	if ((!bFamilyTel && ("ID5家庭电话检查".equals(sCheckPhaseName) || "ID5家庭电话核查".equals(sCheckPhaseName))) && bUserId5) {
		doTemp.setVisible("IndName,HomeAddr", false);
	}
	
	/*  ID5 AREA  add by tbzeng 2014/07/31 END   PART2*/
	
	
	//家庭成员外呼核查   意见选项
	/* if ("0080".equals(sPhaseNo) && "WF_HARD".equals(sFlowNo) && "HomePhoneInfoOpinionInfo".equalsIgnoreCase(sDoNo)) {
		doTemp.setVRadioCode("PhaseOpinion", "FamilyMemberPhoneInfoCheck");
	} */
	
	//生成ASDataWindow对象		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform形式
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"false","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
			//edit by xswang 20150505 CCS-637 PRM-293 审核过程中审核要点功能维护
			{"false","","Button","审核要点","查看审核要点","viewApprove()",sResourcesPath},
			// end by xswang 20150505
			{"true","","Button","申请详情","查看详情","viewTab()",sResourcesPath},
			{"true","","Button","退回前一步","退回任务","backStep()",sResourcesPath},
			{"true","","Button","进一步验证","提交任务","doSubmit()",sResourcesPath},
			{"true","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
			{"true","","Button","电话仓库","查看电话仓库","getPhoneCode()",sResourcesPath},
			{"true","","Button","播放录音","播放录音","playTape()",sResourcesPath},
			{"true","","Button","查看照片","查看照片","viewImage()",sResourcesPath},
			{"true","","Button","取消申请","取消申请","cancelApply()",sResourcesPath},
			{"false","","Button","拨打电话","拨打电话","btnMakeCall_Click()",sResourcesPath},
			{"true","","Button","影像操作","影像操作","imageManage()",sResourcesPath},
			{"true","","Button","查看申请表","查看申请表","creatApplyTable()",sResourcesPath},
	       	{"true","","Button","电子合同","电子合同","createPDF()",sResourcesPath},
	       	{"true","","Button","随心还电子合同","随心还电子合同","createSxhPDF()",sResourcesPath},
		    {"true","","Button","签名照片","签名照片","createPhoto()",sResourcesPath},
		    {"true","","Button","签名录音","签名录音","createAudio()",sResourcesPath},
			{"true","","Button","查看协审信息","查看协审信息","viewAssist()",sResourcesPath}
	};
	
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) sButtons[9][0] = "true";
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<embed name="3_devUnknown" id="3_devUnknown" src="E:\123.wma" type="audio/x-wav" hidden="true" autostart="false" loop="false"/>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	 /*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = "<%=sObjectNo%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
      //验证合同产品是否已经在影响配置中配置
		var sBusinessType = RunMethod("公用方法", "GetColValue", "Business_Contract,BusinessType,SerialNo='"+sObjectNo+"'");
     	var sAmount = RunMethod("公用方法","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
		if(sAmount == 0){
			alert("请先在商品影像配置中配置该产品对应的影像文件！");
			return false;
		}
     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" ); 
	   /*var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	   AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );*/
     
    }
	
	function saveRecord(sPostEvents){
		var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0) {
			/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
			var sOpinionNo = getSerialNo("FLOW_OPINION", "OpinionNo", "");*/
			var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
			/** --end --*/
			setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		}
		
		as_save("myiframe0",sPostEvents);
	}
	
	function chick(){
		var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
		if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			alert("未选择意见！");
			return true;
		}
	}
	
	//
	function svresult(){
		var sResult = getItemValue(0,getRow(),"SVRESULT");

		if(sResult=="01"){//拒绝  
			setItemRequired(0,0,"PhaseOpinion",true);
		}else if(sResult=="02"){//通过
			setItemRequired(0,0,"PhaseOpinion",false);
		}else{
			setItemRequired(0,0,"PhaseOpinion",false);
		}
		
		
	}
	
	/*~[Describe=删除已删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
	    var sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("您还没有签署意见，不能做删除意见操作！");
	 	}
	 	else if(confirm("你确实要删除意见吗？"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("意见删除成功!");
	  		}
	   		else
	   		{
	    		alert("意见删除失败！");
	   		}
			reloadSelf();
		}
	} 
	
    /*~[Describe=提交业务;InputParam=无;OutPutParam=无;]~*/
    function doSubmit()
	{
		//获得申请类型、申请流水号、阶段编号
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var OrgID = "<%=CurUser.getOrgID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sDoNo = "<%=sDoNo%>";
		var needPage = <%=needPage%>;
		//获得任务流水号
		var sSerialNo = "<%=sSerialNo%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		
		//  获取id5电话
		/* var sId5 = getItemValue(0, 0, "PhaseOpinion3");
		var sIdOpinion = getItemValue(0, 0, "PhaseOpinion");
		alert("|"+sId5+"|" + typeof sId5 + "|"+sIdOpinion+"|"+typeof sIdOpinion + "|");
		return; */
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		var sCancelApply = RunMethod("WorkFlowEngine","QueryCancelApply",sObjectNo);
		
		var sCreditReport=getItemValue(0,getRow(),"CreditReport");
		var sCreditNum=getItemValue(0,getRow(),"CreditNum");
		var sCreditLimit=getItemValue(0,getRow(),"CreditLimit");
		var sUseLimit=getItemValue(0,getRow(),"UseLimit");
		var sCreditStatus=getItemValue(0,getRow(),"CreditStatus");
		var sIsNormalCredit=getItemValue(0,getRow(),"IsNormalCredit");
		var sOverDueMonthCredit=getItemValue(0,getRow(),"OverDueMonthCredit");
		var sPutoutAccount=getItemValue(0,getRow(),"PutoutAccount");
		var sPutoutSum=getItemValue(0,getRow(),"PutoutSum");
		var sIsNormalPutout=getItemValue(0,getRow(),"IsNormalPutout");
		var sOverDueMonthPutout=getItemValue(0,getRow(),"OverDueMonthPutout");
		var sSuccessDate=getItemValue(0,getRow(),"SuccessDate");
		var sQueryTime1=getItemValue(0,getRow(),"QueryTime1");
		var sQueryTime2=getItemValue(0,getRow(),"QueryTime2");
		var sPhoneNumber=getItemValue(0,getRow(),"PhoneNumber");
		
		// edit by xswang 20150615 CCS-900 审核中的任务不能被暂停
		/* // add by xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
		// 从合同表中取当前合同的“cancelstatus”标识
		var sReturn1 = RunMethod("BusinessManage", "SelectContractCancelStatus",sObjectNo);
		if("1" == sReturn1){
			alert("该合同已被暂停，不能提交");
			return;
		}
		// end by xswang 20150427 */
		// end by xswang 20150615
		
		if(sCreditReport=="1"){
			if (typeof(sCreditNum)=="undefined" || sCreditNum.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sCreditLimit)=="undefined" || sCreditLimit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sUseLimit)=="undefined" || sUseLimit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sCreditStatus)=="undefined" || sCreditStatus.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sIsNormalCredit)=="undefined" || sIsNormalCredit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sOverDueMonthCredit)=="undefined" || sOverDueMonthCredit.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sPutoutAccount)=="undefined" || sPutoutAccount.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sPutoutSum)=="undefined" || sPutoutSum.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sIsNormalPutout)=="undefined" || sIsNormalPutout.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sOverDueMonthPutout)=="undefined" || sOverDueMonthPutout.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sSuccessDate)=="undefined" || sSuccessDate.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sQueryTime1)=="undefined" || sQueryTime1.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sQueryTime2)=="undefined" || sQueryTime2.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
			if (typeof(sPhoneNumber)=="undefined" || sPhoneNumber.length==0){
				alert("信息不完整,请输入"); 
				return;
			}
		}
		
		
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			if(sCancelApply == "100"){
				alert("该申请已被取消");
				window.close();
				return;
			}else{
				alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
				reloadSelf();
				return;
			}
		}
		if(sCancelApply == "100"){
			alert("该申请已被取消");
			window.close();
			return;
		}
		
		if(<%=bFlow%>){
			var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
			if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
				//add by huanghui PRM-670手机联系方式支付宝验证。只有这个模板做这样的控制，不弹出此框。
				if(sDoNo!="MobileValidationOpinionInfo" ){
					alert("未填写意见！"); 	//updata byang CCS-1220 "未选择意见"   改成  "未填写意见"
					return true;
				}
			} else {
				
				if (sPhaseOpinion=="060" && "ID5PhoneOpinionInfo"==="<%=sDoNo%>") {
					var sId5 = getItemValue(0, 0, "PhaseOpinion3");
					if (! (sId5 && CheckPhoneCode(sId5))) {
						//alert(sId5 + "|" +sId5.replace(/(\s+|[A-Za-z])/g, ""));
						alert("请输入正确的ID5电话号码");
						return;
					} 
				}
			}
		}
		
		if(vI_all("myiframe0")){//add CCS-550 合同有效性检查 审批有问 (当只选择第一个审批意见，没有全部审核完成后，流程可以进入到下一个节点) phe 20150312
		saveRecord();
		
		//PBOC阶段插入意见表
		if(!<%=bFlow%>){
			var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
			sReturn= RunMethod("BusinessManage","InsertOpinion","PBOC已检查,<%=sSerialNo%>,"+sOpinionNo+",<%=sObjectNo%>,<%=sObjectType%>,"+sUserID+","+OrgID);
		}
		
		//弹出审批提交选择窗口	     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		var sToday = "<%=sToday%>";
		if(needPage){
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}else{
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoFlagCommint","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}
		
		// 更新合同状态
		RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo=" + sObjectNo + ",phaseNOFlag=1");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			
			//alert(getHtmlMessage('18'));//提交成功！	// comment by tbzeng 2014/05/03 去掉提交成功提示框
			//top.close();
			/* var sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			var sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			
			var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
			AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,OpenStyle); */
			var isSameUser = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","sameUser","objectNo="+sObjectNo+",objectType="+sObjectType+",userID=<%=CurUser.getUserID()%>");
			//alert(isSameUser);
			
			if(isSameUser=="Yes"){
				window.returnValue = "SameUser";
				//var sCompURL = "";
				//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoNew.jsp";
				//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
				parent.parent.reloadSelf();
			}else{
				window.returnValue = "NotSameUser";
				parent.parent.parent.reloadSelf();
			}
			//window.close();

			//刷新件数及页面
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}else if(sPhaseInfo=="noexits"){

			//alert(getHtmlMessage('18'));//提交成功！	// comment by tbzeng 2014/05/03 去掉提交成功提示框
			//top.close();
			/* var sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			var sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			
			var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
			AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,OpenStyle); */
			var isSameUser = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","sameUser","objectNo="+sObjectNo+",objectType="+sObjectType+",userID=<%=CurUser.getUserID()%>");
			//alert(isSameUser);
			
			if(isSameUser=="Yes"){
				window.returnValue = "SameUser";
				//var sCompURL = "";
				//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoNew.jsp";
				//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
				parent.parent.parent.reloadSelf();
			}
		}else if(sPhaseInfo=="exits"){
			//alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			parent.parent.parent.reloadSelf();
			return; 
	    }else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				// add by xswang 2015/05/25 CCS-808 系统全流程电子化改造：文件质量检查
				//更新文件质量检查状态为未检查，审核通过时间为系统时间
				/* RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,CheckDocStatus,1,SerialNo = '"+sObjectNo+"'");
				RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,PassTime,"+sToday+",SerialNo = '"+sObjectNo+"'"); */
				//RunMethod("PublicMethod","UpdateColValue","String@CheckDocStatus@1@String@PassTime@" + sToday + ",business_contract,String@SerialNo@" + sObjectNo);
				//RunMethod("PublicMethod","UpdateColValue","String@CheckDocStatus@1@String@PassTime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
				// end by xswang 2015/05/25
				alert(getHtmlMessage('18'));//提交成功！
				//刷新件数及页面
				
				}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
		}//end CCS-550 合同有效性检查 审批有问 (当只选择第一个审批意见，没有全部审核完成后，流程可以进入到下一个节点) phe 20150312
	}
    
    /*~[Describe=电话录入;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		
	 }
    
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions(){
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=退回前一步;InputParam=无;OutPutParam=无;]~*/
	function backStep(){
		//获取任务流水号
		var sSerialNo = "<%=sSerialNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		//检查是否能退回
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","cancelCheck","serialNo="+sSerialNo+",userID="+sUserID);
		if(sReturn != "Success"){
			alert("上一步承办人不是当前用户，不允许退回");
			return;
		}else{
			sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","goBack","serialNo="+sSerialNo+",userID="+sUserID);
			if(sReturn =='Success'){
				window.returnValue = "SameUser";
				window.close();
				parent.parent.reloadSelf();
			}else{
				window.returnValue = "NotSameUser";
			}
			return;
		}
		//检查是否签署意见
		//var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//退回任务操作   	
			var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//如果成功，则刷新页面
			if(sRetValue == "Commit"){
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else{
			alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
			return;
		}
	}
	
	/*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sCustomerID = "<%=sCustomerID%>";

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//OpenComp("SignTaskOpinionList","/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
		AsControl.OpenComp("/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank03","dialogWidth=950px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
	}
	
	/*~[Describe=播放录音;InputParam=无;OutPutParam=无;]~*/
	function playTape(){
		var sRet = setObjectValue("SelectWMAUrl", "ContractNo,<%=sObjectNo%>", "", 0, 0, "");
		if (sRet==='_CLEAR_' || typeof(sRet)=='undefined' || sRet==='undefined') {
			return;
		}
		var sWmaUrl = sRet.split("@")[1];
		AsControl.PopComp("/Common/WorkFlow/playTape.jsp","WmaURL="+sWmaUrl,"");
	}
	
	/*~[Describe=查看图片;InputParam=无;OutPutParam=无;]~*/
	function viewImage(){
		AsControl.PopComp("/Common/WorkFlow/SignTaskImage.jsp","ObjectNo=<%=sObjectNo%>","");
	}
	
	/*~[Describe=取消申请;InputParam=无;OutPutParam=无;]~*/
	function cancelApply(){
		var OpenStyle = "dialogWidth=600px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		//弹出选择取消意见界面
		var sReturn = popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&PhaseNo=<%=sPhaseNo%>&FlowNo=<%=sFlowNo%>&TaskNo=<%=sSerialNo%>&Type=1",OpenStyle);
		window.returnValue = sReturn;
		//edit by xswang 20150424 CCS-724 弹出取消选项框后，再点击关闭，停留在当前页面
		if(!(typeof(sReturn)=='undefined')){
			parent.parent.parent.reloadSelf();
		}
		//end by xswang 20150424
		//window.close();
	}
	
	//add by clhuang 2015/07/22 CCS-923 审核端选择欺诈，失败时，下面的欺诈原因为必填项
	//家庭电话外呼核查/家庭成员外呼核查（涉嫌欺诈）
	function CheckPhaseOpinion(){
		 	hideItem(0,0,"PhaseOpinion1");
		   var sPhaseOpinion=getItemValue(0,0,"PhaseOpinion");
		   if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			   return;
		   }
		   if(sPhaseOpinion=="050"){
			   showItem(0,0,"PhaseOpinion1");
			   setItemRequired(0, 0, "PhaseOpinion1", true);
		   }else{
			   hideItem(0,0,"PhaseOpinion1");
			   setItemValue(0,0,"PhaseOpinion1","");
			   setItemRequired(0, 0, "PhaseOpinion1", false);		   
		   }
		}
	//办公电话外呼核查（信息验证失败）
	function CheckOfficeOpinion(){
			hideItem(0,0,"PhaseOpinion1");
			hideItem(0,0,"PhaseOpinion2");
		   var sPhaseOpinion=getItemValue(0,0,"PhaseOpinion");
		   if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			   return;
		   }
		   if(sPhaseOpinion=="040"){
			   showItem(0,0,"PhaseOpinion1");
			   setItemRequired(0, 0, "PhaseOpinion1", true);
		   }else if(sPhaseOpinion=="050"){
			   showItem(0,0,"PhaseOpinion2");
			   setItemRequired(0, 0, "PhaseOpinion2", true);
		   }else{
			   setItemValue(0,0,"PhaseOpinion1","");
			   setItemRequired(0, 0, "PhaseOpinion1", false);
			   setItemValue(0,0,"PhaseOpinion2","");
			   setItemRequired(0, 0, "PhaseOpinion2", false);
		   }
	}
	//个人手机外呼核查（1、信息验证失败2、涉嫌欺诈） 学生手机号码外呼核查（1、信息验证失败 2、涉嫌欺诈）
	function CheckCellTelOpinion(){
		hideItem(0,0,"PhaseOpinion1");
		hideItem(0,0,"PhaseOpinion2");
	   var sPhaseOpinion=getItemValue(0,0,"PhaseOpinion");//CellTelCheck
	   if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
		   return;
	   }
	   if(sPhaseOpinion=="030"){//信息验证失败
		   showItem(0,0,"PhaseOpinion1");//信息验证失败
		   setItemRequired(0, 0, "PhaseOpinion1", true);
	   }else if(sPhaseOpinion=="040"){//欺诈嫌疑
		   showItem(0,0,"PhaseOpinion2");//欺诈嫌疑
		   setItemRequired(0, 0, "PhaseOpinion2", true);
	   }else{
		   setItemValue(0,0,"PhaseOpinion1","");
		   setItemRequired(0, 0, "PhaseOpinion1", false);
		   setItemValue(0,0,"PhaseOpinion2","");
		   setItemRequired(0, 0, "PhaseOpinion2", false);
	   }
	}
	//主观判断（选择RES05的情况）
	function CheckSubjectivityOpinion(){
			var sDoNo = "<%=sDoNo%>";
			//只有这个模板做这样的控制
			if(sDoNo!="SubjectivityOpinionInfo"){
				return;
			}
			hideItem(0,0,"PHASEOPINION2");
		   var sPhaseOpinion=getItemValue(0,0,"PhaseOpinion");
		   if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			   return;
		   }
		   if(sPhaseOpinion=="050"){
			   showItem(0,0,"PHASEOPINION2");
			   setItemRequired(0, 0, "PHASEOPINION2", true);
		   }else{
			   hideItem(0,0,"PHASEOPINION2");
			   setItemValue(0,0,"PHASEOPINION2","");
			   setItemRequired(0, 0, "PHASEOPINION2", false);
		   }
	}
	//其他联系人信息审核(涉嫌欺诈)
	function CheckOtherManageOpinion(){
			hideItem(0,0,"PhaseOpinion1");
		   var sPhaseOpinion=getItemValue(0,0,"PhaseOpinion");
		   if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			   return;
		   }
		   if(sPhaseOpinion=="040"){
			   showItem(0,0,"PhaseOpinion1");
			   setItemRequired(0, 0, "PhaseOpinion1", true);
		   }else{
			   hideItem(0,0,"PhaseOpinion1");
			   setItemValue(0,0,"PhaseOpinion1","");
			   setItemRequired(0, 0, "PhaseOpinion1", false);
		   }
	}
	//end by clhuang
	
	

	
	//人行信用报告为是时，为必输
	function getCreditReport(){
		 var sCreditReport=getItemValue(0,getRow(),"CreditReport");
		 if(sCreditReport=="1"){
			 setItemRequired(0,0,"CreditReport",true);
			 setItemRequired(0,0,"CreditNum",true);
			 setItemRequired(0,0,"CreditLimit",true);
			 setItemRequired(0,0,"UseLimit",true);
			 setItemRequired(0,0,"CreditStatus",true);
			 setItemRequired(0,0,"IsNormalCredit",true);
			 setItemRequired(0,0,"OverDueMonthCredit",true);
			 setItemRequired(0,0,"PutoutAccount",true);
			 setItemRequired(0,0,"PutoutSum",true);
			 setItemRequired(0,0,"IsNormalPutout",true);
			 setItemRequired(0,0,"OverDueMonthPutout",true);
			 setItemRequired(0,0,"SuccessDate",true);
			 setItemRequired(0,0,"QueryTime1",true);
			 setItemRequired(0,0,"QueryTime2",true);
			 setItemRequired(0,0,"PhoneNumber",true);
		 }else{
			 setItemRequired(0,0,"CreditReport",false);
			 setItemRequired(0,0,"CreditNum",false);
			 setItemRequired(0,0,"CreditLimit",false);
			 setItemRequired(0,0,"UseLimit",false);
			 setItemRequired(0,0,"CreditStatus",false);
			 setItemRequired(0,0,"IsNormalCredit",false);
			 setItemRequired(0,0,"OverDueMonthCredit",false);
			 setItemRequired(0,0,"PutoutAccount",false);
			 setItemRequired(0,0,"PutoutSum",false);
			 setItemRequired(0,0,"IsNormalPutout",false);
			 setItemRequired(0,0,"OverDueMonthPutout",false);
			 setItemRequired(0,0,"SuccessDate",false);
			 setItemRequired(0,0,"QueryTime1",false);
			 setItemRequired(0,0,"QueryTime2",false);
			 setItemRequired(0,0,"PhoneNumber",false);
		 }
	}
	
	/*~[Describe=手机号码验证;InputParam=无;OutPutParam=无;]~*/
	function checkMobile(obj){ 
		
	    var sPhoneNumber = getItemValue(0,getRow(),"PhoneNumber");
	    if(typeof(sPhoneNumber) == "undefined" || sPhoneNumber.length==0){
	    	return false;
	    }
	    if(!(/^1[3|4|5|8][0-9]\d{8}$/.test(sPhoneNumber))){ 
	        alert("手机号码输入有误，请重新输入"); 
	        //obj.focus();
		    setItemValue(0,0,"PhoneNumber","");
	        return false; 
	    } 
	} 
	
	//信用卡数量检查
	function creditNum(){
		var sCreditNum = getItemValue(0,getRow(),"CreditNum");
		if(sCreditNum<=0 ){
			alert("信用卡数量在1~99之间");
    		 setItemValue(0,0,"CreditNum","");
    	}
    	if(sCreditNum>99 ){
			alert("信用卡数量在1~99之间");
    		 setItemValue(0,0,"CreditNum","");
    	}
	}
	
	//最近24期最大逾期月数检查
	function overDueMonthCredit(){
		var sOverDueMonthCredit = getItemValue(0,getRow(),"OverDueMonthCredit");
		if(sOverDueMonthCredit<=0 ){
			alert("最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
    	if(sOverDueMonthCredit>99 ){
			alert("最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
	}
	
	//贷款账户数检查
	function putoutAccount(){
		var sPutoutAccount = getItemValue(0,getRow(),"PutoutAccount");
		if(sPutoutAccount<=0 ){
			alert("贷款账户数在1~99之间");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
    	if(sPutoutAccount>99 ){
			alert("贷款账户数在1~99之间");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
	}
	
	//贷款最近24期最大逾期月数检查
	function overDueMonthPutout(){
		var sOverDueMonthPutout = getItemValue(0,getRow(),"OverDueMonthPutout");
		if(sOverDueMonthPutout<=0 ){
			alert("贷款最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
    	if(sOverDueMonthPutout>99 ){
			alert("贷款最近24期最大逾期月数在1~99之间");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
	}
	
	
	//最近6个月被查询次数检查
	function queryTime1(){
		var sQueryTime1 = getItemValue(0,getRow(),"QueryTime1");
		if(sQueryTime1<=0 ){
			alert("最近6个月被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime1","");
    	}
    	if(sQueryTime1>99 ){
			alert("最近6个月被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime1","");
    	}
	}
	
	//最近6个月被查询次数检查
	function queryTime2(){
		var sQueryTime2 = getItemValue(0,getRow(),"QueryTime2");
		if(sQueryTime2<=0 ){
			alert("最近30天被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime2","");
    	}
    	if(sQueryTime2>99 ){
			alert("最近30天被查询次数在1~99之间");
    		 setItemValue(0,0,"QueryTime2","");
    	}
	}
	
	//总授信额度检查
	function creditLimit(){
		var sCreditLimit = getItemValue(0,getRow(),"CreditLimit");
		if(sCreditLimit<1){
			alert("总授信额度在1~1000w之间");
    		 setItemValue(0,0,"CreditLimit","");
    	}
    	if(sCreditLimit>10000000 ){
			alert("总授信额度在1~1000w之间");
    		 setItemValue(0,0,"CreditLimit","");
    	}
	}
	
	
	//已用额度检查
	function useLimit(){
		var sUseLimit = getItemValue(0,getRow(),"UseLimit");
		if(sUseLimit<1 ){
			alert("已用额度在1~1000w之间");
    		 setItemValue(0,0,"UseLimit","");
    	}
    	if(sUseLimit>10000000 ){
			alert("已用额度在1~1000w之间");
    		 setItemValue(0,0,"UseLimit","");
    	}
	}
	
	
	//贷款总额检查
	function putoutSum(){
		var sPutoutSum = getItemValue(0,getRow(),"PutoutSum");
		if(sPutoutSum<1 ){
			alert("贷款总额在1~99999999之间");
    		 setItemValue(0,0,"PutoutSum","");
    	}
    	if(sPutoutSum>99999999 ){
			alert("贷款总额在1~99999999之间");
    		 setItemValue(0,0,"PutoutSum","");
    	}
	}
	
	
	//拨打软电话
	function btnMakeCall_Click()
	{
		var sRetVal = PopPage("/Common/WorkFlow/PhoneCallInputInfo.jsp", "", "dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sRetVal!="_none_"){
			var txt_Pfhc;
			Pfhc="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall&CustomerNumber=&ContractID=&RecordName=";
			Pfhc+= sRetVal+"&CallerParty=";
	        window.location= Pfhc;
		}
		
	}

	function creatApplyTable(){
		var sObjectNo = "<%=sObjectNo%>";
		//检查是否APP端提交数据 SureType
		var sAppFlag = RunMethod("公用方法", "GetColValue", "Business_Contract,SureType,SerialNo='"+sObjectNo+"'");
		var url = "";
		if(sAppFlag=="APP"){//APP端提交数据
			//AsControl.PopComp("Common/WorkFlow/PutOutApply/EDocMangeForPad.jsp","","");
			url="<%=sAPPUrl4pdf%>"+"<%=sObjectNo%>";
			window.open(url);
			return;
		}else if(sAppFlag=="JQM"){
			url="<%=sJQMUrl4pdf%>"+"<%=sObjectNo%>";
			window.open(url);
			return;
		}else if(sAppFlag=="FC"){
			url="<%=sFCUrl4pdf%>"+"<%=sObjectNo%>";
			window.open(url);
			return;
		}else{//PC端提交数据
			printTable("ApplySettle");
		} 
		}
		/*~[Describe=查看协审信息;InputParam=无;OutPutParam=无;]~*/
		function viewAssist(){
			printTable("AssistSettle");
		}
		//标准的打印逻辑
		function printTable(type){
			
			var sObjectNo = "<%=sObjectNo%>";
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			//CCS-316 需要根据合同状态控制快速查询里的按钮     add by Roger 2015/03/09
			var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
			    if(sContractStatus == "060" || sContractStatus == "070"){   //新发生、审核中合同除了admin，其他人都不能打印合同
			    	//给管理员角色这个特权 
			    	if(!<%=CurUser.hasRole(new String[]{"000","099","1000"})%>){
			    		alert("只有管理员才能调阅该笔合同");
			    		return;
			    	}
		    }
			var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
			if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("请联系系统管理员检查合同模板配置和合同信息!");
				return;
			}
			var sDocID = 	returnValue.split("@")[0];
			var sUrl = returnValue.split("@")[1];
			var sObjectType = type;
			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}else{
				//检查出帐通知单是否已经生成
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if (sReturn == "false"){ //未生成出帐通知单
					//生成出帐通知单	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
					//记录生成动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
				}else{
					//记录查看动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
				}
				//获得加密后的出帐流水号
				var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
				//通过　serverlet 打开页面
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
				//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
				OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	//   ============================== end  打印格式化报告 ============================================================

	function createPDF(){
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == null || ssuretype.length == 0 || (ssuretype != "APP" && ssuretype != "JQM" && ssuretype != "FC" )) {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    var url;
	    if(ssuretype == "APP"){
	    	url="<%=sAPPUrl4pdf%>"+"<%=sObjectNo%>";
	    }else if(ssuretype == "JQM"){
	    	url="<%=sJQMUrl4pdf%>"+"<%=sObjectNo%>";
	    }else if(ssuretype=="FC"){
			url="<%=sFCUrl4pdf%>"+"<%=sObjectNo%>";
		}
	    window.open(url,"_blank",CurOpenStyle);
	}
	
	function createSxhPDF(){
		var sObjectNo = "<%=sObjectNo%>";
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == 'PC') {
	        alert("该合同非电子合同!");
	        return;
	    }
	    var bugpaypkgind = RunMethod("公用方法", "GetColValue", "business_contract,bugpaypkgind,serialno='"+sObjectNo+"'");
		if(typeof(bugpaypkgind)=="undefined" || bugpaypkgind.length==0 || bugpaypkgind == "0"){
	        alert("该合同没有购买随心还服务包!");
	        return;
		}
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
	    	window.open("<%=sAPPUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	}
	
	function createPhoto(){
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == null || ssuretype.length == 0 || ssuretype != "APP") {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    var url="<%=sAPPUrl4photo%>"+"<%=sObjectNo%>";
	    window.open(url,"_blank",CurOpenStyle);
	}
	  
	function createAudio(){
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == null || ssuretype.length == 0 || ssuretype != "APP") {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    var url="<%=sAPPUrl4record%>"+"<%=sObjectNo%>";
	    window.open(url,"_blank",CurOpenStyle);
	}
	/*~[Describe=查询审核要点提示;InputParam=无;OutPutParam=无;]~*/
	function viewApprove(){
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		popComp("AuditPointsModelFrame","/SystemManage/CarManage/AuditPointsModelFrame.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&RightType=ReadOnly","");
	}
	
	/*~[Describe=意见选择触发事件;InputParam=无;OutPutParam=无;]~*/
	function selectID5Opinion() {
		
		/* var sSelOp = getItemValue(0, 0, "PhaseOpinion");
		if (sSelOp!=null && sSelOp && sSelOp=="060") {
			setItemRequired(0, 0, "PhaseOpinion3", true);
			showItem(0, 0, "PhaseOpinion3");
		} else {
			setItemRequired(0, 0, "PhaseOpinion3", false);
			hideItem(0, 0, "PhaseOpinion3");
		} */
	}
	
	function trimAlpha(obj) {
		
		var sId5 = getItemValue(0, 0, "PhaseOpinion3");
		setItemValue(0, 0, "PhaseOpinion3", sId5.replace(/(\s+|[a-zA-z])/g,""));
	}

	//add by daihuafeng 20150709 CRA-285  下拉菜单(选择信息验证失败及欺诈嫌疑，下拉菜单非必选项) ----begin 
	//家庭电话核查
	function ChangeTwoOpinion(){
		var sDoNo = "<%=sDoNo%>";
		//只有这两个模板做这样的控制
		if(sDoNo!="OfficePhoneOpinionInfo" && sDoNo!="OfficePhoneOpinionInfo2"){
			return;
		}
		var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
		if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			//空值(第一次进来)时什么都不做
		}else if(sPhaseOpinion=="040"){//信息验证失败
			setItemDisabled(0,getRow(),"PhaseOpinion1",false);
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
		}else if(sPhaseOpinion=="050"){//涉嫌欺诈
			setItemDisabled(0,getRow(),"PhaseOpinion2",false);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}else{//有值且不是信息验证失败、不是涉嫌欺诈时
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}
		
		var phaseName = "<%=sCheckPhaseName%>";
		if("办公电话外呼核查"==phaseName){
			CheckOfficeOpinion();
		}
	}
	//手机核查
	function ChangeTwoOpinion2(){
		var sDoNo = "<%=sDoNo%>";
		//只有这两个模板做这样的控制
		if(sDoNo!="CellTelOpinionInfo" && sDoNo!="CellTelOpinionInfo2"){
			return;
		}
		
		var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
		if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			//空值(第一次进来)时什么都不做
		}else if(sPhaseOpinion=="030"){//信息验证失败
			setItemDisabled(0,getRow(),"PhaseOpinion1",false);
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
		}else if(sPhaseOpinion=="040"){//涉嫌欺诈
			setItemDisabled(0,getRow(),"PhaseOpinion2",false);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}else{//有值且不是信息验证失败、不是涉嫌欺诈时
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}
		
		var phaseName = "<%=sCheckPhaseName%>";
		if("手机号码外呼核查"==phaseName || "学生手机号码外呼核查"==phaseName){
			CheckCellTelOpinion();
		}
	}
	//----end
	
	//add by huanghui 2015/12/21 PRM-670 手机联系方式支付宝验证
	//手机联系方式支付宝验证
	function CheckMobileValidationInfo(){
	   var sPhaseOpinion=getItemValue(0,0,"PhaseOpinion");
	   var sPhaseOpinion1=getItemValue(0,0,"PhaseOpinion1");
	   var sPhaseOpinion2=getItemValue(0,0,"PhaseOpinion2");
	   if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0 || typeof(sPhaseOpinion1)=="undefined" || sPhaseOpinion1.length==0 || typeof(sPhaseOpinion2)=="undefined" || sPhaseOpinion2.length==0){
		   return;
	   }
	   if(sPhaseOpinion=="040" || sPhaseOpinion1=="040" || sPhaseOpinion2=="040"){
		   setItemRequired(0, 0, "Opinion_Remark", true);
	   }else{
		   setItemRequired(0, 0, "Opinion_Remark", false);		   
	   }
	}
	
	function initRow(){
		var sUseId5 = "<%=bUserId5%>";
		var bUserId5 = sUseId5==="true" ? 1: 0;
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
		
		if (("NCIIC信息自动检查" ===  "<%=sCheckPhaseName%>")) {
			setItemValue(0, 0, "ID5", "<%=sDbTip%>");
			if ("error" !== "<%=sRet%>") {
				if("timeOut" !== "<%=sRet%>"){
				setItemValue(0, 0, "CompResult", "<%=sCompResult%>");
				setItemValue(0, 0, "PhaseOpinion", "<%=sOpinionId%>");
				}else{
					setItemValue(0, 0, "CompResult", "ID5调用超时");
					//--add 访问ID5检查超时，意见详情默认选择“访问NCIIC失败” tangyb 20150827--
					setItemValue(0, 0, "PhaseOpinion", "050");
				}
			} else {
				if("Y" == "<%=renzhengbao%>"){
					setItemValue(0, 0, "CompResult", "<%=sCompResult%>");
					setItemValue(0, 0, "PhaseOpinion", "<%=sOpinionId%>");
				}else{
					setItemValue(0, 0, "PhaseOpinion", "050");
				}
			}
		} else if  ((("ID5办公电话检查" === "<%=sCheckPhaseName%>")  || ("ID5办公电话核查" === "<%=sCheckPhaseName%>")) && bUserId5) {
			setItemValue(0, 0, "ID5", "<%=sDbTip%>");
			if ("error" != "<%=sRet%>"&&"timeOut" !== "<%=sRet%>") {
				setItemValue(0, 0, "IndName", "<%=sworkCorp%>");
				setItemValue(0, 0, "HomeAddr", '<%=sworkAddName%>');
						if("070"=="<%=sOpinionId%>"){
			          setItemReadOnly(0,0,"IndName",false);
			          setItemReadOnly(0,0,"HomeAddr",false);
			          setItemValue(0, 0, "PhaseOpinion", "070");
			        }
			} else {
				setItemReadOnly(0,0,"IndName",false);
				setItemReadOnly(0,0,"HomeAddr",false);
				setItemValue(0, 0, "PhaseOpinion", "070");
			}
		}else if (("ID5家庭电话检查" === "<%=sCheckPhaseName%>" || "ID5家庭电话核查"==="<%=sCheckPhaseName%>") && bUserId5) {
			setItemValue(0, 0, "ID5", "<%=sDbTip%>");
			if ("error" != "<%=sRet%>"&&"timeOut" !== "<%=sRet%>") {
				setItemValue(0, 0, "IndName", "<%=sphoneName%>");
				setItemValue(0, 0, "HomeAddr", '<%=snewAdd%>');
				if("070"=="<%=sOpinionId%>"){
					setItemReadOnly(0,0,"IndName",false);
					setItemReadOnly(0,0,"HomeAddr",false);
					setItemValue(0, 0, "PhaseOpinion", "030");
				}
			} else {
				setItemReadOnly(0,0,"IndName",false);
				setItemReadOnly(0,0,"HomeAddr",false);
				setItemValue(0, 0, "PhaseOpinion", "030");
			}
			
		}
		if ("error" === "<%=bBFDbAccess%>") {
			// 佰仟数据库访问失败
		}
		if ("error" === "<%=sRet%>") {
			// ID5访问失败
			
		}
		
		var phaseName = "<%=sCheckPhaseName%>";
		if("支付宝手机联系方式验证"==phaseName){
			CheckMobileValidationInfo();
		}
		
		CheckSubjectivityOpinion();
		if("其他联系人信息审核"==phaseName){
			CheckOtherManageOpinion();
		}else if("家庭电话外呼核查"==phaseName || "家庭成员外呼核查"==phaseName){
			CheckPhaseOpinion();
		}

		//add by daihuafeng 20150709 --begin
		ChangeTwoOpinion();
		ChangeTwoOpinion2();
		//--end
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		bCheckBeforeUnload = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>