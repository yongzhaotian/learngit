<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: --审批流程配置主界面
	*/
	String PG_TITLE = "审批流程管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;审批流程管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度,不显示树图
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	//myleft.width=1;
	OpenComp("FlowCatalogList","/Common/Configurator/FlowManage/FlowCatalogList.jsp","ComponentName=审批流程管理","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>