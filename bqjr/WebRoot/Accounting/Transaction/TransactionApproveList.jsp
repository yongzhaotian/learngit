<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: ��ҳ����Ҫ����ҵ����ص���������б�
		Input Param:
		Output param:
		History Log: 
			2005.08.03 jbye    �����޸�������������Ϣ
			2005.08.05 zywei   �ؼ�ҳ��
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	
/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
function viewTask(){
	//����������͡�������ˮ��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	var transactionCode = "<%=transactionFilter%>";
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("������������");
			return;
		}
		if(sFlowState=="1"){
			alert("�������ѱ�����,��ѡ����������");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("������������");
				return;
			}
		}
	}
	
	if(transactionCode=="@0090@" || transactionCode=="@3530@"){
		sCompID = "CreditTab";
		sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo;
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
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	
	if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
		as_del("myiframe0");
		as_save("myiframe0");  //�������ɾ������Ҫ���ô����
	}
}

/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
function backStep(){
	//��ȡ������ˮ��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("������������");
			return;
		}
		if(sFlowState=="1"){
			alert("�������ѱ�����,��ѡ����������");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("������������");
				return;
			}
		}
	}	
	if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������
	//����Ƿ�ǩ�����
	var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
	if(typeof(sReturn)=="undefined" || sReturn.length==0){
		//�˻��������   	
		var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//����ɹ�����ˢ��ҳ��
		if(sRetValue == "Commit"){
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			alert("�˻سɹ�!");
			reloadSelf();
		}else{
			alert(sRetValue);
		}
	}else{
		alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
		return;
	}
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
	var sReturn = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>");
	if(sReturn=="true"){
		alert("����ִ�гɹ���");
		reloadSelf();
	}
	else{
		alert("����ִ��ʧ�ܣ�����ԭ��"+sReturn);
	}
}

/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
function doSubmit(){
	//add by hwang,������ȡ����sApplyType1��������
	//����������͡�������ˮ�š����̱�š��׶α�š���������
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sApproveType1 = "<%=sApproveType%>";
	var sOccurType=getItemValue(0,getRow(),"OccurType");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("������������");
			return;
		}
		if(sFlowState=="1"){
			alert("�������ѱ�����,��ѡ����������");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("������������");
				return;
			}
		}
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
	
	<%-- var sReturn = autoRiskScan("017","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApproveType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo);
	if(sReturn != true){
		return;
	} --%>
	var sSignOpinion = RunMethod("���÷���", "GetColValue", "FLOW_OPINION,PHASEOPINION,serialno=(SELECT max(serialno) FROM FLOW_TASK WHERE OBJECTNO='"+sObjectNo+"')");
	
	if (sSignOpinion == "Null") {
		alert("����ǩ��������ύ��");
		return;
	}

	//���������ύѡ�񴰿�		
	var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	// !LoanAccount.RunTransaction2(#ObjectNo,#UserID,N)
	if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
		var sLastPhaseNo = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,PHASENO,FLOWNO='TransFeeFlow' AND OBJECTTYPE='TransactionApply' AND OBJECTNO='"+sObjectNo+"'");
		if (sLastPhaseNo == "1000") {
			RunMethod("LoanAccount", "RunTransaction2", sObjectNo+",<%=CurUser.getUserID()%>,N");
		}
		if (sLastPhaseNo == "8000") {
			RunMethod("���÷���", "UpdateColValue", "ACCT_TRANSACTION,TRANSSTATUS,4,serialno='"+sObjectNo+"'");
		}
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
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("������������");
			return;
		}
		if(sFlowState=="1"){
			alert("�������ѱ�����,��ѡ����������");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("������������");
				return;
			}
		}
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
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);	
	var sEndTime=getItemValue(0,getRow(),"EndTime");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(sEndTime==""){
		if(sFlowState==""){
			alert("������������");
			return;
		}
		if(sFlowState=="1"){
			alert("�������ѱ�����,��ѡ����������");
			return;
		}
		if(sFlowState=="2"){
			var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
			if(islock=="false"){
				alert("������������");
				return;
			}
		}
	}
	//popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID=001","");
	//popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
function lock(){
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");

//	var sFlowState=getItemValue(0,getRow(),"FlowState");
	//���������ˮ��
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
		return;
	}
	if(sFlowState=="1"){
		LockUser = RunMethod("WorkFlowEngine","LockUser",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		alert("�������ѱ�-"+LockUser+"-����,���ܶԸÿͻ�����ҵ�������ѡ����������");
		//alert("�������ѱ�����,��ѡ����������");
		return;
	}
	if(sFlowState=="2"){
		var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if(islock=="true"){
			alert("�������ѱ�����,�����ظ�������");
			return;
		}
	}
	//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
	var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
	if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
		alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
		reloadSelf();
		return;
	}
	var lock=RunMethod("WorkFlowEngine","LockOrUnLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>"+",1");
	if(lock=="SUCCESS"){
		alert("���������ɹ���");
	}
//	reloadSelf();

}

function unlock(){
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	
//	var sFlowState=getItemValue(0,getRow(),"FlowState");
	
	//���������ˮ��
	var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
	var sFlowState= RunMethod("WorkFlowEngine","GetFlowState",sSerialNo);
	
	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
		return;
	}
	if(sFlowState==""){
		alert("������������");
		return;
	}
	if(sFlowState=="1"){
		LockUser = RunMethod("WorkFlowEngine","LockUser",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		//alert("�������ѱ�-"+LockUser+"-����,���ܶԸÿͻ�����ҵ�������ѡ����������");
		alert("�������ѱ�-"+LockUser+"-����,��ѡ����������");
		return;
	}
	if(sFlowState=="2"){
		var islock=RunMethod("WorkFlowEngine","IsLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if(islock=="false"){
			alert("�������ڽ���״̬�������ظ�������");
			return;
		}
	}
	//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
	var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
	if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
		alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
		reloadSelf();
		return;
	}
	//ObjectType = 'CreditApply' and ObjectNo= '2013073000000080' and FlowNo = 'PerRetCenFlow' and PhaseNo = '0020' and UserID <> 'test13' and (EndTime is null or EndTime = '')
	var lock=RunMethod("WorkFlowEngine","LockOrUnLock",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>" + ",2");
	if (lock == "SUCCESS") {
		alert("��������ɹ���");
	}
//	reloadSelf();
}

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
