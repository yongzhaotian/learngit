<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 对象类型Tab列表
	 */
	String PG_TITLE = "对象类型Tab配置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
 	String sTempletNo = "ObjTypeRelaList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaInfo.jsp","_self","");      
	}
	
	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		if(typeof(sObjectType) == "undefined" || sObjectType.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        
       OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaInfo.jsp?ObjectType="+sObjectType+"&RelationShip="+sRelationShip,"_self","");           
	}
    
	function deleteRecord(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");		
		if(typeof(sObjectType) == "undefined" || sObjectType.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function exportAll(){
		amarExport("myiframe0");
	}	
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>