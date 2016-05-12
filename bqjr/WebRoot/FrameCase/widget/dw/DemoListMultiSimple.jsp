<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    //接收参数，根据参数确定打开页面的类型
    String sLayout = DataConvert.toString(request.getParameter("Layout"));

	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.setPageSize(30);//设置单页显示的记录行数
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
		{"false","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","","btn_icon_delete",""},
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
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
	function mySelectRow(){

		var layout = "<%=sLayout%>";
		sSerialNo=getItemValue(0,getRow(),"SerialNo");

		if(layout == "east"){
			//若为左右联动，则打开记录的详情信息
			var sUrl = "/FrameCase/widget/dw/DemoInfoMultiSimple.jsp";
			OpenPage(sUrl+'?SerialNo=' + sSerialNo+"&Layout=east",parent.Layout.getRegionName('east'),"");
		}
        if(layout == "south"){
        	//若为上下联动，则打开记录的关联列表信息
        	var sUrl = "/FrameCase/widget/dw/DemoInfoMultiSimple.jsp";
			OpenPage(sUrl+'?SerialNo=' + sSerialNo+"&Layout=south",parent.Layout.getRegionName('south'),"");
        }
	}

	//进入页面后默认选择第一条
	//mySelectRow(0);
	
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
