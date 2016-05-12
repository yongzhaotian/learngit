<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>SessionOut</title>
</head>
<%	
	/* String sCurUserId = (String)session.getAttribute("CurUserId");
	Map<String, String> userMap = (HashMap<String, String>)application.getAttribute("AmarsoftUserMap");
	System.out.println("xxx: " + userMap.keySet().contains(sCurUserId));
	if (userMap!=null && userMap.keySet().contains(sCurUserId)) userMap.remove(sCurUserId);
	application.setAttribute("AmarsoftUserMap", userMap); */ 
	
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	session.invalidate(); 
	%>
<script type="text/javascript">
if(navigator.userAgent.toLowerCase().indexOf("msie 6")>-1)
{
	window.opener = null;
	window.close();
}
else
	window.open("<%=request.getContextPath()%>/index.html","_top","");
</script>
<body>
</body>
</html>