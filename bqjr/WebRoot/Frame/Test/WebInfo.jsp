<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<jsp:directive.page import="java.text.SimpleDateFormat"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>应用服务器信息</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<script>
	function IEMsg()
	{
		var msg = "";
		msg = msg + "\n版本：";
		msg = msg + "\n"+"navigator.appVersion="+navigator.appVersion;
		msg = msg + "\n"+"navigator.appName="+navigator.appName;
		msg = msg + "\n"+"navigator.userAgent="+navigator.userAgent;
		msg = msg + "\n";

		msg = msg + "\n分辨率：";
		msg = msg + "\n"+"window.screen.width="+window.screen.width;
		msg = msg + "\n"+"window.screen.height="+window.screen.height;
		msg = msg + "\n"+"window.screen.availWidth="+window.screen.availWidth;
		msg = msg + "\n"+"window.screen.availHeight="+window.screen.availHeight;
		msg = msg + "\n";

		msg = msg + "\n技术参数：";
		msg = msg + "\n"+"event.screenX="+event.screenX;
		msg = msg + "\n"+"top.screenLeft="+top.screenLeft;
		msg = msg + "\n"+"top.document.documentElement.scrollWidth="+top.document.documentElement.scrollWidth;
		msg = msg + "\n"+"event.screenY="+event.screenY;
		msg = msg + "\n"+"event.clientY="+event.clientY;
		msg = msg + "\n"+"event.screenY-clientY="+(event.screenY-event.clientY);
		msg = msg + "\n"+"top.screenTop="+top.screenTop;
		msg = msg + "\n"+"top.document.documentElement.scrollHeight="+top.document.documentElement.scrollHeight;
		msg = msg + "\n";
		msg = msg + "\n"+"top.screenTop="+top.screenTop;
		msg = msg + "\n"+"parent.screenTop="+parent.screenTop;
		msg = msg + "\n"+"window.screenTop="+window.screenTop;

		msg = msg + "\n";				
		msg = msg + "\n"+"event.altKey="+event.altKey;
		msg = msg + "\n"+"parent.location="+parent.location;
		alert(msg); 
	}
</script>
</head>
<%!
String getTime() {
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
	return sdf.format(cal.getTime());
}
%> 
  <body>
  <h2>应用服务器信息<h2>
  <p>当前时间:<%=getTime() %> <p>
  <p>应用服务器:<%=application.getServerInfo() %> <p>
  <p>应用服务器WebApp版本:<%=application.getMajorVersion() %>.<%=application.getMinorVersion() %><p>
  <p>应用名称:<%=application.getServletContextName() %> <p>
  <p>应用文件路径:<%=application.getRealPath("") %> <p>
  <p>请求上下文路径:<%=request.getContextPath() %> <p>
  <p>请求URL:<%=SpecialTools.amarsoft2Real(request.getRequestURL()) %> <p>
  <p>Session状态:<%=session.isNew() %> <p>
  <p><a onclick= "javascript:IEMsg();">浏览器信息</a><p>
  </body>
</html>