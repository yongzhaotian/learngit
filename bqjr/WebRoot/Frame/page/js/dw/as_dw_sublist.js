var _user_validator = new Array();//保存验证规则
var _user_valid_errors = new Array();
var filterNames = new Array();
var aDWfilterTitles = new Array();
var aDWResultInfo = new Array();
var aDWResultError = new Array();
TableFactory.ColValidInfo = new Array();//是否只读
TableFactory.FilterConditions = new Array();//过滤条件
TableFactory.OldRowCount = -1;
TableFactory.ExportArgValues;
TableFactory.FilterCheckBoxWidth = "200px";
TableFactory.CheckBoxDisplayMax = 6; 
TableFactory.ExportDataObject;
TableFactory.SortParams;
var PageQueryString = new Array();//保存本页面request参数
var SAVE_TMP = false;
var DisplayDONO = "";//用于debug条获取dono
var iOverDWHandler;
var as_dw_sMessage = "";
var as_dw_sPostEvent = "";
var v_g_DWIsSerializJbo = "0";//是否需要序列化
var bDWConvertCode = false;//是否将代码转换成标题
var DWFullFiterButtons = "";//多搜索按钮组代码
var DWFullFiterButtons2 = "";//搜索区域按钮组代码
var bListFuzzyQuery = false;//是否支持模糊查询匹配 
//var dwTime = new Array();
//如果是保存则验证非空,如果暂存则不验证
jQuery.validator.addMethod("required0",function(value,element,param){
	if(SAVE_TMP==true){
		return true;
	}
	else{
		if ( !this.depend(param, element) )
			return "dependency-mismatch";
		switch( element.nodeName.toLowerCase() ) {
		case 'select':
			var options = $("option:selected", element);
			return options.length > 0 && ( element.type == "select-multiple" || (/msie/.test(navigator.userAgent.toLowerCase()) && !(options[0].attributes['value'].specified) ? options[0].text : options[0].value).length > 0);
		case 'input':
			if ( this.checkable(element) )
				return this.getLength(value, element) > 0;
		default:
			return $.trim(value).length > 0;
		}
	}
});

function getFilterIndexByName(tableIndex,name){
	for(var i=0;i<filterNames[tableIndex].length;i++){
		if(filterNames[tableIndex][i].toUpperCase() == name.toUpperCase())
			return i;
	}
	return 0;
}

function tableSearchFromInput(obj,from,params,clearSort){
	TablePage.from = from;
	var tableIndex = 0;
	if(jQuery.isFunction(window.validFilter)){
		if(validFilter()==false){
			return false;
		}
	}
	if(obj){
		tableIndex = obj.parentNode.getAttribute("tableId").substring(8);
	}
	s_r_c[tableIndex]=-1;
	openDWDialog();
	if(clearSort)TableFactory.SortParams="";
	TableFactory.search(tableIndex,params,v_g_DWIsSerializJbo,undefined,from);
	autoCloseDWDialog();
	if(obj){
		obj.parentNode.style.display='none';
	}
	return true;
}
function setFilterCondition(dwname,colname,condition){
	TableFactory.FilterConditions[colname.toUpperCase()] = condition;
}
TableFactory.SelectGridValue = function(colname,objname,sDoNo, sArgs, sFields, sSelected, isMulti){
	if(sFields.indexOf("=") > -1){
		return TableFactory.SetGridValue(colname,objname,sDoNo, sArgs, sFields);
	}
	return AsControl.PopComp("/Frame/page/tools/SelectDialog.jsp", "SelectDialogUrl=/Frame/page/tools/SelectGridDialog.jsp&append=true&IsMulti=true&DoNo="+sDoNo+"&Parameters="+sArgs+"&Fields="+sFields+"&Selected="+sSelected+"&IsMulti="+isMulti, "dialogWidth=600px;dialogHeight=500px;resizable=no;maximize:yes;help:no;status:no;");
};
TableFactory.SetGridValue = function(colname,objname,sDoNo, sArgs, sFieldValues, sSelected){
	var obj = document.getElementsByName(objname)[0];
	var titleobj = document.getElementsByName(objname+"_TITLE")[0];
	if(sFieldValues.indexOf("=") < 0){
		return this.SetGridValue(colname,objname,sDoNo, sArgs, sFieldValues, sSelected, false);
	}
	else{
		fields = sFieldValues.split("=")[1];
	}
	var sReturn = TableFactory.SelectGridValue(colname,objname,sDoNo, sArgs, fields, sSelected, false);
	if(!sReturn) return;
	if(sReturn == "_CLEAR_"){
		obj.value = "";
		titleobj.value = "";//titleobj.innerHTML = "";
		filterTitles["myiframe0"][colname]="";
		obj.fireEvent("onchange");
	}else{
		//alert("sReturn="+ sReturn[1]);
		var valueTitleArray = "";
		if(typeof(sReturn)=="string"){
			valueTitleArray = sReturn.split("~");
		}
		else{
			valueTitleArray = sReturn[1].split("~");
		}
		var sValueString="";
		var sTitleString = "";
		for(var i=0;i<valueTitleArray.length;i++){
			var sValueAndTitle = valueTitleArray[i].split("@");
			if(i==0){
				sValueString =  sValueAndTitle[0];
				sTitleString =  sValueAndTitle[1];//sValueAndTitle[1] + "("+sValueAndTitle[0]+")";
			}
			else{
				sValueString +=  "|" + sValueAndTitle[0];
				sTitleString +=  "|" + sValueAndTitle[1];//"|" + sValueAndTitle[1] + "("+sValueAndTitle[0]+")";
			}
		}
		if(typeof(sReturn)=="string" || obj.value==""){
			obj.value = sValueString;
			filterTitles["myiframe0"][colname]=sTitleString;
			titleobj.value = sTitleString;
			obj.fireEvent("onchange");
		}
		else{
			obj.value += "|" + sValueString;
			filterTitles["myiframe0"][colname]+="|" +sTitleString;
			titleobj.value += "|" + sTitleString;
			obj.fireEvent("onchange");
		}
		if(valueTitleArray.length>0){
			setFilterAreaOption(0,colname,"In");
		}
	}
	return sReturn;
};
function setFilterAreaValue(dwname,colName,value,index){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	var iColIndex = getColIndex(tableIndex,colName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iColIndex); 
	if(index==undefined)index=0;
	var inputName = "DOFILTER_DF_"+colName.toUpperCase()+"_"+(index+1)+"_VALUE";
	var objs = document.getElementsByName(inputName);
	if(objs){
		if(objs[0].type=='checkbox'){
			for(var i=0;i<objs.length;i++){
				if( TableBuilder.isStrInArray(value.split(","),objs[i].value)>-1 )
					objs[i].checked = true;
				else
					objs[i].checked = false;
			}
		}
		else{
			objs[0].value = value;
		}
		if(DZ[tableIndex][1][iColIndex][2]=='1'){
			if(index==0)
				filterValues[tableId][iTableColIndex]=value;
			else
				filterValues2[tableId][iColIndex]=value;
		}
		else{
			filterHiddenValues[tableId][DZ[tableIndex][1][iColIndex][15]]= value;
		}
	}
}
function getFilterAreaValue(dwname,colName,index){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	if(index==undefined)index=0;
	var inputName = "DOFILTER_DF_"+colName.toUpperCase()+"_"+(index+1)+"_VALUE";
	var objs = document.getElementsByName(inputName);
	if(objs){
		if(objs[0].type=='checkbox'){
			var result = "";
			for(var i=0;i<objs.length;i++){
				if(objs[i].checked)
					result += "," + objs[i].value;
			}
			if(result=="")
				return "";
			else
				return result.substring(1);
		}
		else{
			return objs[0].value;
		}
	}
	return "";
}
function setFilterAreaOption(dwname,colName,value){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	var iColIndex = getColIndex(tableIndex,colName);
	var inputName = "DOFILTER_DF_"+colName.toUpperCase()+"_1_OP";
	var objs = document.getElementsByName(inputName);
	if(objs && objs[0]){
		objs[0].value = value;
		filterOptions[tableId][iColIndex] = value;
		var objx = document.getElementById('SPVAL2_'+tableId+'_'+iColIndex+'');
		if(objx){
			if(value=="Area"){
				objx.style.display = "inline";
			}
			else{
				objx.style.display = "none";
			}
		}
		
	}
}
function getFilterAreaOption(dwname,colName){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	var inputName = "DOFILTER_DF_"+colName.toUpperCase()+"_1_OP";
	var objs = document.getElementsByName(inputName);
	if(objs && objs[0]){
		return objs[0].value;
	}
	return "";
}
function submitFilterArea(params){
	if(tableSearchFromInput(undefined,'fromarea',params)){
		openFilterArea('TableFilter_AREA',0,event);
		closeFullFilter(0,event);
		hideFilterArea(event);
		if(window.afterSubmitFilter){
			afterSubmitFilter();
		}
	}
}
function getFilterAreaInput(dwname,colName,index){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	if(index==undefined)index=0;
	var inputName = "DOFILTER_DF_"+colName.toUpperCase()+"_"+(index+1)+"_VALUE";
	var objs = document.getElementsByName(inputName);
	if(objs){
		if(objs[0].type=='checkbox'){
			return objs;
		}
		else{
			return objs[0];
		}
	}
	return null;
}

function getColIndex(dwname,sCol){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var iDW = dwname.substring(8);
	for(var i=0;i<DZ[iDW][1].length;i++)
	{
		if(DZ[iDW][1][i][15].toUpperCase()==sCol.toUpperCase()) return i;
	};
	return -1;
}

function getLockAreaWidths(tableId){
	return TableBuilder.getLockAreaWidths(tableId);
}
function iV_all(dwname){
	if(beforeCheck(dwname)==false)return false;
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	TableFactory.ColValidInfo[tableIndex] = new Array();
	var bResult = true;
	_user_valid_errors[tableIndex] = undefined;
	if(isNaN(tableIndex))tableIndex = tableIndex.substring(8);
	var validator = _user_validator[tableIndex];
	if(validator==undefined)return true;
	var form = $("#listvalid" +tableIndex );
	var element = document.getElementById("element_listvalid" + tableIndex);
	var rules = validator.rules;
	var ii = 1;
	
	for(sColName in rules){//sColName为字段名
		
		var colValidators = rules[sColName];
		for(method in colValidators){
			rule = { method: method, parameters: colValidators[method] };
			//逐行获得数据值
			var iDataSize = DZ[tableIndex][2].length;
			//alert("rule.parameters=" + rule.parameters);
			for(var i=0;i<iDataSize;i++){
				//alert("sColName=" + sColName);
				var sColValue = getItemValue(tableIndex,i,sColName);//获得字段值
				sColValue = sColValue.replace(/\r/g, "");
				element.value = sColValue;
				var bValid = false;
				if(rule.parameters.length==2 && rule.parameters[0].substring(0,1)=="#"){
					var iColIndexT = getColIndex(tableIndex,rule.parameters[0].substring(1));
					var iColIndexTForTable = TableFactory.getTableColIndexFromDZ(dwname,iColIndexT);
					var myruleparams = ["#INPUT_"+dwname+"_"+rule.parameters[0].substring(1)+"_"+i+"_" + iColIndexT,rule.parameters[1]];
					bValid = jQuery.validator.methods[method].call( form.validate(), sColValue, element, myruleparams,i );
				}
				else
					bValid = jQuery.validator.methods[method].call( form.validate(), sColValue, element, rule.parameters,i );
				if(bValid==false){
					bResult = false;
					var iColIndex = getColIndex(tableIndex,sColName);
					var title = DZ[tableIndex][1][iColIndex][0];
					/*
					if(_user_valid_errors[tableIndex]){
						_user_valid_errors[tableIndex].append("<br>" + title + ":" + validator.messages[sColName.toUpperCase()][method] + "[第" + (i+1) +"行]");
					}
					else{
						_user_valid_errors[tableIndex] = new StringBuffer();
						_user_valid_errors[tableIndex].append(title + ":" + validator.messages[sColName.toUpperCase()][method] + "[第" + (i+1) +"行]");
					}
					*/
					if(!_user_valid_errors[tableIndex])
						_user_valid_errors[tableIndex] = new Array();
					_user_valid_errors[tableIndex][_user_valid_errors[tableIndex].length]=title + ":" + validator.messages[sColName.toUpperCase()][method] + "[第" + (i+1) +"行]";
					TableFactory.ColValidInfo[tableIndex][TableFactory.ColValidInfo[tableIndex].length] = [i,sColName];
				}
			}
		}
	}
	return bResult && afterCheck(dwname);
}

function showErrors(dwname){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe" + tableIndex;
	if(_user_valid_errors==undefined || _user_valid_errors[tableIndex]==undefined)return;
	
	var list = _user_valid_errors[tableIndex];
	document.getElementById("messageBox").style.display='block';
	//document.getElementById("messageBox").style.display='none'; //信息框按需要显示
	document.getElementById("ul_error_1").innerHTML="";
	document.getElementById("ul_error_0").innerHTML="";
	var iExtCount = 8;
	if(list.length<=iExtCount){
		$("#showpart").hide();
		$("#mobtn").hide();
		$("#hidbtn").hide();
	}
		
	else{
		$("#showpart").hide();
		$("#hidbtn").hide();
	}
	for(var ii=0;ii<list.length;ii++){
		var ele_error = document.createElement("<li>");
		ele_error.innerHTML = "<a href='#'>" + list[ii] + "</a>";
		if(ii>=iExtCount){
			document.getElementById("ul_error_1").appendChild(ele_error);
		}
		else{
			document.getElementById("ul_error_0").appendChild(ele_error);
		}
	}
	
	for(var i=0;i<TableFactory.ColValidInfo[tableIndex].length;i++){
		var iColIndex = getColIndex(tableIndex,TableFactory.ColValidInfo[tableIndex][i][1]);
		var iColIndexForTable = TableFactory.getTableColIndexFromDZ(tableId,iColIndex);
		var inputs = null;
		inputs = document.getElementsByName("INPUT_" + tableId + "_" + TableFactory.ColValidInfo[tableIndex][i][1] + "_" + TableFactory.ColValidInfo[tableIndex][i][0] + "_" + iColIndexForTable);
		if(inputs){
			for(var j=0;j<inputs.length;j++){
				inputs[j].style.backgroundColor='red';
				//if(i==0 && j==0)inputs[j].focus();
				
			}
		}
	}
	
		
	
}

function showErrors0(dwname){//待删除-flian 20120511
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe" + tableIndex;
	if(_user_valid_errors==undefined || _user_valid_errors[tableIndex]==undefined)return;
	var error = _user_valid_errors[tableIndex].toString();
	error = error.replace(/<br>/g,"\n");
	alert(error);
	
	for(var i=0;i<TableFactory.ColValidInfo[tableIndex].length;i++){
		var iColIndex = getColIndex(tableIndex,TableFactory.ColValidInfo[tableIndex][i][1]);
		var iColIndexForTable = TableFactory.getTableColIndexFromDZ(tableId,iColIndex);
		var inputs = null;
		inputs = document.getElementsByName("INPUT_" + tableId + "_" + TableFactory.ColValidInfo[tableIndex][i][1] + "_" + TableFactory.ColValidInfo[tableIndex][i][0] + "_" + iColIndexForTable);
		if(inputs){
			for(var j=0;j<inputs.length;j++){
				inputs[j].style.backgroundColor='red';
				//if(i==0 && j==0)inputs[j].focus();
				
			}
		}
	}
	
}

function clearErrors(input){
	var parentNode = input.parentNode;
	for(var i=0;i<parentNode.childNodes.length;i++){
		//if(parentNode.childNodes[i].targName)
		if(parentNode.childNodes[i].tagName=='INPUT' || parentNode.childNodes[i].tagName=='SELECT' || parentNode.childNodes[i].tagName=='TEXTAREA'){
			if(parentNode.childNodes[i].style.backgroundColor=='red')
				parentNode.childNodes[i].style.removeAttribute("backgroundColor");
		}
	}
}

//设置某一列的宽度
function setColumnWidth(dwname,sColName,width){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	var iDZColIndex = getColIndex(tableIndex,sColName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex)+2;
	if(iTableColIndex>-1)
		TableBuilder.setColumnWidth(tableId,iTableColIndex,width);
	change_height();
}

//设置某一列的宽度
function getColumnWidth(dwname,sColName){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	var iDZColIndex = getColIndex(tableIndex,sColName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	if(iTableColIndex>-1)
		return TableBuilder.getColumnWidth(tableId,iTableColIndex);
	return -1;
}


function getResultInfo(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	return aDWResultInfo[tableIndex];
}
function getResultError(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	return aDWResultError[tableIndex];
}
function getResultStatus(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	if(aDWResultError[tableIndex]==null || aDWResultError[tableIndex]==undefined || aDWResultError[tableIndex]=='')
		return "success";
	else
		return "fail";
}

function getItemValue(dwname,rowindex,sColName){
	if(rowindex==-1) return undefined;
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	
	var tableId = "myiframe"+tableIndex;
	var iDZColIndex = getColIndex(tableIndex,sColName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	//alert(iTableColIndex);
	//sValue =TableBuilder.getFomatedNumber(sValue,DZ[tableIndex][1][iDZColIndex][12]) ;
	if(iTableColIndex>-1)
		return	TableBuilder.getFomatedNumber(tableDatas[tableId][rowindex][iTableColIndex],DZ[tableIndex][1][iDZColIndex][12]) ;
	else{
		try{
			return TableBuilder.getFomatedNumber(DZ[tableIndex][2][rowindex][iDZColIndex],DZ[tableIndex][1][iDZColIndex][12]) ;
		}
		catch(e){
			return "";
		}
	}
}

function setItemValue(dwname,rowindex,sColName,value){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe"+tableIndex;
	var iDZColIndex = getColIndex(tableIndex,sColName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	//alert(iTableColIndex);
	if(iTableColIndex>-1){
		tableDatas[tableId][rowindex][iTableColIndex] = value;
		var div = document.getElementById('DIV_Data_'+ tableId + "_" + rowindex + "_" + iTableColIndex);
		if(DZ[tableIndex][0][2]==0 && DZ[tableIndex][1][iDZColIndex][3]=="0"){//可编辑
			var sValue = TableBuilder.convertJS2HTML(value);
			sValue =value;
			var obj = getObj(tableIndex,rowindex,sColName);
			var inputType = TableBuilder.reviseInput(DZ[tableIndex][1][iDZColIndex][11]);
			if(inputType=="select"){
				for(var i=0;i<obj.options.length;i++){
					if(obj.options[i].value==sValue)
						obj.selectedIndex = i;
				}
			}
			else if(inputType=="radio"){
				obj = getRadios(tableIndex,rowindex,sColName);
				for(var i=0;i<obj.length;i++){
					if(obj[i].value==sValue)
						obj[i].checked = true;
					else
						obj[i].checked = false;
				}
			}
			else if(inputType=="checkbox"){
				if(sValue=="1")
					obj.checked = true;
				else
					obj.checked = false;
			}
			else{
				sValue =TableBuilder.getFomatedNumber(sValue,DZ[tableIndex][1][iDZColIndex][12]) ;
				obj.value = sValue;
			}
		}
		else{
			
			var sValue = TableBuilder.convertJS2HTML(value);
			//alert(sValue);
			//如果有取值范围要获得从取值范围中找标题
			if(DZ[tableIndex][1][iDZColIndex][20]){
				for(var i=0;i<DZ[tableIndex][1][iDZColIndex][20].length;i+=2){
					if(DZ[tableIndex][1][iDZColIndex][20][i]==sValue){
						sValue= DZ[tableIndex][1][iDZColIndex][20][i+1];
						break;
					}
				}
			}
			
			//alert(document.getElementById("INPUT_" + tableId + "_" + sColName + "_" + rowindex + "_" + iTableColIndex).outerHTML);
			var obj = getObj(tableIndex,rowindex,sColName);
			//格式化值
			sValue =TableBuilder.getFomatedNumber(sValue,DZ[tableIndex][1][iDZColIndex][12]) ;
			obj.innerHTML = sValue;
		}
	}
	
}
//设置单元格的样式
function setItemStyle(dwname,rowindex,sColName,style){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	
	var tableId = "myiframe"+tableIndex;
	var iDZColIndex = getColIndex(tableIndex,sColName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	if(iTableColIndex>-1)
		TableBuilder.setItemStyle(tableId,rowindex,iTableColIndex,style);
}

function getSelRows(tableIndex){
	var iCurrDW = "myiframe0";
	if(tableIndex)
	{
		if(!isNaN(tableIndex)) iCurrDW="myiframe"+tableIndex;
		else iCurrDW=tableIndex;
	}
	return selectedRows[iCurrDW];
}
function getCheckedRows(dwname){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var objs = document.getElementsByName("check_S_" + dwname);
	var result = new Array();
	for(var i=0;i<objs.length;i++){
		if(objs[i].checked){
			result[result.length] = i;
		}
	}
	return result;
}

function selectAllRows(dwname,value){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe" + tableIndex;
	var checkAll = document.getElementById('DW_CheckAll_' + tableId);
	checkAll.checked = value;
	TableBuilder.SelAll(tableId,checkAll);
}

function lightRow(dwname,rowIndex,evt){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	//alert(tableDatas[dwname].length);
	if(tableDatas[dwname].length==0)return;
	var rowCount = getRowCount(0);
	if(rowIndex<0) rowIndex =0;
	else if(rowIndex >=rowCount)  rowIndex = rowCount-1;
	TableBuilder.TRClick(rowIndex,undefined,"TR_Right_" + dwname + "_" + rowIndex,sWDColors[3]);
}
function selectRows(dwname,rowIndex){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	
	var tableId = "myiframe" + tableIndex;
	var checkBoxs = document.getElementsByName("check_S_" + tableId);
	for(var i=0;i<checkBoxs.length;i++){
		checkBoxs[i].checked = false;
	}
	selectedRows[tableId] = [];
	if(typeof(rowIndex)=="number"){
		selectedRows[tableId][0] = rowIndex;
		checkBoxs[rowIndex].checked = true;
	}
	else if(typeof(rowIndex)=="string"){
		rowIndex = rowIndex.split(",");
		for(var i=0;i<rowIndex.length;i++){
			selectedRows[tableId][i] = rowIndex[i];
			checkBoxs[rowIndex[i]].checked = true;
		}
	}
	else{
		if(rowIndex){
			for(var i=0;i<rowIndex.length;i++){
				selectedRows[tableId][i] = rowIndex[i];
				checkBoxs[rowIndex[i]].checked = true;
			}
		}
		
	}
	//TableBuilder.displaySelectedRowsColor(tableId,tableDatas[tableId].length,colors[3]);
}
	

function getRow(dwname) {
	var sCurrDW = "myiframe0";
	if(dwname)
	{
		if(!isNaN(dwname)) sCurrDW="myiframe"+dwname;
		else sCurrDW=dwname;
	}
	return TableBuilder.iCurrentRow[sCurrDW];	
}

function getRowCount(dwname){
	if(isNaN(dwname))dwname = dwname.substring(8);
	var tableId = "myiframe" + dwname;
	if(tableDatas[tableId])
		return tableDatas[tableId].length;
	else
		return 0;
}


//保存成功后的处理

function checkFrameReady(){
	//alert("frames[\"alsdivwin_f1\"].document.readyState = " + frames["alsdivwin_f1"].document.readyState);
	if(frames["alsdivwin_f1"].document.readyState=='complete'){
		window.clearInterval(iOverDWHandler);
		//alert(1);
		if(sPostEvent){
			frames["alsdivwin_f1"].showInfo(sMessage,'success');
			if(sPostEvent!="undefined"){
				if(sPostEvent.substring(sPostEvent.length-1,sPostEvent.length)==";")
					eval(sPostEvent);
				else
					eval("("+ sPostEvent +")");
			}
		}
		else{
			//alert(frames["alsdivwin_f1"]);
			frames["alsdivwin_f1"].showInfo(sMessage);
		}
	}
}
//保存成功后的处理
function checkFrameReady(){
	//alert("frames[\"alsdivwin_f1\"].document.readyState = " + frames["alsdivwin_f1"].document.readyState);
	if(frames["alsdivwin_f1"].document.readyState=='complete'){
		window.clearInterval(iOverDWHandler);
		//alert(1);
		if(as_dw_sPostEvent){
			frames["alsdivwin_f1"].showInfo(as_dw_sMessage,'success');
			if(as_dw_sPostEvent!="undefined"){
				if(as_dw_sPostEvent.substring(as_dw_sPostEvent.length-1,as_dw_sPostEvent.length)==";")
					eval(as_dw_sPostEvent);
				else
					eval("("+ as_dw_sPostEvent +")");
			}
		}
		else{
			//alert(frames["alsdivwin_f1"]);
			frames["alsdivwin_f1"].showInfo(as_dw_sMessage);
		}
	}
}
//保存成功后的处理
function updateSuccess(msg,postevents){
	as_dw_sMessage = msg;
	as_dw_sPostEvent = postevents;
	iOverDWHandler = window.setInterval(checkFrameReady, 5);
}
/*
function updateSuccess(msg,postevents){
	//alert(msg + "|" + postevents);
	
	$("#alsdivwin_f1 > div").ready(function() {
		//alert($("#alsdivwin_f1 > div"));
		if(postevents){
			
			frames["alsdivwin_f1"].showInfo(msg,'success');
			if(postevents==undefined) postevents = "undefined";
			if(postevents!="undefined" && postevents!="")
				eval("("+ postevents +")");
		}
		else{
			frames["alsdivwin_f1"].showInfo(msg);
		}
	});
}
*/
//获得查询条件
function getFilters(tableIndex){
	var result = "";
	//获得表格名
	var tableId = "myiframe" + tableIndex;
	//alert(filterValues[tableId].length);
	for(var i=0;i<filterValues[tableId].length;i++){
		//忽略无效值与空值
		if(!filterValues[tableId][i] || filterValues[tableId][i]=='')continue;
		//获得DZ编号 
		var iDZIndex = TableFactory.getDZColIndexFromTalbe(tableId,i);
		//获得字段名
		var sColName = DZ[tableIndex][1][iDZIndex][15];
		result += "&" + sColName + "=" + filterValues[tableId][i];
	}
	return result;
}

function as_dropEdit(dwname,rowIndex){
	if(isNaN(dwname))dwname = dwname.substring(8);
	var tableIndex = dwname;
	var tableId = "myiframe" + tableIndex;
	if(rowIndex==-1){
		alert('对不起，没有选中数据');
		return;
	}
	if(rowIndex<TableFactory.OldRowCount){
		alert('对不起，只有新增的数据才能执行本操作');
		return;
	}
	if(rowIndex!=tableDatas[tableId].length-1){
		alert('对不起，新增的行只能从最后一行开始删除');
		return;
	}
	
	var tbody = document.getElementById(tableId + "_order_GridBody_Locks");
	tbody.removeChild(tbody.childNodes[rowIndex]);
	var tbody2 =document.getElementById(tableId + "_order_GridBody_Cells");
	tbody2.removeChild(tbody2.childNodes[rowIndex]);
	as_resetData(tableIndex,rowIndex);
}

function as_resetData(tableIndex,rowIndex){//重置新增数据
	var tableId = "myiframe" + tableIndex;
	for(var i=rowIndex;i<tableDatas[tableId].length-1;i++){
		tableDatas[tableId][i] = tableDatas[tableId][i+1];
		DZ[tableIndex][2][i]=DZ[tableIndex][2][i+1];
	}
	//alert("tableDatas[tableId].length=" + tableDatas[tableId].length);
	tableDatas[tableId].length--;
	//alert("tableDatas[tableId].length=" + tableDatas[tableId].length);
	DZ[tableIndex][2].length--;
	//var tableId = "myiframe" + tableIndex;
	//tableDatas[tableId][iLastRow][i] = DZ[tableIndex][1][dzColIndex][9];
	//DZ[tableIndex][2][iLastRow][dzColIndex] = DZ[tableIndex][1][dzColIndex][9];
}
function as_copy(dwname,copyIndexArray){
	if(isNaN(dwname))dwname = dwname.substring(8);
	var tableId = "myiframe" + dwname;
	if(copyIndexArray==undefined) copyIndexArray = getSelRows(dwname);
	for(var i=0;i<copyIndexArray.length;i++){
		var index = copyIndexArray[i];
		//alert(tableDatas[tableId][index]);
		as_add(dwname,tableDatas[tableId][index]);
	}
}
function as_add(dwname,copyData,readonly){
	alert("嵌套表格不支持as_add");
	/*
	if(isNaN(dwname))dwname = dwname.substring(8);
	var tableIndex = dwname;
	var tableId = "myiframe" + tableIndex;
	var headers = TableBuilder.Headers[tableId];
	var iLockCols = DZ[tableIndex][0][6];
	var iDisplayColumnSize = headers.length; 
	var iLastRow = tableDatas[tableId].length;
	//alert("iLastRow = " + iLastRow);
	tableDatas[tableId][iLastRow] = new Array();
	DZ[tableIndex][2][iLastRow] = new Array();
	var tbody = document.getElementById(tableId + "_order_GridBody_Locks");
	var tr = document.createElement("tr");
	var dzColIndex = 0;
	var iFirstIndex = -1;
	if(tbody){
		tr.setAttribute("tableId", tableId);
		tr.setAttribute("id", "TR_Left_"+ tableId +"_"+ iLastRow);
		TableFactory.addEventWithParams4(tr,"mouseover",TableBuilder.TRMouseOver,iLastRow,tr,undefined,sWDColors[3]);
		TableFactory.addEventWithParams4(tr,"mousedown",TableBuilder.TRClick,iLastRow,tr,undefined,sWDColors[3]);
		TableFactory.addEventWithParams4(tr,"mouseout",TableBuilder.TRMouseOut,iLastRow,tr,undefined,sWDColors[3]);
		tbody.appendChild(tr);
		
		if(DZ[tableIndex][0][11]==1)
			iFirstIndex = -2;//如果有多选按钮
		for(var i=iFirstIndex;i<iLockCols;i++){
			var td = document.createElement("td");
			tr.appendChild(td);
			var div = document.createElement("div");
			td.appendChild(div);
			if(i==-2){
				td.className = "list_checkbox_td";
				div.className = "list_gridCell_narrow";
				//div.innerHTML = '<input class="list_left_cbInput" type="checkbox" name="check_S_'+ tableId +'" onclick="TableBuilder.iCurrentRow[\''+ tableId +'\'] = '+iLastRow+';TableBuilder.displaySelectedRows(\''+ tableId +'\')">';
				div.innerHTML = '&nbsp;';
			}
			else if(i==-1){
				td.className = "list_all_no";
				div.className = "list_gridCell_narrow";
				div.innerHTML = tableDatas[tableId].length;
			}
			else{
				dzColIndex = TableFactory.getDZColIndexFromTalbe(tableId,i);
				td.style.backgroundColor = sWDColors[iLastRow%2];
				td.className = "list_all_td";
				div.className = "list_gridCell_lock";
				var sValue = (copyData?copyData[i]:DZ[tableIndex][1][dzColIndex][9]);
				sValue=TableBuilder.getFomatedNumber(sValue,DZ[tableIndex][1][dzColIndex][12]);
				if((readonly==undefined || readonly =='0') && DZ[tableIndex][1][dzColIndex] && DZ[tableIndex][1][dzColIndex][3]=="0"){
					div.innerHTML = TableBuilder.createInput(tableId,"INPUT_"+ tableId +"_" + DZ[tableIndex][1][dzColIndex][15],DZ[tableIndex][1][dzColIndex][11],sValue,'',DZ[tableIndex][1][dzColIndex][20],iLastRow,i,DZ[tableIndex][1][dzColIndex][12]);
					tableDatas[tableId][iLastRow][i] = sValue;
					DZ[tableIndex][2][iLastRow][dzColIndex] = '';
					TableBuilder.header_reloadEvents(iLastRow);
				}
				else{
					tableDatas[tableId][iLastRow][i] = "";
					DZ[tableIndex][2][iLastRow][dzColIndex] = '';
					div.innerHTML = '<span id="INPUT_'+ tableId + '_' + DZ[tableIndex][1][dzColIndex][15] + '_' + iLastRow+ '_' + i +'" class="list_event_width">'+ "" + '</span>';
				}
				
				div.style.width = document.getElementById('Header_'+ tableId + '_' + i).style.width;
				
			}
		}
	}
	
	var tbody2 = document.getElementById(tableId + "_order_GridBody_Cells");
	tr = document.createElement("tr");
	tr.setAttribute("tableId", tableId);
	tr.setAttribute("id", "TR_Right_"+ tableId +"_"+ iLastRow);
	tr.style.backgroundColor = sWDColors[iLastRow%2];
	tr.setAttribute("origColor", sWDColors[iLastRow%2]);
	tr.setAttribute("lightColor", sWDColors[2]);
	
	TableFactory.addEventWithParams4(tr,"mouseover",TableBuilder.TRMouseOver,iLastRow,undefined,tr,sWDColors[3]);
	TableFactory.addEventWithParams4(tr,"mousedown",TableBuilder.TRClick,iLastRow,undefined,tr,sWDColors[3],tableDatas[tableId].length);
	TableFactory.addEventWithParams4(tr,"mouseout",TableBuilder.TRMouseOut,iLastRow,undefined,tr,sWDColors[3]);
	tbody2.appendChild(tr);
	for(var i=iLockCols;i<iDisplayColumnSize;i++){
		dzColIndex = TableFactory.getDZColIndexFromTalbe(tableId,i);
		var td = document.createElement("td");
		tr.appendChild(td);
		var div = document.createElement("div");
		td.appendChild(div);
		td.className = "list_all_td";
		div.className = "list_gridCell_standard";
		//alert(DZ[tableIndex][1][dzColIndex][3]=="0");
		var sValue = (copyData?copyData[i]:DZ[tableIndex][1][dzColIndex][9]);
		sValue=TableBuilder.getFomatedNumber(sValue,DZ[tableIndex][1][dzColIndex][12]);
		if((readonly==undefined || readonly =='0') && DZ[tableIndex][1][dzColIndex] && DZ[tableIndex][1][dzColIndex][3]=="0"){
			div.innerHTML = TableBuilder.createInput(tableId,"INPUT_"+ tableId +"_" + DZ[tableIndex][1][dzColIndex][15],DZ[tableIndex][1][dzColIndex][11],sValue,'',DZ[tableIndex][1][dzColIndex][20],iLastRow,i,DZ[tableIndex][1][dzColIndex][12]);
			tableDatas[tableId][iLastRow][i] = sValue;
		}
		else{
			div.innerHTML = '<span id="INPUT_'+ tableId + '_' + DZ[tableIndex][1][dzColIndex][15] + '_' + iLastRow+ '_' + i +'" class="list_event_width">'+ "" + '</span>';
			tableDatas[tableId][iLastRow][i] = "";
		}
		
		DZ[tableIndex][2][iLastRow][dzColIndex] = '';
		
		div.style.width = document.getElementById('Header_'+ tableId + '_' + i).style.width;
		addListEventListenerForInput(div,DZ[tableIndex][1][dzColIndex][15]);
	}
	//TableBuilder.header_reloadEvents();
	//alert(document.getElementById("INPUT_myiframe0_ISINUSE_13_3").outerHTML);
	//TableBuilder.reloadDate();
	lightRow(0,iLastRow);//高亮第一行
	//document.write(document.getElementById("myiframe0").outerHTML);
	*/
}

function addListEventListenerForInput(div,colname){
	for(var j=0;j<div.childNodes.length;j++){
		var childtag = div.childNodes[j];
		if(childtag.tagName == 'INPUT' || childtag.tagName == 'SELECT'){
			if(DZ[0][0][10]){
				for(var ii=0;ii<DZ[0][0][10].length;ii++){
					if(colname!=DZ[0][0][10][ii][0])continue;
					if(childtag.addEventListener){
						childtag.addEventListener(DZ[0][0][10][ii][1],eval(DZ[0][0][10][ii][2]),false);
					}
					else{
						childtag.attachEvent(DZ[0][0][10][ii][1],eval(DZ[0][0][10][ii][2]),false);
					}
				}
			}
		}
	}
}

function as_do(dwname,postevents,action){
	if(isNaN(dwname))dwname = dwname.substring(8);
	if(action=="delete"){
		as_delete(dwname,postevents);
	}
	else if(action == "save"){
		as_save(dwname,postevents);
	}
	else{
		if(action==undefined || action==null || action=="")
			action = "defaultAction";
		as_doAction(dwname,postevents,action);
	}
}

//删除函数：此方法为高性能删除模式，所以不支持附表操作。如需要操作附表，请使用as_doAction(dwname,postevents,'delete')
function as_delete(dwname,postevents){
	if(isNaN(dwname))dwname = dwname.substring(8);
	var tableIndex = dwname;
	//获得表格名
	var tableId = "myiframe" + dwname;
	//获得选中的列
	var aSelRows = getSelRows(dwname);
	if(aSelRows.length<=0){
		alert('没有选中任何行，无法进行删除操作');
		return;
	}
	//处理新增模式下的删除
	if(getRow(tableIndex)>=TableFactory.OldRowCount){
		as_dropEdit(tableIndex,getRow(tableIndex));
		return;
	}
	//openwin(sDWResourcePath + '/OverDW.jsp',700,257);
	openDWDialog();
	var rows = new StringBuffer();
	rows.append("<rows>");
	//获得关键字
	for(var i=0;i<aSelRows.length;i++){
		rows.append("<row>");
		for(var j=0;j<TableFactory.ColKeyIndexs.length;j++){
			var keyName = DZ[dwname][1][TableFactory.ColKeyIndexs[j]][15];
			var keyValue = DZ[dwname][2][aSelRows[i]][TableFactory.ColKeyIndexs[j]];
			rows.append("<col name=\""+ keyName +"\">"+ keyValue +"</col>");
		}
		rows.append("</row>");
	}
	rows.append("</rows>");
	//组合参数
	var params = rows.toString();
	params += "&asd=" + DZ[dwname][0][8];
	$.ajax({
	   type: "POST",
	   url: sDWResourcePath + "/ListDelete.jsp",
	   processData: false,
	   //data: "para=" + params  + "&SelectedRows="+ getSelRows(dwname).toString() + "&bpdata=" + bpdata,
	   data: "para=" + encodeURI(encodeURI(params)) ,
	   success: function(msg){
		var result = eval("(" + msg + ")");
		if(result.status=="success"){
			try{
				//alert("v_g_DWIsSerializJbo = " + v_g_DWIsSerializJbo);
				s_r_c[tableIndex]=-1;
				TableFactory.search(dwname,undefined,v_g_DWIsSerializJbo);
				aDWResultError[dwname] = '';
				aDWResultInfo[dwname] = result.resultInfo;
				msg = "删除成功";
				if(postevents==undefined) postevents="";
				if(postevents.length>0)eval("("+postevents+")");
			}
			catch(e){
				msg = "删除成功，但是页面刷新失败："+e.toString();
			}
			//TableBuilder.reloadDateForAsync();
			resetDWDialog(msg,true);
		}
		else{
			aDWResultInfo[dwname] = '';
			aDWResultError[dwname] = result.errors;
			//updateSuccess(result.errors);
			//TableBuilder.reloadDateForAsync();
			resetDWDialog(msg,false);
		}
		/*
		if(msg.indexOf("删除成功")==0){
			//alert(1);
			try{
				TableFactory.search(tableIndex);
			}
			catch(e){
				msg = "删除成功，但是页面刷新失败："+e.toString();
			}
			//alert(msg);
			updateSuccess(msg,postevents);
		}
		else{
			updateSuccess(msg);
		}
		*/
	   }
	});
}

function as_save(dwname,postevents){
	as_doAction(dwname,postevents,"save");
}

function as_extendAction(dwname,postevents,action){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	//获得表格名
	var tableId = "myiframe" + tableIndex;
	var selrows = getSelRows(tableIndex);
	//alert(selrows);
	var serializedjbo = DZ[tableIndex][0][9];
	//删除操作要过滤多余数据
	var aSerializedjbo = serializedjbo.split(",");
	openDWDialog();
	$.ajax({
		   type: "POST",
		   url: sDWResourcePath + "/ListExtendAction.jsp",
		   processData: false,
		   data: encodeURI(encodeURI("SERIALIZED_ASD=" + DZ[tableIndex][0][8] + "&SERIALIZED_JBO=" + serializedjbo + "&UPDATED_FIELD=" + getChangedValues(tableIndex) + "&SelectedRows="+ getSelRows(tableIndex).toString() +"&SYS_ACTION=" + action)),
		   success: function(msg){
			var result = eval("(" + msg + ")");
			if(result.status=="success"){
				try{
					aDWResultInfo[tableIndex] = result.resultInfo;
					msg = "操作成功";
					if(postevents==undefined) postevents="";
				}
				catch(e){
					msg = "操作成功，但是页面刷新失败："+e.toString();
				}
				resetDWDialog(msg,true);
				if(postevents.length>0)eval("("+postevents+")");
			}
			else{
				aDWResultError[tableIndex] = result.errors;
				//updateSuccess(result.errors);
				resetDWDialog(result.errors,false);
			}
		   }
		});
}

function as_doAction(dwname,postevents,action,noresearch){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	//获得表格名
	var tableId = "myiframe" + tableIndex;
	var selrows = getSelRows(tableIndex);
	var serializedjbo = DZ[tableIndex][0][9];
	//删除操作要过滤多余数据
	var aSerializedjbo = serializedjbo.split(",");
	if(action=='delete'){
		//处理新增模式下的删除
		if(window.confirm('确定删除该记录？')){
			if(getRow(tableIndex)>=TableFactory.OldRowCount){
				as_dropEdit(tableIndex,getRow(tableIndex));
				return;
			}
			serializedjbo = "";
			for(var i=0;i<selrows.length;i++){
				if(serializedjbo == "")
					serializedjbo = aSerializedjbo[selrows[i]];
				else
					serializedjbo += "," + aSerializedjbo[selrows[i]];
			}
		}
		
	}
	else{
		if(iV_all(tableIndex)==false){
			showErrors(tableIndex);
			return;
		}
	}

	//alert("getChangedValues(tableIndex)=" + getChangedValues(tableIndex));
	//openwin(sDWResourcePath + '/OverDW.jsp',700,257);
	openDWDialog();
	$.ajax({
		   type: "POST",
		   url: sDWResourcePath + "/ListSave.jsp",
		   processData: false,
		   data: encodeURI(encodeURI("SERIALIZED_ASD=" + DZ[tableIndex][0][8] + "&SERIALIZED_JBO=" + serializedjbo + "&UPDATED_FIELD=" + getChangedValues(tableIndex) + "&SelectedRows="+ getSelRows(tableIndex).toString() +"&SYS_ACTION=" + action)),
		   success: function(msg){
			var result = eval("(" + msg + ")");
			if(result.status=="success"){
				try{
					s_r_c[tableIndex]=-1;
					if(noresearch==undefined)
						TableFactory.search(tableIndex,undefined,"1");
					aDWResultInfo[tableIndex] = result.resultInfo;
					msg = "操作成功";
					if(postevents==undefined) postevents="";
				}
				catch(e){
					msg = "操作成功，但是页面刷新失败："+e.toString();
				}
				try{
					//TableBuilder.reloadDateForAsync();
				}
				catch(e){}
				resetDWDialog(msg,true);
				if(postevents.length>0)eval("("+postevents+")");
			}
			else{
				aDWResultError[tableIndex] = result.errors;
				//updateSuccess(result.errors);
				resetDWDialog(result.errors,false);
			}
		   }
		});
}
//获得修改后的数据
function getChangedValues(tableIndex){
	var result = new StringBuffer();
	result.append("<root>");
	var tableId = "myiframe" + tableIndex;
	for(var i=0;i<tableDatas[tableId].length;i++){
		var changed = false;
		for(var j=0;j<tableDatas[tableId][i].length;j++){
			var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,j);
			var sOldValue = DZ[tableIndex][2][i][iDZColIndex];
			var sNewValue = tableDatas[tableId][i][j];
			if(sOldValue!=sNewValue){
				changed = true;
				break;
			}
		}
		if(!changed) continue;
		result.append("<row index=\""+ i +"\">");
		for(var j=0;j<tableDatas[tableId][i].length;j++){
			var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,j);
			var sNewValue = tableDatas[tableId][i][j];
			sNewValue = sNewValue.replace(/&/g,"⊙≌□");
			sNewValue = sNewValue.replace(/#/g,"⊙s≌h□");
			sNewValue = sNewValue.replace(/>/g,"⊙g≌t□");
			sNewValue = sNewValue.replace(/</g,"⊙l≌t□");
			result.append("<col name=\""+ DZ[tableIndex][1][iDZColIndex][15] +"\">"+ sNewValue +"</col>");
		}
		result.append("</row>");
	}
	result.append("</root>");
	result = result.toString();
	//alert(result);
	return result;
}
function as_isPageChanged(){
	var sData = getChangedValues(0);
	if(sData == '<root></root>')
		return false;
	else
		return true;
}

//页面导出
function exportPage(rootpath,dwname,fileType,argValues){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	
	//alert(fileType)
	//创建虚拟的form提交
	var params = "rand=" + Math.random();
	var url = rootpath + "/EAS/PageExport/list?" + params;
	var form = document.getElementById("@SUBMIT");
	//alert(form);\
	if(TableFactory.ExportArgValues==undefined )
		TableFactory.ExportArgValues =argValues;
	if(TableFactory.ExportDataObject==undefined)
		TableFactory.ExportDataObject= DZ[tableIndex][0][8];
	if(form==undefined){
		var tableSubmit = document.getElementById("TABLE_SUBMIT_" + tableIndex);
		form = document.createElement("form");
		form.setAttribute("name", "@SUBMIT");
		form.setAttribute("id", "@SUBMIT");
		form.setAttribute("action", url);
		form.setAttribute("method", "post");
		tableSubmit.appendChild(form);
		
		var sb = new StringBuffer();
		//sb.append('<form name="@SUBMIT" id="@SUBMIT" action="'+ url +'" method="post">');
		sb.append('<input type="hidden" name="SERIALIZED_ASD" value="">');
		sb.append('<input type="hidden" name="ArgValues" value="">');
		sb.append('<input type="hidden" name="FileType" value="">');
		sb.append('<input type="hidden" name="ConvertCode" value="">');
		form.innerHTML = sb.toString();
		//sb.append('</form>');
		//document.getElementById("TABLE_SUBMIT_" + tableIndex).innerHTML = sb.toString();
		//form = document.getElementById("@SUBMIT");
	}
	//alert("TableFactory.ExportArgValues=" + TableFactory.ExportArgValues);
	form.elements["SERIALIZED_ASD"].value = TableFactory.ExportDataObject;
	form.elements["ArgValues"].value = TableFactory.ExportArgValues;
	form.elements["FileType"].value = fileType;	
	if(bDWConvertCode)
		form.elements["ConvertCode"].value = "1";
	else
		form.elements["ConvertCode"].value = "";
	openDWDialog();
	form.submit();
	resetDWDialogForAjax("正在生成文件，请稍后到任务调度平台查看",sDWResourcePath+"/CheckExportPage.jsp?rand="+rand);
	//resetDWDialog("正在生成文件，请稍后到任务调度平台查看",false);
}

function createHiddenInput(parent,name,value){
	var input = document.createElement("input");
	input.setAttribute("type", "hidden");
	input.setAttribute("name", name);
	input.setAttribute("value", value);
	parent.appendChild(input);
	return input;
}
function TableFactory(){

}

//清空过滤输入项
TableFactory.clearFilter = function(tableIndex){
	var tableId = "myiframe"+tableIndex;
	for(var i=0;i<filterValues[tableId].length;i++)
		filterValues[tableId][i] = "";
	for(var i=0;i<filterValues2[tableId].length;i++)
		filterValues2[tableId][i] = "";
	filterTitles[tableId] = new Array();
	for(var i=0;i<filterHiddenNames[tableId].length;i++)
		filterHiddenValues[tableId][filterHiddenNames[tableId][i]] = "";
	for(var i=0;i<filterOptions[tableId].length;i++)
		filterOptions[tableId][i] = "";
	
};
//汇总查询功能，需要根据汇总项对每个filter数组赋值
TableFactory.submitFilter = function(tableIndex){
	var tableId = "myiframe"+tableIndex;
	var form = document.getElementsByName("DOFilter")[tableIndex];
	var elements = form.elements;
	for(var i=0;i<elements.length;i++){
		//DF2_1_INPUT
		var name = elements[i].id;
		var iFilterIndex = 0;
		var sFilterName = "";
		if(name.substring(0,2)=="DF" && name.indexOf("_1_INPUT")>-1){
			iFilterIndex = name.substring(2,name.indexOf("_"));
			//alert(iFilterIndex);
			//获得查询关键字名称
			sFilterName = filterNames[tableIndex][iFilterIndex];
			//转换为显示的列，这样对过滤数组赋值才能成功
			for(var j=0;j<DZ[tableIndex][1].length;j++){
				if(DZ[tableIndex][1][j][19].toUpperCase()==sFilterName.toUpperCase())
					sFilterName = DZ[tableIndex][1][j][15];
			}
			//if(DZ[tableIndex][1][iDZColIndex][19]=="")
			//根据名称获得表格对应的编号
			var iDZColIndex = getColIndex(tableIndex,sFilterName);
			var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
			//alert("name=" + name + "|sFilterName=" + sFilterName + "|iTableColIndex=" + iTableColIndex + "|elements[i].value =" + elements[i].value);
			filterValues[tableId][iTableColIndex] = elements[i].value;
		}
	}
	openDWDialog();
	TableFactory.search(tableIndex,undefined,v_g_DWIsSerializJbo);
	autoCloseDWDialog();
};

//排序
TableFactory.sort = function(tableId,sortIndex,source){
	var tableIndex = tableId.substring(8);
	var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,sortIndex);
	//alert("sortIndex =" + sortIndex + "|" + DZ[tableIndex][1][iDZColIndex][15]);
	var sortDirect = source.getAttribute("sortDirect");
	if(sortDirect=="desc"){
		sortDirect= "asc";
		//source.innerHTML = "↑";
	}
	else{
		sortDirect= "desc";
		//source.innerHTML = "↓";
	}
	TableFactory.SortParams = "&SYS_SortIndex=" + DZ[tableIndex][1][iDZColIndex][15] + "&SYS_SortDirect=" + sortDirect;
	
	openDWDialog();
	submitFilterArea(TableFactory.SortParams);
	//TableFactory.search(tableIndex,params,v_g_DWIsSerializJbo,undefined,TablePage.from);
	autoCloseDWDialog();
};
//查询条件
function as_refreshCurrentRow(dwname){
	//alert('todo');
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	//alert(1);
	var tableIndex = dwname.substring(8);
	var iRow = getRow(tableIndex);
	TableFactory.search(tableIndex,"&RefreshRowIndex=" + iRow,v_g_DWIsSerializJbo,iRow);
}

TableFactory.search = function(tableIndex,params,isSerializJbo,lightRowIndex,from){
	//alert("from=" + from);
	//openDWDialog();
	if(params==undefined)params="";
	var tableId = "myiframe" + tableIndex;
	//alert("filterValues[tableId]=" + filterValues[tableId]);
	for(var i=0;i<filterValues[tableId].length;i++){
		
		if(filterValues[tableId][i]){
			var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,i);
			var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
			var sColName = "";
			if(DZ[tableIndex][1][iDZColIndex][19]=="")
				sColName = DZ[tableIndex][1][iDZColIndex][15];
			else
				sColName = DZ[tableIndex][1][iDZColIndex][19];
			//alert(sColName);
			params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_VALUE=" +encodeURI(filterValues[tableId][i]);
			if(DZ[tableIndex][1][iDZColIndex][20] && DZ[tableIndex][1][iDZColIndex][20].length>0){
				params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=" + document.getElementById("DOFILTER_DF_"+ DZ[tableIndex][1][iDZColIndex][15].toUpperCase() +"_1_OP").value;
			}
			else if(DZ[tableIndex][1][iDZColIndex][21] && DZ[tableIndex][1][iDZColIndex][21].length>0){
				//alert("DZ[tableIndex][1][iDZColIndex][15].toUpperCase()=" + DZ[tableIndex][1][iDZColIndex][15].toUpperCase());
				params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=" + document.getElementById("DOFILTER_DF_"+ DZ[tableIndex][1][iDZColIndex][15].toUpperCase() +"_1_OP").value;			
			}
			else{
				if(from=="fromarea" && document.getElementById("DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP")){
					params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=" + document.getElementById("DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP").value;
					if(document.getElementById("DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP") && document.getElementById("DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP").value=="Area"){
						params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_2_VALUE=" +encodeURI(filterValues2[tableId][iDZColIndex]);
					}
				}
				else{
					if(DZ[tableIndex][1][iDZColIndex][12]==5 || DZ[tableIndex][1][iDZColIndex][12]==2 || DZ[tableIndex][1][iDZColIndex][12]==6 || DZ[tableIndex][1][iDZColIndex][12]==7 || DZ[tableIndex][1][iDZColIndex][12]>10)
						params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=Equals";
					else
						params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=BeginsWith";
				}
			}
		}
	}
	//alert("filterHiddenValues[tableId].length=" + filterHiddenValues[tableId].length);
	for(var i=0;i<filterHiddenNames[tableId].length;i++){
		var sColName = filterHiddenNames[tableId][i];
		iDZColIndex = getColIndex(tableId,sColName);
		var sValue = filterHiddenValues[tableId][sColName];
		if(sValue && sValue!=''){
			params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_VALUE=" +encodeURI(filterHiddenValues[tableId][sColName]);
			if(DZ[tableIndex][1][iDZColIndex][20] && DZ[tableIndex][1][iDZColIndex][20].length>0)
				params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=In";
			else
				params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=BeginsWith";
		}
	}
	//alert("params=" + params);
	if(lightRowIndex!=undefined)
		TableFactory.DO2(sDWResourcePath + "/ListSearch.jsp",tableIndex,"search",undefined,undefined,params,isSerializJbo,lightRowIndex);
	else
		TableFactory.DO(sDWResourcePath + "/ListSearch.jsp",tableIndex,"search",undefined,undefined,params,isSerializJbo);
	//autoCloseDWDialog();
};

TableFactory.DO2 = function(url,tableIndex,action,postevents,message,searchParams,isSerializJbo,lightRowIndex){
	var tableId = "myiframe" + tableIndex;
	var params = "rowcount="+ s_r_c[tableIndex] +"&curpage="+ s_c_p[tableIndex] +"&SYS_ACTION="+action+"&index="+ tableIndex + "&SERIALIZED_ASD=" + DZ[tableIndex][0][8]  +"&SERIALIZED_JBO=" + DZ[tableIndex][0][9] + "&isSerializJbo=" + isSerializJbo;
	if(searchParams){//组合查询条件
		params += searchParams;//searchParams以&开头,所以这里不需要加&
	}
	$.ajax({
	   type: "POST",
	   url: url,
	   async:false,
	   data: encodeURI(params),
	   success: function(json){
		//alert(json);
		if(json==undefined || json=='')return;
		var obj = eval("("+ json +")");
		if(obj.data==undefined || obj.data=='')return;
		//alert("obj.data="  + obj.data);
		eval(obj.data);
		//alert("lightRowIndex="+lightRowIndex);
		if(lightRowIndex>-1){
			for(var iii=0;iii<DZ[tableIndex][2][lightRowIndex].length;iii++){
				//alert(DZ[tableIndex][2][lightRowIndex][iii]);
				try{
					setItemValue(tableIndex,lightRowIndex,DZ[tableIndex][1][iii][15],DZ[tableIndex][2][lightRowIndex][iii]);
				}
				catch(e){}
			}
			//定义显示规则
			if(DZ[0][6]){
				TableBuilder.setDisplayRule("myiframe0",DZ[0][6]);
			}
			lightRow(tableIndex,lightRowIndex);
		}
	   }
	});
};

TableFactory.DO = function(url,tableIndex,action,postevents,message,searchParams,isSerializJbo){
	//alert(isSerializJbo);
	var tableId = "myiframe" + tableIndex;
	var iNewPage = s_c_p[tableIndex];
	var params = "rowcount="+ s_r_c[tableIndex] +"&curpage="+ iNewPage +"&CompClientID"+sCompClientID+"&SYS_ACTION="+action+"&index="+ tableIndex + "&SERIALIZED_ASD=" + DZ[tableIndex][0][8]  +"&SERIALIZED_JBO=" + DZ[tableIndex][0][9] + "&isSerializJbo=" + isSerializJbo;
	if(searchParams){//组合查询条件
		params += searchParams;//searchParams以&开头,所以这里不需要加&
	}
	//alert(isSerializJbo);
	//alert("do");
	$.ajax({
		   type: "POST",
		   url: url,
		   async:false,
		   data: encodeURI(params),
		   success: function(json){
				//alert(json);
				if(json==undefined || json=='')return;
				var obj = eval("("+ json +")");
				//alert(obj.status);
				if(obj.status==false){
					updateSuccess("出错了:" + obj.errors);
				}
				else{
					//alert(msg);
					DZ[tableIndex][0][8] = obj.SERIALIZED_ASD;
					DZ[tableIndex][0][9] = obj.SERIALIZED_JBO;
					
					TableFactory.ExportArgValues = obj.ArgValues;
					TableFactory.ExportDataObject= obj.New_SERIALIZED_ASD;
					//alert(obj.data);
					eval(obj.data);
					
					if(s_r_c[tableIndex]==s_p_s[tableIndex]*s_p_c[tableIndex] && s_p_c[tableIndex]==s_c_p[tableIndex] && s_c_p[tableIndex]>0){//如果刚好删除的是最后一页，并且只有一条，那么需要重新刷数据
						s_c_p[tableIndex] = s_c_p[tableIndex]-1;
						TableFactory.DO(url,tableIndex,action,postevents,message,searchParams,isSerializJbo);
						return;
					}
					
					//alert(DZ[0][2]);
					//重新显示界面
					document.getElementById("Table_Content_" + tableIndex).innerHTML = TableFactory.createTableHTML(tableIndex);
					if(window.afterSearch)
						afterSearch();
					//更新尺寸
					change_height();
					//判断状态
					if(message)
						updateSuccess(message,postevents);
					if(obj.sortIndex!=undefined && obj.sortIndex!=null){//更新排序信息
						
						var dzColIndex = getColIndex(tableIndex,obj.sortIndex);
						var tableColIndex = TableFactory.getTableColIndexFromDZ(tableId,dzColIndex); 
						
						var source = document.getElementById("Sorter_" + tableId + "_" + tableColIndex);
						source.setAttribute("sortDirect",obj.sortDirect);
						//alert(obj.sortDirect);
						if(obj.sortDirect=="desc")
							source.innerHTML = "↓";
						else if(obj.sortDirect=="asc")
							source.innerHTML = "↑";
						else
							source.innerHTML = "→";
					}
					//重写事件
					TableBuilder.header_reloadEvents();
					//重新生成右键菜单
					createContextMenu(0);
					//重新统计数据
					TableFactory.OldRowCount = tableDatas[tableId].length;
					//alert(TableFactory.OldRowCount);
					//定义显示规则
					if(DZ[0][6]){
						TableBuilder.setDisplayRule("myiframe0",DZ[0][6]);
					}
					lightRow(tableIndex,0);
				}
		   }
	});
};

TableFactory.ColIndexMap = new Array();
TableFactory.ColKeyIndexs = new Array();
//把表格的列编号变换转换为源数据的列编号
TableFactory.getDZColIndexFromTalbe = function(tableId,colindex){
	var result = TableFactory.ColIndexMap[tableId][colindex];
	if(result==undefined)
		result = colindex;
	return result;
};
//把源数据的列编号转换为表格的列编号
TableFactory.getTableColIndexFromDZ = function(tableId,colindex){
	if(TableFactory.ColIndexMap[tableId]){
		for(var i=0;i< TableFactory.ColIndexMap[tableId].length;i++){
			if(TableFactory.ColIndexMap[tableId][i]==colindex)
				return i;
		}
	}
	return -1;
};

TableFactory.addEventWithParams4 = function(target, eventName, handler, arg1,arg2,arg3,arg4){
	var eventHander = function(e){
        handler.call(target,arg1,arg2,arg3,arg4,e);
    };
    if(window.attachEvent)//IE
        target.attachEvent("on" + eventName, eventHander );
    else//FF
        target.addEventListener(eventName, eventHander, false);
};

TableFactory.addEventWithParams8 = function(target, eventName, handler, args){
	if(typeof(handler)=='string'){
		if(window.addEventListener){
			if(eventName.substring(0,2)=="on")
				eventName= eventName.substring(2);
			target.addEventListener(eventName,eval(handler),false);
		}
		else{//IE
			if(eventName.substring(0,2)!="on")
				eventName= "on" + eventName;
			target.attachEvent(eventName,eval(handler),false);
		}
	}
	else{
		var eventHander = function(e){
			if(args)
				handler.call(target,args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],e);
			else{
				handler.call(target,e);
			}
	    };
		eventName = eventName.toLocaleLowerCase();
	    if(window.attachEvent)//IE
	        target.attachEvent("on" + eventName, eventHander );
	    else//FF
	        target.addEventListener(eventName, eventHander, false);
	}
};

TableFactory.colReadOnly = new Array();//是否只读
TableFactory.createTableHTML = function(tableIndex){
	
	var resultHTML = "";
	//获得表格名
	var tableId = "myiframe" + tableIndex;
	//获得标题和统计信息
	var heads = new Array();
	var colNames = new Array();
	var range = new Array();//取值范围
	var sortable = new Array();//是否可排序
	var colHtmlStyle = new Array();//htmlstyle
	var colAlign = new Array();//对齐方式
	var checkFormat = new Array();
	var colEditStyle = new Array();//显示控件类型
	var colUnit = new Array();
	var clientCount;//小计
	var serverCount;//总计
	//alert(DZ);
	if(DZ[tableIndex][0][4]==1){
		clientCount = ["小计",""];
	}
	TableFactory.ColIndexMap[tableId] = new Array();
	var k = 0;
	
	for(var i=0;i<DZ[tableIndex][1].length;i++){
		if(DZ[tableIndex][1][i][1]==1){
			TableFactory.ColKeyIndexs[TableFactory.ColKeyIndexs.length] = i;
		}
		if(DZ[tableIndex][1][i][2]!=1)continue;//visible字段不显示
		//补充映射关系
		TableFactory.ColIndexMap[tableId][k] = i;
		//添加标题
		heads[k] = DZ[tableIndex][1][i][0];
		//添加字段名
		colNames[k] = DZ[tableIndex][1][i][15];
		//添加小计
		
		if((DZ[tableIndex][1][i][14]=="2" || DZ[tableIndex][1][i][14]=="3") && clientCount != undefined){
			
			if(clientCount[1]=="") 
				clientCount[1]= "" + TableFactory.getTableColIndexFromDZ(tableId,i);
			else
				clientCount[1] += ","+ TableFactory.getTableColIndexFromDZ(tableId,i);
			//alert(clientCount[1]);
		}
		//获得htmlstyle
		if(DZ[tableIndex][1][i][10].length>10){
			//alert(DZ[tableIndex][1][i][10]);
			colHtmlStyle[TableFactory.getTableColIndexFromDZ(tableId,i)] = DZ[tableIndex][1][i][10];
		}
		//取值范围需要转换成实字段
		var sColActualName = DZ[tableIndex][1][i][19];
		if(sColActualName==undefined || sColActualName== "")
			sColActualName = DZ[tableIndex][1][i][15];
		var iColIndexDz = getColIndex(tableIndex,sColActualName);
		if(iColIndexDz!=i && DZ[tableIndex][1][iColIndexDz])
			DZ[tableIndex][1][i][20] = DZ[tableIndex][1][iColIndexDz][20];
		//获得取值范围
		if(DZ[tableIndex][1][iColIndexDz] && DZ[tableIndex][1][iColIndexDz][20]){
			range[k] = DZ[tableIndex][1][iColIndexDz][20];
		}
		//alert(range);
		//是否可排序
		sortable[k] = DZ[tableIndex][1][i][6];//1表示可排序，0-不可排序
		//对齐方式
		colAlign[k] = DZ[tableIndex][1][i][8];
		if(colAlign[k]=="")colAlign[k] = 0;
		//显示格式
		checkFormat[k] = DZ[tableIndex][1][i][12];
		//是否只读
		if(DZ[tableIndex][0][2]==1)
			TableFactory.colReadOnly[k] =1;
		else
			TableFactory.colReadOnly[k] = DZ[tableIndex][1][i][3];
		//控件
		colEditStyle[k] = DZ[tableIndex][1][i][11];
		//unit
		colUnit[k] = DZ[tableIndex][1][i][17];
		k++;
	}
	
	//获得冻结列数
	var lockCols = DZ[tableIndex][0][6];
	//alert("lockCols=" + lockCols);
	//添加总计
	if(DZ[tableIndex][3] && clientCount != undefined){
		serverCount = ["总计"];
		for(var i=0;i<DZ[tableIndex][3].length;i++){
			var iTable = TableFactory.getTableColIndexFromDZ(tableId,i);
			//alert(iTable);
			if(iTable>-1)
				serverCount[iTable+1] = DZ[tableIndex][3][i];
		}
		//alert(serverCount);
	}
	//获得列合并信息
	var combineLeft = DZ[tableIndex][4]?DZ[tableIndex][4][0]:undefined;
	var combineRight = DZ[tableIndex][4]?DZ[tableIndex][4][1]:undefined;
	//获得宽度
	var defaultWidths = 'self';
	//层次结构
	var depth = DZ[tableIndex][12];
	//alert("depth = " + depth);
	//汇总界面参数
	//alert("colHtmlStyle = " + colHtmlStyle);
	var uiparams = {
		colors:sWDColors,
		lockCols:lockCols,
		clientCount:clientCount,
		serverCount: serverCount,
		combineLeft:combineLeft,	
		combineRight:combineRight,
		defaultWidths:defaultWidths,
		depth:depth,
		htmlStyle:colHtmlStyle,
		sortable:sortable,
		colAlign:colAlign,
		checkFormat:checkFormat,
		colReadOnly:TableFactory.colReadOnly,
		colEditStyle:colEditStyle,
		colNames:colNames,
		colUnit:colUnit,
		multySelect:DZ[tableIndex][0][11]
	};
	//显示规则
	//var displayRule;
	//获得数据
	var datas = null;
	//alert(DZ[tableIndex][2]);
	if(DZ[tableIndex][2]){
		datas = new Array(DZ[tableIndex][2].length);
		for(var i=0;i<DZ[tableIndex][2].length;i++){
			datas[i] = new Array();//列数不固定，所以，这里不需要给数组设置长度
			for(var j=0;j<DZ[tableIndex][2][i].length;j++){
				var jTable = TableFactory.getTableColIndexFromDZ(tableId,j);
				if(jTable>-1){
					datas[i][jTable] = DZ[tableIndex][2][i][j];
				}
			}
			//alert(datas[i]);
		}
	}
	//alert(heads);
	//生成表格
	//alert("datas= " + datas);
	var table =  new TableBuilder(tableId,heads,datas,range,uiparams);
	resultHTML = table.createTableHTML();
	//生成页码:只有超过两页时才显示页码
	//alert("s_r_c[tableIndex]= " + parseInt(s_r_c[tableIndex])>1);
	if(s_p_c[tableIndex]>1){
		var iPageSize = s_p_s[tableIndex];
		//alert(iPageSize);
		if(iPageSize==undefined || iPageSize==null || iPageSize=="")
			iPageSize = 10;
		var page = new TablePage(tableId,s_r_c[tableIndex],iPageSize,s_p_c[tableIndex],s_c_p[tableIndex]);
		resultHTML += page.createPageHTML();
	}
	return resultHTML;
};

function addListEventListeners(tableIndex,row,colNames,eventtype,function_,params){
	var sColNameArray = colNames.split(",");
	for(var i=0;i<sColNameArray.length;i++)
		addListEventListener(tableIndex,row,sColNameArray[i],eventtype,function_,params);
}

//给list编辑控件添加事件
function addListEventListener(tableIndex,row,colName,eventtype,function_,params){
	var tableId = "myiframe" + tableIndex;
	var iDZColIndex = getColIndex(tableIndex,colName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	var rows = new Array();
	if(row==undefined || row==null || row == "" || row<0){
		for(var i=0;i<DZ[tableIndex][2].length;i++)rows[i] = i;
	}
	else{
		rows = [row];
	}
	for(var i=0;i<rows.length;i++){
		var obj = document.getElementById("INPUT_" + tableId + "_" + colName + "_" + rows[i] + "_" + iTableColIndex);
		//alert("INPUT_" + tableId + "_" + colName + "_" + rows[i] + "_" + iTableColIndex);
		if(obj){
			if(obj.type=='radio'){
				var objs = document.getElementsByName(obj.name);
				for(var ii=0;ii<objs.length;ii++){
					if(eventtype.substring(0,2)=="on")
						eventtype= eventtype.substring(2);
					TableFactory.addEventWithParams8(objs[ii],eventtype,function_,params);
						
					/*
					if(objs.addEventListener){
						if(eventtype.substring(0,2)=="on")
							eventtype= eventtype.substring(2);
						objs[ii].addEventListener(eventtype,eval(function_),false);
					}
					else{
						if(eventtype.substring(0,2)!="on")
							eventtype= "on" + eventtype;
						objs[ii].attachEvent(eventtype,eval(function_),false);
					}
					*/
				}
			}
			else{
				if(eventtype.substring(0,2)=="on")
					eventtype= eventtype.substring(2);
				TableFactory.addEventWithParams8(obj,eventtype,function_,params);
				/*
				if(obj.addEventListener){
					if(eventtype.substring(0,2)=="on")
						eventtype= eventtype.substring(2);
					obj.addEventListener(eventtype,eval(function_),false);
				}
				else{
					if(eventtype.substring(0,2)!="on")
						eventtype= "on" + eventtype;
					obj.attachEvent(eventtype,eval(function_),false);
				}
				*/
			}
			
		}
	}
}

function getObj(tableIndex,row,colName){
	var tableId = "myiframe" + tableIndex;
	var iDZColIndex = getColIndex(tableIndex,colName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	var obj = document.getElementById("INPUT_" + tableId + "_" + colName + "_" + row + "_" + iTableColIndex);
	return obj;
}

function getRadios(tableIndex,row,colName){
	var tableId = "myiframe" + tableIndex;
	var iDZColIndex = getColIndex(tableIndex,colName);
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
	var objs = document.getElementsByName("INPUT_" + tableId + "_" + colName + "_" + row + "_" + iTableColIndex);
	return objs;
}
function createContextMenu(tableIndex){
	//右键菜单处理
	if(DZ && DZ[0] && DZ[0][0][11]=='1'){
		document.getElementById("div_select_all_sep_1").style.display = "block";
		document.getElementById("div_select_all_ok").style.display = "block";
		document.getElementById("div_select_cancel").style.display = "block";
	}
	//document.getElementById("myiframe" + tableIndex).oncontextmenu = function(e){
	document.oncontextmenu = function(e){
		if(e==undefined)e=event;
		var sourceObj = e.srcElement?e.srcElement:e.target;
		if(sourceObj){
			if(sourceObj.tagName=='INPUT' || sourceObj.tagName=='select-one' || sourceObj.tagName=='select-multiple'){
				hideASContextMenu(e,true);
				return true;
			}
		}
		bindASContextMenu("mm",e);
		return false;
	};
	/*
	$("#myiframe" + tableIndex).bind('contextmenu',function(e){
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
		return false;
	});
	*/
}
function setFilterValue(div,tableId,tableColIndex){
	var labels = div.childNodes;
	var sValue = "";
	for(var i=0;i<labels.length;i++){
		var checkbox = labels[i].firstChild;
		if(checkbox && checkbox.checked){
			sValue += "|" + checkbox.value;
		}
	}
	if(sValue!="")sValue = sValue.substring(1);
	filterValues[tableId][tableColIndex] = sValue;
	//alert("filterValues[tableId][tableColIndex]=" + filterValues[tableId][tableColIndex]);
}
function setFilterHiddenValue(div,tableId,colName){
	
	var labels = div.childNodes;
	var sValue = "";
	for(var i=0;i<labels.length;i++){
		var checkbox = labels[i].firstChild;
		if(checkbox && checkbox.checked){
			sValue += "|" + checkbox.value;
		}
	}
	if(sValue!="")sValue = sValue.substring(1);
	filterHiddenNames[tableId][filterHiddenNames[tableId].length] = colName;
	filterHiddenValues[tableId][colName] = sValue;
}
function setFilterChecks(div,obj){
	//alert("obj.checked=" + obj.checked);
	var labels = div.childNodes;
	for(var i=0;i<labels.length-1;i++){
		//alert(labels[i].outerHTML);
		var checkbox = labels[i].firstChild;
		checkbox.checked = obj.checked;
		
		//checkbox.fireEvent("onclick");
	}
}
function openFullFilter(tableIndex,evt){
	var tableId = "myiframe" + tableIndex;
	var filterobj = document.getElementById("TableFullFilter_" + tableId);
	var sSearchHtml = new StringBuffer();
	filterobj.style.display = 'block';
	//left = (left?left:(evt.x?evt.x:evt.clientX));
	//alert(left);
	filterobj.style.left=document.getElementById("TableFilter").style.left;
	//top=(top?top:(evt.y?evt.y:evt.clientY));
	//alert(top);
	filterobj.style.top=document.getElementById("TableFilter").style.top;
	for(var i=0;i<aDWfilterTitles[tableIndex].length;i++){
		if(aDWfilterTitles[tableIndex][i]==undefined || aDWfilterTitles[tableIndex][i]=='')continue;
		var iColIndex = getColIndex(tableIndex,filterNames[tableIndex][i]);
		//如果为隐藏字段也不显示--注销 by flian 2011/07/18
		//if(DZ[tableIndex][1][iColIndex][2]!='1')continue;
		var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iColIndex); 
		var sValue = filterValues[tableId][iTableColIndex];
		//alert("sValue1==" + sValue);
		if(iTableColIndex==-1){
			sValue = filterHiddenValues[tableId][DZ[tableIndex][1][iColIndex][15]];
		}
		if(sValue==undefined)sValue = "";
		//alert("sValue2==" + sValue);
		sSearchHtml.append("<div><b>" + aDWfilterTitles[tableIndex][i] + "：</b></div>");
		//根据取值范围显示控件
		//alert("DZ[tableIndex][1]["+iColIndex+"][20] = " + DZ[tableIndex][1][iColIndex][20]);
		if(DZ[tableIndex][1][iColIndex][20] && DZ[tableIndex][1][iColIndex][20]!=""){
			sSearchHtml.append("<div>");
			for(var ii=0;ii<DZ[tableIndex][1][iColIndex][20].length;ii+=2){
				var sel = "";
				if(ii==0 && DZ[tableIndex][1][iColIndex][20][ii]=="")continue;
				if(TableBuilder.isStrInArray(sValue.split("|"),DZ[tableIndex][1][iColIndex][20][ii])>-1)sel = "checked";
				
				if(DZ[tableIndex][1][iColIndex][2]=='1')
					sSearchHtml.append('<label><input type="checkbox" value="'+ DZ[tableIndex][1][iColIndex][20][ii] +'" '+ sel +' onclick=setFilterValue(this.parentNode.parentNode,"'+tableId+'",'+iTableColIndex+')>'+ DZ[tableIndex][1][iColIndex][20][ii+1] +'</label><br>');
				else
					sSearchHtml.append('<label><input type="checkbox" value="'+ DZ[tableIndex][1][iColIndex][20][ii] +'" '+ sel +' onclick=setFilterHiddenValue(this.parentNode.parentNode,"'+tableId+'","'+DZ[tableIndex][1][iColIndex][15]+'")>'+ DZ[tableIndex][1][iColIndex][20][ii+1] +'</label><br>');
			}
			sSearchHtml.append('<label><input type="checkbox" value="" onclick=setFilterChecks(this.parentNode.parentNode,this)>全选</label>');
			sSearchHtml.append("</div>");
		}
		else{
			if(DZ[tableIndex][1][iColIndex][2]=='1')
				sSearchHtml.append('<input type="text" value="'+ sValue +'"'
						+ ' listfilter2="true" tablecolindex="'+iTableColIndex+'" onChange=filterValues["'+tableId+'"]['+iTableColIndex+']=this.value'
						+ getDateString(tableIndex,iColIndex) + '>');
			else{
				filterHiddenNames[tableId][filterHiddenNames[tableId].length] = DZ[tableIndex][1][iColIndex][15];
				sSearchHtml.append('<input type="text" value="'+ sValue +'"'
						+ ' listfilter2="true" tablecolindex="'+DZ[tableIndex][1][iColIndex][15]+'" onChange=filterHiddenValues["'+tableId+'"]["'+DZ[tableIndex][1][iColIndex][15]+'"]=this.value;'
						+ getDateString(tableIndex,iColIndex) +'>');
			}
			
				
		}
	}
	//生成按钮
	sSearchHtml.append('<div>' + DWFullFiterButtons + '</div>');
	//sSearchHtml.append('<div><input type="button" value="确定" onclick="tableSearchFromInput();closeFullFilter('+tableIndex+',event)">');
	//sSearchHtml.append('<input type="button" value="清空" onclick="TableFactory.clearFilter('+tableIndex+');openFullFilter('+tableIndex+',event);tableSearchFromInput();">');
	//sSearchHtml.append('<input type="button" value="返回" onclick=closeFullFilter('+tableIndex+',event,true)>');
	//sSearchHtml.append('<input type="button" value="关闭" onclick="closeFullFilter('+tableIndex+',event)"></div>');
	filterobj.innerHTML = sSearchHtml.toString();
}
function setFilterOptions(tableId,dzcolindex,value){
	filterOptions[tableId][dzcolindex]=value;
}
function getFilterOptionSelection(tableId,dzcolindex,value){
	//alert("TablePage.from=" + TablePage.from + "|" + filterOptions[tableId][dzcolindex] + "|"+G_SearchArea_Selection+"|" + value);
	if(filterOptions[tableId][dzcolindex]==value)
		return "selected";
	else if(TablePage.from=="" && G_SearchArea_Selection==value){//初始化显示
		//alert(TablePage.from);
		return "selected";
	}
	else if(filterOptions[tableId][dzcolindex]==undefined && G_SearchArea_Selection==value)
		return "selected";
	else
		return "";
}
function getDateString(tableIndex,iColIndex){
	var dateString = "";
	if(DZ[tableIndex][1][iColIndex][11]=='Date'){
		var sMin = "1900/01/01";
		var sMax = "2100/12/31";
		dateString = " onclick=\"SelectDate(this,'yyyy\/MM\/dd','"+sMin+"','"+sMax+"')\"";
	}
	return dateString;
}

function as_returnCheckBoxResult(){
	var parentObj = document.getElementById("DIV_CheckBox_Selector");
	var childNodes = parentObj.childNodes;
	for(var i=0;i<childNodes.length;i++){
		var obj = childNodes[i];
		if(obj.tagName.toUpperCase()=="LABEL"){
			var ckobj =  obj.firstChild;
			//alert(ckobj.outerHTML);
		}
	}
}

function as_openCheckBoxSelector(datas,displayid,i,iColIndex,evt){
	if(datas=="")return;
	var tableIndex = 0;
	var tableId = "myiframe" + tableIndex;
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iColIndex);
	var sValue = filterValues[tableId][iTableColIndex];
	if(iTableColIndex==-1){
		sValue = filterHiddenValues[tableId][DZ[tableIndex][1][iColIndex][15]];
	}
	if(sValue==undefined)sValue = "";
	var aData = datas.split(",");
	var sbHtml = new StringBuffer();
	sbHtml.append("<div id='DIV_CheckBox_Selector' style='height:200px;overflow:auto;'>");
	for(var ii=0;ii<aData.length;ii+=2){
		var sel = "";
		if(ii==0 && DZ[tableIndex][1][iColIndex][20][ii]=="")continue;
		if(TableBuilder.isStrInArray(sValue.split("|"),DZ[tableIndex][1][iColIndex][20][ii])>-1)sel = "checked";
		if(DZ[tableIndex][1][iColIndex][2]=='1')
			sbHtml.append('<label style="width:'+TableFactory.FilterCheckBoxWidth+';overflow:hidden" nowrap title="'+DZ[tableIndex][1][iColIndex][20][ii+1]+'"><input type="checkbox" name="DOFILTER_DF_'+ filterNames[tableIndex][i].toUpperCase() +'_1_VALUE" value="'+ DZ[tableIndex][1][iColIndex][20][ii] +'" '+ sel +' onclick=setFilterValue(this.parentNode.parentNode,"'+tableId+'",'+iTableColIndex+')>'+ DZ[tableIndex][1][iColIndex][20][ii+1] +'&nbsp;</label>');
		else
			sbHtml.append('<label style="width:'+TableFactory.FilterCheckBoxWidth+';overflow:hidden" nowrap title="'+DZ[tableIndex][1][iColIndex][20][ii+1] +'"><input type="checkbox" name="DOFILTER_DF_'+ filterNames[tableIndex][i].toUpperCase() +'_1_VALUE" value="'+ DZ[tableIndex][1][iColIndex][20][ii] +'" '+ sel +' onclick=setFilterHiddenValue(this.parentNode.parentNode,"'+tableId+'","'+DZ[tableIndex][1][iColIndex][15]+'")>'+ DZ[tableIndex][1][iColIndex][20][ii+1] +'&nbsp;</label>');
	}
	sbHtml.append('<label style="width:'+TableFactory.FilterCheckBoxWidth+'"><input type="checkbox" value="" onclick=setFilterChecks(this.parentNode.parentNode,this);');
	if(DZ[tableIndex][1][iColIndex][2]=='1'){
		sbHtml.append('setFilterValue(this.parentNode.parentNode,"'+tableId+'",'+iTableColIndex+')');
	}
	else{
		sbHtml.append('setFilterHiddenValue(this.parentNode.parentNode,"'+tableId+'","'+DZ[tableIndex][1][iColIndex][15]+'")');
	}
	sbHtml.append('>全选</label></span>');
	
	sbHtml.append("</div>");
	openDWDialog(sbHtml.toString());
	document.getElementById("DWOverLayoutSubDiv").style.top = evt.clientY;
	document.getElementById("DWOverLayoutSubDiv").style.left = evt.clientX;
	
}
function openFilterArea(divid,tableIndex,evt){
	var tableId = "myiframe" + tableIndex;
	var filterobj = document.getElementById(divid);
	var sSearchHtml = new StringBuffer();
	sSearchHtml.append('<table width="100%" border="0" cellspacing="0" cellpadding="0">');
	//sSearchHtml.append('<form name="AS_Form_Search" id="AS_Form_Search">');
	for(var i=0;i<aDWfilterTitles[tableIndex].length;i++){
		if(aDWfilterTitles[tableIndex][i]==undefined || aDWfilterTitles[tableIndex][i]=='')continue;
		var iColIndex = getColIndex(tableIndex,filterNames[tableIndex][i]);
		//如果为隐藏字段也不显示--注销 by flian 2011/07/18
		//if(DZ[tableIndex][1][iColIndex][2]!='1')continue;
		var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iColIndex); 
		var sValue = filterValues[tableId][iTableColIndex];
		//alert("iColIndex=" + filterValues[tableId][0]);
		if(iTableColIndex==-1){
			sValue = filterHiddenValues[tableId][DZ[tableIndex][1][iColIndex][15]];
		}
		if(sValue==undefined)sValue = "";
		sSearchHtml.append("<tr><td width='100'  valign='top'>" + aDWfilterTitles[tableIndex][i] + "：</td>");
		//根据取值范围显示控件
		//alert(1);
		//alert("DZ[tableIndex][1]["+iColIndex+"][20] = " + DZ[tableIndex][1][iColIndex][20]);
		if(DZ[tableIndex][1][iColIndex][20] && DZ[tableIndex][1][iColIndex][20]!=""){
			//插入操作符号
			var sInputOptions = "<select name='DOFILTER_DF_"+ filterNames[tableIndex][i] +"_1_OP'><option value='In' "+getFilterOptionSelection(tableId,iColIndex,'In')+">等于　　　</option></select>";
			sSearchHtml.append("<td width='60' valign='top'><span  id='DOFILTER_MAIN0_"+filterNames[tableIndex][i].toUpperCase()+"'>" + sInputOptions + "</span></td><td  valign='top'><span  id='DOFILTER_MAIN1_"+filterNames[tableIndex][i].toUpperCase()+"'>");
			if(DZ[tableIndex][1][iColIndex][20].length/2<TableFactory.CheckBoxDisplayMax){
				for(var ii=0;ii<DZ[tableIndex][1][iColIndex][20].length;ii+=2){
					var sel = "";
					if(ii==0 && DZ[tableIndex][1][iColIndex][20][ii]=="")continue;
					if(TableBuilder.isStrInArray(sValue.split("|"),DZ[tableIndex][1][iColIndex][20][ii])>-1)sel = "checked";
					if(DZ[tableIndex][1][iColIndex][2]=='1')
						sSearchHtml.append('<label style="width:'+TableFactory.FilterCheckBoxWidth+';overflow:hidden" nowrap title="'+DZ[tableIndex][1][iColIndex][20][ii+1]+'"><input type="checkbox" name="DOFILTER_DF_'+ filterNames[tableIndex][i].toUpperCase() +'_1_VALUE" value="'+ DZ[tableIndex][1][iColIndex][20][ii] +'" '+ sel +' onclick=setFilterValue(this.parentNode.parentNode,"'+tableId+'",'+iTableColIndex+')>'+ DZ[tableIndex][1][iColIndex][20][ii+1] +'&nbsp;</label>');
					else
						sSearchHtml.append('<label style="width:'+TableFactory.FilterCheckBoxWidth+';overflow:hidden" nowrap title="'+DZ[tableIndex][1][iColIndex][20][ii+1] +'"><input type="checkbox" name="DOFILTER_DF_'+ filterNames[tableIndex][i].toUpperCase() +'_1_VALUE" value="'+ DZ[tableIndex][1][iColIndex][20][ii] +'" '+ sel +' onclick=setFilterHiddenValue(this.parentNode.parentNode,"'+tableId+'","'+DZ[tableIndex][1][iColIndex][15]+'")>'+ DZ[tableIndex][1][iColIndex][20][ii+1] +'&nbsp;</label>');
				}
				sSearchHtml.append('<label style="width:'+TableFactory.FilterCheckBoxWidth+'"><input type="checkbox" value="" onclick=setFilterChecks(this.parentNode.parentNode,this);');
				if(DZ[tableIndex][1][iColIndex][2]=='1'){
					sSearchHtml.append('setFilterValue(this.parentNode.parentNode,"'+tableId+'",'+iTableColIndex+')');
				}
				else{
					sSearchHtml.append('setFilterHiddenValue(this.parentNode.parentNode,"'+tableId+'","'+DZ[tableIndex][1][iColIndex][15]+'")');
				}
				sSearchHtml.append('>全选</label></span>');
			}
			else{
				sSearchHtml.append("<span style='cursor:pointer' onclick=as_openCheckBoxSelector('"+DZ[tableIndex][1][iColIndex][20].toString()+"','DOFILTER_MAIN1_"+filterNames[tableIndex][i].toUpperCase()+"',"+i+","+iColIndex+",event)>选择</span></span>");
			}
			
			sSearchHtml.append('<span id="DOFILTER_EXTSP_'+filterNames[tableIndex][i].toUpperCase()+'"></span>');
			sSearchHtml.append("</td>");
		}
		else{
			//插入操作符号
			var sInputOptions = "<select name='DOFILTER_DF_"+ filterNames[tableIndex][i] +"_1_OP' onchange=showFM('"+tableId+"',"+iColIndex+",this.value,'"+filterNames[tableIndex][i]+"')><option value='BeginsWith' "+getFilterOptionSelection(tableId,iColIndex,'BeginsWith')+">以…开始</option><option value='NotBeginsWith' "+getFilterOptionSelection(tableId,iColIndex,'NotBeginsWith')+">不以…开始</option><option value='Equals' "+getFilterOptionSelection(tableId,iColIndex,'Equals')+">等于　　</option><option value='Not' "+getFilterOptionSelection(tableId,iColIndex,'Not')+">不等于　</option><option value='BigThan' "+getFilterOptionSelection(tableId,iColIndex,'BigThan')+">大于</option><option value='BigEqualsThan' "+getFilterOptionSelection(tableId,iColIndex,'BigEqualsThan')+">大于等于</option><option value='LessThan' "+getFilterOptionSelection(tableId,iColIndex,'LessThan')+">小于</option><option value='LessEqualsThan' "+getFilterOptionSelection(tableId,iColIndex,'LessEqualsThan')+">小于等于</option><option value='Area' "+getFilterOptionSelection(tableId,iColIndex,'Area')+">在…之间</option>";
			if(bListFuzzyQuery){
				sInputOptions += "<option value='Like' "+getFilterOptionSelection(tableId,iColIndex,'Like')+">包含</option>";
				//sInputOptions += "<option value='NotLike' "+getFilterOptionSelection(tableId,iColIndex,'NotLike')+">不包含</option>";
			}
			sInputOptions += "</select>";
			
			var dateString = getDateString(tableIndex,iColIndex);
			var afterString= "";
			//alert("DZ["+tableIndex+"][1]["+iColIndex+"][21]=" + DZ[tableIndex][1][iColIndex][21]);
			if(dateString.length>0 || (DZ[tableIndex][1][iColIndex][12]==5 || DZ[tableIndex][1][iColIndex][12]==2 || DZ[tableIndex][1][iColIndex][12]==6 || DZ[tableIndex][1][iColIndex][12]==7 || DZ[tableIndex][1][iColIndex][12]>10)){//日期控件和数字控件 需要重新设置调整键
				sInputOptions = "<select name='DOFILTER_DF_"+ filterNames[tableIndex][i] +"_1_OP' onchange=showFM('"+tableId+"',"+iColIndex+",this.value,'"+filterNames[tableIndex][i]+"')><option value='Equals' "+getFilterOptionSelection(tableId,iColIndex,'Equals')+">等于　　　</option><option value='Not' "+getFilterOptionSelection(tableId,iColIndex,'Not')+">不等于　</option><option value='BigThan' "+getFilterOptionSelection(tableId,iColIndex,'BigThan')+">大于</option><option value='BigEqualsThan' "+getFilterOptionSelection(tableId,iColIndex,'BigEqualsThan')+">大于等于</option><option value='LessThan' "+getFilterOptionSelection(tableId,iColIndex,'LessThan')+">小于</option><option value='LessEqualsThan' "+getFilterOptionSelection(tableId,iColIndex,'LessEqualsThan')+">小于等于</option><option value='Area' "+getFilterOptionSelection(tableId,iColIndex,'Area')+">在…之间</option>";
			}
			else if(DZ[tableIndex][1][iColIndex][21] && DZ[tableIndex][1][iColIndex][21]!=""){
				var aTempColFilterAttrs = DZ[tableIndex][1][iColIndex][21].split(",");
				var sTempColFilterConditions = "";
				if(TableFactory.FilterConditions[filterNames[tableIndex][i].toUpperCase()]){
					sTempColFilterConditions =TableFactory.FilterConditions[filterNames[tableIndex][i].toUpperCase()];
				}
				else{
					//for(var ii=1;ii<aTempColFilterAttrs;ii<aTempColFilterAttrs.length-1){
					for(var ii=1;ii<aTempColFilterAttrs.length-1;ii++){
						if(ii==1)
							sTempColFilterConditions = aTempColFilterAttrs[ii];
						else
							sTempColFilterConditions += "," + aTempColFilterAttrs[ii];
					}
				}
				//alert("sTempColFilterConditions=" + sTempColFilterConditions);
				var sValueTitle = "";
				sValueTitle = filterTitles[tableId][filterNames[tableIndex][i].toUpperCase()];
				if(sValueTitle==undefined)sValueTitle="";
				sInputOptions = "<select name='DOFILTER_DF_"+ filterNames[tableIndex][i] +"_1_OP' onchange=showFM('"+tableId+"',"+iColIndex+",this.value,'"+filterNames[tableIndex][i]+"')><option value='In' "+getFilterOptionSelection(tableId,iColIndex,'In')+">等于　　</option><option value='Like' "+getFilterOptionSelection(tableId,iColIndex,'Like')+">包含　　</option>";
				//afterString= "<span id=DOFILTER_DF_"+ filterNames[tableIndex][i].toUpperCase() +"_1_VALUE_TITLE>"+sValueTitle+"</span><input class=\"info_unit_button\" value=\"...\" type=button onClick=TableFactory.SetGridValue('"+filterNames[tableIndex][i].toUpperCase()+"','DOFILTER_DF_"+ filterNames[tableIndex][i].toUpperCase() +"_1_VALUE','"+aTempColFilterAttrs[0]+"','"+aTempColFilterAttrs[1]+"','DOFILTER_DF_"+ filterNames[tableIndex][i].toUpperCase() +"_1_VALUE="+aTempColFilterAttrs[2]+"')>";
				afterString= "<input readonly=true style=\"background-color:#dddddd;color:#000000\" id=DOFILTER_DF_"+ filterNames[tableIndex][i].toUpperCase() +"_1_VALUE_TITLE value='" + sValueTitle+"' > <input class=\"info_unit_button\" value=\"...\" type=button onClick=TableFactory.SetGridValue('"+filterNames[tableIndex][i].toUpperCase()+"','DOFILTER_DF_"+ filterNames[tableIndex][i].toUpperCase() +"_1_VALUE','"+aTempColFilterAttrs[0]+"','"+sTempColFilterConditions+"','DOFILTER_DF_"+ filterNames[tableIndex][i].toUpperCase() +"_1_VALUE="+aTempColFilterAttrs[aTempColFilterAttrs.length-1]+"')>";
				dateString = ' readonly="readonly" style="color:#999;display:none"';
			}
			sSearchHtml.append("<td width='60'><span  id='DOFILTER_MAIN0_"+filterNames[tableIndex][i].toUpperCase()+"'>" + sInputOptions + "</span></td><td><span  id='DOFILTER_MAIN1_"+filterNames[tableIndex][i].toUpperCase()+"'>");
			if(DZ[tableIndex][1][iColIndex][2]=='1'){
				sSearchHtml.append('<input type="text" name="DOFILTER_DF_'+ filterNames[tableIndex][i].toUpperCase() +'_1_VALUE" listfilter="true" tablecolindex="'+iTableColIndex+'" value="'+ sValue +'"'
						+ ' onChange=filterValues["'+tableId+'"]['+iTableColIndex+']=this.value'
						+ dateString + '>' + afterString);
			}
			else{
				filterHiddenNames[tableId][filterHiddenNames[tableId].length] = DZ[tableIndex][1][iColIndex][15];
				sSearchHtml.append('<input type="text" name="DOFILTER_DF_'+ filterNames[tableIndex][i].toUpperCase() +'_1_VALUE" tablecolindex="'+iTableColIndex+'" listfilter="true" value="'+ sValue +'"'
						+ ' onChange=filterHiddenValues["'+tableId+'"]["'+DZ[tableIndex][1][iColIndex][15]+'"]=this.value'
						+ dateString + '>' + afterString);
			}
			var spvaldisplay = "none";
			if(getFilterOptionSelection(tableId,iColIndex,'Area').length>0)spvaldisplay="inline";
			sSearchHtml.append('<span id="SPVAL2_'+tableId+'_'+iColIndex+'" style="display:'+spvaldisplay+'">-<input type="text" listfilter_area="true" dzcolindex="'+iColIndex+'" value="'+ (filterValues2[tableId][iColIndex]?filterValues2[tableId][iColIndex]:"") +'"'
				+ ' name="DOFILTER_DF_'+ filterNames[tableIndex][i].toUpperCase() +'_2_VALUE" onChange=filterValues2["'+tableId+'"]['+iColIndex+']=this.value'
				+ dateString + '></span>');
			sSearchHtml.append('</span><span id="DOFILTER_EXTSP_'+filterNames[tableIndex][i].toUpperCase()+'"></span>');
		}
		sSearchHtml.append("</td></tr>");
	}
	//sSearchHtml.append('</form>');
	sSearchHtml.append('</table>');
	//生成按钮
	sSearchHtml.append('<div>' + DWFullFiterButtons2 + '</div>');
	filterobj.innerHTML = sSearchHtml.toString();
}

function showFM(tableId,dzcolindex,value,colname){
	colname=colname.toUpperCase();
	filterOptions[tableId][dzcolindex] = value;
	var obj = document.getElementById('DOFILTER_DF_'+ colname +'_1_FM');
	if(obj){
		if(value=='BeginsWith'){
			obj.style.display='inline';
		}
		else{
			obj.style.display='none';
		}
	}
	var objval2 = document.getElementById('SPVAL2_'+tableId+'_'+dzcolindex+'');
	//alert(objval2);
	if(value=="Area"){
		objval2.style.display='inline';
	}
	else{
		objval2.style.display='none';
	}
	
}
function expandFilterArea(divid,divobj,evt){
	var status = divobj.getAttribute("open");
	if(status == "1"){
		document.getElementById(divid).style.display = 'none';
		divobj.setAttribute("open","0");
		divobj.firstChild.innerHTML = "+";
		divobj.parentNode.style.borderTopWidth = 0;
		divobj.parentNode.style.borderLeftWidth = 0;
		divobj.parentNode.style.borderRightWidth = 0;
		divobj.parentNode.style.borderBottomWidth = 0;
	}
	else{
		openFilterArea("TableFilter_AREA",0,evt);
		document.getElementById(divid).style.display = 'block';
		divobj.setAttribute("open","1");
		divobj.firstChild.innerHTML = "-";
		divobj.parentNode.style.borderTopWidth = 1;
		divobj.parentNode.style.borderLeftWidth = 1;
		divobj.parentNode.style.borderRightWidth = 1;
		divobj.parentNode.style.borderBottomWidth = 1;
	}
	change_height();
}
function hideFilterArea(evt){
	var divobj = document.getElementById("TableFilter_AREA_TITLE");
	var divid = "TableFilter_AREA";
	divobj.setAttribute("open","1");
	expandFilterArea(divid,divobj,evt);
}
function setFilterExtHtml(tableId,colname,html){
	var extid = "DOFILTER_EXTSP_" + colname.toUpperCase();
	var extobj = document.getElementById(extid);
	extobj.innerHTML = html;
}

function showFilterforSelection(tableId,colname){
	var spanid0 = "DOFILTER_MAIN0_"+colname.toUpperCase() ;
	var spanobj0 = document.getElementById(spanid0);
	spanobj0.style.display = "inline";
	var spanid1 = "DOFILTER_MAIN1_"+colname.toUpperCase() ;
	var spanobj1 = document.getElementById(spanid1);
	spanobj1.style.display = "inline";
}
function hideFilterforSelection(tableId,colname){
	var spanid0 = "DOFILTER_MAIN0_"+colname.toUpperCase() ;
	var spanobj0 = document.getElementById(spanid0);
	spanobj0.style.display = "none";
	var spanid1 = "DOFILTER_MAIN1_"+colname.toUpperCase() ;
	var spanobj1 = document.getElementById(spanid1);
	spanobj1.style.display = "none";
}

function showFilterArea(){
	var divid = "TableFilter_AREA";
	var divobj= document.getElementById("TableFilter_AREA_TITLE");
	var status = divobj.getAttribute("open");
	if(status == "1"){
		document.getElementById(divid).style.display = 'none';
		divobj.setAttribute("open","0");
		divobj.firstChild.innerHTML = "+";
	}
	else{
		document.getElementById(divid).style.display = 'block';
		divobj.setAttribute("open","1");
		divobj.firstChild.innerHTML = "-";
		
	}
}
function closeFullFilter(tableIndex,evt,showParent){
	var tableId = "myiframe" + tableIndex;
	var filterobj = document.getElementById("TableFullFilter_" + tableId);
	filterobj.style.display = 'none';
	
	if(showParent)
		document.getElementById("TableFilter").style.display="block";
	else
		document.getElementById("TableFilter").style.display="none";
	//alert(document.getElementById("TableFilter").style.display);
}
function closeFilterArea(divid,evt){
	var filterobj = document.getElementById(divid);
	filterobj.style.display = 'none';
}
//var dwTime = new Array();
//启动快捷键
$().ready(function(event){
	//事件
	if(DZ[0][0][10]){
		for(var i=0;i<DZ[0][0][10].length;i++){
			addListEventListeners(0,undefined,DZ[0][0][10][i][0],DZ[0][0][10][i][1],DZ[0][0][10][i][2],DZ[0][0][10][i][3]);
		}
	}
	//显示过滤区域
	openFilterArea("TableFilter_AREA",0,event);
	//绑定快捷键
	jQuery.initObjectKeyArray();
	$(document).keydown(function(evt){
		//alert(1);
		//alert(evt.srcElement.type=='button' || evt.srcElement.type=='text' || evt.srcElement.type=='checkbox');
		if(evt.srcElement && (evt.srcElement.type=='button' || evt.srcElement.type=='text' || evt.srcElement.type=='checkbox')){
			//alert(evt.srcElement.getAttribute("id")=='Input_Filter' && evt.keyCode==13);
			if(evt.srcElement.getAttribute("id")=='Input_Filter' && evt.keyCode==13){
				filterValues[evt.srcElement.parentNode.getAttribute('tableId')][evt.srcElement.parentNode.colIndex]=evt.srcElement.value;
				tableSearchFromInput(document.getElementsByName('search')[0]);
			}
			else if(evt.srcElement.getAttribute("listfilter")=='true' && evt.keyCode==13){//listfilter
				filterValues["myiframe0"][evt.srcElement.getAttribute("tablecolindex")]=evt.srcElement.value;
				if(tableSearchFromInput(undefined,'fromarea')){
					openFilterArea('TableFilter_AREA',0,event);
					closeFullFilter(0,event);
				}
			}
			else if(evt.srcElement.getAttribute("listfilter_area")=='true' && evt.keyCode==13){//listfilter
				filterValues2["myiframe0"][evt.srcElement.getAttribute("dzcolindex")]=evt.srcElement.value;
				//alert(filterValues2["myiframe0"]);
				if(tableSearchFromInput(undefined,'fromarea')){
					openFilterArea('TableFilter_AREA',0,event);
					closeFullFilter(0,event);
				}
				
			}
			else if(evt.srcElement.getAttribute("listfilter2")=='true' && evt.keyCode==13){//listfilter
				filterValues["myiframe0"][evt.srcElement.getAttribute("tablecolindex")]=evt.srcElement.value;
				if(tableSearchFromInput())
					document.getElementById('TableFilter').style.display='none';
			}
		}
		else if(evt.target && (evt.target.type=='button' || evt.target.type=='text' || evt.target.type=='checkbox')){
			if(evt.target.getAttribute("id")=='Input_Filter' && evt.keyCode==13){
				filterValues[evt.target.parentNode.getAttribute('tableId')][evt.target.parentNode.colIndex]=evt.target.value;
				tableSearchFromInput(document.getElementsByName('search')[0]);
			}
			else if(evt.target.getAttribute("listfilter")=='true' && evt.keyCode==13){//listfilter
				filterValues["myiframe0"][evt.target.getAttribute("tablecolindex")]=evt.target.value;
				if(tableSearchFromInput(undefined,'fromarea')){
					openFilterArea('TableFilter_AREA',0,evt);
					closeFullFilter(0,evt);
				}
			}
			else if(evt.target.getAttribute("listfilter_area")=='true' && evt.keyCode==13){//listfilter
				filterValues2["myiframe0"][evt.target.getAttribute("dzcolindex")]=evt.target.value;
				if(tableSearchFromInput(undefined,'fromarea')){
					openFilterArea('TableFilter_AREA',0,evt);
					closeFullFilter(0,evt);
				}
				
			}
			
			else if(evt.target.getAttribute("listfilter2")=='true' && evt.keyCode==13){//listfilter
				filterValues["myiframe0"][evt.target.getAttribute("tablecolindex")]=evt.target.value;
				if(tableSearchFromInput()){
					document.getElementById('TableFilter').style.display='none';
				}
			}
		}
		else if(evt.keyCode==27 || evt.keyCode==13){
			try{
				if(document.getElementById("DWOverLayoutDiv").style.display=='block')
					autoCloseDWDialog();
			}
			catch(e){}
		}
		jQuery.runByKey(evt.keyCode,evt.shiftKey,evt.ctrlKey,evt.altKey);
	});
	//是否序列化判断
	for(var i=0;i<TableFactory.colReadOnly.length;i++){
		if(TableFactory.colReadOnly[i]=="0")
			v_g_DWIsSerializJbo = "1";
	}
	if(DZ[0][0][9])v_g_DWIsSerializJbo = "1";
	//绑定右键
	createContextMenu(0);
	TableFactory.OldRowCount = tableDatas["myiframe0"].length;
	change_height();
	if(window.afterSearch)afterSearch();
});
function change_height(){	
	if(aDWfilterTitles[0].length==0)document.getElementById('TableFilter_DIV_PARENT').style.display='none';
	document.getElementById("Right_TD_myiframe0").style.width = document.body.offsetWidth - 10;
	document.getElementById("myiframe0_cells").style.width = document.getElementById("Right_TD_myiframe0").style.width
	var myNewHeight = document.body.offsetHeight 
		- document.getElementById("DWTD").offsetTop
		- document.getElementById("myiframe0_float").offsetHeight
		- document.getElementById("TableFilter_DIV_PARENT").offsetHeight;
		//- document.getElementById("TableFilter_AREA_Hidden").offsetHeight;
	//alert(myNewHeight);
	var adjustHeight = 0;
	if(window.getAdjustHeight)
		adjustHeight = getAdjustHeight();
	else
		adjustHeight = getAdjustHeight2();
	document.getElementById("myiframe0_cells").style.height  = myNewHeight-adjustHeight-40;	
}
function getAdjustHeight2(){
	return 0;
}
function checkModified(){
	 var sUnloadMessage = "\n\r当前页面内容已经被修改，\n\r按“取消”则留在当前页，然后再按当前页上的“保存”按钮以保存修改过的数据，\n\r按“确定”则不保存修改过的数据并且离开当前页．";
	 if(as_isPageChanged()){
		 return confirm(sUnloadMessage);
	 }
	 return true;
}
function setFrameHeight(frameId,height){
	if(height=='auto'){
		//alert(window.frames[frameId].window.document.body.scrollHeight+10);
		document.getElementById(frameId).style.height = window.frames[frameId].window.document.body.scrollHeight+10;
	}
	else{
		document.getElementById(frameId).style.height = height;
	}
}
//以下代码是实现复合保存
function as_createFormDatas(){
	var result = new Object();
	result.type="list";
	//"&UPDATED_FIELD=" + getChangedValues(tableIndex) + "&SelectedRows="+ getSelRows(tableIndex).toString() +"&SYS_ACTION=" + action)),
	result.serializedJbo=DZ[0][0][9];
	result.serializedAsd=DZ[0][0][8];
	result.updatedFields=getChangedValues(0);
	
	result.selectedRows=getSelRows(0).toString();
	result.curpage=s_c_p[0];
	
	return result;
}

function as_saveAll(postevents){
	var frameNames = "window";
	for(var i=0;i<getRowCount(0);i++){
		frameNames += ",SUBIFR_" + TableBuilder.pageDepth+"_" + i;
	}
	as_saveFrames(frameNames,postevents);
}
function as_saveFrames(frameNames,postevents){
	as_doAction2(frameNames,undefined,postevents);
}
function as_doAction2(frameNames,actions,postevents){
	var aFrameNames = frameNames.split(",");
	var aActions;
	if(actions){
		aActions = actions.split(",");
		if(aFrameNames.length!=aActions.length){
			alert('提交参数错误');
			return;
		}
	}
	
	var dataValid = true;
	//数据校验
	for(var i=0;i<aFrameNames.length;i++){
		var frameObj;
		if(aFrameNames[i]=="window")
			frameObj = window;
		else
			frameObj=window.frames[aFrameNames[i]];
		if(frameObj.iV_all && frameObj.iV_all(0)==false){
			dataValid = false;
			frameObj.showErrors(0);
		}
	}
	if(dataValid){
		//获得提交数据
		var postDataJson= new StringBuffer();
		postDataJson.append("{");
		for(var i=0;i<aFrameNames.length;i++){
			var frameObj;
			if(aFrameNames[i]=="window")
				frameObj = window;
			else
				frameObj=window.frames[aFrameNames[i]];
			//window.frames[aFrameNames[i]];
			if(i>0)postDataJson.append(",");
			if(frameObj.checkElementsChange)
				frameObj.checkElementsChange(0);//保存修改的字段
			as_getPostJsonData(postDataJson,frameObj,aActions?aActions[i]:'save');
		}
		postDataJson.append("}");
		//document.write(postDataJson.toString());
		//发起post提交
		as_PostData(postDataJson.toString(),postevents);
	}
}
function as_PostData(data,postevents){
	openDWDialog();
	$.ajax({
	   type: "POST",
	   url: sDWResourcePath + "/MultiPageSave.jsp",
	   processData: false,
	   data: "data=" + data,
	   success: function(msg){
		var result = eval("(" + msg + ")");
		if(result.status=="success"){
			msg = "操作成功";
			//alert("result.resultInfos=" + result.resultInfos.frame_info);
			for(var frameName in result.resultInfos){
				aDWResultInfo[frameName] = result.resultInfos[frameName];
				//alert("frameName=" + frameName + ",aDWResultInfo[frameName]=" + aDWResultInfo[frameName]);
			}
			//aDWResultInfo[tableIndex] = result.resultInfo;
			if(postevents==undefined) postevents="";
			resetDWDialog(msg,true);
			if(postevents.length>0)eval("("+postevents+")");
		}
		else{
			resetDWDialog(result.errors,false);
		}
	   }
	});
}
function as_getPostJsonData(postDataJson,frameObj,action){
	if(!frameObj.as_createFormDatas)return;
	var framePostData = frameObj.as_createFormDatas();
	postDataJson.append('"'+frameObj.name+'":{');
	postDataJson.append('"serializedJbo":"'+framePostData.serializedJbo+'",');
	postDataJson.append('"serializedAsd":"'+framePostData.serializedAsd+'",');
	postDataJson.append('"type":"'+framePostData.type+'",');
	postDataJson.append('"action":"'+action+'",');
	
	if(framePostData.type=='info'){
		postDataJson.append('"updatedFields":{');
		//alert('framePostData.updatedFields='+ framePostData.updatedFields);
		for(var j=0;j<framePostData.updatedFields.length;j++){
			if(j>0){
				postDataJson.append(',');
			}
			//postDataJson.append('{');
			postDataJson.append('"'+framePostData.updatedFields[j]+'":"'+ replaceSpecialHtml(framePostData.fieldValues[framePostData.updatedFields[j]]) +'"');
			//postDataJson.append('{');
		}
		postDataJson.append('},');
		
		postDataJson.append('"allFieldValues":{');
		//alert('framePostData.updatedFields='+ framePostData.updatedFields);
		for(var j=0;j<framePostData.allFieldNames.length;j++){
			if(j>0){
				postDataJson.append(',');
			}
			//postDataJson.append('{');
			postDataJson.append('"'+framePostData.allFieldNames[j]+'":"'+ replaceSpecialHtml(framePostData.allFieldValues[framePostData.allFieldNames[j]]) +'"');
			//postDataJson.append('{');
		}
		postDataJson.append('}');
		
	}
	else if(framePostData.type=='list'){
		postDataJson.append('"updatedFields":"'+replaceSpecialHtml(framePostData.updatedFields)+'",');
		postDataJson.append('"selectedRows":"'+ framePostData.selectedRows +'",');
		postDataJson.append('"curpage":' + framePostData.curpage);
	}
	postDataJson.append('}');
}
function replaceSpecialHtml(html){
	html = html.replace(/&/g,"⊙≌□");
	html = html.replace(/"/g,'\"');
	return encodeURI(encodeURI(html));
}