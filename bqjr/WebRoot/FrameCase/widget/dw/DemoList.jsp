<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfo");
	doTemp.setBusinessProcess("com.amarsoft.app.awe.framecase.dwhandler.TestResultListAction");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.MultiSelect = true;
	dwTemp.ReadOnly = "1";
	dwTemp.genHTMLObjectWindow("");
	

	String sButtons[][] = {
		{"true","All","Button","����","����","as_save(0,'getresult()')","","","","btn_icon_save"},
		{"true","","Button","ɾ��","ɾ��","as_delete(0,'getresult()')","","","","btn_icon_delete"},
		{"true","","Button","����EXCEL","����EXCEL","exportPage('"+sWebRootPath+"',0,'excel','')","","","",""},
		{"true","","Button","��ø�����Name","��ø�����Name","getParentRegion()","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function getresult(){
		alert("���ؽ����" + getResultInfo(0));
	}

	function getParentRegion(){
		alert(parent.Layout.getRegionName("south") +" ���� "+parent.Layout.getRegionName("east"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
