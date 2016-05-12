var vCheckItem = false;
var vCheckStatus = false;
var vItemStatus1 = true,vItemStatus2 = true;

function setItemStatus()
{
	vItemStatus1 = vItemStatus2;
}

function checkStatus(obj)
{
	if(vCheckStatus)
	{
		vCheckItem = true;
		vCheckStatus = false;
		obj.focus();
		if(vItemStatus1 != vItemStatus2)
		{
			vCheckItem = false;
			vItemStatus1 = vItemStatus2;
		}
	}
}

//默认规则：可为空或者为数字
function checkCommon(obj, vFormatType)
{
	vItemStatus1 = !vItemStatus1;
	
	if(vCheckItem)
	{
		vCheckItem = false;
		return false;
	}
	
	var vObjCaption = getCaptionObjValue(obj.name+"_caption");
	
	if(obj.value.length == 0)
	{
		vCheckStatus = false;
		return true;
	}
	
	var vObjValue = obj.value;
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/ /g,'');
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/,/g,'');
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/%/g,'');
	
	if(isNaN(vObjValue))
	{
		alert('"' + vObjCaption + '"只接受数字，请重新输入！');
		vCheckStatus = true;
		return false;
	}
	
	applyFormat(obj, vFormatType);
	vCheckStatus = false;
	return true;
}

//只检测输入值正确与否，不置状态
function checkOnly(obj)
{
	var vObjCaption = getCaptionObjValue(obj.name+"_caption");
	
	if(obj.value.length == 0)
	{
		return true;
	}
	
	//var vObjValue = obj.value.replace(/,/g,'').replace(/%/g,'');
	var vObjValue = obj.value;
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/ /g,'');
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/,/g,'');
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/%/g,'');
	
	if(isNaN(vObjValue))
	{
		alert('"' + vObjCaption + '"只接受数字，请重新输入！');
		return false;
	}
	
	return true;
}

function getCaptionObjValue(objname)
{
	return document.forms["report"].elements[objname].value;
}

function getSubItemName(objInnerCode)
{
	return document.forms["report"].elements[objInnerCode].value;
}

function getSubItemValue(objName)
{
	var vSubItemValue = document.forms["report"].elements[objName].value;
	if(vSubItemValue.length == 0)
		return 0;
	else
		return vSubItemValue;
}

function formatNumber(vNumber)
{
	if(!isNaN(vNumber))
	{
		//add by hxd in 2004/03/17 for kick ,
		if(vNumber.length > 0)
			vNumber = vNumber.replace(/ /g,'');
		if(vNumber.length > 0)
			vNumber = vNumber.replace(/,/g,'');
		
		var vIndex = vNumber.toString().indexOf(".");
		if(vIndex > 0)
		{
			var vInteger = vNumber.toString().substring(0,vIndex);
			var vFraction = vNumber.toString().substring(vIndex + 1);
			return formatWithComma(vInteger) + "." + vFraction; 
		}
		else
		{
			return formatWithComma(vNumber);
		}
	}
	else
		return "";
}

function formatWithComma(vSource)
{
	var vSign;
	if(vSource < 0)
	{
		vSign = "-";
		vSource = Math.abs(vSource);
	}
	else
		vSign = "";
	
	var vCommaCount = Math.floor(vSource.toString().length / 3);
	if(parseInt(vSource.toString().length) == 3*parseInt(vCommaCount))
		vCommaCount = vCommaCount - 1;
	
	var vFirstLen = vSource.toString().length - 3*vCommaCount;
	for(var i=1; i<=vCommaCount; i++)
	{
		var vFrontLen = vFirstLen + (i - 1)*4;
		vSource = vSource.toString().substring(0,vFrontLen) + "," + vSource.toString().substring(vFrontLen);
	}
	return vSign + vSource;
}

function formatPercent(vNumber)
{
	vNumber = vNumber.replace(/ /g,'');
	var vIndex = vNumber.toString().indexOf("%");
	if(vIndex >= 0)
	{
		return formatWithFraction(stringToNumber(vNumber)*100) + "%";
	}
	else if(vNumber.length == 0)
		return "";
	else if(!isNaN(vNumber))
	{
		if(vNumber == 0)
			return "0.00%";
		return formatWithFraction(vNumber*100) + "%";
	}
	else
		return "";
}

function formatWithFraction(vSource)
{
	return parseFloat(vSource).toPrecision(Math.floor(Math.abs(parseFloat(vSource))).toString().length + 2);
}

function applyFormat(obj, vFormatType)
{
	//add by hxd in 2004/03/17 for kick ,
	var vObjValue = obj.value;
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/ /g,'');
	if(vObjValue.length > 0)
		vObjValue = vObjValue.replace(/,/g,'');
	
	//一般形式，三位一逗
	if(vFormatType == "1")
	{
		if(!isNaN(vObjValue))
		{
			vObjValue = formatWithFraction(vObjValue);
			obj.value = formatNumber(vObjValue);
		}
	}
	else if(vFormatType == "2")
		obj.value = formatPercent(vObjValue);
}

function stringToNumber(vString)
{
	if(vString.length > 0)
		vString = vString.replace(/ /g,'');
	if(vString.length > 0)
		vString = vString.replace(/,/g,'');
	if(vString.length == 0)
		return 0;
	var vIndex = vString.toString().indexOf("%");
	var vTemp;
	if(vIndex > 0)
	{
		vTemp = vString.toString().substring(0,vIndex);
		return parseFloat(vTemp) / 100;
	}
	else
		return parseFloat(vString);
}


var vCurClassName = "";
function setHighLight(obj)
{
	vCurClassName = obj.className;
	obj.className = "FSHighLightInput";
	if(obj.value == "0.00"||obj.value == "0.0000"||obj.value == "0.00000") //高亮的数值为0时，清空，方便录入
		obj.value = "";
}
//2010/07/22增加了3个参数，配合财务报表的精度进行还原
function unsetHighLight(obj,sReportName,sReportUnitName)
{
	obj.className = vCurClassName;
    if(parseFloat(obj.value) == parseFloat(0) || obj.value == ""){
    	if(sReportUnitName == "元"){
    		obj.value = "0.00";
    	}else if(sReportUnitName == "千元"){
    		if(sReportName.indexOf("指标表") > -1){
    			obj.value = "0.00";
    		}else{
    			obj.value = "0.0000";
    		}
    	}else{
    		if(sReportName.indexOf("指标表") > -1){
    			obj.value = "0.00";
    		}else{
    			obj.value = "0.00000";
    		}
    	}
    }
}
