<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����Ŵ�����
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 �ؼ�ҳ�� 
		zywei 2007/10/10 �޸�ȡ�����ʵ���ʾ��
		djia  2009/08/13 ����AmarOTI --> putOut()/putOff()
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/ApplyList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�����Ŵ�����;InputParam=��;OutPutParam=��;]~*/
	function newApply()
	{
		//���ú�ͬ����
		sObjectType = "BusinessContract";		
		//�����ʵĺ�ͬ��Ϣ
		sParaString = "ManageUserID"+","+"<%=CurUser.getUserID()%>"+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		sReturn = setObjectValue("SelectContractOfPutOut",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//��ͬ��ˮ��
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sBusinessType = sReturn[1];
		sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sObjectNo);
		if(parseFloat(sSurplusPutOutSum) <= 0) //�����ͬû�п��ý�����ֹ��������
		{	
			alert(getBusinessMessage('573'));//��ҵ���ͬ��û�п��ý����ܽ��зŴ����룡
			return;
		}
		//��ҵ��Ʒ��Ϊ����ҵ��ʱ����Ҫ�����Ƿ���Ʊ�ݡ�
		if(sBusinessType =="1020010" || sBusinessType == "1020020" || sBusinessType == "1020030"){
			sReturn = RunMethod("BusinessManage","CheckBillInfo",sObjectNo+","+sBusinessType);
			if(sReturn == "00"){
				alert("û��¼����ص�Ʊ����Ϣ����¼����ٽ��г������룡");
				return;
			}
		}
		
		//���з�������̽��
		sReturn=RunMethod("BusinessManage","CheckContractRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != ""){
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
			//return;  //�á�return���Ƿ���Ч�Ӿ���ҵ���������
		}
		
		//�������ҵ����Ҫ����Ʊ����ʱ������Ŀ�����б�дѡ��Ʊ�ݵ��б�����ѡ��Ļ�Ʊ��Ÿ���sBillNo
		//��Ʒԭ�����ǽ������ֺ�ͬ���µ�Ʊ��һ���Գ���
		var sBillNo="";
				
		//��ʼ���Ŵ�����,���س�����ˮ��
		sReturn = RunMethod("WorkFlowEngine","InitializePutOut","<%=sObjectType%>,"+sObjectNo+","+sBusinessType+","+sBillNo+",<%=CurUser.getUserID()%>,<%=sApplyType%>,<%=sInitFlowNo%>,<%=sInitPhaseNo%>,<%=CurUser.getOrgID()%>");
		if(typeof(sReturn) == "undefined" || sReturn == "") return;

		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=PutOutApply&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
			
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
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

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sPhaseNo != "0010" && sPhaseNo != "3000") {
			sParamString += "&ViewID=002";
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		//��ó������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");	
		var sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");	
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��");//�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
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
		isBizSort = RunMethod("BusinessManage","GetBizSort",sBusinessType);
		sUserID = getItemValue(0,getRow(),"InputUserID");
		sReturn = autoRiskScan("003","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sTaskNo+"&BusinessType="+sBusinessType+"&ContractSerialNo="+sContractSerialNo+"&IsBizSort="+isBizSort+"&BusinessSum="+sBusinessSum+"&BusinessCurrency="+sBusinessCurrency+"&UserID="+sUserID);
		if(sReturn != true){
			return;
		}
		
		//���������ύѡ�񴰿�		
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&oldPhaseNo="+sPhaseNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){
			//ͬһ�û��ڲ�ͬ�����ϵ�½�󣬶�ͬһ��ҵ��ͬʱ�ύ����һ�׶�ʱ�����ܻ����������� 
			alert("�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��");//�����У�
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	
	//ǩ�����
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
		sCompID = "SignTaskOpinion";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe=ת�����;InputParam=��;OutPutParam=��;]~*/
	function transToAfterLoan(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(!confirm("ȷ��ת�������")){
			return;
		}
		
		sReturn = RunMethod("WorkFlowEngine","TransToAfterLoan",sObjectType+","+sObjectNo);
		if(parseInt(sReturn) == 1){
			reloadSelf();
		}else{
			alert("ת�����ʧ�ܣ�");
		}
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//��ó������͡�������ˮ�š����̱�š��׶α��
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

	/*~[Describe=�鵵;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		//��ó������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('56'))){ //������뽫����Ϣ�鵵��
			//�鵵����
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getHtmlMessage('60'));//�鵵ʧ�ܣ�
				return;			
			}else{
				reloadSelf();	
				alert(getHtmlMessage('57'));//�鵵�ɹ���
			}			
		}
	}

	/*~[Describe=ȡ���鵵;InputParam=��;OutPutParam=��;]~*/
	function cancelarch(){
		//��ó������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //������뽫����Ϣ�鵵ȡ����
			//ȡ���鵵����
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
			}
		}
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
		var sPhaseNo = "<%=sInitPhaseNo%>";	
		//��ȡ������ˮ��
		var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
			if(confirm(getBusinessMessage('498'))){ //ȷ���ջظñ�ҵ����
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else{
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}				
	}
	
	/*~[Describe=��ӡ����֪ͨ��;InputParam=��;OutPutParam=��;]~*/
	function print(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?DocID="+sExchangeType+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	
	/*~[Describe=���ͷſ���Ϣ������;InputParam=��;OutPutParam=��;]~*/
	function putOut(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sOperateType = "10";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = PopPageAjax("/Common/WorkFlow/PutOutAjax.jsp?SerialNo="+sSerialno+"&BusinessType="+sBusinessType+"&OperateType="+sOperateType,"","");
		if(typeof(sReturn) != "undefined"){
			sReturn=sReturn.split("@");
	        sStatus=sReturn[0];
	        sTradeNo=sReturn[1];
	        sMessage=sReturn[2];
	    	if(sStatus == "0"){
	    		sReturn = "�����ɹ������״��룺"+sTradeNo;
	    	}else{
	    		sReturn = "������ʾ��"+sTradeNo+"����ʧ�ܣ�ʧ����Ϣ��"+sMessage;
	    	}
	    	alert(sReturn);
        }
	}
	
	/*~[Describe=���ͳ�����Ϣ������;InputParam=��;OutPutParam=��;]~*/
	function putOff(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sOperateType = "20";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sReturn = PopPageAjax("/Common/WorkFlow/PutOutAjax.jsp?SerialNo="+sSerialno+"&BusinessType="+sBusinessType+"&OperateType="+sOperateType,"","");
		if(typeof(sReturn) != "undefined"){
			sReturn=sReturn.split("@");
	        sStatus=sReturn[0];
	        sTradeNo=sReturn[1];
	        sMessage=sReturn[2];
	    	if(sStatus == "0"){
	    		sReturn = "�����ɹ������״��룺"+sTradeNo;
	    	}else{
	    		sReturn = "������ʾ��"+sTradeNo+"����ʧ�ܣ�ʧ����Ϣ��"+sMessage;
	    	}
	    	alert(sReturn);
        }
	}

	/*~[Describe=����֧����Ϣ������;InputParam=��;OutPutParam=��;]~*/
	function sendPayment(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sOperateType = "30";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sReturn = PopPageAjax("/Common/WorkFlow/PutOutAjax.jsp?SerialNo="+sSerialno+"&BusinessType="+sBusinessType+"&OperateType="+sOperateType,"","");
		if(typeof(sReturn) != "undefined"){
			sReturn=sReturn.split("@");
	        sStatus=sReturn[0];
	        sTradeNo=sReturn[1];
	        sMessage=sReturn[2];
	    	if(sStatus == "0"){
	    		sReturn = "�����ɹ������״��룺"+sTradeNo;
	    	}else{
	    		sReturn = "������ʾ��"+sTradeNo+"����ʧ�ܣ�ʧ����Ϣ��"+sMessage;
	    	}
	    	alert(sReturn);
        }
	}
	
	/*******************�������Ӵ���***********/
	
	/*~[Describe=������ȡ;InputParam=��;OutPutParam=��;]~*/
	function recieveFee(){
		FeeTransaction('3508');
	}
	
	/*~[Describe=����֧��;InputParam=��;OutPutParam=��;]~*/
	function payFee(){
		FeeTransaction('3520');
	}
	
	/*~[Describe=���ý���;InputParam=��;OutPutParam=��;]~*/
	function FeeTransaction(transCode){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sBPObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.business_putout%>";
		var sBCObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(transCode == "3508")
			sParaString = "SerialNo,"+sObjectNo+",FeeFlag,R";
		else
			sParaString = "SerialNo,"+sObjectNo+",FeeFlag,P";
		sReturn = setObjectValue("SelectAcctFee",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_CLEAR_")
		{
			return;
		}
		var feeSerialNo = sReturn.split("@")[0];
		if(typeof(feeSerialNo) == "undefined" || feeSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transactionSerialNo = RunMethod("LoanAccount","CheckExistsTransaction","<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+","+transCode+"");
		if(typeof(transactionSerialNo)=="undefined" || transactionSerialNo.length==0||transactionSerialNo=="Null") {
			//��������Ҫ���̵Ľ���
			var returnValue = RunMethod("LoanAccount","CreateTransaction",","+transCode+",<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+",,<%=CurUser.getUserID()%>,2");
			returnValue = returnValue.split("@");
			transactionSerialNo = returnValue[1];
			if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
				alert("��������{"+transCode+"}ʱʧ�ܣ�����ԭ��Ϊ��"+returnValue);
				return;
			}
		}
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&ViewID=000";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		if(confirm("��ȷ���Ƿ�������˴���"))
		{
			var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("ϵͳ�����쳣��");
				return;
			}
			var message=returnValue.split("@")[1];
			alert(message);
			reloadSelf();
		}
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function KeepAccounts(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sSerialno = getItemValue(0,getRow(),"SerialNo");
		var productID = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sReturn = RunMethod("LoanAccount","RunTransaction3",productID+",,TRA001,<%=BUSINESSOBJECT_CONSTATNTS.business_putout%>,"+sObjectNo+",<%=CurUser.getUserID()%>,");
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("ϵͳ�����쳣��");
			return;
		}
		alert(sReturn.split("@")[1]);
		reloadSelf();
	}
	/*******************�������Ӵ���***********/
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>