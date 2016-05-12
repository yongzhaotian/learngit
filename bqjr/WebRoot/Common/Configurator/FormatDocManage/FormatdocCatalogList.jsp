<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 格式化报告模型列表
	 */
	String PG_TITLE = "格式化报告模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String[][] sHeaders={
			{"DocID","报告编号"},
			{"DocName","报告名称"}
		};

	String sSql =  " select DocID,DocName from FormatDoc_Catalog where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Catalog";
	doTemp.setKey("DocID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID"," style={width:50px} ");
	doTemp.setHTMLStyle("DocName"," style={width:220px} ");

	//查询
 	doTemp.setColumnAttribute("DocID,DocName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelFormatDocCatalog(#DocID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","格式化报告定义列表","查看/修改格式化报告定义列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FormatdocCatalogInfo","/Common/Configurator/FormatDocManage/FormatdocCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/FormatDocManage/FormatdocCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FormatdocCatalogInfo","/Common/Configurator/FormatDocManage/FormatdocCatalogInfo.jsp","DocID="+sDocID,"");
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       popComp("FormatdocDefList","/Common/Configurator/FormatDocManage/FormatdocDefList.jsp","DocID="+sDocID,"");
	}

	function deleteRecord(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('67'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>