<%@page import="com.amarsoft.app.accounting.web.bizlets.AheadPaymentCalculate"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  xjzhao 2012/03/28
		Tester:
		Content: ��������
		Input Param:
		Output param:
		History Log:
		
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���׹�������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));//������ˮ��
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));//TransApply
	String sScheduleDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScheduleDate")));//�ƻ���ǰ������
	String sPayDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PayDate")));//��ǰ�����������
	String sFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag")));
	String sYesNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("YesNo")));//�Ƿ���ȡ��ǰ����������
	String PrePrepayFeeAmt = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrePrepayFeeAmt")));//��ǰ����������
	String ContractSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo")));//��ͬ��ˮ
	
	// ��ȡ��ͬ�źͿͻ�����
	/* String sbcInfoSql = "SELECT BC.SERIALNO||'@'||BC.CUSTOMERNAME FROM ACCT_TRANSACTION ATR, ACCT_FEE AF, ACCT_LOAN AL, BUSINESS_CONTRACT BC " + 
		" WHERE ATR.RELATIVEOBJECTNO=AF.SERIALNO AND AF.OBJECTNO=AL.SERIALNO AND AL.PUTOUTNO=BC.SERIALNO AND ATR.SERIALNO=:SERIALNO";
	String sbccusname = DataConvert.toString(Sqlca.getString(new SqlObject(sbcInfoSql).setParameter("SERIALNO", objectNo)));
	String[] bccusnameArray = sbccusname.split("@");
	String sBcSerialno = "";
	String sCustomername = "";
	if (bccusnameArray.length == 2) {
		sBcSerialno = bccusnameArray[0];
		sCustomername = bccusnameArray[1];
	} */
	String sCustomername = Sqlca.getString("select customername from business_contract where serialno='"+ContractSerialNo+"'");
	if(sCustomername==null){
		sCustomername = "";
	}
	
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction,objectNo);
	if(bo == null)  throw new Exception("���ײ����ڣ�");
	String transCode = bo.getString("TransCode");
	String transStatus = bo.getString("TransStatus");
	String relaObjectType = bo.getString("RelativeObjectType");
	String relaObjectNo = bo.getString("RelativeObjectNo");
	String documentSerialNo = bo.getString("DocumentSerialNo");
	String documentType = bo.getString("DocumentType");
	//ģ�壬�������ͣ���������ʹ����
	ASValuePool templete = com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionDef(transCode);
	String templeteNo=templete.getString("ViewTempletNo");
	String tranType=templete.getString("Type");
	
	//��ȡ�����˺�
	com.amarsoft.app.accounting.web.bizlets.GetTransactionRela gtr = new com.amarsoft.app.accounting.web.bizlets.GetTransactionRela();
	gtr.setAttribute("SerialNo",objectNo);
	gtr.setAttribute("Type",BUSINESSOBJECT_CONSTATNTS.loan);
	String loanSerialNo = (String)gtr.run(Sqlca);
	
	String productID = "";
	String productVersion ="";
	if(loanSerialNo!=null&&loanSerialNo.length()>0&&!loanSerialNo.equalsIgnoreCase("false")){
	BusinessObject loan = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan,loanSerialNo);
		productID = loan.getString("BusinessType");
		productVersion = loan.getString("ProductVersion");
	}
	
	String businessDate = SystemConfig.getBusinessDate();
	String Sql = "select (PayPrincipalAmt - nvl(ActualPayPrincipalAmt,0)) as PayPrincipalAmt,(PayInteAmt - nvl(ActualPayInteAmt,0)) as PayInteAmt from acct_payment_schedule where ObjectNo = '"+relaObjectNo+"' and ObjectType = '"+BUSINESSOBJECT_CONSTATNTS.loan+"' and PayDate = '"+businessDate+"' ";
	ASResultSet rs = Sqlca.getASResultSet(Sql);
	double PayPrincipalAmt = 0.0d;
	double PayInteAmt = 0.0d;
	if(rs.next()){
		PayPrincipalAmt = DataConvert.toDouble(rs.getString("PayPrincipalAmt"));
		PayInteAmt = DataConvert.toDouble(rs.getString("PayInteAmt"));
	}
	rs.getStatement().close();
	String sFeeSerialno="";
	if(transCode.equals("3530")){
		String Sql1 = "select relativeobjectno from acct_transaction  where serialno='"+objectNo+"'";
		ASResultSet ars = Sqlca.getASResultSet(Sql1);
		if(ars.next()){
			sFeeSerialno = ars.getString("relativeobjectno");
		}
		ars.getStatement().close();
	}
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASDataObject doTemp = new ASDataObject(templeteNo,Sqlca);
	if(transCode.equals("3530")){	
		doTemp.setDDDWSql("SeqID", "select seqid,seqid from acct_payment_schedule aps where aps.objectno='"+sFeeSerialno+"' and aps.objecttype='jbo.app.ACCT_FEE' and aps.finishdate is null");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����datawindow����
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", productID);
	valuePool.setAttribute("ProductVersion", productVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	dwTemp.setEvent("AfterUpdate","!LoanAccount.UpdateTransaction("+objectNo+",#TransDate)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{sFlag.equals("010")&&!"0055".equals(transCode)?"true":"flase","All","Button","����","����������Ϣ","saveRecord('afterSave()')",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���ݱ���;InputParam=��;OutPutParam=��;]~*/
	//��ǰ����ı������ҳ���ʼ��
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
		//if( !confirm("ȷ���������Ϣ��?")) return;
		if(!beforeSave()) return;  //����У�����
		//����acct_fee_waive
		if("<%=transCode%>"=="3530"){
			var sFeeSerialNo = getItemValue(0,getRow(),"FeeSerialNo");
			var sSeqID = getItemValue(0,getRow(),"SeqID");
			var sWaiveAmount = getItemValue(0,getRow(),"WaiveAmount");
			var sReturn=RunMethod("BusinessManage","UpdateFeeWaive",sWaiveAmount+","+sSeqID+","+sFeeSerialNo+","+"<%=CurUser.getUserID()%>"+","+"<%=CurUser.getOrgID()%>"+","+<%=objectNo%>);
			if(sReturn=='1'){
				alert("������ˮ��:��"+sFeeSerialNo+"���ڵڡ�"+sSeqID+"��������һ��δ��Ч�ķ��ü�������,�������ظ�����");
				return;
			}
			else if(sReturn!='true') return;
		}
		if("<%=transCode%>"=="0052" || "<%=transCode%>"=="0055"){
			
			if("<%=transCode%>"=="0055"){
				/* if(!confirm("�Ƿ�ȷ����ǰ��������,ȷ�Ͻ�������Ӧ���ã�")) return; */
				
				var PrePrepayFeeAmt = "<%=PrePrepayFeeAmt%>";
				var sYesNo = "<%=sYesNo%>";
				if(sYesNo=="1" && (parseFloat(PrePrepayFeeAmt)>0.0 && typeof(PrePrepayFeeAmt) !="undefined")){
					var sSerialNo = "<%=ContractSerialNo%>";
					var sPayDate = "<%=sPayDate%>";
					var LoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
					var atpserialno = getItemValue(0,getRow(),"SerialNo");
					var xx = RunMethod("PublicMethod","GetColValue","amount,acct_fee,String@feetype@A9@String@ObjectNo@"+LoanSerialNo);
				
					if(parseFloat(xx.split("@")[1])<=0.0 || xx.split("@")[1]=="null" || typeof(xx.split("@")[1]) == "undefined"){
						var returnvalue = RunMethod("BusinessManage","BusinessPrepayAmt",sSerialNo+","+sPayDate);
						if("SUCCESS" != returnvalue){
							alert("���ò���ʧ�ܣ�");
							return;
						}
					}
				}
			}
			as_save("myiframe0","");
		}
		else{
			as_save("myiframe0",sPostEvents);
		}
	}
	
	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
	}
	
	/*~[Describe=���ÿ�ֵ;InputParam=�����¼�;OutPutParam=��;]~*/
	function setValue(colName,Value)
	{
		var sColName = getItemValue(0,getRow(),colName);
		if(typeof(sColName) == "undefined" || sColName.length == 0)
		{
			setItemValue(0,getRow(),colName,Value);
		}
	}
	
	</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<%
	String jsfile=com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionDef(transCode, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
		String[] s=jsfile.split("@");
		for(String s1:s){System.out.println(sWebRootPath+s1);
%>
<script type="text/javascript" src="<%=sWebRootPath+s1%>"> </script>
<%		}
	}
	else{
%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/transaction/transaction.js"> </script>
<%		
	}
	%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	
	var bCheckBeforeUnload = false;
	var businessDate = "<%=businessDate%>";
	var systemDate = "<%=SystemConfig.getSystemDate()%>";
	var curUserID = "<%=CurUser.getUserID()%>";
	var curUserName = "<%=CurUser.getUserName()%>";
	var curOrgID = "<%=CurOrg.getOrgID()%>";
	var curOrgName = "<%=CurOrg.getOrgName()%>";
	var documentType = "<%=documentType%>";
	var documentSerialNo = "<%=documentSerialNo%>";
	var transactionSerialNo = "<%=objectNo%>";
	var payPrincipalAmt = "<%=PayPrincipalAmt%>";
	var payInteAmt = "<%=PayInteAmt%>";
	var relaObjectNo = "<%=relaObjectNo%>";
	var relaObjectType = "<%=relaObjectType%>";
	var sPayDate="<%=sPayDate%>";
	var sScheduleDate="<%=sScheduleDate%>";
	initRow();
	
	var PayAmt = getItemValue(0,getRow(),"PayAmt");
	var PrePrepayFeeAmt="<%=PrePrepayFeeAmt%>";
	setItemValue(0,getRow(),"PrepaymentFee",PrePrepayFeeAmt);
	var temp = getItemValue(0,getRow(),"CashOnlineFlag");
	if(temp=="1"){
		PrePrepayFeeAmt = "0.00";
	}
	setItemValue(0,getRow(),"PayAmt",parseFloat(PrePrepayFeeAmt)+parseFloat(PayAmt));
	
	setItemValue(0,getRow(),"CashOnlineFlag","1");
	
	// ���ú�ͬ�źͿͻ�����
	setItemValue(0, 0, "BCSerialno", "<%=ContractSerialNo%>");
	setItemValue(0, 0, "CustomerName", "<%=sCustomername%>");
	var transCode = "<%=transCode%>";
	if("0055"==transCode){
		saveRecord('afterSave()');
	}
	
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>