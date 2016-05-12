<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "预审信息";
	 
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PretrialInfoList";//公告模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    doTemp.WhereClause = " where State <> '001' and inputuserid='"+CurUser.getUserID()+"'";
	
	
    
	doTemp.generateFilters(Sqlca);
	//控制登记日期查询条件选项
	doTemp.setFilter(Sqlca, "0350", "InputDate", "Operators=BetweenString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);

	// 没有输入任何条件，只能查询查询当天数据
	if(!doTemp.haveReceivedFilterCriteria()) {
		doTemp.WhereClause += " and (to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD')-to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))=0";
	} else {
		//有输入任何条件，只能查询3个月内的数据
	    doTemp.WhereClause += " and months_between(to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD'),to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))<=3";
	}
	
	//控制特殊字符输入
	for(int k=0;k<doTemp.Filters.size();k++){
		
		//输入的条件都不能含有%或_符号
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
				&& (doTemp.Filters.get(k).sFilterInputs[0][1].contains("%") 
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("_")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("#")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("$"))){
			%>
			<script type="text/javascript">
				alert("输入的条件不能含有['%'、'_'、'#'、'$']符号!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);//设置分页数量
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","提交下一步","提交产品界面","submit()",sResourcesPath},
		{"true","","Button","取消数据","取消该笔信息","cancelData()",sResourcesPath},
	};
	
	//用于控制单行按钮显示的最大个数  
	String iButtonsLineMax = "5";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = ""; //存放SQL语句
	ASResultSet rs = null; //存放查询结果集
	String sPhaseTypeSet = ""; //存放阶段类型组
	String sObjectType = ""; //存放对象类型
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	
	//获得组件参数:申请类型,阶段类型
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String transactionFilter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransactionFilter",10));
	String stuApplyType= DataConvert.toRealString(iPostChange,(CurComp.getParameter("subApplyType")));
	//将空值转化成空字符串
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(transactionFilter == null) transactionFilter = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
    //销售门店
    String sSNo = CurUser.getAttribute8();
    if(sSNo == null) sSNo = "";
    
    
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得ApplyMain的树图以及该申请的阶段,流程对象类型,ApplyList使用哪个ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
	}else{
		throw new Exception("没有找到相应的申请类型定义（CODE_LIBRARY.ApplyType:"+sApplyType+"）！");
	}
	rs.getStatement().close();
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
	%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=取消 */%>
	function cancelData(){
		var SERIALNO = getItemValue(0,getRow(),"SERIALNO");
		var STATE    = getItemValue(0,getRow(),"STATE");
		if (typeof(SERIALNO)=="undefined" || SERIALNO.length==0){
			alert("请选择一条记录！");
			return;
		}else{
			if(STATE=="002"){
				if (confirm("你确定要取消该笔预审申请吗？")) {
					RunMethod("公用方法", "UpdateColValue", "Pretrial_Info,STATE,005,SERIALNO='"+SERIALNO+"'");
				}
			}else{
					alert("只能取消预审通过的数据！");
			}
		}
		reloadSelf();	
	}
	<%/*~[Describe=提交下一步  */%>
	function submit(){
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sState = getItemValue(0,getRow(),"STATE");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录！");
			return;
		}else{
			if(sState=="002"){
			var SERIALNO = getItemValue(0,getRow(),"SERIALNO");
			var CustomerID = getItemValue(0,getRow(),"CustomerID");
			var CustomerName = getItemValue(0,getRow(),"CustomerName");
			var CertID = getItemValue(0,getRow(),"CertID");
			var MobileTelephone = getItemValue(0,getRow(),"MobileTelephone");
			var WorkCorp = getItemValue(0,getRow(),"WorkCorp");
			var SelfMonthIncome = getItemValue(0,getRow(),"SelfMonthIncome");
			var RelativeType = getItemValue(0,getRow(),"RelativeType");
			var KinshipName = getItemValue(0,getRow(),"KinshipName");
			var KinshipTel = getItemValue(0,getRow(),"KinshipTel");
			var Contactrelation = getItemValue(0,getRow(),"Contactrelation");
			var OtherContact = getItemValue(0,getRow(),"OtherContact");
			var ContactTel = getItemValue(0,getRow(),"ContactTel");
			var InteriorCode = getItemValue(0,getRow(),"InteriorCode");

			//将jsp中的变量值转化成js中的变量值
			var sObjectType = "<%=sObjectType%>";	
			var sApplyType = "<%=sApplyType%>";	
			var ssSubApplyType="<%=stuApplyType%>";
			var sPhaseType = "<%=sPhaseType%>";
			var sInitFlowNo = "<%=sInitFlowNo%>";
			var sInitPhaseNo = "<%=sInitPhaseNo%>";


			var sUserID = "<%=CurUser.getUserID()%>";
			// add by xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
			//var sStore = RunMethod("BusinessManage","getStore",sUserID);
			var sSno = "<%=CurUser.getAttribute8()%>";
			var sStore = RunMethod("BusinessManage","getStoreNew",sSno);
			// end by xswang 2015/06/01
			var ssCity=RunMethod("GetElement","GetElementValue","city,user_info,userid='"+sUserID+"'");
			
			if(typeof(sStore)=="undefined" || sStore.length==0 || sStore == "Null"){
				alert("选择做单门店为空，请在主页按钮旁边点击门店选择门店重新选择门店！");
				return;
			}
			var subProductType=null;
			if(sApplyType == "CreditLineApply"){
				if(ssSubApplyType=="StuEducation"){//进入学生教育贷
					subProductType = 5;
				}else if("AdultEducation"==ssSubApplyType){//进入成人教育贷
					subProductType = 4;
				}else if("ssSubApplyType"==ssSubApplyType){//进入学生消费
					subProductType = 7;
				}else{
					subProductType = 0;//进入普通消费贷
				}
			}else if (sApplyType == "NoOrderdCashApply"){//进入无预约现金贷
					subProductType = 2;
			}
			
			if(confirm("当前登录所在门店为：\n\r"+sStore+"\n\r是否确认在该门店发起申请？")){
				var rValues=RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getCreditID", "ProductType="+subProductType+",citys="+ssCity);
				 if(rValues=="false"){
					alert("该城市下产品类型为消费贷没有相关贷款人！");
					return;
				} 
				//弹出新增申请参数对话框
				if(sApplyType == "CreditLineApply"){
					if(ssSubApplyType=="StuEducation"){//进入学生教育贷
						sCompID = "CreditLineApplyCreationInfo";
						sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
						subProductType="5";
					} else if("AdultEducation"==ssSubApplyType){//进入成人教育贷
						sCompID = "CreditLineApplyCreationInfo";
						sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
						subProductType="4";
					}else if( "StuPos" == ssSubApplyType ){//学生消费贷   add by dahl
						sCompID = "CreditStuPosApplyCreationInfo";
						sCompURL = "/CreditManage/CreditApply/CreditStuPosApplyCreationInfo.jsp";	 
						subProductType="7";
					}else{//普通消费贷
				 		sCompID = "CreditLineApplyCreationInfo";
						sCompURL = "/CreditManage/CreditApply/CreditLineApplyCreationInfo.jsp";	 
					}
				}else if (sApplyType == "NoOrderdCashApply"){//进入无预约现金贷
					sCompID = "NoOrderdCashApplyInfo";
					sCompURL = "/CreditManage/CashLoan/NoOrderdCashApplyInfo.jsp";	 
					subProductType="2";
				}else{
					sCompID = "CreditApplyCreation";
					sCompURL = "/CreditManage/CreditApply/CreditApplyCreationInfoAll.jsp";
				}
				 var ParamString="ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo+"&SubProductType="+subProductType
				     +"&SERIALNO="+SERIALNO+"&CustomerID="+CustomerID+"&CustomerName="+CustomerName+"&CertID="+CertID+"&MobileTelephone="+MobileTelephone+"&WorkCorp="+WorkCorp
			         +"&SelfMonthIncome="+SelfMonthIncome+"&RelativeType="+RelativeType+"&KinshipName="+KinshipName+"&KinshipTel="+KinshipTel+"&Contactrelation="+Contactrelation+"&OtherContact="+OtherContact+"&ContactTel="+ContactTel+"&InteriorCode="+InteriorCode;
				sReturn = popComp(sCompID,sCompURL,ParamString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];

				//add by qfang 增加判断：如果为"贷款新规适用产品"，则弹出页面，显示业务品种分类的三个标志位字段
				sObjectType=sReturn[1];	
				if(sReturn[2] != null){ 
					sTypeNo=sReturn[2];
					sSortReturn = RunMethod("CreditLine","CheckProductSortFlag",sTypeNo);
					if(sSortReturn.split("@")[0] == "true"){
						popComp("SortFlagInfo","/CreditManage/CreditApply/SortFlagInfo.jsp","TypeNo="+sTypeNo+"&ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");		
					}
				} 
				//add end
				
		         //根据新增申请的流水号，打开申请详情界面
				sCompID = "CreditTab";
				sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
				sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); 
			}
			reloadSelf();	
			}else{
				alert("只允许预审通过的数据提交下一步！");
			}
		}
	}
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newApply(){
			
	}
	
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>