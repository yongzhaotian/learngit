<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ά�������ϴ�����ҳ��
	 */
	String PG_TITLE = "��Ʒ�����б�";
	//���ҳ�����
	String productTypeId = CurComp.getParameter("productTypeId");
    System.out.println("sProductTypeId==="+productTypeId);

	if (productTypeId == null) productTypeId = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ImageByProductAfterLoan";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

/* 	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); */
	
//	doTemp.setReadOnly("TypeNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	System.out.println(dwTemp.iPageCount);
	
	doTemp.setVisible("IMAGE_TYPE_NO,IMAGE_TYPE_NAME",false);
	doTemp.setVisible("UPLOADDAYLIMIT,UPLOADCITY,OVERDUESTATUS",true);
	
	doTemp.setReadOnly("UPLOADDAYLIMIT,UPLOADCITY,OVERDUESTATUS", false);
	
	doTemp.setDDDWSql("OVERDUESTATUS", " SELECT ITEMNO, ITEMNAME FROM CODE_LIBRARY WHERE CODENO = 'Opinion' and itemno in (2, 3) ");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(productTypeId);
	for(int i=0;i<vTemp.size();i++) {
		out.print((String)vTemp.get(i));
	}
	String amount = Sqlca.getString(new SqlObject("select count(1) from product_ecm_upload where PRODUCT_TYPE_ID = "+productTypeId));
 	boolean flag = new Integer(amount).intValue() > 0;
	String sButtons[][] = {
 			{flag?"true":"false","All","Button","����","���������޸�","saveRecord()",sResourcesPath},
	}; 
 	%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">	

function selectCityObject(){
	var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
	if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
		alert("��ѡ����У�");
		return;
	}
	var orgName = retVal.split("~");
	var sOrgId = "";
	var sOrgName = "";
	for (var i in orgName) {
		sOrgId += orgName[i].split("@")[0]+"@";
		sOrgName += orgName[i].split("@")[1]+"@";
	}
	sOrgId = sOrgId.substring(0,sOrgId.length-1);
	setItemValue(0, 0, "UPLOADCITY", sOrgName);
}

function saveRecord(){
		var sProductTypeId = "<%=productTypeId%>"; //��Ʒ���ͱ��
		var sOverdueStatus = getItemValue(0,0,"OVERDUESTATUS");
		var sUploadCity = getItemValue(0,0,"UPLOADCITY");
		var sUploadLimit = getItemValue(0,0,"UPLOADDAYLIMIT");
		var sUploadCity1 = "";
		var sUploadCity2 = "";
		var sUploadCity3 = "";
		var sUploadCity4 = "";
		var sUploadCity5 = "";
		var sUploadCity6 = "";
		var len = sUploadCity.length;
		if(len < 500){
			sUploadCity1 = sUploadCity.substring(0, len);
		}else if(len > 500 && len < 1000){
			sUploadCity1 = sUploadCity.substring(0, 500);
			sUploadCity2 = sUploadCity.substring(500, len);
		}else if(len > 1000 && len < 1500){
			sUploadCity1 = sUploadCity.substring(0, 500);
			sUploadCity2 = sUploadCity.substring(500, 1000);
			sUploadCity3 = sUploadCity.substring(1000, len);
		}else if(len > 1500 && len < 2000){
			sUploadCity1 = sUploadCity.substring(0, 500);
			sUploadCity2 = sUploadCity.substring(500, 1000);
			sUploadCity3 = sUploadCity.substring(1000, 1500);
			sUploadCity4 = sUploadCity.substring(1500, len);
		}else if(len > 2000 && len < 2500){
			sUploadCity1 = sUploadCity.substring(0, 500);
			sUploadCity2 = sUploadCity.substring(500, 1000);
			sUploadCity3 = sUploadCity.substring(1000, 1500);
			sUploadCity4 = sUploadCity.substring(1500, 2000);
			sUploadCity5 = sUploadCity.substring(2000, len);
		}else if(len > 2500){
			sUploadCity1 = sUploadCity.substring(0, 500);
			sUploadCity2 = sUploadCity.substring(500, 1000);
			sUploadCity3 = sUploadCity.substring(1000, 1500);
			sUploadCity4 = sUploadCity.substring(1500, 2000);
			sUploadCity5 = sUploadCity.substring(2000, 2500);
			sUploadCity6 = sUploadCity.substring(2500, len);
		}
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,UPLOADCITY,"+sUploadCity1+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,UPLOADCITY2,"+sUploadCity2+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,UPLOADCITY3,"+sUploadCity3+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,UPLOADCITY4,"+sUploadCity4+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,UPLOADCITY5,"+sUploadCity5+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,UPLOADCITY6,"+sUploadCity6+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,OVERDUESTATUS,"+sOverdueStatus+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("���÷���","UpdateColValue","product_ecm_upload,UPLOADDAYLIMIT,"+sUploadLimit+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
//		as_save("myiframe0")
		alert("�������ݳɹ�");
//		parent.frames["frameleft"].reloadSelf();
		parent.reloadSelf();
}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
//	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.image.GetUploadCity", "getUploadCityStr", "productTypeID=<%=productTypeId%>");
	setItemValue(0, 0, "UPLOADCITY", sReturn);
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>