<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150505 CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
	 */
	%>
<%/*~END~*/%>

<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%
	//�ĵ����
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if (null == sFlowNo) sFlowNo = "";
	if (null == sPhaseNo) sPhaseNo = "";
	if (null == sRightType) sRightType = "";
%>

<script type="text/javascript">
	// edit by xswang 20150505 CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
	AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp","FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&RightType=<%=sRightType%>","rightup");
	<%-- if("ReadOnly" == "<%=sRightType%>")//�鿴����Ҫ��
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
