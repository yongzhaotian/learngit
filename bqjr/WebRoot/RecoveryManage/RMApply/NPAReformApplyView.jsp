<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005.8.11
		Tester:
		Content: 重组方案详情
		Input Param:
				SerialNo：重组方案流水号
				sViewID：视图ID
		Output param:
		            
		History Log: zywei 2005/09/01 重检代码
		              
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重组方案详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;重组方案基本信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数(流水号、视图ID、对象类型)	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	String sObjectType = "NPAReformApply";
	
	//获得发生类型
	String sSql = " select ApplyType from BUSINESS_APPLY where SerialNo = :SerialNo ";
   	String sApplyType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
   	//定义变量：树型视图展现条件
	String sSqlTreeView = "";
			
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"重组方案详情列表","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构	
	sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'NPAReformView' and IsInUse = '1' ";	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;Describe=树图事件;]~*/%>
<script type="text/javascript"> 

	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	//从TreeView的code_library库属性获取事件codeno = CaseInfoList
	function openChildComp(sCompID,sURL,sParameterString)
	{
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sObjectNo = "<%=sObjectNo%>";
		sApplyType = "<%=sApplyType%>";
		sObjectType = "<%=sObjectType%>";
		
		if(sCurItemDescribe2 == "Back")
		{
			self.close();
			opener.location.reload();

		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ApplyType="+sApplyType+"",OpenStyle);
			setTitle(sCurItemName);
		}
	}
		
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化;]~*/%>
<script type="text/javascript">
	startMenu();
	expandNode('root');		
	selectItem('01');	 
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
