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
		alert("�����������Ϊ��"+sRelativeOrgID+"�������������ڵ�");
	}

	function gotoOtherUser(sRelativeOrgID){
		alert("�����������Ϊ��"+sRelativeOrgID+"���������û��ڵ�");
	}
	
	function gotoOrg(sOrgID){
		alert("���������"+sOrgID+"���ڵ�");
	}
	
	function gotoUser(sUserID){
		alert("����û���"+sUserID+"���ڵ�");
	}
</script>
<style>
body { margin: 0px; overflow:hidden }
</style>
<body>
<div id=mychart></div>
</body>
<%@ include file="/IncludeEnd.jsp"%>