<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan");
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("Acct_Transaction",Sqlca);
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","��������","��������","newTransaction()",sResourcesPath},
			{"true","","Button","����","���˽���","runTransaction()",sResourcesPath},
			{"true","","Button","����","���˽���","reverseTransaction()",sResourcesPath},
			{"true","","Button","��������","��������","viewTransaction()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteTransaction()",sResourcesPath},
			{"true","","Button","ƾ֤��ӡ","ƾ֤��ӡ","printDocument()",sResourcesPath},
		};

	if(loan==null){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}
		
	%>
<%/*~END~*/%>

<%
	String businessDate = "";
	if(null!=loan){
		businessDate = loan.getString("BusinessDate");
	}
	if(!"".equals(businessDate)){
%>	
		
		<table>
		 	 <tr align="right">
		 	 	<td align="right"> 
		 	 		<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 	 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ǰ���ڣ�<%=businessDate%></font>
		 		</td>
		 	  </tr>
		</table>
<%
	}
%>	


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<script language=javascript>
	//���ཻ���б� 
	function newTransaction(){
		var returnValue = setObjectValue("SelectLoanSimulationTransCode","","",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "_CANCEL_" || returnValue == "_NONE_" || returnValue == "_CLEAR_" ) return;
		returnValue=returnValue.split("@");
		var transCode=returnValue[0];
		var transDate = "<%=businessDate%>";
		if(transCode=="9090"){
			transDate = PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth=20;dialogheight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(transDate)=="undefined" || transDate.length==0) return;
		}
		var returnValue = PopPage("/Accounting/LoanSimulation/CreateTransaction.jsp?TransDate="+transDate+"&TransCode="+transCode,"","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		returnValue=returnValue.split("@");
		if(returnValue[0]=="true"){
			OpenComp("ACCT_LoanSimulationTransInfo","/Accounting/LoanSimulation/TransactionInfo.jsp","SerialNo="+returnValue[1],"_blank",OpenStyle);
			reloadSelf();
		}
	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransDate="+transDate+"&TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("����ִ�гɹ���");
		reloadSelf();
	}
	
	function runTransaction1(transSerialNo){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransactionSerialNo="+transSerialNo,"","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("����ִ�гɹ���");
		reloadSelf();
	}
	
	// ����
	function runTransaction(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var status = getItemValue(0,getRow(),"TransStatus");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(status!="0"){
			alert("����״̬����ȷ����ѡ��δ���˵Ľ��ף�");
			return;
		}
		runTransaction1(serialNo);
	}

	//����
	function viewTransaction(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenComp("ACCT_LoanSimulationTransInfo","/Accounting/LoanSimulation/TransactionInfo.jsp","SerialNo="+serialNo,"_blank",OpenStyle);
	}

	function deleteTransaction(){
		var status = getItemValue(0,getRow(),"TransStatus");
		if (typeof(status) == "undefined" || status.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (status!="0"){
			alert("���ײ���δ����״̬��������ɾ����");
			return;
		}
		deleteBusinessObjectFromSession('<%=BUSINESSOBJECT_CONSTATNTS.transaction%>','SerialNo');
	}

	// ����
	function reverseTransaction(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var status = getItemValue(0,getRow(),"TransStatus");
		if(status!="1"){
			alert("��ѡ����Ч�Ľ��׽��г��ʣ�");
			return;
		}
		var value = PopPage("/CreditManage/CreditConsult/SetoffTransaction.jsp?SerialNo="+serialNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:yes;status:no;statusbar:no");
		if(value=="true"){ 
			alert("���ʳɹ���");
			reloadSelf();
		}
		else  alert("����ʧ�ܣ�");
	}

	
	function printDocument(){
		alert("���п������ܣ��粻��Ҫ�����Σ�");
	}
</script>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/businessobject.js"> </script>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	<%
		out.print(DWExtendedFunctions.setDataWindowValues(loan,loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.transaction), dwTemp,Sqlca) );
	%>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>