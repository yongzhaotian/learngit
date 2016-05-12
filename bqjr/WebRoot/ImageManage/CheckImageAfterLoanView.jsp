<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.als.image.HTMLTreeViewYX"%>

<%
	/*
		Author:  yongxu 2015/05/25
		Tester:
		Content: Ӱ�������ļ����
		Input Param:
		Output param:
		History Log: 
	*/
	
	//���ҳ�����   typeNo:Ӱ������ 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
	//��Ʒ���Ͳ�ѯ
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
	
	String sGlobalType = sObjectType.equals("Customer") ? "�ͻ�" : "ҵ��";
	
	String PG_TITLE = sGlobalType+"Ӱ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = sGlobalType +"["+ sObjectNo + "]����Ӱ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "300";//Ĭ�ϵ�treeview���
	// ��Ϊ�������ŵ�����ʱ����С�����ͼ��� add by tbzeng 2014/04/16
	if ("RetailStore".equals(sObjectType)) {
		PG_LEFT_WIDTH = "260";
	}
	
	//����Treeview
	HTMLTreeViewYX tviTemp = new HTMLTreeViewYX(SqlcaRepository,CurComp,sServletURL,"Ӱ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//TODO Ӱ�����͹��ˣ���Ҫ��ϸ��ƣ���ʱ�Ӽ�
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
	} else if ("RetailStore".equals(sObjectType)) { //�����������ŵ�����
		sFilter = "60";
		sAppend = " and TypeNo like '" + sFilter + "%'";
	}
	
	String sCheckStatus = Sqlca.getString(new SqlObject("Select checkstatus From BUSINESS_CONTRACT Where SerialNo = :SerialNo").setParameter("SerialNo",sObjectNo));
	//������ͼ�ṹ
	String sSqlTreeView = "";
	if(sCheckStatus.equals("5")){//���Ϊ�������ϣ���ֻ��ʾ�д���Ҫ�����ϴ����ļ���Ϣ
		sSqlTreeView = "from ECM_IMAGE_TYPE where IsInUse = '1' and typeno in (select typeno from ecm_image_opinion eio where eio.objectType = 'BusinessLoan'  and (eio.checkopinion1 ='2' or eio.checkopinion1 ='3')) " + sAppend;
		tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	}else{
		sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " + sAppend;
		tviTemp.initWithSql("TypeNo","TypeName","","","",sSqlTreeView,"Order By TypeNo",Sqlca);
	}
	//ά����ʷ����������ʾ��ʼ
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
	//��ѯ����
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
		sbuf.append("setItemName('"+my_typeNo+"', getItemName('"+my_typeNo+"')+' ( " + cc + " ��)" +"');");
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
	/*Ӱ������ */
	var sTypeNo="<%=typeNo%>"; 
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--�����ͼ�Ľڵ����
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID+"&RightType=<%=sRightType%>";
			// ���⴦���������ŵ�����  
			if ("RetailStore"=="<%=sObjectType%>") {
				// ��������Ѿ��ϴ�����ɾ���ü�¼���ϴ�
				var sDocNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+<%=sObjectNo%>+"'");
				if (sDocNo!="Null") {
					RunMethod("���÷���", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+<%=sObjectNo%>+"'");
				}
                
				AsControl.OpenView("/ImageManage/ImageViewNewFrame.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID,"right1");
			} else {
				// ��������Ѿ��ϴ�����ɾ���ü�¼���ϴ�
				var sDocNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+<%=sObjectNo%>+"'");
				if (sDocNo!="Null") {
					RunMethod("���÷���", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+<%=sObjectNo%>+"'");
				}
				var sReturn1 = RunMethod("���÷���","GetColValue","BUSINESS_CONTRACT,checkstatus,SerialNo = '"+<%=sObjectNo%>+"' ");
				if(sReturn1 == "4" || sReturn1 == "7"){
					AsControl.OpenView("/ImageManage/ImageViewInfo.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID+"uploadPeriod=1","right");
				}else{
					AsControl.OpenView("/ImageManage/ImageViewNewFrame.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID+"&uploadPeriod=1","right");
				}
			}
			setTitle( "<%=sGlobalType%>��<%=sObjectNo%>�����µ�Ӱ�����ϣ���" + getCurTVItem().name + "��" );
		}
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
		if(sTypeNo.length>0){
			selectItem(sTypeNo);
		}
		//������ʾ���������Ŀ��Ϣ
		<%=sbuf.toString()%>
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView().replaceAll( "addItem", "addItemYX" )%>
	}
		
	initTreeView();
	expandAll();
</script>

<%@ include file="/IncludeEnd.jsp"%>