<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	String sSerialNo = DataConvert.toString((String)CurComp.getParameter("SerialNo"));

    String sFullPath = Sqlca.getString("select FullPath from EDOC_PRINT where SerialNo='"+sSerialNo+"'");
    String sContentType = Sqlca.getString("select ContentType from EDOC_PRINT where SerialNo='"+sSerialNo+"'");
 	System.out.println(sFullPath);System.out.println(sContentType);
	String sViewType="view"; //"view" or "save"
	if(sViewType.equals("view"))
	{
%>

<form name=form1 method=post action=<%=sWebRootPath%>/fileview>
	<%=sFullPath%>
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