	function selectOrgID(){
		var sOrgInfo = PopPage("/FixStat/SelectOrgID.jsp?rand="+randomNumber(),"","dialogWidth=320px;dialogHeight=400px;center:yes;status:no;statusbar:no");
		if(typeof(sOrgInfo)!="undefined"){
			if(sOrgInfo=="_NONE_"){
				document.item.OrgID.value = "";
				document.item.OrgName.value = "ÇëÑ¡Ôñ»ú¹¹";
			}else if(sOrgInfo!=""){
				var sInfoDetail = sOrgInfo.split('@');
				document.item.OrgID.value=sInfoDetail[0];
				document.item.OrgName.value=sInfoDetail[1];
			}
		}
	}

	function selectDate(){
		var sDate = PopPage("/FixStat/SelectDate.jsp?rand="+randomNumber(),"","dialogWidth=300px;dialogHeight=220px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sDate)!="undefined"){
			document.item.InputDate.value=sDate;
		}
	}

	function selectMonth(){
		var sMonth = PopPage("/FixStat/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=280px;dialogHeight=200px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sMonth)!="undefined"){
			document.item.InputDate.value=sMonth;
		}
	}

	function selectQuarter(){
		var sQuarter = PopPage("/FixStat/SelectQuarter.jsp?rand="+randomNumber(),"","dialogWidth=280px;dialogHeight=200px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sQuarter)!="undefined"){
			document.item.InputDate.value=sQuarter;
		}
	}
	
	function SelectHalfYear(){
		var sHalfYear = PopPage("/FixStat/SelectHalfYear.jsp?rand="+randomNumber(),"","dialogWidth=280px;dialogHeight=200px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sHalfYear)!="undefined"){
			document.item.InputDate.value=sHalfYear;
		}
	}
	
	function selectYear(){
		var sYear = PopPage("/FixStat/SelectYearEnd.jsp?rand="+randomNumber(),"","dialogWidth=280px;dialogHeight=200px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sYear)!="undefined"){
			document.item.InputDate.value=sYear;
		}
	}
