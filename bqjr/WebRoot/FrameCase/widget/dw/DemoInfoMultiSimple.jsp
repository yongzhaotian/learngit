<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

    String slayout = CurPage.getParameter("Layout");

	String sTempletNo = "TestCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0),parent.reloadSelf()","","","",""},
		{"false","All","Button","����","�����б�","returnList()","","","",""}
	};
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 var sUrl = "/FrameCase/widget/dw/DemoListMultiSimple.jsp";
		 OpenPage(sUrl,'_self','');
		
	}

	function afterSave(){
		//�����Ҳ�ɵ��ñ�����������ˢ�¸�����
		AsControl.OpenPage("/FrameCase/widget/dw/DemoListMultiSimple.jsp", "",parent.Layout.getRegionName("center"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
