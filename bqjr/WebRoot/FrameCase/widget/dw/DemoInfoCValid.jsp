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
		{"true","All","Button","����","�����б�","returnList()","","","",""}
	};
	sButtonPosition = "south";
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 var sUrl = "/FrameCase/widget/dw/DemoListSimple.jsp";
		 OpenPage(sUrl,'_self','');
	}
	function beforeCheck(dwname){
		alert("beforeCheck");
		return true;
	}
	function afterCheck(dwname){
		alert("afterCheck");
		return true;
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
