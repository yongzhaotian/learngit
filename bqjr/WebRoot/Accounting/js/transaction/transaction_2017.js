var aheadPaymentScheFlag = false;//�����Ƿ���Ҫ������л���ƻ�����
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var MaturityDate = getItemValue(0,getRow(),"MaturityDate");
	var OLDMaturityDate = getItemValue(0,getRow(),"OLDMaturityDate");
	//��չ��ʹ�ô˶δ���
	/*setItemValue(0,0,"TransDate",OLDMaturityDate);
	if(MaturityDate<=OLDMaturityDate)
	{
		alert("�µ����ձ������ԭ�����գ�");
		return false;
	}*/
	if(MaturityDate == OLDMaturityDate){
		alert("�����������ǰһ�£�������ѡ��");
		return false;
	}
	
	if(MaturityDate<=transDate)
	{
		alert("�����ձ��������Ч���ڣ�");
		return false;
	}
	//���ֶ�ָ�����������ʱ��ʹ����δ���
	/*try{
		myiframe0.RatePart.saveRecord();
	}catch(e){
		
	}*/
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){	
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	/*calcLoanRateTermID();//���ֶ�ָ��������������ʱ��ʹ����δ���
	calcFINTermID();*/
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
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}
//���ֶ�ָ���������ʱ��ʹ�ô˴���
/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
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
/*~[Describe=��Ϣ��Ϣ;InputParam=��;OutPutParam=��;]~*/
/*function calcFINTermID(){
	var obj = frames['myiframe0'].document.getElementById('ContentFrame_FINPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("FinTermList","/Accounting/LoanDetail/LoanTerm/FinTermList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","FINPart","");
}*/
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
	//�ֶ�ָ���������ʱʹ�ô˴���
	/*calcLoanRateTermID();
	calcFINTermID();*/
}
/*���ݿ������
1�ֶ�ָ�����ޱ������
update DATAOBJECT_LIBRARY  set colhtmlstyle='onChange=parent.calcLoanRateTermID()'  WHERE DONO='Transaction_2017' and colindex='0100';
update code_library  set itemattribute='com.amarsoft.app.accounting.trans.script.loan.change.LoanTermExtend' where codeno='T_Transaction_Def' and itemno='2017'
update  dataobject_group  set styleid='width:100%;height:110%;' where dono='Transaction_2017' and dockid in( 'RatePart' ,'FINPart')
update dataobject_library  set colvisible=1,colrequired=1 where dono='Transaction_2017' and colindex='0140';
update dataobject_library  set colvisible=0 where dono='Transaction_2017' and colindex='0130';
2�����ֶ�ָ�����ޱ������
update  dataobject_group  set styleid='display:none;' where dono='Transaction_2017' and dockid in( 'RatePart' ,'FINPart');
update code_library  set itemattribute='com.amarsoft.app.accounting.trans.script.loan.change.LoanTermChange' where codeno='T_Transaction_Def' and itemno='2017';
update dataobject_library  set colvisible=0,colrequired=0 where dono='Transaction_2017' and colindex='0140';
update DATAOBJECT_LIBRARY  set colhtmlstyle=null WHERE DONO='Transaction_2017' and colindex='0100';
update dataobject_library  set colvisible=1 where dono='Transaction_2017' and colindex='0130';*/