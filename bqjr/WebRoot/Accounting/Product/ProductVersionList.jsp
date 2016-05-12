<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "产品版本信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>

<%
	//获得页面参数,产品编号
	String ProductID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeNo"));
	if(ProductID == null) ProductID = "";
%>

<%

	//生成DW对象
	String sTempletNo = "ProductVersionList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	//增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//设置页面显示的列数
	dwTemp.setPageSize(10);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(ProductID);
	for(int i=0;i<vTemp.size();i++)out.print((String)vTemp.get(i));

%>


<%
	String sButtons[][] = {
			{"true","","Button","新增版本","新增版本","newRecord()",sResourcesPath},
			{"true","","Button","新增并复制版本","新增版本信息","copyRecord()",sResourcesPath},
			{"true","","Button","版本详情","查看某个版本基本信息","viewAndEdit()",sResourcesPath},//查看版本信息时将不再显示关联版本信息
			{"true","","Button","删除版本","删除未生效的产品版本","deleteRecord()",sResourcesPath},
			{"true","","Button","版本启用","版本启用","changeVersionStatus(1)",sResourcesPath},
			{"true","","Button","版本停用","停用已生效的产品版本","changeVersionStatus(2)",sResourcesPath},
	};
%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	//新增版本
	function newRecord(){
		var userID = "<%=CurUser.getUserID()%>";
		var newVersionID = AsControl.PopView("/Accounting/Product/CopyVersionDialog.jsp","","resizable=yes;dialogWidth=20;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(newVersionID) != "undefined" && newVersionID.length != 0 && newVersionID != '_CANCEL_'){
			var sReturn = RunMethod("ProductManage","CreateProductVersion",<%=ProductID%>+","+newVersionID+","+userID);
        	if(sReturn=="true") {
        		AsControl.OpenView("/Accounting/Product/ProductFunctionDef.jsp","ProductID=<%=ProductID%>"+"&VersionID="+newVersionID,"_blank",OpenStyle);
            	reloadSelf();
        	}else
            	alert("新增版本失败！");
        	return;
		}
	}
	function copyRecord()
	{
		var userID = "<%=CurUser.getUserID()%>";
		var ProductID = getItemValue(0,getRow(),"ProductID");
		var versionID = getItemValue(0,getRow(),"VersionID");//--获取版本编号
		//新增并复制版本
		if(typeof(versionID)=="undefined" || versionID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}else{//新增并复制版本
			var newVersionID = AsControl.PopView("/Accounting/Product/CopyVersionDialog.jsp","","resizable=yes;dialogWidth=20;dialogHeight=10;center:yes;status:no;statusbar:no");
			if(typeof(newVersionID) != "undefined" && newVersionID.length != 0 && newVersionID != '_CANCEL_'){
				var sReturn = RunMethod("ProductManage","CopyProductVersion",ProductID+","+versionID+","+newVersionID+","+userID);
	        	if(sReturn=="true") {
	        		AsControl.OpenView("/Accounting/Product/ProductFunctionDef.jsp","ProductID="+ProductID+"&VersionID="+newVersionID,"_blank",OpenStyle);
	            	reloadSelf();
	        	}
			}
		}		
	}

	function viewAndEdit()
	{
		var ProductID = getItemValue(0,getRow(),"ProductID");//--获取产品编号
		var versionID = getItemValue(0,getRow(),"VersionID");//--获取版本编号
	    if(typeof(ProductID)=="undefined" || ProductID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
	    AsControl.OpenView("/Accounting/Product/ProductFunctionDef.jsp","ProductID="+ProductID+"&VersionID="+versionID,"_blank",OpenStyle);
        reloadSelf();
	}

	function changeVersionStatus(status)
	{	
		var productID = getItemValue(0,getRow(),"ProductID");//--获取产品编号
		var versionID = getItemValue(0,getRow(),"VersionID");//--获取版本编号
		var isNew = getItemValue(0,getRow(),"IsNew");
	    if(typeof(productID)=="undefined" || productID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	        return ;
		}
		if(isNew==status){
			alert("已经是该状态！");
			return;
			}
		var sReturn = RunMethod("ProductManage","StartNewVersion",productID+","+versionID+","+status);//执行更新，返回更新结果
		if(sReturn=="true"){
			alert("版本更新成功！");
			reloadSelf();
		}else{
			alert("版本更新失败！");
			reloadSelf();
		}
	}
	
	function deleteRecord()
	{
		VersionID = getItemValue(0,getRow(),"VersionID");
		ProductID   = getItemValue(0,getRow(),"ProductID");
		if (typeof(VersionID)=="undefined" || VersionID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(confirm("您真的想删除该信息吗？")){
			sReturn = RunMethod("ProductManage","DeleteVersionInfo",ProductID+","+VersionID);
			if(sReturn=="true"){
	    		alert("版本信息删除成功!");
			}else{
				alert("版本信息删除失败!");
			}
   		}
   		reloadSelf();
	}
	
</script>
	
	<script language=javascript>	
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	</script>	


<%@ include file="/IncludeEnd.jsp"%>
