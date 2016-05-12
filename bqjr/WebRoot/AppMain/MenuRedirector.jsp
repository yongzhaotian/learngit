<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	//取系统名称
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";
	
	String sTitle = CurPage.getParameter("Title");
	String sUrl = CurPage.getParameter("Url");
	String sParas = CurPage.getParameter("Paras");
	if(sParas == null) sParas = "";
%>
<html>
<head>
<title><%=sImplementationName%></title>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground"
	style="overflow: auto; overflow-x: visible; overflow-y: visible">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
			<td valign="bottom" class="mytop">
				<%@include file="/MainTop.jsp"%>
			</td>
		</tr>
		<tr>
			<td valign="top">
			<iframe width="100%" height="100%" name="MainCenter" frameBorder="0" src="<%=sWebRootPath%>/AppMain/MenuMain.html"></iframe>
			</td>
		</tr>
	</table>
</body>
<script type="text/javascript">
<%if(sUrl != null){%>
	AsControl.OpenView("/AppMain/MenuTabContainer.jsp", "Title=<%=sTitle%>&Url=<%=sUrl%>&Paras=<%=sParas%>", "MainCenter");
<%}%>
</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>