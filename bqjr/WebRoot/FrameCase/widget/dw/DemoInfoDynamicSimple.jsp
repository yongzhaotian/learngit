<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "TestCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"false","All","Button","����","�����б�","returnList()","","","",""}
	};
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function beforeTabClose(){
		alert("����ֵΪundefined�򲼶�ֵΪtrue����رգ�������ֹ�رգ�\n��flag����ֵΪtrue����ô!flag == false");
		return confirm("ȷ���ر�?");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
