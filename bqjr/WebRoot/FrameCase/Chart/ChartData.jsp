<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin.jspf"%><%@
 page import="com.amarsoft.awe.ui.chart.*"%>
<%
    String sGraphType = DataConvert.toRealString(CurPage.getParameter("GraphType"));
    ChartData chart = new ChartData(sGraphType,"Char图形展示[单位  百分比%]");
    ChartCatalog catalog;
    catalog = new ChartCatalog("产权比率");
    catalog.addItem("目标企业","64.01");
    if(!"pie".equals(sGraphType)){
	    catalog.addItem("优质企业","94.01");
    }
    chart.addCategory(catalog); 
    catalog = new ChartCatalog("负债比率");
    catalog.addItem("目标企业","54.01");
    if(!"pie".equals(sGraphType)){
    	catalog.addItem("优质企业","64.01");
    }
    chart.addCategory(catalog); 
%>
<script type="text/javascript" src="<%=sWebRootPath %>/Frame/resources/js/chart/swfobject.js"></script>
<script type="text/javascript" src="<%=sWebRootPath %>/Frame/resources/js/chart/json2.js"></script>
<script type="text/javascript">
function get_data()
{
	var chart=<%=chart.getJson()%>;
	return JSON.stringify(chart);
}

document.onready = function(){
	<%=ChartHelp.getDataScript(sWebRootPath,"mychart","100%","100%","get_data")%>
};
</script>
<style>
body { margin: 0px; overflow:hidden }
</style>
<body>
<div id=mychart></div>
</body>
<%@ include file="/Frame/resources/include/include_end.jspf"%>