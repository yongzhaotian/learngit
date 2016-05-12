<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	String sEDocNo = DataConvert.toString((String)CurComp.getParameter("EDocNo"));
    String sEDocType = DataConvert.toString((String)CurComp.getParameter("EDocType"));

    String sFullPath = Sqlca.getString("select FullPath"+sEDocType+" from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
    String sContentType = Sqlca.getString("select ContentType"+sEDocType+" from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");

	String sViewType="view"; //"view" or "save"
	if(sViewType.equals("view"))
	{
%>

<form name=form1 method=post action=<%=sWebRootPath%>/fileview>
	<div style="display:none">
		<input name=filename value="<%=sFullPath%>">
		<input name=contenttype value="<%=sContentType%>">
		<input name=viewtype value="view">		
	</div>
</form>

<script language=javascript>
	form1.submit();
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>