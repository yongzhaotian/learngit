<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.TransactionConfig"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  	--spectre	2010.03
		Tester:
		Content: ҵ�������Ϣ
		Input Param:
		Output param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����	
	String transactionSerialNo =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));

	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	BusinessObject transaction = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transactionSerialNo);
	if(transaction==null){
		throw new Exception("δ�Ҵ���{"+transactionSerialNo+"}");
	}
	String transactionStatus = transaction.getString("TransStatus");
	String transactionCode=transaction.getString("TransCode");
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%	
	//��ҵ��������л��ҵ��Ʒ�֡��������͡�ѭ���������͡����ʽ
	String templeteNo = TransactionConfig.getTransactionDef(transactionCode, "ViewTempletNo");
	if(templeteNo==null||templeteNo.length()==0){//û������ģ��Ľ���
		templeteNo="Acct_Transaction";
	}
	ASDataObject doTemp = new ASDataObject(templeteNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	
	if(transactionStatus==null||transactionStatus.equals("0")){
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	else{
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","200");
	}
	if(templeteNo.equals("Acct_Transaction")){
		doTemp.setVisible("", false);
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","10");
	}
	
	//����datawindow����
	ASValuePool valuePool=new ASValuePool(); 
	valuePool.setAttribute("ProductID", loan.getString("BusinessType"));
	valuePool.setAttribute("ProductVersion", loan.getString("ProductVersion"));
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	String dwValues=DWExtendedFunctions.setDataWindowValues(transaction,transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo")), dwTemp,Sqlca);
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("TT_1,TT_1,TT_1,TT_1,TT_1");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","����","saveBusinessObjectToSession('"+transaction.getString("DocumentType")+"','"+BUSINESSOBJECT_CONSTATNTS.transaction+"','"+transactionSerialNo+"')",sResourcesPath},
			{"true","","Button","��Ʒ�¼","��Ʒ�¼","viewJournalList()",sResourcesPath},
	};
	
	if(transactionStatus==null||transactionStatus.equals("0")){
		sButtons[1][0]="false";
	}
	else{
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	
	<script language=javascript>
	//��¼��Ϣ
	function viewJournalList(){
		OpenPage("/Accounting/LoanSimulation/BusinessObjectList.jsp?ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.subledger_detail%>&TempleteNo=LoanDetailList&ParentObjectType=<%=BUSINESSOBJECT_CONSTATNTS.transaction%>&ParentObjectNo=<%=transactionSerialNo%>","DetailFrame","");
	}
</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<%
	String jsfile=com.amarsoft.app.accounting.config.loader.TransactionConfig.getTransactionDef(transactionCode, "JSFile");
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

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	<%= dwValues%>
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	
	var bCheckBeforeUnload = false;
	var businessDate = "<%=SystemConfig.getBusinessDate()%>";
	var systemDate = "<%=SystemConfig.getSystemDate()%>";
	var curUserID = "<%=CurUser.getUserID()%>";
	var curUserName = "<%=CurUser.getUserName()%>";
	var curOrgID = "<%=CurOrg.getOrgID()%>";
	var curOrgName = "<%=CurOrg.getOrgName()%>";
	var documentType = "<%=transaction.getString("DocumentType")%>";
	var documentSerialNo = "<%=transaction.getString("DocumentSerialNo")%>";
	var transactionSerialNo = "<%=transaction.getString("SerialNo")%>";
	var payPrincipalAmt = "";
	var payInteAmt = "";
	var relaObjectNo = "<%=transaction.getString("RelativeObjectNo")%>";
	var relaObjectType = "<%=transaction.getString("RelativeObjectType")%>";
	initRow();
<%	if(transactionStatus!=null&&!transactionStatus.equals("0")){
%>
		viewJournalList();
<%	}
%>
</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
