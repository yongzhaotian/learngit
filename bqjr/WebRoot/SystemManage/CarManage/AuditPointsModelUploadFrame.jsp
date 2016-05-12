<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例上下框架页面--
	 */
	 
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<%
	//文档编号
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
    System.out.println("-------"+sDocNo+"-------"+sTypeNo);
	if (sTypeNo == null) sTypeNo = "";
	if (sDocNo == null) sDocNo = "";
%>
<script type="text/javascript">	
	var OpenStyle = "width=100%,height=100%,top=20,left=20,toolbar=yes,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
	AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelUploadList.jsp","DocNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>","frameleft",OpenStyle);
	AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelUploadView.jsp","ObjectNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>","frameright",OpenStyle);
</script>	
<%@ include file="/IncludeEnd.jsp"%>
