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
    <title>Ӧ�÷�������Ϣ</title>
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
		msg = msg + "\n�汾��";
		msg = msg + "\n"+"navigator.appVersion="+navigator.appVersion;
		msg = msg + "\n"+"navigator.appName="+navigator.appName;
		msg = msg + "\n"+"navigator.userAgent="+navigator.userAgent;
		msg = msg + "\n";

		msg = msg + "\n�ֱ��ʣ�";
		msg = msg + "\n"+"window.screen.width="+window.screen.width;
		msg = msg + "\n"+"window.screen.height="+window.screen.height;
		msg = msg + "\n"+"window.screen.availWidth="+window.screen.availWidth;
		msg = msg + "\n"+"window.screen.availHeight="+window.screen.availHeight;
		msg = msg + "\n";

		msg = msg + "\n����������";
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
  <h2>Ӧ�÷�������Ϣ<h2>
  <p>��ǰʱ��:<%=getTime() %> <p>
  <p>Ӧ�÷�����:<%=application.getServerInfo() %> <p>
  <p>Ӧ�÷�����WebApp�汾:<%=application.getMajorVersion() %>.<%=application.getMinorVersion() %><p>
  <p>Ӧ������:<%=application.getServletContextName() %> <p>
  <p>Ӧ���ļ�·��:<%=application.getRealPath("") %> <p>
  <p>����������·��:<%=request.getContextPath() %> <p>
  <p>����URL:<%=SpecialTools.amarsoft2Real(request.getRequestURL()) %> <p>
  <p>Session״̬:<%=session.isNew() %> <p>
  <p><a onclick= "javascript:IEMsg();">�������Ϣ</a><p>
  </body>
</html>