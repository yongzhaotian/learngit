<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.awe.ui.chart.*"%>
<%
	String sGroupID = CurPage.getParameter("GroupID");
	String sVersionSeq = CurPage.getParameter("RefVersionSeq");
%>
<%=ChartHelp.getSwfobjectSrc(sWebRootPath)%>
<script type="text/javascript">
document.onready = function() {
	<%=ChartHelp.getDragChartXml(sWebRootPath,"mychart","100%","100%","com.amarsoft.app.als.customer.group.action.GetFamilyChartXmlAction","getChart","GroupID="+sGroupID+",RefVersionSeq="+sVersionSeq)%>
};
</script>
<script language=javascript>
	function gotoLink(sState,sCustomerID){
		if(sState == "NOTEXIST"){
			alert("成员为虚拟客户！");
			return;
		}
		//查看集团成员详情
		openObject("Customer",sCustomerID,"003");
		
	}
</script>
<style>
body { margin: 0px; overflow:hidden }
</style>
<body>
<div id=mychart></div>
</body>
<%@ include file="/IncludeEnd.jsp"%>