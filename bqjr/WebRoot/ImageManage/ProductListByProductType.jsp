<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��Ʒ�����б�";
	//���ҳ�����
	String productTypeId = CurComp.getParameter("productTypeId");
    System.out.println("sProductTypeId==="+productTypeId);

	if (productTypeId == null) productTypeId = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ProductListByProductType";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

 	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca, "010", "PRODUCT_ID", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "020", "PRODUCT_NAME", "Operators=EqualsString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); 
	
//	doTemp.setReadOnly("TypeNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	System.out.println(dwTemp.iPageCount);

	String sParam = "";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(productTypeId);
	for(int i=0;i<vTemp.size();i++) {
		out.print((String)vTemp.get(i));
	}
 	String sButtons[][] = {
			{"true","","Button","��Ʒά��","��Ʒά��","maintainProduct()",sResourcesPath},
	}; 

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
		as_add( "myiframe0" );
		var param = "productTypeId=<%=productTypeId%>";
		var sNewExampleTypeNo = RunJavaMethodSqlca( "com.amarsoft.app.als.image.ImageUtil", "GetNewTypeNo", param );
		setItemValue( 0, getRow(), "TypeNo", sNewExampleTypeNo );
	}
	
	function saveRecord(){
		var sProductTypeID = getItemValue(0,getRow(),"product_Type_Id");
		var sProductTypeName = getItemValue(0,getRow(),"product_Type_Name");
		if( (typeof sProductTypeID !="undefined") && (sProductTypeID == "" || sProductTypeName == "") ){
			alert( "���ͱ�š��������Ʋ�����Ϊ��" );
			return;
		}else{
			as_save("myiframe0")
			parent.frames["frameleft"].reloadSelf();
		}
			
	}
	
	function deleteRecord(){
		var sProductTypeID = getItemValue(0,getRow(),"product_Type_Id");
		if (typeof(sProductTypeID)=="undefined" || sProductTypeID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			param = "imageTypeNo="+sProductTypeID;
			RunJavaMethodSqlca( "com.amarsoft.app.als.image.ManagePRDImageRela", "delRelationByImageTypeNo", param );
		}
	}
	
	function maintainProduct(){
		var sProductTypeId = getItemValue(0,getRow(),"PRODUCT_TYPE_ID");
		var re = PopPage("/ImageManage/AddProduct.jsp?ProductTypeId="+<%=productTypeId%>,"","dialogWidth=1000px;dialogHeight=350px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
	    if(re==1){
			window.location.reload();
        }
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
