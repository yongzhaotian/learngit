<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerListX");
	doTemp.setVisible("ACTION", true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(5);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
		{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		{"true","","Button","联动菜单编辑","联动菜单编辑","editd()","","","","btn_icon_detail",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var selfUrl = "/FrameCase/widget/dw/DemoListWithAction.jsp";
	function add(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp?PrevUrl="+selfUrl;
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo')+'&PrevUrl='+selfUrl,'_self','');
	}function editd(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoDMenu.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo')+'&PrevUrl='+selfUrl,'_self','');
	}
	//在加载完表格后调用
	function afterSearch(){
		for(var i=0;i<getRowCount(0);i++){
			
			getObj(0,i,"ACTION").innerHTML='<a href=# onclick="javascript:add()">新增</a> <a href=# onclick="javascript:edit()">详情</a> <a href=# onclick="javascript:if(confirm(\'确实要删除吗?\'))as_delete(0)">删除</a> ';
		}
		setColumnWidth(0,"ACTION",150);
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
