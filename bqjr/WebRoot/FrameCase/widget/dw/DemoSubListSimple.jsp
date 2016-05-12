<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_sublist.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(5);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
		{"true","","Button","详情","详情","reloadSelf()","","","","btn_icon_detail",""},
		{"true","","Button","联动菜单编辑","联动菜单编辑","editd()","","","","btn_icon_detail",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
		 PopPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_blank','');
	}function editd(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoDMenu.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
	//显示子表格的事件
	function displaySubTable(rowIndex,frameId){
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
