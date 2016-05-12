<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "产品系列详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;产品系列详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数,产品编号
	String sProductID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("productID"));
	if(sProductID == null) sProductID = "";
	//产品类型
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductType"));
    if(null == sProductType) sProductType = "";
	//产品子类型
    String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubProductType"));
    if(null == sSubProductType) sSubProductType = "";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"产品系列详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	tviTemp.insertPage("root", "基本信息", "", 1);
	tviTemp.insertPage("root", "产品分配", "", 2);
	tviTemp.insertPage("root", "文档信息", "", 3);
	
	%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>

<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sProductID="<%=sProductID%>";
		var sCurItemName = getCurTVItem().name;
		if(sCurItemName=="基本信息"){	
			AsControl.OpenView("/BusinessManage/Products/ProductTypesDetailsInfo.jsp","productID="+sProductID+"&SubProductType=<%=sSubProductType%>","right");
		}else if(sCurItemName=="产品分配"){
			AsControl.OpenView("/BusinessManage/Products/ProductTypesDetailsInfo1.jsp","productID="+sProductID+"&ProductType=<%=sProductType%>","right");//update 现金贷需求
		}else if(sCurItemName=="文档信息"){
			AsControl.OpenView("/AppConfig/Document/ProductTypeAttachmentList.jsp","DocNo="+sProductID+"&UserID=<%=CurUser.getUserID()%>","right");
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
