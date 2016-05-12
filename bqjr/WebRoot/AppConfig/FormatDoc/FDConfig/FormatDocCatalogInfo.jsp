<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
 	String sTypeNo = CurPage.getParameter("TypeNo");
 	String sDocType = CurPage.getParameter("SubTypeNo");
	String sDocID = CurPage.getParameter("DocID");
	if(sTypeNo == null) sTypeNo = "";
	if(sDocType == null) sDocType = "";
	if(sDocID == null) sDocID = "";
	
	ASObjectModel doTemp = new ASObjectModel("FDCatalogInfo");
	doTemp.setDefaultValue("Attribute2", sTypeNo);
	doTemp.setDefaultValue("DocType", sDocType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sDocID);
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("格式化报告目录信息");
	function saveRecord(){
		as_save("myiframe0");
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>