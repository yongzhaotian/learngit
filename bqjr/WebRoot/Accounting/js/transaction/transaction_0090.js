/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var WAVEINTEAMT=getItemValue(0,getRow(),"WAVEINTEAMT");
	var PAYINTEAMT=getItemValue(0,getRow(),"PAYINTEAMT");
	var WAVEFINEAMT=getItemValue(0,getRow(),"WAVEFINEAMT");
	var PAYFINEAMT=getItemValue(0,getRow(),"PAYFINEAMT");
	
	if(WAVEINTEAMT>PAYINTEAMT){
		alert("减免利息不能大于应还利息！");
		return false;
	}
	
	if(WAVEFINEAMT>PAYFINEAMT){
		alert("减免罚息不能大于应还罚息！");
		return false;
	}
	
	if(WAVEINTEAMT<0){
		alert("减免的利息不能小于0！");
		return false;
	}
	
	if(WAVEFINEAMT<0){
		alert("减免的罚息不能小于0！");
		return false;
	}
	
	if(WAVEINTEAMT == 0 && WAVEFINEAMT == 0)
		{
			alert("减免金额不能全部为零！");
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
		alert("调整金额为负数时不能小于对应应还金额！");
		return false;
	}
	if(WAVEPRINCIPALAMT == 0 
		&& WAVEINTEAMT == 0 
		&& WAVECOMPDINTEAMT == 0 
		&& WAVEFINEAMT == 0)
	{
		alert("调整金额不能全部为零！");
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
}

function selectPSS()
{
	var loanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
	setObjectValue("SelectPaymentSchedule","ObjectType,jbo.app.ACCT_LOAN,ObjectNo,"+loanSerialNo,"@PAYDATE@0@PAYPRINCIPALAMT@1@PAYINTEAMT@2@PAYCOMPDINTEAMT@3@PAYFINEAMT@4@ACTUALPAYPRINCIPALAMT@5@ACTUALPAYINTEAMT@6@ACTUALPAYCOMPDINTEAMT@7@ACTUALPAYFINEAMT@8@PSSERIALNO@9",0,0,"");
}

