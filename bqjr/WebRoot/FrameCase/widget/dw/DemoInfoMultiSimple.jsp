<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%

    String slayout = CurPage.getParameter("Layout");

	String sTempletNo = "TestCustomerInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0),parent.reloadSelf()","","","",""},
		{"false","All","Button","返回","返回列表","returnList()","","","",""}
	};
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 var sUrl = "/FrameCase/widget/dw/DemoListMultiSimple.jsp";
		 OpenPage(sUrl,'_self','');
		
	}

	function afterSave(){
		//保存后也可调用本方法，单独刷新父区域
		AsControl.OpenPage("/FrameCase/widget/dw/DemoListMultiSimple.jsp", "",parent.Layout.getRegionName("center"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
