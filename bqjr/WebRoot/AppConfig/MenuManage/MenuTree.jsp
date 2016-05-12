<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //默认打开节点
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"主菜单配置","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	tviTemp.initWithSql("SortNo","MenuName","MenuID","","","from AWE_MENU_INFO where 1 = 1 ","Order By SortNo",Sqlca);
	String sButtons[][] = {
		{"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","启用","启用该条记录","changeMenuState('1')","","","",""},
		{"true","All","Button","停用","停用该条记录","changeMenuState('2')","","","",""},
		{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete"},
		{"true","All","Button","配置角色","配置可见角色","selectMenuRoles()","","","",""},
		{"false","","Button","刷新缓存","","reloadCacheAll()","","","",""},
		{"true","","Button","查询","","showTVSearch()","","","",""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem('<%=sDefaultNode%>');
	}
	<%/*[Describe=新增记录;]*/%>
	function newRecord(){
        OpenPage("/AppConfig/MenuManage/MenuInfo.jsp","frameright","");
	}

	function changeMenuState(sChange){ // 启用 1，停用 2
		var sSortNo = getCurTVItem().id; //根据菜单的生成，这里取得是菜单排序号
		var sMenuID = getCurTVItem().value;
		if(!sMenuID){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return ;
		}
		var sAction = "";
		if(sChange == "1") sAction = "启用";
		else if(sChange == "2") sAction = "停用";
		else sAction = "操作";

		var sIncludeSubs = "false";
		if(confirm("是否同时"+sAction+"项下菜单？")){
			sIncludeSubs = "true";
		}
		var sPara = "MenuID="+sMenuID+",SortNo="+sSortNo+",Flag="+sChange+",IncludeSubs="+sIncludeSubs;
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.menu.action.ChangeMenuState","changeMenuState",sPara);
		if(sReturn != "SUCCEEDED"){
			alert(sAction+"该菜单项失败！");
		}else{
		    alert("该项目已"+sAction+"成功！");
		    OpenPage("/AppConfig/MenuManage/MenuInfo.jsp?MenuID="+sMenuID, "frameright"); //重新打开节点
		}
	}
	
    function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	
	<%/*[Describe=点击节点事件,查看及修改详情;]*/%>
	function TreeViewOnClick(){
		var sMenuID = getCurTVItem().value;
		if(!sMenuID){
			OpenPage("/AppMain/Blank.jsp?TextToShow=请选择左边树图节点!", "frameright");
		}else if(sMenuID=="root"){
		}else{
	      	OpenPage("/AppConfig/MenuManage/MenuInfo.jsp?MenuID="+sMenuID, "frameright"); 
		}
	}

	<%/*[Describe=删除记录;]*/%>
	function deleteRecord(){
		var sMenuID = getCurTVItem().value;
		if(!sMenuID){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return ;
		}
		if(confirm("删除该记录将同时删除其与可见角色的关联关系，\n您确定删除吗？")){
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.menu.action.DeleteMenuAction","deleteMenuAndRela","MenuID="+sMenuID);
			if(typeof sReturn != "undefined" && sReturn == "SUCCEEDED"){
				AsControl.OpenView("/AppConfig/MenuManage/MenuTree.jsp", "", "frameleft", "");
				AsControl.OpenView("/Blank.jsp","TextToShow=请在左侧选择一项","frameright","");
			}
		}
	}
	
	<%/*[Describe=选择菜单可见角色;]*/%>
	function selectMenuRoles(){
		var sMenuID = getCurTVItem().value;
		var sMenuName = getCurTVItem().name;
		if(!sMenuID){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return ;
		}else{
			AsControl.PopView("/AppConfig/MenuManage/SelectMenuRoleTree.jsp","MenuID="+sMenuID+"&MenuName="+sMenuName,"dialogWidth=440px;dialogHeight=500px;center:yes;resizable:no;scrollbars:no;status:no;help:no");
        }
    }
	<%/*刷新所有缓存*/%>
	function reloadCacheAll(){
		var sReturn = RunJavaMethod("com.amarsoft.app.awe.common.action.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("刷新成功！");
		else alert("刷新失败！");
	}
	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>