<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sTitle = CurPage.getParameter("Title");
	String sUrl = CurPage.getParameter("Url");
	String sParas = CurPage.getParameter("Paras");
	if(sTitle == null) sTitle = "";
	if(sParas != null) sParas = sParas.replace("~", "&");
	String sTabStrip[][] = {
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%if(sUrl != null){%>
<script type="text/javascript">
	addTabStripItem("<%=sTitle%>", "<%=sUrl%>", "<%=sParas%>");
</script>
<%}%>
<%@ include file="/IncludeEnd.jsp"%>