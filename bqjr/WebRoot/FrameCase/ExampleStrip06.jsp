<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/strip.css">
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css"> 
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<div>
<input id="add01" value="�����Strip" type="button"/>
<input id="add02" value="�����Strip(��Ӻ�������)" type="button"/>
</div>
<div id="demo_strip" style="width:100%;height:100%;"> 
</div>
<%@ include file="/IncludeEnd.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var tabCompent = new TabStrip("T001","Demo Strip","strip","#demo_strip"); 
	//tabCompent.setSelectedItem("0"); 						//Ĭ�ϴ���
	tabCompent.addDataItem('0',"ʾ��1","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",false,true);
	tabCompent.addDataItem('1',"ʾ��2","AsControl.OpenView('/FrameCase/ExampleList02.jsp','','TabContentFrame')",false,true);
	tabCompent.addDataItem('2',"ʾ��3","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",false,false,true);
	//tabCompent.addDataItem('00X1',"Demo001","void(0)",true,false);
	tabCompent.init();

	var script = "OpenComp('ExampleList','/FrameCase/ExampleList.jsp','','TabContentFrame')";
	var number = 4;
	//--------------��ť�¼���----------------------
	$("#add01").click(function(){
		tabCompent.addItem('0X'+number,"���"+number,script);
		number++;
	});
	$("#add02").click(function(){
		tabCompent.addItem('0X'+number,"���"+number,script,true,true,true);
		number++;
	});
});
</script>