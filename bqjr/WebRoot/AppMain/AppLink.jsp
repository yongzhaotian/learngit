<%@page import="com.amarsoft.awe.res.MenuManager"%>
<%@page import="com.amarsoft.awe.res.model.MenuItem"%>
<%@page import="com.amarsoft.awe.res.AppManager"%>
<%@page import="com.amarsoft.awe.res.model.AppItem"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/AppMain/resources/css/page.css">
<link rel="stylesheet" type="text/css" href="<%=sSkinPath%>/css/page.css">
<body>
<div class="app_welcom2">
<%/*
	<div class="app_hidden" ><a href="javascript:void(0)" title="关闭" onclick="hideWelcome();">x 关闭</a></div>  
	<div class="app_show" ><a href="javascript:void(0)" title="显示" onclick="showWelcome();">√ 显示</a></div>
*/%>
	<div class="app_change"><a class="c_sys" href="javascript:void(0)" title="切换视图" onClick="changeView();">⊿切换视图</a></div>
	<div class="app_welcom_txt2">ALS风险管理系统</div>
	<%
	BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.USER_LIST");
	BizObjectQuery bq = bm.createQuery("select * from O where O.UserID=:UserID and O.begintime=(select max(UL1.begintime) from jbo.sys.USER_LIST UL1 where UL1.userid=:UserID)");
	BizObject bo = bq.setParameter("UserID",CurUser.getUserID()).getSingleResult();
	if(bo!=null){
	    String lastIp=bo.getAttribute("RemoteAddr").getString();
	    String lastTime=bo.getAttribute("BeginTime").getString();
	%>
	<div class="app_welcom_note2">上次登录时间：<%= lastTime%>，上次登录IP：<%= lastIp%></div>
	<%} %>
    <div class="app_welcom_note2">请选择进入子系统：</div>
</div>
<div class="app_wrap">
<%
	ArrayList<AppItem> appItemList = AppManager.getUserAppList(CurUser);
	int i=0;
	for (AppItem appItem:appItemList) {
		i++;
		ArrayList<MenuItem> menuList = MenuManager.getUserMenuListAll(CurUser, appItem.getAppID());
		for(int j = 0; j< menuList.size(); j++){
			String appItemScript = menuList.get(j).getUrl();
			if(appItemScript != null && appItemScript.length() > 0){
				appItem.setUrl(appItemScript);
				appItem.setUrlParam(menuList.get(j).getUrlParam());
				break; 
			}
    	}
		%>
    <div id="enterBlock<%=i%>" class="app_block" title="点击进入" <%=appItem.getOnclickScript()%>  onMouseOut="this.className='app_block'" onMouseOver="this.className='app_block app_block_on'">
        <a href="javascript:void(0)"><div class="app_img" style="background:url(<%=sWebRootPath%>/AppMain/resources/images/colorful/<%=appItem.getIcon()%>) no-repeat;"></div></a>
            <div class="app_tit"><a><%=appItem.getDisplayName()%></a></div>
            <div class="app_txt"><%=appItem.getDescribe() == null ?appItem.getDisplayName():appItem.getDescribe()%></div>
    </div>
<%	} %>
</div>
<iframe name="AppLinkDetail" height="91%" width="100%" scolling="auto" frameborder=0 id="AppLinkDetail" style="padding-left:10px; display: none;"></iframe>
</body>
<script type="text/javascript">
	var toggled = false; // 标识是否切换过视图 
	function changeView(){
		$(".app_wrap").toggle();
		var obj = $("#AppLinkDetail").toggle();
		if(!toggled && obj.is(":visible")){
			toggled = true;
			OpenPage("/AppMain/AppLinkDetail.jsp","AppLinkDetail");
		}
	}

	function hideWelcome(){
		$(".app_hidden").toggle();
		$(".app_show").toggle();
		$(".app_welcom").toggleClass("app_welcom").toggleClass("app_welcom2");
		$(".app_welcom_txt").toggleClass("app_welcom_txt").toggleClass("app_welcom_txt2");
		$(".app_welcom_note").toggleClass("app_welcom_note").toggleClass("app_welcom_note2");
	}

	function showWelcome(){
		$(".app_hidden").toggle();
		$(".app_show").toggle();
		$(".app_welcom2").toggleClass("app_welcom2").toggleClass("app_welcom");
		$(".app_welcom_txt2").toggleClass("app_welcom_txt2").toggleClass("app_welcom_txt");
		$(".app_welcom_note2").toggleClass("app_welcom_note2").toggleClass("app_welcom_note");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>