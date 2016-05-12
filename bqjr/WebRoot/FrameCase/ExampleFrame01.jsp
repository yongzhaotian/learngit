<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例上下框架页面
	 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/FrameCase/ExampleList.jsp","","rightup","");
	AsControl.OpenView("/FrameCase/ExampleList.jsp","","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>