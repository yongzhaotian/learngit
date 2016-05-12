/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	
}

/*~[Describe=输入本金调整金额;InputParam=无;OutPutParam=无;]~*/
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
			alert(Subtract+"调整金额过大，请重新输入！");
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
			alert("调整金额过大，请重新输入！");
			setItemValue(0,0,"ChangePrincipalAmt",0);
			return;
		}
		setItemValue(0,0,"NormalBalance",Sum);
		setItemValue(0,0,"OldOverdueBalance",sLoanNormalBalance-sOldNormalBalance);
		setItemValue(0,0,"NewOverdueBalance",sLoanNormalBalance-Sum);
	}
}

/*~[Describe=选择旧的科目;InputParam=无;OutPutParam=无;]~*/
function selectOLDAccountCode(id,name)
{
	var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
	setObjectValue("SelectOLDAccountCode","LoanSerialNo,"+sLoanSerialNo+",ObjectType,jbo.app.ACCT_LOAN","@"+id+"@0@"+name+"@1",0,0,"");
}
/*~[Describe=选择新的科目;InputParam=无;OutPutParam=无;]~*/
function selectAccountCodeB(id,name)
{
	setObjectValue("SelectAccountCodeB","","@"+id+"@0@"+name+"@1",0,0,"");
}

/*~[Describe=初始化;InputParam=无;OutPutParam=无;]~*/
function initRow(){
	if (getRowCount(0)==0) {
		as_add("myiframe0");//新增记录
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