<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_sublist.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.forceSerialJBO = true;
	dwTemp.setPageSize(5);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly ="0";
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","全部保存","全部保存","saveAll()","","","","btn_icon_save",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function saveAll(){
		as_saveAll();
	}
	//显示子表格的事件
	function displaySubTable(rowIndex,frameId){
		//alert("frameId=" + frameId);
		var sUrl = "/FrameCase/widget/dw/DemoInfoDMenu.jsp";
		sUrl = sUrl+'?SerialNo=' + getItemValue(0,rowIndex,'SerialNo');
		OpenPage(sUrl,frameId,'');
	}
	//子表格加载事件
	function reloadFrame(frameId){
		//设置子表格高度
		setFrameHeight(frameId,"auto");
	}
	
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
