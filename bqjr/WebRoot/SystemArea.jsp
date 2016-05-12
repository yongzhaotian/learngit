<%@page import="com.amarsoft.awe.util.ASResultSet"%>
<%@page import="com.amarsoft.context.ASUser"%>
<%@page import="org.apache.poi.hslf.record.CurrentUserAtom"%>
<script type="text/javascript">
	function MM_swapImgRestore(){
	    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_preloadImages(){
	    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

	function MM_findObj(n, d){
	    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	    if(!x && document.getElementById) x=document.getElementById(n); return x;
	}

	function MM_swapImage(){
	    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	    if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

	function MM_reloadPage(init){
	    if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    	    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  	    else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}

    function ModifyPass(){
 		PopPage("/AppMain/ModifyPassword.jsp","","dialogHeight=480px;dialogWidth=800px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    }
    
    function ModifySotres(){
 		var sRetVal=PopPage("/AppMain/ModifySotres.jsp?identtype=01","","dialogHeight=250px;dialogWidth=800px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
 		//StoreChosen用于首页“门店选择”按键
 		OpenComp("Main","/Main.jsp","ToDestroyAllComponent=Y&StoreChosen="+sRetVal,"_top","");
    }
    
    function ModifySotres1(){
    	PopPage("/AppMain/ModifySotres.jsp?identtype=02","","dialogHeight=250px;dialogWidth=800px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    }

 	function sessionOut(){
 		if(confirm("确认退出本系统吗？"))
 			OpenComp("SignOut","/AppMain/SignOut.jsp","","_top","");
	}

	MM_reloadPage(true);
 	function goHome(){
		OpenComp("Main","/Main.jsp","ToDestroyAllComponent=Y","_top","");
	}
 	
 	function saveSkin(path){
 		var sReturn = AsControl.RunJsp("/AppConfig/OrgUserManage/ReloadSkin.jsp", "Path="+path);
 		if(!sReturn){
 			reloadSelf();
 		}else{
 			alert(sReturn);
 		}
 	}
 	
 	$(function(){
 		$("#skin_bar").bind("mouseleave", function(){
 			$(this).hide();
 		});
 	});
</script><style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<%
	//取系统名称
	String sImplementationID = CurConfig.getConfigure("ImplementationID");
	String sImplementationVersion = CurConfig.getConfigure("ImplementationVersion");
	String sAttribute8 = CurUser.getAttribute8();
	String sRName = Sqlca.getString("select ri.rName from retail_info ri where ri.serialno=(select si.rserialno from store_info si where si.sno='"+sAttribute8+"')");
	if(null == sRName) sRName = "";
	String sSname = Sqlca.getString("select sname from store_info where sno = '"+sAttribute8+"'"); 
	if(null == sSname) sSname = "";
	
	ArrayList<com.amarsoft.awe.res.model.SkinItem> items = com.amarsoft.awe.res.model.SkinItem.getFixSkins();
	
	String isCar  = CurUser.getIsCar();
%>
<table border="0" cellspacing="0" cellpadding="0">
<tr>
  <td nowrap class="sys_menu_href">&nbsp;
  	<a href="javascript:goHome()" class="home">主页</a>&nbsp;&nbsp;
<%--   	<%if(!items.isEmpty()){%> --%>
<%--    	<a style="background:url(<%=sWebRootPath%><%=CurUser.getSkin().getPath()%>/icon.gif) no-repeat left center; text-decoration: none;" title="<%=CurUser.getSkin().getRemark()%>" href="javascript:void(0);" onmouseover="javascript:$('#skin_bar').slideDown(100);"><span style="margin-left: 22px;"><%=CurUser.getSkin().getName()%></span></a>&nbsp;| --%>
<%--    	<%}%> --%>
<%if("02".equals(isCar)){ 
     if(CurUser.hasRole("1006")||CurUser.hasRole("1622")||CurUser.hasRole("1624")||CurUser.hasRole("1626")||CurUser.hasRole("1628")||CurUser.hasRole("1630")||CurUser.hasRole("1620")||CurUser.hasRole("3008")){
%>
	 <a href="javascript:ModifySotres()">当前商户:<%=sRName %></a>&nbsp;&nbsp;|
	<a href="javascript:ModifySotres()">当前门店:<%=sSname %></a>&nbsp;&nbsp;|
	<%}else{%>
	<a href="javascript:ModifySotres()">门店选择</a>&nbsp;&nbsp;|
	<%}}else{ %>
		<a href="javascript:ModifySotres1()">展厅选择</a>&nbsp;&nbsp;|
		<% }%>
   	<a href="javascript:ModifyPass()">修改密码</a>&nbsp;|
   	<a href="javascript:sessionOut()">退出系统</a>
  </td>
  <td nowrap>
    <span class="pageversion" title="系统版本">&nbsp;&nbsp;|&nbsp;&nbsp;<%=sImplementationID+" "+sImplementationVersion%> &nbsp;&nbsp;</span>
  </td>
  <td nowrap width="">
    <span class="pageversion" >
    </span>
  </td>
</tr>
</table>
<div id="skin_bar" class="skin_bar" style="display:none">
<%for(int _item_index = 0; _item_index < items.size(); _item_index++){
	com.amarsoft.awe.res.model.SkinItem item = items.get(_item_index);
	if(item.getPath().equals(CurUser.getSkin().getPath())) continue;
%><a style="background-image:url(<%=sWebRootPath%><%=item.getPath()%>/icon.gif);" title="<%=item.getRemark()%>" href="javascript:saveSkin('<%=item.getPath()%>');"><span><%=item.getName()%></span></a>
<%}%>
</div>