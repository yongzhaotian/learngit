<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "商品类型";

	// 获得页面参数
	String sProductCategoryID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("productCategoryID"));
	if(sProductCategoryID==null) sProductCategoryID = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProductCType";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause += " and IsinUse='1' ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProductCategoryID);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","新增","新增提款记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","详情记录","myDetail()",sResourcesPath},	
	        {"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}, 		
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/Products/ProductCTypeInfo.jsp","productCategoryID=<%=sProductCategoryID %>","_self");
	}
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function deleteRecord(){
		var sProductCTypeID = getItemValue(0,getRow(),"ProductCTypeID");	//获取删除记录的单元值
		if (typeof(sProductCTypeID)=="undefined" || sProductCTypeID.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}
	
	function myDetail(){
		var sProductCTypeID = getItemValue(0,getRow(),"ProductCTypeID");
		//AsControl.OpenView("/BusinessManage/Products/ProductCTypeInfo.jsp","productCTypeID="+sProductCTypeID,"_self");
		OpenPage("/BusinessManage/Products/ProductCTypeInfo.jsp?productCTypeID="+sProductCTypeID,"_self","");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
