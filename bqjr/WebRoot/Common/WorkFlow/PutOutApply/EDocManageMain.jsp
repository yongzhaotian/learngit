<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明:隐藏左侧区域的Main页面--
	 */
	String PG_TITLE = "电子合同管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;电子合同管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "0";//默认的treeview宽度

	//获得页面参数

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	myleft.width=1;
	AsControl.OpenComp("Common/WorkFlow/PutOutApply/EDocMangeForPad.jsp","","right","");
	// AsControl.OpenView("Common/WorkFlow/PutOutApply/EDocMangeForPad.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>