<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "商品类型列表";
	//获得页面参数
	String productTypeId = CurComp.getParameter("productTypeId");
    System.out.println("sProductTypeId==="+productTypeId);

	if (productTypeId == null) productTypeId = "";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProductListByProductType";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

 	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca, "010", "PRODUCT_ID", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "020", "PRODUCT_NAME", "Operators=EqualsString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca)); 
	
//	doTemp.setReadOnly("TypeNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	System.out.println(dwTemp.iPageCount);

	String sParam = "";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(productTypeId);
	for(int i=0;i<vTemp.size();i++) {
		out.print((String)vTemp.get(i));
	}
 	String sButtons[][] = {
			{"true","","Button","产品维护","产品维护","maintainProduct()",sResourcesPath},
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
			alert( "类型编号、类型名称不可以为空" );
			return;
		}else{
			as_save("myiframe0")
			parent.frames["frameleft"].reloadSelf();
		}
			
	}
	
	function deleteRecord(){
		var sProductTypeID = getItemValue(0,getRow(),"product_Type_Id");
		if (typeof(sProductTypeID)=="undefined" || sProductTypeID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
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
