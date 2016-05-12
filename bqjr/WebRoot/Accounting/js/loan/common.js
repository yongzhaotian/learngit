/*~[Describe=查询利率调整方式;InputParam=无;OutPutParam=无;]~*/
	function selectRepriceInfo(){
		var sResult = getItemValue(0,getRow(),"RepriceType");
		if("7"==sResult){
			setItemDisabled(0,getRow(),"RepriceCyc",true);
			setItemDisabled(0,getRow(),"RepriceDate",true);
			setItemDisabled(0,getRow(),"RepriceFlag",true);
			setItemValue(0,getRow(),"RepriceCyc","");
			setItemValue(0,getRow(),"RepriceDate","");
			setItemValue(0,getRow(),"RepriceFlag","");
			//setItemUnit(0,getRow(),"RepriceDate","");
			return;
		}else if("8"!=sResult){
			setItemDisabled(0,getRow(),"RepriceCyc",true);
			setItemDisabled(0,getRow(),"RepriceDate",true);
			setItemDisabled(0,getRow(),"RepriceFlag",true);
			setItemValue(0,getRow(),"RepriceCyc","");
			setItemValue(0,getRow(),"RepriceDate","");
			setItemValue(0,getRow(),"RepriceFlag","");
			//setItemUnit(0,getRow(),"RepriceDate","");
			return;
		}else{
			setItemDisabled(0,getRow(),"RepriceCyc",false);
			setItemDisabled(0,getRow(),"RepriceDate",false);
			setItemDisabled(0,getRow(),"RepriceFlag",false);
			//setItemUnit(0,getRow(),"RepriceDate","<input class=inputdate type=button value=... onClick=parent.selectDate(\"RepriceDate\");>");
			return;
		}
	}
	
	/*~[Describe=计算到期日;InputParam=无;OutPutParam=无;]~*/
	function CalcMaturity(){
		var sMaturity ="";
		var sLoanTermFlag ="";
		var sTermMonth = getItemValue(0,getRow(),"TermMonth");
		var sTermDay = getItemValue(0,getRow(),"TermDay");
		var sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 || typeof(sPutOutDate)=="undefined" || sPutOutDate.length == 0 || typeof(sTermDay)== "undefined" || sTermDay.length == 0) {
			return ;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate); 
		   setItemValue(0,getRow(),"Maturity",sMaturity);
		}
		if(sTermDay !=0){
		   sLoanTermFlag ="010";
		   sBusinessDate = getItemValue(0,getRow(),"Maturity");
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermDay+","+sBusinessDate); 
		}
        setItemValue(0,getRow(),"Maturity",sMaturity);
	}