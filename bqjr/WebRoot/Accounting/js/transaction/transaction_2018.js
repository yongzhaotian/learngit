/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
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
			alert("新利率调整方式不能与原利率调整方式相同");
			return false;
		}
		else if(RepriceDate == OLDRepriceDate && RepriceCyc == OLDRepriceCyc && RepriceFlag == OLDRepriceFlag){
			alert("新利率调整方式不能与原利率调整方式相同");
			return false;
		}
	}
	
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){	
	openFeeList();
	selectRepriceInfo();
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null  || obj.style.display=="none") return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
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
	openFeeList();
}