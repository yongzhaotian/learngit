<%@
page contentType="text/html; charset=GBK"%><%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);
String sTextToShow  = request.getParameter("TextToShow");
if(sTextToShow == null || sTextToShow.length() == 0) sTextToShow = "";
else sTextToShow = java.net.URLDecoder.decode(sTextToShow,"UTF-8");
%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<body>
<table><tr><td><span style="font-size:12px;"><%=sTextToShow%></span></td></tr></table>
</body>
</html>