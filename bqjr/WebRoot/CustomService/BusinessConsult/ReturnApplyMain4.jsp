<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "保险金审批"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;保险金审批&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请稍后";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y003","right","");
		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	