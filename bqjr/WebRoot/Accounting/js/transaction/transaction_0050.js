/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate != businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	if(actualPayAmt<=0){
		alert("还款总金额必须大于0");
		setItemValue(0,getRow(),"ActualPayAmt","");
		return false;
	}
	//校验账号必输
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("必须引入还款账号!");
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
		alert("还款总金额不能大于应还总金额（包含正常本息）！");
		setItemValue(0,getRow(),"ActualPayAmt","");
		return false;
	}*/
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	
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