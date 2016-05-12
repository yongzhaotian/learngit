<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.awe.ui.chart.*"%>
<%
	String sGroupID = CurPage.getParameter("GroupID");
	String sVersionSeq = CurPage.getParameter("RefVersionSeq");
%>
<script type="text/javascript" src="<%=sWebRootPath %>/Frame/resources/js/chart/swfobject.js"></script>
<script type="text/javascript">
document.onready = function() {
	<%=ChartHelp.getDragChartXml(sWebRootPath,"mychart","100%","100%","com.amarsoft.app.awe.framecase.swf.DragNodeAction","getChart","UserID="+CurUser.getUserID())%>
};
</script>
<script type="text/javascript">
	function gotoOtherOrg(sRelativeOrgID){
		alert("点击关联机构为【"+sRelativeOrgID+"】的其他机构节点");
	}

	function gotoOtherUser(sRelativeOrgID){
		alert("点击所属机构为【"+sRelativeOrgID+"】的其他用户节点");
	}
	
	function gotoOrg(sOrgID){
		alert("点击机构【"+sOrgID+"】节点");
	}
	
	function gotoUser(sUserID){
		alert("点击用户【"+sUserID+"】节点");
	}
</script>
<style>
body { margin: 0px; overflow:hidden }
</style>
<body>
<div id=mychart></div>
</body>
<%@ include file="/IncludeEnd.jsp"%>