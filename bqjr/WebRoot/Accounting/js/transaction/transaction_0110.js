var nLessZ = "不能小于等于0";
var MoreZ = "必须大于0";
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var MayquitAmt = getItemValue(0,getRow(),"MayquitAmt");
	if(actualPayAmt<=0){
		alert("退款金额"+nLessZ);
		setItemValue(0,getRow(),"ActualPayAmt",0);
		return false;
	}
	
	if(actualPayAmt>MayquitAmt){
		alert("退款金额不能大于可退金额");
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

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	return;
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


/*~[Describe=可退金额;InputParam=无;OutPutParam=无;]~*/
function ReturnAmount(){
	var sTransSerialNo = getItemValue(0,getRow(),"TransSerialNo");
	var sSerialno = getItemValue(0,getRow(),"ObjectNo");
	var sInputTime = getItemValue(0,getRow(),"TransDate");
	var sNextDueDate = getItemValue(0,getRow(),"NextDueDate");
	if(typeof(sInputTime) == "undefined" || sInputTime.length == 0){
		alert("请选择申请退款日期");
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
