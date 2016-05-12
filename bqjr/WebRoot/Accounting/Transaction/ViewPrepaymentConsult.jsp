<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.accounting.trans.ITransactionScript"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.*"%>
<%@ page import="com.amarsoft.app.accounting.trans.script.loan.LoanEOD_BOD"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.BusinessObject"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS"%>
<%@ page import="com.amarsoft.app.accounting.util.PaymentScheduleFunctions"%>


<head>
	<title>咨询还款计划</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0">
	<%
		//定义变量
		BusinessObject transaction = null;
		
		//获得页面参数
		String loanSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange, (String) CurPage.getParameter("LoanSerialNo")));
		String transactionSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange, (String) CurPage.getParameter("TransSerialNo")));
		String transactionCode = DataConvert.toString(DataConvert.toRealString(iPostChange, (String) CurPage.getParameter("TransactionCode")));
		String sTransDate = DataConvert.toString(DataConvert.toRealString(iPostChange, (String) CurPage.getParameter("TransDate")));
		String rightType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType")));
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		
		if ("9090".equals(transactionCode)) {
			String date_9090 = DateFunctions.getRelativeDate(sTransDate, DateFunctions.TERM_UNIT_DAY, -1);
			BusinessObject loan = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan, loanSerialNo);
			LoanEOD_BOD changeLoanDateScript = (LoanEOD_BOD) TransactionConfig.getTransactionSript("9090", bom);
			transaction = changeLoanDateScript.createTransaction("9090", null, loan, "", date_9090);
			changeLoanDateScript.setTransaction(transaction);
			changeLoanDateScript.loadTransaction();
			changeLoanDateScript.run();
		} else {
			transaction = TransactionConfig.loanTransaction(transactionSerialNo, bom);
			BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));
			sTransDate = transaction.getString("TransDate");
			//对于生效日期不是在当天的进行换日交易的处理
			if (sTransDate.compareTo(loan.getString("BusinessDate")) > 0) {
				LoanEOD_BOD changeLoanDateScript = (LoanEOD_BOD) TransactionConfig.getTransactionSript("9090", bom);
				BusinessObject eodTransaction = changeLoanDateScript.createTransaction("9090",null,loan,"",DateFunctions.getRelativeDate(transaction.getString("TransDate"),DateFunctions.TERM_UNIT_DAY,-1));
				changeLoanDateScript.setTransaction(eodTransaction);
				changeLoanDateScript.run();
			}
			
			ITransactionScript scriptClass = (ITransactionScript) transaction.getObject("TransactionScript");
			scriptClass.setTransaction(transaction);
			scriptClass.run();
		}

		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		List<BusinessObject> list = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, null);
		List<BusinessObject> psList = PaymentScheduleFunctions.getFuturePaymentScheduleList(loan, null);
		rightType =  "RPT15".equals(loan.getString("RPTTERMID")) ? rightType:"ReadOnly";
		
		//删除原始的还款计划
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		if(loanChange!=null&&!rightType.equals("ReadOnly")){
			
			AbstractBusinessObjectManager bom1 = new DefaultBusinessObjectManager(Sqlca);
			//删除历史
			bom1.setBusinessObjects(AbstractBusinessObjectManager.operateflag_delete, loanChange.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule));
			bom1.updateDB();
			
			for(BusinessObject a:psList){
				BusinessObject b = new BusinessObject(a.getObjectType(),bom1);
				b.setValue(a);
				b.setAttributeValue("ObjectType",loanChange.getObjectType());
				b.setAttributeValue("ObjectNo",loanChange.getObjectNo());
				bom1.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, b);
				list.add(b);
			}
			bom1.updateDB();
		}
		else if("ReadOnly".equals(rightType)&&"RPT15".equals(loanChange.getString("RPTTERMID")))
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectType",loanChange.getObjectType());
			as.setAttribute("ObjectNo",loanChange.getObjectNo());
			list = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule,"ObjectType=:ObjectType and ObjectNo=:ObjectNo order by PayDate,SeqID",as);
		}else list.addAll(psList);
		
		
		
		bom.sortBusinessObject(list, "PayDate");
		double allPrincipalAmt = 0.0;
		double allInteAmt = 0.0;
		double allAmt = 0.0;
		String putoutDate = loan.getString("PutOutDate");
		String maturityDate = loan.getString("MaturityDate");
		int firstSeqID = list.get(0).getInt("SeqID");
		int maxSeqID = list.size() + firstSeqID - 1;
		String rptTermID = loan.getString("RPTTERMID");
		String defaultDueDay = "";
		if("RPT15".equals(loanChange.getString("RPTTERMID"))){
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", loanChange.getObjectNo());
			as.setAttribute("ObjectType", loanChange.getObjectType());
			List<BusinessObject> rptList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "  ObjectNo=:ObjectNo and ObjectType=:ObjectType ", as);
			if(rptList != null && rptList.size() > 0) {
				for(BusinessObject rpt:rptList)
				{
					if(rpt.getString("Status").equals("0"))
						defaultDueDay = rpt.getString("DefaultDueDay");
					if(defaultDueDay.length() == 1)
						defaultDueDay = "0" + defaultDueDay;
				}
			}
			if(defaultDueDay.equals("")){
				defaultDueDay = loan.getString("PutOutDate").substring(8,10);
			}
		}
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
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='导出' onclick="excelShow()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='重置还款计划' onclick="reset()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>期次</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>还款日期</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>本金</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>利息</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>还款金额</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>剩余本金</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>结清日期</font></td>
</tr>

	<%
	if(list != null){
		for(BusinessObject bo:list){
			String payPrincipalColor = "black";
			String payInteColor = "black";
			String fixInstallmentColor = "black";
			String payDateColor = "black";
			String flag = ""; //1 为本金调整 2 为还款额调整
			
			if( bo.getDouble("FixPrincipalAmt") > 0.0d)
			{
				payPrincipalColor = "red";
				flag = "1";
				System.out.println(bo.getDouble("FixPrincipalAmt") + bo.getString("ObjectType")+bo.getString("ObjectNo"));
			}
			else if(bo.getDouble("FixInstallmentAmt") > 0.0d)
			{
				fixInstallmentColor = "red";
				flag = "2";
			}
			else if(!defaultDueDay.equals("") && !bo.getString("PayDate").substring(8, 10).equals(defaultDueDay) && !bo.getString("PayDate").equals(maturityDate))
			{
				payDateColor = "red";
			}
			
			allPrincipalAmt += bo.getDouble("PayPrincipalAmt");
			allInteAmt += bo.getDouble("PayInteAmt");
			allAmt += bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInteAmt");
		%>
		<script language="javascript">
		boList[<%=bo.getInt("SeqID")%>] = Array(<%=bo.getDouble("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PayInteAmt")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>,"<%=bo.getDouble("FinishDate")%>");
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("SeqID")%><input id="SerialNo<%=bo.getInt("SeqID")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("SeqID")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" <%=rightType %> onclick=selectDate("<%=bo.getInt("SeqID")%>","PayDate","<%=bo.getInt("SeqID")%>") ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PayPrincipalAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayInteAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PayInteAmt"))%>" onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PayInteAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixInstallmentAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInteAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("SeqID")%>","FixInstallmentAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PrincipalBalance","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=DataConvert.toString(bo.getString("FinishDate"))%></font></td>
		</tr>
		<%
		}
	}
	%>
	<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>合计</font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
	</tr>
</table>
</div>
</body>
</html>

<script language="javascript">
	function ChangeValue(seqID,colName,colID)
	{
		var value = document.getElementById(colName+colID).value;
		var serialNo = document.getElementById("SerialNo"+colID).value;
		var flag = document.getElementById("Flag"+colID).value;
		if(value == null) return;
		var boTemp = boList[colID];
		if(boTemp == null)
		{
			alert("不存在该还款计划，请刷新后重新输入！");
			return;
		}
		if(colName == "FixInstallmentAmt")
		{
			if(parseFloat(value) < boTemp[2] && parseFloat(value) != 0) 
			{
				alert("还款金额不能小于利息金额！");
				document.getElementById(colName+colID).value=boTemp[1]+boTemp[2];
				return;
			}
			if(flag == "1")
			{
				alert("已经进行本金调整，不能再调整还款金额！");
				reloadSelf();
			}
			if(value==0) value=-1;
			
			RunMethod('LoanAccount','updatePSFixInstallmentAmount',serialNo+','+value);
			reLoad();
		}
		else if(colName == "PayPrincipalAmt")
		{
			if(parseFloat(value) < 0.0) 
			{
				alert("调整本金不能将应还本金调整为负数！");
				document.getElementById(colName+colID).value=boTemp[1];
				return;
			}
			if(value==0) value=-1;
			if(flag == "2")
			{
				alert("已经进行还款金额调整，不能再调整本金！");
				document.getElementById(colName+colID).value=boTemp[1];
				reloadSelf();
			}
			
			RunMethod('LoanAccount','updatePSFixPrincipalAmt',serialNo+','+parseFloat(value));
			reLoad();
		}
		else if(colName == "PayDate")
		{		
			if(typeof(value)=="undefined")
				return;
			if(flag == "1" || flag == "2")
			{
				alert("已经进行还款金额调整，不能再调整日期！");				
				reloadSelf();
			} 
			else{
				RunMethod('LoanAccount','updatePayDate',serialNo+','+value);	
				reLoad();
			}			
		}
	}
	/*~[Describe=导出excel;InputParam=无;OutPutParam=无;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	/*~[Describe=重置还款计划;InputParam=无;OutPutParam=无;]~*/
	function reset()
	{
		RunMethod('LoanAccount','deletePaymentSchedule','<%=transaction.getString("DocumentSerialNo")%>,<%=transaction.getString("DocumentType")%>');
		reLoad();
	}
	
	function reLoad()
	{
		OpenComp("SimulationPaymentSchedule","/Accounting/Transaction/ViewPrepaymentConsult.jsp","TransSerialNo=<%=transactionSerialNo%>","_self");
	}
	
	function selectDate(seqID,colName,colID){
		var rpt = "<%=rptTermID%>";
		if(rpt != "RPT15") return;
		var putoutDate = "<%=putoutDate%>";
		var maturityDate = "<%=maturityDate%>";
		var maxseqID = "<%=maxSeqID%>";
		var firstSeqID = "<%=firstSeqID%>";

		var sDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=220px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
		if(typeof(sDate)!="undefined" && sDate!=""){
			if((parseInt(colID) > parseInt(firstSeqID)) && (parseInt(colID) < parseInt(maxseqID))){
				if((sDate > document.getElementById(colName+(parseInt(colID)-1)).value) && (sDate < document.getElementById(colName+(parseInt(colID)+1)).value))
				{	
					document.getElementById(colName+colID).value=sDate;
					ChangeValue(seqID,colName,colID);
				}
				else{
					alert("本期还款日期应当介于上期和下期还款日期，请重新选择！");
					reloadSelf();
				}			
			}
			else 				
			{	if(parseInt(firstSeqID) == parseInt(colID)){
					if(sDate <= putoutDate){
						alert("还款日期必需大于贷款出账日期，请重新选择！");
						reloadSelf();
					}else if(parseInt(colID) < parseInt(maxseqID) && sDate > document.getElementById(colName+(parseInt(colID)+1)).value){
						alert("还款日期必需小于下期还款日期，请重新选择！");
						reloadSelf();
					}
					else{
						document.getElementById(colName+colID).value=sDate;
						ChangeValue(seqID,colName,colID);
					}
				}
				else if(parseInt(maxseqID) == parseInt(colID)){					
					if(sDate >= maturityDate){
						alert("还款日期必需小于贷款到期日期，请重新选择！");
						reloadSelf();
					}else if(parseInt(firstSeqID) < parseInt(maxseqID) && sDate < document.getElementById(colName+(parseInt(colID)-1)).value){
						alert("还款日期必需大于上期还款日期，请重新选择！");
						reloadSelf();
					}
					else{
						document.getElementById(colName+colID).value=sDate;
						ChangeValue(seqID,colName,colID);
					}
				}
			}			
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>