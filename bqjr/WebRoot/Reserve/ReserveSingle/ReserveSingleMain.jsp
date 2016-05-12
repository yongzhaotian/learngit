<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:	sjchuan	2009-10-19
		Tester:
		Content:单项计提减值准备数据主页面
		Input Param:
		Output param:
			CustomerType: 客户类型
				 01 公司客户 
				 03 个人客户
		History Log: 
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	//树型菜单页数
	int iLeaf = 1;
	//获得组件参数	
	
	//获得页面参数	

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
<%
	//浏览器窗口标题 <title> PG_TITLE </title>
	String PG_TITLE = "单项计提减值准备数据"; 
	//默认的内容区标题
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;单项计提减值准备数据&nbsp;&nbsp;"; 
	//默认的内容区文字
	String PG_CONTNET_TEXT = "请点击左侧列表";
	//默认的treeview宽度
	String PG_LEFT_WIDTH = "200";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"单项计提数据信息","right");
	//设置资源文件目录（图片、CSS）
	tviTemp.ImageDirectory = sResourcesPath; 
	//设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.toRegister = false; 
	
	//定义树图结构
	tviTemp.insertPage("root","公司客户单项计提数据","javascript:parent.openPhase('01')",iLeaf++);
	tviTemp.insertPage("root","个人客户单项计提数据","javascript:parent.openPhase('03')",iLeaf++);	
%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
<script type="text/javascript"> 

	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function openPhase(sCustomerType)
	{
		//打开对应的List界面
		OpenComp("ReserveSingleList","/Reserve/ReserveSingle/ReserveSingleList.jsp","CustomerType="+sCustomerType,"right");
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
<script type="text/javascript">
	//加载树图
	startMenu();
	//展开树图的节点
	expandNode('root');
	selectItem('1');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
