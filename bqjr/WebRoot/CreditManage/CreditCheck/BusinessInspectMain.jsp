<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.01.17
		Tester:
		Content: 贷后检查主界面
		Input Param:
		Output param:
		History Log:  
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后检查"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;贷后检查&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sTreeviewTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TreeviewTemplet"));

	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//条件
	String sCondition ="";
	int i=0,i1=0,i2=0;
	//280－分行客户经理；480－支行客户经理；000－总行系统数据维护员
	if (CurUser.hasRole("280") || CurUser.hasRole("480") || CurUser.hasRole("000")){
		i1 = 1;
	}
	//040－总行信贷风险贷后检查员；240－分行信贷风险贷后检查员；000－总行系统数据维护员
	if (CurUser.hasRole("040") || CurUser.hasRole("240")|| CurUser.hasRole("000")){
		i2 = 2;
	}
	i=i1+i2;
	if (i==3) sCondition ="";
	if (i==2) sCondition =" and Itemno like '02%'";
	if (i==1) sCondition =" and Itemno like '01%'";
	if (i==0) sCondition =" and Itemno like '1%'";
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"风险检查管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeviewTemplet+"'"+sCondition;
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
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
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		if(typeof(sCurItemID)!="undefined" && typeof(sCurItemDescribe2)!="undefined" && sCurItemDescribe2.length > 0 && sCurItemID !="root" && sCurItemID !="010" && sCurItemID !="020")
		{
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&InspectType="+sCurItemDescribe3,"right");
		}
		
		if(sCurItemDescribe1 != "null"&&sCurItemDescribe1!="root")
		{	
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
	expandNode('01');
	expandNode('02');
	expandNode('01010');	
	expandNode('01020');
	selectItem('01010010');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
