<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%

	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sRegCode = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RegCode"));
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sPhaseType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	
	if (sPhaseType == null) sPhaseType = "";
	if (sSerialNo == null) sSerialNo = "";
	if (sRegCode == null) sRegCode = "";

%>

<script type="text/javascript">
	//myleft.width=200;
	AsControl.OpenView("/BusinessManage/RetailManage/StoreAttachmentList.jsp","SerialNo=<%=sSerialNo%>&RegCode=<%=sRegCode%>&Type=<%=sType%>&PhaseType=<%=sPhaseType%>","rightup","");
	AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
