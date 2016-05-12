<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  hxli 2005-8-3
		Tester:
		Content: 抵债资产日常管理主界面PDAMain.jsp
		Input Param:			                
		Output param:		                
		History Log: 		                 
	 */

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;抵债资产管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
		
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
		
	//获得页面参数

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"抵债资产管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件


	//定义树图结构
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDADailyList' and ItemNo<>'04' and isinuse<>'2' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
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
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //代码表描述字段中用@分隔的第1个串:url
		sCurItemDescribe2=sCurItemDescribe[1];  //代码表描述字段中用@分隔的第2个串:name
		sCurItemDescribe3=sCurItemDescribe[2];  //代码表描述字段中用@分隔的第3个串，根据情况，还可以很多:parameter
		sObjectType = "<%=sObjectType%>";
		//已批准拟抵入的资产
		if (sCurItemDescribe2=="AppNoDisposalList"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=待处置的资产列表&ObjectType="+sObjectType,"right");
			setTitle(sCurItemName);
		}

		//已抵入/处置中的抵债资产列表页面
		if (sCurItemDescribe2=="AppDisposingList"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,
						"ComponentName=处置中的抵债资产列表&ObjectType="+sObjectType+"&InOut="+sCurItemDescribe3,"right");
			setTitle(sCurItemName);
		}

		//处置完毕的抵债资产列表页面
		if (sCurItemDescribe2=="PDADisposalEndList"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,
						"ComponentName=处置终结的抵债资产列表&ObjectType="+sObjectType+"&InOut="+sCurItemDescribe3,"right");
			setTitle(sCurItemName);
		}

		//goback
		if (sCurItemDescribe2=="goBack"){
			OpenPage("/Main.jsp","_self","");
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
	startMenu();
	expandNode('root');
	expandNode('02');
	expandNode('03');
</script>

<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
