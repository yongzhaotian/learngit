<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明:隐藏左侧区域的Main页面--
	 */
	String PG_TITLE = "预约现金贷准入客户名单"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;预约现金贷准入客户名单&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度

	//获得页面参数

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	AsControl.OpenView("/BusinessManage/ResCashAccess/ResCashAccessList.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>