<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: 文件质量检查审核要点管理
		Input Param:
		Output param:
		History Log: 
	*/
	String PG_TITLE = "文件质量检查审核要点管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;文件质量检查审核要点管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "0";//默认的treeview宽度

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"文件质量检查审核要点管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	tviTemp.insertPage("root","文件质量检查审核要点管理","",1);
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		AsControl.OpenView("/SystemManage/CarManage/DocAuditPointsList.jsp","","right");
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		selectItemByName("文件质量检查审核要点管理");	//默认打开的(叶子)选项	
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
