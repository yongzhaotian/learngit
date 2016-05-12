<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jfeng
		Tester:
		Content:支付流水主页面
		Input Param:
		
		Output param:
		
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "支付流水"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;支付流水&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	
	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
		
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"支付流水","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构	
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo = 'PaymentFlowMain' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript"> 
	
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;

		/**
		PaymentStatus 支付状态
		000		 待处理  	
		010  	处理中
		020		已完成
		030		失败
		PaymentMode 支付方式
		010 	自主支付
		020		受托支付
		*/
		if(getCurTVItem().id == "02010"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=020&PaymentMode=010";
		}else if(getCurTVItem().id == "02020"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=020&PaymentMode=020";
		}else if(getCurTVItem().id == "03010"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=030&PaymentMode=010";
		}else if(getCurTVItem().id == "03020"){
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=030&PaymentMode=020";
		}else {
			sParaStringTmp = sParaStringTmp + "&PaymentStatus=010";
		}	
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/

	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe3=sCurItemDescribe[2];
				
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"&ComponentName=PaymentFlowMain");
			setTitle(getCurTVItem().name);
		}
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
	startMenu();
	expandNode('root');	
	//expandNode('010');
	expandNode('020');
	expandNode('030');
	selectItem('010');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
