<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfo");
	doTemp.setBusinessProcess("com.amarsoft.app.awe.framecase.dwhandler.TestResultListAction");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.MultiSelect = true;
	dwTemp.ReadOnly = "1";
	dwTemp.genHTMLObjectWindow("");
	

	String sButtons[][] = {
		{"true","All","Button","保存","保存","as_save(0,'getresult()')","","","","btn_icon_save"},
		{"true","","Button","删除","删除","as_delete(0,'getresult()')","","","","btn_icon_delete"},
		{"true","","Button","导出EXCEL","导出EXCEL","exportPage('"+sWebRootPath+"',0,'excel','')","","","",""},
		{"true","","Button","获得父区域Name","获得父区域Name","getParentRegion()","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function getresult(){
		alert("返回结果：" + getResultInfo(0));
	}

	function getParentRegion(){
		alert(parent.Layout.getRegionName("south") +" 或者 "+parent.Layout.getRegionName("east"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
