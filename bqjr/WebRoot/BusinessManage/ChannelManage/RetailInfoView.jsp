<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --客户视图主界面
		Input Param:
			  ObjectNo  ：--客户号
		Output param:
			               
		History Log: 
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "零售商准入申请"; //-- 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;零售商准入申请&nbsp;&nbsp;"; //--默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//--默认的内容区文字
	String PG_LEFT_WIDTH = "200";//--默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = "";	//--存放sql语句
	String sItemAttribute = "",sItemDescribe = "",sAttribute3 = "";//--客户类型	
	String sCustomerType = "";//--客户类型	
	String sTreeViewTemplet = "";//--存放custmerview页面树图的CodeNo
	ASResultSet rs = null;//--存放结果集
	int iCount = 0;//记录数
	String sBelongGroupID = "";//所属集团客户ID
	//获得组件参数	,客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//获得页面参数	

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%	
	//如果用户没有上述相关权限，则给出相应的提示
	if( false){
%>
		<script type="text/javascript">
			//用户不具备当前客户查看权
			alert( getHtmlMessage("15"));				
		    self.close();			        
		</script>
<%
	}
	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectNo == null) sObjectNo="";
	if(sObjectType == null) sObjectType="";		// RetailApplyInfo
	
	sTreeViewTemplet = "RetailApplyView";
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"客户信息管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick()
	{
		var sCurItemName = getCurTVItem().name;//--获得树图的节点名称
		var sCurItemDescribe = getCurTVItem().value;//--获得连接下个页面的路径及相关的参数

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--获得连接下个页面的路径
		sCurItemDescribe2=sCurItemDescribe[1];//--存放下个页面的的页面名称
		sCurItemDescribe3=sCurItemDescribe[2];//--现在没有
		sCurItemDescribe4=sCurItemDescribe[3];//--现在没有
		
		if(sCurItemDescribe2 == "Back")
		{
			top.close();
		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root" && sCurItemDescribe1 != "")  //modified by yzheng 2013-7-3 父节点不响应事件兼容IE
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ModelType="+sCurItemDescribe4+"&ComponentName="+sCurItemName+"&NoteType="+sCurItemDescribe3);
			setTitle(getCurTVItem().name);
		}
	}
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	var sCustomerType = "<%=sCustomerType%>";

	//如果客户类型为集团客户，则自动点击"010"项目，如果不是集团客户，则自动展开"010"节点 add by cbsu 2009-10-21
	var sGroupType = sCustomerType.substring(0,2);
	if (sGroupType != '02') {
		expandNode('010');
	} else {
	    selectItem('010');
	}
	
	if(sCustomerType != '0120')
	{
		selectItem('010010');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	}else 
	{
		selectItem('010005');//中小企业。 自动点击树图，目前写死，也可以设置到 code_library中进行设定
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
