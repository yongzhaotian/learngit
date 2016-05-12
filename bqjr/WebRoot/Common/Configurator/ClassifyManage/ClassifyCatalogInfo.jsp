<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    决策流模型目录信息详情
	 */
	String PG_TITLE = "决策流模型目录信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	ModelNo：    报表记录编号
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";

 	
 	//通过DW模型产生ASDataObject对象doTemp
 	String sTempletNo = "ClassifyCatalogInfo";//模型编号
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","");
	}
	function saveRecordAndBack(){
		as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
		OpenComp("ClassifyCatalogInfo","/Common/Configurator/ClassifyManage/ClassifyCatalogInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>