<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 工作计划笔记框架(美化工作台)
	 */
	String PG_TITLE = "工作计划笔记"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;工作计划笔记&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	String myleft_top_WIDTH = "0";//默认的treeview宽度
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript">
	//屏蔽左侧区域
	myleft.width=1;
	OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","NoteType=All","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>