<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	CurPage.setAttribute("CanStore", "true");
	//StoreFactory.getStoreManager().storeFunction(CurPage, CurUser);
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
		{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
		{"true","","Button","刷新第二个tab","刷新tab","refresh()","","","","",""},
		{"true","","Button","关闭第二个tab","关闭tab","closeTab()","","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
		parent.amarTab.OpenDynamicTab("新增",sUrl,"");
	}
	function edit(){
		var sSerialNo = getItemValue(0,getRow(0),'SerialNo');
	    var sUrl = "/FrameCase/widget/dw/DemoInfoDynamicSimple.jsp";
	    parent.amarTab.OpenDynamicTab("详情—"+sSerialNo,sUrl,"SerialNo=" + sSerialNo);
	}
	function refresh(){
		parent.amarTab.refreshWidgetTab(1);
	}
	function closeTab(){
		parent.amarTab.close(1);
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
