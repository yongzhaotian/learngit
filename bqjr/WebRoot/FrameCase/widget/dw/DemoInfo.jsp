<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "TestCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0,'getresult()')","","","","btn_icon_save"},
		{"true","All","Button","ɾ��","ɾ����ǰ��¼","if(confirm('�Ƿ�Ҫɾ��'))as_delete(0,'getresult()')","","","","btn_icon_delete"},
	};
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function getresult(){
		alert("���ؽ����" + getResultInfo(0));
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>