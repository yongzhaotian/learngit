<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:示例模块主页面
	 */
	String PG_TITLE = "电话催收"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;催收管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"示例模块主页面","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	//String sFolder1=tviTemp.insertFolder("root","示例信息","",1);
	//tviTemp.insertPage(sFolder1,"所有的示例信息","",1);
	//tviTemp.insertPage(sFolder1,"我的示例信息","",2);
	//tviTemp.insertPage(sFolder1,"他的示例信息","",3);
	tviTemp.insertPage("root","查找组","",1);
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		//PhaseType1:(0011:电话催收M1;		0012:电话催收M2;	0013:电话催收M3)
		if(sCurItemname=='查找组'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionGroupList.jsp","","right");
		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		selectItemByName("所有的示例信息");	//默认打开的(叶子)选项	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
