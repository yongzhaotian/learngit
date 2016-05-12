<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ccxie 2010/04/06
		Tester:
		Content: 业务补登主界面
		Input Param:
			 	SerialNo：业务申请流水号
		Output param:
			      
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务补登"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;基本信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	
	//定义变量
	String sBusinessType = "",sCustomerID = "";
	String sOccurType = "";
	String sApplyType="";
	String sTable="";
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	
	//根据sObjectType的不同，得到不同的关联表名和模版名
	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
	
	sSql="select CustomerID,OccurType,ApplyType,BusinessType from "+sTable+" where SerialNo=:SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
		sOccurType=DataConvert.toString(rs.getString("OccurType"));
		sApplyType=DataConvert.toString(rs.getString("ApplyType")); 
		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
	}
	rs.getStatement().close(); 

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'InputCreditView' and IsInUse = '1' ";

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
		
		sObjectType="<%=sObjectType%>";
		sObjectNo="<%=sObjectNo%>";
		sCustomerID="<%=sCustomerID%>";
		sOccurType="<%=sOccurType%>";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType",sObjectType);
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo",sObjectNo);
		sParaStringTmp=sParaStringTmp.replace("#CustomerID",sCustomerID);
		sParaStringTmp=sParaStringTmp.replace("#OccurType",sOccurType);
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
		
	}

	function TreeViewOnClick(){
		var AccountType="";
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		if(!sCurItemDescribe0 || sCurItemDescribe0 == "null") return;
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&AccountType=ALL&"+sCurItemDescribe2);
		setTitle(getCurTVItem().name);
	}
	
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('01');
	expandNode('040');
	expandNode('041');	
	selectItem('010');
	setTitle("基本信息");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>