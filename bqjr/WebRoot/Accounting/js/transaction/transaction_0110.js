var nLessZ = "����С�ڵ���0";
var MoreZ = "�������0";
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var MayquitAmt = getItemValue(0,getRow(),"MayquitAmt");
	if(actualPayAmt<=0){
		alert("�˿���"+nLessZ);
		setItemValue(0,getRow(),"ActualPayAmt",0);
		return false;
	}
	
	if(actualPayAmt>MayquitAmt){
		alert("�˿���ܴ��ڿ��˽��");
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

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	return;
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
	setItemValue(0,getRow(),"InputTime","");
	setItemValue(0,getRow(),"TransDate","");
	setItemValue(0,getRow(),"UPDATEUSERID",curUserID);
	setItemValue(0,getRow(),"UPDATEUSERNAME",curUserName);
	setItemValue(0,getRow(),"UPDATEORGID",curOrgID);
	setItemValue(0,getRow(),"UPDATEORGNAME",curOrgName);
	setItemValue(0,getRow(),"UPDATEDATE",businessDate);
	setItemValue(0,getRow(),"PayPrincipalAmt",payPrincipalAmt);
	setItemValue(0,getRow(),"PayInteAmt",payInteAmt);
	changeCashOnlineFlag();
}


/*~[Describe=���˽��;InputParam=��;OutPutParam=��;]~*/
function ReturnAmount(){
	var sTransSerialNo = getItemValue(0,getRow(),"TransSerialNo");
	var sSerialno = getItemValue(0,getRow(),"ObjectNo");
	var sInputTime = getItemValue(0,getRow(),"TransDate");
	var sNextDueDate = getItemValue(0,getRow(),"NextDueDate");
	if(typeof(sInputTime) == "undefined" || sInputTime.length == 0){
		alert("��ѡ�������˿�����");
		return;
	}
	
	var sParaString=sTransSerialNo+","+sSerialno+","+sInputTime+","+sNextDueDate;
	var sReturn=RunMethod("BusinessManage","SelectReturnAmount",sParaString);
	var str=sReturn.split(",");
	
	setItemValue(0,getRow(),"MayquitAmt",str[0]);
	setItemValue(0,getRow(),"NextPayTotalAmt",str[1]);
	setItemValue(0,getRow(),"ActualPayTotalAmt",str[2]);
	setItemValue(0,getRow(),"PayTotalAmt",str[3]);
}
