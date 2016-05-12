<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.accounting.trans.ITransactionScript"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.*"%>
<%@ page import="com.amarsoft.app.accounting.trans.script.loan.LoanEOD_BOD"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.BusinessObject"%>
<%@ page import="com.amarsoft.app.accounting.util.SPTFunctions"%>


<head>
	<title>��ѯ����ƻ�</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0">
	<%
		//�������
		BusinessObject transaction = null;
		
		//���ҳ�����
		String transactionSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange, (String) CurPage.getParameter("TransSerialNo")));
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		

		transaction = TransactionConfig.loanTransaction(transactionSerialNo, bom);
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectNo", loanChange.getObjectNo());
		as.setAttribute("ObjectType", loanChange.getObjectType());
		List<BusinessObject> sptList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment, " ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));
		List<BusinessObject> list = SPTFunctions.createSPTScheduleList(sptList, loan, bom);
	%>

<script language="javascript">
	var boList = new Array();
</script>
<html> 
<head>
<title></title>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" >

<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='70%' border=0 cellspacing="4" cellpadding="0">
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='����' onclick="excelShow()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�ڴ�</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��������</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��Ϣ���</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��Ϣ����</font></td>
</tr>

	<%
	if(list != null){
		for(BusinessObject bo:list){
			System.out.println(bo.getInt("SeqID") + bo.getString("PayDate") + bo.getDouble("SPTAmount"));
		%>
		<script language="javascript">
		boList[<%=bo.getInt("SeqID")%>] = Array(<%=bo.getString("PayDate")%>,<%=bo.getDouble("SPTAMOUNT")%>,<%=bo.getString("SPTTERMID")%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("SeqID")%><input id="SerialNo<%=bo.getInt("SeqID")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: black;' class=fftdinput type=text readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>"></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="SPTAMOUNT<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: black;' class=fftdinput type=text readOnly value="<%=DataConvert.toString(bo.getString("SPTAmount"))%>"></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="SPTTYPE<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: black;' class=fftdinput type=text readOnly value="<%=DataConvert.toString(bo.getString("SPTTERMID"))%>"></font></td>
		</tr>
		<%
		}
	}
	%>

</table>
</div>
</body>
</html>

<script language="javascript">
	/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	/*~[Describe=���û���ƻ�;InputParam=��;OutPutParam=��;]~*/

</script>
<%@ include file="/IncludeEnd.jsp"%>