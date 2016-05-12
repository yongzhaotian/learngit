<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.18
		Tester:
		Content: 调查报告主界面
		Input Param:
			DocID:    formatdoc_catalog中的文档类别（调查报告，贷后检查报告，...)
			ObjectNo：业务流水号
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "调查报告管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sDocID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));

	//定义变量
	String sSql = "";	
	String sCustomerType = "";
	String sCustomerTemplet = "";
	String sCustomerInfoTemplet = "",sModelType = "";
	
	//生成treeview...root
	String sSql1 = "";
	ASResultSet rsData = null;

	//取得该笔申请的客户代码
	String sRootCaption = "";
	sSql1 = "select CustomerName,getBusinessName(BusinessType),getItemName('OccurType',OccurType) " +
			" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'";
	rsData = Sqlca.getResultSet(sSql1);
	if(rsData.next())
		sRootCaption = rsData.getString(1)+"|"+rsData.getString(2)+"|"+rsData.getString(3);
	rsData.getStatement().close();	
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"调查报告("+sRootCaption+")","right");
	tviTemp.ImageDirectory = sResourcesPath; 
	tviTemp.toRegister = false; 
	tviTemp.TriggerClickEvent=true; 

	//定义树图结构
	String sSqlTreeView = "from FORMATDOC_DATA where ObjectNo='"+sObjectNo+"' and DocID='"+sDocID+"' ";

	tviTemp.initWithSql("SerialNo","DirName","SerialNo","","",sSqlTreeView,"Order By TreeNo",Sqlca);  //TreeNo
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemValue = getCurTVItem().value;
		var sCurItemType = getCurTVItem().type;
		
		if(sCurItemType=="page"){
			var sReturn = PopPageAjax("/FormatDoc/ChooseJsp.jsp?SerialNo="+sCurItemID+"&ObjectNo=<%=sObjectNo%>","","");
			if(typeof(sReturn)!='undefined' && sReturn!=""){
				OpenPage(sReturn+"SerialNo="+sCurItemID+"&ObjectNo=<%=sObjectNo%>","right");
				setTitle(sCurItemName);
			}
		}else{
			return false;
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');	
	setTitle("调查报告");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
