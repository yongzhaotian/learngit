<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
 <script type="text/javascript">
	function testkeyup(){
		alert("����绰Ϊ��" + getItemValue(0,0,"TELEPHONE"));
	}
	function testclick(){
		alert("�Ƿ�ʹ�ã�" + getItemValue(0,0,"ISINUSE"));
	}
	
</script>
<%
	String sTempletNo = "TestCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setHtmlEvent("TELEPHONE","onkeyup","testkeyup");
	doTemp.setHtmlEvent("ISINUSE","onclick","testclick");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""}
	};
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
