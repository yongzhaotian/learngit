var nLessZ = "����С�ڵ���0";
var MoreZ = "�������0";
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	if(actualPayAmt<=0){
		alert("�����ܽ��"+nLessZ);
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
	setValue("TransDate",businessDate);
	afterSave();
	changeCashOnlineFlag();
}

/*~[Describe=���㻹���ܽ��;InputParam=�����¼�;OutPutParam=��;]~*/
function changeActualPayAmt(){
	var PayPrincipalAmt = getItemValue(0,getRow(),"PayPrincipalAmt");
	var PayInteAmt = getItemValue(0,getRow(),"PayInteAmt");
	var OverDueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var ODInteBalance = getItemValue(0,getRow(),"ODInteBalance");
	var FineInteBalance = getItemValue(0,getRow(),"FineInteBalance");
	var CompdInteBalance = getItemValue(0,getRow(),"CompdInteBalance");
	
	var ActualPayPrincipalAmt = getItemValue(0,getRow(),"ActualPayPrincipalAmt");
	var ActualPayInteAmt = getItemValue(0,getRow(),"ActualPayInteAmt");
	var ActualPayODPrincipalAmt = getItemValue(0,getRow(),"ActualPayODPrincipalAmt");
	var ActualPayODInteAmt = getItemValue(0,getRow(),"ActualPayODInteAmt");
	var ActualPayFineAmt = getItemValue(0,getRow(),"ActualPayFineAmt");
	var ActualPayCompdInteAmt = getItemValue(0,getRow(),"ActualPayCompdInteAmt");
	
	var temp = "���ܳ���";
	if(ActualPayPrincipalAmt>PayPrincipalAmt){
		alert("ʵ�յ��ڱ���"+temp+"���ڱ���");
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(ActualPayInteAmt>PayInteAmt){
		alert("ʵ�յ�����Ϣ"+temp+"������Ϣ");
		setItemValue(0,getRow(),"ActualPayInteAmt",0);
		return;
	}
	if(ActualPayODPrincipalAmt>OverDueBalance){
		alert("ʵ���ڹ����ڱ���"+temp+"�ڹ�Ƿ�����");
		setItemValue(0,getRow(),"ActualPayODPrincipalAmt",0);
		return;
	}
	if(ActualPayODInteAmt>ODInteBalance){
		alert("ʵ���ڹ�ǷϢ"+temp+"�ڹ�ǷϢ���");
		setItemValue(0,getRow(),"ActualPayODInteAmt",0);
		return;
	}
	if(ActualPayFineAmt>FineInteBalance){
		alert("ʵ�շ�Ϣ"+temp+"���ڷ�Ϣ���");
		setItemValue(0,getRow(),"ActualPayFineAmt",0);
		return;
	}
	if(ActualPayCompdInteAmt>CompdInteBalance){
		alert("ʵ�ո�Ϣ"+temp+"���ڸ�Ϣ���");
		setItemValue(0,getRow(),"ActualPayCompdInteAmt",0);
		return;
	}
	
	if(ActualPayPrincipalAmt<0){
		alert("ʵ�յ��ڱ���"+nLessZ);
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(ActualPayInteAmt<0){
		alert("ʵ�յ�����Ϣ"+nLessZ);
		setItemValue(0,getRow(),"ActualPayInteAmt",0);
		return;
	}
	if(ActualPayODPrincipalAmt<0){
		alert("ʵ���ڹ����ڱ���"+nLessZ);
		setItemValue(0,getRow(),"ActualPayODPrincipalAmt",0);
		return;
	}
	if(ActualPayODInteAmt<0){
		alert("ʵ���ڹ�ǷϢ"+nLessZ);
		setItemValue(0,getRow(),"ActualPayODInteAmt",0);
		return;
	}
	if(ActualPayFineAmt<0){
		alert("ʵ�շ�Ϣ"+nLessZ);
		setItemValue(0,getRow(),"ActualPayFineAmt",0);
		return;
	}
	if(ActualPayCompdInteAmt<0){
		alert("ʵ�ո�Ϣ"+nLessZ);
		setItemValue(0,getRow(),"ActualPayCompdInteAmt",0);
		return;
	}
	
	var ActualPayPrincipalAmt = getItemValue(0,getRow(),"ActualPayPrincipalAmt");
	var ActualPayInteAmt = getItemValue(0,getRow(),"ActualPayInteAmt");
	
	setItemValue(0,getRow(),"ActualPayAmt",(ActualPayPrincipalAmt+ActualPayInteAmt+ActualPayODPrincipalAmt+ActualPayODInteAmt+ActualPayFineAmt+ActualPayCompdInteAmt).toFixed(2));
}