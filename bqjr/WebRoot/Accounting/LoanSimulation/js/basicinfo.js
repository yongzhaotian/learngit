	/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcLoanRateTermID(functionID){
		var loanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
		if(typeof(loanRateTermID) == "undefined" || loanRateTermID.length == 0) return;
		//window.frames['myiframe0'].document.getElementById('ContentFrame_RatePart').style.display="";
		var currency = getItemValue(0,getRow(),"BusinessCurrency");
		if(typeof(currency) == "undefined" || currency.length == 0)
		 	currency = getItemValue(0,getRow(),"Currency");
		if(typeof(currency) == "undefined" || currency.length == 0) currency = "";
		
		var sPutoutDate = getItemValue(0,getRow(),"PutOutDate");
		var sMaturity = getItemValue(0,getRow(),"Maturity"); //����ΪBusinessPutOutʱ
		var sMaturityDate = getItemValue(0,getRow(),"MaturityDate"); //����ΪLoanʱ����������ѯ��
		if(typeof(sMaturity)=="undefined" || sMaturity.length==0)
			sMaturity = sMaturityDate;
		var termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturity);
		
		OpenPage("/Accounting/LoanSimulation/LoanTerm/BusinessTermView.jsp?TermID="+loanRateTermID+"&TermMonth="+termMonth+"&Currency="+currency,"RatePart","");
	}
	
	/*~[Describe=���ʽ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcRPTTermID(functionID){
		var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
		if(typeof(sRPTTermID) == "undefined" || sRPTTermID.length == 0) return;
		//frames['myiframe0'].document.getElementById('ContentFrame_RPTPart').style.display="";
		OpenPage("/Accounting/LoanSimulation/LoanTerm/BusinessTermView.jsp?TermID="+sRPTTermID,"RPTPart","");
	}
	
	/*~[Describe=�б���ʽ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewTermList(functionID,termType,frameName){
		var obj = frames['myiframe0'].document.getElementById("ContentFrame_"+frameName);
		if(typeof(obj) == "undefined" || obj == null) return;
		OpenPage("/Accounting/LoanSimulation/LoanTerm/BusinessTermList.jsp?TermType="+termType,frameName,"");
	}
	
	function runTransaction1(transactionSerialNo){
		var returnValue = PopPage("/Accounting/LoanSimulation/LoanTerm/RunTransaction.jsp?TransactionSerialNo="+transactionSerialNo+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("����ִ�гɹ���");
		reloadSelf();
	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/LoanTerm/RunTransaction.jsp?TransDate="+transDate+"TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("����ִ�гɹ���");
		reloadSelf();
	}
	
	