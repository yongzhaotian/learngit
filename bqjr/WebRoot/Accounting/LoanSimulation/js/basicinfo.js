	/*~[Describe=利率信息;InputParam=无;OutPutParam=无;]~*/
	function calcLoanRateTermID(functionID){
		var loanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
		if(typeof(loanRateTermID) == "undefined" || loanRateTermID.length == 0) return;
		//window.frames['myiframe0'].document.getElementById('ContentFrame_RatePart').style.display="";
		var currency = getItemValue(0,getRow(),"BusinessCurrency");
		if(typeof(currency) == "undefined" || currency.length == 0)
		 	currency = getItemValue(0,getRow(),"Currency");
		if(typeof(currency) == "undefined" || currency.length == 0) currency = "";
		
		var sPutoutDate = getItemValue(0,getRow(),"PutOutDate");
		var sMaturity = getItemValue(0,getRow(),"Maturity"); //类型为BusinessPutOut时
		var sMaturityDate = getItemValue(0,getRow(),"MaturityDate"); //类型为Loan时，即点完咨询后
		if(typeof(sMaturity)=="undefined" || sMaturity.length==0)
			sMaturity = sMaturityDate;
		var termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturity);
		
		OpenPage("/Accounting/LoanSimulation/LoanTerm/BusinessTermView.jsp?TermID="+loanRateTermID+"&TermMonth="+termMonth+"&Currency="+currency,"RatePart","");
	}
	
	/*~[Describe=还款方式信息;InputParam=无;OutPutParam=无;]~*/
	function calcRPTTermID(functionID){
		var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
		if(typeof(sRPTTermID) == "undefined" || sRPTTermID.length == 0) return;
		//frames['myiframe0'].document.getElementById('ContentFrame_RPTPart').style.display="";
		OpenPage("/Accounting/LoanSimulation/LoanTerm/BusinessTermView.jsp?TermID="+sRPTTermID,"RPTPart","");
	}
	
	/*~[Describe=列表形式的组件信息;InputParam=无;OutPutParam=无;]~*/
	function viewTermList(functionID,termType,frameName){
		var obj = frames['myiframe0'].document.getElementById("ContentFrame_"+frameName);
		if(typeof(obj) == "undefined" || obj == null) return;
		OpenPage("/Accounting/LoanSimulation/LoanTerm/BusinessTermList.jsp?TermType="+termType,frameName,"");
	}
	
	function runTransaction1(transactionSerialNo){
		var returnValue = PopPage("/Accounting/LoanSimulation/LoanTerm/RunTransaction.jsp?TransactionSerialNo="+transactionSerialNo+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("交易执行成功！");
		reloadSelf();
	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/LoanTerm/RunTransaction.jsp?TransDate="+transDate+"TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("交易执行成功！");
		reloadSelf();
	}
	
	