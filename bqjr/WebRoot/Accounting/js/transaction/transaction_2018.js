/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var RepriceType = getItemValue(0,getRow(),"RepriceType");
	var OLDRepriceType = getItemValue(0,getRow(),"OLDRepriceType");
	var RepriceDate = getItemValue(0,getRow(),"RepriceDate");
	var OLDRepriceDate = getItemValue(0,getRow(),"OLDRepriceDate");
	var RepriceCyc = getItemValue(0,getRow(),"RepriceCyc");
	var OLDRepriceCyc = getItemValue(0,getRow(),"OLDRepriceCyc");
	var RepriceFlag = getItemValue(0,getRow(),"RepriceFlag");
	var OLDRepriceFlag = getItemValue(0,getRow(),"OLDRepriceFlag");
	if(RepriceType == OLDRepriceType){
		if(OLDRepriceType != '8'){
			alert("�����ʵ�����ʽ������ԭ���ʵ�����ʽ��ͬ");
			return false;
		}
		else if(RepriceDate == OLDRepriceDate && RepriceCyc == OLDRepriceCyc && RepriceFlag == OLDRepriceFlag){
			alert("�����ʵ�����ʽ������ԭ���ʵ�����ʽ��ͬ");
			return false;
		}
	}
	
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){	
	openFeeList();
	selectRepriceInfo();
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function openFeeList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null  || obj.style.display=="none") return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
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
	openFeeList();
}