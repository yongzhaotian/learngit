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
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("�������뻹���˺�!");
		return false;
	}
	
	return true;
}

/*~[Describe=��ʼ��;InputParam=��;OutPutParam=��;]~*/
function initRow(){
	
	if (getRowCount(0)==0) {
		as_add("myiframe0");//������¼
	}
	
	var sNormalBalance =getItemValue(0,getRow(),"NormalBalance");
	setItemValue(0,getRow(),"ActualPayAmt",sNormalBalance);
	setItemValue(0,getRow(),"PrePayPrincipalAmt",sNormalBalance);
	setItemValue(0,getRow(),"PayAmt",sNormalBalance);
	
	setItemValue(0,getRow(),"payinteamt",0);
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
	setValue("TransDate",businessDate);
	setItemValue(0,getRow(),"PrePayType","10");
	setItemValue(0,getRow(),"PrepayInterestDaysFlag","02");
	setItemValue(0,getRow(),"PrepayInterestBaseFlag","02");
	setItemValue(0,getRow(),"PrePayAmountFlag","1");
	changeCashOnlineFlag();
}

