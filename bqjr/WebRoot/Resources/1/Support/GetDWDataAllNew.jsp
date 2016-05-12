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
<a id=mydownload name=mydownload href="<%=sWebRootPath%><%=sURLName%>" >œ¬‘ÿ</a>
</body>
</html>
<script type="text/javascript">
	mydownload.click();  //window.open("<%=sWebRootPath%><%=sURLName%>");	

	setTimeout('closeTop();',1000);	
	function closeTop(){
		//top.close();
		parent.myhide('myiframe0');
	}
</script>
<%@ include file="/Resources/Include/IncludeTail.jspf"%>