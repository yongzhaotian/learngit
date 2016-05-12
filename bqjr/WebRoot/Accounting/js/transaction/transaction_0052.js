/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var PrePayType = getItemValue(0,getRow(),"PrePayType");
	if(actualPayAmt<=0 && PrePayType != "10"){//不是全部提前还款
		alert("还款总金额不能小于等于0");
		setItemValue(0,getRow(),"ActualPayAmt",0);
		return false;
	}
	//校验账号必输
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("必须引入还款账号!");
		return false;
	}
	
	return true;
}

/*~[Describe=初始化;InputParam=无;OutPutParam=无;]~*/
function initRow(){
	
	if (getRowCount(0)==0) {
		as_add("myiframe0");//新增记录
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

