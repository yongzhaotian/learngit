<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.accounting.config.loader.*" %>

	<%
	String PG_TITLE = "���㽻�׶����б�"; // ��������ڱ��� <title> PG_TITLE </title>

	
	%> 
	<%@include file="/Common/WorkFlow/ApplyList.jsp"%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	<script language=javascript>

	/*~[Describe=������������;InputParam=��;OutPutParam=��;]~*/
	
	var tempTransCode = "";
	function createTask(){
		var transactionDate="";
		<%
		if(transactionFilter.indexOf("@")<0&&transactionFilter.trim().length()>0&&!transactionFilter.equalsIgnoreCase("All"))
		{
		%>
			var transactionCode = "<%=transactionFilter%>";
			var transObjectSelector = "<%=TransactionConfig.getTransactionDef(transactionFilter).getString("ObjectSelector")%>";
		<%
		}
		else{
		%>
			if("<%=transactionFilter%>"=="3530"){
				var transactionCode ="<%=transactionFilter%>";
				tempTransCode = transactionCode;
			}else{
				var paraString = "TransactionFilter,<%=transactionFilter%>,UserID,<%=CurUser.getUserID()%>";
				var returnValue = setObjectValue("SelectTransactionCode",paraString,"",0,0,"");
				if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
				{
					return;
				}
				returnValue = returnValue.split("@");
				var transactionCode = returnValue[0];
				tempTransCode = transactionCode;
			}
			
		<%
		}
		%>
		
		
		var relativeObjectType = "";
		var relativeObjectNo = "";
			
		var transObjectSelector = RunMethod("PublicMethod","GetColValue","Attribute5,CODE_LIBRARY,String@CodeNo@T_Transaction_Def@String@ItemNo@"+transactionCode);

		if(typeof(transObjectSelector) == "undefined" || transObjectSelector.length == 0){
			relativeObjectType = "";
			relativeObjectNo = "";
			return;
		}
		else{
			try{
				var returnValue = eval(transObjectSelector.split("@")[1]);
				if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_"){
					return;
				}
				relativeObjectType = returnValue.split("@")[0];
				relativeObjectNo = returnValue.split("@")[1];
			}
			catch(e){
				//alert("����{"+transactionCode+"}����Ķ���ѡ��������ʧ�ܣ�����Code_Library��Attribute5!");
				return;
			}
		}
		//CCS-953 ��ǰ����˻������ü����໥�ж��Ƿ��н��׽�����
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+relativeObjectNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			return;
		}//CCS-953 END
		var objectType="<%=sApplyType%>";
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
		if(returnValue.substring(0,5) != "true@") {
			alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
			return;
		}
		returnValue = returnValue.split("@");
		var transactionSerialNo = returnValue[1];
		if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
			alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
			return;
		}
			
		 if(transactionCode=="0090" || transactionCode=="2012" || transactionCode=="0110" || transactionCode=="2011" || transactionCode=="3530" || transactionCode=="0052" ){
			 var sContractSerialNo = "";
			 if(transactionCode=="3530"){
				 var sLoanSerialNo = RunMethod("���÷���", "GetColValue", "acct_fee,objectno,serialno='"+relativeObjectNo+"'");
				sContractSerialNo = RunMethod("���÷���", "GetColValue", "acct_loan,putoutno,serialno='"+sLoanSerialNo+"'");//ͨ��������ˮ��ȡ��ͬ����
			 }else{
				sContractSerialNo = RunMethod("���÷���", "GetColValue", "acct_loan,putoutno,serialno='"+relativeObjectNo+"'");//ͨ����ݻ�ȡ��ͬ����
			 }
			 sCompID = "CreditTab";
			sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&Flag=010&ContractSerialNo="+sContractSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else{ 
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
		
	}

	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTask(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sTransCode = getItemValue(0,getRow(),"TransCode");
		var BCSerialno = getItemValue(0,getRow(),"BCSerialno");
		var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		 if(sTransCode=="0090" || sTransCode=="2012" || sTransCode=="0110" || sTransCode=="3530" || sTransCode=="2011" || sTransCode=="0052"){
			 if(sTransCode!="3530"){
				 BCSerialno =  RunMethod("���÷���", "GetColValue", "acct_loan,putoutno,serialno='"+sLoanSerialNo+"'");
			 }
			 sCompID = "CreditTab";
			sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo+"&ContractSerialNo="+BCSerialno+"&Flag=<%=sPhaseType%>";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else{ 
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
	}

	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		var sTransCode = getItemValue(0,getRow(),"TransCode");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		
		if(sTransCode=="3530"){
			RunMethod("BusinessManage","DeleteFeeWaiveApply",sObjectNo);
		}
		reloadSelf();//����������ȡ��ʱ����
	}
	
	//����ִ��
	function runTransaction(){
		var transactionSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(transactionSerialNo)=="undefined"||transactionSerialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var sTransStatus = getItemValue(0,getRow(),"TransStatus");
		if(sTransStatus =="1"){
			alert("�Ѿ����˳ɹ�!");
			return;
		}
		var sReturn = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("ϵͳ�����쳣��");
			return;
		}
		alert(sReturn.split("@")[1]);
		reloadSelf();
	}
	
	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		//add by hwang,������ȡ����sApplyType1��������
		//����������͡�������ˮ�š����̱�š��׶α�š���������
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		var sTransCode = getItemValue(0,getRow(),"TransCode");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);		
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}

		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		} 
		
		//���з�������̽��
		
		<%-- var sReturn = autoRiskScan("017","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo+"&TransCode="+sTransCode);
		if(sReturn != true){
			return;
		} --%>

		if (sFlowNo == "TransactionFlow" && sApplyType1=="TransactionApply") {	// ��Ϣ����У��
			var sPsSerialNo = RunMethod("���÷���", "GetColValue", "ACCT_PAYMENT_LOG,PSSERIALNO, SERIALNO IN(SELECT DOCUMENTSERIALNO FROM ACCT_TRANSACTION WHERE SERIALNO='"+sObjectNo+"' AND RELATIVEOBJECTTYPE='jbo.app.ACCT_LOAN' AND DOCUMENTTYPE='jbo.app.ACCT_PAYMENT_LOG')");
			if (sPsSerialNo=="Null" || sPsSerialNo.length==0) {
				alert("��ѡ�񻹿�ƻ���ˮ��");
				return;
			}
		} else if (sFlowNo == "TransFeeFlow" && sApplyType1=="TransFeeApply") {	// ���ü���У��
			var sIsSave = RunMethod("���÷���", "GetColValue", "ACCT_FEE_LOG,SEQID,SERIALNO=(SELECT DOCUMENTSERIALNO FROM ACCT_TRANSACTION WHERE SERIALNO='"+sObjectNo+"')");
			//alert(sObjectNo+"|"+sSignOpinion+"|"+sIsSave+"|"+sIsSave.length+"|");
			
			if (sIsSave=="Null" || sIsSave.length==0) {
				alert("��δѡ�������Σ�");
				return;
			}
		}
		
		var sSignOpinion = RunMethod("���÷���", "GetColValue", "FLOW_OPINION,PHASEOPINION,serialno=(SELECT max(serialno) FROM FLOW_TASK WHERE OBJECTNO='"+sObjectNo+"')");
		
		if (sSignOpinion == "Null") {
			alert("����ǩ��������ύ��");
			return;
		}
		
		//���������ύѡ�񴰿�		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
	
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function signOpinion(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	//�ջ�
	function takeBack(){
		//���ջ��������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = RunMethod("WorkFlowEngine","GetInitPahseNo",sObjectType+","+sObjectNo);
		//��ȡ������ˮ��
		var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
			if(confirm(getBusinessMessage('498'))){ //ȷ���ջظñ�ҵ����
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				//�ջسɹ����ˢ��ҳ��
				if(sRetValue == "Commit"){
					reloadSelf();
				}
			}
		}else{
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}				
	}
	
	/*~[Describe=��ӡ���׵���;InputParam=��;OutPutParam=��;]~*/
	function printBill(){
		var transactionSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(transactionSerialNo)=="undefined"||transactionSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	 	var rtn = RunMethod("BusinessManage","GenerateEDoc","GeneralLedger,"+transactionSerialNo+",KJPZ_1,<%=CurOrg.getOrgID()%>");
	 	if(rtn=="true"){
			var sReturn = RunMethod("Insure","CheckPrintSerialNo",transactionSerialNo+",GeneralLedger,KJPZ_1");
			OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
	 	}else{
			alert("��ʽ���ĵ�����ʧ��");
	 	}
	}

	
	/*~[Describe=ѡ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function selectTransObject(objectType,selectorname)//ѡ�����
	{
		var s=setObjectValue(selectorname,"OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return objectType+"@"+serialNo;
	}

	function SelectFeeRecieve()//ѡ����ȡ����
	{
		var sTransCode = tempTransCode;
		tempTransCode = "";
		
		var s = setObjectValue("SelectFeeRecieve","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;
	}

	function SelectFeePay()//ѡ��֧������
	{
		var sTransCode = tempTransCode;
		tempTransCode = "";
		
		var s = setObjectValue("SelectFeePay","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;
	}

	function SelectWaiveFee()
	{
		var s=setObjectValue("SelectWaiveFee","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;

	}

	function SelectRefundFee()
	{
		var s=setObjectValue("SelectRefundFee","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.fee%>@"+serialNo;

	}
	
	function selectTransaction(TransCode)//ѡ��ԭ����
	{
		var s=setObjectValue("SelectStrikeTransaction","OrgID,<%=CurOrg.getOrgID()%>,TransCode,"+TransCode,"",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>@"+serialNo;

	}
	
	/*~[Describe=ѡ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function selectLoan_FineBea()//ѡ�����
	{
		var s=setObjectValue("SelectLoanFineBEA","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.loan%>@"+serialNo;
	}
	
	function selectBC(){
		var s=setObjectValue("SelectBelongContract","OrgID,<%=CurOrg.getOrgID()%>,UserID,<%=CurUser.getUserID()%>","",0,0,"");
		if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
		var serialNo = s.split('@')[0];
		return "<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>@"+serialNo;
	}

	//modify begin add by bhxiao 20120810
	//��֤��ӡ
	function print(){
		var sTransactionSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sTransactionSerialNo)=="undefined"||sTransactionSerialNo.length==0){
			return;
		}
		//		var sBatchpaymentflag = RunMethod("BusinessInspectManage","CheckBatchPaymentFlag",sTransactionSerialNo);
	//	if(sBatchpaymentflag == '1'||sBatchpaymentflag.length == 0||typeof(sBatchpaymentflag) =="undefined"){
	//		var sDocNo = "PFR-DOC3A";
	//	}else{
	//		sDocNo = "PFR-DOC3AX";
	//		}
	    var sParemater = RunMethod("LoanAccount","GetEdocNoByTransSerialNo",sTransactionSerialNo);
	   
		//var sParemater = "@10710@10720@";
		sParemater = "@"+sParemater+"@";
		var sDocNo = setObjectValue("SelectPrintList","SortNoList,"+sParemater,"",0,0,"");
		if(typeof(sDocNo)=="undefined"||sDocNo.length==0||"_CANCEL_"==sDocNo||"_CLEAR_"==sDocNo){
			return;
		}
		if(sDocNo.indexOf("@")>-1){
			sDocNo = sDocNo.split("@")[0];
		}
		
		sReturn = RunMethod("Insure","CheckPrintSerialNo",sTransactionSerialNo+",TransactionChange,"+sDocNo);
		if(sReturn!='Null'&&sReturn.length!=0){
			if(confirm("���ĵ��Ѿ���ӡ�Ƿ������ӡ��")){
				rtn = RunMethod("BusinessManage","GenerateEDoc","TransactionChange,"+sTransactionSerialNo+","+sDocNo+",<%=CurOrg.getOrgID()%>");
				if(rtn=="true"){
					sReturn = RunMethod("Insure","CheckPrintSerialNo",sTransactionSerialNo+",TransactionChange,"+sDocNo);
					OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
			 	}else{
					alert("��ʽ���ĵ�����ʧ��");
				}
		 	}else{
		 		OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
		 	}
		}else{
		 	rtn = RunMethod("BusinessManage","GenerateEDoc","TransactionChange,"+sTransactionSerialNo+","+sDocNo+",<%=CurOrg.getOrgID()%>");
		 	if(rtn=="true"){
				sReturn = RunMethod("Insure","CheckPrintSerialNo",sTransactionSerialNo+",TransactionChange,"+sDocNo);
				OpenComp("EDOCView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn,"_blank","");
		 	}else{
				alert("��ʽ���ĵ�����ʧ��");
			}
		}
	}

	//��ӡ����ƾ֤
	function printProof(){
		var DocumentSerialNo=getItemValue(0,getRow(),"DocumentSerialNo");
		var sDocumentType=getItemValue(0,getRow(),"DocumentType");
		if(sDocumentType!="jbo.app.ACCT_TRANS_PAYMENT"){
			alert("ֻ�н�������Ϊ����Ĳ��ܴ�ӡ����ƾ֤");
			return;
		}
		if (typeof(DocumentSerialNo)=="undefined" || DocumentSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			OpenComp("TransactionPrintProof","/Accounting/Transaction/TransactionPrintProof.jsp","DocumentSerialNo="+DocumentSerialNo,"_blank","");
		}
	}
	//��ӡ���ƾ֤
	function printAccounting(){
		var DocumentSerialNo=getItemValue(0,getRow(),"DocumentSerialNo");
		var sDocumentType=getItemValue(0,getRow(),"DocumentType");
		if (typeof(DocumentSerialNo)=="undefined" || DocumentSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		PopPage("/Accounting/PrintManage/PrintAccounting.jsp?DocumentType="+sDocumentType+"&TransSerialNo="+DocumentSerialNo,"","dialogWidth=730px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	//modify end
	
	</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>