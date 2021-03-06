<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	
<%
	String PG_TITLE = "业务组件主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;业务组件管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务组件管理查询","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件


	//定义树图结构,去掉跟踪的不良资产和催收函快速查询
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'TermType' and IsInUse in('0','1') ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%>
	
	
<%@include file="/Resources/CodeParts/Main04.jsp"%>


<script type="text/javascript"> 
	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sItemDescribe = getCurTVItem().value;
		if(typeof(sItemDescribe) != "undefined" && sItemDescribe != "" && sItemDescribe != "null"){
			AsControl.OpenView(sItemDescribe.split("@")[0],sItemDescribe.split("@")[2],"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem('0010');
	expandNode('0020');
</script>


<%@ include file="/IncludeEnd.jsp"%>
