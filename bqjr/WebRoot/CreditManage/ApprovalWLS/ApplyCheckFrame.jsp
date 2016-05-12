<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Frame00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 示例上下框架页面
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Frame01;Describe=定义变量，获取参数;]~*/%>
<%
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Frame02;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Frame03;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Frame04;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	OpenPage("/CreditManage/ApprovalWLS/ApplyInfoList.jsp?OrgID=<%=sOrgID%>","rightup","");
	OpenPage("/Blank.jsp?TextToShow=请在上方列表中选择一项111","rightdown","");

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
