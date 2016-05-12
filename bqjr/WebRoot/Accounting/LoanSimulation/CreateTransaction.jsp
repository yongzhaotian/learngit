<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.*"%>
<%@ page import="com.amarsoft.app.accounting.trans.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>交易执行</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	String transactionCode =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransCode")));
	String transactionDate =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransDate")));
	
	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	//创建交易
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