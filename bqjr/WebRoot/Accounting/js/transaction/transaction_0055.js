var aheadPaymentCalcFlag = true;//�����Ƿ���Ҫ������ǰ�������
var aheadPaymentScheFlag = false;//�����Ƿ���Ҫ������л���ƻ�����
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var PrePayType = getItemValue(0,getRow(),"PrePayType");
	if(actualPayAmt<=0 && PrePayType != "10"){//����ȫ����ǰ����
		alert("�����ܽ���С�ڵ���0");
		setItemValue(0,getRow(),"ActualPayAmt",0);
		return false;
	}
	//У���˺ű���
	/*var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("�������뻹���˺�!");
		return false;
	}*/
	
	return true;
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function openFeeList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null || obj.style.display=="none") return;
	OpenComp("TransactionFeeList","/Accounting/Transaction/TransactionFeeList.jsp","ToInheritObj=y&ParentTransSerialNo="+transactionSerialNo,"NEWFEEPart","");
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	if(aheadPaymentCalcFlag)
	{
		var apcs=popComp("AheadPaymentConsult","/Accounting/Transaction/AheadPaymentConsult.jsp","TransactionSerialNo="+transactionSerialNo,"dialogWidth=50;dialogHeight=30;");
		if(typeof(apcs) != "undefined" && apcs.length != 0)
		{
			var payAmt = apcs.split("@")[0];
			var prePayPrincipalAmt = apcs.split("@")[1];
			var prePayInteAmt = apcs.split("@")[2];
			setItemValue(0,0,"PayAmt",payAmt);
			setItemValue(0,0,"PrePayPrincipalAmt",prePayPrincipalAmt);
			setItemValue(0,0,"PrePayInteAmt",prePayInteAmt);
		}
	}
	
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","ToInheritObj=y&TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	/*changePrepayType();*/
	openFeeList();
}

/*~[Describe=������ǰ������ѯ;InputParam=�����¼�;OutPutParam=��;]~*/
function repayConsult(){
	var sActualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var sPayAmt = getItemValue(0,getRow(),"PayAmt");
	/*
	if(sActualPayAmt>sPayAmt){
		alert("��������С�ڻ����ܽ��");
		return;
	}*/
	var sTransStatus = getItemValue(0,getRow(),"TransStatus");
	if(typeof(sTransStatus)=="undefined"||sTransStatus.length==0 || sTransStatus !="0"){
		alert("�˱ʽ���״̬���Ǵ��ύ,����������!");
		return;
	}
	aheadPaymentCalcFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=����ƻ�����;InputParam=��;OutPutParam=��;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=��ʼ��;InputParam=��;OutPutParam=��;]~*/
function initRow(){
	if (getRowCount(0)==0) {
		as_add("myiframe0");//������¼
	}
	setItemValue(0,getRow(),"INPUTUSERID",curUserID);
	setItemValue(0,getRow(),"INPUTUSERNAME",curUserName);
	setItemValue(0,getRow(),"INPUTORGID",curOrgID);
	setItemValue(0,getRow(),"INPUTORGNAME",curOrgName);
	setItemValue(0,getRow(),"INPUTDATE",businessDate);
	setItemValue(0,getRow(),"UPDATEUSERID",curUserID);
	setItemValue(0,getRow(),"UPDATEUSERNAME",curUserName);
	setItemValue(0,getRow(),"UPDATEORGID",curOrgID);
	setItemValue(0,getRow(),"UPDATEORGNAME",curOrgName);
	setItemValue(0,getRow(),"UPDATEDATE",businessDate);
	setItemValue(0,getRow(),"PayPrincipalAmt",payPrincipalAmt);
	setItemValue(0,getRow(),"PayInteAmt",payInteAmt);
	setItemValue(0,getRow(),"PayAccountFlag",2);
	
	//setValue("TransDate",businessDate);
	setItemValue(0,getRow(),"TransDate",sPayDate);
	setItemValue(0,getRow(),"PrePayType","10");
	setItemValue(0,getRow(),"PrepayInterestDaysFlag","02");
	setItemValue(0,getRow(),"PrepayInterestBaseFlag","02");
	setItemValue(0,getRow(),"PrePayAmountFlag","2");
	
	var sTransDate = getItemValue(0,getRow(),"TransDate");
	var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
	
	var sParaString=sTransDate+","+sLoanSerialNo+","+sScheduleDate;
	var sReturn=RunMethod("BusinessManage","SelectPrepaymentAmount",sParaString);
	var str=sReturn.split(",");
	
	setItemValue(0,getRow(),"PayPrincipalAmt",str[0]);
	setItemValue(0,getRow(),"PayInteAmt",str[1]);
	setItemValue(0,getRow(),"PrePayPrincipalAmt",str[0]);
	setItemValue(0,getRow(),"PrePayInteAmt",str[1]);
	setItemValue(0,getRow(),"PayInsuranceFee",str[2]);
	setItemValue(0,getRow(),"PrepaymentFee",str[3]);
	setItemValue(0,getRow(),"CustomerServeFee",str[4]);
	setItemValue(0,getRow(),"AccountManageFee",str[5]);
	setItemValue(0,getRow(),"StampTax",str[6]);
	setItemValue(0,getRow(),"PayAmt",str[7]);
	
	var sFlag=str[8];
	if(sFlag == "true") setItemValue(0,getRow(),"PrepayInterestDaysFlag","04");
	
	
	/*changePrepayType();*/
	openFeeList();
	changeCashOnlineFlag();
/*	ImportAccount("01","PayAccountFlag","PayAccountType","PayAccountCurrency","PayAccountNo","PayAccountName","PayAccountOrgID");
*/}

/*~[Describe=������ǰ���ʽ��ͬ�������¼�;InputParam=�����¼�;OutPutParam=��;]~*/
/*function changePrepayType(){
	var dNormalBalance = getItemValue(0,getRow(),"NormalBalance");
	var dOverdueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var sPrePayType = getItemValue(0,0,"PrePayType");
	if(typeof(sPrePayType)=="undefined" || sPrePayType.length==0){
		return;
	}
	if(sPrePayType == "10"){
		setItemValue(0,0,"PrePayAmountFlag","1");
		setItemDisabled(0,0,"PrePayAmountFlag",true);
		setItemValue(0,0,"ActualPayAmt",parseFloat(dNormalBalance)+parseFloat(dOverdueBalance));
		setItemDisabled(0,0,"ActualPayAmt",true);
		setItemValue(0,0,"PrepayInterestBaseFlag","02");
		setItemDisabled(0,0,"PrepayInterestBaseFlag",true);
	}else{
		var sPrepayInterestDaysFlag = getItemValue(0,0,"PrepayInterestDaysFlag");
		if(typeof(sPrepayInterestDaysFlag)=="undefined" || sPrepayInterestDaysFlag.length==0){
			return;
		}
		setItemDisabled(0,0,"PrePayAmountFlag",false);
		setItemDisabled(0,0,"ActualPayAmt",false);
		setItemDisabled(0,0,"PrepayInterestBaseFlag",false);
		setItemDisabled(0,0,"PrepayInterestDaysFlag",false);
		if(sPrepayInterestDaysFlag=="03"){
			setItemValue(0,0,"PrepayInterestBaseFlag","02");
			setItemDisabled(0,0,"PrepayInterestBaseFlag",true);
		}
		else{
			setItemDisabled(0,0,"PrepayInterestBaseFlag",false);
		} 
	}
	
}*/