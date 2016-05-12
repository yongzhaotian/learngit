<%@page import="com.amarsoft.awe.res.AppManager"%>
<%@page import="com.amarsoft.awe.res.model.AppItem"%>
<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<head>
<title>欢迎页面</title>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/AppMain/resources/css/page.css">
<link rel="stylesheet" type="text/css" href="<%=sSkinPath%>/css/page.css">
<style type="text/css">
body{ margin:0px; padding:10px; background:none;font-size:12px}
</style>
</head>
<body>
	<div class="s_nvg">
		<%
			ArrayList<AppItem> appItemList = AppManager.getUserAppList(CurUser);
			int i=0;
	    	for (AppItem appItem:appItemList) {
	        	String newAppUrl = appItem.getUrl();
		    	
				String sClassName = "snb snb_s_"+i;
	        	if(i==0){sClassName = "snb snb_selected";}
	        	if(newAppUrl != null && newAppUrl.length() > 1 ) {
		%>
	        	<div class="<%=sClassName%>" onclick="sysClick(<%=i%>)"><%=appItem.getDisplayName()%></div>
	        	<input type="hidden" id="SysMessage<%=i%>" value="<%=appItem.getDescribe() == null ?appItem.getDisplayName():appItem.getDescribe()%>">
	        	<input type="hidden" id="AppID<%=i%>" value="<%=appItem.getAppID()%>">
	        	<input type="hidden" id="Icon<%=i%>" value="<%=appItem.getIcon()%>">
	        	<input type="hidden" id="ClickScript<%=i%>" value="<%=appItem.getOnclickScript()%>">
		<%		}
				i++;
		    }
		%>
	</div>
	
	<div class="s_appimg" id="SysImage">
		<div class="s_appimg_flow"></div>
	</div>
	
	<div class="s_content">
		<div class="s_tit">
			<div class="s_btnin" id="SysButton"></div>
			<div class="s_express" id="sysMessage"></div>
		</div>

		<div class="s_scoll">
		<table class="apmtb"><tr>
			<td>
			<iframe name="MenuContainer" height="100%" width="100%" scolling="auto" frameborder=0></iframe>
			</td>
		</tr></table>
		</div>
	</div>
</body>

<script type="text/javascript">
	$(document).ready(function(){
		//默认打开第一个
		sysClick(0);
		//$("#SysButton").html("<input class='s_btn' type=button "+$("#ClickScript0").val()+" value='进入系统'>");
		//$("#SysImage").css("background","url(<%=sWebRootPath%>/AppMain/resources/images/colorful/"+$("#Icon0").val()+") 8px 8px no-repeat");
		//OpenPage("/AppMain/SubAppMenus.jsp?AppID="+$("#AppID0").val(),"MenuContainer");
	});

	<%//子系统描述%>
	function sysClick(index){
		var sDes = $("#SysMessage"+index).val();
		sDes = sDes.replace(/<span>/g,"");
		sDes = sDes.replace(/<\/span>/g,"");
		$("#sysMessage").text(sDes);index
		
		<%//选中样式切换%>
		$(".s_nvg .snb_selected").removeClass("snb_selected");
		$(".s_nvg >div:eq("+index+")").addClass("snb_selected");

		<%//切换图片%>
		var sIcon = $("#Icon"+index).val();
		$("#SysImage").css("background","url(<%=sWebRootPath%>/AppMain/resources/images/colorful/"+sIcon+") 8px 8px no-repeat");

		<%//进入子系统按钮事件切换%>
		$("#SysButton").html("<input class='s_btn' type=button "+$("#ClickScript"+index).val()+" value='进入系统'>");
		
		var sAppID = $("#AppID"+index).val();
		OpenPage("/AppMain/SubAppMenus.jsp?AppID="+sAppID,"MenuContainer");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>