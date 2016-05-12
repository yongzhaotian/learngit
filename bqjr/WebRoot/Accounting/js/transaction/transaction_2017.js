var aheadPaymentScheFlag = false;//控制是否需要贷款进行还款计划测算
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var MaturityDate = getItemValue(0,getRow(),"MaturityDate");
	var OLDMaturityDate = getItemValue(0,getRow(),"OLDMaturityDate");
	//做展期使用此段代码
	/*setItemValue(0,0,"TransDate",OLDMaturityDate);
	if(MaturityDate<=OLDMaturityDate)
	{
		alert("新到期日必须大于原到期日！");
		return false;
	}*/
	if(MaturityDate == OLDMaturityDate){
		alert("到期日与调整前一致，请重新选择！");
		return false;
	}
	
	if(MaturityDate<=transDate)
	{
		alert("到期日必须大于生效日期！");
		return false;
	}
	//需手动指定贷款的利率时，使用这段代码
	/*try{
		myiframe0.RatePart.saveRecord();
	}catch(e){
		
	}*/
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){	
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	/*calcLoanRateTermID();//需手动指定变更贷款的利率时，使用这段代码
	calcFINTermID();*/
	openFeeList();
}

/*~[Describe=还款计划测算;InputParam=无;OutPutParam=无;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}
//当手动指定变更利率时，使用此代码
/*~[Describe=利率信息;InputParam=无;OutPutParam=无;]~*/
/*function calcLoanRateTermID(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_RatePart');
	if(typeof(obj) == "undefined" || obj == null) return;
	var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
	if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID.length == 0) return;
	var sPutoutDate = getItemValue(0,getRow(),"LoanPutOutDate");
	var sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
	if(typeof(sMaturityDate) == "undefined" || sMaturityDate.length == 0){ 
		sMaturityDate = getItemValue(0,getRow(),"OLDMaturityDate");
	}
	var  termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturityDate);
	OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Status=0@1&termMonth="+termMonth+"&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RateSegmentView&TermObjectType=<%=BUSINESSOBJECT_CONSTATNTS.loan_rate_segment%>&TermID="+sLoanRateTermID,"RatePart","");
}*/
/*~[Describe=罚息信息;InputParam=无;OutPutParam=无;]~*/
/*function calcFINTermID(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_FINPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("FinTermList","/Accounting/LoanDetail/LoanTerm/FinTermList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","FINPart","");
}*/
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
	//手动指定变更利率时使用此代码
	/*calcLoanRateTermID();
	calcFINTermID();*/
}
/*数据库操作：
1手动指定期限变更利率
update DATAOBJECT_LIBRARY  set colhtmlstyle='onChange=parent.calcLoanRateTermID()'  WHERE DONO='Transaction_2017' and colindex='0100';
update code_library  set itemattribute='com.amarsoft.app.accounting.trans.script.loan.change.LoanTermExtend' where codeno='T_Transaction_Def' and itemno='2017'
update  dataobject_group  set styleid='width:100%;height:110%;' where dono='Transaction_2017' and dockid in( 'RatePart' ,'FINPart')
update dataobject_library  set colvisible=1,colrequired=1 where dono='Transaction_2017' and colindex='0140';
update dataobject_library  set colvisible=0 where dono='Transaction_2017' and colindex='0130';
2、非手动指定期限变更利率
update  dataobject_group  set styleid='display:none;' where dono='Transaction_2017' and dockid in( 'RatePart' ,'FINPart');
update code_library  set itemattribute='com.amarsoft.app.accounting.trans.script.loan.change.LoanTermChange' where codeno='T_Transaction_Def' and itemno='2017';
update dataobject_library  set colvisible=0,colrequired=0 where dono='Transaction_2017' and colindex='0140';
update DATAOBJECT_LIBRARY  set colhtmlstyle=null WHERE DONO='Transaction_2017' and colindex='0100';
update dataobject_library  set colvisible=1 where dono='Transaction_2017' and colindex='0130';*/