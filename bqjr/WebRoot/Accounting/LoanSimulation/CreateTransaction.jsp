<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.*"%>
<%@ page import="com.amarsoft.app.accounting.trans.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>����ִ��</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	String transactionCode =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransCode")));
	String transactionDate =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransDate")));
	
	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	//��������
	AbstractBusinessObjectManager bom=new DefaultBusinessObjectManager(Sqlca);
	ITransactionScript transScript= TransactionConfig.getTransactionSript(transactionCode, bom);
	BusinessObject transaction=transScript.createTransaction(transactionCode, null, loan, CurUser.getUserID(), transactionDate);
	loan.setRelativeObject(transaction);
	%>
<%/*~END~*/%>

<script language=javascript>
	self.returnValue="true@<%=transaction.getObjectNo()%>";
	self.close();
</script>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>