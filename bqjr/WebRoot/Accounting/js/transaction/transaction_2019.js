/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var AccountingOrgID = getItemValue(0,getRow(),"AccountingOrgID");
	var OLDAccountingOrgID = getItemValue(0,getRow(),"OLDAccountingOrgID");
	if(AccountingOrgID == OLDAccountingOrgID){
		alert("机构与调整前一致，请重新选择！");
		return false;
	}
	
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){	
}

/*~[Describe=选择机构;InputParam=无;OutPutParam=通过true,否则false;]~*/
function selectOrgID(orgID,orgName)
{
	setObjectValue("SelectAllOrg","","@"+orgID+"@0@"+orgName+"@1",0,0,"");
	var sAccountingOrgID = getItemValue(0,getRow(),"AccountingOrgID");
	var sOLDAccountingOrgID = getItemValue(0,getRow(),"OLDAccountingOrgID");
	if(sAccountingOrgID == sOLDAccountingOrgID){
		alert("调整后机构不能为调整前机构");
		setItemValue(0,getRow(),"AccountingOrgID","");
		setItemValue(0,getRow(),"AccountingOrgName","");
	}
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