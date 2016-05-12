var _user_validator = new Array();//保存验证规则
var _user_valid_errors = new Array();
var filterNames = new Array();
var aDWfilterTitles = new Array();
var aDWResultInfo = new Array();
var aDWResultError = new Array();
TableFactory.ColValidInfo = new Array();//是否只读
TableFactory.OldRowCount = -1;
var PageQueryString = new Array();//保存本页面request参数
var SAVE_TMP = false;
var DisplayDONO = "";//用于debug条获取dono
var iOverDWHandler;
var as_dw_sMessage = "";
var as_dw_sPostEvent = "";
var v_g_DWIsSerializJbo = "0";//是否需要序列化
var bDWConvertCode = false;//是否将代码转换成标题
//var dwTime = new Array();
var sWDColors = ["#f2f2f2","#FFF",'#DEE5CD','#B4CBFF'];//add in 2011/10/25


function getFilterIndexByName(tableIndex,name){
	for(var i=0;i<filterNames[tableIndex].length;i++){
		if(filterNames[tableIndex][i].toUpperCase() == name.toUpperCase())
			return i;
	}
	return 0;
}
function as_sublist(argValueArray){
	for(var ii=0;ii<argValueArray.length;ii++){
		var trid = 'TR_Right_myiframe0_'+ ii;
		var tr = document.getElementById(trid);
		var td = tr.childNodes[0];
		TableFactory.addEventWithParams2(td,"click",TableBuilder.setSubList,[(ii+1),argValueArray[ii],td]);
	}
}
function tableSearchFromInput(obj){
	var tableIndex = 0;
	if(obj){
		tableIndex = obj.parentNode.getAttribute("tableId").substring(8);
	}
	TableFactory.search(tableIndex,undefined,v_g_DWIsSerializJbo);
	if(obj){
		obj.parentNode.style.display='none';
	}
}

function getColIndex(dwname,sCol){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var iDW = dwname.substring(8);
	for(i=0;i<DZ[iDW][1].length;i++)
	{
		if(DZ[iDW][1][i][15].toUpperCase()==sCol.toUpperCase()) return i;
	};
	return -1;
}

function getLockAreaWidths(tableId){
	return TableBuilder.getLockAreaWidths(tableId);
}

function iV_all(dwname){
	
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
			for(var i=0;i<iDataSize;i++){
				var sColValue = getItemValue(tableIndex,i,sColName);//获得字段值
				sColValue = sColValue.replace(/\r/g, "");
				element.value = sColValue;
				var bValid = jQuery.validator.methods[method].call( form.validate(), sColValue, element, rule.parameters,i );
				if(bValid==false){
					bResult = false;
					var iColIndex = getColIndex(tableIndex,sColName);
					var title = DZ[tableIndex][1][iColIndex][0];
					if(_user_valid_errors[tableIndex]){
						_user_valid_errors[tableIndex].append("<br>" + title + ":" + validator.messages[sColName.toUpperCase()][method] + "[第" + (i+1) +"行]");
					}
					else{
						_user_valid_errors[tableIndex] = new StringBuffer();
						_user_valid_errors[tableIndex].append(title + ":" + validator.messages[sColName.toUpperCase()][method] + "[第" + (i+1) +"行]");
					}
					TableFactory.ColValidInfo[tableIndex][TableFactory.ColValidInfo[tableIndex].length] = [i,sColName];
				}
			}
		}
	}
	return bResult;
}

function showErrors(dwname){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var tableIndex = dwname.substring(8);
	var tableId = "myiframe" + tableIndex;
	
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
	var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iDZColIndex);
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
	if(iTableColIndex>-1)
		return	tableDatas[tableId][rowindex][iTableColIndex];
	else
		return DZ[tableIndex][2][rowindex][iDZColIndex];
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
			//alert(tableIndex+","+"INPUT_"+ tableId +"_" + DZ[tableIndex][1][iDZColIndex][15]+","+ DZ[tableIndex][1][iDZColIndex][11]+","+ sValue+","+ DZ[tableIndex][1][iDZColIndex][20]+","+ rowindex+","+ iTableColIndex);
			//div.innerHTML = TableBuilder.createInput(tableId,"INPUT_"+ tableId +"_" + DZ[tableIndex][1][iDZColIndex][15], DZ[tableIndex][1][iDZColIndex][11], sValue, DZ[tableIndex][1][iDZColIndex][20], rowindex, iTableColIndex);
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
				obj.value = sValue;
			}
		}
		else{
			
			var sValue = TableBuilder.convertJS2HTML(value);
			//alert(document.getElementById("INPUT_" + tableId + "_" + sColName + "_" + rowindex + "_" + iTableColIndex).outerHTML);
			var obj = getObj(tableIndex,rowindex,sColName);
			obj.innerHTML = sValue;
			/*
			var html = div.innerHTML;//获得div下html代码
			//alert(html);
			var regExp = /<IMG[\w\W]+?>/;
			regExp.exec(html);
			//如果有图片则获得图片代码
			var imgHtml ="";
			if(RegExp.index>0)
				imgHtml = html.substr(RegExp.index,RegExp.lastIndex-RegExp.index);
			
			div.innerHTML = imgHtml + TableBuilder.convertJS2HTML(value);
			*/
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
	if(tableDatas.length==0)return 0;
	return tableDatas[tableId].length;
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
	tr.setAttribute("tableId", tableId);
	tr.setAttribute("id", "TR_Left_"+ tableId +"_"+ iLastRow);
	TableFactory.addEventWithParams4(tr,"mouseover",TableBuilder.TRMouseOver,iLastRow,tr,undefined,sWDColors[3]);
	TableFactory.addEventWithParams4(tr,"mousedown",TableBuilder.TRClick,iLastRow,tr,undefined,sWDColors[3]);
	TableFactory.addEventWithParams4(tr,"mouseout",TableBuilder.TRMouseOut,iLastRow,tr,undefined,sWDColors[3]);
	tbody.appendChild(tr);
	var dzColIndex = 0;
	var iFirstIndex = -1;
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
	TableBuilder.reloadDate();
	lightRow(0,iLastRow);//高亮第一行
	//document.write(document.getElementById("myiframe0").outerHTML);
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
	   data: "para=" + params ,
	   success: function(msg){
		var result = eval("(" + msg + ")");
		if(result.status=="success"){
			try{
				//alert("v_g_DWIsSerializJbo = " + v_g_DWIsSerializJbo);
				TableFactory.search(dwname,undefined,v_g_DWIsSerializJbo);
				aDWResultError[dwname] = '';
				aDWResultInfo[dwname] = result.resultInfo;
				msg = "删除成功";
				if(postevents==undefined) postevents="undefined";
			}
			catch(e){
				msg = "删除成功，但是页面刷新失败："+e.toString();
			}
			TableBuilder.reloadDateForAsync();
			resetDWDialog(msg,true);
		}
		else{
			aDWResultInfo[dwname] = '';
			aDWResultError[dwname] = result.errors;
			//updateSuccess(result.errors);
			TableBuilder.reloadDateForAsync();
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

function as_doAction(dwname,postevents,action){
	
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
	else{
		if(iV_all(tableIndex)==false){
			showErrors(tableIndex);
			return;
		}
	}
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
					TableFactory.search(tableIndex,undefined,"1");
					aDWResultInfo[tableIndex] = result.resultInfo;
					msg = "操作成功";
					if(postevents==undefined) postevents="";
				}
				catch(e){
					msg = "操作成功，但是页面刷新失败："+e.toString();
				}
				try{
					TableBuilder.reloadDateForAsync();
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
function getChangedValues_Old(tableIndex){
	var result = new StringBuffer();
	result.append("<root>");
	var tableId = "myiframe" + tableIndex;
	for(var i=0;i<tableDatas[tableId].length;i++){
		var first = true;
		for(var j=0;j<tableDatas[tableId][i].length;j++){
			var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,j);
			var sOldValue = DZ[tableIndex][2][i][iDZColIndex];
			var sNewValue = tableDatas[tableId][i][j];
			if(sOldValue!=sNewValue){
				//sNewValue = encode(sNewValue);
				if(first){
					result.append("<row index=\""+ i +"\">");
					result.append("<col name=\""+ DZ[tableIndex][1][iDZColIndex][15] +"\">"+ sNewValue +"</col>");
					first = false;
				}
				else
					result.append("<col name=\""+ DZ[tableIndex][1][iDZColIndex][15] +"\">"+ sNewValue +"</col>");
			}
		}
		if(first==false)
			result.append("</row>");
	}
	result.append("</root>");
	result = result.toString();
	//alert(result);
	return result;
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
	//alert(form);
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
	form.elements["SERIALIZED_ASD"].value = DZ[tableIndex][0][8];
	form.elements["ArgValues"].value = argValues;
	form.elements["FileType"].value = fileType;	
	if(bDWConvertCode)
		form.elements["ConvertCode"].value = "1";
	else
		form.elements["ConvertCode"].value = "";
	form.submit();
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
	/*
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
			elements[i].value = "";
			filterValues[tableId][iTableColIndex] = "";
		}
	}
	*/
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
	TableFactory.search(tableIndex,undefined,v_g_DWIsSerializJbo);
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
	var params = "&SYS_SortIndex=" + DZ[tableIndex][1][iDZColIndex][15] + "&SYS_SortDirect=" + sortDirect;
	TableFactory.search(tableIndex,params,v_g_DWIsSerializJbo);
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

TableFactory.search = function(tableIndex,params,isSerializJbo,lightRowIndex){
	if(params==undefined)params="";
	var tableId = "myiframe" + tableIndex;
	for(var i=0;i<filterValues[tableId].length;i++){
		
		if(filterValues[tableId][i]){
			var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,i);
			var sColName = "";
			if(DZ[tableIndex][1][iDZColIndex][19]=="")
				sColName = DZ[tableIndex][1][iDZColIndex][15];
			else
				sColName = DZ[tableIndex][1][iDZColIndex][19];
			
			params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_VALUE=" +encodeURI(filterValues[tableId][i]);
			if(DZ[tableIndex][1][iDZColIndex][20] && DZ[tableIndex][1][iDZColIndex][20].length>0)
				params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=In";
			else
				params += "&DOFILTER_DF_"+ sColName.toUpperCase() +"_1_OP=BeginsWith";
			//alert(params);
			//给汇总框赋值
			//alert(sColName);
			//alert(getFilterIndexByName(tableIndex,sColName));
			var tobj = document.getElementById('DF'+ getFilterIndexByName(tableIndex,sColName) +'_1_INPUT');
			//alert(tobj.outerHTML);
			if(tobj)
				tobj.value = filterValues[tableId][i];
			//alert(tobj.value);
		}
	}
	//alert(sDWResourcePath + "/ListSearch.jsp");
	if(lightRowIndex)
		TableFactory.DO2(sDWResourcePath + "/ListSearch.jsp",tableIndex,"search",undefined,undefined,params,isSerializJbo,lightRowIndex);
	else
		TableFactory.DO(sDWResourcePath + "/ListSearch.jsp",tableIndex,"search",undefined,undefined,params,isSerializJbo);
};

TableFactory.DO2 = function(url,tableIndex,action,postevents,message,searchParams,isSerializJbo,lightRowIndex){
	var tableId = "myiframe" + tableIndex;
	var params = "curpage="+ s_c_p[tableIndex] +"&SYS_ACTION="+action+"&index="+ tableIndex + "&SERIALIZED_ASD=" + DZ[tableIndex][0][8]  +"&SERIALIZED_JBO=" + DZ[tableIndex][0][9] + "&isSerializJbo=" + isSerializJbo;
	if(searchParams){//组合查询条件
		params += searchParams;//searchParams以&开头,所以这里不需要加&
	}
	$.ajax({
	   type: "POST",
	   url: url,
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
	var params = "curpage="+ iNewPage +"&CompClientID"+sCompClientID+"&SYS_ACTION="+action+"&index="+ tableIndex + "&SERIALIZED_ASD=" + DZ[tableIndex][0][8]  +"&SERIALIZED_JBO=" + DZ[tableIndex][0][9] + "&isSerializJbo=" + isSerializJbo;
	if(searchParams){//组合查询条件
		params += searchParams;//searchParams以&开头,所以这里不需要加&
	}
	//alert(isSerializJbo);
	//alert("do");
	$.ajax({
		   type: "POST",
		   url: url,
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

TableFactory.addEventWithParams2 = function(target, eventName, handler, args){
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
	//alert("tableIndex=" + tableIndex);
	var resultHTML = "";
	//获得表格名
	var tableIndex0 = (tableIndex>0?1:0);
	var tableId0 = "myiframe" + tableIndex0;
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
	if(DZ[tableIndex0][0][4]==1){
		clientCount = ["小计",""];
	}
	TableFactory.ColIndexMap[tableId0] = new Array();
	var k = 0;
	
	for(var i=0;i<DZ[tableIndex0][1].length;i++){
		if(DZ[tableIndex0][1][i][1]==1){
			TableFactory.ColKeyIndexs[TableFactory.ColKeyIndexs.length] = i;
		}
		if(DZ[tableIndex0][1][i][2]!=1)continue;//visible字段不显示
		//补充映射关系
		TableFactory.ColIndexMap[tableId0][k] = i;
		//添加标题
		heads[k] = DZ[tableIndex0][1][i][0];
		//添加字段名
		colNames[k] = DZ[tableIndex0][1][i][15];
		//添加小计
		
		if((DZ[tableIndex0][1][i][14]=="2" || DZ[tableIndex0][1][i][14]=="3") && clientCount != undefined){
			
			if(clientCount[1]=="") 
				clientCount[1]= "" + TableFactory.getTableColIndexFromDZ(tableId0,i);
			else
				clientCount[1] += ","+ TableFactory.getTableColIndexFromDZ(tableId0,i);
			//alert(clientCount[1]);
		}
		//获得htmlstyle
		if(DZ[tableIndex0][1][i][10].length>10){
			//alert(DZ[tableIndex0][1][i][10]);
			colHtmlStyle[TableFactory.getTableColIndexFromDZ(tableId0,i)] = DZ[tableIndex0][1][i][10];
		}
		//取值范围需要转换成实字段
		var sColActualName = DZ[tableIndex0][1][i][19];
		if(sColActualName==undefined || sColActualName== "")
			sColActualName = DZ[tableIndex0][1][i][15];
		var iColIndexDz = getColIndex(tableIndex0,sColActualName);
		if(iColIndexDz!=i && DZ[tableIndex0][1][iColIndexDz])
			DZ[tableIndex0][1][i][20] = DZ[tableIndex0][1][iColIndexDz][20];
		//获得取值范围
		if(DZ[tableIndex0][1][iColIndexDz] && DZ[tableIndex0][1][iColIndexDz][20]){
			range[k] = DZ[tableIndex0][1][iColIndexDz][20];
		}
		//是否可排序
		sortable[k] = DZ[tableIndex0][1][i][6];//1表示可排序，0-不可排序
		//对齐方式
		colAlign[k] = DZ[tableIndex0][1][i][8];
		if(colAlign[k]=="")colAlign[k] = 0;
		//显示格式
		checkFormat[k] = DZ[tableIndex0][1][i][12];
		//是否只读
		if(DZ[tableIndex0][0][2]==1)
			TableFactory.colReadOnly[k] =1;
		else
			TableFactory.colReadOnly[k] = DZ[tableIndex0][1][i][3];
		//控件
		colEditStyle[k] = DZ[tableIndex0][1][i][11];
		//unit
		colUnit[k] = DZ[tableIndex0][1][i][17];
		k++;
	}
	
	//获得冻结列数
	var lockCols = DZ[tableIndex0][0][6];
	//alert("lockCols=" + lockCols);
	//添加总计
	if(DZ[tableIndex0][3] && clientCount != undefined){
		serverCount = ["总计"];
		for(var i=0;i<DZ[tableIndex0][3].length;i++){
			var iTable = TableFactory.getTableColIndexFromDZ(tableId0,i);
			//alert(iTable);
			if(iTable>-1)
				serverCount[iTable+1] = DZ[tableIndex0][3][i];
		}
		//alert(serverCount);
	}
	//获得列合并信息
	var combineLeft = DZ[tableIndex0][4]?DZ[tableIndex0][4][0]:undefined;
	var combineRight = DZ[tableIndex0][4]?DZ[tableIndex0][4][1]:undefined;
	//获得宽度
	var defaultWidths = 'self';
	//层次结构
	var depth = DZ[tableIndex0][12];
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
		multySelect:DZ[tableIndex0][0][11]
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
				var jTable = TableFactory.getTableColIndexFromDZ(tableId0,j);
				if(jTable>-1){
					datas[i][jTable] = DZ[tableIndex][2][i][j];
				}
			}
			//alert(datas[i]);
		}
	}
	//alert(heads);
	//生成表格
	//alert("DZ[tableIndex][2]= " + DZ[tableIndex][2]);
	var table =  new TableBuilder(tableId,heads,datas,range,uiparams);
	resultHTML = table.createTableHTML();
	//生成页码:只有超过两页时才显示页码
	//alert("s_r_c[tableIndex]= " + parseInt(s_r_c[tableIndex])>1);
	if(s_p_c>1){
		var iPageSize = s_p_s[tableIndex];
		//alert(iPageSize);
		if(iPageSize==undefined || iPageSize==null || iPageSize=="")
			iPageSize = 10;
		var page = new TablePage(tableId,s_r_c[tableIndex],iPageSize,s_p_c[tableIndex],s_c_p[tableIndex]);
		resultHTML += page.createPageHTML();
	}
	//隐藏显示字段的过滤条件
	/*
    for(var i=0;i<DZ[tableIndex][1].length;i++){
    	if(DZ[tableIndex][1][i][19]!=""){
    		//alert(DZ[tableIndex][1][i][15]);
    		var iFilterIndex = getFilterIndexByName(tableIndex,DZ[tableIndex][1][i][15]);
    		var form = document.getElementsByName("DOFilter")[tableIndex];
    		var elements = form.elements;
    		for(var j=0;j<elements.length;j++){
    			//隐藏多余的操作符，只显示第一个
    			//alert(elements[j].tagName);
    			if(elements[j].tagName=="SELECT")
    				elements[j].options.length = 1;
    		}
    		var td = document.getElementById("DF4_TD_1"); // form.getElementById("DF4_TD_1"); 
    		if(td){
    			var tr = td.parentNode;
    			if(tr)
    				tr.style.display = 'none';
    		}
    	}
    }
    */
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
	var checkboxs = div.childNodes;
	var sValue = "";
	for(var i=0;i<checkboxs.length;i++){
		if(checkboxs[i].checked){
			sValue += "|" + checkboxs[i].value;
		}
	}
	if(sValue!="")sValue = sValue.substring(1);
	filterValues[tableId][tableColIndex] = sValue;
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
		//如果为隐藏字段也不显示
		//if(DZ[tableIndex][1][iColIndex][2]!='1')continue;
		var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,iColIndex); 
		var sValue = filterValues[tableId][iTableColIndex];
		//alert("iColIndex=" + filterValues[tableId][0]);
		if(sValue==undefined)sValue = "";
		sSearchHtml.append("<div>" + aDWfilterTitles[tableIndex][i] + "：</div>");
		//根据取值范围显示控件
		//alert("DZ[tableIndex][1]["+iColIndex+"][20] = " + DZ[tableIndex][1][iColIndex][20]);
		if(DZ[tableIndex][1][iColIndex][20] && DZ[tableIndex][1][iColIndex][20]!=""){
			sSearchHtml.append("<div>");
			for(var ii=0;ii<DZ[tableIndex][1][iColIndex][20].length;ii+=2){
				var sel = "";
				if(ii==0 && DZ[tableIndex][1][iColIndex][20][ii]=="")continue;
				if(TableBuilder.isStrInArray(sValue.split("|"),DZ[tableIndex][1][iColIndex][20][ii])>-1)sel = "checked";
				sSearchHtml.append('<input type="checkbox" value="'+ DZ[tableIndex][1][iColIndex][20][ii] +'" '+ sel +' onclick=setFilterValue(this.parentNode,"'+tableId+'",'+iTableColIndex+')>'+ DZ[tableIndex][1][iColIndex][20][ii+1] +' ');
			}
			sSearchHtml.append("</div>");
		}
		else{
			sSearchHtml.append('<input type="text" value="'+ sValue +'"'
				+ ' onkeypress=if(event.keyCode==13){filterValues["'+tableId+'"]['+iTableColIndex+']=this.value;} onChange=filterValues["'+tableId+'"]['+iTableColIndex+']=this.value'
				+'>');
		}
	}
	//生成按钮
	sSearchHtml.append('<div><input type="button" value="确定" onclick="tableSearchFromInput();closeFullFilter('+tableIndex+',event)">');
	sSearchHtml.append('<input type="button" value="清空" onclick="TableFactory.clearFilter('+tableIndex+');openFullFilter('+tableIndex+',event);tableSearchFromInput();">');
	sSearchHtml.append('<input type="button" value="返回" onclick=closeFullFilter('+tableIndex+',event,true)>');
	sSearchHtml.append('<input type="button" value="关闭" onclick="closeFullFilter('+tableIndex+',event)"></div>');
	filterobj.innerHTML = sSearchHtml.toString();
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
//var dwTime = new Array();
//启动快捷键
$().ready(function(event){
	//事件
	if(DZ[0][0][10]){
		for(var i=0;i<DZ[0][0][10].length;i++){
			addListEventListeners(0,undefined,DZ[0][0][10][i][0],DZ[0][0][10][i][1],DZ[0][0][10][i][2],DZ[0][0][10][i][3]);
		}
	}
	//绑定快捷键
	jQuery.initObjectKeyArray();
	$(document).keydown(function(evt){
		if(evt.srcElement && (evt.srcElement.type=='button' || evt.srcElement.type=='text' || evt.srcElement.type=='checkbox')){
		}
		else if(evt.target && (evt.target.type=='button' || evt.target.type=='text' || evt.target.type=='checkbox')){
			
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
	for(var i=0;i<TableFactory.colReadOnly.length;i++){
		if(TableFactory.colReadOnly[i]=="0")
			v_g_DWIsSerializJbo = "1";
	}
	if(DZ[0][0][9])v_g_DWIsSerializJbo = "1";
	createContextMenu(0);
	TableFactory.OldRowCount = tableDatas["myiframe0"].length;
	change_height();

	
});
