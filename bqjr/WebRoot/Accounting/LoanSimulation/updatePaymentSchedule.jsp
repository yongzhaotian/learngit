<%@page import="com.amarsoft.app.accounting.util.PaymentScheduleFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>Session保存信息</title>
<%
	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	loan.setAttributeValue("UpdateInstalAmtFlag", "1");
	BusinessObject loan1=loan.cloneObject();
	PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, null,  new DefaultBusinessObjectManager(Sqlca));
	loan.setRelativeObjects(PaymentScheduleFunctions.createLoanPaymentScheduleList(loan1, null, new DefaultBusinessObjectManager(Sqlca)));
%>
<script language=javascript>
	//返回检查状态值和客户号
	self.returnValue = "true";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>