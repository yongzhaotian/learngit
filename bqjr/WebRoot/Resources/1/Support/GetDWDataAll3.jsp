<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Resources/Include/IncludeBeginDWAJAX.jspf"%>
<%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));
	if(sType==null || sType.equals("") || sType.equals("null")) sType = "export";   //print,export

	String sURLName = "";
	if(sDWName!=null && !sDWName.equals("")){
		ASDataWindow dwTemp = Component.getDW(sSessionID);
		sURLName = dwTemp.genHTMLAllEx(Sqlca,request,"",65535);		
	}
%>
<html>
<head>
<title>«Î…‘∫Ú...</title>
</head>
<body>
<!--  
<a id=mydownload name=mydownload href="<%=sWebRootPath%><%=sURLName%>" >œ¬‘ÿ</a>
-->
<iframe name="MyAtt" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"’˝‘⁄œ¬‘ÿ£¨«Î…‘∫Ú...")%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
<form name=form1 method=post action=<%=sWebRootPath%>/servlet/view/file target=MyAtt>
	<div style="display:none">
		<input name=filename value="<%=sURLName%>">
		<input name=contenttype value="application/x-zip-compressed">
		<input name=viewtype value="download">
	</div>
</form>

</body>
</html>
<script type="text/javascript">
	/*
	mydownload.click();  //window.open("<%=sWebRootPath%><%=sURLName%>");	
	*/
	form1.submit();
	
	setTimeout('closeTop();',2000);	
	function closeTop()
	{
		top.close();
	}

</script>
<%@ include file="/Resources/Include/IncludeTail.jspf"%>