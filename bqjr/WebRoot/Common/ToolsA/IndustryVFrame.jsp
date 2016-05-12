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
	String sIndustryType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("IndustryType"));
%>
<%/*~END~*/%>


 

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Frame02;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Frame03.jsp"%>
<%/*~END~*/%>
 




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Frame03;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Frame04;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	myleft.width=340;
	OpenPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryType=<%=sIndustryType%>","frameleft","");
	OpenPage("/Blank.jsp?TextToShow=请在左方列表中选择一项","frameright","");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
