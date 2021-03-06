<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "借款详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;借款详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数,产品编号
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("businessType"));
	String sQuotaID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("quotaID"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("customerID"));
	if(sCustomerID == null) sCustomerID = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sQuotaID == null) sQuotaID = "";

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"借款详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	tviTemp.insertPage("root", "融资车辆信息", "", 1);
	tviTemp.insertPage("root", "借款信息", "", 2);
	
	%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sSerialNo="<%=sSerialNo %>";
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="1"){	
			AsControl.OpenView("/DistributorInfo/DistributorLoadDetailCarList.jsp","serialNo="+sSerialNo,"right");
		}else if(sCurItemID=="2"){
			AsControl.OpenView("/DistributorInfo/DistributorLoadDetailInfo.jsp","serialNo=<%=sSerialNo %>&businessType=<%=sBusinessType %>&quotaID=<%=sQuotaID %>&customerID=<%=sCustomerID %>","right");
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
