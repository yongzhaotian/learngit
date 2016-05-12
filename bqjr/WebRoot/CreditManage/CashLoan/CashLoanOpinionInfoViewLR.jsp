<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
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
	 
%><%@include file="/Resources/CodeParts/Frame0302.jsp"%>
<script type="text/javascript">	
	var OpenStyle = "width=100%,height=100%,top=20,left=20,toolbar=yes,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
	AsControl.OpenView("/CreditManage/CashLoan/CashLoanImageInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","frameleft",OpenStyle);
	AsControl.OpenView("/CreditManage/CashLoan/CashLoanCreditInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","frameright",OpenStyle);
</script>	
<%@ include file="/IncludeEnd.jsp"%>
