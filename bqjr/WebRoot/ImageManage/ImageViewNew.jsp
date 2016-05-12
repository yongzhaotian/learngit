<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.als.image.HTMLTreeViewYX"%>

<%
 
	/*
		ҳ��˵��:Ӱ�����ҳ��
	 */
	 
	//���ҳ�����   typeNo:Ӱ������ 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
	//��ȡ�жϴ�ǰ���Ǵ������ݵĲ���
	String uploadPeriod = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("uploadPeriod"));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(typeNo==null) typeNo ="";
	if(sRightType==null) sRightType ="";
	if(uploadPeriod==null) uploadPeriod="";
	
	String sGlobalType = sObjectType.equals("Customer") ? "�ͻ�" : "ҵ��";
	
	String PG_TITLE = sGlobalType+"Ӱ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = sGlobalType +"["+ sObjectNo + "]����Ӱ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "300";//Ĭ�ϵ�treeview���
	/* if(typeNo.length()>0){
		PG_LEFT_WIDTH = "1";
	} */
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
	/* 	String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_APPLY "+
				" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
		if( sBusinessType == null ) sBusinessType = " ";
		//sFilter = "%";
		sAppend = "and TypeNo Like '" + sFilter + "%'"; */
		//���ݴ�ǰ����״̬�����ù�����ѯ��
		//��Ʒ���Ͳ�ѯ
		String sProductCategory = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT "+
				" Where SerialNo = :SerialNo ").setParameter( "SerialNo", sObjectNo ) );
		//��Ʒ���Ͳ�ѯ
		String sProductID = Sqlca.getString( new SqlObject("Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID " +
                " from business_contract where serialno = :SerialNo ").setParameter( "SerialNo", sObjectNo ) );
		while(sProductID.endsWith(",")){
			sProductID = sProductID.substring(0, sProductID.length()-1);
		}
		if( sProductCategory == null ) sProductCategory = " ";
		
		if("1".equals(uploadPeriod)){
			// ��ʾ��������
		
			sAppend += " and TypeNo In (Select IMAGE_TYPE_NO from PRODUCT_ECM_UPLOAD where PRODUCT_TYPE_ID in ("+sProductID+"))";
		}else if("2".equals(uploadPeriod)){
			//�ڿ��ٲ�ѯҳ����ʾ��ǰ�ʹ�������
			sAppend += " and TypeNo In (Select IMAGE_TYPE_NO from PRODUCT_ECM_TYPE where PRODUCT_TYPE_ID in (Select PRODUCT_TYPE_ID  from PRODUCT_TYPE_CTYPE where PRODUCT_ID = '"+sProductCategory+"'))";
			sAppend += " or TypeNo In (Select IMAGE_TYPE_NO from PRODUCT_ECM_UPLOAD where PRODUCT_TYPE_ID in ("+sProductID+"))";
		}else{
			//��ʾ��ǰ����
			sAppend += " and TypeNo In (Select IMAGE_TYPE_NO from PRODUCT_ECM_TYPE where PRODUCT_TYPE_ID in (Select PRODUCT_TYPE_ID  from PRODUCT_TYPE_CTYPE where PRODUCT_ID = '"+sProductCategory+"'))";
		}
	} else if ("RetailStore".equals(sObjectType)) { // add by tbzeng 2014/04/16 �����������ŵ�����
		sFilter = "60";
		sAppend = " and TypeNo like '" + sFilter + "%'";
	}
	
	/* String sTypeName = Sqlca.getString(new SqlObject("Select TypeName From ECM_IMAGE_TYPE Where TypeNo = :TypeNo").setParameter("TypeNo",sTypeNo));
	String sCount = Sqlca.getString( new SqlObject( "(Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like :TypeNo )" ).setParameter("TypeNo",sTypeNo+"%"));
	if( sTypeName == null ) sTypeName = "";
	if( sCount == null ) sCount = "";
	String sTitle = sGlobalType + "��" + sObjectNo +"�����µ�Ӱ�����ϣ�" +  "��" + sTypeName +"��(" + sCount + "��)"; */
	
	//������ͼ�ṹ
	String sSqlTreeView = "from ECM_IMAGE_TYPE where  IsInUse = '1' " + sAppend;
	//tviTemp.initWithSql("TypeNo","case when (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.documentId is not null and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') > 0 then ( TypeName || '( <font color=\"red\">' || (Select Count(*) FROM ECM_PAGE Where ECM_PAGE.ObjectNo = '"+sObjectNo+"' and ECM_PAGE.TypeNo Like ECM_IMAGE_TYPE.TypeNo || '%') || '</font> ��)') else TypeName end as TypeName ","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
		tviTemp.initWithSql("TypeNo","TypeName","TypeName","","",sSqlTreeView,"Order By TypeNo",Sqlca);
		//��ѯ����
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
		tmpRs.close();
	}
	//ά����ʷ����������ʾ����
	String querySumSql = "";
	if("1".equals(uploadPeriod)){
		querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 and ECM_PAGE.objectType = 'BusinessLoan' ";
		if(tmpTypeNoStr!=null && ""!=tmpTypeNoStr.trim()){
			querySumSql += "and TypeNo in ("+tmpTypeNoStr+") ";
		}
		querySumSql+="group  by ECM_PAGE.typeNo";
	}else if("2".equals(uploadPeriod)){
		querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 ";
		if(tmpTypeNoStr!=null && ""!=tmpTypeNoStr.trim()){
			querySumSql += "and TypeNo in ("+tmpTypeNoStr+") ";
		}
		querySumSql+="group  by ECM_PAGE.typeNo";
	}else {
		querySumSql = "select count(*) as cc, typeNo from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 and ECM_PAGE.objectType = 'Business'  ";
		if(tmpTypeNoStr!=null && ""!=tmpTypeNoStr.trim()){
			querySumSql += "and TypeNo in ("+tmpTypeNoStr+") ";
		}
		querySumSql+="group  by ECM_PAGE.typeNo";
	}
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(querySumSql));
	StringBuffer sbuf = new StringBuffer();
	while(rs.next()){
		int cc = rs.getInt("cc");
		String my_typeNo = rs.getString("typeNo");
		sbuf.append("setItemName('"+my_typeNo+"', getItemName('"+my_typeNo+"')+' ( " + cc + " ��)" +"');");
	}
	if(rs!=null) {
		rs.close();
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
	var sUploadPeriod = "<%=uploadPeriod%>";
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;//--�����ͼ�Ľڵ����
		if( sCurItemID != "null" && sCurItemID != "root" && hasChild(getCurTVItem().id) ){
			var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sCurItemID+"&RightType=<%=sRightType%>";
			//AsControl.OpenView( "/ImageTrans/ImageTrans.jsp", param, "right" );
			// ���⴦���������ŵ�����  add by tbzeng 2014/04/16
			if ("RetailStore"=="<%=sObjectType%>") {
				//AsControl.OpenView( "/ImageManage/ImagePage.jsp", param, "right1" );
				// ��������Ѿ��ϴ�����ɾ���ü�¼���ϴ�
				var sDocNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+<%=sObjectNo%>+"'");
				if (sDocNo!="Null") {
					RunMethod("���÷���", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+<%=sObjectNo%>+"'");
				}
                
				AsControl.OpenView("/ImageManage/ImageViewNewFrame.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID+"&uploadPeriod="+sUploadPeriod,"right1");
			} else {
				//AsControl.OpenView( "/ImageManage/ImagePage.jsp", param, "right" );
				// ��������Ѿ��ϴ�����ɾ���ü�¼���ϴ�
				var sDocNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+<%=sObjectNo%>+"'");
				if (sDocNo!="Null") {
					RunMethod("���÷���", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+<%=sObjectNo%>+"'");
				}
                
				AsControl.OpenView("/ImageManage/ImageViewNewFrame.jsp","DocNo="+<%=sObjectNo%>+"&TypeNo="+sCurItemID+"&uploadPeriod="+sUploadPeriod,"right");
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
