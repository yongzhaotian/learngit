<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%>

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

<%
	/*
		--ҳ��˵��: ʾ�����¿��ҳ��--
	 */
	 //��ȡҳ�����
	 String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	 String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	 String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo")); 
	 String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")); 
	 String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	 //��ȡģ����
	 
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	var OpenStyle = "width=100%,height=100%,top=20,left=20,toolbar=yes,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
	AsControl.OpenView("/CreditManage/CashLoan/CashLoanOpinionInfoViewLR.jsp","SerialNo=<%=sObjectNo%>&TaskNo=<%=sSerialNo%>","rightup",OpenStyle);
	// edit by xswang 20150505 CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
	/* AsControl.OpenView("/CreditManage/CashLoan/CashLoanOpinionInfoNew.jsp","","rightdown",OpenStyle); */
	AsControl.OpenView("/CreditManage/CashLoan/CashLoanOpinionInfoViewRR.jsp","","rightdown",OpenStyle);
	// end by xswang 20150505
</script>	
<%@ include file="/IncludeEnd.jsp"%>
