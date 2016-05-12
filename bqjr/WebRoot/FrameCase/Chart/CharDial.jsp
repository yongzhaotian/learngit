<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin.jspf"%><%@
 page import="com.amarsoft.awe.ui.chart.*"%>
<script type="text/javascript" src="<%=sWebRootPath %>/Frame/resources/js/chart/swfobject.js"></script>
<script type="text/javascript">
<%
/*initValue 初始值,minValue 最小值,maxValue 最大值,
safeMaxValue 绿色区域最大值,alarmMaxValue 安全区域最大值,minorNums 小刻度数量,step 大刻度步长值 
(相关参数值可动态获取再拼接成下列格式即可)
*/
	String flashVars="kpiName:'不良贷款率',initValue:4,minValue:0,maxValue:30,"+
					  "safeMaxValue:2,alarmMaxValue:5,minorNums:10,step:5";
%>
document.onready = function(){
	<%=ChartHelp.getDial(sWebRootPath,"mychart","50%","50%",flashVars)%>
};
</script>
<style>
body { margin: 0px; overflow:hidden }
</style>
<body>
<div id=mychart></div>
</body>
<%@ include file="/Frame/resources/include/include_end.jspf"%>