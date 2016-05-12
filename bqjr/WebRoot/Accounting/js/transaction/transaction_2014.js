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
	calcOldAccountInfo();
	calcNewAccountInfo();
	openFeeList();
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function openFeeList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null || obj.style.display=="none") return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}

/*~[Describe=ԭ�˻���Ϣ;InputParam=��;OutPutParam=��;]~*/
function calcOldAccountInfo(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_OldAccountPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("DepositAccountsList","/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp","RightType=ReadOnly&Status=2&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","OldAccountPart","");
}

/*~[Describe=���˻���Ϣ;InputParam=��;OutPutParam=��;]~*/
function calcNewAccountInfo(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NewAccountPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("DepositAccountsList","/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NewAccountPart","");
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
	calcOldAccountInfo();
	calcNewAccountInfo();
	openFeeList();
}