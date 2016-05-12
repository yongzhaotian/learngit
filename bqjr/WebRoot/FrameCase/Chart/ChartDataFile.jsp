<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin.jspf"%><%@
 page import="com.amarsoft.awe.ui.chart.*"%>
<script type="text/javascript" src="<%=sWebRootPath %>/Frame/resources/js/chart/swfobject.js"></script>
<script type="text/javascript" src="<%=sWebRootPath %>/Frame/resources/js/chart/json2.js"></script>
<script type="text/javascript">
document.onready = function(){
	<%=ChartHelp.getDataFile(sWebRootPath,"mychart","100%","80%","com.amarsoft.app.awe.framecase.swf.GetChartAction","getChart","")%>
};
</script>
<style>
body { margin: 0px; overflow:hidden }
</style>
<body>
<div id=mychart></div>
</body>
<%@ include file="/Frame/resources/include/include_end.jspf"%>