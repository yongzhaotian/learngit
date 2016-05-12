	function saveSubItem()
	{
		try{
			if(myiframe0.RPTPart.vI_all("myiframe0")){
				var status = myiframe0.RPTPart.saveRecord();
				if(!status)return false;
			}else return false;
		}catch(e){
			
		}
		try{
			if(myiframe0.RatePart.vI_all("myiframe0"))
				return myiframe0.RatePart.saveRecord();
			else
				return false;
		}catch(e){
			
		}
		
		return true;
	}
	function afterLoad(objectType,objectNo)
	{
		calcLoanRateTermID(objectType,objectNo);
		calcRPTTermID(objectType,objectNo);
		calcDRPTTermID(objectType,objectNo);
		calcFINTermID(objectType,objectNo);
		calcSPTTermID(objectType,objectNo);
		calcFEETermID(objectType,objectNo);
		viewAccountInfo(objectType,objectNo);
		viewPaymentBill(objectType,objectNo);
	}
	
	
	/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcLoanRateTermID(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_RatePart');
		if(typeof(obj) == "undefined" || obj == null) return;
		var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
		if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID==null||sLoanRateTermID.length == 0) return;
		var currency = getItemValue(0,getRow(),"BusinessCurrency");
		if(typeof(currency) == "undefined" ||currency==null|| currency.length == 0)
		 	currency = getItemValue(0,getRow(),"Currency");
		if(typeof(currency) == "undefined" || currency==null||currency.length == 0) currency = "";
		if(sLoanRateTermID == "RAT002")
		{
			setItemValue(0,getRow(),"RepriceType","7");
			try{
				setItemDisabled(0,getRow(),"RepriceType",true);
			}
			catch(e){}
		}else{
			try{
				setItemDisabled(0,getRow(),"RepriceType",false);
			}
			catch(e){}
		}
		var termMonth=getItemValue(0,getRow(),"TermMonth");
		var termDay=getItemValue(0,getRow(),"TermDay");
		if(!(typeof(termDay) == "undefined" || termDay==null||termDay.length == 0||termDay==0)){
			termMonth=termMonth+1;
		}
		
		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Status=0&ToInheritObj=y&termMonth="+termMonth+"&ObjectType="+objectType+"&ObjectNo="+objectNo+"&TermID="+sLoanRateTermID+"&Currency="+currency,"RatePart","");
	}
	/*~[Describe=���ʽ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcRPTTermID(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_RPTPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
		if(typeof(sRPTTermID) == "undefined" ||sRPTTermID==null|| sRPTTermID.length == 0) return;
		if(sRPTTermID=="RPT20"){
			var businessSum=getItemValue(0,getRow(),"BusinessSum");
			if (typeof(businessSum)=="undefined" || businessSum.length==0||businessSum==0||businessSum==null){
				alert("����¼�������!");
				return;
			}
			var putOutDate="";
			var maturity="";
			if("PutOutApply"==objectType){
				 putOutDate=getItemValue(0,getRow(),"PutOutDate");
				 maturity=getItemValue(0,getRow(),"Maturity");
			}else{
				var termMonth=getItemValue(0,getRow(),"TermMonth");
				if(!(typeof(termMonth) == "undefined" || termMonth==null||termMonth.length == 0||termMonth==0)){
					var termMonthFlag ="020";
					 putOutDate=businessDate;
					 maturity=RunMethod("BusinessManage","CalcMaturity",termMonthFlag+","+termMonth+","+putOutDate);
					var termDay=getItemValue(0,getRow(),"TermDay");
					if(!(typeof(termDay) == "undefined" || termDay==null||termDay.length == 0||termDay==0)){
						var termDayFlag ="010";
						maturity=RunMethod("BusinessManage","CalcMaturity",termDayFlag+","+termDay+","+maturity);
					}
				}		
			}
			if ((typeof(putOutDate)=="undefined" || putOutDate.length==0||putOutDate==0||putOutDate==null)
					||(typeof(maturity)=="undefined" ||maturity.length==0||maturity==0||maturity==null)
					||maturity==putOutDate){
				alert("����¼��������޻�����!");
				return;
			}
			OpenComp("RPTTermList","/Accounting/LoanDetail/LoanTerm/RPTTermList.jsp","Status=0&ToInheritObj=y&Maturity="+maturity+"&PutOutDate="+putOutDate+"&BusinessSum="+businessSum+"&ObjectType="+objectType+"&ObjectNo="+objectNo+"&TermID="+sRPTTermID,"RPTPart","");
		}else{
			OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Status=0&ToInheritObj=y&ObjectType="+objectType+"&ObjectNo="+objectNo+"&TermID="+sRPTTermID,"RPTPart","");
		}
	}
	
	/*~[Describe=Լ��������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcDRPTTermID(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_DRPTPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
		if(typeof(sRPTTermID) == "undefined" || sRPTTermID==null||sRPTTermID.length == 0) return;
		//frames['myiframe0'].document.getElementById('ContentFrame_RPTPart').style.display="";
		OpenComp("DRPTList","/Accounting/LoanDetail/LoanTerm/DRPTList.jsp","ToInheritObj=y&ObjectType="+objectType+"&ObjectNo="+objectNo,"DRPTPart","");
	}
	
	/*~[Describe=��Ϣ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcFINTermID(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_FINPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		OpenComp("FinTermList","/Accounting/LoanDetail/LoanTerm/FinTermList.jsp","Status=0&ToInheritObj=y&ObjectType="+objectType+"&ObjectNo="+objectNo,"FINPart","");
	}
	
	/*~[Describe=��Ϣ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcSPTTermID(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_SPTPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		OpenComp("BusinessTermList","/Accounting/LoanDetail/LoanTerm/BusinessTermList.jsp","Status=0&ToInheritObj=y&ObjectType="+objectType+"&ObjectNo="+objectNo+"&TempletNo=SPTSegmentList&TermType=SPT","SPTPart","");
	}
	
	/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcFEETermID(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_FEEPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectType="+objectType+"&ObjectNo="+objectNo+"&TransCode=0020","FEEPart","");
	}
	
	/*~[Describe=�˻���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewAccountInfo(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_AccountsPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		OpenComp("DepositAccountsList","/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp","Status=0&ToInheritObj=y&ObjectType="+objectType+"&ObjectNo="+objectNo,"AccountsPart","");
	}
	
	/*~[Describe=֧����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewPaymentBill(objectType,objectNo){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_PaymentBill');
		if(typeof(obj) == "undefined" || obj == null) return;
		OpenComp("PaymentBillList","/Accounting/LoanDetail/LoanTerm/PaymentBillList.jsp","ObjectNo="+objectNo+"&ToInheritObj=y&ObjectType="+objectType,"PaymentBill","");
	}
	
	/*~[Describe=����ƻ���ѯ;InputParam=��;OutPutParam=��;]~*/
	function Simulation(objectType,objectNo,rightType)
	{
		var tempSaveFlag = getItemValue(0,getRow(),'TempSaveFlag');
		if(tempSaveFlag != "2")
		{
			alert("���ȱ������ݣ�");
			return;
		}
		var vRPTTermID = getItemValue(0,getRow(),'RPTTermID');
		if(typeof(vRPTTermID)=="undefined" || vRPTTermID.length == 0){
			alert("ȱ�ٻ��������Ϣ��");
			return;
		}
		PopComp("SimulationPaymentSchedule","/Accounting/Transaction/SimulationPaymentSchedule.jsp","ObjectType="+objectType+"&ObjectNo="+objectNo+"&RightType="+rightType,"");
	}