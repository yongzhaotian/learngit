var ARRAY_OLD = new Array();//保存原始值
var ARRAY_NEW = new Array();//保存新值
var ARRAY_LOADED = new Array();//保存载入页面时候的值
var _user_validator = new Array();//保存验证规则
var DisplayFields = new Array();//保存字段数组
var DWColIndexNameMap = new Array();//字段编号与字段名映射关系表
var aDWResultInfo = new Array();
var aDWResultError = new Array();
var CHANGED = false;
var SAVE_TMP = false;
var DisplayDONO = "";//用于debug条获取dono
var iOverDWHandler;
DWSystem = function(){};
DWSystem.bDWRunMyLoad = false;
var bDWConvertCode = true;//是否将代码转换成标题


//控制pictureRadio样式
function setPicRaidoCss(inputid,type){
	//alert(inputid);
	var obj = document.getElementById(inputid);
	//alert(obj);
	//a控件名
	var name = obj.getAttribute("name");
	//关联的hidden控件控件名
	var radioname = obj.getAttribute("radioname");
	//css普通样式
	var css = obj.className.replace("_light","");
	//css点亮样式
	var csslight = css + "_light";
	var elements = document.getElementsByName(name);
	for(var i=0;i<elements.length;i++){
		elements[i].className = css;
	}
	if(type){
		document.getElementsByName(radioname)[0].value = "";
	}
	else{
		
		obj.className = csslight;
		//alert(obj.className);
		//给隐藏域赋值
		//alert(radioname);
		document.getElementsByName(radioname)[0].value = obj.getAttribute("value");
		//alert(document.getElementsByName(radioname)[0].value);
	}
	
}
//格式化输入控件
function maskInputControl(splitChar,formatStr){
	
	var aFormatStr = formatStr.split(splitChar);
	var source = event.srcElement;
	var curIndex = source.id.substring(source.id.lastIndexOf("_")+1);
	curIndex = parseInt(curIndex);
	
	if(event.keyCode==8 && event.srcElement){
		if(curIndex>0){
			var preIndex = curIndex-1;
			var object = document.getElementById(source.name + "_" + preIndex + "");
			//alert("f_" + source.name + "_" + preIndex + "");
			if(source.value==""){
				var txtRange = object.createTextRange();
				object.focus();
				txtRange.moveStart("character",object.value.length);
				txtRange.moveEnd( "character", 0 ); 
				txtRange.select();
			}
		}
	}
	else{
		
		var nextIndex = curIndex+1;
		//alert(aFormatStr[curIndex].length);
		if(source.value.length>=aFormatStr[curIndex].length){
			
			var object = document.getElementById(source.name + "_" + nextIndex + "");
			
			if(object){
				object.focus();
			}
		}
	}
}

//日期格式化
function DateFormat(obj,evt){
	var value = obj.value;
	var name = obj.name;
	if(obj.id == name + '_0'){
		if(keycode<48 || keycode>57)
			evt.keyCode=0;
		if(value.length==4)
			documenet.getElementById(name+ '_1').focus();
	}
	else if(obj.id == name + '_1'){
		if(keycode<48 || keycode>57)
			evt.keyCode=0;
		if(value.length==2)
			documenet.getElementById(name+ '_2').focus();
	}
	else{
		if(keycode<48 || keycode>57)
			evt.keyCode=0;
	}
}
function iV_all(dwname){
	if(beforeCheck(dwname)==false)return false;
	var dwindex;
	if(isNaN(dwname)){
		dwindex = parseInt(dwname.substring(8));
	}
	else{
		dwindex = dwname;
		dwname = "myiframe" + dwindex;
	}
	//alert0(_user_validator[dwindex]);
	document.getElementById("ul_error_0").innerHTML='';
	document.getElementById("ul_error_1").innerHTML='';
	document.getElementById("messageBox").style.display='none';
	var result = $("#" + dwname).validate(_user_validator[dwindex]).form();
	
	return result && afterCheck(dwname);
}

function as_doAction(dwname,postevents,action){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	if(action=="save"){
		as_save(dwname,postevents);
	}
	if(action=="savetmp" || action=="saveTmp"){
		as_saveTmp(dwname,postevents);
	}
	else if(action=="delete"){
		as_delete(dwname,postevents);
	}
	else{
		if(action==undefined || action==null || action=="")
			action = "defaultAction";
		getObj(dwindex,"SYS_SAVETMP").value = "0";
		SAVE_TMP = false;
		as_save0(dwname,dwindex,postevents,action);
	}
}
//删除处理操作
function as_delete(dwname,postevents){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	getObj(dwindex,"POST_EVENTS").value = postevents;
	getObj(dwindex,"SYS_FORMID").value = dwname;
	getObj(dwindex,"SYS_ACTION").value = "delete";
	getObj(dwindex,"SYS_BPDATA").value = "";
	//openwin(sDWResourcePath + '/OverDW.jsp',700,257);
	openDWDialog();
	$("#" + dwname).submit();
}
//保存处理操作
function as_save(dwname,postevents){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	getObj(dwindex,"SYS_SAVETMP").value = "0";
	SAVE_TMP = false;
	as_save0(dwname,dwindex,postevents,"save");
}
//暂存
function as_saveTmp(dwname,postevents){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	getObj(dwindex,"SYS_SAVETMP").value = "1";
	SAVE_TMP = true;
	as_save0(dwname,dwindex,postevents,"saveTmp");
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
function as_save0(dwname,dwindex,postevents,action){
	//alert(getItemValue(0,0,'APPID'));
	checkElementsChange(dwindex);//保存修改的字段
	getObj(dwindex,"POST_EVENTS").value = postevents;
	//alert(document.getElementById('UPDATED_FIELD').value);
	//alert(getItemValue(0,0,'InputUserID'));
	//document.getElementById('POST_EVENTS').value = postevents;
	//先获得修改过的控件的disabled属性状态
	//alert(DisplayFields[dwindex].split(","));
	var updatedFields = DisplayFields[dwindex];
	iLen = updatedFields.length;
	for(var i=0;i<iLen;i++){
		//alert(updatedFields[i]);
		var objs = getObjs(dwindex,updatedFields[i]);
		if(objs){
			for(var j=0;j<objs.length;j++){
				if(objs[j].getAttribute("disabled")){
					objs[j].setAttribute("oldDisabled",objs[j].getAttribute("disabled"));
					objs[j].removeAttribute("disabled");
				}
			}
		}
	}
	if(iV_all(dwname)){
		document.getElementById("messageBox").style.display='none';
		//openwin(sDWResourcePath + '/OverDW.jsp',700,257);
		openDWDialog();
		getObj(dwindex,"SYS_FORMID").value = dwname;
		getObj(dwindex,"SYS_BPDATA").value = "";
		getObj(dwindex,"SYS_ACTION").value = action;
		$("#" + dwname).submit();
		//还原
		for(var i=0;i<iLen;i++){
			var objs = getObjs(dwindex,updatedFields[i]);
			if(objs){
				for(var j=0;j<objs.length;j++){
					if(objs[j].getAttribute("oldDisabled")){
						objs[j].setAttribute("disabled",objs[j].getAttribute("oldDisabled"));
					}
				}
			}
			
		}
	}
	else{
		//还原
		for(var i=0;i<iLen;i++){
			var objs = getObjs(dwindex,updatedFields[i]);
			if(objs){
				for(var j=0;j<objs.length;j++){
					if(objs[j].getAttribute("oldDisabled")){
						objs[j].setAttribute("disabled",objs[j].getAttribute("oldDisabled"));
					}
				}
			}
		}
		showErrors(0);
	}
}

function getErrorLabel(colName){
	var elements = document.getElementsByTagName("label");
	for(var i=0;i<elements.length;i++){
		if(elements[i].getAttribute("for")==colName)
			return elements[i];
	}
	return undefined;
}
function showErrors(tableIndex){
	var list = $("#myiframe0").validate().errorList;
	document.getElementById("messageBox").style.display='block';
	//document.getElementById("messageBox").style.display='none'; //信息框按需要显示
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
		var ele_error = document.createElement("li");
		//ele_error.setAttribute("element_name",list[ii].element.getAttribute('name'));
		//alert(list[ii].element.getAttribute('name'));
		var errmsg = getErrorLabel(list[ii].element.getAttribute('name'));
		//alert(errmsg.innerHTML);
		if(errmsg==undefined)
			errmsg = list[ii].message;
		else
			errmsg = errmsg.innerHTML;
		ele_error.innerHTML = "<a href='javascript:void(0)' target='_self' element_name='"+list[ii].element.getAttribute('name')+"'>" + errmsg + "</a>";
		if(ii>=iExtCount){
			document.getElementById("ul_error_1").appendChild(ele_error);
		}
		else{
			document.getElementById("ul_error_0").appendChild(ele_error);
		}
		var eventHander = function(e){
			var sourceObj = e.srcElement?e.srcElement:e.target;
			try{
				document.getElementsByName(sourceObj.getAttribute("element_name"))[0].focus();
			}
			catch(ex){
				//alert('该控件无法聚焦');
			}
	    };
		if(window.attachEvent)//IE
			ele_error.childNodes[0].attachEvent("onclick", eventHander );
	    else{
	    	//FF
	    	ele_error.childNodes[0].addEventListener("click", eventHander, false);
	    }
	}
	//alert("数据填写出错了!");
	if(list && list[0] && list[0].element){
		try{
			document.getElementsByName(list[0].element.getAttribute("name"))[0].focus();
		}
		catch(e){}
	}
}
function getColIndexFromName(name){
	//alert("DWColIndexNameMap.length=" + DWColIndexNameMap.length + ",name=" + name);
	for(var i =0;i<DWColIndexNameMap.length;i++){
		//alert(DWColIndexNameMap[i][0] + "," + DWColIndexNameMap[i][1] + "," + (DWColIndexNameMap[i][1]==name));
		if(DWColIndexNameMap[i][1].toUpperCase()==name.toUpperCase())
			return DWColIndexNameMap[i][0];
	}
	return "";
}
function getColHeaderFromName(name){
	//alert("DWColIndexNameMap.length=" + DWColIndexNameMap.length + ",name=" + name);
	for(var i =0;i<DWColIndexNameMap.length;i++){
		//alert(DWColIndexNameMap[i][0] + "," + DWColIndexNameMap[i][1] + "," + (DWColIndexNameMap[i][1]==name));
		if(DWColIndexNameMap[i][1].toUpperCase()==name.toUpperCase())
			return DWColIndexNameMap[i][2];
	}
	return "";
}
function hideItem(dwname,sColName){
	return showItem(dwname,sColName,'none');
	
}
function showItemTips(obj){
	var sColName = obj.getAttribute("id");
	var sColIndex = getColIndexFromName(sColName);
	var oTips = document.getElementById("Tips_" + sColIndex);
	if(oTips)
		oTips.style.display="inline";
}
function hideItemTips(obj){
	var sColName = obj.getAttribute("id");
	var sColIndex = getColIndexFromName(sColName);
	var oTips = document.getElementById("Tips_" + sColIndex);
	if(oTips)
		oTips.style.display="none";
}

function getColLabel(dwname,sCol){
	if(DWColIndexNameMap==undefined)return "";
	for(var i=0;i<DWColIndexNameMap.length;i++){
		if(DWColIndexNameMap[i][1].toUpperCase()==sCol.toUpperCase())
			return DWColIndexNameMap[i][2];
	}
	return "";
}

function showItem(dwname,sColName,display){
	if(display==undefined) display = "block";
	var sColIndex = getColIndexFromName(sColName);
	//alert("sColIndex=" + sColIndex);
	if(sColIndex!=""){
		var obj = document.getElementById("A_div_" + sColIndex);
		if(obj){
			obj.style.display = display;
			return true;
		}
		else
			return false;
	}
	else
		return false;
}
function setItemRequired(dwname,sColName,value){
	if(value)
		showItemRequired(dwname,sColName);
	else
		hideItemRequired(dwname,sColName);
}
function showItemRequired(dwname,sColName){
	//alert("sColName=" + sColName);
	var sColIndex = getColIndexFromName(sColName);
	//alert(sColIndex);
	var oSpanInput = document.getElementById("div_" + sColIndex);
	var sHtml = oSpanInput.innerHTML;
	var sSP = '<SPAN style="COLOR: #ff0000"><DELETED>*</DELETED></SPAN>';
	if(sHtml.indexOf(sSP)==-1){
		//alert("|" + sHtml.substring(sHtml.length-7, sHtml.length) + "|");
		if(sHtml.substring(sHtml.length-1, sHtml.length)==" ")
			oSpanInput.innerHTML = sHtml.substring(0,sHtml.length-1) + sSP;
		else if(sHtml.substring(sHtml.length-6, sHtml.length)=="&nbsp;"){
			oSpanInput.innerHTML = sHtml.substring(0,sHtml.length-6) + sSP;
			//alert(oSpanInput.innerHTML);
		}
		else{
			//alert(1);
			oSpanInput.innerHTML += sSP;
		}
	}
	
	sColName = sColName.toUpperCase();
	//更新校验
	$.ajax({
		   type: "POST",
		   url: sDWResourcePath + "/RequiredRuleUpdator.jsp",
		   processData: false,
		   async:false,
		   data: "DataObject=" + $("#SERIALIZED_ASD").val()  + "&ColName="+ sColName + "&Required=1",
		   success: function(msg){
			   if(msg.substring(0,5)=="fail:"){
					  alert('校验更新失败:' +msg.substring(5));
					  return;
				  }
				  $("#SERIALIZED_ASD").val(msg);
			 //更新前台校验
				var title = "请输入"+getColHeaderFromName(sColName);
				try{
					$("#"+sColName).rules("add",{required0 : true,messages:{required0:title}});
				}
				catch(e){
					var rules = _user_validator[0].rules;
					var messages = _user_validator[0].messages;
					if(!rules[sColName])rules[sColName] = new Object();
					if(!rules[sColName].required0){
						rules[sColName].required0 = true;
						messages[sColName].required0=title;
					}
				}
		   }
		});
}
function hideItemRequired(dwname,sColName){
	//alert(sColName);
	var sColIndex = getColIndexFromName(sColName);
	var oSpanInput = document.getElementById("div_" + sColIndex);
	var sHtml = oSpanInput.innerHTML;
	var sSP = '<SPAN style="COLOR: #ff0000"><DELETED>*</DELETED></SPAN>';
	sHtml = sHtml.replace(sSP,'&nbsp;');
	//alert(sHtml);
	oSpanInput.innerHTML = sHtml;
	
	sColName = sColName.toUpperCase();
	//更新校验
	$.ajax({
		   type: "POST",
		   url: sDWResourcePath + "/RequiredRuleUpdator.jsp",
		   processData: false,
		   async:false,
		   data: "DataObject=" + $("#SERIALIZED_ASD").val()  + "&ColName="+ sColName + "&Required=0",
		   success: function(msg){
			  if(msg.substring(0,5)=="fail:"){
				  alert('校验更新失败:' +msg.substring(5));
				  return;
			  }
			  $("#SERIALIZED_ASD").val(msg);
			 //更新前台校验
				try{
					$("#"+sColName).rules("remove","required0");
				}
				catch(e){
					var rules = _user_validator[0].rules;
					var messages = _user_validator[0].messages;
					if(rules[sColName]&&rules[sColName].required0){
						rules[sColName].required0 = undefined;
						messages[sColName].required0=undefined;
					}
				}
		   }
		});
}
//页面导出
function exportPage(rootpath,dwname,fileType){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var params = "FileType=" + fileType + "&rand=" + Math.random();
	if(bDWConvertCode)
		params += "&ConvertCode=1";
	var sOldAction = document.getElementById(dwname).action;
	//var sOldTarget = document.getElementById(dwname).target;
	document.getElementById(dwname).action = rootpath + "/EAS/PageExport/info?" + params;
	//document.getElementById(dwname).target = "_blank";
	document.getElementById(dwname).submit();
	//还原form属性
	document.getElementById(dwname).action = sOldAction;
	//document.getElementById(dwname).target = sOldTarget;
}

//保存成功后的处理
function updateSuccess(msg,postevents){
	if(getResultStatus(0)=="success"){
		resetDWDialog(msg,true);
		//alert(postevents.substring(postevents.length-1,postevents.length) == ";");
		CHANGED = false;
		if(postevents==undefined || postevents=="" || postevents=="undefined")
			return;
		else if(postevents.substring(postevents.length-1,postevents.length) == ";")
			eval(postevents);
		else
			eval("("+ postevents +")");
	}
	else{
		resetDWDialog(msg,false);
	}
}
//控件onchange事件触发的方法
function inputOnchangeFunction(obj){
	/*
	var list = document.getElementById('UPDATED_FIELD');
	if(list.value==''){
		list.value = obj.name;
	}
	else{
		list.value += ',' + obj.name;
	}
	//alert(list.value);
	*/
}
function getObjs(dwindex,fieldName){
	if(fieldName!="Multy_Input")fieldName = fieldName.toUpperCase();
	var formid = "myiframe" + dwindex;
	var form = document.getElementById(formid);
	//if(form==null)
		//alert(dwindex + "," + fieldName);
	//if(fieldName=="CertType")
	//alert(objs[0].type);
	if(form==null)alert(formid);
	var objs = form.elements[fieldName];
	if(objs){
		if(objs[0] && objs[0].type){
		}
		else
			objs = new Array(objs);
	}
	return objs;
}

function getObj(dwindex,fieldName){
	/*
	var formid = "myiframe" + dwindex;
	var form = document.getElementById(formid);
	var obj = form.elements(fieldName);
	//if(obj[0])obj = obj[0];
	//if(fieldName=="SINo")alert(obj[0].name);
	*/
	var objs = getObjs(dwindex,fieldName);
	if(objs)
		return objs[0];
	else
		return undefined;
}

//检查是否复合字段，如果是复合字段则返回其分隔符
function isMultyInput(dwindex,fieldName){
	var multys = getObjs(dwindex,"Multy_Input");//document.getElementsByName("Multy_Input");
	if(multys!=null)
	{
		for(var i=0;i<multys.length;i++){
			//alert(myltys[i].value);
			var aValue = multys[i].value.split("|");
			if(aValue[0]==fieldName)
				return aValue[1];
		}
	}
	return null;
}
//检查是否联动菜单
/*
function isFloatMenu(fieldName){
	var result = new Array();
	var multys = document.getElementsByTagName("select");
	for(var i=0;i<multys.length;i++){
		var curName = fieldName;
		if(multys[i].getAttribute("child")==curName){
			result.push(multys[i].getAttribute("id"));
		}
	}
}
*/

//获得控件所在的formid
function getFormId(obj){
	var pnode = obj.parentNode;
	while(pnode){
		//alert(pnode.tagName);
		if(pnode.tagName.toUpperCase()=="FORM")
			return pnode.id;
		else
			pnode = pnode.parentNode;
	}
	return "myiframe0";
}

function setMultyTextValueFromChild(fieldName){
	//alert(fieldName);
	var dwindex = "0";
	var obj = document.getElementById(fieldName);
	var formid = getFormId(obj);
	//alert(formid);
	var obj = document.getElementById(fieldName);//getObj(dwindex,fieldName);//
	dwindex = formid.substring(8);
	var obj = getObj(dwindex,fieldName);
	var subObjs = getObjs(dwindex,"f_" + fieldName);//document.getElementsByName("f_" + fieldName);
	var result = "";
	for(var i=0;i<subObjs.length;i++){
		result += obj.aplitchar + subObjs[i].value;
	}
	obj.value = result.substring(1);
	//alert(obj.value);
}
//以下提供js访问方法
function getItemValue(dwname,rowindex,fieldName){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	
	try{
		var result = "";
		var sSplit = isMultyInput(dwindex,fieldName);
		if(sSplit!=null){//复合字段的处理
			//alert(fieldName + ".split=" + sSplit);
			result = getMultyItemValue(dwindex,fieldName,sSplit);
		}
		else{
			var objs = getObjs(dwindex,fieldName);
			var length = objs.length;
			//if(fieldName=='SINo')
				//alert(objs[length-1].alstype);
			if(objs[0].getAttribute("floatMenu")=="true"){//联动菜单的处理
				result = getFloatMenuValue(dwindex,fieldName,objs[0].value);
				//alert(result);
			}
			else if(objs[0].type.toLowerCase()=="radio"){
				for(var i=0;i<length;i++){
					if(objs[i].checked){
						result = objs[i].value;
						break;
					}
				}
			}
			else{
				if(objs[length-1].getAttribute("initValue")){
					var result0 = objs[length-1].getAttribute("initValue");
					var result1 = objs[length-1].value;
					if(objs[length-1].options.length<=1)
						result = result0;
					else
						result = result1;
				}
					
				else
					{
						if(objs[length-1].getAttribute("alstype")=="KNumber")
							result = objs[length-1].value.replace(/,/g,"");
						else
							result = objs[length-1].value;
					}
			}
		}
		return result;
	}
	catch(e){
		window.status = "出错了： " + e.message;
		return "";
	}
	
}
function getMultyItemValue(dwindex,fieldName,splitChar){
	var objs = getObjs(dwindex,fieldName);
	var length = objs.length;
	//alert(length);
	var result = "";
	for(var i=0;i<objs.length;i++){
		var sCurValue = null;
		//alert(objs[i].type);
		if(objs[i].type=="checkbox"){//checkbox的处理
			if(objs[i].checked)
				result += splitChar + objs[i].value;
		}
		else if(objs[i].type=="select-multiple"){
			var options = objs[i].options;
			for(var j=0;j<options.length;j++){
				if(options[j].selected)
					result += splitChar + options[j].value;
			}
		}
		else{
			result += splitChar + objs[i].value;
		}
		
	}
	return result.substring(1);
}
//获得联动菜单值
function getFloatMenuValue(dwindex,fieldName,value){
	
	var parentId = Parent_Pre + fieldName;
	//alert(parentId);
	//alert(obj);
	var obj = getObj(dwindex,parentId);
	//alert(obj);
	//alert(obj.value);
	if(obj){
		value = obj.value + "," + value;
		//alert(value);
		return getFloatMenuValue(dwindex,parentId,value);
	}
	else
		return value;
}
//获得联动菜单对象
function getFloatMenuObjNames(dwindex,fieldName){
	var parentId = Parent_Pre + fieldName;
	var obj = getObj(dwindex,parentId);
	//alert(obj);
	if(obj){
		fieldName = parentId + "," + fieldName;
		return getFloatMenuObjNames(dwindex,fieldName);
	}
	else
		return fieldName;
}
function isStrInArray(arr,str){
	//alert(arr);
	//alert(str);
	if(arr==null)return false;
	for(var i=0;i<arr.length;i++){
		if(arr[i]==str)
			return true;
	}
	return false;
}

function setItemHeader(dwname,rowindex,fieldName,title){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	var sColIndex = getColIndexFromName(fieldName);
	var oSpanInput = document.getElementById("Title_" + sColIndex);
	oSpanInput.innerHTML = title;
}
function getItemHeader(dwname,rowindex,fieldName){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	var sColIndex = getColIndexFromName(fieldName);
	var oSpanInput = document.getElementById("Title_" + sColIndex);
	return oSpanInput.innerHTML;
}
function setItemUnit(dwname,rowindex,fieldName,unit){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	var sColIndex = getColIndexFromName(fieldName);
	var oSpanInput = document.getElementById("Unit_" + sColIndex);
	oSpanInput.innerHTML = unit;
}
function getItemUnit(dwname,rowindex,fieldName){
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	var sColIndex = getColIndexFromName(fieldName);
	var oSpanInput = document.getElementById("Unit_" + sColIndex);
	return oSpanInput.innerHTML;
}

function getDWFomatedNumber(str,checkFormat){
	if(checkFormat==5){
		str = FormatKNumber(str,0);
	}
	else if(checkFormat==2){
		str = FormatKNumber(str,2);
	}
	else if(checkFormat>10){
		str = FormatKNumber(str,checkFormat-10);
	}
	return str;
};

//赋值操作
function setItemValue(dwname,rowindex,fieldName,value){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	
	var sSplit = isMultyInput(dwindex,fieldName);
	if(sSplit!=null){//复合字段的处理
		//alert(sSplit);
		var objs = getObjs(dwindex,fieldName);//document.getElementsByName(fieldName);
		var length = objs.length;
		var aValue = value.split(sSplit);
		for(var i=0;i<length;i++){
			if(objs[i].type.toLowerCase()=="checkbox"){
				
				if(isStrInArray(aValue,objs[i].value))
					objs[i].checked = true;
				else
					objs[i].checked = false;
			}
			else if(objs[i].type.toLowerCase()=="select-multiple"){
				var options = objs[i].options;
				for(var j=0;j<options.length;j++){
					if(isStrInArray(aValue,options[j].value))
						options[j].selected = true;
					else
						options[j].selected = false;
				}
			}
			else if(objs[i].getAttribute("alstype")=="PictureRadio"){//图片单选框的处理
				//alert(0);
				var els = document.getElementsByTagName("a");
				for(var j=0;j<els.length;j++){
					if(els[j].getAttribute("radioname")==objs[i].name){
						els[j].value = aValue[i];
						CHANGED=true;
						//alert(1);
						setPicRaidoCss(els[j].id);
					}
				}
			}
			else{
				if(aValue[i]){
					
					objs[i].value = aValue[i];
				}
				else
					objs[i].value = "";
			}
		}
	}
	else{
		//alert(fieldName);
		var objs = getObjs(dwindex,fieldName);//document.getElementsByName(fieldName);
		if(objs==null) {alert("不存在字段["+fieldName+"]!");return;}
		var length = objs.length;
		for(var i=0;i<length;i++){
			//alert(objs[i].type);
			if(objs[i].getAttribute("floatMenu")=="true"){//联动菜单的处理
				//alert(1);
				//alert(getFloatMenuObjNames(fieldName));
				var fields = getFloatMenuObjNames(dwindex,fieldName);
				//alert(fields);
				var aFieldName = fields.split(",");
				var aValue = value.split(",");
				//alert(aFieldName.length);
				for(var j=0;j<aFieldName.length;j++){
					aFieldName[j] = aFieldName[j].toUpperCase();
					var input = getObj(dwindex,aFieldName[j]);
					if(input){
						for(var t=0;t<input.options.length;t++){
							if(input.options[t].value == aValue[j]){
								input.options[t].selected = true;
								if(j<aFieldName.length-1){
									//alert(aFieldName[j]);
									eval("(getChildArr_" + aFieldName[j] + "())");
								}
							}
						}
					}
				} 
			}
			else if(objs[i].getAttribute("alstype")=="MyltyText"){//MyltyText的处理
				var aValue = value.split(objs[i].aplitchar);
				var fobjs = getObjs(dwindex,"f_" + fieldName);//document.getElementsByName("f_" + fieldName);
				if(fobjs){
					
					for(var j=0;j<fobjs.length;j++){
						if(aValue[j])
							fobjs[j].value = aValue[j];
						else
							fobjs[j].value = "";
					}
				}
				getObjs(dwindex,fieldName)[0].value = value;
			}
			else if(objs[i].getAttribute("alstype")=="KNumber"){//千分位的处理
				objs[i].value=getDWFomatedNumber(value,objs[i].getAttribute("colcheckformat"));
			}
			else if(objs[i].getAttribute("alstype")=="PictureRadio"){//图片单选框的处理
				var els = document.getElementsByTagName("a");
				if(value==""){
					setPicRaidoCss(els[0].getAttribute("id"),"empty");
				}
				else{
					for(var j=0;j<els.length;j++){
						if(els[j].getAttribute("radioname")==fieldName && els[j].getAttribute("value")==value){
							CHANGED=true;
							//alert(els[j].getAttribute("id"));
							setPicRaidoCss(els[j].getAttribute("id"));
						}
					}
				}
				
			}
			else if(objs[i].getAttribute("alstype")=="YearMonth"){//月份选择的处理
				var aValue = value.split("/");
				//alert("Year_" + fieldName);
				var el0 = getObjs(dwindex,"Year_" + fieldName)[0].options;
				
				//alert(el0.options[1].value==aValue[0]);
				for(var j=0;j<el0.length;j++){
					if(el0[j].value==aValue[0]){
						el0[j].selected = true;
						break;
					}
				}
				if(value=="")el0[0].selected=true;
				var el1 = getObjs(dwindex,"Month_" + fieldName)[0].options;
				for(var j=0;j<el1.length;j++){
					if(el1[j].value==aValue[1]){
						el1[j].selected = true;
						break;
					}
				}
				if(value=="")el1[0].selected=true;
				objs[i].value = value;
			}
			else if(objs[i].tagName.toLowerCase()=="select"){//普通选择框的处理
				objs[i].setAttribute("initValue",value);
				var els = objs[i].options;
				for(var j=0;j<els.length;j++){
					if(els[j].value==value){
						els[j].selected = true;
						break;
					}
				}
			}
			else if(objs[i].type.toLowerCase()=="radio"){//单选框的处理
				//alert(value);
				if(value=="")
					objs[i].checked = false;
				else if(objs[i].value==value){
					objs[i].checked = true;
				}
			}
			else{
				//alert(value);
				//当为非编辑状态的时候checkbox setItemValue会出现无法选中状态，这里需要特别处理
				if(objs[i].type.toLowerCase()=="checkbox"){
					
					if(isStrInArray(value.split(objs[i].splitchar),objs[i].value))
						objs[i].checked = true;
					else
						objs[i].checked = false;
				}
				else
					objs[i].value = value;
			}
		}
		
	}
}
function getDisplayFieldIndex(dwindex,fieldName){
	for(var i=0;i<DisplayFields[dwindex].length;i++){
		if(fieldName==DisplayFields[dwindex][i])
			return i;
	}
	return -1;
}
//保存所有的值
function saveElementsValue(dwindex,isNew){
	if(isNew==undefined)
		ARRAY_LOADED[dwindex] = new Array(DisplayFields[dwindex].length);
	else if(isNew)
		ARRAY_NEW[dwindex] = new Array(DisplayFields[dwindex].length);
	else
		ARRAY_OLD[dwindex] = new Array(DisplayFields[dwindex].length);
	for(var i=0;i<DisplayFields[dwindex].length;i++){
		if(isNew==undefined)
			ARRAY_LOADED[dwindex][i] = getItemValue(dwindex,0,DisplayFields[dwindex][i]);
		else if(isNew){
			ARRAY_NEW[dwindex][i] = getItemValue(dwindex,0,DisplayFields[dwindex][i]);
		}
		else{
			ARRAY_OLD[dwindex][i] = getItemValue(dwindex,0,DisplayFields[dwindex][i]);
		}
	}
	/*
	if(isNew)
		alert(ARRAY_NEW[dwindex]);
	else
		alert(ARRAY_OLD[dwindex]);
		*/
}

function getColIndex(dwindex,colname){
	for(var i=0;i<DisplayFields[dwindex].length;i++){
		if(DisplayFields[dwindex][i].toUpperCase()==colname.toUpperCase())
			return i;
	}
	return -1;
}

function getRowCount(dwindex){
	//var obj = document.getElementById('dwrowcount');
	var obj = document.forms["myiframe"+dwindex].elements['dwrowcount'];
	if(obj && obj.value!="")
		return obj.value;
	else
		return 0;
}

function getRow(iDW)
{
	return 0;  
}

function checkElementsChange(dwindex){
	var updatedFields = "";
	//先获得新数组值
	saveElementsValue(dwindex,true);
	//alert(ARRAY_OLD[dwindex]);
    //值对比
    for(var i=0;i<DisplayFields[dwindex].length;i++){
    	if(ARRAY_OLD[dwindex][i]!=ARRAY_NEW[dwindex][i]){
        	updatedFields += "," + DisplayFields[dwindex][i];
        }
    }
    //保存到隐藏域
    if(updatedFields!=""){
    	//document.getElementById("UPDATED_FIELD").value = updatedFields.substring(1);
    	var obj = document.forms["myiframe"+dwindex].elements['UPDATED_FIELD'];
    	obj.value = updatedFields.substring(1);
    }
    //alert(updatedFields);
}

function as_isPageChanged(){
	return isUserChanged();
}
function DWChangeKeyForInput(){
	if(event.keyCode==13)event.keyCode = 9;
}
//页面初始化以及事件处理
function my_load(sortorder,sortfieldindex,dwname){
	if(DWSystem.bDWRunMyLoad)return;
	var dwindex;
	if(isNaN(dwname))
		dwindex = dwname.substring(8);
	else
		dwindex =  dwname;
	document.onkeydown = function(evt){
		if(navigator.appName=="Netscape")return;
		var sourceObj = event.srcElement?event.srcElement:event.target;
		//alert(sourceObj);
		if(sourceObj.tagName=='INPUT' || sourceObj.tagName=='select-one' || sourceObj.tagName=='select-multiple'){
			if(event.keyCode==13)
				event.keyCode = 9;
		}
	};
	//快捷键处理
	jQuery.initObjectKeyArray();
	/*
	document.oncontextmenu = function(e){
		if(e==undefined)e=event;
		var sourceObj = e.srcElement?e.srcElement:e.target;
		if(sourceObj){
			if(sourceObj.tagName==undefined){
				hideASContextMenu(e,true);
				return true;
			}
				
			if(sourceObj.tagName.toLowerCase()=='textarea' || sourceObj.tagName=='INPUT' || sourceObj.tagName=='select-one' || sourceObj.tagName=='select-multiple'){
				hideASContextMenu(e,true);
				return true;
			}
		}
		bindASContextMenu("mm",e);
		return false;
	};
	*/
	DWSystem.bDWRunMyLoad = true;
}
//用户是否变动过数据
function isUserChanged(){
	//alert("CHANGED = " + CHANGED);
	if(CHANGED==true){//先检查是否手工有过变动，如果有变动再对比数组值
		//获得所有form
		var forms = document.forms;
		for(var i=0;i<forms.length;i++){//获得各个form的新值
			var form = forms[i];
			if(form.id!="" && form.id.indexOf("myiframe")>=0)
			{
				var dwindex = form.id.substring(8);
				saveElementsValue(dwindex,true);
			}
		}
		//检查值是否有变动
		var changed2 = false;//值是否有变动
		for(var i=0;i<ARRAY_OLD.length;i++){
			var arr_old2 =  ARRAY_LOADED[i];
			var arr_new2 =  ARRAY_NEW[i];
			for(var j=0;j<arr_old2.length;j++){
				if(arr_old2[j]!=arr_new2[j])
					changed2 = true;
			}
		}
		if(changed2)
			return true;
	}
	return false;
}
$(document).keydown(function(evt){
  if(isIEBrowser()){
	  evt = event;
	  srcElement = evt.srcElement;
  }
  else{
	  srcElement = evt.target;
  }
  if(evt.keyCode==13) {//将enter变tab
	  if(isIEBrowser()){
		  if(!(srcElement.type=="button"|| srcElement.type=="submit" || srcElement.type=="textarea")){
		   	//alert(frames["alsdivwin_f1"].document.getElementById("button").style.disply);
			  event.keyCode=9;
		  }
	  }
	  else{
	  }
  }
  else{
	if(srcElement.type && evt.keyCode==8){
		//backspace快捷方式在输入框中不起作用
		CHANGED=true;//标记修改状态
	}
	else if(srcElement.type && evt.keyCode==46){
		//截获del快捷方式在输入框中不起作用
		CHANGED=true;//标记修改状态
	}
	else{//开始定义快捷键
		if(evt.srcElement && (evt.srcElement.type=='button' || evt.srcElement.type=='text' || evt.srcElement.type=='checkbox')){
			//alert(evt.srcElement.type);
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
		CHANGED=true;//标记修改状态
	}
  }
});

function as_defaultExport(){
	exportPage(sWebRootPath,0,'excel');
}

function change_height_after(colcount){
	if(colcount<=1){
		try {
			if(parent.document.getElementById("wizard-body")) {
				var oClass = $(".info_td_left");
				var i = 0;
				for(i=0;i<oClass.length;i++)	
						try { oClass[i].style.width = (document.body.offsetWidth - 190)/2;}catch(e) {}
				var oClassEven = $(".info_td_left_even");
				i = 0;
				for(i=0;i<oClassEven.length;i++)	
						try { oClassEven[i].style.width = (document.body.offsetWidth - 190)/2;}catch(e) {}
			}
		}catch(e) {}	
	}
}
function change_height(sButtonPosition,colcount){
	var iTurnPageHeight = 6;
	if(navigator.appName=="Netscape")
		iTurnPageHeight=26;
	if("north"==sButtonPosition){
		var max_div_my0_length = document.body.offsetHeight
			- document.getElementById("DWTD").offsetTop
			- iTurnPageHeight;
		var adjustHeight = 0;
		if(window.getAdjustHeight)
			adjustHeight = getAdjustHeight();
		else
			adjustHeight = getAdjustHeight2();
		max_div_my0_length = max_div_my0_length-adjustHeight;
		if(max_div_my0_length > 0 ) //if(max_div_my0_length > 0 && document.getElementById("div_my0").offsetHeight > max_div_my0_length)
			document.getElementById("div_my0").style.height = max_div_my0_length;
		document.getElementById("div_my0").style.width = document.body.clientWidth;
	}
	change_height_after(colcount);
}
function getAdjustHeight2(){
	return 0;
	
}
$().ready(function(){
	my_load(0,0,0);
	//$('#DW_Dialog').window({title:'结果反馈',modal:true,collapsible:false,minimizable:false,maximizable:false});
	//页面载入的时候保存值
	var forms = document.forms;//获得所有form
	for(var i=0;i<forms.length;i++){//获得各个form的新值
		var form = forms[i];
		if(form.id!="" && form.id.indexOf("myiframe")>=0)
		{
			var dwindex = form.id.substring(8);
			saveElementsValue(dwindex);
		}
	}
	 $("#showpart").hide();
	 $("#hidbtn").hide();
   $("#mobtn").click(function(){
       $("#showpart").show();
		$("#mobtn").hide();
		$("#hidbtn").show();
	});
	$("#hidbtn").click(function(){
       $("#showpart").hide();
		$("#mobtn").show();
		$("#hidbtn").hide();
	});
}
);
function setReadOnly(obj, value) {  
    if (obj) {  
    	if (obj.type == 'radio' || obj.type == 'checkbox') {  
    		if (obj.name) {  
                var arr = document.getElementsByName(obj.name);  
                var len = arr.length;  
                var tmp = null;  
                for (var i = 0; i < len; i++){
                	if(value){
            			arr[i].setAttribute("disabled","disabeld");
            		}
            		else{
            			arr[i].removeAttribute("disabled");
            		}
                }  
    		}
    		else{
    			if(value){
        			obj.setAttribute("disabled","disabeld");
        		}
        		else{
        			obj.removeAttribute("disabled");
        		}
    		}
    		
    	}
    	else if (obj.getAttribute("alstype")=="KNumber" || obj.getAttribute("alstype")=="Text" || obj.type == 'textarea') {
    		if(value){
    			obj.setAttribute("readOnly","true");
    			if(obj.className.indexOf("info_text_readonly_color")==-1)
    				obj.className+= " info_text_readonly_color";
    		}
    		else{
    			obj.removeAttribute("readOnly");
    			obj.className = obj.className.replace('info_text_readonly_color','');
    		}
    	}
    	else{
    		if(value){
    			obj.setAttribute("disabled","disabeld");
    		}
    		else{
    			obj.removeAttribute("disabled");
    		}
    	}
    }  
}  

function GetIeVersion() {  
    var exp;  
    try {  
        var str = navigator.userAgent;  
        var strIe = 'MSIE';  
        if (str && str.indexOf(strIe) >= 0) {  
            str = str.substring(str.indexOf(strIe) + strIe.length);  
            str = str.substring(0, str.indexOf(';'));  
            return parseFloat(str.trim());  
        }  
    }  
    catch (exp) {  
    }  
    return 0;  
} 

function setTextReadOnly(iDw,iRow,sName,bValue){
	var sBGColor = '#ECECEC';
	var obj = getObj(iDw,sName);
	if(bValue){
		setReadOnly(obj,sBGColor);
	}
	else{
		obj.readOnly='';
		obj.style.backgroundColor = '';
	}
}

function setItemDisabled(iDw,iRow,sName,bValue){
	var objs = getObjs(iDw,sName);
	for(var i=0;i<objs.length;i++){
		if(objs[i].getAttribute("floatMenu")=="true"){//联动菜单的处理
			var fields = getFloatMenuObjNames(iDw,objs[i].getAttribute("id"));
			var aFields = fields.split(",");
			for(var j=0;j<aFields.length;j++){
				setReadOnly(getObj(iDw,aFields[j]),bValue);
			}
		}
		else if(objs[i].getAttribute("alstype")=="PictureRadio"){//图片单选框的处理
			var els = document.getElementsByTagName("a");
			for(var j=0;j<els.length;j++){
				if(els[j].getAttribute("radioname")==objs[i].name){
					if(bValue){
						els[j].href= "javascript:void(0)";
					}
					else{
						els[j].href = "javascript:CHANGED=true;setPicRaidoCss('"+ els[j].id +"')";
					}
				}
			}
		}
		else if(objs[i].getAttribute("alstype")=="YearMonth"){//月份选择的处理
			//alert(getObj(iDw,sName ));
			setReadOnly(getObj(iDw,"Year_" +sName ),bValue);
			setReadOnly(getObj(iDw,"Month_" +sName ),bValue);
		}
		else{
			setReadOnly(objs[i],bValue);
		}
	}
}

function setItemReadOnly(iDw,iRow,sName,bValue)
{
	setReadOnly(iDw,iRow,sName,bValue);
}

//给info页面编辑控件添加事件
function addInfoEventListener(iDw,iRow,colName,eventtype,function_){
	var obj = getObj(iDw,colName);
	//alert(obj);
	if(obj){
		if(obj.addEventListener){
			obj.addEventListener(eventtype,function_,false);
		}
		else{
			if(eventtype.substring(0,1)=="on")
				eventtype= eventtype.substring(2);
			obj.attachEvent(eventtype,function_,false);
		}
	}
}
function AS_Address(){};
AS_Address.cityArray = new Array();
AS_Address.areaArray = new Array();
AS_Address.setCity = function(colName,provValue){
	var aCode = [];
	if(AS_Address.cityArray[provValue]){
		aCode = AS_Address.cityArray[provValue];
	}
	else{
		var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.CityFetcher","getCities","prov="+provValue);
		if(sReturn!=""){
			aCode = sReturn.split(",");
		}
	}
	var oCity = document.getElementById("City_" + colName);
	var options = oCity.options;
	options.length = 1;
	options[0] = new Option("请选择城市","");
	options[0].selected = true;
	//alert(options[0]);
	for(var i=0;i<aCode.length;i+=2){
		options[options.length] = new Option(aCode[i+1],aCode[i]);
	}
	AS_Address.setArea(colName,'');
};
AS_Address.setArea = function(colName,cityValue){
	var aCode = [];
	if(AS_Address.areaArray[cityValue]){
		aCode = AS_Address.areaArray[cityValue];
	}
	else{
		var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.AreaFetcher","getAreas","city="+cityValue);
		if(sReturn!=""){
			aCode = sReturn.split(",");
		}
	}
	//alert(aCode);
	var oArea = document.getElementById(colName);
	var options = oArea.options;
	options.length = 1;
	options[0] = new Option("请选择区县","");
	options[0].selected = true;
	for(var i=0;i<aCode.length;i+=2){
		options[options.length] = new Option(aCode[i+1],aCode[i]);
	}
};
function checkModified(){
	 var sUnloadMessage = "\n\r当前页面内容已经被修改，\n\r按“取消”则留在当前页，然后再按当前页上的“保存”按钮以保存修改过的数据，\n\r按“确定”则不保存修改过的数据并且离开当前页．";
	 if(as_isPageChanged()){
		 return confirm(sUnloadMessage);
	 }
	 return true;
}
function as_createFormDatas(){
	var result = new Object();
	result.type="info";
	result.serializedJbo=document.getElementById("SERIALIZED_JBO").value;
	result.serializedAsd=document.getElementById("SERIALIZED_ASD").value;
	result.action=document.getElementById("SYS_ACTION").value;
	var sUpdatedFields = document.getElementById("UPDATED_FIELD").value;
	if(sUpdatedFields.length>0){
		result.updatedFields=sUpdatedFields.split(",");
		result.fieldValues = new Object();
		for(var i=0;i<result.updatedFields.length;i++){
			result.fieldValues[result.updatedFields[i]]= getItemValue(0,0,result.updatedFields[i]);
		}
	}
	else
		result.updatedFields=[];
	//载入所有数据
	result.allFieldNames =DisplayFields[0];
	if(DisplayFields[0]){
		result.allFieldValues = new Object();
		for(var i=0;i<DisplayFields[0].length;i++){
			result.allFieldValues[DisplayFields[0][i]]= getItemValue(0,0,DisplayFields[0][i]);
			//alert("result.allFieldValues["+DisplayFields[0]+"]=" + "=" + result.allFieldValues[DisplayFields[0]]);
		}
	}
	//result.updatedFields=document.getElementById("UPDATED_FIELD").value;
	return result;
}
function as_rateForStar(obj,sMin,sMax,evt){
	evt = (event?event:evt);
	obj.childNodes[0].style.width=evt.offsetX+"px";
	obj.value=as_round2ForStar(evt.offsetX/75,sMin,sMax);
	obj.childNodes[1].value=as_round2ForStar(evt.offsetX/75,sMin,sMax);
}
function as_round2ForStar(x,sMin,sMax){
	x=(sMax-sMin)*x+sMin;
	x = Math.round(x);
	return x;
}