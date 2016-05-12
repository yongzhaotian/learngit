/*~[Describe=是否在线支付改变;InputParam=后续事件;OutPutParam=无;]~*/
function changeCashOnlineFlag(){
	var CashOnlineFlag = getItemValue(0,getRow(),"CashOnlineFlag");
	
	if(CashOnlineFlag == "1"){
		setItemRequired(0,getRow(),"PayAccountFlag",true);
		setItemRequired(0,getRow(),"PayAccountType",true);
		setItemRequired(0,getRow(),"PayAccountCurrency",true);
		setItemRequired(0,getRow(),"PayAccountNo",true);
		setItemRequired(0,getRow(),"PayAccountName",true);
		setItemRequired(0,getRow(),"PayAccountOrgID",true);
	}
	else{
		setItemRequired(0,getRow(),"PayAccountFlag",false);
		setItemRequired(0,getRow(),"PayAccountType",false);
		setItemRequired(0,getRow(),"PayAccountCurrency",false);
		setItemRequired(0,getRow(),"PayAccountNo",false);
		setItemRequired(0,getRow(),"PayAccountName",false);
		setItemRequired(0,getRow(),"PayAccountOrgID",false);
	}
}

/*~[Describe=引入还款账户;InputParam=无;OutPutParam=通过true,否则false;]~*/
function ImportAccount(accountIndicator,accountFlag,accountType,accountCurrency,accountNo,accountName,accountOrgID)
{
	setObjectValue("SelectDepositAccount","ObjectType,"+relaObjectType+",ObjectNo,"+relaObjectNo+",AccountIndicator,"+accountIndicator,"@"+accountFlag+"@0@"+accountType+"@1@"+accountCurrency+"@2@"+accountNo+"@3@"+accountName+"@4@"+accountOrgID+"@5",0,0,"");
}

/*~[Describe=核对账户信息;InputParam=后续事件;OutPutParam=无;]~*/
function queryPayAccount(){
	alert("请到接口查询");
}

/*~[Describe=账户查询;InputParam=无;OutPutParam=通过true,否则false;]~*/
function QueryAccount(accountFlag,accountType,accountCurrency,accountNo,accountName,accountOrgID)
{
	showCoverTip("&nbsp;&nbsp;<font color=\"blue\">正在与核心系统进行接口信息交互，请您耐心等待......</font>");
	alert("实时接口联机核心需客户化开发");
	hideCoverTip();
}