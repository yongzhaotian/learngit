/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	
}

/*~[Describe=���뱾��������;InputParam=��;OutPutParam=��;]~*/
function changePrincipalAmt(){
	var sLoanNormalBalance = getItemValue(0,getRow(),"LoanNormalBalance");
	var sChangePrincipalType = getItemValue(0,getRow(),"ChangePrincipalType");
	var sOldNormalBalance = getItemValue(0,getRow(),"OldNormalBalance");
	var sChangePrincipalAmt = getItemValue(0,getRow(),"ChangePrincipalAmt");
	
	if(sChangePrincipalAmt <= 0){
		setItemValue(0,0,"ChangePrincipalAmt","");
		return;
	}
	if("010"==sChangePrincipalType){
		var sChangePrincipalAmt = getItemValue(0,getRow(),"ChangePrincipalAmt");
		var Subtract = sOldNormalBalance-sChangePrincipalAmt;
		if(Subtract<0){
			alert(Subtract+"�������������������룡");
			setItemValue(0,0,"ChangePrincipalAmt",0);
			return;
		}
		setItemValue(0,0,"NormalBalance",Subtract);
		setItemValue(0,0,"OldOverdueBalance",sLoanNormalBalance-sOldNormalBalance);
		setItemValue(0,0,"NewOverdueBalance",sLoanNormalBalance-Subtract);
	}else if("020"==sChangePrincipalType){
		var sOldNormalBalance = getItemValue(0,getRow(),"OldNormalBalance");
		var sLoanNormalBalance = getItemValue(0,getRow(),"LoanNormalBalance");
		var sChangePrincipalAmt = getItemValue(0,getRow(),"ChangePrincipalAmt");
		var Sum = sOldNormalBalance+sChangePrincipalAmt;
		if(Sum>sOldNormalBalance){
			alert("�������������������룡");
			setItemValue(0,0,"ChangePrincipalAmt",0);
			return;
		}
		setItemValue(0,0,"NormalBalance",Sum);
		setItemValue(0,0,"OldOverdueBalance",sLoanNormalBalance-sOldNormalBalance);
		setItemValue(0,0,"NewOverdueBalance",sLoanNormalBalance-Sum);
	}
}

/*~[Describe=ѡ��ɵĿ�Ŀ;InputParam=��;OutPutParam=��;]~*/
function selectOLDAccountCode(id,name)
{
	var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
	setObjectValue("SelectOLDAccountCode","LoanSerialNo,"+sLoanSerialNo+",ObjectType,jbo.app.ACCT_LOAN","@"+id+"@0@"+name+"@1",0,0,"");
}
/*~[Describe=ѡ���µĿ�Ŀ;InputParam=��;OutPutParam=��;]~*/
function selectAccountCodeB(id,name)
{
	setObjectValue("SelectAccountCodeB","","@"+id+"@0@"+name+"@1",0,0,"");
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