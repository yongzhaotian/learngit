<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150505 CCS-637 PRM-293 审核过程中审核要点功能维护
	 */
	%>
<%/*~END~*/%>

<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%
	//文档编号
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if (null == sFlowNo) sFlowNo = "";
	if (null == sPhaseNo) sPhaseNo = "";
	if (null == sRightType) sRightType = "";
%>

<script type="text/javascript">
	// edit by xswang 20150505 CCS-637 PRM-293 审核过程中审核要点功能维护
	AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp","FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&RightType=<%=sRightType%>","rightup");
	<%-- if("ReadOnly" == "<%=sRightType%>")//查看审批要点
	{
		AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelUploadView.jsp","ObjectNo=<%=sFlowNo%>&TypeNo=<%=sPhaseNo%>","rightdown");
	}
	else
	{
		AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelUploadFrame.jsp","DocNo=<%=sFlowNo%>&TypeNo=<%=sPhaseNo%>","rightdown");
	} --%>
	AsControl.OpenView("/AppConfig/Document/AuditPointsAttachmentFrame.jsp","","rightdown");
	// end by xswang 20150505
</script>

<%@ include file="/IncludeEnd.jsp"%>
