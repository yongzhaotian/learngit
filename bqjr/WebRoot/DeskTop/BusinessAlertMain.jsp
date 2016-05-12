<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jytian  2004/12/28
		Tester:
		Content: 业务信息提醒
		Input Param:
			                
		Output param:
			              
		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务信息提醒"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	
	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务信息提醒","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//生成本次搜索的Sql语句
	String sSql = "select SortNo,ItemName,ItemNo from CODE_LIBRARY where CodeNo= 'BusinessAlert' Order By SortNo";
	ASResultSet rs=Sqlca.getASResultSet(sSql);
	String sSortNo="";
	String sItemName="";
	String sItemNo="";
	while(rs.next())
	{
		sSortNo = rs.getString("SortNo");
		sItemName = rs.getString("ItemName");
		sItemNo = rs.getString("ItemNo");
		sSql = "select count(*) from WORK_REMIND  where RemindType=:RemindType and InputUserID=:InputUserID";
		ASResultSet rs1=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RemindType",sSortNo).setParameter("InputUserID",CurUser.getUserID()));
		rs1.next();
		sItemName += "("+rs1.getInt(1)+")件"; 
		rs1.getStatement().close();
		tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
	}
	rs.getStatement().close();
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	//treeview单击选中事件
	function TreeViewOnClick()
	{
		var sCurItemNo = getCurTVItem().value;
		
		if(sCurItemNo != "root")
		{
			OpenComp("BusinessAlertList","/DeskTop/BusinessAlertList.jsp","RemindType="+sCurItemNo,"right");
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
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
