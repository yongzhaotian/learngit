<%@page import="com.amarsoft.app.accounting.util.PaymentScheduleFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>Session������Ϣ</title>
<%
	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	loan.setAttributeValue("UpdateInstalAmtFlag", "1");
	BusinessObject loan1=loan.cloneObject();
	PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, null,  new DefaultBusinessObjectManager(Sqlca));
	loan.setRelativeObjects(PaymentScheduleFunctions.createLoanPaymentScheduleList(loan1, null, new DefaultBusinessObjectManager(Sqlca)));
%>
<script language=javascript>
	//���ؼ��״ֵ̬�Ϳͻ���
	self.returnValue = "true";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>