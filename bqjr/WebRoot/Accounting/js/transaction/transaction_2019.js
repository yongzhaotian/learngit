/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var AccountingOrgID = getItemValue(0,getRow(),"AccountingOrgID");
	var OLDAccountingOrgID = getItemValue(0,getRow(),"OLDAccountingOrgID");
	if(AccountingOrgID == OLDAccountingOrgID){
		alert("���������ǰһ�£�������ѡ��");
		return false;
	}
	
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){	
}

/*~[Describe=ѡ�����;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
function selectOrgID(orgID,orgName)
{
	setObjectValue("SelectAllOrg","","@"+orgID+"@0@"+orgName+"@1",0,0,"");
	var sAccountingOrgID = getItemValue(0,getRow(),"AccountingOrgID");
	var sOLDAccountingOrgID = getItemValue(0,getRow(),"OLDAccountingOrgID");
	if(sAccountingOrgID == sOLDAccountingOrgID){
		alert("�������������Ϊ����ǰ����");
		setItemValue(0,getRow(),"AccountingOrgID","");
		setItemValue(0,getRow(),"AccountingOrgName","");
	}
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
}