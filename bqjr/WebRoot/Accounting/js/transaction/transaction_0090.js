/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var WAVEINTEAMT=getItemValue(0,getRow(),"WAVEINTEAMT");
	var PAYINTEAMT=getItemValue(0,getRow(),"PAYINTEAMT");
	var WAVEFINEAMT=getItemValue(0,getRow(),"WAVEFINEAMT");
	var PAYFINEAMT=getItemValue(0,getRow(),"PAYFINEAMT");
	
	if(WAVEINTEAMT>PAYINTEAMT){
		alert("������Ϣ���ܴ���Ӧ����Ϣ��");
		return false;
	}
	
	if(WAVEFINEAMT>PAYFINEAMT){
		alert("���ⷣϢ���ܴ���Ӧ����Ϣ��");
		return false;
	}
	
	if(WAVEINTEAMT<0){
		alert("�������Ϣ����С��0��");
		return false;
	}
	
	if(WAVEFINEAMT<0){
		alert("����ķ�Ϣ����С��0��");
		return false;
	}
	
	if(WAVEINTEAMT == 0 && WAVEFINEAMT == 0)
		{
			alert("�������ȫ��Ϊ�㣡");
			return false;
		}
	
	/*var WAVEPRINCIPALAMT = getItemValue(0,getRow(),"WAVEPRINCIPALAMT");
	var WAVEINTEAMT = getItemValue(0,getRow(),"WAVEINTEAMT");
	var WAVECOMPDINTEAMT = getItemValue(0,getRow(),"WAVECOMPDINTEAMT");
	var WAVEFINEAMT = getItemValue(0,getRow(),"WAVEFINEAMT");
	var PAYPRINCIPALAMT = getItemValue(0,getRow(),"PAYPRINCIPALAMT");
	var PAYINTEAMT = getItemValue(0,getRow(),"PAYINTEAMT");
	var PAYCOMPDINTEAMT = getItemValue(0,getRow(),"PAYCOMPDINTEAMT");
	var PAYFINEAMT = getItemValue(0,getRow(),"PAYFINEAMT");
	var ACTUALPAYPRINCIPALAMT = getItemValue(0,getRow(),"ACTUALPAYPRINCIPALAMT");
	var ACTUALPAYINTEAMT = getItemValue(0,getRow(),"ACTUALPAYINTEAMT");
	var ACTUALPAYCOMPDINTEAMT = getItemValue(0,getRow(),"ACTUALPAYCOMPDINTEAMT");
	var ACTUALPAYFINEAMT = getItemValue(0,getRow(),"ACTUALPAYFINEAMT");
	if(WAVEPRINCIPALAMT+PAYPRINCIPALAMT-ACTUALPAYPRINCIPALAMT < 0
	  || WAVEINTEAMT+PAYINTEAMT-ACTUALPAYINTEAMT < 0
	  || WAVECOMPDINTEAMT+PAYCOMPDINTEAMT-ACTUALPAYCOMPDINTEAMT < 0
	  || WAVEFINEAMT+PAYFINEAMT-ACTUALPAYFINEAMT < 0){
		alert("�������Ϊ����ʱ����С�ڶ�ӦӦ����");
		return false;
	}
	if(WAVEPRINCIPALAMT == 0 
		&& WAVEINTEAMT == 0 
		&& WAVECOMPDINTEAMT == 0 
		&& WAVEFINEAMT == 0)
	{
		alert("��������ȫ��Ϊ�㣡");
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
}

function selectPSS()
{
	var loanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
	setObjectValue("SelectPaymentSchedule","ObjectType,jbo.app.ACCT_LOAN,ObjectNo,"+loanSerialNo,"@PAYDATE@0@PAYPRINCIPALAMT@1@PAYINTEAMT@2@PAYCOMPDINTEAMT@3@PAYFINEAMT@4@ACTUALPAYPRINCIPALAMT@5@ACTUALPAYINTEAMT@6@ACTUALPAYCOMPDINTEAMT@7@ACTUALPAYFINEAMT@8@PSSERIALNO@9",0,0,"");
}

