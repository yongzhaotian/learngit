/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate != businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	if(actualPayAmt<=0){
		alert("�����ܽ��������0");
		setItemValue(0,getRow(),"ActualPayAmt","");
		return false;
	}
	//У���˺ű���
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("�������뻹���˺�!");
		return false;
	}
	/*var normalBalance = getItemValue(0,getRow(),"NormalBalance");
	var accrueInteBalance = getItemValue(0,getRow(),"AccrueInteBalance");
	var OverDueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var ODInteBalance = getItemValue(0,getRow(),"ODInteBalance");
	var FineInteBalance = getItemValue(0,getRow(),"FineInteBalance");
	var CompdInteBalance = getItemValue(0,getRow(),"CompdInteBalance");
	var ActualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var payAmt = parseFloat(normalBalance)+parseFloat(accrueInteBalance)+parseFloat(OverDueBalance)+parseFloat(ODInteBalance)+parseFloat(FineInteBalance)+parseFloat(CompdInteBalance);
	if(parseFloat(ActualPayAmt) > payAmt)
	{
		alert("�����ܽ��ܴ���Ӧ���ܽ�����������Ϣ����");
		setItemValue(0,getRow(),"ActualPayAmt","");
		return false;
	}*/
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	
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
	setItemValue(0,getRow(),"PayReasonCode","01");
	
	
	var sLoanSerialNo=getItemValue(0,getRow(),"LoanSerialNo");
	var sCreditAttribute = RunMethod("BusinessManage","getCreditAttribute",sLoanSerialNo);
	if(sCreditAttribute=="0002"){
		setItemValue(0,getRow(),"SeqFlag","10");
	}else{	
		setItemValue(0,getRow(),"SeqFlag","11");
	}
	
	setValue("TransDate",businessDate);
	afterSave();
	changeCashOnlineFlag();
}