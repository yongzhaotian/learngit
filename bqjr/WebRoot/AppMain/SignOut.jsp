<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%@
page import="com.amarsoft.awe.security.UserMarkInfo"%>
<%
	String sTempNow = StringFunction.getToday()+" "+StringFunction.getNow();
	UserMarkInfo userMarkInfo = new UserMarkInfo(Sqlca, CurUser.getUserID());
	userMarkInfo.setLastSignOutTime(sTempNow);
	userMarkInfo.saveMarkInfo(Sqlca);
%>
<script type="text/javascript">
		window.open("<%=sWebRootPath%>/Frame/page/sys/SessionOut.jsp?rand="+randomNumber(),"_self");
</script>
<%@ include file="/IncludeEnd.jsp"%>