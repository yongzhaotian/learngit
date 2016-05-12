<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<div style="padding:1% 0.5%;border:0px solid #F00;position:absolute; height:100%;width: 100%;over-flow:hidden" id="ControlCenter">
</div>
<%@ include file="/IncludeEnd.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var tabCompent = new TabStrip("T001","控制台","tab","#ControlCenter");
	tabCompent.setSelectedItem("0010");			//默认选中项的编号
	//tabCompent.setIsCache(true);	 			//是否缓存,如果设置为false，则添加的元素即使设置了缓存也不会有效
	tabCompent.setCanClose(false);			//是否有关闭按钮,如果设置为false，则添加的元素即使设置了关闭按钮也不会显示
	//添加一项，参数说明：ID(必需唯一)，名称，解发脚本，是否缓存，是否有可关闭
	tabCompent.addDataItem('0010',"运行参数","AsControl.OpenView('/AppConfig/ControlCenter/RunConfig.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0020',"缓存控制台","AsControl.OpenView('/AppConfig/ControlCenter/CacheConsole.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0030',"系统环境","AsControl.OpenView('/AppConfig/ControlCenter/SystemEnv.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0040',"系统属性","AsControl.OpenView('/AppConfig/ControlCenter/SystemProperties.jsp','','TabContentFrame')",true,true);
	tabCompent.addDataItem('0050',"日志管理","AsControl.OpenView('/AppConfig/ControlCenter/LogManage/GeneralFileManage.jsp','','TabContentFrame')",true,true);
	
	//如果使用addDataItem,则必需调用init()函数
	tabCompent.initTab(); 
});
</script>