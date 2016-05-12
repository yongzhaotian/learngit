<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   cchang  2004.12.2
	Tester:	  BYao	  2004.12.07
	Content: 客户主界面
	Input Param:
		 CustomerType：客户类型				
			01：公司客户；
			0110：大型企业客户；
			0120：中小型企业客户；
			02：集团客户；
			0210：实体集团客户；
			0220：虚拟集团客户；
			03：个人客户
			0310：个人客户；
			0320：个体经营户；
		 CustomerListTemplet:客户列表模板代码
		                以上参数统一由代码表:MainMenu主菜单得到配置
	Output param:
		 CustomerType：客户类型
		 CustomerListTemplet:客户列表模板代码
		                以上参数统一由代码表:MainMenu主菜单得到配置
	History Log: 
		2004-12-13	cchang	增加个体工商户操作
 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;客户管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sCustomerListTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
	
	if(sCustomerType == null) sCustomerType = "";
	if(sCustomerListTemplet == null) sCustomerListTemplet = "";
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"集团客户管理","right");
	if(sCustomerType.equals("02")){
		//定义树图结构
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数
		tviTemp.insertPage("01","root","集团客户管理 ","","",1);
		tviTemp.insertPage("02","root","集团客户查询","","",2);
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	 function TreeViewOnClick()
	{
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemID=='root'){
			return;
		}else if(sCurItemID=='01'){
			OpenComp("CustomerList","/CustomerManage/CustomerList.jsp","CustomerType="+sCustomerType+"&CustomerListTemplet="+sCustomerListTemplet,"right");
			setTitle(getCurTVItem().name);
		}else if(sCurItemID=='02'){
		}
	} 
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	sCustomerType = "<%=sCustomerType%>";
	sCustomerListTemplet = "<%=sCustomerListTemplet%>";

	//如果不为集团客户，则自动打开List,并且隐藏树图部分
	if(sCustomerType == "02"){
		startMenu();
		expandNode('root');
		selectItemByName("集团客户管理 ");	//默认打开的(叶子)选项
		//selectItemById("01");
	}else{
		myleft.width=1;
		//OpenComp("CustomerList","/CustomerManage/CustomerList.jsp","CustomerType="+sCustomerType+"&CustomerListTemplet="+sCustomerListTemplet,"right");
		AsControl.OpenView("/InfoManage/QuickSearch/IndQueryList.jsp","","right","");
	}
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	