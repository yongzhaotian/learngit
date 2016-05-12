function len(value){
	return value.length;
}
function isShortDate(value){
	return /^[0-9]{4}\/[0-9]{2}\/[0-9]{2}$/g.test(value);
}
function isEmail(value){
	return /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/g.test(value);
}
function isEmpty(value){
	//alert("isEmpty");
	if(value==null||value==undefined || value=="")
		return true;
	else
		return false;
}
function substring(value,index1,index2){
	return value.substring(index1,index2);
}
function javafetch(className,methodName,paramValues,type){
	//alert(paramValues);
	var sParams = "className="+className+"&methodName="+methodName;
	var sUrl = "/Frame/page/dw/RunJavaStaticMethod.jsp";
	if(type){
		sUrl = "/Frame/page/dw/"+type+".jsp";
	}
	if(paramValues){
		if(type){
			paramValues = JSON.stringify(paramValues);
			//alert("paramValues="+ paramValues)
		}
		sParams += "&paramValues=" + encodeURI(encodeURI(paramValues));
	}
	return AsControl.RunJsp(sUrl,sParams);//+"&paramValues="+encodeURI(encodeURI(paramValues.join(''))));
}
function ifthen(ifcondition,ifvalue,elsevalue){
	if(eval(ifcondition))
		return ifvalue;
	else
		return elsevalue;
}
jQuery.validator.prototype.showLabel = function(element,message){
	if(element.getAttribute('errorInfo')){
		message=element.getAttribute('errorInfo');
		element.removeAttribute('errorInfo');
	}
	var label = this.errorsFor( element );
	if ( label.length ) {
		// refresh error/success class
		label.removeClass().addClass( this.settings.errorClass );

		// check if we have a generated label, replace the message then
		label.attr("generated") && label.html(message);
	} else {
		// create label
		label = $("<" + this.settings.errorElement + "/>")
			.attr({"for":  this.idOrName(element), generated: true})
			.addClass(this.settings.errorClass)
			.html(message || "");
		if ( this.settings.wrapper ) {
			// make sure the element is visible, even in IE
			// actually showing the wrapped element is handled elsewhere
			label = label.hide().show().wrap("<" + this.settings.wrapper + "/>").parent();
		}
		if ( !this.labelContainer.append(label).length )
			this.settings.errorPlacement
				? this.settings.errorPlacement(label, $(element) )
				: label.insertAfter(element);
	}
	if ( !message && this.settings.success ) {
		label.text("");
		typeof this.settings.success == "string"
			? label.addClass( this.settings.success )
			: this.settings.success( label );
	}
	this.toShow = this.toShow.add(label);
};
/*jquery.validate.js功能扩展*/
jQuery.validator.addMethod("regular",function(value,element,params){
	if(element.type=='radio' || element.type=='checkbox')
		value = getItemValue(0,0,element.name);
	if(value=='')return true;
	var exp = new RegExp(params[0]);
    var m = value.match(exp);
	if(m==null)
		return false;
	else
		return true;
});
jQuery.validator.addMethod("minx",function(value,element,params){
	if(value=="")return true;
	if(toNumber(value)>=params)
		return true;
	else
		return false;
});
jQuery.validator.addMethod("maxx",function(value,element,params){
	if(value=="")return true;
	if(toNumber(value)<=params)
		return true;
	else
		return false;
});

//通过远程赋值
function setItemValueFromRemote(dwname,rowindex,fieldName,javaClassName,params){
	var sValue = remoteFetch(dwname,rowindex,javaClassName,params);
	if(sValue!=null)
		setItemValue(dwname,rowindex,fieldName,sValue);
}

//远程获取数据
function remoteFetch(dwname,rowindex,javaClassName,params){
	
	if(!isNaN(dwname))dwname = "myiframe" + dwname;
	var dwindex = dwname.substring(8);
	
	var sUrl = sWebRootPath  + "/Frame/page/dw/RemoteFetch.jsp";
	var param = "ClassName=" + javaClassName + "&rand="+Math.random();
	var result = ['error','无法连接服务器'];
	for(var i=0;i<params.length;i++){
		if(params[i] && params[i]!=''){
			var sParamName = params[i];
			var sParamValue = "";
			if(sParamName.length > 7 && sParamName.substring(0,7) == '$Const:' && sParamName.indexOf("=")>-1){
				var iDot = sParamName.indexOf("=");
				sParamValue = sParamName.substring(iDot+1,sParamName.length);
				sParamName = sParamName.substring(0,iDot);
			}
			else
				sParamValue = getItemValue(dwindex,rowindex,sParamName.toUpperCase());
			if(sParamValue==undefined)sParamValue = "";
			param += "&"+sParamName+"=" + sParamValue.replace(/&/g, "⊙≌□");
		}
	}
	$.ajax({
		url: sUrl,
		async: false,
		cache: false,
		type :"post",
		dataType: "text",
		data: encodeURI(encodeURI(param)),
		success: function(response) {
			if(response.substring(0,8)=='success:')
				result = ["success",response.substring(8)];
			else if(response.substring(0,6)=='error:')
				result = ["error",response.substring(6)];
			else
				result = ["error",response];
		}
	});
	if(result[0]=='success')
		return result[1];
	else{
		alert('远程获取出错：'+ result[1]);
		return null;
	}
}

jQuery.validator.addMethod("commCompare",function(value,element,params,index){
	//alert($(params[0]));
	if(index==undefined)index=0;
	if(element.type=='radio' || element.type=='checkbox')
		value = getItemValue(0,0,element.name);
	var sCompareValue = $(params[0]).val();
	if(sCompareValue==undefined){
		//alert(params[0].substring(1));
		sCompareValue = getItemValue(0,index,params[0].substring(1));
	}
	//alert("sCompareValue="+ sCompareValue);
	var sCompareRegular = params[1];
	//alert("params="+params +"|value=" + value + "|sCompareValue=" + sCompareValue);
	//alert('sCompareValue:' + isNaN(sCompareValue));
	if(isNumber(value) && isNumber(sCompareValue)){
		value = toNumber(value);
		sCompareValue = toNumber(sCompareValue);
	}
	//alert('sCompareRegular=' + sCompareRegular);
	var result = false;
	if(sCompareRegular=='=='){
		result = (value==sCompareValue);
	}
	else if(sCompareRegular=='!='){
		result = (value!=sCompareValue);
	}
	else if(sCompareRegular=='>'){
		result = (value>sCompareValue);
	}
	else if(sCompareRegular=='>='){
		result = (value>=sCompareValue);	
	}
	else if(sCompareRegular=='<'){
		result = (value<sCompareValue);
	}
	else if(sCompareRegular=='<='){
		result = (value<=sCompareValue);
	}
	else{
	}
	/*
	sCompareRegular =sCompareRegular.replace(/\{VALUE\}/g,value);
	sCompareRegular =sCompareRegular.replace(/\{COMPARE\}/g,sCompareValue);
	alert('sCompareRegular=' + sCompareRegular);
	var result = val("("+ sCompareRegular +")");
	alert('result=' + result);
	*/
	//alert('result=' + result);
	return result;
});

jQuery.validator.addMethod("classcheck",function(value,element,params,index){
	if(element.type=='radio' || element.type=='checkbox')
		value = getItemValue(0,0,element.name);
	//alert(element.name+'|'+value);
	if(index==undefined)index = 0;
	//var sUrl = sWebRootPath  + "/Frame/page/dw/ValidClass.jsp";
	var sUrl = sWebRootPath + params[0];
	//alert("sUrl=" + sUrl);
	var param = "ClassName=" + params[1] + "&rand="+Math.random()+"&Value=" + value.replace(/&/g, "⊙≌□");
	var result = false;
	for(var i=3;i<=params.length;i++){
		if(params[i] && params[i]!=''){
			var sParamName = params[i];
			//alert(sParamName);
			var sParamValue = "";
			if(sParamName.length > 7 && sParamName.substring(0,7) == '$Const:' && sParamName.indexOf("=")>-1){
				var iDot = sParamName.indexOf("=");
				sParamValue = sParamName.substring(iDot+1,sParamName.length);
				sParamName = sParamName.substring(0,iDot);
			}
			else{
				sParamValue = getItemValue(0,index,sParamName.toUpperCase());
				if(sParamValue==undefined)
					sParamValue=getItemValue(0,index,sParamName);
				//alert(sParamValue);
			}
				
			if(sParamValue==undefined)sParamValue = "";
			if(sParamValue.length>0)sParamValue=sParamValue.replace(/&/g, "⊙≌□");
			param += "&"+sParamName+"=" + sParamValue;
		}
	}
	//alert(param);
	$.ajax({
			url: sUrl,
			async: false,
			cache: false,
			type :"post",
			dataType: "text",
			data: encodeURI(encodeURI(param)),
			success: function(response) {
				if(response=='true'){
					result = true;
				}
				else{
					//alert("response="+ response);
					if(response!='false')
						element.setAttribute("errorInfo",response);
					result = false;
				}
			}
	});
	return result;
});
//如果是保存则验证非空,如果暂存则不验证
jQuery.validator.addMethod("required0",function(value,element,param){
	//alert(value +"|" + element.type + "|" + element.name + "|" +element.outerHTML);
	if(SAVE_TMP==true){
		return true;
	}
	else if(getItemValue(0,0,"TempSaveFlag"=="1")){
		return true;
	}
	else{
		if ( !this.depend(param, element) )
			return "dependency-mismatch";
		switch( element.nodeName.toLowerCase() ) {
		case 'select':
			var options = $("option:selected", element);
			return options.length > 0 && ( element.type == "select-multiple" || ((/msie/.test(navigator.userAgent.toLowerCase())) && !(options[0].attributes['value'].specified) ? options[0].text : options[0].value).length > 0);
		case 'input':
			if ( this.checkable(element) )
				return this.getLength(value, element) > 0;
		default:
			return $.trim(value).length > 0;
		}
	}
});
jQuery.validator.addMethod("expressions",function(value,element,expressions,index){
	if(index==undefined)index=0;
	//expressions=expressions.replace(new RegExp("#ROW_INDEX","g"), + index);
	//expressions=expressions.replace(new RegExp("\\$\{stringValue\}","g"),"'" + value + "'");
	//expressions=expressions.replace(new RegExp("\\$\{numberValue\}","g"),value);
	//expressions = eval("("+ expressions + ")");
	var errorInfos = new Array();
	for(var i=0;i<expressions.length;i++){
		var scope = expressions[i].scope;
		if(scope){
			if(scope=='client' || scope=='all'){
				var message = expressions[i].message;
				
				var iDot0 = message.indexOf("#{");
				var iDot1 = message.indexOf("}");
				if(iDot0>-1 && iDot1>iDot0)
					message = message.substring(0,iDot0) + getColLabel(0,message.substring(iDot0+2,iDot1)) + message.substring(iDot1+1);
				var expression = expressions[i].expression;
				
				if(typeof(value) == "undefined" || value == null) continue;
				if(expression.indexOf("ifthen(")==-1 && $.trim(value)=="") continue;
				
				expression=expression.replace(new RegExp("#ROW_INDEX","g"), + index);
				expression=expression.replace(new RegExp("\\$\{stringValue\}","g"),"'" + value + "'");
				expression=expression.replace(new RegExp("\\$\{numberValue\}","g"),toNumber(value));
				
				var valid = eval(expression);
				if(valid==false)
					errorInfos[errorInfos.length] = message;
			}
		}
	}
	if(errorInfos.length>0){
		//alert(element.parentNode.innerHTML);
		element.setAttribute("errorInfo",errorInfos.join(',并且'));
		return false;
	}
	else
		return true;
});

function errorPlaceRule(error, element) {
	var eid = element.attr('name');
	var tlabel = undefined;
	if(frames['myiframe0'] && DisplayDONO==undefined)
		tlabel = $('#' + eid + '_label',frames['myiframe0'].document);
	//alert("DisplayDONO="+ DisplayDONO + "|" + (tlabel?tlabel:element));
	if (element.is(':radio') || element.is(':checkbox')) {
  	   if (G_FromFormatDoc) {error.appendTo(tlabel?tlabel:element.parent());return;}
       error.appendTo(tlabel?tlabel:element.parent().parent());
  } else {
      error.insertAfter(tlabel?tlabel:element);
     //alert(element.outerHTML);
  }
}
