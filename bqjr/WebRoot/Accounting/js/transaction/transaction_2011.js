var aheadPaymentScheFlag = false;//�����Ƿ���Ҫ������л���ƻ�����
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	try{
		myiframe0.NEWRPTPart.saveRecord();
	}catch(e){
		
	}
	
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){	
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	calcNewRPTTermID();
	calcOldRPTTermID();
	openFeeList();
}

/*~[Describe=����ƻ�����;InputParam=��;OutPutParam=��;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function openFeeList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null || obj.style.display=="none") return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}

/*~[Describe=���ʽ��Ϣ;InputParam=��;OutPutParam=��;]~*/
function calcNewRPTTermID(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWRPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
	if(typeof(sRPTTermID) == "undefined" || sRPTTermID.length == 0) return;
	if(sRPTTermID=="RPT20"){
		var businessSum=getItemValue(0,getRow(),"NormalBalance");
		var putOutDate=businessDate;
		var maturity=getItemValue(0,getRow(),"LoanMaturityDate");
		OpenComp("RPTTermList","/Accounting/LoanDetail/LoanTerm/RPTTermList.jsp","Status=0&ToInheritObj=y&Maturity="+maturity+"&PutOutDate="+putOutDate+"&BusinessSum="+businessSum+"&ObjectType="+documentType+"&ObjectNo="+documentSerialNo+"&TermID="+sRPTTermID,"NEWRPTPart","");
	}else{
		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=<%=BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment%>&TermID="+sRPTTermID,"NEWRPTPart","");
	}
}

/*~[Describe=ԭ���ʽ��Ϣ;InputParam=��;OutPutParam=��;]~*/
function calcOldRPTTermID(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_OLDRPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	var sOLDRPTTermID = getItemValue(0,getRow(),"OLDRPTTermID");
	if(typeof(sOLDRPTTermID) == "undefined" || sOLDRPTTermID.length == 0) return;
	OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","RightType=ReadOnly&Status=2&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=<%=BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment%>&TermID="+sOLDRPTTermID,"OLDRPTPart","");
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
	calcNewRPTTermID();
	calcOldRPTTermID();
	openFeeList();
}