<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权方案配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授权方案配置&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数，组件名称、模板类型
	
	//获得页面参数	

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授权方案组管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	tviTemp.initWithSql("SortNo","GroupName","GroupId","","","from SADRE_SCENEGROUP","Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	
	String sButtons[][] = {
		{"true","","Button","新增","新增方案组别","newSceneGroup()",sResourcesPath},
		{"true","","Button","编辑","编辑方案组别","editSceneGroup()",sResourcesPath},
		{"true","","Button","删除","删除方案组别","deleteSceneGroup()",sResourcesPath},
		//刷新缓存功能请项目组酌情使用
		{"false","","Button","刷新缓存","刷新授权缓存","reloadCache()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Common/Configurator/Authorization/View04btn.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	
<script language=javascript> 
	
	function newSceneGroup(){
		var sGroupID = popComp("SceneGroupInfo","/Common/Configurator/Authorization/SceneGroupInfo.jsp","","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sGroupID)=="undefined") return;
		OpenPage("/Common/Configurator/Authorization/RuleSceneView.jsp", "_self", "");
	}
	
	function editSceneGroup(){
		var sGroupID = getCurTVItem().value;//--获得当前节点的代码值
		if(typeof(sGroupID)=="undefined"||sGroupID=="root"){
			alert("请选择方案组别!");
			return;
		}
		sGroupID = popComp("SceneGroupInfo","/Common/Configurator/Authorization/SceneGroupInfo.jsp","GroupID=" + sGroupID,"dialogWidth=40;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof sGroupID == "undefined" || sGroupID.length == 0) return;
		//AsControl.OpenPage("/AppConfig/Authorization/RuleSceneView.jsp", "GroupID="+sGroupID, "_self");
		OpenPage("/Common/Configurator/Authorization/RuleSceneView.jsp?GroupID="+sGroupID, "_self", "");
	}
	
	function deleteSceneGroup(){
		var sGroupID = getCurTVItem().value;//--获得当前节点的代码值
		if(typeof(sGroupID)=="undefined"||sGroupID=="root"){
			alert("请选择方案组别!");
			return;
		}
		var sGroupName = getCurTVItem().name;//--获得当前节点名称
		if(!confirm("将同时删除其项下的授权方案,确认删除\""+sGroupName+"\"?")) return;
		
		//var sReturn = RunJavaMethod("com.amarsoft.sadre.app.action.RemoveSceneGroup", "execute", "GroupID="+sGroupID);
		var sReturn = RunMethod("PublicMethod","AuthorObjectManage","remove,SceneGroup,"+sGroupID);
		if(sReturn && sReturn == "SUCCESSFUL"){
			alert("删除\""+sGroupName+"\"成功.");
			//AsControl.OpenPage("/AppConfig/Authorization/RuleSceneView.jsp", "", "_self");
			OpenPage("/Common/Configurator/Authorization/RuleSceneView.jsp", "_self", "");
		}else{
			alert("删除授权组别失败！");
			return;
		}
	}

	function reloadCache(){
		if(confirm("您即将刷新授权定义缓存,请确认没有用户正在使用系统或者与授权相关的功能!\n警告:若您在刷新授权定义缓存时,用户正在使用与授权相关功能,可能导致功能异常!")){
			var sReturn=RunJavaMethodSqlca("com.amarsoft.app.als.sadre.util.ReloadSADERCache","reloadSADRECache","");
			if(sReturn=="<%=com.amarsoft.app.util.RunJavaMethodAssistant.SUCCESS_MESSAGE%>"){
				alert("成功刷新授权定义缓存!");
			}else{
				alert("刷新授权定义缓存异常,请与系统管理员联系!");
			}
		}
	}
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		var sCurItemName = getCurTVItem().name;//--获得当前节点名称
		var sGroupID = getCurTVItem().value;//--获得当前节点的代码值
		
		OpenComp("RuleSceneList","/Common/Configurator/Authorization/RuleSceneList.jsp","GroupID="+sGroupID,"right");
		setTitle(getCurTVItem().name);
	}

	/*~[Describe=置右面详情的标题;InputParam=sTitle:标题;OutPutParam=无;]~*/
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	function genCtrlButton(myDocument){
		myDocument.writeln("<input type=\"button\" id=\"confirm\" value=\"&nbsp;确&nbsp;定&nbsp;\" alt=\"确定\" onclick=\"javascript:doQuery();\"/>");
		myDocument.close();	
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	//genCtrlButton(left.document);
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
