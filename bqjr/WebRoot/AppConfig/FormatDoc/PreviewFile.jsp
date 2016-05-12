<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sOrigDocID = CurPage.getParameter("DocID");
	String sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sOrigDocID);//找到合适版本的DOCID
	String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//排除的节点
	IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,sExcludeDirIds);
	String sFileName = formatTool.getFullFileName(sObjectType,sObjectNo,sDocID );
%>
<body>
<br/><br/>
	<form name=form1 method=post target="_self" action=<%=sWebRootPath%>/servlet/view/file >
		<div style="display:none">
			<input name=filename value="<%=sFileName%>">
			<input name=contenttype value="text/html">
			<input name=viewtype value="view">
		</div>
	</form>
</body>
<script type="text/javascript">
	setDialogTitle("<table border=0 cellspacing=0 cellpadding=0><tr><td width=100>查看</td>"+
		"<td><input type=\"button\" value=\"复制到粘贴板\" alt=\"AutoCopy\" onClick=\"autoCopy()\"/></td>"+
		"<td>&nbsp;</td>"+
		"<td><input type=\"button\" value=\"导出到Word\" alt=\"ExportToWord\" onClick=\"exportToWord()\"/></td>"+
		"<td>&nbsp;</td>"+
		"<td><input type=\"button\" value=\"导出到Pdf\" alt=\"导出到Pdf\" onClick=\"exportToPdf('<%=sOrigDocID%>','<%=sObjectNo%>','<%=sObjectType%>')\"/></td>"+
		"<td>&nbsp;</td>"+
		"<td><input type=\"button\" value=\"打印\" alt=\"打印\" onClick=\"if(/mozilla/.test(navigator.userAgent.toLowerCase()) && !/(compatible|webkit)/.test(navigator.userAgent.toLowerCase())) {ObjectList.print();} else ObjectList.document.execCommand('Print');\"/></td>"+
		"</tr></table>");
	form1.submit();
</script>
<%@ include file="/IncludeEnd.jsp"%>