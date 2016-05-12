<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@page import="com.amarsoft.app.als.image.HTMLTreeViewYX"%>
 <%
 
	/*
		页面说明:影像操作页面
	 */
	 
	//获得页面参数   typeNo:影像类型 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if( sObjectNo == null ) sObjectNo = null;
	if( sObjectType == null ) sObjectType = null;
	if(typeNo==null) typeNo ="";
	
	String sGlobalType = sObjectType.equals("Customer") ? "客户" : "业务";
	
	String PG_TITLE = sGlobalType+"影像资料"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = sGlobalType +"["+ sObjectNo + "]项下影像资料&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "300";//默认的treeview宽度
	if(typeNo.length()>0){
		PG_LEFT_WIDTH = "1";
	}
	
	//定义Treeview
	HTMLTreeViewYX tviTemp = new HTMLTreeViewYX(SqlcaRepository,CurComp,sServletURL,"影像资料","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//TODO 影像类型过滤，需要详细设计，暂时从简
	String sFilter =  "";
	String sAppend = " ";
	if( sObjectType.equals( "Customer" ) ){
		String sCustomerType = "";
		String sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID ";
		sCustomerType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sObjectNo));
		if( sCustomerType != null ){
			if( sCustomerType.startsWith( "01" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "02" ) ) sFilter = "1020";
			else if( sCustomerType.startsWith( "03" ) ) sFilter = "1010";
		}
		sAppend = " and ECM_IMAGE_TYPE.TypeNo Like '" + sFilter + "%' ";
	}else if( sObjectType.equals( "Business" ) ){
		String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_APPLY "+
				" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
		if( sBusinessType == null ) sBusinessType = " ";
		sFilter = "%";
		sAppend += " and ECM_IMAGE_TYPE.TypeNo In (Select ImageTypeNo From ECM_PRDIMAGE_RELA Where ProductID = '"+ sBusinessType +"') ";
	}
	
	/* String sTypeName = Sqlca.getString(new SqlObject("Select TypeName From ECM_IMAGE_TYPE Where TypeNo = :TypeNo").setParameter("TypeNo",sTypeNo));
	String sCount = Sqlca.getString( new SqlObject( "(Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like :TypeNo )" ).setParameter("TypeNo",sTypeNo+"%"));
	if( sTypeName == null ) sTypeName = "";
	if( sCount == null ) sCount = "";
	String sTitle = sGlobalType + "【" + sObjectNo +"】项下的影像资料：" +  "【" + sTypeName +"】(" + sCount + "件)"; */
	
	//定义树图结构
	String sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " + sAppend;
	//tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.documentId is not null and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> 件)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	//查询总数
	String querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 group  by ECM_PAGE.typeNo ";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(querySumSql));
	StringBuffer sbuf = new StringBuffer();
	while(rs.next()){
		int cc = rs.getInt("cc");
		String my_typeNo = rs.getString("typeNo");
		sbuf.append("setItemName('"+my_typeNo+"', getItemName('"+my_typeNo+"')+' ( " + cc + " 件)" +"');");
	}
	if(rs!=null) {
		rs.close();
	}
	
	rs.getStatement().close();

%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*影像类型 */
	var sTypeNo="<%=typeNo%>"; 
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--获得树图的节点号码
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID;
			//AsControl.OpenView( "/ImageManage/ImagePage.jsp", param, "right" );
			AsControl.OpenView( "/ImageTrans/ImageTrans.jsp", param, "right" );
			setTitle( "<%=sGlobalType%>【<%=sObjectNo%>】项下的影像资料：【" + getCurTVItem().name + "】" );
		}
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
		if(sTypeNo.length>0){
			selectItem(sTypeNo);
		}
		//用于显示各个项的数目信息
		<%=sbuf.toString()%>
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView().replaceAll( "addItem", "addItemYX" )%>
	}
		
	initTreeView();
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>
