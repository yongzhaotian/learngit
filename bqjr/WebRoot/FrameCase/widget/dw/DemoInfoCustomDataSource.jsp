<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "TestCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDataQueryClass("com.amarsoft.app.awe.framecase.dw.DemoInfoForCustomData");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","����","�����б�","returnList2()","","","",""}
	};
	sButtonPosition = "south";
%>
<script>
function returnList2(){
	 var sUrl = "/FrameCase/widget/dw/DemoListCustomDataSource.jsp";
	 OpenPage(sUrl,'_self','');
}

</script>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
