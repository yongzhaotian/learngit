<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sOrigDocID = CurPage.getParameter("DocID");
	String sDocID = FormatToolManager.getTrueDocId(sObjectType,sObjectNo,sOrigDocID);//�ҵ����ʰ汾��DOCID
	String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//�ų��Ľڵ�
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
	setDialogTitle("<table border=0 cellspacing=0 cellpadding=0><tr><td width=100>�鿴</td>"+
		"<td><input type=\"button\" value=\"���Ƶ�ճ����\" alt=\"AutoCopy\" onClick=\"autoCopy()\"/></td>"+
		"<td>&nbsp;</td>"+
		"<td><input type=\"button\" value=\"������Word\" alt=\"ExportToWord\" onClick=\"exportToWord()\"/></td>"+
		"<td>&nbsp;</td>"+
		"<td><input type=\"button\" value=\"������Pdf\" alt=\"������Pdf\" onClick=\"exportToPdf('<%=sOrigDocID%>','<%=sObjectNo%>','<%=sObjectType%>')\"/></td>"+
		"<td>&nbsp;</td>"+
		"<td><input type=\"button\" value=\"��ӡ\" alt=\"��ӡ\" onClick=\"if(/mozilla/.test(navigator.userAgent.toLowerCase()) && !/(compatible|webkit)/.test(navigator.userAgent.toLowerCase())) {ObjectList.print();} else ObjectList.document.execCommand('Print');\"/></td>"+
		"</tr></table>");
	form1.submit();
</script>
<%@ include file="/IncludeEnd.jsp"%>