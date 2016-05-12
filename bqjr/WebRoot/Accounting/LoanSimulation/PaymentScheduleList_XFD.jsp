<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Comparator"%>
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
	
	List<BusinessObject> list1 =parentObject.getRelativeObjects(objectType);
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
	
	list1.addAll(list_fee_payment);
	
//888888888888888888888888888---����--===start==888888888888888888888888888888888888888888888888888888888888888
	
  /*   System.out.println(list1.toString()); 
	String periodstemp = "";
	
	BusinessObject businesscontracts= (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");
	
	periodstemp=businesscontracts.getString("PERIODS");

	int periods = (int)Float.parseFloat(periodstemp); */
	int SeqID = 1;
	
	 List<BusinessObject> list = new ArrayList<BusinessObject>();	
	
	 int i=0;
	
	 for(int j=0;j<list1.size();j++){
		 for(BusinessObject b:list1){
				if(b.getString("SeqID").equals(String.valueOf(i+1))){
					list.add(b);
				}
			}
		 i++;
	 }
	
	double monthPrincipalAmt = 0.0;//ÿ��Ӧ����� 
	
//888888888888888888888888888---x����--===end==888888888888888888888888888888888888888888888888888888888888888
	
	double allPrincipalAmt = 0.0;
	double allInteAmt = 0.0;
	double allAmt = 0.0;
	int firstSeqID = list.get(0).getInt("SeqID");
	int maxSeqID = list.size() + firstSeqID - 1;
	String rptTermID = simulationObject.getString("RPTTERMID");
	String defaultDueDay = "";
	
	
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
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>�ڴ�</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��������</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��������</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>Ӧ�����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>ʵ�����</font></td>
	<td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��Ϣ</font></td>
	<!-- <td colspan="1" align='center'><font color='#000880' style=' font-size: 11pt;FONT-WEIGHT: bold;'>��Ӧ��������</font></td> -->
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
			
			String PayType = "";
			if(bo.getString("PayType").equals("1")){
				PayType="��������";
			}else if(bo.getString("PayType").equals("A2")){
				PayType="�ͻ������";
			}else if(bo.getString("PayType").equals("A7")){
				PayType="������ʷ�";
			}else if(bo.getString("PayType").equals("A10")){
				PayType="���ɽ�";
			}else if(bo.getString("PayType").equals("A11")){
				PayType="ӡ��˰";
			}else if(bo.getString("PayType").equals("A12")){
				//PayType="���շ�";
				PayType="��ֵ�����";
			}else if(bo.getString("PayType").equals("A14")){
				PayType="������";
			}else if(bo.getString("PayType").equals("A3")){
				PayType="��ǰ����������";
			}else if(bo.getString("PayType").equals("A9")){
				PayType="��ǰ����������";
			}else if(bo.getString("PayType").equals("A18")){
				PayType="���Ļ������";
			}
			
		%>
		<script language="javascript">
		boList[<%=bo.getInt("SeqID")%>] = Array(<%=bo.getString("PayDate")%>,<%=bo.getDouble("PayPrincipalAmt")%>,<%=bo.getDouble("PayInteAmt")%>,<%=bo.getDouble("FixInstallmentAmt")%>,<%=bo.getDouble("FixPrincipalAmt")%>);
		</script>
		<tr>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><%=bo.getInt("SeqID")%><input id="SerialNo<%=bo.getInt("SeqID")%>" type=hidden value="<%=bo.getString("SerialNo")%>"/></font></td>
			<input id="Flag<%=bo.getInt("SeqID")%>" type=hidden value="<%=flag%>"/></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayType<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=PayType%>" ) ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayDate<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payDateColor%>' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toString(bo.getString("PayDate"))%>" <%=rightType %> onclick=selectDate("<%=bo.getInt("SeqID")%>","PayDate","<%=bo.getInt("SeqID")%>") ></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PayPrincipalAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayPrincipalAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payPrincipalColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("ActualPayPrincipalAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PayPrincipalAmt","<%=bo.getInt("SeqID")%>")></font></td>
			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PayInteAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=payInteColor%>; ' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PayInteAmt"))%>" onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PayInteAmt","<%=bo.getInt("SeqID")%>")></font></td>
<%-- 			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="FixInstallmentAmt<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px;COLOR: <%=fixInstallmentColor%>' class=fftdinput type=text onblur=parent.trimField(this) value="<%=DataConvert.toMoney(bo.getDouble("PayPrincipalAmt")+bo.getDouble("PayInteAmt"))%>" <%=rightType %> onchange=ChangeValue("<%=bo.getInt("SeqID")%>","FixInstallmentAmt","<%=bo.getInt("SeqID")%>")></font></td>
 --%>			<td colspan="1" align='center'><font style=' font-size: 9pt;'><input id="PrincipalBalance<%=bo.getInt("SeqID")%>" style='text-align: right;WIDTH: 80px; COLOR: black;' class=fftdinput type=text onblur=parent.trimField(this) readOnly value="<%=DataConvert.toMoney(bo.getDouble("PrincipalBalance"))%>" onchange=ChangeValue("<%=bo.getInt("SeqID")%>","PrincipalBalance","<%=bo.getInt("SeqID")%>")></font></td>
		</tr>
		<%
		}
		
	}
	
	%>
	<tr>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'>�ϼ�</font></td>
		<td colspan="1" align='center'><font color='#000880' style=' font-size: 9pt;FONT-WEIGHT: bold;'></font></td>
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
	
</script>
<%@ include file="/IncludeEnd.jsp"%>