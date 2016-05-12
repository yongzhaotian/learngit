<%@page import="com.amarsoft.app.billions.CommonUtils"%>
<%@page import="com.amarsoft.webclient.RunID5"%>
<%@page import="com.amarsoft.webclient.RenZhengBao"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150424 CCS-724 ����ȡ��ѡ�����ٵ���رգ�ͣ���ڵ�ǰҳ��
					 xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
					 xswang 20150505 CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
					 xswang 2015/05/25 CCS-808 ϵͳȫ���̵��ӻ����죺�ļ��������
					 xswang 20150615 CCS-900 ����е������ܱ���ͣ
	 */
	%>
<%/*~END~*/%>

<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("PhaseNo"));
	String sFlowNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("FlowNo"));
	String sRet = DataConvert.toRealString(iPostChange,CurComp.getParameter("Ret"));
	if(sRet==null)sRet="";
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	
	String sToday = StringFunction.getTodayNow();
	
	//��ȡ���µ��ֶ�����
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
	
	String sLineMaxButton = "7";//���õ�ǰҳ��ÿ�����ť����Ϊ8
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
�����Ҫ����ʾ����<%="\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sCheckPoint%>
	</textarea>
	 -->
<%
	
	
	String sDoNo = "SignTaskOpinionInfo";
	boolean bUserId5 = true;
	/* �Ƿ���Ҫ����ҳ��ѡ����� */
	boolean needPage = false;
	//��ʱ�Ѹ����׶ε���ʾģ�������õ�PHASEATTRIBUTE�ֶ���(��Ӧ���������е�'�׶�����')
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
  	String renzhengbao="K";//�Ƿ��Ѿ���������֤��
	String imgpath = CurConfig.getConfigure("ImageFolder");// imgpath ����ͷ�񱣴�·��  by linhai 20150519 CCS-757
	String savepath = CurConfig.getConfigure("XmlFolder");//CCS-757 by linhai
	String sCompSatus="", sCompResult="", status2="", sworkAddName="",sworkCorp="", sindWorkAddName="",sindWorkCorp="", sphoneName="",snewAdd="", sindPhoneName="", sindNewAdd="",bBFDbAccess="success";
	boolean bFamilyTel = true;
	if (savepath == null || savepath.length()<=0) {
		savepath = sResourcesPath;
	}
		try{
	renzhengbao = Sqlca.getString(new SqlObject("select status from business_renzhengbao where 1='1'"));//��֤�����أ�Y��ʾ���ã�N��ʾ������
	}catch(Exception e) {
		
	}
	String sCheckPhaseName = Sqlca.getString(new SqlObject("SELECT PHASENAME FROM FLOW_TASK WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sSerialNo));
	if (sCheckPhaseName == null) sCheckPhaseName = "";
	sCheckPhaseName = sCheckPhaseName.trim();
	if ("NCIIC��Ϣ�Զ����".equals(sCheckPhaseName)) {
		
		try {
			reqData = Sqlca.getString(new SqlObject("SELECT CUSTOMERNAME||'@'||CERTID FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID")
								 .setParameter("CUSTOMERID", sCustomerID));
		} catch(Exception e) {
			bBFDbAccess = "error";
		}
		//"reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum
		reqHeader = "1A020201";
		if(!"timeOut".equals(sRet)){
		sRet = RunID5.runParserId5(Sqlca, sCustomerID, reqHeader, reqData, savepath, "010",imgpath); //imgpath ����ͷ�񱣴�·��  by linhai 20150519 CCS-757
		}
	} else if (("ID5�칫�绰���".equals(sCheckPhaseName) || "ID5�칫�绰�˲�".equals(sCheckPhaseName)) && bUserId5) {
		
		reqData = Sqlca.getString(new SqlObject("SELECT WORKTEL FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID")
								.setParameter("CUSTOMERID", sCustomerID));
		if(reqData == null) reqData = "";	
		reqData = reqData.replace("-", "");
		reqHeader = "1C1G01";
		/** update �޸�����ID5У�鳬ʱ��ID5_XML_ELE_VAL���������� tangyb 20150826 start
		// ����Ƿ񳬹�30�죬��������Ҫ���»�ȡ
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
			if (overDayCmp > 0) {	// �Ѿ�����30��
				Sqlca.executeSQL(new SqlObject("DELETE  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
			}
		}
		update �޸�����ID5У�鳬ʱ��ID5_XML_ELE_VAL���������� tangyb 20150826 end**/
		if(!"timeOut".equals(sRet)){
		sRet = RunID5.runParserId5(Sqlca, sCustomerID, reqHeader, reqData, savepath, "020",imgpath);//imgpath ����ͷ�񱣴�·��  by linhai 20150519
		}
	} else if (("ID5��ͥ�绰���".equals(sCheckPhaseName) || "ID5��ͥ�绰�˲�".equals(sCheckPhaseName)) && bUserId5) {
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
		
		// ����Ƿ񳬹�30�죬��������Ҫ���»�ȡ
		//String sExists = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
		
		if (bFamilyTel) {
			/* �޸�����ID5У�鳬ʱ��ID5_XML_ELE_VAL���������� 
			if (sExists != null) {
				double overDayCmp = Sqlca.getDouble(new SqlObject("SELECT (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30)) AS ID5DATE FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO")
					.setParameter("SERIALNO", reqHeader+"#"+reqData));
				if (overDayCmp > 0) {	// �Ѿ�����30��
					Sqlca.executeSQL(new SqlObject("DELETE  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
				}
			}
			 */
			if(!"timeOut".equals(sRet)){
			sRet = RunID5.runParserId5(Sqlca, sCustomerID, reqHeader, reqData, savepath, "020",imgpath);//imgpath ����ͷ�񱣴�·��  by linhai 20150519 CCS-757
			}
		} 
		/** update �޸�����ID5У�鳬ʱ��ID5_XML_ELE_VAL���������� tangyb 20150826 end**/
	}
	
	System.out.println("xxxxxxxxoooooo---"+sCheckPhaseName +":  " + sRet);
	//  ����ҳ����ʾֵ
	try {
		
		// ������ʾ������Դ
		String sRetHeader = "";
		if (sRet==null || sRet.length()<=0) {
			sRetHeader = "900";
		} else {
			sRetHeader = sRet.substring(0, 3);
		}
		// �����ͥ�绰δ��
		if (!bFamilyTel) {
			sRetHeader = "900";
		}
		if ("010".equals(sRetHeader)) {
			//sDbTip = "<font class=\"ecrmpt9\">&nbsp;��Ϣ��Դ�ڰ�Ǫ���ݿ�&nbsp;</font>";
			sDbTip = "��Ϣ��Դ�ڰ�Ǫ���ݿ�";
		} else if("020".equals(sRetHeader)) {
			//sDbTip = "<font class=\"ecrmpt9\">&nbsp;��Ϣ��Դ��ID5���ݿ�&nbsp;</font>";
			sDbTip = "��Ϣ��Դ��ID5���ݿ�";
		} else if ("900".equals(sRetHeader)) {
			sDbTip = "δ�����ͥ�绰��";
		}
		if ("error".equals(sRet)) {
			sDbTip = "ID5����ʧ��";
		}
		if ("timeOut".equals(sRet)) {
			   sDbTip = "��Ϣ��Դ���˹�ģʽ";
			  
		}
		if("Y".equals(renzhengbao)&&!"010".equals(sRetHeader)){
		try{
					 //��ͨ��֤��ʱ������֤��û�в�ѯ�칫�绰���ܣ��������ݿ����Ƿ��г���30���ͬ��������Դ����ʾ��Ǫ���ݿ���߷���ʧ��  qlm 20151221
		  	if (!"NCIIC��Ϣ�Զ����".equals(sCheckPhaseName)) {
		  		sDbTip ="��Ϣ��Դ���˹�ģʽ";
		  		sCompResult="����ʧ��";
		  		  sOpinionId = "070"; 
		  	}else{
		    sDbTip = "��Ϣ��Դ����֤��";
		 	String 	identification=	Sqlca.getString(new SqlObject("SELECT certid FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID").setParameter("CUSTOMERID", sCustomerID));
		 	String 	customerName=	Sqlca.getString(new SqlObject("SELECT customername FROM IND_INFO WHERE CUSTOMERID=:CUSTOMERID").setParameter("CUSTOMERID", sCustomerID));
		 	String  result=	RenZhengBao.simpleCheckByJson(Sqlca,identification,customerName,"bqjr_admin","baiqian123",CurUser.getUserID());
		      if("һ��".equals(result)){
		    	  sOpinionId = "010";
		      }else if("һ�£�����������֤����Ƭ".equals(result)){
		    	  sOpinionId = "030"; 
		      }else if("��һ��".equals(result)){
		    	  sOpinionId = "020";
		      }else if("�����޴˺�".equals(result)){
		    	  sOpinionId = "040";
		      }else if("һ��_1".equals(result)){
		    	  sDbTip = "��Ϣ��Դ�ڰ�Ǫ���ݿ� ��֤��";
		    	  sOpinionId = "010";
		    	  result="һ��";
		      }else if("һ�£�����������֤����Ƭ_1".equals(result)){
		    	  sDbTip = "��Ϣ��Դ�ڰ�Ǫ���ݿ� ��֤��";
		    	  sOpinionId = "030";
		    	  result="һ�£�����������֤����Ƭ";
		      }else if("��һ��_1".equals(result)){
		    	  sDbTip = "��Ϣ��Դ�ڰ�Ǫ���ݿ� ��֤��";
		    	  sOpinionId = "020";
		    	  result="��һ��";
		      }else if("�����޴˺�_1".equals(result)){
		    	  sDbTip = "��Ϣ��Դ�ڰ�Ǫ���ݿ� ��֤��";
		    	  sOpinionId = "040";
		    	  result="�����޴˺�";
		      }else{
		    	  sOpinionId = "050";
		    	  sDbTip = "��֤������ʧ��";
		      }
		        sCompResult=result;
		        }
		}catch(Exception e) {
			
		}
	}else{
		// �ж�����߼�
		ASResultSet id5Rs = Sqlca.getASResultSet(new SqlObject("SELECT STATUS2, VALUE2,COMPRESULT,COMPSTATUS,CHECKPHOTO,QUERYTYPE, CORPTEL,QUERYRESULT,TELINPUT, CORPNAME,AREACODE,CORPADDRESS,Z_NAME,HOMEADDRESS,INPUTDATE,CUSTOMERID  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO")
			.setParameter("SERIALNO", reqHeader+"#"+reqData));
		if (id5Rs.next()) {	// ��ѯ����ͨ��������
			if ("NCIIC��Ϣ�Զ����".equals(sCheckPhaseName)) {
				
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
			} else if (("ID5�칫�绰���".equals(sCheckPhaseName) || "ID5�칫�绰�˲�".equals(sCheckPhaseName)) && bUserId5) {
				
				status2 = id5Rs.getString("STATUS2");
				if(status2 == null) status2 = "";	
				if ("1".equals(status2)) {
					sOpinionId = "030";
				} else if ("0".equals(status2)) {
					sworkCorp = CommonUtils.replaceIllegalChar(id5Rs.getString("CORPNAME"));
					sworkAddName = CommonUtils.replaceIllegalChar(id5Rs.getString("AREACODE")+id5Rs.getString("CORPADDRESS"));
					System.out.println("Corpname: " + sworkCorp + ", WorkAddName: " + sworkAddName);
				}
			} else if (("ID5��ͥ�绰�˲�".equals(sCheckPhaseName) || "ID5��ͥ�绰���".equals(sCheckPhaseName)) && bFamilyTel && bUserId5) {
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
		
		// �رս����
		if (id5Rs != null) id5Rs.getStatement().close();
		}
	} catch (Exception e) {
		Sqlca.rollback();
		e.printStackTrace();
	}
	/*  ID5 AREA  add by tbzeng 2014/07/31 END   PART1*/
	
	/* ��֤dono��� */
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
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDoNo,Sqlca);
	
	// ר����������û��ֶ�
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) {
		doTemp.setVisible("InputUserName,InputTime,InputOrgName", false);
	}
	
	//PBOC���ȡ�������ʾ
	boolean bFlow = true;
	String sPhasename = Sqlca.getString(new SqlObject("select PhaseName from FLow_Model where FlowNo = :Flowno and PhaseNo =:PhaseNo")
					.setParameter("Flowno", sFlowNo).setParameter("PhaseNo", sPhaseNo));
	if(sPhasename == null) sPhasename = "";	
	if(sPhasename.startsWith("PBOC")){
		bFlow =false;
	}
	
	// �޸��˹���Ϣ��˽׶�ģ�� add by tbzeng 2014/08/04 �޸��˹����ѡ����
	/* if ("NCIIC��Ϣ�˹����".equals(sCheckPhaseName) || "NCIIC��Ϣ�˹��˲�".equals(sCheckPhaseName)) {
		doTemp.setVRadioCode("PhaseOpinion", "NCIICMunallChick2");
	} */
	
	/*  ID5 AREA  add by tbzeng 2014/07/31 START PART2*/
	if(sRet == null) sRet = "";	
	if ("NCIIC��Ϣ�Զ����".equals(sCheckPhaseName)) {
		doTemp.setVisible("ID5", true);
		if(!"timeOut".equals(sRet)){
		doTemp.setReadOnly("PhaseOpinion", true);
		}
		if (!"error".equals(sRet)) {
			doTemp.setVisible("CompResult", true);
		}
		//doTemp.setUpdateable("ID5", true);
	} else if (("ID5�칫�绰���".equals(sCheckPhaseName) || "ID5�칫�绰�˲�".equals(sCheckPhaseName)) && bUserId5) {
		doTemp.setVisible("ID5", true);
		if (!"error".equals(sRet)) {
			doTemp.setVisible("IndName,HomeAddr", true);
		}
	}else if (("ID5��ͥ�绰���".equals(sCheckPhaseName) || "ID5��ͥ�绰�˲�".equals(sCheckPhaseName)) && bUserId5) {
		if (!"error".equals(sRet)) {
			doTemp.setVisible("ID5,IndName,HomeAddr", true);
		}
	}
	// ���δ�����ͥ�绰
	if ((!bFamilyTel && ("ID5��ͥ�绰���".equals(sCheckPhaseName) || "ID5��ͥ�绰�˲�".equals(sCheckPhaseName))) && bUserId5) {
		doTemp.setVisible("IndName,HomeAddr", false);
	}
	
	/*  ID5 AREA  add by tbzeng 2014/07/31 END   PART2*/
	
	
	//��ͥ��Ա����˲�   ���ѡ��
	/* if ("0080".equals(sPhaseNo) && "WF_HARD".equals(sFlowNo) && "HomePhoneInfoOpinionInfo".equalsIgnoreCase(sDoNo)) {
		doTemp.setVRadioCode("PhaseOpinion", "FamilyMemberPhoneInfoCheck");
	} */
	
	//����ASDataWindow����		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform��ʽ
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
			//edit by xswang 20150505 CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
			{"false","","Button","���Ҫ��","�鿴���Ҫ��","viewApprove()",sResourcesPath},
			// end by xswang 20150505
			{"true","","Button","��������","�鿴����","viewTab()",sResourcesPath},
			{"true","","Button","�˻�ǰһ��","�˻�����","backStep()",sResourcesPath},
			{"true","","Button","��һ����֤","�ύ����","doSubmit()",sResourcesPath},
			{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
			{"true","","Button","�绰�ֿ�","�鿴�绰�ֿ�","getPhoneCode()",sResourcesPath},
			{"true","","Button","����¼��","����¼��","playTape()",sResourcesPath},
			{"true","","Button","�鿴��Ƭ","�鿴��Ƭ","viewImage()",sResourcesPath},
			{"true","","Button","ȡ������","ȡ������","cancelApply()",sResourcesPath},
			{"false","","Button","����绰","����绰","btnMakeCall_Click()",sResourcesPath},
			{"true","","Button","Ӱ�����","Ӱ�����","imageManage()",sResourcesPath},
			{"true","","Button","�鿴�����","�鿴�����","creatApplyTable()",sResourcesPath},
	       	{"true","","Button","���Ӻ�ͬ","���Ӻ�ͬ","createPDF()",sResourcesPath},
	       	{"true","","Button","���Ļ����Ӻ�ͬ","���Ļ����Ӻ�ͬ","createSxhPDF()",sResourcesPath},
		    {"true","","Button","ǩ����Ƭ","ǩ����Ƭ","createPhoto()",sResourcesPath},
		    {"true","","Button","ǩ��¼��","ǩ��¼��","createAudio()",sResourcesPath},
			{"true","","Button","�鿴Э����Ϣ","�鿴Э����Ϣ","viewAssist()",sResourcesPath}
	};
	
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) sButtons[9][0] = "true";
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<embed name="3_devUnknown" id="3_devUnknown" src="E:\123.wma" type="audio/x-wav" hidden="true" autostart="false" loop="false"/>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	 /*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
        var sObjectNo   = "<%=sObjectNo%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
      //��֤��ͬ��Ʒ�Ƿ��Ѿ���Ӱ������������
		var sBusinessType = RunMethod("���÷���", "GetColValue", "Business_Contract,BusinessType,SerialNo='"+sObjectNo+"'");
     	var sAmount = RunMethod("���÷���","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
		if(sAmount == 0){
			alert("��������ƷӰ�����������øò�Ʒ��Ӧ��Ӱ���ļ���");
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
			/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
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
			alert("δѡ�������");
			return true;
		}
	}
	
	//
	function svresult(){
		var sResult = getItemValue(0,getRow(),"SVRESULT");

		if(sResult=="01"){//�ܾ�  
			setItemRequired(0,0,"PhaseOpinion",true);
		}else if(sResult=="02"){//ͨ��
			setItemRequired(0,0,"PhaseOpinion",false);
		}else{
			setItemRequired(0,0,"PhaseOpinion",false);
		}
		
		
	}
	
	/*~[Describe=ɾ����ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    var sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("����û��ǩ�������������ɾ�����������");
	 	}
	 	else if(confirm("��ȷʵҪɾ�������"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("���ɾ���ɹ�!");
	  		}
	   		else
	   		{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
			reloadSelf();
		}
	} 
	
    /*~[Describe=�ύҵ��;InputParam=��;OutPutParam=��;]~*/
    function doSubmit()
	{
		//����������͡�������ˮ�š��׶α��
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var OrgID = "<%=CurUser.getOrgID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sDoNo = "<%=sDoNo%>";
		var needPage = <%=needPage%>;
		//���������ˮ��
		var sSerialNo = "<%=sSerialNo%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		
		//  ��ȡid5�绰
		/* var sId5 = getItemValue(0, 0, "PhaseOpinion3");
		var sIdOpinion = getItemValue(0, 0, "PhaseOpinion");
		alert("|"+sId5+"|" + typeof sId5 + "|"+sIdOpinion+"|"+typeof sIdOpinion + "|");
		return; */
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
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
		
		// edit by xswang 20150615 CCS-900 ����е������ܱ���ͣ
		/* // add by xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
		// �Ӻ�ͬ����ȡ��ǰ��ͬ�ġ�cancelstatus����ʶ
		var sReturn1 = RunMethod("BusinessManage", "SelectContractCancelStatus",sObjectNo);
		if("1" == sReturn1){
			alert("�ú�ͬ�ѱ���ͣ�������ύ");
			return;
		}
		// end by xswang 20150427 */
		// end by xswang 20150615
		
		if(sCreditReport=="1"){
			if (typeof(sCreditNum)=="undefined" || sCreditNum.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sCreditLimit)=="undefined" || sCreditLimit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sUseLimit)=="undefined" || sUseLimit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sCreditStatus)=="undefined" || sCreditStatus.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sIsNormalCredit)=="undefined" || sIsNormalCredit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sOverDueMonthCredit)=="undefined" || sOverDueMonthCredit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sPutoutAccount)=="undefined" || sPutoutAccount.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sPutoutSum)=="undefined" || sPutoutSum.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sIsNormalPutout)=="undefined" || sIsNormalPutout.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sOverDueMonthPutout)=="undefined" || sOverDueMonthPutout.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sSuccessDate)=="undefined" || sSuccessDate.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sQueryTime1)=="undefined" || sQueryTime1.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sQueryTime2)=="undefined" || sQueryTime2.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sPhoneNumber)=="undefined" || sPhoneNumber.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
		}
		
		
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			if(sCancelApply == "100"){
				alert("�������ѱ�ȡ��");
				window.close();
				return;
			}else{
				alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
				reloadSelf();
				return;
			}
		}
		if(sCancelApply == "100"){
			alert("�������ѱ�ȡ��");
			window.close();
			return;
		}
		
		if(<%=bFlow%>){
			var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
			if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
				//add by huanghui PRM-670�ֻ���ϵ��ʽ֧������֤��ֻ�����ģ���������Ŀ��ƣ��������˿�
				if(sDoNo!="MobileValidationOpinionInfo" ){
					alert("δ��д�����"); 	//updata byang CCS-1220 "δѡ�����"   �ĳ�  "δ��д���"
					return true;
				}
			} else {
				
				if (sPhaseOpinion=="060" && "ID5PhoneOpinionInfo"==="<%=sDoNo%>") {
					var sId5 = getItemValue(0, 0, "PhaseOpinion3");
					if (! (sId5 && CheckPhoneCode(sId5))) {
						//alert(sId5 + "|" +sId5.replace(/(\s+|[A-Za-z])/g, ""));
						alert("��������ȷ��ID5�绰����");
						return;
					} 
				}
			}
		}
		
		if(vI_all("myiframe0")){//add CCS-550 ��ͬ��Ч�Լ�� �������� (��ֻѡ���һ�����������û��ȫ�������ɺ����̿��Խ��뵽��һ���ڵ�) phe 20150312
		saveRecord();
		
		//PBOC�׶β��������
		if(!<%=bFlow%>){
			var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
			sReturn= RunMethod("BusinessManage","InsertOpinion","PBOC�Ѽ��,<%=sSerialNo%>,"+sOpinionNo+",<%=sObjectNo%>,<%=sObjectType%>,"+sUserID+","+OrgID);
		}
		
		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		var sToday = "<%=sToday%>";
		if(needPage){
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}else{
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoFlagCommint","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}
		
		// ���º�ͬ״̬
		RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo=" + sObjectNo + ",phaseNOFlag=1");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			
			//alert(getHtmlMessage('18'));//�ύ�ɹ���	// comment by tbzeng 2014/05/03 ȥ���ύ�ɹ���ʾ��
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

			//ˢ�¼�����ҳ��
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else if(sPhaseInfo=="noexits"){

			//alert(getHtmlMessage('18'));//�ύ�ɹ���	// comment by tbzeng 2014/05/03 ȥ���ύ�ɹ���ʾ��
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
			//alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			parent.parent.parent.reloadSelf();
			return; 
	    }else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				// add by xswang 2015/05/25 CCS-808 ϵͳȫ���̵��ӻ����죺�ļ��������
				//�����ļ��������״̬Ϊδ��飬���ͨ��ʱ��Ϊϵͳʱ��
				/* RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,CheckDocStatus,1,SerialNo = '"+sObjectNo+"'");
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,PassTime,"+sToday+",SerialNo = '"+sObjectNo+"'"); */
				//RunMethod("PublicMethod","UpdateColValue","String@CheckDocStatus@1@String@PassTime@" + sToday + ",business_contract,String@SerialNo@" + sObjectNo);
				//RunMethod("PublicMethod","UpdateColValue","String@CheckDocStatus@1@String@PassTime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
				// end by xswang 2015/05/25
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				//ˢ�¼�����ҳ��
				
				}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
		}//end CCS-550 ��ͬ��Ч�Լ�� �������� (��ֻѡ���һ�����������û��ȫ�������ɺ����̿��Խ��뵽��һ���ڵ�) phe 20150312
	}
    
    /*~[Describe=�绰¼��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		
	 }
    
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
	function backStep(){
		//��ȡ������ˮ��
		var sSerialNo = "<%=sSerialNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		//����Ƿ����˻�
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","cancelCheck","serialNo="+sSerialNo+",userID="+sUserID);
		if(sReturn != "Success"){
			alert("��һ���а��˲��ǵ�ǰ�û����������˻�");
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
		//����Ƿ�ǩ�����
		//var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//�˻��������   	
			var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if(sRetValue == "Commit"){
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sCustomerID = "<%=sCustomerID%>";

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//OpenComp("SignTaskOpinionList","/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
		AsControl.OpenComp("/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank03","dialogWidth=950px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
	}
	
	/*~[Describe=����¼��;InputParam=��;OutPutParam=��;]~*/
	function playTape(){
		var sRet = setObjectValue("SelectWMAUrl", "ContractNo,<%=sObjectNo%>", "", 0, 0, "");
		if (sRet==='_CLEAR_' || typeof(sRet)=='undefined' || sRet==='undefined') {
			return;
		}
		var sWmaUrl = sRet.split("@")[1];
		AsControl.PopComp("/Common/WorkFlow/playTape.jsp","WmaURL="+sWmaUrl,"");
	}
	
	/*~[Describe=�鿴ͼƬ;InputParam=��;OutPutParam=��;]~*/
	function viewImage(){
		AsControl.PopComp("/Common/WorkFlow/SignTaskImage.jsp","ObjectNo=<%=sObjectNo%>","");
	}
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		var OpenStyle = "dialogWidth=600px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		//����ѡ��ȡ���������
		var sReturn = popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&PhaseNo=<%=sPhaseNo%>&FlowNo=<%=sFlowNo%>&TaskNo=<%=sSerialNo%>&Type=1",OpenStyle);
		window.returnValue = sReturn;
		//edit by xswang 20150424 CCS-724 ����ȡ��ѡ�����ٵ���رգ�ͣ���ڵ�ǰҳ��
		if(!(typeof(sReturn)=='undefined')){
			parent.parent.parent.reloadSelf();
		}
		//end by xswang 20150424
		//window.close();
	}
	
	//add by clhuang 2015/07/22 CCS-923 ��˶�ѡ����թ��ʧ��ʱ���������թԭ��Ϊ������
	//��ͥ�绰����˲�/��ͥ��Ա����˲飨������թ��
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
	//�칫�绰����˲飨��Ϣ��֤ʧ�ܣ�
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
	//�����ֻ�����˲飨1����Ϣ��֤ʧ��2��������թ�� ѧ���ֻ���������˲飨1����Ϣ��֤ʧ�� 2��������թ��
	function CheckCellTelOpinion(){
		hideItem(0,0,"PhaseOpinion1");
		hideItem(0,0,"PhaseOpinion2");
	   var sPhaseOpinion=getItemValue(0,0,"PhaseOpinion");//CellTelCheck
	   if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
		   return;
	   }
	   if(sPhaseOpinion=="030"){//��Ϣ��֤ʧ��
		   showItem(0,0,"PhaseOpinion1");//��Ϣ��֤ʧ��
		   setItemRequired(0, 0, "PhaseOpinion1", true);
	   }else if(sPhaseOpinion=="040"){//��թ����
		   showItem(0,0,"PhaseOpinion2");//��թ����
		   setItemRequired(0, 0, "PhaseOpinion2", true);
	   }else{
		   setItemValue(0,0,"PhaseOpinion1","");
		   setItemRequired(0, 0, "PhaseOpinion1", false);
		   setItemValue(0,0,"PhaseOpinion2","");
		   setItemRequired(0, 0, "PhaseOpinion2", false);
	   }
	}
	//�����жϣ�ѡ��RES05�������
	function CheckSubjectivityOpinion(){
			var sDoNo = "<%=sDoNo%>";
			//ֻ�����ģ���������Ŀ���
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
	//������ϵ����Ϣ���(������թ)
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
	
	

	
	//�������ñ���Ϊ��ʱ��Ϊ����
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
	
	/*~[Describe=�ֻ�������֤;InputParam=��;OutPutParam=��;]~*/
	function checkMobile(obj){ 
		
	    var sPhoneNumber = getItemValue(0,getRow(),"PhoneNumber");
	    if(typeof(sPhoneNumber) == "undefined" || sPhoneNumber.length==0){
	    	return false;
	    }
	    if(!(/^1[3|4|5|8][0-9]\d{8}$/.test(sPhoneNumber))){ 
	        alert("�ֻ�����������������������"); 
	        //obj.focus();
		    setItemValue(0,0,"PhoneNumber","");
	        return false; 
	    } 
	} 
	
	//���ÿ��������
	function creditNum(){
		var sCreditNum = getItemValue(0,getRow(),"CreditNum");
		if(sCreditNum<=0 ){
			alert("���ÿ�������1~99֮��");
    		 setItemValue(0,0,"CreditNum","");
    	}
    	if(sCreditNum>99 ){
			alert("���ÿ�������1~99֮��");
    		 setItemValue(0,0,"CreditNum","");
    	}
	}
	
	//���24����������������
	function overDueMonthCredit(){
		var sOverDueMonthCredit = getItemValue(0,getRow(),"OverDueMonthCredit");
		if(sOverDueMonthCredit<=0 ){
			alert("���24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
    	if(sOverDueMonthCredit>99 ){
			alert("���24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
	}
	
	//�����˻������
	function putoutAccount(){
		var sPutoutAccount = getItemValue(0,getRow(),"PutoutAccount");
		if(sPutoutAccount<=0 ){
			alert("�����˻�����1~99֮��");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
    	if(sPutoutAccount>99 ){
			alert("�����˻�����1~99֮��");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
	}
	
	//�������24����������������
	function overDueMonthPutout(){
		var sOverDueMonthPutout = getItemValue(0,getRow(),"OverDueMonthPutout");
		if(sOverDueMonthPutout<=0 ){
			alert("�������24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
    	if(sOverDueMonthPutout>99 ){
			alert("�������24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
	}
	
	
	//���6���±���ѯ�������
	function queryTime1(){
		var sQueryTime1 = getItemValue(0,getRow(),"QueryTime1");
		if(sQueryTime1<=0 ){
			alert("���6���±���ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime1","");
    	}
    	if(sQueryTime1>99 ){
			alert("���6���±���ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime1","");
    	}
	}
	
	//���6���±���ѯ�������
	function queryTime2(){
		var sQueryTime2 = getItemValue(0,getRow(),"QueryTime2");
		if(sQueryTime2<=0 ){
			alert("���30�챻��ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime2","");
    	}
    	if(sQueryTime2>99 ){
			alert("���30�챻��ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime2","");
    	}
	}
	
	//�����Ŷ�ȼ��
	function creditLimit(){
		var sCreditLimit = getItemValue(0,getRow(),"CreditLimit");
		if(sCreditLimit<1){
			alert("�����Ŷ����1~1000w֮��");
    		 setItemValue(0,0,"CreditLimit","");
    	}
    	if(sCreditLimit>10000000 ){
			alert("�����Ŷ����1~1000w֮��");
    		 setItemValue(0,0,"CreditLimit","");
    	}
	}
	
	
	//���ö�ȼ��
	function useLimit(){
		var sUseLimit = getItemValue(0,getRow(),"UseLimit");
		if(sUseLimit<1 ){
			alert("���ö����1~1000w֮��");
    		 setItemValue(0,0,"UseLimit","");
    	}
    	if(sUseLimit>10000000 ){
			alert("���ö����1~1000w֮��");
    		 setItemValue(0,0,"UseLimit","");
    	}
	}
	
	
	//�����ܶ���
	function putoutSum(){
		var sPutoutSum = getItemValue(0,getRow(),"PutoutSum");
		if(sPutoutSum<1 ){
			alert("�����ܶ���1~99999999֮��");
    		 setItemValue(0,0,"PutoutSum","");
    	}
    	if(sPutoutSum>99999999 ){
			alert("�����ܶ���1~99999999֮��");
    		 setItemValue(0,0,"PutoutSum","");
    	}
	}
	
	
	//������绰
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
		//����Ƿ�APP���ύ���� SureType
		var sAppFlag = RunMethod("���÷���", "GetColValue", "Business_Contract,SureType,SerialNo='"+sObjectNo+"'");
		var url = "";
		if(sAppFlag=="APP"){//APP���ύ����
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
		}else{//PC���ύ����
			printTable("ApplySettle");
		} 
		}
		/*~[Describe=�鿴Э����Ϣ;InputParam=��;OutPutParam=��;]~*/
		function viewAssist(){
			printTable("AssistSettle");
		}
		//��׼�Ĵ�ӡ�߼�
		function printTable(type){
			
			var sObjectNo = "<%=sObjectNo%>";
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
			//CCS-316 ��Ҫ���ݺ�ͬ״̬���ƿ��ٲ�ѯ��İ�ť     add by Roger 2015/03/09
			var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
			    if(sContractStatus == "060" || sContractStatus == "070"){   //�·���������к�ͬ����admin�������˶����ܴ�ӡ��ͬ
			    	//������Ա��ɫ�����Ȩ 
			    	if(!<%=CurUser.hasRole(new String[]{"000","099","1000"})%>){
			    		alert("ֻ�й���Ա���ܵ��ĸñʺ�ͬ");
			    		return;
			    	}
		    }
			var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
			if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
				return;
			}
			var sDocID = 	returnValue.split("@")[0];
			var sUrl = returnValue.split("@")[1];
			var sObjectType = type;
			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}else{
				//������֪ͨ���Ƿ��Ѿ�����
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if (sReturn == "false"){ //δ���ɳ���֪ͨ��
					//���ɳ���֪ͨ��	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
					//��¼���ɶ���
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
				}else{
					//��¼�鿴����
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
				}
				//��ü��ܺ�ĳ�����ˮ��
				var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
				//ͨ����serverlet ��ҳ��
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
				//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
				OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	//   ============================== end  ��ӡ��ʽ������ ============================================================

	function createPDF(){
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == null || ssuretype.length == 0 || (ssuretype != "APP" && ssuretype != "JQM" && ssuretype != "FC" )) {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
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
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    var bugpaypkgind = RunMethod("���÷���", "GetColValue", "business_contract,bugpaypkgind,serialno='"+sObjectNo+"'");
		if(typeof(bugpaypkgind)=="undefined" || bugpaypkgind.length==0 || bugpaypkgind == "0"){
	        alert("�ú�ͬû�й������Ļ������!");
	        return;
		}
	    //ͨ����serverlet ��ҳ��
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
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    var url="<%=sAPPUrl4photo%>"+"<%=sObjectNo%>";
	    window.open(url,"_blank",CurOpenStyle);
	}
	  
	function createAudio(){
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == null || ssuretype.length == 0 || ssuretype != "APP") {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    var url="<%=sAPPUrl4record%>"+"<%=sObjectNo%>";
	    window.open(url,"_blank",CurOpenStyle);
	}
	/*~[Describe=��ѯ���Ҫ����ʾ;InputParam=��;OutPutParam=��;]~*/
	function viewApprove(){
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		popComp("AuditPointsModelFrame","/SystemManage/CarManage/AuditPointsModelFrame.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&RightType=ReadOnly","");
	}
	
	/*~[Describe=���ѡ�񴥷��¼�;InputParam=��;OutPutParam=��;]~*/
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

	//add by daihuafeng 20150709 CRA-285  �����˵�(ѡ����Ϣ��֤ʧ�ܼ���թ���ɣ������˵��Ǳ�ѡ��) ----begin 
	//��ͥ�绰�˲�
	function ChangeTwoOpinion(){
		var sDoNo = "<%=sDoNo%>";
		//ֻ��������ģ���������Ŀ���
		if(sDoNo!="OfficePhoneOpinionInfo" && sDoNo!="OfficePhoneOpinionInfo2"){
			return;
		}
		var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
		if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			//��ֵ(��һ�ν���)ʱʲô������
		}else if(sPhaseOpinion=="040"){//��Ϣ��֤ʧ��
			setItemDisabled(0,getRow(),"PhaseOpinion1",false);
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
		}else if(sPhaseOpinion=="050"){//������թ
			setItemDisabled(0,getRow(),"PhaseOpinion2",false);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}else{//��ֵ�Ҳ�����Ϣ��֤ʧ�ܡ�����������թʱ
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}
		
		var phaseName = "<%=sCheckPhaseName%>";
		if("�칫�绰����˲�"==phaseName){
			CheckOfficeOpinion();
		}
	}
	//�ֻ��˲�
	function ChangeTwoOpinion2(){
		var sDoNo = "<%=sDoNo%>";
		//ֻ��������ģ���������Ŀ���
		if(sDoNo!="CellTelOpinionInfo" && sDoNo!="CellTelOpinionInfo2"){
			return;
		}
		
		var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
		if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			//��ֵ(��һ�ν���)ʱʲô������
		}else if(sPhaseOpinion=="030"){//��Ϣ��֤ʧ��
			setItemDisabled(0,getRow(),"PhaseOpinion1",false);
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
		}else if(sPhaseOpinion=="040"){//������թ
			setItemDisabled(0,getRow(),"PhaseOpinion2",false);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}else{//��ֵ�Ҳ�����Ϣ��֤ʧ�ܡ�����������թʱ
			setItemValue(0,getRow(),"PhaseOpinion2","");
			setItemDisabled(0,getRow(),"PhaseOpinion2",true);
			setItemValue(0,getRow(),"PhaseOpinion1","");
			setItemDisabled(0,getRow(),"PhaseOpinion1",true);
		}
		
		var phaseName = "<%=sCheckPhaseName%>";
		if("�ֻ���������˲�"==phaseName || "ѧ���ֻ���������˲�"==phaseName){
			CheckCellTelOpinion();
		}
	}
	//----end
	
	//add by huanghui 2015/12/21 PRM-670 �ֻ���ϵ��ʽ֧������֤
	//�ֻ���ϵ��ʽ֧������֤
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
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
		
		if (("NCIIC��Ϣ�Զ����" ===  "<%=sCheckPhaseName%>")) {
			setItemValue(0, 0, "ID5", "<%=sDbTip%>");
			if ("error" !== "<%=sRet%>") {
				if("timeOut" !== "<%=sRet%>"){
				setItemValue(0, 0, "CompResult", "<%=sCompResult%>");
				setItemValue(0, 0, "PhaseOpinion", "<%=sOpinionId%>");
				}else{
					setItemValue(0, 0, "CompResult", "ID5���ó�ʱ");
					//--add ����ID5��鳬ʱ���������Ĭ��ѡ�񡰷���NCIICʧ�ܡ� tangyb 20150827--
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
		} else if  ((("ID5�칫�绰���" === "<%=sCheckPhaseName%>")  || ("ID5�칫�绰�˲�" === "<%=sCheckPhaseName%>")) && bUserId5) {
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
		}else if (("ID5��ͥ�绰���" === "<%=sCheckPhaseName%>" || "ID5��ͥ�绰�˲�"==="<%=sCheckPhaseName%>") && bUserId5) {
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
			// ��Ǫ���ݿ����ʧ��
		}
		if ("error" === "<%=sRet%>") {
			// ID5����ʧ��
			
		}
		
		var phaseName = "<%=sCheckPhaseName%>";
		if("֧�����ֻ���ϵ��ʽ��֤"==phaseName){
			CheckMobileValidationInfo();
		}
		
		CheckSubjectivityOpinion();
		if("������ϵ����Ϣ���"==phaseName){
			CheckOtherManageOpinion();
		}else if("��ͥ�绰����˲�"==phaseName || "��ͥ��Ա����˲�"==phaseName){
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