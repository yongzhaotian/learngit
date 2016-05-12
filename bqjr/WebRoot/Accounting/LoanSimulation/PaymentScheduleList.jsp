<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ƻ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	//if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");
	
	String rightType =  "RPT15".equals(simulationObject.getString("RPTTERMID"))?"":"ReadOnly";
	String objectType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));
	String parentObjectType =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentObjectType")));
	String parentObjectNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentObjectNo")));
	String putoutDate = simulationObject.getString("PutOutDate");
	String maturityDate = simulationObject.getString("MaturityDate");
	BusinessObject parentObject=null;
	if(parentObjectType!=null&&parentObjectType.length()>0){
		parentObject = simulationObject.getRelativeObject(parentObjectType, parentObjectNo);
		if(parentObject==null){
			throw new Exception("δ�ҵ�����{"+parentObjectType+"-"+parentObjectNo+"}!");
		}
	}
	else{
		parentObject=simulationObject;
	}
	
	List<BusinessObject> list =parentObject.getRelativeObjects(objectType);
	List<BusinessObject> list_fee = new ArrayList<BusinessObject>();
	List<BusinessObject> list_fee_payment = new ArrayList<BusinessObject>();
	list_fee=parentObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);//��ȡ��ݹ����ķ��÷���
	if(list_fee !=null){
		for(BusinessObject fee:list_fee){
			List<BusinessObject> fee_payment = new ArrayList<BusinessObject>();
			fee_payment=fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);//���÷�����Ӧ����ƻ�
			if(fee_payment!=null){
				list_fee_payment.addAll(fee_payment);
			}
			
		}
	}
	
	list.addAll(list_fee_payment);

	double allPrincipalAmt = 0.0;
	double allInteAmt = 0.0;
	double allAmt = 0.0;
	int firstSeqID = list.get(0).getInt("SeqID");
	int maxSeqID = list.size() + firstSeqID - 1;
	String rptTermID = simulationObject.getString("RPTTERMID");
	String defaultDueDay = "";
	if("RPT15".equals(simulationObject.getString("RPTTERMID"))){
		List<BusinessObject> rptList = parentObject.getRelativeObjects("jbo.app.ACCT_RPT_SEGMENT");
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
			defaultDueDay = simulationObject.getString("PutOutDate").substring(8,10);
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
<input type=button value='����' onclick="excelShow()"> 
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='70%' border=0 cellspacing="4" cellpadding="0">
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
		boList[<%=bo.getInt("SeqID")%>] = Array(<%=bo.getString("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PayInteAmt")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>);
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
				reloadSelf();
			}
			if(value==0) value=-1;
			
			var paraStr = "RowCount=1&ParentObjectType=&ParentObjectNo="
				+"&BusinessObjectType=<%=objectType%>&SerialNo1="+serialNo
				+"&FixInstallmentAmt1="+value+"&ColNames=FixInstallmentAmt";
			
			var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			if(returnValue=="true"){
				
				var returnValue = PopPage("/Accounting/LoanSimulation/updatePaymentSchedule.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
				reloadSelf();
			}
			else
				alert("ϵͳ�������ݳ����쳣��");
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
			var paraStr = "RowCount=1&ParentObjectType=&ParentObjectNo="
				+"&BusinessObjectType=<%=objectType%>&SerialNo1="+serialNo
				+"&FixPrincipalAmt1="+parseFloat(value)
				+"&ColNames=FixPrincipalAmt";
			var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			if(returnValue=="true"){
				
				var returnValue = PopPage("/Accounting/LoanSimulation/updatePaymentSchedule.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
				reloadSelf();
			}
			else
				alert("ϵͳ�������ݳ����쳣��");
		}

		else if(colName == "PayDate"){
			
			if(typeof(value)=="undefined")
				return;
			if(flag == "1" || flag == "2")
			{
				alert("�Ѿ����л���������������ٵ������ڣ�");				
				reloadSelf();
			} 
			else {
				var paraStr = "RowCount=1&ParentObjectType=&ParentObjectNo="
					+"&BusinessObjectType=<%=objectType%>&SerialNo1=" + serialNo
					+"&PayDate1="+value
					+"&ColNames=PayDate";
	
				var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
				if(returnValue=="true"){			
					var returnValue = PopPage("/Accounting/LoanSimulation/updatePaymentSchedule.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
					reloadSelf();
				}
			}
		}
	}
	/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
	function excelShow()
	{
		var mystr = document.all('Layer1').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
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