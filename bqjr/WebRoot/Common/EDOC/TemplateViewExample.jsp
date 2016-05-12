<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.edoc.EDocument"%>
<%@ include file="/IncludeBegin.jsp"%>


<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>

</body>
</html>
<%
	String sEDocNo = DataConvert.toString((String)CurComp.getParameter("EDocNo"));
	String sContentType = Sqlca.getString("select ContentTypeFmt from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
	String sFullPathFmt = Sqlca.getString("select FullPathFmt from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
	String sFullPathDef = Sqlca.getString("select FullPathDef from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
	int index = sFullPathFmt.indexOf('.');
	String sOutName = sFullPathFmt.substring(0,index-1)+"OUT"+sFullPathFmt.substring(index);
	System.out.println("OutName:"+sOutName);
	EDocument edoc = new EDocument(sFullPathFmt,sFullPathDef);
	edoc.saveAsDefault(sOutName);
%>

<form name=form1 method=post action=<%=sWebRootPath%>/fileview>
	<div style="display:none">
		<input name=filename value="<%=sOutName%>">
		<input name=contenttype value="<%=sContentType%>">
		<input name=viewtype value="view">		
	</div>
</form>

<script language=javascript>
	form1.submit();
</script>
	
<%@ include file="/IncludeEnd.jsp"%>
