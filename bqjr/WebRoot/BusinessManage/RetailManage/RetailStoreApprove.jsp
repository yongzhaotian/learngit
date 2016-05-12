<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--零售商门店准入审批
	 */
	String PG_TITLE = "零售商门店准入审批"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;零售商门店准入审批&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"零售商门店准入审批","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构                          
	String sFold1=tviTemp.insertFolder("root","零售商准入审批","",1);   
	String tmp1=tviTemp.insertFolder(sFold1,"零售商当前任务","",1); 
 	tviTemp.insertPage(tmp1,"零售商当前初审任务","",1);
	tviTemp.insertPage(tmp1,"零售商当前复审任务","",2);
    tviTemp.insertPage(sFold1,"零售商已完成任务","",2); 
    tviTemp.insertPage(sFold1,"零售商不通过任务","",3); 

	String sFold2=tviTemp.insertFolder("root","门店准入审批","",2);
	String tmp3=tviTemp.insertFolder(sFold2,"门店当前任务","",1); 
 	tviTemp.insertPage(tmp3,"门店当前初审任务","",1);
	tviTemp.insertPage(tmp3,"门店当前复审任务","",2);
    tviTemp.insertPage(sFold2,"门店已完成任务","",2); 
    tviTemp.insertPage(sFold2,"门店不通过任务","",3); 
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	
	function TreeViewOnClick() {
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if (sCurItemname == '零售商当前初审任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList.jsp",
					"type=02", "right");
		} else if (sCurItemname == '零售商当前复审任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList1.jsp",
					"type=02", "right");
		} else if (sCurItemname == '零售商已完成任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList2.jsp",
					"type=02", "right");
		} else if (sCurItemname == '零售商不通过任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList2.jsp",
					"type=05", "right");
		} else if (sCurItemname == '门店当前初审任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList.jsp",
					"type=02", "right");
		} else if (sCurItemname == '门店当前复审任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList1.jsp",
					"type=02", "right");
		} else if (sCurItemname == '门店已完成任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList2.jsp",
					"type=02", "right");
		} else if (sCurItemname == '门店不通过任务') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList2.jsp",
					"type=05", "right");
		}
		setTitle(getCurTVItem().name);
	}
<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("零售商准入审批");	//默认打开的(叶子)选项	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
