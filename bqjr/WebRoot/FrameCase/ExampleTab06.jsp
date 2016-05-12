<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<div>
<input id="add01" value="添加新Tab(不缓存)" type="button"/>
<input id="add02" value="添加新Tab(缓存)"  type="button"/>
<input id="add03" value="添加新Tab(不可关闭)"  type="button"/>
<input id="add04" value="添加新Tab(可关闭)"  type="button"/>
<input id="add05" value="添加新Tab(添加后立即打开)"  type="button"/>
</div>
<div style="padding:1% 0.5%;border:0px solid #F00;position:absolute; height:100%;width: 100%;over-flow:hidden" id="ExamplePlant">
</div>
<%@ include file="/IncludeEnd.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	
	var tabCompent = new TabStrip("T001","工作台","tab","#ExamplePlant");
	tabCompent.setSelectedItem("0010");			//默认选中项的编号
	tabCompent.setIsAddButton(true);				//是否有新建按钮
	tabCompent.setAddCallback("addNewTabListen(this)");		//新建按钮监听函数
	tabCompent.setCloseCallback("deleteTabListen(this)");	//执行删除后监听函数
	//tabCompent.setIsCache(true);	 			//是否缓存,如果设置为false，则添加的元素即使设置了缓存也不会有效
	//tabCompent.setCanClose(false);			//是否有关闭按钮,如果设置为false，则添加的元素即使设置了关闭按钮也不会显示
	//添加一项，参数说明：ID(必需唯一)，名称，解发脚本，是否缓存，是否有可关闭
	tabCompent.addDataItem('0010',"示例01","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0020',"示例02","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0030',"示例03","AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')",true,true);
	//如果使用addDataItem,则必需调用init()函数
	tabCompent.initTab(); 

	var number = 4;
	var script = "AsControl.OpenView('/FrameCase/ExampleList.jsp','','TabContentFrame')";
	//这里绑定按钮事件
	//1.添加新Tab(不缓存)
	$("#add01").click(function(){
		tabCompent.addItem('0X'+number,"添加"+number,script,false,true,false);
		number++;
	});
	$("#add02").click(function(){
		tabCompent.addItem('0X'+number,"添加"+number,script,true,true,false);
		number++;
	});
	$("#add03").click(function(){
		tabCompent.addItem('0X'+number,"添加"+number,script,true,false,false);
		number++;
	});
	$("#add04").click(function(){
		tabCompent.addItem('0X'+number,"添加"+number,script,true,true,false);
		number++;
	});
	$("#add05").click(function(){
		tabCompent.addItem('0X'+number,"添加"+number,script,true,true,true);
		number++;
	});
});

function addNewTabListen(obj){
	id = $(obj).attr("id").replace(/^handle_/,"");
	alert("新建按钮被点击了!ID="+id);
}
function deleteTabListen(obj){
	id = $(obj).attr("id").replace(/^handle_/,"");
	alert("选项卡被删除!ID="+id);
}
</script>