/*~[Describe=�Ƿ�����֧���ı�;InputParam=�����¼�;OutPutParam=��;]~*/
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

/*~[Describe=���뻹���˻�;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
function ImportAccount(accountIndicator,accountFlag,accountType,accountCurrency,accountNo,accountName,accountOrgID)
{
	setObjectValue("SelectDepositAccount","ObjectType,"+relaObjectType+",ObjectNo,"+relaObjectNo+",AccountIndicator,"+accountIndicator,"@"+accountFlag+"@0@"+accountType+"@1@"+accountCurrency+"@2@"+accountNo+"@3@"+accountName+"@4@"+accountOrgID+"@5",0,0,"");
}

/*~[Describe=�˶��˻���Ϣ;InputParam=�����¼�;OutPutParam=��;]~*/
function queryPayAccount(){
	alert("�뵽�ӿڲ�ѯ");
}

/*~[Describe=�˻���ѯ;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
function QueryAccount(accountFlag,accountType,accountCurrency,accountNo,accountName,accountOrgID)
{
	showCoverTip("&nbsp;&nbsp;<font color=\"blue\">���������ϵͳ���нӿ���Ϣ�������������ĵȴ�......</font>");
	alert("ʵʱ�ӿ�����������ͻ�������");
	hideCoverTip();
}