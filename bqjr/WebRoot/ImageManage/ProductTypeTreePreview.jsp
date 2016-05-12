<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//获得页面参数
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	if (sType == null) sType = "";
	String sStartWithId = CurComp.getParameter("StartWithId");
	if (sStartWithId == null) sStartWithId = "";
%>

<%
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"商品范畴预览","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.TriggerClickEvent=true;
	
	String sFilter = "";
	/* if( sType.equals( "Customer" ) ) sFilter = "10";
	else if( sType.equals( "Business" ) ) sFilter = "20"; */
	
	String sSqlTreeView = "from PRODUCT_TYPE "; //and IsInUse = '1'
	tviTemp.initWithSql("distinct Product_Type_Id","Product_Type_Name"," Product_Type_Name ","","",sSqlTreeView,"Order By Product_Type_Id",Sqlca);
%>
<html>
<head>
<title>商品范畴预览</title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
	<div style="positition:absolute;align:left;height:430px;overflow-y: hide;">
		<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
	</div>
</body>
</html>

<script type="text/javascript">

	function TreeViewOnClick() {
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
	//	var mediaTypeNo = parent.document.getElementById("mediaTypeNo").value;
//		AsControl.OpenView("/ImageManage/ProductTypeTreePreview.jsp", "StartWithId="+mediaTypeNo, "frameleft","left");
		AsControl.OpenView( "/ImageManage/ImageAndProductManageFrame.jsp", "productTypeId="+sCurItemID, "frameright","" );
		setTitle( "商品范畴预览" ); 
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
	}

	<%out.println(tviTemp.generateHTMLTreeView());%>
	setDialogTitle("商品范畴预览");
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>