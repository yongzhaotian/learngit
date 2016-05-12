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
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASDataObject doTemp = new ASDataObject(templeteNo,Sqlca);
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
		{"true","All","Button","����","����������Ϣ","saveRecord('afterSave()')",sResourcesPath},
		{"false","","Button","����ƻ�����","����ƻ�����","viewConsult()",sResourcesPath},
		{"false","","Button","��Ϣ�ƻ�����","��Ϣ�ƻ�����","viewSPTConsult()",sResourcesPath}
	};
	if(("0055".equals(transCode) || "2011".equals(transCode) || "2012".equals(transCode) || "2013".equals(transCode) || "2017".equals(transCode)) && !"1".equals(transStatus)){
		sButtons[1][0] = "true";
	}
	if("2016".equals(transCode) &&  !"1".equals(transStatus)) {
		sButtons[2][0] = "true";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���ݱ���;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
		//if( !confirm("ȷ���������Ϣ��?")) return;
		if(!beforeSave()) return;  //����У�����
		as_save("myiframe0",sPostEvents);
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
	
	/*~[Describe=��Ϣ�ƻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewSPTConsult()
	{
		var transactionSerialNo = "<%=objectNo%>";
		PopComp("ViewSPTConsult","/Accounting/Transaction/ViewSPTConsult.jsp","TransSerialNo="+transactionSerialNo,"");
	}
	
	</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<%
	String jsfile=com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionDef(transCode, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
		String[] s=jsfile.split("@");
		for(String s1:s){
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
	initRow();
	setItemValue(0,getRow(),"CashOnlineFlag","1");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>