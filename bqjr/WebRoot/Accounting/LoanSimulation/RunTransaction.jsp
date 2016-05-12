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
	String alertMessage="���״���ɹ���";
	
	String transactionCode =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransCode")));
	String transactionDate =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransDate")));
	String transactionSerialNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransactionSerialNo")));
	String documentType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentType")));
	String documentNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocumentNo")));
	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	if(simulationObject == null)  throw new Exception("δ����������Ϣ�����ȱ��棡");
	
	BusinessObject transaction = null;
	ITransactionScript transScript= null;
	AbstractBusinessObjectManager bom=new DefaultBusinessObjectManager(Sqlca);
	if(transactionSerialNo!=null&&transactionSerialNo.length()>0){
		transaction = simulationObject.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transactionSerialNo);
		if(transaction==null){
			throw new Exception("δ�Ҵ���{"+transactionSerialNo+"}");
		}
		transactionCode=transaction.getString("TransCode");
		transScript= TransactionConfig.getTransactionSript(transactionCode, bom);
		transScript.setTransaction(transaction);
	}
	else{
		BusinessObject documentObject=null,relativeObject=null;
		transScript= TransactionConfig.getTransactionSript(transactionCode, bom);
		if(documentType.equals(simulationObject.getObjectType())){//�ſ�
			transactionDate=simulationObject.getString("PutoutDate");
			documentObject=simulationObject;
			relativeObject=simulationObject;
		}
		else{//���������
			documentObject=simulationObject.getRelativeObject(documentType, documentNo);
			relativeObject=simulationObject;
		}
		transaction = transScript.createTransaction(transactionCode, documentObject, relativeObject, "", transactionDate);
	}
	transaction.setAttributeValue("BookTypeFilter", "N,B,C");//������ѯ��������
	transScript.prerun();
	transScript.run();
	if(BUSINESSOBJECT_CONSTATNTS.business_putout.equals(documentType)){
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		session.setAttribute("SimulationObject_Loan",loan);
		loan.setRelativeObject(transaction);
	}
	
	ArrayList<String> arrList = transScript.getMessageList();
	%>
<%/*~END~*/%>

<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#EAEAEA">

	<%
		if(arrList.size()>0){
	%>

		<br>
		<table align="center" width="100%">
			<tr>
				<td>
					<font face="Geneva, Arial, Helvetica, sans-serif, ��������"> <strong>�������ʾ���£� </strong> </font>
				</td>
			</tr>
		</table>
		<br>
		
<table width="100%" border="1" cellspacing="0" cellpadding="3" 

bordercolordark="#EAEAEA">
<%//չ��У����
	for (int j = 0; j < arrList.size(); j++) {
		out.println("<tr bgcolor=#fafafa height=20px><td nowrap align=\"left\" class=\"black9pt\" bgcolor=\"#D8D8AF\" ><font color=red>"+ (j + 1)+ "��&nbsp&nbsp"+ (String) arrList.get(j)+ "</font></tr></td>");
	}
	%>
	<tr>
		<td align="center" valign="bottom" nowrap height=100px
			class="black9pt" bgcolor="#D8D8AF">
			<input type="button" style="width: 70px" value=" ��  �� "
				class="button"
				onclick="javascipt:self.returnValue=<%=arrList.size()%>;self.close()">
		</td>
	</tr>
</table>
		<%
		}
		else{
			%>
			<script language=javascript>
				self.returnValue="true";
				alert("<%=alertMessage%>");
				self.close();
			</script>
			<%
		}
		%>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>