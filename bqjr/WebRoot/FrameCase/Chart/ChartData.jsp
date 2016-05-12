<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin.jspf"%><%@
 page import="com.amarsoft.awe.ui.chart.*"%>
<%
    String sGraphType = DataConvert.toRealString(CurPage.getParameter("GraphType"));
    ChartData chart = new ChartData(sGraphType,"Charͼ��չʾ[��λ  �ٷֱ�%]");
    ChartCatalog catalog;
    catalog = new ChartCatalog("��Ȩ����");
    catalog.addItem("Ŀ����ҵ","64.01");
    if(!"pie".equals(sGraphType)){
	    catalog.addItem("������ҵ","94.01");
    }
    chart.addCategory(catalog); 
    catalog = new ChartCatalog("��ծ����");
    catalog.addItem("Ŀ����ҵ","54.01");
    if(!"pie".equals(sGraphType)){
    	catalog.addItem("������ҵ","64.01");
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