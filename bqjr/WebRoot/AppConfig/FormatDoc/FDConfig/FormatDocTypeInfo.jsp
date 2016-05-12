<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sTypeNo = CurPage.getParameter("TypeNo");
	if(sTypeNo == null) sTypeNo = "";

	ASObjectModel doTemp = new ASObjectModel("FDTypeInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow(sTypeNo);

	String sButtons[][] = {
		{"true","All","Button","保存","","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("大类分类信息");
	function saveRecord(){
		as_save("myiframe0", "setReturn()");
	}
	function setReturn(){
		top.returnValue = getItemValue(0, getRow(), "TypeNo");
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>