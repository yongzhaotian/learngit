String.prototype.trim = function(){return this.replace(/(^[\s]*)|([\s]*$)/g, "");};
String.prototype.lTrim = function(){return this.replace(/(^[\s]*)/g, "");};
String.prototype.rTrim = function(){return this.replace(/([\s]*$)/g, "");};
var AsControl = {
	_getDefaultOpenStyle:function() {
		return "width="+screen.availWidth+"px,height="+screen.availHeight+"px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
	},
	_getDefaultDialogStyle:function() {
		return "dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;";
	},
	_getDialogStyle:function(sStyle) {
		if(typeof(sStyle)=="undefined" || sStyle=="") 
			return this._getDefaultDialogStyle();
		else 
			return sStyle;
	},
	_getParaString:function(sPara) {
		if(typeof(sPara)=="undefined" || sPara=="") {
			return "";
		}
		else if (sPara.substring(0,1)=="&") {
			return encodeURI(encodeURI(sPara));
		}
		else {
			return "&"+encodeURI(encodeURI(sPara));
		}
	},
	_getCompID:function(sURL) {
		return sURL.substring(sURL.lastIndexOf("/")+1, sURL.indexOf(".jsp"));
	},
	randomNumber:function() {
		return Math.abs(Math.sin(new Date().getTime())).toString().substr(2);
	}
};

AsControl.OpenObject = function(sObjectType,sObjectNo,sViewID,sStyle){
	return OpenObject(sObjectType,sObjectNo,sViewID,sStyle); //
};
AsControl.PopObject = function(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas){
	return PopObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas); //
};

AsControl.OpenPage = function(sURL,sPara,sTargetWindow,sStyle) {
	if(typeof(sURL)=="undefined" || sURL=="") { alert("URL不能为空！"); return false; }
	if(sURL.indexOf("?")>=0){ alert("URL中存在\"?\"！"); return false; }
	if(sTargetWindow=="_blank") { alert("弹出的页面不能使用OpenPage函数！"); return false; }
	
	sWindowToUnload="";
	if(sTargetWindow==null || sTargetWindow=="_self"){
		sWindowToUnload="self";
	}else if(sTargetWindow=="_top"){
		sWindowToUnload="top";
	}else if(sTargetWindow=="_blank"){
		sWindowToUnload="";
	}else if(sTargetWindow=="_parent"){
		sWindowToUnload="parent";
	}else sWindowToUnload=sTargetWindow;
	try{
		oWindow = eval(sWindowToUnload);
	}catch(e){
	}
	try{
		oWindow = eval(sWindowToUnload);
		if(!oWindow.checkModified()) return;
	}catch(e){
		try{if(!parent.frames[sWindowToUnload].checkModified()) return;}catch(e2){}
	}

	var sPageURL=sWebRootPath+sURL; if(sURL.indexOf("?")<0) {sPageURL = sPageURL+"?"; } else if (sURL.substr(sURL.length-1)!="?"){sPageURL = sPageURL+"&";}
	sPageURL = sPageURL + "CompClientID="+sCompClientID+this._getParaString(sPara)+"&randp="+this.randomNumber();
	window.open(sPageURL,sTargetWindow,sStyle);
};

AsControl.OpenComp = function(sURL,sPara,sTargetWindow,sStyle) {
	if(sURL.indexOf("?")>=0) { alert("URL中存在\"?\"！"); return false; }

	var sToDestroyClientID="";
	var sWindowToUnload = sTargetWindow;
	if(sTargetWindow=="_blank") {
		return this.PopComp(sURL,sPara);
	}else{
		if(sTargetWindow==null || sTargetWindow=="_self") sWindowToUnload="self";
		if(sTargetWindow==null || sTargetWindow=="_top") sWindowToUnload="top";

		try{
			oWindow = eval(sWindowToUnload);
			sToDestroyClientID = oWindow.sCompClientID;
		}catch(e){
			sToDestroyClientID = "";
		}
		try{if(!oWindow.checkModified()) return;}catch(e1){
			try{if(!parent.frames[sWindowToUnload].checkModified()) return;}catch(e2){}
		}
	}
	if(typeof(sToDestroyClientID)=="undefined" || sToDestroyClientID=="") {sToDestroyClientID="";} else {sToDestroyClientID="&ToDestroyClientID="+sToDestroyClientID;}
	var sPageURL = sWebRootPath + "/Redirector?OpenerClientID="+sCompClientID+sToDestroyClientID+"&ComponentURL="+sURL+this._getParaString(sPara);
	window.open(sPageURL,sTargetWindow,sStyle);
};

AsControl.PopPage = function(sURL,sPara,sStyle)
{
	if(sURL.indexOf("?")>=0){
		alert("错误：页面URL中存在\"?\"。请将页面参数在第二个参数中传入！");
		return false;
	}
	var sDialogStyle = this._getDialogStyle(sStyle);
	var sPageURL = sWebRootPath+"/RedirectorDialog?DiaglogURL="+sURL+"&OpenerClientID="+sCompClientID+"&ComponentURL="+sURL+this._getParaString(sPara);
	return window.showModalDialog(sPageURL,"",sDialogStyle);
};

AsControl.PopComp = function(sURL,sPara,sStyle)
{
	if(sURL.indexOf("?")>=0) { alert("URL中存在\"?\"！"); return false; }
	var sDialogStyle = this._getDialogStyle(sStyle);

	var sCompPara = sPara;
	while(sCompPara.indexOf("&")>=0) sCompPara = sCompPara.replace("&","$[and]");
	
	var sPageURL = sWebRootPath+"/RedirectorDialog?DiaglogURL=/Frame/page/control/OpenCompDialog.jsp&OpenerClientID="+sCompClientID+"&ComponentURL="+sURL+this._getParaString("CompPara="+sCompPara);
	return window.showModalDialog(sPageURL,"",sDialogStyle);
};

AsControl.OpenPageOld = function(sURL,sTargetWindow,sStyle) {
	if(sTargetWindow=="_blank") { alert("弹出的页面不能使用OpenPage函数！");}
	
	var sPageURL=sURL; 
	var sPara = "";
	if(sURL.indexOf("?")>0) {
		sPageURL = sURL.substring(0,sURL.indexOf("?"));
		sPara = sURL.substring(sURL.indexOf("?")+1);
	}
	this.OpenPage(sPageURL, sPara, sTargetWindow,sStyle);
};

AsControl.PopPageOld = function(sURL,sStyle)
{
	var sPageURL=sURL; 
	var sPara = "";
	if(sURL.indexOf("?")>0) {
		sPageURL = sURL.substring(0,sURL.indexOf("?"));
		sPara = sURL.substring(sURL.indexOf("?")+1);
	}
	return this.PopPage(sPageURL, sPara, sStyle);
};

AsControl.OpenView = function(sURL,sPara,sTargetWindow,sStyle){ 	return this.OpenComp(sURL,sPara,sTargetWindow,sStyle);};
AsControl.PopView = function(sURL, sPara, sStyle){	return this.PopComp(sURL, sPara, sStyle);};

AsControl.DestroyComp = function (ToDestroyClientID) {
	$.ajax({url: sWebRootPath+"/Frame/page/control/DestroyCompAction.jsp?ToDestroyClientID="+ToDestroyClientID,async: false});
};

AsControl.RunJavaMethod = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,""),ClassName);
};

AsControl.RunJavaMethodSqlca = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,"&ArgsObject=Sqlca"),ClassName);
};

AsControl.RunJavaMethodTrans = function (ClassName,MethodName,Args) {
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,"&ArgsObject=Trans"),ClassName);
};

AsControl.CallJavaMethodJSP = function (ClassName,MethodName,Args,ArgsObjectText) {
	return $.ajax({
		  url: sWebRootPath+"/Frame/page/sys/tools/RunJavaMethod.jsp?ClassName="+ClassName+"&MethodName="+MethodName+this._getParaString("Args="+Args)+ArgsObjectText,
		  async: false
		 }).responseText.trim();
};

AsControl.CallJavaMethod = function (ClassName,MethodName,Args,ArgsObjectText) {
	return $.ajax({
		  // FIXME 加号替换，请修改为特殊字符，见com.amarsoft.awe.control.RunJavaMethodServlet.doGet
		  url: sWebRootPath+"/servlet/run?ClassName="+ClassName+"&MethodName="+MethodName+this._getParaString("Args="+Args).replace(/\+/g, 'Ж')+ArgsObjectText,
		  async: false
		 }).responseText.trim();
};

AsControl.GetJavaMethodReturn = function (sReturnText,ClassName) {
	window.onerror = function(msg, url, line) {
	    alert("运行异常: " + msg + "\n");
	    //alert("JS异常: " + msg + "\n" + goUrlName(sWebRootPath,url) + ":" + line);
	    return true;
	};
	if (typeof(sReturnText)=='undefined' || sReturnText.length<8) {
		throw new Error("【"+AWES0007+"】后台服务调用出错！\n【"+ClassName+"】");
	}
	var rCode = sReturnText.substring(0,8);
	if (rCode != '00000000') {
		throw new Error("【"+rCode+"】"+sReturnText.substring(8)+"\n【"+ClassName+"】");
	}
	
	sReturnText = sReturnText.substring(8);
	if(sReturnText.length>0 && sReturnText.substring(0,1)=="{")
		return eval("("+ sReturnText +")");
	else
		return sReturnText;
};

AsControl.RunJsp = function(sURL,sPara) {
	if(sURL.indexOf("?")>=0){
		alert("错误：页面URL中存在\"?\"。请将页面参数在第二个参数中传入！");
		return false;
	}
	var sPageURL = sWebRootPath+sURL+"?CompClientID="+sCompClientID+this._getParaString(sPara);
	return $.ajax({url: sPageURL,async: false}).responseText.trim();
};

AsControl.RunJspOne = function(sURL) {
	var sPageURL=sURL; 
	var sPara = "";
	if(sURL.indexOf("?")>0) {
		sPageURL = sURL.substring(0,sURL.indexOf("?"));
		sPara = sURL.substring(sURL.indexOf("?")+1);
	}
	return this.RunJsp(sPageURL, sPara);
};

AsControl.RunASMethod = function(ClassName,MethodName,Args) {
	return this.RunJsp("/Common/ToolsB/RunMethodAJAX.jsp","ClassName="+ClassName+"&MethodName="+MethodName+"&Args="+Args);
};

AsControl.getErrMsg = function (MsgNo) {
	var ClassName="com.amarsoft.awe.res.ErrMsgManager";
	var MethodName="getText";
	var Args="MsgNo="+MsgNo;
	return AsControl.GetJavaMethodReturn(AsControl.CallJavaMethod(ClassName,MethodName,Args,""),ClassName);
};

var OpenStyle=AsControl._getDefaultOpenStyle();
function randomNumber() { return AsControl.randomNumber();}
function OpenComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle) {return AsControl.OpenComp(sCompURL,sPara,sTargetWindow,sStyle);}
function openComp(sCompID,sCompURL,sPara,sTargetWindow,sStyle) {return AsControl.OpenComp(sCompURL,sPara,sTargetWindow,sStyle);}
function PopComp(sComponentID,sComponentURL,sParaString,sStyle) {return AsControl.PopComp(sComponentURL,sParaString,sStyle);}
function popComp(sComponentID,sComponentURL,sParaString,sStyle) {return AsControl.PopComp(sComponentURL,sParaString,sStyle);}
function PopPage(sURL,sTargetWindow,sStyle) {return AsControl.PopPageOld(sURL,sStyle);}
function OpenPage(sURL,sTargetWindow,sStyle) {return AsControl.OpenPageOld(sURL,sTargetWindow,sStyle);}
function RunJavaMethod(ClassName,MethodName,Args) {return AsControl.RunJavaMethod(ClassName,MethodName,Args);}
function RunJavaMethodSqlca(ClassName,MethodName,Args) {return AsControl.RunJavaMethodSqlca(ClassName,MethodName,Args);}
function RunJavaMethodTrans(ClassName,MethodName,Args) {return AsControl.RunJavaMethodTrans(ClassName,MethodName,Args);}
function PopPageAjax(sURL,sTargetWindow,sStyle){return AsControl.RunJspOne(sURL);}
function RunJspAjax(sURL,sTargetWindow,sStyle){return AsControl.RunJspOne(sURL);}
function RunMethod(ClassName,MethodName,Args){return AsControl.RunASMethod(ClassName,MethodName,Args);	}

function getMessageText(iNo) { return AsControl.getErrMsg(iNo);}

var AsDialog = {
	OpenSelector : function(sObjectType,sParaString,sStyle){
		return selectObjectValue(sObjectType,sParaString,sStyle); //使用在SELECT_CATALOG中自定义查询选择信息
	},
	OpenCalender : function(obj,strFormat,startDate,endDate,postEvent){
		if(typeof(strFormat)=="undefined" || strFormat=="") {
			strFormat = "yyyy/MM/dd";
		}
		if(typeof(obj)=="undefined" || obj=="") return null;
		else if (typeof(obj) == "string"){
			obj = document.getElementById(obj);
		}
		var date = new Date();
		var today = date.format(strFormat);
		if(startDate && startDate.toUpperCase() == "TODAY"){
			startDate = today;
		}
		if(endDate && endDate.toUpperCase() == "TODAY"){
			endDate = today;
		}
		SelectDate(obj,strFormat,startDate,endDate,postEvent);
	}
};

function setWindowTitle(sTitle) {
	window.document.title=sTitle+"　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　";
}

function setDialogTitle(sTitle) {
	if(typeof(parent.setTopTitle)=="function"){
		parent.setTopTitle(sTitle);
	}
	else if(typeof(parent.parent.setTopTitle)=="function"){
		parent.parent.setTopTitle(sTitle);
	}
	else if(typeof(parent.parent.parent.setTopTitle)=="function"){
		parent.parent.parent.setTopTitle(sTitle);
	}
}
function getDialogTitle(){
	if(typeof(parent.getTopTitle)=="function"){
		return parent.getTopTitle();
	}
	else if(typeof(parent.parent.getTopTitle)=="function"){
		return parent.parent.getTopTitle();
	}
	else if(typeof(parent.parent.parent.getTopTitle)=="function"){
		return parent.parent.parent.getTopTitle();
	}
}