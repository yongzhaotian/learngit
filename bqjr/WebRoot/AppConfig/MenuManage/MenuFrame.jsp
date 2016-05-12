<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 左右框架页面
 */
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">
	myleft.width=500;
	AsControl.OpenView("/AppConfig/MenuManage/MenuTree.jsp","","frameleft","");
	//AsControl.OpenView("/Blank.jsp","TextToShow=请在左侧选择一项","frameright","");
</script>
<%@ include file="/IncludeEnd.jsp"%>