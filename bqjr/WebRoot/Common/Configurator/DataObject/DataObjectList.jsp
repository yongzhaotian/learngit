<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 数据对象目录列表
	 */
	String PG_TITLE = "数据对象目录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	String sDoName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoName"));
	String sDoNo2 =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo2"));
	if(sDoNo==null) sDoNo="";
	if(sDoName==null) sDoName="";
	if(sDoNo2==null) sDoNo2=""; 
	
	String sTempletNo="DataObjectList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(50);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelDOLibrary(#DoNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","从元数据生成","从元数据生成","generateFromMetaData()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		OpenComp("DataObjectView","/Common/Configurator/DataObject/DataObjectView.jsp","","");
		reloadSelf();
	}
	
	function viewAndEdit(){
       var sDoNo = getItemValue(0,getRow(),"DoNo");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		openObject("DataObject",sDoNo,"001");
	}
    
	function deleteRecord(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	function generateFromMetaData(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
      	if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		sMetaData = popComp("MetaTableSelect","/Common/Configurator/MetaDataManage/MetaTableSelectionList.jsp","","");
		if(typeof(sMetaData)=="undefined" || sMetaData=="_CANCEL_") return;
		alert(sMetaData);
		sMetaDatas = sMetaData.split("@");
		sMetaDatabase = sMetaDatas[0];
		sMetaTable = sMetaDatas[1];
		sReturn = PopPageAjax("/Common/Configurator/DataObject/GenerateFromMetaDataAjax.jsp?DatabaseID="+sMetaDatabase+"&TableID="+sMetaTable+"&DoNo="+sDoNo,"","");
		if(sReturn=="succeeded"){
			if(confirm("成功生成数据对象！\n\n打开编辑吗？")) viewAndEdit();
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>	
<%@ include file="/IncludeEnd.jsp"%>