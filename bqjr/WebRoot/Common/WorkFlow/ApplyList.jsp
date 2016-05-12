<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: 该页面主要处理业务相关的申请列表，如授信额度申请列表，额度项下业务申请列表，
			 单笔授信业务申请列表，最终审批意见登记列表、出帐申请列表
	Input Param:
		ApplyType：申请类型
			—CreditLineApply/授信额度申请
			—DependentApply/额度项下申请	
			—IndependentApply/单笔授信业务申请	
			—ApproveApply/待提交复核最终审批意见
			—PutOutApply/待提交审核出帐
			--ProductLineApply 产品申请
		PhaseType：阶段类型
			—1010/待提交阶段（初始阶段）
	Output param:
	History Log: zywei 2005/07/27 重检页面
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = ""; //存放SQL语句
	ASResultSet rs = null; //存放查询结果集
	String sTempletNo = ""; //显示模版ItemNo
	String sPhaseTypeSet = ""; //存放阶段类型组
	String sButton = ""; 
	String sObjectType = ""; //存放对象类型
	String sViewID = ""; //存放查看方式
	String sWhereClause1 = ""; //存放阶段类型强制where子句1
	String sWhereClause2 = ""; //存放阶段类型强制where子句2
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	String sButtonSet = "";
	String userType="";
	String switch_status ="";//二段式提单添加系统开关 huzp
	//获得组件参数:申请类型,阶段类型
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String transactionFilter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransactionFilter",10));
	String stuApplyType= DataConvert.toRealString(iPostChange,(CurComp.getParameter("subApplyType")));
	//将空值转化成空字符串
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(transactionFilter == null) transactionFilter = "";
	//获得合同取消时的显示参数,合同取消时新增"取消原因"，"取消类型"的显示
	String sMonitorId=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	if(sMonitorId==null) sMonitorId="";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//如果申请类型为ClassifyApply(五级分类申请)，则从PARA_CONFIGURE表中读取五级分类的对象类型，确定其是借据还是合同 add by cbsu 2009-10-28
    String sResultType = CurConfig.getConfigure("ClassifyObjectType");
    /*if("ClassifyApply".equals(sApplyType)) {
        sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'";    
        sResultType = Sqlca.getString(sSql); 
        //如果PARA_CONFIGURE表中没有配置五级分类数据，则直接使用"BusinessDueBill"
        if(!sResultType.equals("BusinessDueBill") && !sResultType.equals("BusinessContract"))
        {
            sResultType = "BusinessDueBill";
        }
    }*/
    
    //销售门店
    String sSNo = CurUser.getAttribute8();
    if(sSNo == null) sSNo = "";
    System.out.println("-------销售门店-------"+sSNo);
    
    
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得ApplyMain的树图以及该申请的阶段,流程对象类型,ApplyList使用哪个ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		sButtonSet = rs.getString("Attribute5");
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
		if(sButtonSet == null) sButtonSet = "";
	}else{
		throw new Exception("没有找到相应的申请类型定义（CODE_LIBRARY.ApplyType:"+sApplyType+"）！");
	}
	rs.getStatement().close();
	//根据组件ID和组件参数(阶段类型)从代码表CODE_LIBRARY中查询出显示的按钮,以什么视图查看对象详情,where条件1,where条件2,ApplyList数据对象ID
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo =:CodeNo and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sPhaseTypeSet).setParameter("ItemNo",sPhaseType));
	if(rs.next()){
		sButton = rs.getString("ItemDescribe");
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));		
		sTempletNo = rs.getString("Attribute4");
		
		//将sTempNo按@进行分割 add by cbsu 2009-10-12
		if ("Classify".equals(sObjectType)) {
			String[] sTempletNos = sTempletNo.split("@");
			//根据五级分类对象是借据还是合同来使用不同的模板 add by cbsu 2009-10-12
			if (sTempletNos.length > 1) {
				if ("BusinessDueBill".equals(sResultType)) {
					sTempletNo = sTempletNos[0];
					}
				if ("BusinessContract".equals(sResultType)) {
					sTempletNo = sTempletNos[1];
				}
			}
		}
		
		if(sButton == null) sButton = "";
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{
		throw new Exception("没有找到相应的申请阶段定义（CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"）！");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("没有定义sTempletNo, 检查CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	if(sViewID.equals("")) throw new Exception("没有定义ViewID 检查CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得默认流程ID
	sSql = " select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	while(rs.next()){
		sInitFlowNo = rs.getString("Attribute2");
		if(sInitFlowNo == null) sInitFlowNo = "";
	}
	rs.getStatement().close();
	
	//根据默认流程ID从流程表FLOW_CATALOG中获得初始阶段
	sSql = " select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo",sInitFlowNo));
	while(rs.next()){
		sInitPhaseNo = rs.getString("InitPhase");
		if(sInitPhaseNo == null) sInitPhaseNo = "";
	}
	rs.getStatement().close();


	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	//根据显示模版编号和显示模版过滤条件生成DataObject对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//非额度申请,隐藏敞口金额字段,并将BusinessSum列名更新为申请金额
	if(!"CreditLineApply".equals(sApplyType)){
		doTemp.setVisible("ExposureSum",false);
		doTemp.setHeader("BusinessSum","申请金额");
	}
	//取消页面新增两个显示字段：“取消类型”、“取消原因”
	if("Cancel".equals(sMonitorId)){
		doTemp.setVisible("CancelReason",true);
		doTemp.setVisible("CancelType",true);
	}
	//add  在“ 已拒绝合同”增加显示  能否原地复活字段 by hhuang 20150630
	if("1050".equals(sPhaseType)){
		doTemp.setVisible("AllowReconsider",true);
	}
	//设置更新表名和主键
	doTemp.UpdateTable = "FLOW_OBJECT";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //为后面的删除
	//将where条件1和where条件2中的变量用实际的值替换，生成有效的SQL语句
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ApplyType",sApplyType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseType",sPhaseType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.getUserID());
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ApplyType",sApplyType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseType",sPhaseType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#Stores",sSNo);//添加门店控制
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	
	//在做五级分类申请时对SQL语句进行拼接  add by cbsu 2009-10-29
    if ("Classify".equals(sObjectType)) {
        String sTableSerialNo = "";
        if ("BusinessDueBill".equals(sResultType)) {
        	sTableSerialNo = "BUSINESS_DUEBILL.SerialNo";
        }
        if ("BusinessContract".equals(sResultType)) {
        	sTableSerialNo = "BUSINESS_CONTRACT.SerialNo";
        }
        sWhereClause1 = StringFunction.replace(sWhereClause1,"#TableSerialNo",sTableSerialNo);
        sWhereClause2 = StringFunction.replace(sWhereClause2,"#TableSerialNo",sTableSerialNo);
    }
	
	//增加空格防止sql语句拼接出错
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//设置ASDataObject中的排序条件
	//doTemp.OrderClause = " order by FLOW_OBJECT.ObjectNo desc ";
	//add 合同注册、合同打印界面不区分产品子类型所有产品都能查询 by huanghui 20150826
	if((stuApplyType != null && (!"1150".equals(sPhaseType) && (!"1160".equals(sPhaseType)))) || ("CreditLineApply".equals(sApplyType) && (!"1150".equals(sPhaseType) && (!"1160".equals(sPhaseType))))){
		if("StuEducation".equals(stuApplyType)){//quliangmao   产品子类型 根据用户点击的URL 判断是那条子类型
			doTemp.WhereClause += "  and  subproducttype = '5'  ";
		} else if("AdultEducation".equals(stuApplyType)){
			doTemp.WhereClause += "  and  subproducttype = '4'  ";
		} else if ("StuPos".equals(stuApplyType)){	// 学生消费贷  add by dahl
			doTemp.WhereClause += "  and  subproducttype = '7'  ";
		}else{ //普通消费贷 edit by dahl
			/*
			doTemp.WhereClause += "  and  nvl(subproducttype,'3') <> '4'  ";
			doTemp.WhereClause += "  and  nvl(subproducttype,'3') <> '5'  ";
			doTemp.WhereClause += "  and  nvl(subproducttype,'3') <> '7'  ";
			*/
			doTemp.WhereClause += "  and  subproducttype = '0'  ";
			
		}
	}
	
	//设置申请时间为日历控件
	doTemp.setCheckFormat("inputdate", "3");
	//生成查询框
	//add 合同打印、合同注册界面更改查询 by huanghui 20150826
	if("1150".equals(sPhaseType) ){
		doTemp.setFilter(Sqlca, "002", "SerialNo", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "020", "CustomerName", "Operators=EqualsString,BeginsWith;");
		doTemp.setDDDWSql("contractStatus1", "select itemno,itemname from code_library where codeno='ContractStatus' and itemno in ('020','050','080') and IsInUse = '1' ");
		doTemp.setFilter(Sqlca, "036", "contractStatus1", "Operators=EqualsString;");
		doTemp.setFilter(Sqlca, "027", "inputdate", "Operators=EqualsString,BeginsWith;");
		//doTemp.generateFilters(Sqlca);
	}else if(("1160".equals(sPhaseType))){
		//隐藏注册时间
		doTemp.setVisible("timerange,registrationdate", false);
		doTemp.setFilter(Sqlca, "002", "SerialNo", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "020", "CustomerName", "Operators=EqualsString,BeginsWith;");
		doTemp.setDDDWSql("contractStatus1", "select itemno,itemname from code_library where codeno='ContractStatus' and itemno ='080' and IsInUse = '1' ");
		doTemp.setFilter(Sqlca, "036", "contractStatus1", "Operators=EqualsString;");
		doTemp.setFilter(Sqlca, "027", "inputdate", "Operators=EqualsString,BeginsWith;");
		//doTemp.generateFilters(Sqlca);
	}else{
		doTemp.generateFilters(Sqlca);
	}	
	//添加贷后资料上传状态查询条件
	if("CreditLineApply".equals(sApplyType) && "1080".equals(sPhaseType)){
		doTemp.setDDDWSql("uploadFlag", " select itemname,itemname from code_library where codeno='uploadFlag' and IsInUse = '1' ");
		doTemp.setDDDWSql("checkstatus", " select itemname,itemname from code_library where codeno='checkstatus' and IsInUse = '1' ");
		doTemp.setFilter(Sqlca, "024", "uploadFlag", "Operators=EqualsString;");
		doTemp.setFilter(Sqlca, "026", "checkstatus", "Operators=EqualsString;");
	}else if("CreditLineApply".equals(sApplyType) && "1050".equals(sPhaseType) && CurUser.hasRole("1005")){
		doTemp.WhereClause += " "+" and (isbaimingdan <> '1' or isbaimingdan is null)  ";
	}
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//jgao 2009-10-09修改，查询框内容已在显示模板中配置，
	//doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//if(!sApplyType.equals("CreditCogApply")){ //信用等级评估申请时不展示
		//doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//}	
	
	//add 合同注册、合同打印界面增加默认不查询的限制 by huanghui 20150826
	if("1150".equals(sPhaseType) || ("1160".equals(sPhaseType))){
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20); 
	//删除当前的业务信息 
	if(sObjectType.equals("CreditApply")|| sObjectType.equals("ProductApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	}else if(sObjectType.equals("Reserve")){
		//增加减值准备删除的操作逻辑，add by syang 2009-10-10
		dwTemp.setEvent("AfterDelete","!ReserveManage.ReserveCancelApply(#ObjectNo)+!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteReserve)");
	}else if(sObjectType.equals("Classify")){
		//增加删除五级分类删除的操作逻辑，add by cbsu 2009-10-12
        dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteClassify)");
	}else if(sObjectType.equals("TransformApply")){
        //增加删除担保合同变更的操作逻辑
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteGuarantyTransform)");
	}else{
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sApplyType+"','"+sPhaseType+"','"+CurUser.getUserID()+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	if(sApplyType.equals("PutOutApply")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeletePutoutTask)");
	}
	
	//add by qfang 2011-6-8 取消支付申请
	if(sApplyType.equals("PaymentApply")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeletePaymentApply)");
	}
	//add end
	
	//out.println("-------sql"+doTemp.SourceSql); //常用这句话调试datawindow装载数据的SQL语句
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
	//0.是否显示
	//1.注册目标组件号(为空则自动取当前组件)
	//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.按钮文字
	//4.说明文字
	//5.事件
	//6.资源图片路径
	String sSql11="select userType from user_info where userID=:userID and isCar='02'";
	ASResultSet rs11=Sqlca.getASResultSet(new SqlObject(sSql11).setParameter("userID",CurUser.getUserID()));
	if(rs11.next()){
		userType=rs11.getString("userType");
	}
	rs11.getStatement().close();
	
	//获取销售门店运作模式    add by phe
    String operatemode="";
    String sSql2="select operatemode from store_info where sno=:sNo";
	 rs11=Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("sNo",sSNo));
	if(rs11.next()){
		operatemode=rs11.getString("operatemode");
	}
	rs11.getStatement().close();
	
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//用于控制单行按钮显示的最大个数
	String iButtonsLineMax = "8";
	//add 在有权限的销售代表名单里面的销售代表做单时给予显示原地复活的按钮；若不在此名单内，不要显示原地复活的按钮。 by hhuang 20150630
	String Serialno = "";
	sSql11="select * from Reconsider_Quota_Record r where r.saleid=:userID ";
	rs11=Sqlca.getASResultSet(new SqlObject(sSql11).setParameter("userID",CurUser.getUserID()));
	if(rs11.next()){
		Serialno = rs11.getString(1);
	}
	rs11.getStatement().close();
	/********二段式提单开关***************************/
	sSql = 	" select t.switch_status from SYSTEM_SWITCH t where t.switch_type ='PRETRIAL_ENABLE'";
	rs = Sqlca.getASResultSet(new SqlObject(sSql));
    if(rs.next()){
    	switch_status = rs.getString("switch_status");
    }else{
        throw new Exception("预审申请异常，请联系管理员！");
    }
    rs.getStatement().close();
    /**************************end**************/
	//根据按钮集从代码表CODE_LIBRARY中查询到按钮英文名称，属性1，属性2（Button）、按钮中文名称、按钮功能描述、按钮调用javascript函数名称
	sSql = 	" select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode "+
			" from CODE_LIBRARY where CodeNo =:CodeNo and IsInUse = '1' Order by SortNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sButtonSet)); 
	while(rs.next()){
		iCountRecord++;
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		//sButtons[iCountRecord][0] = "true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sApplyType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		}
		sButtons[iCountRecord][6] = sResourcesPath;
		//add sy syang 2009/10/22 放贷复核通过的申请，在演示模式下，“转入贷后”按钮可见
		if(sApplyType.equals("PutOutApply")){
			if("transToAfterLoan".equals(rs.getString("ItemNo"))){	//匹配按钮
				if(sButton.indexOf(rs.getString("ItemNo"))>=0){ //是否允许显示
					if("Demonstration".equals(sCurRunMode)||"Development".equals(sCurRunMode)){			//允许显示后，判断是否为演示模式
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
		}
		if(sApplyType.equals("IndependentApply") || sApplyType.equals("CreditLineApply") || sApplyType.equals("DependentApply")){
			if("greenWay".equals(rs.getString("ItemNo"))||"viewFlowGraph".equals(rs.getString("ItemNo"))){	//匹配按钮
				if(sButton.indexOf(rs.getString("ItemNo"))>=0){ //是否允许显示
					if("Demonstration".equals(sCurRunMode)){			//只有在演示模式下才显示绿色通道和查看流程图按钮
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
		}
		if(!userType.equals("01") && "doRegistration".equals(rs.getString("ItemNo"))){
			sButtons[iCountRecord][0] = "false";
		}
		if("doSign".equals(rs.getString("ItemNo"))){
			sButtons[iCountRecord][0] = "false";
		}
		if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("03")){
			sButtons[iCountRecord][0] = "true";
		}else if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("02")){
			sButtons[iCountRecord][0] = "false";
		}else if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("01")){
			sButtons[iCountRecord][0] = "false";
			sButtons[iCountRecord-1][0] = "true";			
		}else if(userType.equals("02")&&sButton.indexOf(rs.getString("ItemNo"))>=0&&"doSign".equals(rs.getString("ItemNo"))&&operatemode.equals("04")){//add by phe 20150318 CCS-543
			sButtons[iCountRecord][0] = "true";
		}
		//add 在无权限的销售代表名单里面的销售代表做单时给予不显示原地复活的按钮、把产品子类型为4和5的审批拒绝列表的原地复活按钮进行隐藏，让销售代表看不到就可以 by hhuang 20150708
		if(Serialno==null || "".equals(Serialno) || "StuEducation".equals(stuApplyType) || "AdultEducation".equals(stuApplyType)){
			if("ReconsiderSubmit".equals(rs.getString("ItemNo"))){
				sButtons[iCountRecord][0] = "false";
			}
		}		
		//add CCS-1256 佰保袋打印合同服务 教育贷隐藏“打印佰保袋合同”按钮 by fangxq 20160229
		if("StuEducation".equals(stuApplyType) || "AdultEducation".equals(stuApplyType)){
			if("printBaiBaoDai".equals(rs.getString("ItemNo"))){
				sButtons[iCountRecord][0] = "false";
			}
		}
		//end 
		/********二段式提单开关***************************/
		if("1".equals(switch_status) && "新增申请".equals(sButtons[iCountRecord][3])){
			if(("CarCashLoanApply".equals(sApplyType)||"CashLoanApply".equals(sApplyType))){
				if("1010".equals(sPhaseType) ){
					sButtons[iCountRecord][0]="true"; 
				}else{
					sButtons[iCountRecord][0]="false"; 
				}
			}else{
				sButtons[iCountRecord][0]="false"; 
			}
		}
		/**************************end**************/
	}
	rs.getStatement().close();
	
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>