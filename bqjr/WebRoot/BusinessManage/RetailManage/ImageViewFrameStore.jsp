<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<%

	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sRegCode = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RegCode"));
	String sPhaseType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	
	if (sPhaseType == null) sPhaseType = "";
	if (sSerialNo == null) sSerialNo = "";
	if (sRegCode == null) sRegCode = "";

%>

<script type="text/javascript">
 myleft.width=200; 
AsControl.OpenView("/BusinessManage/RetailManage/ImageViewStore.jsp","SerialNo=<%=sSerialNo%>&RegCode=<%=sRegCode%>&PhaseType=<%=sPhaseType%>","frameleft","");
	</script>

<%@ include file="/IncludeEnd.jsp"%>
