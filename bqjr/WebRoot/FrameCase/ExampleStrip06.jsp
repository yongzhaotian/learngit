<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/strip.css">
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css"> 
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<div>
<input id="add01" value="添加新Strip" type="button"/>
<input id="add02" value="添加新Strip(添加后立即打开)" type="button"/>
</div>
<div id="demo_strip" style="width:100%;height:100%;"> 
</div>
<%@ include file="/IncludeEnd.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var tabCompent = new TabStrip("T001","Demo Strip","strip","#demo_strip"); 
	//tabCompent.setSelectedItem("0"); 						//默认打开项
	tabCompent.addDataItem('0',"示例1","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",false,true);
	tabCompent.addDataItem('1',"示例2","AsControl.OpenView('/FrameCase/ExampleList02.jsp','','TabContentFrame')",false,true);
	tabCompent.addDataItem('2',"示例3","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",false,false,true);
	//tabCompent.addDataItem('00X1',"Demo001","void(0)",true,false);
	tabCompent.init();

	var script = "OpenComp('ExampleList','/FrameCase/ExampleList.jsp','','TabContentFrame')";
	var number = 4;
	//--------------按钮事件绑定----------------------
	$("#add01").click(function(){
		tabCompent.addItem('0X'+number,"添加"+number,script);
		number++;
	});
	$("#add02").click(function(){
		tabCompent.addItem('0X'+number,"添加"+number,script,true,true,true);
		number++;
	});
});
</script>