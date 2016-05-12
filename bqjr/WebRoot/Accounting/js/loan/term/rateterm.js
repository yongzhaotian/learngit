function calcBusinessRate(currency){
	var businessRate=getItemValue(0,getRow(),"BusinessRate");

	calcBaseRate(currency);
   	var baseRate = getItemValue(0,getRow(),"BaseRate");
   	if(typeof(baseRate) == "undefined" || baseRate == "" || baseRate == 0){
   		return;
   	}
   	var rateFloatType = getItemValue(0,getRow(),"RateFloatType");
   	if(typeof(rateFloatType) == "undefined" || rateFloatType.length == 0){
   		return;
   	}
   	var rateFloat = getItemValue(0,getRow(),"RateFloat");
   	var loanRate = getLoanExecuteRate(baseRate*1.0,rateFloatType+"",rateFloat*1.0);
   	if(typeof(loanRate) == "undefined" || loanRate.length == 0){
   		alert("未获取到执行利率！");
   		return;
   	}
	if(loanRate<0){
		alert("输入的执行利率不能小于0！");
		return;
	}
   	setItemValue(0,getRow(),"BusinessRate",loanRate.toFixed(14));
}

//计算基准利率，需页面录入开始时间、结束时间、基准利率类型
function calcBaseRate(currency){
	var objectType = getItemValue(0,getRow(),"ObjectType");
	var objectNo = getItemValue(0,getRow(),"ObjectNo");
	var baseRateType = getItemValue(0,getRow(),"BaseRateType");
	var rateUnit = getItemValue(0,getRow(),"RateUnit");
	var baseRateGrade = getItemValue(0,getRow(),"BaseRateGrade");
	if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
	if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
	var baseRate = RunMethod("BusinessManage","GetBaseRateByTerm",objectType+","+objectNo+","+baseRateType+","+rateUnit+","+baseRateGrade+","+currency);
	if(baseRate==0 || baseRate.length==0){
		alert("请检查是否已经维护基准利率！");
		return;
	}
	setItemValue(0,getRow(),"BaseRate",baseRate);
}

function calcBaseRateNew(currency){
	var objectType = getItemValue(0,getRow(),"ObjectType");
	var objectNo = getItemValue(0,getRow(),"ObjectNo");
	var baseRateType = getItemValue(0,getRow(),"BaseRateType");
	var rateUnit = getItemValue(0,getRow(),"RateUnit");
	var baseRateGrade = getItemValue(0,getRow(),"BaseRateGrade");
	if(typeof(baseRateType) == "undefined" || baseRateType == "" || baseRateType == null)return;
	if(typeof(baseRateGrade) == "undefined" || baseRateGrade == "" || baseRateGrade == null)return;
	var baseRate = RunMethod("BusinessManage","GetBaseRateByTerm",objectType+","+objectNo+","+baseRateType+","+rateUnit+","+baseRateGrade+","+currency);
	if(baseRate==0 || baseRate.length==0){
		alert("请检查是否已经维护基准利率！");
		return;
	}
	return baseRate;
}

function getLoanExecuteRate(baseRate,rateFloatType,rateFloat){
	if(rateFloatType == "0" || rateFloatType == 0){
		return baseRate*(1.0+rateFloat/100.0);
	}else if(rateFloatType == "1" || rateFloatType == 1){
		return baseRate+rateFloat/100.0;
	}else{
		return baseRate;
	}
	
}

//动态显示基准利率档次选项
function showBaseRateGradeOption()
{
	var flag = true;
	var obj = window.frames["myiframe0"].document.getElementById("R0F"+getColIndex(0,"BaseRateGrade"));
	if(typeof(obj) == "undefined" || obj == null)return;
	var sBaseRateType = getItemValue(0,getRow(),"BaseRateType");
	var sBaseRateGrade = getItemValue(0,getRow(),"BaseRateGrade");
	if(typeof(sBaseRateType) == "undefined" || sBaseRateType.length == 0) return;
	window.frames["myiframe0"].document.getElementById("R0F"+getColIndex(0,"BaseRateGrade")).options[0] = new Option("","");
	window.frames["myiframe0"].document.getElementById("R0F"+getColIndex(0,"BaseRateGrade")).length = 1;
	var m = 1;
	for(var i = 0 ; i < rateArray.length; i++)
	{
		if(rateArray[i][0] == sBaseRateType)
		{
			window.frames["myiframe0"].document.getElementById("R0F"+getColIndex(0,"BaseRateGrade")).options[m++] = new Option(rateArray[i][2],rateArray[i][1]);
			if(sBaseRateGrade == rateArray[i][1])
			{
				flag = false;
			}
		}
	}
	if(flag)
	{
		setItemValue(0,getRow(),"BaseRateGrade","");
	}
	else
	{
		setItemValue(0,getRow(),"BaseRateGrade",sBaseRateGrade);
	}

	if(rightType != "ReadOnly")
	{
		var sBaseRateGrade=RunMethod("BusinessManage","GetBaseRateGrade",currency+","+sBaseRateType+",020,"+termMonth+","+businessDate);
		if(!(typeof(sBaseRateGrade) == "undefined" || sBaseRateGrade.length == 0)){
			setItemValue(0,getRow(),"BaseRateGrade",sBaseRateGrade);
			setItemDisabled(0,getRow(),"BaseRateGrade",true);
			calcBusinessRate(currency);
		}
	}
}

//页面初始化加载
showBaseRateGradeOption();