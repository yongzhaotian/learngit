<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 维护贷后上传资料页面
	 */
	String PG_TITLE = "商品类型列表";
	//获得页面参数
	String productTypeId = CurComp.getParameter("productTypeId");
    System.out.println("sProductTypeId==="+productTypeId);

	if (productTypeId == null) productTypeId = "";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ImageByProductAfterLoan";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

/* 	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); */
	
//	doTemp.setReadOnly("TypeNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	System.out.println(dwTemp.iPageCount);
	
	doTemp.setVisible("IMAGE_TYPE_NO,IMAGE_TYPE_NAME",false);
	doTemp.setVisible("UPLOADDAYLIMIT,UPLOADCITY,OVERDUESTATUS",true);
	
	doTemp.setReadOnly("UPLOADDAYLIMIT,UPLOADCITY,OVERDUESTATUS", false);
	
	doTemp.setDDDWSql("OVERDUESTATUS", " SELECT ITEMNO, ITEMNAME FROM CODE_LIBRARY WHERE CODENO = 'Opinion' and itemno in (2, 3) ");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(productTypeId);
	for(int i=0;i<vTemp.size();i++) {
		out.print((String)vTemp.get(i));
	}
	String amount = Sqlca.getString(new SqlObject("select count(1) from product_ecm_upload where PRODUCT_TYPE_ID = "+productTypeId));
 	boolean flag = new Integer(amount).intValue() > 0;
	String sButtons[][] = {
 			{flag?"true":"false","All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
	}; 
 	%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">	

function selectCityObject(){
	var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
	if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
		alert("请选择城市！");
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
		var sProductTypeId = "<%=productTypeId%>"; //商品类型编号
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
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,UPLOADCITY,"+sUploadCity1+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,UPLOADCITY2,"+sUploadCity2+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,UPLOADCITY3,"+sUploadCity3+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,UPLOADCITY4,"+sUploadCity4+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,UPLOADCITY5,"+sUploadCity5+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,UPLOADCITY6,"+sUploadCity6+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,OVERDUESTATUS,"+sOverdueStatus+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
		RunMethod("公用方法","UpdateColValue","product_ecm_upload,UPLOADDAYLIMIT,"+sUploadLimit+",PRODUCT_TYPE_ID='"+sProductTypeId+"'");
//		as_save("myiframe0")
		alert("保存数据成功");
//		parent.frames["frameleft"].reloadSelf();
		parent.reloadSelf();
}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
//	initRow(); //页面装载时，对DW当前记录进行初始化
	var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.image.GetUploadCity", "getUploadCityStr", "productTypeID=<%=productTypeId%>");
	setItemValue(0, 0, "UPLOADCITY", sReturn);
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>