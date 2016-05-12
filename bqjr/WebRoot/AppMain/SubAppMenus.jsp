<%@page import="com.amarsoft.web.ui.mainmenu.AmarMenu"%>
<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
   	String sAppID = CurPage.getParameter("AppID");
	AmarMenu menu = new AmarMenu(CurUser,sAppID);
	String sAllMenu = menu.getMenusFromSubSys(sAppID);
%>
<html>
<head>
<title>子系统菜单</title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/AppMain/resources/css/page.css">
<link rel="stylesheet" type="text/css" href="<%=sSkinPath%>/css/page.css">
<script type="text/javascript">
	$(function(){
		var li = $(".sub_menu_bar >li");
		var max = 0;
		for(var i = 0; i < li.length; i++){
			var height = $(li[i]).height();
			if(max < height) max = height;
		}
		li.height(max);
	});
</script>
</head>
<body><%=sAllMenu%></body>
</html>
<%@ include file="/IncludeEnd.jsp"%>