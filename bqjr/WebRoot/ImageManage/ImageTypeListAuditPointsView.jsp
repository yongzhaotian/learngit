<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: 影像类型审核要点
		Input Param:
		Output param:
		History Log: 
	*/
	String PG_TITLE = "影像类型审核要点";
	//获得页面参数
	String sStartWithId = CurComp.getParameter("StartWithId");
	if (sStartWithId == null) sStartWithId = "";
	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//合同编号
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//区分贷前贷后
	if(sSerialNo==null) sSerialNo = "";
	if(sObjectType==null) sObjectType = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ImageTypeListAuditPoints";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	doTemp.setReadOnly("TypeNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.DataObject.setVisible("AuditPoints", true);
	dwTemp.DataObject.setReadOnly("TypeName,AuditPoints", true);

	String sParam = "";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) {
		out.print((String)vTemp.get(i));
	}

	String sButtons[][] = {
		{"false","","Button","保存","保存记录","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function saveRecord(){
		as_save("myiframe0");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
