<%@page import="com.amarsoft.web.ui.mainmenu.AmarMenu"%>
<script type='text/javascript' src='<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.bgiframe.js'></script>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/menu.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/menu.css">
<%
String sMenuBarId = "ASMenuBar";
String sMenuBar = (String) session.getAttribute(sMenuBarId);
//如果在session中找不到主菜单，则重新生成一个新的
if (sMenuBar == null || sMenuBar.length() <= 0) {
	String sApproveNeed = CurConfig.getConfigure("ApproveNeed");
	ArrayList<String> ExcludeIDs = new ArrayList<String>();
	if ("false".equalsIgnoreCase(sApproveNeed)) {
		ExcludeIDs.add("300030");
		ExcludeIDs.add("300040");
	}
	AmarMenu menu = new AmarMenu(CurUser, ExcludeIDs);
	sMenuBar = menu.genMenuBar(sMenuBarId);
	session.setAttribute(sMenuBarId, sMenuBar); //存入session
}


%>
<script type="text/javascript">
	function showMenu(a, e){
		var ul = a.nextSibling;
		if(!ul || ul.tagName != "UL") return;
		window.clearTimeout(ul.time);
		ul.style.display = "block";
		var zIndex = Math.ceil(new Date().getTime()/1000);
		a.parentNode.style.zIndex = zIndex;
		ul.style.zIndex = zIndex;
		ul.className = "";
		var stateX = a.offsetWidth + ul.offsetWidth-(!e.offsetX?e.layerX:e.offsetX);
		if(e.clientX+stateX>document.body.clientWidth){
			ul.className = "menu_left_show";
		}
		$(ul).bgiframe();
	}
	function hideMenu(li){
		var ul = li.lastChild;
		if(!ul || ul.tagName != "UL") return;
		var time = setTimeout(function(){
			ul.style.display = "none";
		}, 150);
		ul.time = time;
	}
	
	function moremenu(){
		var menubar = document.getElementById("<%=sMenuBarId%>");
		var morebutton = menubar.lastChild;
		while(morebutton.tagName!="LI") morebutton = morebutton.previousSibling;
		var moremenu = morebutton.lastChild;
		while(moremenu.childNodes.length>0){
			menubar.insertBefore(moremenu.childNodes[0], morebutton);
		}
		
		var maxwidth = menubar.offsetWidth;
		var width = 40;
		morebutton.style.display = "none";
		for(var i = 0; i < menubar.childNodes.length; i++){
			if(menubar.childNodes[i].tagName!="LI") continue;
			if((width+=menubar.childNodes[i].offsetWidth)<maxwidth) continue;
			if(menubar.childNodes[i]==morebutton) break;
			morebutton.style.display = "block";
			moremenu.appendChild(menubar.childNodes[i--]);
		}
	}
	
	function openMenu(sMenuName, sUrl, sParas, sAccessType){
		if(sAccessType == "20"){ // 动态
			for(var i = 0; i < frames.length; i++){
				if(typeof frames[i].addTabItem == "function"){
					frames[i].addTabItem(sMenuName, sUrl, sParas);
					return;
				}
			}
			AsControl.OpenView("/AppMain/MenuRedirector.jsp", "Title="+sMenuName+"&Url="+sUrl+"&Paras="+sParas.replace(/\&/g, "~")+"~_SYSTEM_MENU_FALG=0", "_self");
			return;
		}
		AsControl.OpenView(sUrl, sParas, "_self"); // 经典
	}
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">  
  <tr align="center" >
  	<td valign="top" class="logo"></td>
    <td height="30" nowrap ><%=sMenuBar%></td>
    <!-- 
    <td width="200"  class="welcome">
       	欢迎您！<b><a href="#" onmouseover="openDWDialog(event)" onmouseout="autoCloseDWDialog()"><%=CurUser.getUserName()%></a></b>
    </td>
     -->
	<!-- 系统按钮区域  -->
  	<td valign="bottom" class="menu_sys" width="1" ><%@include file="SystemArea.jsp"%></td>
    <td width="1" valign="middle">
    <iframe name=myrefresh0 frameborder=0 width=1 height=1 src="<%=sWebRootPath%>/Frame/page/sys/SessionClose.jsp" ></iframe>
    </td>
  </tr>
</table>
<div id="OverLayoutDiv" class="overdiv_top" >
<div class="overdiv_title">&nbsp;<span id="sp_overdiv_top" style="cursor:pointer;">&nbsp;&nbsp;</span></div>
<div class="overdiv_info"></div>
</div>
<script type="text/javascript">
	$(function(){
		moremenu();
		$(window).resize(moremenu);
	});
</script>