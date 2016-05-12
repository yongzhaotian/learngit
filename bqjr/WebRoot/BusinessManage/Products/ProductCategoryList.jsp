<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "商品范畴";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProductCategory";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.setColumnAttribute("ProductCategoryName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","新增","新增提款记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","详情记录","myDetail()",sResourcesPath},	
	        {"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}, 
			
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function mySelectRow(){
		var sProductCategoryID = getItemValue(0,getRow(),"ProductCategoryID");
		if(typeof(sProductCategoryID)=="undefined" || sProductCategoryID.length==0) {
			alert(getHtmlMessage(1));
		}else{
			AsControl.OpenView("/BusinessManage/Products/ProductCTypeList.jsp", "productCategoryID="+sProductCategoryID, "rightdown","");
		}
	}
	
	//新增记录
	function newRecord(){
		var sProductCategoryID = getItemValue(0,getRow(),"ProductCategoryID");
		sCompID = "ProductCTypeInfo";
		sCompURL = "/BusinessManage/Products/ProductCategoryInfo.jsp";
	    popComp(sCompID,sCompURL,"productCategoryID= ","dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
    
	function myDetail(){
		var sProductCategoryID = getItemValue(0,getRow(),"ProductCategoryID");
		if(typeof(sProductCategoryID)=="undefined" || sProductCategoryID.length==0) {
			alert(getHtmlMessage(1));
		}else {
			AsControl.OpenView("/BusinessManage/Products/ProductCategoryInfo.jsp", "productCategoryID="+sProductCategoryID, "_self","");
		}
	}
	
	function deleteRecord(){
		var sProductCategoryID =getItemValue(0,getRow(),"ProductCategoryID");//获取删除记录的单元值
		if (typeof(sProductCategoryID)=="undefined" || sProductCategoryID.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			RunMethod("DeleteNumber","GetDeleteNumber1","Product_CType,productcategoryid='"+sProductCategoryID+"'");
			parent.reloadSelf();
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>