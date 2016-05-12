<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Tree00;Describe=注释区;]~*/%>
	<%
	/*
		Author:     组件选择
		Tester:
		Content:    权限管理视图
		Input Param:
                  
		Output param:
		                
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Tree01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "权限管理视图"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;权限管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Tree02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	//获取传入参数ObjectNo，确定是根据用户查看权限还是根据角色查看权限
    String sPara = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));

    //判断组件的排序号是否重复
    ASResultSet rsRole = SqlcaRepository.getASResultSet("select OrderNo,count(*) from reg_comp_def where OrderNo not like '99%' group by OrderNo having count(*)>1");
	while(rsRole.next())
    {
		throw new Exception("排序号重复："+rsRole.getString("OrderNo"));
	}
	rsRole.getStatement().close();
    
    %>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Tree03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
    HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"应用组件列表","right");
    tviTemp.TriggerClickEvent=true;
    String sSqlTreeView = " from REG_COMP_DEF where OrderNo is not null and OrderNo not like '99%'";
    tviTemp.initWithSql("OrderNo","CompName"," CompID ","","",sSqlTreeView,"Order By OrderNo",Sqlca);

	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Tree04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/Tree04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Tree05;]~*/%>
	<script type="text/javascript"> 

    //treeview单击选中事件
	function TreeViewOnClick()
	{
		
		top.returnValue = getCurTVItem().value+"@"+getCurTVItem().name+"@"+getCurTVItem().id;
		if(confirm("您选择了\n\n组件ID: ["+getCurTVItem().id+"]\n组件名: ["+getCurTVItem().name+"]\n排序号:["+getCurTVItem().value+"]\n\n确认吗?"))
			top.close();
		else top.returnValue="";
			
		
		//setTitle(getCurTVItem().name);
	}
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
    function closeAndReturn()
    {
        parent.reloadOpener();
        parent.close();
    }
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Tree06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	expandNode(1);
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
