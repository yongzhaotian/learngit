function reloadSelf(){
	if(typeof(DZ) != "undefined" && DZ && DZ.length>0){
		s_r_c[0]=-1;
		var iCurrentRow = getRow(0);
		TableFactory.search(0,undefined,v_g_DWIsSerializJbo);
		if(iCurrentRow== -1) iCurrentRow=0;
		lightRow(0,iCurrentRow);//高亮
	} else {
		self.location.reload();
	}
}

function formatNumber(number,pattern){ //格式化数字
	var str			= number.toString();
	var strInt;
	var strFloat;
	var formatInt;
	var formatFloat;
	if(/\./g.test(pattern)){
		formatInt		= pattern.split('.')[0];
		formatFloat		= pattern.split('.')[1];
	}else{
		formatInt		= pattern;
		formatFloat		= null;
	}
	if(/\./g.test(str)){
		if(formatFloat!=null){
			var tempFloat	= Math.round(parseFloat('0.'+str.split('.')[1])*Math.pow(10,formatFloat.length))/Math.pow(10,formatFloat.length);
			strInt		= (Math.floor(number)+Math.floor(tempFloat)).toString();				
			strFloat	= /\./g.test(tempFloat.toString())?tempFloat.toString().split('.')[1]:'0';			
		}else{
			strInt		= Math.round(number).toString();
			strFloat	= '0';
		}
	}else{
		strInt		= str;
		strFloat	= '0';
	}
	if(formatInt!=null){
		var outputInt	= '';
		var zero		= formatInt.match(/0*$/)[0].length;
		var comma		= null;
		if(/,/g.test(formatInt)){
			comma		= formatInt.match(/,[^,]*/)[0].length-1;
		}
		var newReg		= new RegExp('(\\d{'+comma+'})','g');
		if(strInt.length<zero){
			outputInt		= new Array(zero+1).join('0')+strInt;
			outputInt		= outputInt.substr(outputInt.length-zero,zero);
		}else{
			outputInt		= strInt;
		}			var 
		outputInt			= outputInt.substr(0,outputInt.length%comma)+outputInt.substring(outputInt.length%comma).replace(newReg,(comma!=null?',':'')+'$1');
		outputInt			= outputInt.replace(/^,/,'');			strInt	= outputInt;
	}
	if(formatFloat!=null){
		var outputFloat	= '';
		var zero		= formatFloat.match(/^0*/)[0].length;
		if(strFloat.length<zero){
			outputFloat		= strFloat+new Array(zero+1).join('0');
			//outputFloat		= outputFloat.substring(0,formatFloat.length);
			var outputFloat1	= outputFloat.substring(0,zero);
			var outputFloat2	= outputFloat.substring(zero,formatFloat.length);
			outputFloat		= outputFloat1+outputFloat2.replace(/0*$/,'');
		}else{
			outputFloat		= strFloat.substring(0,formatFloat.length);
		}
		strFloat	= outputFloat;
	}else{
		if(pattern!='' || (pattern=='' && strFloat=='0')){
			strFloat	= '';
		}
	}
	return strInt+(strFloat==''?'':'.'+strFloat);
}
/**
 * 检查是否IE浏览器
 * @return
 */
function isIEBrowser(){
	if(navigator.appName=="Microsoft Internet Explorer")
		return true;
	else
		return false;
}

function ReplaceAll(str,fstr,pstr){
	if(str.length<=0)return str;
	var curstr;
	var sReturn = "";
	for(var i=0;i<str.length;i++){
		curstr = str.charAt(i);
		//alert(curstr + '|' + fstr + '|' + sReturn);
		if(curstr == fstr)curstr = pstr;
		sReturn += curstr;
	}
	return sReturn;
}
function getFormatedDateString(date,char){
	var year  = date.getFullYear();
	var month= date.getMonth()+1;
	if(month<10)month="0"+month;
	var day = date.getDate();
	if(day<10)day="0"+day;
	return year+char+month+char+day;
}
//格式化为千分位
function FormatKNumber(number_,size){
	if(number_ =='')
		return '';

	var number = "";
	var orgsize = size;

	if(typeof(number_)=="number")
		number = number_ + "";
	else
		number = parseFloat(number_.replace(/,/g,""),10).toString(); //modify in 2011/10/27

	if(number=='')
		return '';
	
	var sPreChar = "";
	var sAfterChar = "";
	if(number.substring(0,1)== "-"){
		sPreChar = "-";
		number = number.substring(1,number.length);
	}
	var	str = number.toString();
	str = ReplaceAll(str,',','');
	
	//获得数字的原始位数
	var oldSize = number.substring(number.indexOf(".")+1,number.length).length;
	
	if(size==undefined || size<0)
		size = oldSize;
	
	if(str.indexOf('.')>-1){
		var dotFormat = "";
		for(var i=0;i<size;i++)
			dotFormat+= "#";
		var sResult = formatNumber(str,'#,###.' + dotFormat);
		oldSize  = sResult.substring(sResult.indexOf(".")+1,sResult.length).length;
		for(var i=oldSize;i<size;i++)
			sAfterChar += "0";
		return sPreChar + sResult + sAfterChar;
	}else{
		var sResult = formatNumber(str,'#,###');
		for(var i=0;i<orgsize;i++){
			if(i==0)
				sAfterChar += ".0";
			else
				sAfterChar += "0";
		}
		return sPreChar + sResult + sAfterChar;
	}
}

//光标选中指定文字
function setSelectText(el,start,end){
	if(el.createTextRange){
		var Range=el.createTextRange();
		Range.collapse();
		Range.moveEnd('character',end);
		Range.moveStart('character',start);
		Range.select();
	}
	if(el.setSelectionRange){
        el.focus();  
        el.setSelectionRange(start,end);  //设光标 
    }
}
//只允许数字
function NumberFilter(value,size,evt){
	var keycode = evt.keyCode;
	if(keycode==13)
		evt.keyCode = 9;
	var dot = value.indexOf(".");
	if(keycode==45){
		if(value.indexOf("-")>-1){
			evt.keyCode=0;
		}
	}else{
		if(dot==-1){
			if(keycode!=46 &&(keycode<48 || keycode>57))
				evt.keyCode=0;

			if(value.replace(/,/g,"").length>=15) 
				evt.keyCode=0;
		}else{
			if(keycode<48 || keycode>57)
				evt.keyCode=0;

			if(value.substring(0,dot).replace(/,/g,"").length>=15)
				evt.keyCode=0;
		}
	}
}

//只允许输入数字
function IntegerFilter(value,evt){
	var keycode = evt.keyCode;
	
	if(keycode==13){
		evt.keyCode = 9;
		//alert(evt.keyCode);
	}
	if(keycode<48 || keycode>57)
		evt.keyCode=0;
}

//禁止黏贴非数字
function ReplaceNaN(obj,evt){
	//alert(clipboardData.getData('text'));
	clipboardData.setData('text',clipboardData.getData('text').replace(/[^0-9\.]+/g,''));
	
}

function wordlimit(obj,evt){
	var arrExclude = [8,37,38,39,40,46,13,35,36,16,17,20,18];
	if(obj.getAttribute("maxlength")){
		var maxLength = parseInt(obj.getAttribute("maxlength")); 
		for(var i=0;i<arrExclude.length;i++)
			if(evt.keyCode==arrExclude[i])return;
		if(obj.value.length>maxLength)
			evt.returnValue = false;
	}
}

//控制显示模板分组信息
function showHideFields(obj,tableid){
	if(tableid=="@SysSubNOGROUPSYS@")
		tableid = "@SysSub@";
	if(obj.expand=="1"){
		obj.expand = "0";
		//obj.src="{RESOURCEPATH}/images/dw/jia.jpg";
		obj.className = "info_group_collapse";
		if(document.getElementById(tableid))
			document.getElementById(tableid).style.display = "none";
	}
	else{
		obj.expand = "1";
		//obj.src="{RESOURCEPATH}/images/dw/jian.jpg";
		obj.className = "info_group_expand";
		if(document.getElementById(tableid))
			document.getElementById(tableid).style.display = "block";
	}
}
//格式化显示日期
function fomartDate(date){
	var sResult = "";
	var sYear = date.getYear();
	var sMonth = date.getMonth()+1;
	if(sMonth<10)sMonth  = "0" + sMonth; 
	var sDate = date.getDate();
	if(sDate<10)sDate  = "0" + sDate;
	sResult  = sYear + "/" + sMonth + "/" + sDate;
	//alert(1);
	return sResult;
}
//还原日期对象
function parseDate(datestr){
	var oDate;
	if(datestr=="")
		oDate = new Date();
	else
		oDate = new Date(datestr);
	//alert(2);
	return oDate;
}
function getCurrentItemValue(fieldName){
	return getItemValue(0,getRow(),fieldName);
}
function setCurrentItemValue(fieldName,value){
	setItemValue(0,getRow(),fieldName,value);
}
var DWDialogEventHandler;
function openDWDialog(initTitle){
	if(initTitle==undefined) initTitle = "正在处理中...";
	var topDiv = $("#DWOverLayoutDiv");
	topDiv.show();
	var obj = $("#DWOverLayoutSubDiv"); //topDiv.children(".datawindow_overdiv_subdiv");
	obj.children(".datawindow_overdiv_info").html(initTitle);
	obj.show();
	var iLeft = document.body.clientWidth/2-obj.width()/2+document.body.scrollLeft;//100 + document.body.scrollLeft;//var iLeft = (topDiv[0].offsetWidth-obj[0].offsetWidth)/2;
	var iTop = document.body.clientHeight/2-obj.height()/2+document.body.scrollTop;//100 + document.body.scrollTop;//var iTop = (topDiv[0].offsetHeight-obj[0].offsetHeight)/2;
	obj.css({left:iLeft,top:iTop});
	document.getElementById('sp_datawindow_overdiv_top').style.display= 'inline';
	
	//alert(obj.children(".datawindow_overdiv_info").html());
}
function resetDWDialog(title,status){
	var obj = $("#DWOverLayoutSubDiv"); 
	obj.children(".datawindow_overdiv_info").html(title);
	DWDialogEventHandler = undefined;
	if(status){
		DWDialogEventHandler = window.setInterval(autoCloseDWDialog, 500);
	}
}
function autoCloseDWDialog(){
	$("#DWOverLayoutDiv").hide();
	$("#DWOverLayoutSubDiv").hide();
	if(DWDialogEventHandler)
		window.clearInterval(DWDialogEventHandler);
}
var DWDialogEventHandlerForAjax_URL=undefined;
var DWDialogEventHandlerForAjax=undefined;
function resetDWDialogForAjax(title,url){
	if(title){
		var obj = $("#DWOverLayoutSubDiv"); 
		obj.children(".datawindow_overdiv_info").html(title);
	}
	DWDialogEventHandlerForAjax_URL = url;
	//alert(DWDialogEventHandlerForAjax_URL);
	
	DWDialogEventHandlerForAjax = window.setInterval(autoCloseDWDialogForAjax, 500);
}
function autoCloseDWDialogForAjax(){
	$.ajax({
		type:"GET",
		url:DWDialogEventHandlerForAjax_URL,
		processData:false,
		success:function(status){
			//alert("status="+status);
			if(status=="true"){
				$("#DWOverLayoutDiv").hide();
				$("#DWOverLayoutSubDiv").hide();
				if(DWDialogEventHandlerForAjax)
					window.clearInterval(DWDialogEventHandlerForAjax);
				DWDialogEventHandlerForAjax_URL=undefined;
				DWDialogEventHandlerForAjax=undefined;
			}
		}
	});
}

function toNumber(value){
	if(typeof(value)=="number")
		return value;
	else
		return parseFloat(value.replace(/,/g,''));
}
function isNumber(value){
	if(value==undefined)
		return false;
	if(value.indexOf("/")>-1)
		return false;
	if(isNaN(value)==false)
		return true;
	else{
		if(isNaN(toNumber(value))==false)
			return true;
		else
			return false;
	}
}

function beforeCheck(dwname){
	return true;
}
function afterCheck(dwname){
	return true;
}
function calendarPancelScroll(scrollTop){
	var calendarPancel = document.getElementById("calendarPanel");
	if(calendarPancel){
		var origtop = calendarPancel.getAttribute("origtop");
		origtop = origtop.substring(0,origtop.length-2);
		origtop= parseInt(origtop);
		calendarPancel.style.top = (origtop-scrollTop)+"px";
	}
}