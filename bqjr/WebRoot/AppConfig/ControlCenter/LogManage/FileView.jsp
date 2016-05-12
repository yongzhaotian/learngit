<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/AppMain/Blank.html"  width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
<%
	String sFile = java.net.URLDecoder.decode(CurPage.getParameter("file"),"UTF-8"); //ÎÄ¼şÃû
	String sViewType = CurPage.getParameter("ViewType");
	if(sViewType == null) sViewType = "view"; //"view" or "save"
	if(sViewType.equals("view")){
%>
<form name=form1 method=post action="<%=sWebRootPath%>/servlet/view/file">
	<div style="display:none">
		<input name="filename" value="<%=sFile%>">
	</div>
</form>
<script type="text/javascript">
	form1.submit();
</script>
<%}else{%>	
<form name=form1 method=post action="<%=sWebRootPath%>/servlet/view/file" target=MyAtt>
	<div style="display:none">
		<input name="filename" value="<%=sFile%>">
	</div>
</form>
<script type="text/javascript">
	form1.submit();
</script>
<%}%>
<%@ include file="/IncludeEnd.jsp"%>