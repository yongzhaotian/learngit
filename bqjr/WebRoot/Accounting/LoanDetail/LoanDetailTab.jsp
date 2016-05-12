<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xjzhao 2013-03-27
		Tester:
		Content: 贷款账户信息展示
		Input Param:
                ObjectNo：对象编号 
                ObjectType：对象类型 
		Output param:
		History Log: 
	 */
	 
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sTitle = "";
	//获得组件参数	
	//获得页面参数	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sViewID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewID"));
	if (sObjectNo == null) sObjectNo = "";
	if (sObjectType == null) sObjectType = "";
	if (sViewID == null) sViewID = "002";
	%>
<%/*~END~*/%>     

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script type="text/javascript">
	OpenPage("/Accounting/LoanDetail/AcctLoanList.jsp?ContractSerialNo=<%=sObjectNo%>","_self","");
</script>
<%/*~END~*/%>
<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground" style="margin:0;padding:0;";>
<div id="tab06_code_part" style="border:0px solid #F00;z-index:-1;width:100%;height:100%;padding:0,0.5%">&nbsp;</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>

