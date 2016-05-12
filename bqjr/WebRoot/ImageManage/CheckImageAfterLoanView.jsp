<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.als.image.HTMLTreeViewYX"%>

<%
	/*
		Author:  yongxu 2015/05/25
		Tester:
		Content: 影像类型文件检查
		Input Param:
		Output param:
		History Log: 
	*/
	
	//获得页面参数   typeNo:影像类型 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
	//商品类型查询
	String sProductID = Sqlca.getString( new SqlObject("Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID " +
            " from business_contract where serialno = :SerialNo ").setParameter( "SerialNo", sObjectNo ) );
	while(sProductID.endsWith(",")){
		sProductID = sProductID.substring(0, sProductID.length()-1);
	}
	if(sProductID == null) sProductID = "";

	
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(typeNo==null) typeNo ="";
	if(sRightType==null) sRightType ="";
	
	String sGlobalType = sObjectType.equals("Customer") ? "客户" : "业务";
	
	String PG_TITLE = sGlobalType+"影像资料"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = sGlobalType +"["+ sObjectNo + "]项下影像资料&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "300";//默认的treeview宽度
	// 当为零售商门店申请时，缩小左侧树图宽度 add by tbzeng 2014/04/16
	if ("RetailStore".equals(sObjectType)) {
		PG_LEFT_WIDTH = "260";
	}
	
	//定义Treeview
	HTMLTreeViewYX tviTemp = new HTMLTreeViewYX(SqlcaRepository,CurComp,sServletURL,"影像资料","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//TODO 影像类型过滤，需要详细设计，暂时从简
	String sFilter =  typeNo;
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
		sAppend = " and TypeNo Like '" + sFilter + "%' ";
	}else if( sObjectType.equals( "Business" ) ){
		/* String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT "+
				" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
		if( sBusinessType == null ) sBusinessType = " "; */		
		sAppend += " and TypeNo In (Select IMAGE_TYPE_NO from PRODUCT_ECM_UPLOAD where PRODUCT_TYPE_ID in ('"+sProductID+"'))";
	} else if ("RetailStore".equals(sObjectType)) { //处理零售商门店申请
		sFilter = "60";
		sAppend = " and TypeNo like '" + sFilter + "%'";
	}
	
	String sCheckStatus = Sqlca.getString(new SqlObject("Select checkstatus From BUSINESS_CONTRACT Where SerialNo = :SerialNo").setParameter("SerialNo",sObjectNo));
	//定义树图结构
	String sSqlTreeView = "";
	if(sCheckStatus.equals("5")){//如果为补充资料，则只显示有错误要重新上传的文件信息
		sSqlTreeView = "from ECM_IMAGE_TYPE where IsInUse = '1' and typeno in (select typeno from ecm_image_opinion eio where eio.objectType = 'BusinessLoan'  and (eio.checkopinion1 ='2' or eio.checkopinion1 ='3')) " + sAppend;
		tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	}else{
		sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " + sAppend;
		tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	}
	//维护历史数据正常显示开始
	ASResultSet tmpRs  =  Sqlca.getASResultSet("Select TypeNo "+sSqlTreeView);
	String tmpTypeNoStr = "";
	while(tmpRs.next()){
		String tmpTypeNo = tmpRs.getString("typeNo");
		tmpTypeNoStr += tmpTypeNo+",";
	}
	while(tmpTypeNoStr.endsWith(",")){
		tmpTypeNoStr = tmpTypeNoStr.substring(0, tmpTypeNoStr.length()-1);
	}
	if(tmpRs!=null) {
		tmpRs.getStatement().close();
	}
	//查询总数
	String querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and ECM_PAGE.objectType = 'BusinessLoan'  and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 ";
	if(tmpTypeNoStr!=null && ""!=tmpTypeNoStr.trim()){
		querySumSql += "and TypeNo in ("+tmpTypeNoStr+") ";
	}
	querySumSql+="group  by ECM_PAGE.typeNo";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(querySumSql));
	StringBuffer sbuf = new StringBuffer();
	while(rs.next()){
		int cc = rs.getInt("cc");
		String my_typeNo = rs.getString("typeNo");
		sbuf.append("setItemName('"+my_typeNo+"', getItemName('"+my_typeNo+"')+' ( " + cc + " 件)" +"');");
	}
	if(rs!=null) {
		rs.getStatement().close();
	}
	
	//rs.getStatement().close();

%><%if ("RetailStore".equals(sObjectType)){ %> 
<%@include file="/Resources/CodeParts/View0401.jsp"%>
<%} else {%>
<%@include file="/Resources/CodeParts/View04.jsp"%>
<%}%>

<script type="text/javascript"> 
	/*影像类型 */
	var sTypeNo="<%=typeNo%>"; 
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--获得树图的节点号码
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID+"&RightType=<%=sRightType%>";
			// 特殊处理零售商门店申请  
			if ("RetailStore"=="<%=sObjectType%>") {
				// 如果附件已经上传，先删除该记录再上传
				var sDocNo = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+<%=sObjectNo%>+"'");
				if (sDocNo!="Null") {
					RunMethod("公用方法", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+<%=sObjectNo%>+"'");
				}
                
				AsControl.OpenView("/ImageManage/ImageViewNewFrame.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID,"right1");
			} else {
				// 如果附件已经上传，先删除该记录再上传
				var sDocNo = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+<%=sObjectNo%>+"'");
				if (sDocNo!="Null") {
					RunMethod("公用方法", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+<%=sObjectNo%>+"'");
				}
				var sReturn1 = RunMethod("公用方法","GetColValue","BUSINESS_CONTRACT,checkstatus,SerialNo = '"+<%=sObjectNo%>+"' ");
				if(sReturn1 == "4" || sReturn1 == "7"){
					AsControl.OpenView("/ImageManage/ImageViewInfo.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID+"uploadPeriod=1","right");
				}else{
					AsControl.OpenView("/ImageManage/ImageViewNewFrame.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID+"&uploadPeriod=1","right");
				}
			}
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