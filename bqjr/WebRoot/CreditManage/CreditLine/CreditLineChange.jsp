<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content:额度详情察看
		Input Param:
		Output param: 
		History Log:  sxjiang  2010.07.12 对担保额度和合作商额度应该不展示“授信额度分配”内容  Line66 etc.
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数
	//合同流水号
	String sBCSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	if(sBCSerialNo==null) sBCSerialNo="";
	//获得页面参数	
	String sSql = " select LineID from CL_INFO where BCSerialNo=:BCSerialNo and (ParentLineID is null or ParentLineID='' or ParentLineID=' ') ";
	//获得授信额度总协议号
	String sParentLineID = Sqlca.getString(new SqlObject(sSql).setParameter("BCSerialNo",sBCSerialNo));
	
	String sSql1 = " select BusinessType from business_contract where serialno=:serialno";
	//获得业务品种
	String sBusinessType = Sqlca.getString(new SqlObject(sSql1).setParameter("serialno",sBCSerialNo));
	
	if(sParentLineID==null) sParentLineID="";
	if(sBusinessType==null) sBusinessType="";
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授信额度详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	int iOrder = 1;
	//tviTemp.insertPage("root","概览","",iOrder++);
	tviTemp.insertPage("root","授信额度基本信息","",iOrder++);
	if( sBusinessType.equals("3005")||sBusinessType.equals("3010")){
		tviTemp.insertPage("root","授信额度分配","",iOrder++);
	}
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
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=="授信额度基本信息")
		{
			OpenComp("CreditLineInfo","/CreditManage/CreditLine/CreditLineInfo.jsp","ToInheritObj=y&SerialNo=<%=sBCSerialNo%>","right");
		}
		
		if(sCurItemname=="授信额度分配")
		{
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ToInheritObj=y&ParentLineID=<%=sParentLineID%>","right");
		}
		setTitle(getCurTVItem().name);
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
	selectItemByName("授信额度基本信息");
	expandNode('root');	
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
