<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "角色管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;角色管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	OpenComp("RoleList","/AppConfig/RoleManage/RoleList.jsp","","right");			
</script>
<%@ include file="/IncludeEnd.jsp"%>