<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%>

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

<%
	/*
		--页面说明: 示例上下框架页面--
	 */
	 //获取页面参数
	 String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	 String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	 String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo")); 
	 String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")); 
	 String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	 //获取模版编号
	 
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	var OpenStyle = "width=100%,height=100%,top=20,left=20,toolbar=yes,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
	AsControl.OpenView("/CreditManage/CashLoan/CashLoanOpinionInfoViewLR.jsp","SerialNo=<%=sObjectNo%>&TaskNo=<%=sSerialNo%>","rightup",OpenStyle);
	// edit by xswang 20150505 CCS-637 PRM-293 审核过程中审核要点功能维护
	/* AsControl.OpenView("/CreditManage/CashLoan/CashLoanOpinionInfoNew.jsp","","rightdown",OpenStyle); */
	AsControl.OpenView("/CreditManage/CashLoan/CashLoanOpinionInfoViewRR.jsp","","rightdown",OpenStyle);
	// end by xswang 20150505
</script>	
<%@ include file="/IncludeEnd.jsp"%>
