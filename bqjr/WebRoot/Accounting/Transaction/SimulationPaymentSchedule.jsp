<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.util.PaymentScheduleFunctions"%>
<%@ include file="/IncludeBegin.jsp"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	//jqcao:ԭobjectType д���ģ���Ϊ���Σ������ָ���쳣
	/* String objectType = "jbo.app.ACCT_LOAN"; //'jbo.app.ACCT_LOAN' */
	String objectType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));	//
	String objectNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));	//
	String rightType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType")));	//
	if(objectType == null) throw new Exception("δ����������ͣ����飡");
	if(objectNo == null) throw new Exception("δ��������ţ����飡");
	if(rightType == null) rightType = "";
	String putoutDate = "";
	List<BusinessObject> list = null;
	BusinessObject document = AbstractBusinessObjectManager.getBusinessObject(objectType,objectNo,Sqlca);
	//if(document == null || !document.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.business_putout)) throw new Exception("���봫�������Ϣ�����飡");
	AbstractBusinessObjectManager bom=new DefaultBusinessObjectManager(Sqlca);
	BusinessObject loan = null;
	if("ReadOnly".equals(rightType)&&("RPT15".equals(document.getString("RPTTERMID")) || document.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)))
	{
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",document.getObjectType());
		as.setAttribute("ObjectNo",document.getObjectNo());
		loan = document;
		list = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule,"ObjectType=:ObjectType and ObjectNo=:ObjectNo and PayDate > '"+SystemConfig.getBusinessDate()+"' order by PayDate,SeqID",as);
		putoutDate = loan.getString("PutOutDate");
	}else
	{
		String transactionTermID = "TRA001";
		String transactionCode = ProductConfig.getProductTermParameterAttribute(document.getString("BusinessType"), document.getString("ProductVersion"), transactionTermID, "TransactionCode", "DefaultValue");
		if(transactionCode==null||transactionCode.length()==0) 
			throw new Exception("�ò�Ʒ��"+document.getString("BusinessType")+"-"+ document.getString("ProductVersion")+"��δ���ý��������"+transactionTermID+"���Ĳ�����TransactionCode����Ĭ��ֵ����ȷ�ϸ���ҵ���Ƿ��ʹ�ô˹��ܣ�");
		com.amarsoft.app.accounting.trans.ITransactionScript scriptClass = com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionSript(transactionCode, bom);
		putoutDate = document.getString("PutoutDate");
		if(putoutDate==null||putoutDate.length()==0)putoutDate=SystemConfig.getBusinessDate();
		BusinessObject transaction = scriptClass.createTransaction(transactionCode,document,document, CurUser.getUserID(),putoutDate);
		scriptClass.loadTransaction();
		scriptClass.prerun();
		scriptClass.run();
		bom.clear();//��չ��������� ����ֻ���滹��ƻ�
	 	loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		List<BusinessObject> boList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		rightType =  "RPT15".equals(document.getString("RPTTERMID"))?"":"ReadOnly";
		
		loan.setAttributeValue("UpdateInstalAmtFlag", "1");
		BusinessObject loan1=loan.cloneObject();
		PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, null,  new DefaultBusinessObjectManager(Sqlca));
		loan.setRelativeObjects(PaymentScheduleFunctions.createLoanPaymentScheduleList(loan1, null, new DefaultBusinessObjectManager(Sqlca)));
		
		list =  loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		
		for(BusinessObject l: list)
		{
			l.setAttributeValue("ObjectType",document.getObjectType());
			l.setAttributeValue("ObjectNo",document.getObjectNo());
		}
		bom.sortBusinessObject(list, "PayDate");
		
		
		bom.setBusinessObjects(AbstractBusinessObjectManager.operateflag_delete, document.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule));
		bom.updateDB();
		bom.commit();
		if("RPT15".equals(document.getString("RPTTERMID")))
		{
			bom.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, list);
			bom.updateDB();
		}
	}
	
	double allPrincipalAmt = 0.0;
	double allInteAmt = 0.0;
	double allAmt = 0.0;
	String maturityDate = loan.getString("MaturityDate");
	int firstSeqID = list.get(0).getInt("SeqID");
	int maxSeqID = list.size() + firstSeqID - 1;
	String rptTermID = loan.getString("RPTTERMID");
	String defaultDueDay = "";
	if("RPT15".equals(loan.getString("RPTTERMID"))){
		List<BusinessObject> rptList = loan.getRelativeObjects("jbo.app.ACCT_RPT_SEGMENT");
		if(rptList!=null &&rptList.size() > 0  )  {
			for(BusinessObject rpt:rptList)
			{

				if(rpt.getString("Status").equals("1"))
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
<%/*~END~*/%>

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
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'><input type=button value='���û���ƻ�' style="<%=("ReadOnly".equals(rightType) ? "display:none" : "") %>" onclick="reset()"> </font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'></font></td>
</tr>
<tr id = "CRTitle"> 
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�ڴ�</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��������</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��Ϣ</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>������</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>ʣ�౾��</font></td>
</tr>

	<%
	if(list != null)
	{
		for(BusinessObject bo:list)
		{
			String payPrincipalColor = "black";
			String payInteColor = "black";
			String payDateColor = "black";
			String fixInstallmentColor = "black";
			String flag = ""; //1 Ϊ������� 2 Ϊ��������
			
			if( bo.getDouble("FixPrincipalAmt") > 0.0d)
			{
				payPrincipalColor = "red";
				flag = "1";
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
		boList[<%=bo.getInt("SeqID")%>] = Array(<%=bo.getDouble("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PayInteAmt")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("SeqID")%><input id="SerialNo<%=bo.getInt("SeqID")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("SeqID")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" <%=rightType %> onclick=selectDate("<%=bo.getInt("SeqID")%>","PayDate","<%=bo.getInt("SeqID")%>") ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PayPrincipalAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayInteAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PayInteAmt"))%>" onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PayInteAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixInstallmentAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInteAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("SeqID")%>","FixInstallmentAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PrincipalBalance","<%=bo.getInt("SeqID")%>")></font></td>
		</tr>
		<%
		}
	}
	%>
	<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>�ϼ�</font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allPrincipalAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allInteAmt)%></font></td>
		<td colspan="1" align='center'><font align='right' color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'><%=DataConvert.toMoney(allAmt)%></font></td>
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
			alert("�����ڸû���ƻ�����ˢ�º��������룡");
			return;
		}
		
		if(colName == "FixInstallmentAmt")
		{
			if(parseFloat(value) < boTemp[2] && parseFloat(value) != 0) 
			{
				alert("�������С����Ϣ��");
				document.getElementById(colName+colID).value=boTemp[1]+boTemp[2];
				return;
			}
			if(flag == "1")
			{
				alert("�Ѿ����б�������������ٵ��������");
				document.getElementById(colName+colID).value=boTemp[1]+boTemp[2];
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
				alert("���������ܽ�Ӧ���������Ϊ������");
				document.getElementById(colName+colID).value=boTemp[1];
				return;
			}
			if(value==0) value=-1;
			if(flag == "2")
			{
				alert("�Ѿ����л���������������ٵ�������");
				document.getElementById(colName+colID).value=boTemp[1];
				reloadSelf();
			}
			
			RunMethod('LoanAccount','updatePSFixPrincipalAmt',serialNo+','+parseFloat(value));
			reLoad();
		}else if(colName == "PayDate")
		{		
			if(typeof(value)=="undefined")
				return;
			if(flag == "1" || flag == "2")
			{
				alert("�Ѿ����л���������������ٵ������ڣ�");				
				reloadSelf();
			}
			else {
				RunMethod('LoanAccount','updatePayDate',serialNo+','+value);
				reLoad();
			}
		}
	}
	/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	/*~[Describe=���û���ƻ�;InputParam=��;OutPutParam=��;]~*/
	function reset()
	{
		RunMethod('LoanAccount','deletePaymentSchedule','<%=document.getObjectNo()%>,<%=document.getObjectType()%>');
		reLoad();
	}
	
	function reLoad()
	{
		OpenComp("SimulationPaymentSchedule","/Accounting/Transaction/SimulationPaymentSchedule.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self");
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
					alert("���ڻ�������Ӧ���������ں����ڻ������ڣ�������ѡ��");
					reloadSelf();
				}			
			}
			else 				
			{	if(parseInt(firstSeqID) == parseInt(colID)){
					if(sDate <= putoutDate){
						alert("�������ڱ�����ڴ���������ڣ�������ѡ��");
						reloadSelf();
					}else if(parseInt(colID) < parseInt(maxseqID) && sDate > document.getElementById(colName+(parseInt(colID)+1)).value){
						alert("�������ڱ���С�����ڻ������ڣ�������ѡ��");
						reloadSelf();
					}
					else{
						document.getElementById(colName+colID).value=sDate;
						ChangeValue(seqID,colName,colID);
					}
				}
				else if(parseInt(maxseqID) == parseInt(colID)){					
					if(sDate >= maturityDate){
						alert("�������ڱ���С�ڴ�������ڣ�������ѡ��");
						reloadSelf();
					}else if(parseInt(firstSeqID) < parseInt(maxseqID) && sDate < document.getElementById(colName+(parseInt(colID)-1)).value){
						alert("�������ڱ���������ڻ������ڣ�������ѡ��");
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