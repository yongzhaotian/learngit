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
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow(sDocID);
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("��ʽ������Ŀ¼��Ϣ");
	function saveRecord(){
		as_save("myiframe0");
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>