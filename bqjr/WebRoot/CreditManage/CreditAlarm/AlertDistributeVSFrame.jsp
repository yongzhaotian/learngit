<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: 企业债券发行信息_List
		Input Param:
			                CustomerID：客户编号
			                CustomerRight:权限代码----01查看权，02维护权，03超级维护权
		Output param:
		                CustomerID：当前客户对象的客户号
		              	Issuedate:发行日期
		              	BondType:债券类型
		                CustomerRight:权限代码
		                EditRight:编辑权限代码----01查看权，02编辑权
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;已选择分发目标&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "正在打开页面，请稍候...";//默认的内容区文字
	String PG_LEFT_WIDTH = "50%";//默认的treeview宽度

	CurPage.setAttribute("PG_CONTENT_TITLE_LEFT","&nbsp;&nbsp;查询&nbsp;&nbsp;");
	CurPage.setAttribute("PG_CONTNET_TEXT_LEFT","正在打开页面，请稍候...");
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sAlertIDString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertIDString"));
	//获得页面参数	
    //
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/VerticalSplit04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		OpenComp("ExampleList","/Frame/CodeExamples/ExampleList.jsp","ComponentName=我的例子&SortNo="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
	}
	
	function reloadLeftAndRight(){
		left.reloadSelf();
		right.reloadSelf();
	}
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	OpenComp("AlertDistributeUserQuery","/CreditManage/CreditAlarm/UserQueryList.jsp","","left");
	OpenComp("AlertDistributeSelectedUsers","/CreditManage/CreditAlarm/SelectedUserList.jsp","","right");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
