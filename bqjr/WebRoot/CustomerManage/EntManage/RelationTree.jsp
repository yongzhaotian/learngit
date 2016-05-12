<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.customer.model.CustomerRelationTreeModel"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "关联关系智能搜索"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "2000";//默认的treeview宽度
	//获得组件参数:客户编号,搜索层次
	String customerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String searchLevel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SearchLevel"));
	if(customerID == null) customerID = "";
	if(searchLevel == null) searchLevel = "3";//默认为3层
	HTMLTreeView tviTemp= new CustomerRelationTreeModel(customerID,"0",searchLevel).getRelationTree(sResourcesPath,Sqlca);
%>
<%@include file="/Resources/CodeParts/View05.jsp"%>
<script type="text/javascript"> 
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		if (sCurItemID == "root")
			return;
		var sCurItemName = getCurTVItem().name;
		if (isNull(sCurItemName) || sCurItemName.indexOf("客户无详细信息")>0) {
			alert("该客户无详细信息,请在客户信息列表中添加该客户!");
			return;
		}
		var sCustomerID=getCurTVItem().value;
		openObject("Customer",sCustomerID,"002");
	}

	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	startMenu();
	expandNode('root');
</script> 
<%@ include file="/IncludeEnd.jsp"%>