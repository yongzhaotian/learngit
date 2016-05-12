<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "账户信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String status = DataConvert.toRealString(iPostChange,CurPage.getParameter("Status"));
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	
	BusinessObject bo = AbstractBusinessObjectManager.getBusinessObject(sObjectType,sObjectNo,Sqlca);

	//显示模版编号
	String sTempletNo = "DepositAccountsList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+bo.getObjectType());
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	

	String sButtons[][] = {
			{"true", "", "Button", "新增放款帐号", "新增一条放款帐号信息","createRecord('00')",sResourcesPath},
			{"true", "", "Button", "新增还款帐号", "新增一条还款帐号信息","createRecord('01')",sResourcesPath},
			{"true", "", "Button", "新增其他帐号", "新增一条其他帐号信息","createRecord('99')",sResourcesPath},
			{"true", "", "Button", "详情", "费用详情","viewFee()",sResourcesPath},
			{"true", "", "Button", "删除", "删除一条信息","deleteRecord()",sResourcesPath},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[4][0]="false";
	}
	if(sObjectType.equals("jbo.app.ACCT_LOAN_CHANGE" ) || sObjectType.equals("jbo.app.ACCT_FEE" )){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function createRecord(AccountIndicator){
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&AccountIndicator="+AccountIndicator,"_self","");
		//reloadSelf();
		}
	
	function viewFee(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo="+SerialNo,"_self","");
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确定删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	
	//初始化
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>