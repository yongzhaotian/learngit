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
	openOldSptList();
	openNewSptList();
}

/*~[Describe=新贴息信息;InputParam=无;OutPutParam=无;]~*/
function openNewSptList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWSPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("BusinessTermList","/Accounting/LoanDetail/LoanTerm/BusinessTermList.jsp","Status=0@1&ToInheritObj=y&ObjectType="+documentType+"&ObjectNo="+documentSerialNo+"&TempletNo=SPTSegmentList&TermType=SPT","NEWSPTPart","");
}

/*~[Describe=老贴息信息;InputParam=无;OutPutParam=无;]~*/
function openOldSptList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_OLDSPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("BusinessTermList","/Accounting/LoanDetail/LoanTerm/BusinessTermList.jsp","RightType=ReadOnly&Status=2&ObjectType="+documentType+"&ObjectNo="+documentSerialNo+"&TempletNo=SPTSegmentList&TermType=SPT","OLDSPTPart","");
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
	openOldSptList();
	openNewSptList();
}