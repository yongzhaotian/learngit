var aheadPaymentCalcFlag = true;//控制是否需要贷款提前还款计算
var aheadPaymentScheFlag = false;//控制是否需要贷款进行还款计划测算
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
	/*var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("必须引入还款账号!");
		return false;
	}*/
	
	return true;
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null || obj.style.display=="none") return;
	OpenComp("TransactionFeeList","/Accounting/Transaction/TransactionFeeList.jsp","ToInheritObj=y&ParentTransSerialNo="+transactionSerialNo,"NEWFEEPart","");
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	if(aheadPaymentCalcFlag)
	{
		var apcs=popComp("AheadPaymentConsult","/Accounting/Transaction/AheadPaymentConsult.jsp","TransactionSerialNo="+transactionSerialNo,"dialogWidth=50;dialogHeight=30;");
		if(typeof(apcs) != "undefined" && apcs.length != 0)
		{
			var payAmt = apcs.split("@")[0];
			var prePayPrincipalAmt = apcs.split("@")[1];
			var prePayInteAmt = apcs.split("@")[2];
			setItemValue(0,0,"PayAmt",payAmt);
			setItemValue(0,0,"PrePayPrincipalAmt",prePayPrincipalAmt);
			setItemValue(0,0,"PrePayInteAmt",prePayInteAmt);
		}
	}
	
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","ToInheritObj=y&TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	/*changePrepayType();*/
	openFeeList();
}

/*~[Describe=根据提前还款咨询;InputParam=后续事件;OutPutParam=无;]~*/
function repayConsult(){
	var sActualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	var sPayAmt = getItemValue(0,getRow(),"PayAmt");
	/*
	if(sActualPayAmt>sPayAmt){
		alert("还款本金必须小于还款总金额");
		return;
	}*/
	var sTransStatus = getItemValue(0,getRow(),"TransStatus");
	if(typeof(sTransStatus)=="undefined"||sTransStatus.length==0 || sTransStatus !="0"){
		alert("此笔交易状态不是待提交,不允许试算!");
		return;
	}
	aheadPaymentCalcFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=还款计划测算;InputParam=无;OutPutParam=无;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
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
	setItemValue(0,getRow(),"PayAccountFlag",2);
	
	//setValue("TransDate",businessDate);
	setItemValue(0,getRow(),"TransDate",sPayDate);
	setItemValue(0,getRow(),"PrePayType","10");
	setItemValue(0,getRow(),"PrepayInterestDaysFlag","02");
	setItemValue(0,getRow(),"PrepayInterestBaseFlag","02");
	setItemValue(0,getRow(),"PrePayAmountFlag","2");
	
	var sTransDate = getItemValue(0,getRow(),"TransDate");
	var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
	
	var sParaString=sTransDate+","+sLoanSerialNo+","+sScheduleDate;
	var sReturn=RunMethod("BusinessManage","SelectPrepaymentAmount",sParaString);
	var str=sReturn.split(",");
	
	setItemValue(0,getRow(),"PayPrincipalAmt",str[0]);
	setItemValue(0,getRow(),"PayInteAmt",str[1]);
	setItemValue(0,getRow(),"PrePayPrincipalAmt",str[0]);
	setItemValue(0,getRow(),"PrePayInteAmt",str[1]);
	setItemValue(0,getRow(),"PayInsuranceFee",str[2]);
	setItemValue(0,getRow(),"PrepaymentFee",str[3]);
	setItemValue(0,getRow(),"CustomerServeFee",str[4]);
	setItemValue(0,getRow(),"AccountManageFee",str[5]);
	setItemValue(0,getRow(),"StampTax",str[6]);
	setItemValue(0,getRow(),"PayAmt",str[7]);
	
	var sFlag=str[8];
	if(sFlag == "true") setItemValue(0,getRow(),"PrepayInterestDaysFlag","04");
	
	
	/*changePrepayType();*/
	openFeeList();
	changeCashOnlineFlag();
/*	ImportAccount("01","PayAccountFlag","PayAccountType","PayAccountCurrency","PayAccountNo","PayAccountName","PayAccountOrgID");
*/}

/*~[Describe=根据提前还款方式不同触发该事件;InputParam=后续事件;OutPutParam=无;]~*/
/*function changePrepayType(){
	var dNormalBalance = getItemValue(0,getRow(),"NormalBalance");
	var dOverdueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var sPrePayType = getItemValue(0,0,"PrePayType");
	if(typeof(sPrePayType)=="undefined" || sPrePayType.length==0){
		return;
	}
	if(sPrePayType == "10"){
		setItemValue(0,0,"PrePayAmountFlag","1");
		setItemDisabled(0,0,"PrePayAmountFlag",true);
		setItemValue(0,0,"ActualPayAmt",parseFloat(dNormalBalance)+parseFloat(dOverdueBalance));
		setItemDisabled(0,0,"ActualPayAmt",true);
		setItemValue(0,0,"PrepayInterestBaseFlag","02");
		setItemDisabled(0,0,"PrepayInterestBaseFlag",true);
	}else{
		var sPrepayInterestDaysFlag = getItemValue(0,0,"PrepayInterestDaysFlag");
		if(typeof(sPrepayInterestDaysFlag)=="undefined" || sPrepayInterestDaysFlag.length==0){
			return;
		}
		setItemDisabled(0,0,"PrePayAmountFlag",false);
		setItemDisabled(0,0,"ActualPayAmt",false);
		setItemDisabled(0,0,"PrepayInterestBaseFlag",false);
		setItemDisabled(0,0,"PrepayInterestDaysFlag",false);
		if(sPrepayInterestDaysFlag=="03"){
			setItemValue(0,0,"PrepayInterestBaseFlag","02");
			setItemDisabled(0,0,"PrepayInterestBaseFlag",true);
		}
		else{
			setItemDisabled(0,0,"PrepayInterestBaseFlag",false);
		} 
	}
	
}*/