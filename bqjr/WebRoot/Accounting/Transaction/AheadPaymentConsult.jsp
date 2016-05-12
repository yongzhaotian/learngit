<%@page import="com.amarsoft.app.accounting.web.bizlets.AheadPaymentCalculate"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  zmxu 20120614
		Tester:
		Content: 提前还款还款咨询
		Input Param:
		Output param:
		History Log:
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "提前还款还款咨询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	//交易流水号
	String transactionSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransactionSerialNo")));//交易流水号
	if(transactionSerialNo == null)
	{
		throw new Exception("交易流水【TransactionSerialNo】没值！");
	}
	AheadPaymentCalculate ahead = new AheadPaymentCalculate();
	BusinessObject paymentBill = ahead.execute(transactionSerialNo, Sqlca);
	%>
<%/*~END~*/%>




<html>
	<body class="ListPage" leftmargin="0" topmargin="0">
		<table align="center" border='1' cellspacing='10'> 
			<tr>
				<td width="130" align="right">提前归还本金：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("PrePayPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">提前归还利息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("PrePayInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">当期本金：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">当期利息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">期供欠本：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayODPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">期供欠息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayODInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">罚&nbsp;&nbsp;&nbsp;息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayFineAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">复&nbsp;&nbsp;&nbsp;息：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayCompdInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">费用总金额：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("PundAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">账户管理费：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("FeeAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">总金额：</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("TotalAmt"))%>
				</td>
			</tr>
		</table>
	</body>
</html>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
		self.returnValue="<%=DataConvert.toMoney(paymentBill.getDouble("PayAmt"))+"@"+DataConvert.toMoney(paymentBill.getDouble("PrePayPrincipalAmt"))+"@"+DataConvert.toMoney(paymentBill.getDouble("PrePayInteAmt"))%>";
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>