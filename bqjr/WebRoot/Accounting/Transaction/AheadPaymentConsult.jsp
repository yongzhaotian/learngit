<%@page import="com.amarsoft.app.accounting.web.bizlets.AheadPaymentCalculate"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zmxu 20120614
		Tester:
		Content: ��ǰ�������ѯ
		Input Param:
		Output param:
		History Log:
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ǰ�������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	//������ˮ��
	String transactionSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransactionSerialNo")));//������ˮ��
	if(transactionSerialNo == null)
	{
		throw new Exception("������ˮ��TransactionSerialNo��ûֵ��");
	}
	AheadPaymentCalculate ahead = new AheadPaymentCalculate();
	BusinessObject paymentBill = ahead.execute(transactionSerialNo, Sqlca);
	%>
<%/*~END~*/%>




<html>
	<body class="ListPage" leftmargin="0" topmargin="0">
		<table align="center" border='1' cellspacing='10'> 
			<tr>
				<td width="130" align="right">��ǰ�黹����</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("PrePayPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">��ǰ�黹��Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("PrePayInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">���ڱ���</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">������Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�ڹ�Ƿ����</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayODPrincipalAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�ڹ�ǷϢ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayODInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">��&nbsp;&nbsp;&nbsp;Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayFineAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">��&nbsp;&nbsp;&nbsp;Ϣ��</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("ActualPayCompdInteAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�����ܽ�</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("PundAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�˻�����ѣ�</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("FeeAmt")) %>
				</td>
			</tr>
			<tr>
				<td width="130" align="right">�ܽ�</td>
				<td width="200" align="right">
					<%=DataConvert.toMoney(paymentBill.getDouble("TotalAmt"))%>
				</td>
			</tr>
		</table>
	</body>
</html>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		self.returnValue="<%=DataConvert.toMoney(paymentBill.getDouble("PayAmt"))+"@"+DataConvert.toMoney(paymentBill.getDouble("PrePayPrincipalAmt"))+"@"+DataConvert.toMoney(paymentBill.getDouble("PrePayInteAmt"))%>";
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>