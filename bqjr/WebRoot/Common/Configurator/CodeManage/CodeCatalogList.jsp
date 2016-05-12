<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 代码目录列表
	 */
	String PG_TITLE = "代码目录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获得页面参数	
	String sCodeTypeOne =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeOne"));
	String sCodeTypeTwo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeTwo"));
	//将空值转化为空字符串	
	if (sCodeTypeOne == null) sCodeTypeOne = ""; 
	if (sCodeTypeTwo == null) sCodeTypeTwo = ""; 

	
 	//通过DW模型产生ASDataObject对象doTemp
 	String sTempletNo = "CodeCatalogList";//模型编号
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
 	doTemp.multiSelectionEnabled=false;//?
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
 		
	if(sCodeTypeOne!=null && !sCodeTypeOne.equals("")) doTemp.WhereClause+=" and CodeTypeOne='"+sCodeTypeOne+"'";
	if(sCodeTypeTwo!=null && !sCodeTypeTwo.equals("")) doTemp.WhereClause+=" and CodeTypeTwo='"+sCodeTypeTwo+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelCodeLibrary(#CodeNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","代码列表","查看/修改代码详情","viewAndEditCode()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","导出","导出所选中的记录","exportDataObject()",sResourcesPath},
		{"true","","Button","生成SortNo","生成SortNo","GenerateCodeCatalogSortNo()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeTypeOne=<%=sCodeTypeOne%>&CodeTypeTwo=<%=sCodeTypeTwo%>","");
		reloadSelf();        
	}
	
	function viewAndEdit(){
       var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
  		popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeNo="+sCodeNo,"");
	}
    
    /*~[Describe=查看及修改代码详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditCode(){
       var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       var sCodeName = getItemValue(0,getRow(),"CodeName");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		popComp("CodeItem","/Common/Configurator/CodeManage/CodeItemList.jsp","CodeNo="+sCodeNo+"&CodeName="+sCodeName,"");  
	}

	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function exportDataObject(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sServerRoot = "";
		sReturn = PopPageAjax("/Common/Configurator/ObjectExim/ExportDataObjectAjax.jsp?ObjectType=Code&ObjectNo="+sCodeNo+"&ServerRootPath="+sServerRoot,"","");
		if(sReturn=="succeeded"){
			alert("成功导出数据！");
		}
	}
	
	function GenerateCodeCatalogSortNo(){
		RunMethod("Configurator","GenerateCodeCatalogSortNo","");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>