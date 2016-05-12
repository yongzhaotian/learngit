<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "产品基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;产品基本信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数,产品编号
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("typeNo"));
	if(sTypeNo == null) sTypeNo = "";
	//产品类型
	String sProductType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductType"));
	if(null == sProductType) sProductType = "";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"产品基本信息","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	tviTemp.insertPage("root", "产品基本信息", "", 1);
	tviTemp.insertPage("root", "费用配置", "", 2);
	tviTemp.insertPage("root", "费用减免配置", "", 3);
	
	%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sTypeNo="<%=sTypeNo%>";
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="1"){	
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeDetailsInfo.jsp","typeNo="+sTypeNo+"&ProductType=<%=sProductType%>","right");//update 现金贷需求
		}else if(sCurItemID=="2"){
			//AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeCostList.jsp","typeNo="+sTypeNo,"right");
			AsControl.OpenView("/BusinessManage/Products/FeeLibraryList.jsp","ObjectType=Product&typeNo="+sTypeNo,"right");
		}else if(sCurItemID=="3"){
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeCReductionList.jsp","typeNo="+sTypeNo,"right");
		}	
	
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem("1");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
