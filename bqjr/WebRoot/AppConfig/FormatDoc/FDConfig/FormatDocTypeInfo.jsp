<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sTypeNo = CurPage.getParameter("TypeNo");
	if(sTypeNo == null) sTypeNo = "";

	ASObjectModel doTemp = new ASObjectModel("FDTypeInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow(sTypeNo);

	String sButtons[][] = {
		{"true","All","Button","����","","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("���������Ϣ");
	function saveRecord(){
		as_save("myiframe0", "setReturn()");
	}
	function setReturn(){
		top.returnValue = getItemValue(0, getRow(), "TypeNo");
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>