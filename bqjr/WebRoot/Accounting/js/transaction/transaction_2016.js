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
	openOldSptList();
	openNewSptList();
}

/*~[Describe=����Ϣ��Ϣ;InputParam=��;OutPutParam=��;]~*/
function openNewSptList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWSPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("BusinessTermList","/Accounting/LoanDetail/LoanTerm/BusinessTermList.jsp","Status=0@1&ToInheritObj=y&ObjectType="+documentType+"&ObjectNo="+documentSerialNo+"&TempletNo=SPTSegmentList&TermType=SPT","NEWSPTPart","");
}

/*~[Describe=����Ϣ��Ϣ;InputParam=��;OutPutParam=��;]~*/
function openOldSptList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_OLDSPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("BusinessTermList","/Accounting/LoanDetail/LoanTerm/BusinessTermList.jsp","RightType=ReadOnly&Status=2&ObjectType="+documentType+"&ObjectNo="+documentSerialNo+"&TempletNo=SPTSegmentList&TermType=SPT","OLDSPTPart","");
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
	openOldSptList();
	openNewSptList();
}