//Copyright (C) 1998-2003 Amarsoft Corporation
//Writed By HouXD,ZhuRC,HuBy
//All rights reserved.

//var sPath = "/amarbank6/Resources/1/Support/";
//begin 关于格式化调查报告提示保存与自动保存
var bEditHtml = false; 
var bEditHtmlChange = false;
var bEditHtmlAutoSave = true;
//end
var SAVE_TMP=false;
var _user_validator = new Array();//校验规则
var sPath = sResourcesPath+"/Support/";
var DZ = new Array();
var f_c=new Array();  
var r_c=new Array(); 
var rr_c=new Array(); 
var f_css = new Array(); 
var pagenum = new Array();  
var pagesize = new Array(); 
var pageone = new Array(); 
var curpage = new Array();  
var my_change = new Array();           
var my_changedoldvalues = new Array(); 
var my_attribute =  new Array();       
var my_sel_gif = new Array("sel_normal.gif","sel_change.gif","sel_add.gif","sel_delete.gif","sel_adddelete.gif","sel_deletechange.gif","sel_adddeletechange.gif");
var my_notnull = new Array();          
var my_notnull_temp = new Array();
var last_sel_rec = new Array();
var cur_sel_rec = new Array();
var last_sel_item = new Array();
var cur_sel_item = new Array();
var last_frame="";
var cur_frame="";
var needReComputeIndex = new Array();
var my_index = new Array(); 
var cur_sortfield = new Array();
var cur_sortorder = new Array();
var sort_begin = new Array();
var sort_end = new Array();
var myimgstr="";
var iCurRow=-1,iCurCol=0;
var sGDTitleSpace = "&nbsp;";	//add in 2004/03/04
var bNotCheckModified = false;
var sDateReadonlyColor = " readonly style={color:#848284;background:#EEEEFF} "; //add by hxd in 2004/03/15(日期型字段只能选择)
//var sDateReadonlyColor = " style={color:#848284;background:#EEEEFF} "; //add by hxd in 2004/03/15(日期型字段既可选择又可输入)

var s_r_c=new Array(); //server row count,add by hxd in 2004/11/08
var s_p_s=new Array(); 
var s_p_c=new Array();
var s_c_p=new Array(); 
var bTextareaShowLimit = true; //add by hxd in 2005/01/07
var sSaveReturn = "";
var bSavePrompt = true;
var bHighlight = true;
var bNeedCA = false;  
var sContentType = "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\">";
var bShowSelectButton = false;
var keyF7=118;
var sUnloadMessage = "\n\r当前页面内容已经被修改，\n\r按“取消”则留在当前页，然后再按当前页上的“保存”按钮以保存修改过的数据，\n\r按“确定”则不保存修改过的数据并且离开当前页．";
var bShowUnloadMessage=false;  //true for szcb_bank,ceb 此参数已废弃，请不要修改
var bCheckBeforeUnload=true;  //替代 bShowUnloadMessage
var bHighlightFirst = false;
var bDoUnloadOne = true;  //for only one 
var bDoUnload = new Array();
var bShowGridSum = false;
var sSignature = "739D91A4A3A096A58493A4918B9AA097A0B776A795A0AAA6AC5F6261666976A798A2A3A0A6A57698A29185999C95A9AE759E94B2DAE3E26168666E6C719D92";
var dzRowIndex=0;

var sFFormInputStyle   = "font-family:宋体,arial,sans-serif;font-size: 10pt";
var sFFormCaptionStyle = "font-family:宋体,arial,sans-serif;font-size: 10pt;align=center";
var sGridInputStyle    = " ";
var sGridHeaderStyle   = " ";	//color:blue;
var REM_sGridHeaderStyle   = "font-family:宋体,arial,sans-serif;font-size: 10pt; background-color:#B4B4B4;cursor:pointer;text-decoration: none ";	//color:blue;

//var sHeaderStyle = "background-color:#B4B4B4;cursor:pointer;font-family:宋体;font-size: 10pt; text-decoration: none";	
var sHeaderStyle = " ";	
//var sTDStyle = " font-family:宋体; font-size: 10pt; text-decoration: none";	
var sTDStyle = " ";	
var sSumTDStyle = " background-color:#fff;font-family:宋体;font-size: 9pt; text-decoration: none";	

var hmRPTable = " align=left cellspacing=0 cellpadding=0 class='tableContainer' style='border:1px solid #bcbcbc;border-bottom:0px;border-top:0px;' ";
var hmRPPageTr = " ";
var hmRPPageTd = " style='font-family:宋体,arial,sans-serif;font-size:9pt;	font-weight: normal;color: #55554B;	padding-left:5px; border:1px solid #bcbcbc; padding-right:5px;padding-top:2px;padding-bottom:2px;background-color: #CDCDCD;valign:top;' ";
var hmRPHeaderTr = "bgColor=#fff";
var hmRPHeaderTd       = " nowrap align=middle style='background-color:#fff;cursor:pointer;font-family:宋体;font-size: 10pt; text-decoration: none' ";
var hmRPHeaderTdSerial = " nowrap align=middle style='background-color:#fff;cursor:pointer;font-family:宋体;font-size: 10pt; text-decoration: none' ";
var hmRPGroupSumTr = new Array();
var hmRPGroupSumTdSerial = new Array();
var hmRPGroupSumTd = new Array();
var it1=0,itColor=new Array("#FFCCAA","#EE8844","#DD2299","#CC00CC","#BBBBBB","#AAAAAA","#999999","#888888","#777777","#666666","#555555","#444444","#333333","#222222","#111111","#000000");
for(it1=0;it1<16;it1++){
	hmRPGroupSumTr[it1] = " ";
	hmRPGroupSumTdSerial[it1] = " nowrap align=middle style='background-color:#E4E4E4;font-family:宋体;font-size: 9pt; text-decoration: none ' ";
	hmRPGroupSumTd[it1]       = " nowrap              style='background-color:"+itColor[it1]+";font-family:宋体;font-size: 9pt; text-decoration: none ' ";
}
var hmRPContentTr = " ";
var hmRPContentTDSerial = " nowrap align=middle style='font-family:宋体; font-size: 9pt; text-decoration: none ' ";
var hmRPContentTD       = " nowrap              style='font-family:宋体; font-size: 9pt; text-decoration: none ' ";
var hmRPPageSumTr = " ";
var hmRPPageSumTdSerial  = " nowrap align=middle style='font-family:宋体; font-size: 9pt; text-decoration: none ' ";
var hmRPPageSumTd        = " nowrap              style='font-family:宋体; font-size: 9pt; text-decoration: none ' ";
var hmRPTotalSumTr = " ";
var hmRPTotalSumTdSerial = " nowrap align=middle style='font-family:宋体; font-size: 9pt; text-decoration: none ' ";
var hmRPTotalSumTd       = " nowrap              style='font-family:宋体; font-size: 9pt; text-decoration: none ' ";

var hmDate =         "<input type=button class='inputDate' value='...'  ";
var hmSelectButton = "<input type=button class='inputDate' value='...'  ";

var hmFFTable = " class='fftable' border=0 cellspacing=0 cellpadding=2 ";
var hmFFTr = " class='fftr1' ";
var hmFFCaptionTD = " class='fftdhead' nowrap ";
var hmFFTextAreaCaptionTD = hmFFCaptionTD;//" class='fftdheadTextArea' nowrap ";
var hmFFContentTD = " class='FFContentTD' nowrap ";
var hmFFContentInput = " class='fftdinput' style='behavior:url("+sPath+"amarsoft_onchange.sct);' ";
var hmFFContentArea = " class='fftdarea' style='behavior:url("+sPath+"amarsoft_onchange.sct)' ";
var hmFFContentSelect = " class='fftdselect' style='behavior:url("+sPath+"amarsoft_onchange.sct)' " ;
var hmFFBlankTD = " class='FFContentTD' nowrap ";

var hmGDTable = " /**hmGDTable*/ style='border-collapse:collapse;'";
var hmGDHeaderTr = " /**hmGDHeaderTr*/ bgColor=#fff height=20";
var hmGdTdPage = " /**hmGdTdPage*/ class='GdTdPage'";
var hmGDTdHeader = " /**hmGDTdHeader*/ nowrap class='GDTdHeader' ";
var hmGDTdSerialWidth = "width=20";//行号宽度
var hmCountLineHeight = 20;//汇总表格行高度
//var hmGdTdSerial = " /**hmGdTdSerial*/ style='cursor:pointer;font-size: 9pt;color:black;align:absmiddle;valign:top' bgcolor=#999999 noWrap align=middle valign=top width=14  class='TCSelImageUnselected' ";
var hmGdTdSerial = " /**hmGdTdSerial*/ align=center valign=top " + hmGDTdSerialWidth+ "  ";

var hmGdSumTr = "";
var hmGdSumTdSerial = " <TD nowrap id='T0' style='cursor:pointer;font-size: 9pt;color:black;align:absmiddle;valign:top' bgcolor=#EEE1D2 align=center valign=top  >总计</TD> ";
var hmGdSumTd = " style='font-family:宋体,arial,sans-serif;font-size: 9pt ' ";

var sMandatorySignal = " &nbsp;<font color=red>*</font> ";
var hmGdTdContent = " nowrap ";//bgcolor=#FEFEFE

var hmGdTdContentInput1 = " class='GDTdContentInput' ";
var hmGdTdContentArea1 = " class='hmGdTdContentArea' ";
var hmGdTdContentSelect1 = " class='GdTdContentSelect' ";

var hmGdTdContentInput2 =  " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentInput1 ;
var hmGdTdContentArea2 =   " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentArea1;
var hmGdTdContentSelect2 = " style='behavior:url("+sPath+"amarsoft_onchange.sct)' "+hmGdTdContentSelect1;
var hmGdTdContentRadio = " style='height: 13px;margin-right: 2px;margin-left: 2px;' ";
var hmGdTdContentCheckbox = " style='height: 13px;margin-right: 2px;margin-left: 2px;' ";

if(navigator.appName != "Microsoft Internet Explorer"){
	hmFFContentInput = " class='fftdinput' ";
	hmFFContentArea = " class='fftdarea' ";
	hmFFContentSelect = " class='fftdselect' " ;
	hmGdTdContentInput2 =  hmGdTdContentInput1 ;
	hmGdTdContentArea2 =   hmGdTdContentArea1;
	hmGdTdContentSelect2 = hmGdTdContentSelect1;
}

// datawindow 排布数组
var arrangements = new Array();
var harbors = new Array();
var bFreeFormMultiCol = false;

//below can modify in jsp
function myAfterLoadGrid(iDW){
	//setColor(iDW,sEvenColor);
	//Add you code
}

function myAfterLoadFreeForm(iDW){
	//Add you code
}

function mySelectRow(){ 
	//demo code
	//if(myiframe0.event.srcElement.tagName=="BODY") return;	
	//setColor();	
}

function myHandleSelectChangeByIndex(iDW,iRow,iCol){
	sCol = getColName(iDW,iCol);
	myHandleSelectChange(iDW,iRow,sCol);
}

function myHandleSelectChange(iDW,iRow,sCol){
}

function myNumberBFP(myobj){
	try {
		clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d\-+.]/g,''));
	}catch(e){}
}	

function myNumberFC(myobj){
	myobj.value=myobj.value.replace(/,/g,"");
	myNumberPOS(myobj);
}	

function myNumberPOS(myobj)  {
	try {
	   if  (myobj.createTextRange)  {
		   var  r  =  myobj.createTextRange();
		   var  ipos = myobj.value.indexOf('.');
		   if (ipos == -1) {
			   ipos = myobj.value.length;
		   }
		   r.moveStart('character',ipos);
		   r.collapse();
		   r.select();
	   }
	} catch(E) {
		var a=1;
	}
}

function myNumberKD(myobj,event){
	try {
		var mycode = event.keyCode;
		if (mycode == 8 || mycode == 46) { //delete,backspace
		  //event.keyCode = 8; //backspace
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 13 || mycode == 9 || mycode == 27 ) { //enter,tab,esc
		  event.returnValue = true;
		  return;
		}
		else if (mycode >= 16 && mycode <= 18 ) { //shift,ctrl,alt
		  event.returnValue = true;
		  return;
		}
		else if (event.ctrlKey == true && (mycode == 67 || mycode == 86 || mycode == 88)) { //ctrl+cvx
		  event.returnValue = true;
		  return;
		}
		else if ((mycode == 110 || mycode == 190) && myobj.value.indexOf('.')==-1) {//'.'
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 109 || mycode == 189) {//'-'
		  event.returnValue = true;
		  return;
		}
		else if (event.shiftKey == false && mycode >= 48 && mycode <= 57 ) { //0-9
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 40) { //down
		  event.keyCode = 9; //tab
		  event.returnValue = true;
		  return;
		}
		else if (mycode >= 33 && mycode <= 40) { //left,right,home...
		  event.returnValue = true;
		  return;
		}
		else if (mycode == 229 ) { //chinese
		  event.returnValue = true;
		  return;
		}
		else if (mycode >= 96 && mycode <= 105 ) { //[num]0-9
		  event.returnValue = true;
		  return;
		}
		else {
		  event.returnValue = false;
		  return;
		}
	} catch(E) {
		var a=1;
	}
}

function myNumberKU(myobj, event){
	event = event || window.frames["myiframe0"].event;
	var mycode = event.keyCode;
	if( (mycode>=33 && mycode<=39 )|| mycode==16 || mycode==17 ||mycode==18 ||mycode==8) //left,right,home...alt,ctrl,shift,delete
		return; 
	if(mycode!=43 && mycode!=44 && mycode!=45 && mycode!=46 &&
	mycode!=187 && mycode!=188 && mycode!=189 && mycode!=190 &&
	mycode!= 48 && mycode!= 49 && mycode!= 50 && mycode!= 51 && mycode!= 52 &&
	mycode!= 53 && mycode!= 54 && mycode!= 55 && mycode!= 56 && mycode!= 57 && //+,-. 0123456789
	mycode!= 96 && mycode!= 97 && mycode!= 98 && mycode!= 99 && mycode!= 100 &&  //numlock:0-4
	mycode!= 101 && mycode!= 102 && mycode!= 103 && mycode!= 104 && mycode!= 105 &&  //numlock:5-9
	mycode!= 107 && mycode!= 109 && mycode!= 110 ) {//numlock: + - .
		myobj.value=myobj.value.replace(/[^\d\-+.,]/g,'');
		myNumberPOS(myobj);
	}
}	

function myNumberKP(myobj, event){
	try {
		var mycode = event.keyCode;
		if (mycode == 45) {//'-'
		  if (myobj.value.indexOf('-')==-1) {
			  myobj.value = '-' + myobj.value;
		  } else {
			  myobj.value=myobj.value.replace(/-/,"");
		  }
		  myNumberPOS(myobj);
		  event.returnValue = false;
		  return;
		}

		if(myobj.value!="") {
			var a;
			a=parseFloat(myobj.value,10);
			if(Math.abs(a)>100000000000000) {
				alert("数据不正常！");
				myobj.value="";
				event.returnValue = false;
			}
		}
	} catch(E) {
		var a=1;
	}
}	

function myNumberBL(myobj){
	try {
		myobj.value=myobj.value.replace(/[^\d\-+.,]/g,'');  
		/*
		if(myobj.value!="") 
		{
			myobj.value=parseFloat(myobj.value,10);
			if(isNaN(myobj.value)) myobj.value="";
		}
		*/
		if(myobj.value==".") myobj.value="";		
		if(!reg_Num(myobj.value)) myobj.value="";

		if(typeof(myobj.myvalid)!="undefined" && myobj.myvalid!="undefined" ) {
			if(myobj.value.replace(/[^\d\-+.]/g,'')!='' && !eval(myobj.myvalid.replace(/myobj.value/g,myobj.value.replace(/[^\d\-+.]/g,''))))	 //kick 掉 ,
			{
				alert(myobj.mymsg);
				myobj.focus();
			}
		}
	} catch(E) {
		var a=1;
	}
}	

//检查输入的数据的小数位是否超过规定的位数
function FormatNumber(srcStr,nBeforeDot,nAfterDot){ //格式化数字 (int srcStr,int 小数位数)
	srcStr = new String(srcStr);
	if(srcStr=="" || srcStr==null) return true;
	strLen = srcStr.length;	
	dotPos = srcStr.indexOf(".");		
	if(strLen > (nBeforeDot + nAfterDot +1)){return false;} 
	else {
		if (dotPos == -1) {
			if(strLen> (nBeforeDot + nAfterDot)){return false;}  
		}else if((strLen - dotPos) > (nAfterDot + 1)){return false;} 
	}	
	return true;	
}

//判断输入的数据是否全部为数字或一个点号(.)，如果是数字,返回true.
function reg_Num(str){
	var Letters = "-1234567890.,";
	var j = 0;		
	if(str=="" || str==null) return true;
	for (var i=0;i<str.length;i++) {
		var CheckChar = str.charAt(i);
		if (Letters.indexOf(CheckChar) == -1){return false;}
		if (CheckChar == "."){j = j + 1;}
	}
	if (j > 1){return false;}
	return true;
}

//验证数值 ,这个方法较方法reg_Num()更全面一点    add by zhuang 2010-03-23
function validateNum(str){
    var Letters = "-1234567890.,";
    var j = 0;
    var m = 0;   
    if(str=="0"){
    	return "true";
    }
    if(str=="" || str==null) return "true";//返回值为 “true”表示输入合法
    if(str.charAt(0)=="." || str.charAt(str.length-1)==".") {return "false";}//返回值为 “false”表示输入合法

    for(var i=0;i<str.length;i++){
        var CheckChar = str.charAt(i);
        if (Letters.indexOf(CheckChar) == -1){return "false";}
        if (CheckChar == "."){j = j + 1;} 
    }  
                        
    if (j > 1){
        return "false";
    }else{
    	if(j==1){
    		var sStrSubs = str.split(".");//截取整数部分
    		sStrSub =  sStrSubs[0];           
    	}else if(j==0){
    		sStrSub = str;    
        }
    	for (var k=0;k<sStrSub.length;k++){   
    		CheckChar = sStrSub.charAt(k);               
    		if (CheckChar == "0"){  
    			m = m + 1;
    		}else{
    			break;  
            }
        }
    	//m==1:当数值时整数，且输入的第一个数为0时的处理
    	if((m==1) && (str.indexOf(".")==-1)){
        	return k=1;
        }
    	if(m>1){
    		if(m==sStrSub.length){k = k - 1;}
    		return k;//返回第一个非无效 0 的下标 ，或当整数部分全为0时倒数第二个0的下标值
    	}else{
            return "true";
        }
    }
}

//根据自定义小数位数四舍五入,参数object为传入的数值,参数decimal为保留小数位数
function roundOff(number,digit){
	var sNumstr = 1;
	for (var i=0;i<digit;i++) {
		sNumstr=sNumstr*10;
	}
	sReturnValue = Math.round(parseFloat(number)*sNumstr)/sNumstr;
	return sReturnValue;
}

//real,amarsoft,db,js,html
var sAmarReplace = new Array();
sAmarReplace[0] = new Array("\\",		"~[isl]",	"\\",	"\\\\",		"&#92;");
sAmarReplace[1] = new Array("'",		"~[sqt]",	"''",	"\\'",		"&#39;");
sAmarReplace[2] = new Array("\"",		"~[dqt]",	"\"",	"\"",		"&#34;");
sAmarReplace[3] = new Array("<",		"~[alt]",	"<",	"<",		"&#60;");
sAmarReplace[4] = new Array(">",		"~[agt]",	">",	">",		"&#62;");
sAmarReplace[5] = new Array("\r\n",		"~[arn]",	"\r\n",	"\\r\\n",	"&#13;&#10;"); //\r\n
sAmarReplace[6] = new Array("\r",		"~[aor]",	"\r\n",	"\\r\\n",	"&#13;&#10;");
sAmarReplace[7] = new Array("\n",		"~[aon]",	"\r\n",	"\\r\\n",	"&#13;&#10;");
sAmarReplace[8] = new Array("#",		"~[pds]",	"#",	"#",	"#");
sAmarReplace[9] = new Array("(",		"~[lpr]",	"(",	"(",	"(");
sAmarReplace[10] = new Array(")",		"~[rpr]",	")",	")",	")");
sAmarReplace[11] = new Array("+",		"~[pls]",	"+",	"+",	"+");

/**
 * 将字符串sSource中以sBeginIdentifier和sEndIdentifier查找识别到的子字符串sAttributes[i][iAttID]替换为sAttributes[i][iAttValue]<br>
 */
function macroReplace(sAttributes,sSource,sBeginIdentifier,sEndIdentifier,iAttID,iAttValue){
	var iPosBegin=0,iPosEnd=0;
	var sAttributeID="";
	var sReturn = sSource;
	while((iPosBegin=sReturn.indexOf(sBeginIdentifier,iPosBegin))>=0){
		iPosEnd = sReturn.indexOf(sEndIdentifier,iPosBegin);
		sAttributeID = sReturn.substring(iPosBegin ,iPosEnd + sEndIdentifier.length);
		sReturn = sReturn.substring(0,iPosBegin) + getAttribute(sAttributes,sAttributeID,iAttID,iAttValue) + sReturn.substring(iPosEnd+sEndIdentifier.length);
	}
	return sReturn;
}

/**取属性值，无该属性返回Null */
function getAttribute(sAttributes,sAttributeName,iAttID,iAttValue){
	var sAttributeValue;
	for(var i=0;i<sAttributes.length;i++){
		if (sAttributes[i][iAttID]==sAttributeName){
			sAttributeValue = sAttributes[i][iAttValue];
			return sAttributeValue;
		}	
	}	
	return sAttributeValue;
}

function temptest(){
	var tmpstr = "~[pds]12345~[alt]";
	alert(macroReplace(sAmarReplace,tmpstr,"~[","]",1,0));
}

function amarsoft2Html(sSource){
	try{
		if(typeof(sSource)!='string') return sSource;
	
		sReturn = sSource;
		sReturn = macroReplace(sAmarReplace,sReturn,"~[","]",1,4);
		/*
		for(i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][1],sAmarReplace[i][4]);
		*/
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function amarsoft2Real(sSource){
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		sReturn = macroReplace(sAmarReplace,sReturn,"~[","]",1,0);
		/*
		for(i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][1],sAmarReplace[i][0]);
		*/
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}
function real2Amarsoft(sSource){
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		
		for(var i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][0],sAmarReplace[i][1]);
		
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function html2Amarsoft(sSource){
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		
		for(var i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][4],sAmarReplace[i][1]);
		
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function html2Real(sSource){
	try{
		if(typeof(sSource)!='string') return sSource;
		
		sReturn = sSource;
		
		for(var i=0;i<sAmarReplace.length;i++)
			sReturn = replaceAll(sReturn,sAmarReplace[i][4],sAmarReplace[i][0]);
		
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}	
}

function beforeKeyDown(myiframe){
	try {
	if(window.frames[myiframe].event.srcElement.name.indexOf("Radio")>0)
		return false;
	} catch(e) { var a_a=1; }	

	return true;
}

function doKeyDown(myiframe){ }

function afterKeyDown(myiframe){ }

function beforeKeyUp(myiframe){
	try {
	if(window.frames[myiframe].event.srcElement.name.indexOf("Radio")>0)
		return false;
	} catch(e) { var a_a=1; }	
		
	return true;
}

function doKeyUp(myiframe){
	try {
		if(window.frames[myiframe].event.keyCode==13) {
	   		var j = "0";
			var obj = window.frames[myiframe].event.srcElement;
			for(var i=0;i<window.frames[myiframe].document.all.length;i++){
				if(window.frames[myiframe].document.all[i].name==obj.name){
					j="1";
					continue;
				}
				//kick btnR(keyF7)
				if(j=="1" && window.frames[myiframe].document.all[i].name!=null && window.frames[myiframe].document.all[i].name.indexOf("R")!=-1 && window.frames[myiframe].document.all[i].name.substring(0,4)!="btnR")
				{
					if (window.frames[myiframe].document.all[i].disabled==true||window.frames[myiframe].document.all[i].readOnly==true) {
						continue;
					}
					window.frames[myiframe].document.all[i].focus();
					break;
				}

			}   			
	   	}	
	} catch(e) { var a_a=1; }
}

function afterKeyUp(myiframe){ }

function beforeMouseDown(myiframe){
	if(cur_frame=="myform999")
		cur_frame=myiframe;
		
	return true;
}
	
function doMouseDown(myiframe){ }

function afterMouseDown(myiframe){ }

function beforeKeyUp_show(e, myiframe){
	//modify by hxd in 2008/04/10
	//return true;
	//return true;  //2008/02/01 citibank不需要dw export
	return !myHandleSpecialKey(e, myiframe); //必须取反
}

function doKeyUp_show(myiframe){ }

function afterKeyUp_show(myiframe){ }

function beforeMouseDown_show(myiframe){
	return true;
}

function doMouseDown_show(myiframe){ }

function afterMouseDown_show(myiframe){ }

function mymu(){
	alert("up");
}	
//frames["myiframe0"].document.body.onmouseup = mymu;
	
//以下函数为过滤器使用 
var FILTER_OPERATORS = new Array(14);
FILTER_OPERATORS[0] = new Array('SmallerThanOrEquals','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[1] = new Array('BeginsWith','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[2] = new Array('BetweenNumber','','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5');
FILTER_OPERATORS[3] = new Array('BetweenString','','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6');
FILTER_OPERATORS[4] = new Array('BiggerThan','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[5] = new Array('BiggerThanOrEquals','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[6] = new Array('Contains','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[7] = new Array('NotContains','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[8] = new Array('EndWith','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[9] = new Array('EqualsNumber','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3');
FILTER_OPERATORS[10] = new Array('EqualsString','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[11] = new Array('NotEquals','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');
FILTER_OPERATORS[12] = new Array('SmallerThan','#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','#{FilterID}_TD_3');
FILTER_OPERATORS[13] = new Array('IsNull','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','');
FILTER_OPERATORS[14] = new Array('IsNotNull','#{FilterID}_TD_3,#{FilterID}_TD_4,#{FilterID}_TD_5,#{FilterID}_TD_6','');
/**add by byhu 2008.02.21 用于身份证18位和15位互换*/
FILTER_OPERATORS[15] = new Array('EqualsCert','#{FilterID}_TD_4,#{FilterID}_TD_5','#{FilterID}_TD_3,#{FilterID}_TD_6');

function replaceAll(sSource,sOldString,sNewString){
	try{
		if(typeof(sSource)!='string') return sSource;
		var iPosBegin = 0;
		sReturn = sSource;
		//alert(sReturn+"\r\n"+sOldString+"\r\n"+sNewString);
		iPosBegin = sReturn.indexOf(sOldString,iPosBegin);
		while(iPosBegin>=0){
			//sReturn = sReturn.replace(sOldString,sNewString);
			sReturn = sReturn.substring(0,iPosBegin)+sNewString+sReturn.substring(iPosBegin+sOldString.length);
			iPosBegin = sReturn.indexOf(sOldString,iPosBegin+sNewString.length);
		}
		return sReturn;
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message);
	}
}

function filterAction(sObjectID,sFilterID){
	alert(sObjectID+" "+sFilterID);
}
function selectFilterDate(sObjectID,sFilterID){
	var oInput = document.getElementById(sObjectID);
	AsDialog.OpenCalender(oInput,"yyyy/MM/dd");
	//sReturn = PopPage("/Common/ToolsA/SelectDate.jsp","","dialogwidth:320px;dialogheight:280px");
	//if(typeof(sReturn)!="undefined" && sReturn!="" && sReturn!="_CANCEL_"){
	//选择清空时，做清除
	//if(typeof(sReturn)!="undefined" && sReturn!="_CANCEL_"){
	//	oInput.value=sReturn;
	//}
}

function applyFilters(){
	alert("abc");
}
function checkDOFilterForm_old(oForm){
	return true;
}

function checkDOFilterForm(oForm){
	var myi=0;
	var i=0;
	var j=0;
	var bHaveEquals = false;
	var bHaveOrgAndNoValue = false;
	var sOrgCaption = "";
	var specialChar = new Array('%','"','\'','\\','$','％');//设置查询条件需要过滤的特殊字符   

	for(i=0;i<oForm.length;i++){
		if(oForm.elements[i].tagName=="TD" && oForm.elements[i].id.indexOf("_TD_1")>0 ){
			for(j=0;j<DZ[myi][1].length;j++){
				try {
				if(DZ[myi][1][j][0]==oForm.elements[i].innerText){

					if(oForm.document.getElementById(oForm.elements[i].id.replace("_TD_1","")+"_OP_ID").value=="EqualsString" &&
						oForm.document.getElementById("DOFILTER_"+oForm.elements[i].id.replace("_TD_1","")+"_1_VALUE").value!=""  )
						bHaveEquals = true;
				
					if(DZ[myi][1][j][12]==2 || DZ[myi][1][j][12]==5 || DZ[myi][1][j][12]>10) //数字
					{
						if(isNaN(oForm.document.getElementById("DOFILTER_"+oForm.elements[i].id.replace("_TD_1","")+"_1_VALUE").value) ||
							isNaN(oForm.document.getElementById("DOFILTER_"+oForm.elements[i].id.replace("_TD_1","")+"_2_VALUE").value) ) 
						{
							alert("["+oForm.elements[i].innerText+"]应为数字！");
							return false;
						}
					}	
					//开发阶段可以屏蔽掉如下FOR循环代码，从而禁用查询条件中的特殊字符过滤功能。
					for(var k=0;k<specialChar.length;k++ ){
						if(oForm.document.getElementById("DOFILTER_"+oForm.elements[i].id.replace("_TD_1","")+"_1_VALUE").value.indexOf(specialChar[k]) > -1 || 
							oForm.document.getElementById("DOFILTER_"+oForm.elements[i].id.replace("_TD_1","")+"_2_VALUE").value.indexOf(specialChar[k]) > -1)
						{
							alert("["+oForm.elements[i].innerText+"]不能含有特殊字符"+specialChar[k]+"！");
							return false;
						}
					}
				
					//如果涉及谁用到了，请自行调整一下
					//if(oForm.elements[i].innerText=="登记机构"||oForm.elements[i].innerText=="管户机构" ||oForm.elements[i].innerText=="经办机构"||oForm.elements[i].innerText=="所属机构")
					if(DZ[myi][1][j][15].toUpperCase( ).indexOf("ORGID")>0){
						if((oForm.document.getElementById("DOFILTER_"+oForm.elements[i].id.replace("_TD_1","")+"_1_VALUE").value=="" || 
							oForm.document.getElementById("DOFILTER_"+oForm.elements[i].id.replace("_TD_1","")+"_1_VALUE").value==null))
						{
							//alert("["+oForm.elements[i].innerText+"]不能为空，请选择相应的"+"["+oForm.elements[i].innerText+"]");
							//return false;
							bHaveOrgAndNoValue = true;
							sOrgCaption = oForm.elements[i].innerText;
						}else{
							bHaveOrgAndNoValue = false;
						}
					}
					break;			
				}
				}catch(e){}
			}
		}
	}
	
	if( bHaveOrgAndNoValue && !bHaveEquals){
		alert("["+sOrgCaption+"]不能为空，请选择相应的"+"["+sOrgCaption+"]");
		return false;
	}
	
	ShowMessage("系统正在处理数据，请等待...",true,false);
	return true;
}

/**modify by zywei 2006.2.16 17:20 调整了函数onFromAction的输入参数值*/
function submitFilterForm(sFormName){
	var oForm = document.forms[sFormName];
	//for(i=0;i<oForm.elements.length;i++) alert(oForm.elements[i].name+":"+oForm.elements[i].value);
	//oForm.submit();		
	amarhidden.style.display = "none";
	onFromAction(oForm,sFormName);
}
function clearFilterForm(sFormName){
	var oForm = document.forms[sFormName];
	for(var i=0;i<oForm.elements.length;i++){
		if(oForm.elements[i].name.indexOf("_OP")>=0 || oForm.elements[i].type=="button" || oForm.elements[i].type=="reset"|| oForm.elements[i].type=="submit"){
			continue;
		}else if(oForm.elements[i].type=="checkbox"){
			oForm.elements[i].checked=false;
		}else{
			oForm.elements[i].value="";
		}
	}
}
function resetFilterForm(sFormName){
	var oForm = document.forms[sFormName];
	oForm.reset();
}

function showHideFilterElements(sFilterID,oOperatorObj){
	try{
		for(var iOperators=0;iOperators<FILTER_OPERATORS.length;iOperators++){
			if(oOperatorObj.value==FILTER_OPERATORS[iOperators][0]){
				sObjectsToHide = replaceAll(FILTER_OPERATORS[iOperators][1],"#{FilterID}",sFilterID);
				sObjectsToShow = replaceAll(FILTER_OPERATORS[iOperators][2],"#{FilterID}",sFilterID);
				if(sObjectsToHide!="") showHideObjects(sObjectsToHide,"hide");
				if(sObjectsToShow!="") showHideObjects(sObjectsToShow,"show");
			}
		}
	}catch(e){
		alert("显示/隐藏过滤器符号对应的对象时出错。请检查Html模版。");
	}
}

function showHideObjects(sObjects,sShowOrHide){
	if(sObjects=="") return;
	var sTargetObjects = sObjects.split(",");
	if(sTargetObjects=="") return;
	for (var iObject=0;iObject<sTargetObjects.length;iObject++){
		if(sShowOrHide=="hide"){
			try{
				sCurObj = document.getElementById(sTargetObjects[iObject]);
				sCurObj.style.display = "none";
			}catch(e){
				alert("隐藏过滤器符号对应的对象时出错。请检查Html模版。"+e);
			}
		}else{
			try{
				sCurObj = document.getElementById(sTargetObjects[iObject]);
				sCurObj.style.display = "";
			}catch(e){
				alert("显示过滤器符号对应的对象时出错。请检查Html模版。"+e);
			}
		}
	}
}

function multiSelectAll(flag){
	if(flag != true) flag = false;
	var iDW = 0;
	var b = getRowCount(iDW);
	var iCol = getColIndex(iDW, "MultiSelectionFlag");
	var form = window.frames["myiframe"+iDW].document.forms[0];
	for(var iMSR = 0 ; iMSR < b ; iMSR++){
		var element = form.elements["R"+iMSR+"F"+iCol];
		element.checked = flag;
		element.value = flag ? "√" : "";
	}
}

function getItemValueArray(iDW,sColumnID){
	var b = getRowCount(iDW);
	var countSelected = 0;
	var sMemberIDTemp = "";
	var sSelected = new Array(1000);
	for(var iMSR = 0 ; iMSR < b ; iMSR++){
		var a = getItemValue(iDW,iMSR,"MultiSelectionFlag");
		if(a == "√"){
			sSelected[countSelected] = getItemValue(iDW,iMSR,sColumnID);
			countSelected++;
		}
	}
	var sReturn = new Array(countSelected);
	for(var iReturnMSR = 0;iReturnMSR < countSelected; iReturnMSR++){
		sReturn[iReturnMSR] = sSelected[iReturnMSR];
	}
	return sReturn;
}

var oTempObj; // 用于临时中转对象句柄

function editWithScriptEditor(iDW,sCol){
	var myobj = getASObject(iDW,getRow(0),sCol);
	editObjectValueWithScriptEditor(myobj);
}

function editObjectValueWithScriptEditor(oObject,sScriptLanguage){
	var sTempLanguage;
	if(typeof(sScriptLanguage)!="undefined" && sScriptLanguage!="")
		sTempLanguage = sScriptLanguage;
	else sTempLanguage = "AmarScript";

	sInput = oObject.value;
	sInput = real2Amarsoft(sInput);
	sInput = replaceAll(sInput,"~","$[wave]");
	oTempObj = oObject;
	if(sTempLanguage=="AFS")
		saveParaToComp("ScriptText="+sInput+"&ScriptLanguage="+sTempLanguage,"openScriptEditorForAFSAndSetText()");
	else
		saveParaToComp("ScriptText="+sInput+"&ScriptLanguage="+sTempLanguage,"openScriptEditorAndSetText()");
}

function editObjectValueWithScriptEditorForAFS(oObject,sModelNo){
	var sTempModelNo;
	if(typeof(sModelNo)!="undefined" && sModelNo!="")
		sTempModelNo = sModelNo;
	else sTempModelNo = "";

	sInput = oObject.value;
	
	sInput = real2Amarsoft(sInput);
	sInput = replaceAll(sInput,"~","$[wave]");
	oTempObj = oObject;
    saveParaToComp("ScriptText="+sInput+"&ModelNo="+sTempModelNo,"openScriptEditorForAFSAndSetText()");
}

function editObjectValueWithScriptEditorForASScript(oObject){
	sInput = oObject.value;
	
	sInput = real2Amarsoft(sInput);
	sInput = replaceAll(sInput,"~","$[wave]");
	oTempObj = oObject;
    saveParaToComp("ScriptText="+sInput,"openScriptEditorForASScriptAndSetText()");
}

function openScriptEditorAndSetText(){
	var oMyobj = oTempObj;
	sOutPut = popComp("ScriptEditor","/Common/ScriptEditor/ScriptEditor.jsp","","");
	if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_"){
		oMyobj.value = amarsoft2Real(sOutPut);
	}
}

function openScriptEditorForAFSAndSetText(){
	var oMyobj = oTempObj;
	sOutPut = popComp("ScriptEditorForAFS","/Common/ScriptEditor/ScriptEditorForAFS.jsp","","");
	if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_"){
		oMyobj.value = amarsoft2Real(sOutPut);
	}
}

function openScriptEditorForASScriptAndSetText(){
	var oMyobj = oTempObj;
	sOutPut = popComp("ScriptEditorForASScript","/Common/ScriptEditor/ScriptEditorForASScript.jsp","","");
	if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_"){
		oMyobj.value = amarsoft2Real(sOutPut);
	}
}
	
//用于动态生成iframe并通过post将数据传递至模态窗口 
function generateIframe(){
	iframeName=randomNumber().toString();
	iframeName = "frame"+iframeName.substring(2);

	//modify in 2008/04/10,2008/02/14 for https
	//var sHTML="<iframe name='"+iframeName+"'  style='display:none'>";
	var sHTML="<iframe name='"+iframeName+"' src='"+sWebRootPath+"/amarsoft.html' style='display:none'>";
	
	document.body.insertAdjacentHTML("afterBegin",sHTML);
	//alert(sHTML);
	return iframeName;
}
//用于动态生成 form 并通过post将数据传递至模态窗口 
function saveParaToComp(paraString,postAction){
	var sFormName=randomNumber().toString();
	sFormName = "form"+sFormName.substring(2);
	var targetFrameName=generateIframe();
	var sHTML = "";
	if(typeof(dialogStyle)=="undefined" || dialogStyle=="") dialogStyle="";
	var sParaStringToPost = real2Amarsoft(paraString);
	var sPostActionToPost = real2Amarsoft(postAction);
	
	//modify in 2008/04/10
	//sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action='"+sPath+"SaveParaAndShowDialog.jsp' style='display:none'>";
	sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action='"+sPath+"SaveParaToComp.jsp' style='display:none'>";
	
	sHTML+="<input type=hidden name='CompClientID' value='"+sCompClientID+"'>";
	sHTML+="<input type=hidden name='PageClientID' value='"+sPageClientID+"'>";
	sHTML+="<input type=hidden name='TempParaString' id='TempParaString' value=''>";
	sHTML+="<input type=hidden name='TempPostAction' value='"+sPostActionToPost+"'>";
	sHTML+="</form>";
	//alert(sHTML);
	document.body.insertAdjacentHTML("afterBegin",sHTML);

	var oForm = document.forms[sFormName];
	var oElement = oForm.elements["TempParaString"];
	oElement.value = sParaStringToPost;
	oForm.submit();
}

//用于动态生成 form 并通过post将数据传递至模态窗口 
function saveParaToCompSession(paraString,postAction){
	var sFormName=randomNumber().toString();
	sFormName = "form"+sFormName.substring(2);
	var targetFrameName=generateIframe();
	var sHTML = "";
	if(typeof(dialogStyle)=="undefined" || dialogStyle=="") dialogStyle="";
	var sParaStringToPost = real2Amarsoft(paraString);
	var sPostActionToPost = real2Amarsoft(postAction);
	sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action='"+sPath+"SaveParaToCompSession.jsp' style='display:none'>";
	sHTML+="<input type=hidden name='CompClientID' value='"+sCompClientID+"'>";
	sHTML+="<input type=hidden name='PageClientID' value='"+sPageClientID+"'>";
	sHTML+="<input type=hidden name='TempParaString' id='TempParaString' value=''>";
	sHTML+="<input type=hidden name='TempPostAction' value='"+sPostActionToPost+"'>";
	sHTML+="</form>";
	//alert(sHTML);
	document.body.insertAdjacentHTML("afterBegin",sHTML);

	var oForm = document.forms[sFormName];
	var oElement = oForm.elements["TempParaString"];
	oElement.value = sParaStringToPost;
	oForm.submit();
}

function checkModified(){
	var myobjname = cur_frame;
	//begin 关于格式化调查报告提示保存与自动保存
	if(bEditHtml && bEditHtmlChange ){
        if(confirm(sUnloadMessage)) return true;
        else return false;
    }
    //end
	if(isModified(myobjname) && bCheckBeforeUnload){
		if(confirm(sUnloadMessage)) return true;//"当前页面内容已经被修改，按“确定”则不保存修改过的数据并且离开当前页，按“取消”则留在当前页，然后再按当前页上的“保存”按钮以保存修改过的数据。";
		else return false;
	}else{
		return true;
	}
}

function f_myPad0(myi)
{
	var f_mys0 = "";
	if(myi<10)
		f_mys0 = "0"+myi.toString(10);
	else
		f_mys0 = myi.toString(10);
	return f_mys0;
}

function f_myDate()
{
	var d = new Date();
	var s = "" ;
	
	s += f_myPad0(d.getYear());
	s += f_myPad0(d.getMonth()+1);
	s += f_myPad0(d.getDate());
	s += f_myPad0(d.getHours());
	s += f_myPad0(d.getMinutes());
	s += f_myPad0(d.getSeconds());
	s += f_myPad0(d.getMilliseconds());
	
	return s;
}
	
function amarExport(myname){
	try{
		window.showModalDialog(sPath+"GetDWDataAll.jsp?CompClientID="+sCompClientID+"&type=export&dw="+DZ[myname.substring(myname.length-1)][0][1]+"&rand="+randomNumber(),"_blank","width=240,height=100,left="+(screen.availWidth-200)/2+",top="+(screen.availHeight-100)/2+",center=yes,toolbar=no,menubar=no");
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message); 
	}		
}
//add by syang 2009/11/19 导出页面业务要素
function amarExportTemplate(myname){
	try{
		window.showModalDialog(sPath+"GetDWTemplate.jsp?CompClientID="+sCompClientID+"&type=export&dw="+DZ[myname.substring(myname.length-1)][0][1]+"&rand="+randomNumber(),"_blank","width=240,height=100,left="+(screen.availWidth-200)/2+",top="+(screen.availHeight-100)/2+",center=yes,toolbar=no,menubar=no");
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message); 
	}		
}

function amarPrint(myname){
	try{
		window.showModalDialog(sPath+"GetDWDataAll.jsp?CompClientID="+sCompClientID+"&type=print&dw="+DZ[myname.substring(myname.length-1)][0][1]+"&rand="+randomNumber(),"_blank","width=240,height=100,left="+(screen.availWidth-200)/2+",top="+(screen.availHeight-100)/2+",center=yes,toolbar=no,menubar=no");
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message); 
	}
}

function checkIsNotEmpty(str){
    if(str.trim() == "")
        return false;
    else
        return true;
}

//add by hxd in 2008/04/10
function mydokey_old(myname){
	try{
		if( window.frames[myname].event.keyCode==113 || 
			(window.frames[myname].event.ctrlKey && window.frames[myname].event.keyCode==114) ) 
		{
			if(window.frames[myname].document.getElementById('div_myd')==null){
				var sHTML = "<div id='div_myd' style='position:absolute;z-index:9999;filter:alpha(opacity=25);background-color:black;visibility:visible'><table width=100% height=100% border=1><tr valign=middle align=center><td valign=middle align=center><table width=300 height=150 border=1 bordercolor='#000000' style='border-collapse:collapse;background-color:#FFFFFF' ><tr height=30><td valign=middle align=center style='font:9pt;font-family:黑宋体;background-color:#0000FF;color:white' height=25>系统信息</td></tr><tr><td valign=middle align=center style='font:9pt;font-family:黑宋体;background-color:#FFFFFF;color:red;bold:true' >正在从服务器获取数据,请稍候...</td></tr><tr height=30><td valign=middle align=center style='font:9pt;font-family:黑宋体;background-color:white;color:black' ><a href='javascript:;' onClick='myhide(\""+myname+"\")' style='font:9pt;font-family:黑宋体;color:black' >点这里取消这次操作</a></td></tr></table></td></tr></table><iframe name='mydwexportall'></iframe></div>";
				document.body.insertAdjacentHTML('afterBegin',sHTML);
			}
			myshow(myname);
			window.open(sPath+'GetDWDataAllExReport.jsp?dw='+DZ[myname.substring(myname.length-1)][0][1]+'&rand='+randomNumber(),'mydwexportall','width=240,height=100,left='+(screen.availWidth-200)/2+',top='+(screen.availHeight-100)/2+',center=yes,toolbar=no,menubar=no');
			return true;	
		}
	}catch(e){
		alert(e.name+' '+e.number+' :'+e.message); 
	}

	return false;	
}

//add by hxd in 2008/04/10
function amarExportNew(myname){
	if(window.frames[myname].document.getElementById('div_myd')==null){
		var sHTML = "<div id='div_myd' style='position:absolute;z-index:9999;filter:alpha(opacity=25);background-color:black;visibility:visible'>"+
			"<table width=100% height=100% border=1><tr valign=middle align=center>"+
			"<td valign=middle align=center>"+
			"<table width=300 height=150 border=1 bordercolor='#000000' style='border-collapse:collapse;background-color:#FFFFFF' >"+
			"<tr height=30><td valign=middle align=center style='font:9pt;font-family:黑宋体;background-color:#0000FF;color:white' height=25>系统信息</td></tr>"+
			"<tr><td valign=middle align=center style='font:9pt;font-family:黑宋体;background-color:#FFFFFF;color:red;bold:true' >正在从服务器获取数据,请稍候...</td></tr>"+
			"<tr height=30><td valign=middle align=center style='font:9pt;font-family:黑宋体;background-color:white;color:black' >"+
			"<a href='javascript:;' onClick='myhide(\""+myname+"\")' style='font:9pt;font-family:黑宋体;color:black' >点这里取消这次操作</a>"+
			"</td></tr></table></td></tr></table><iframe name='mydwexportall'></iframe></div>";
		document.body.insertAdjacentHTML('afterBegin',sHTML);
	}
	myshow(myname);
	window.open(sPath+"GetDWDataAllNew.jsp?CompClientID="+sCompClientID+"&type=export&dw="+DZ[myname.substring(myname.length-1)][0][1]+"&rand="+randomNumber(),'mydwexportall','');
}

//modify by hxd in 2008/04/10
function myHandleSpecialKey(e, myname,fordebug){
	try{
		var e = window.frames[myname].event || e;
		//F2 或 ctrl+F3
		if(e.keyCode==113 || ( e.ctrlKey && e.keyCode==114) ){
//			amarExport(myname); //amarExportNew(myname);	//amarPrint(myname);
			return true;
		}
		if(e.keyCode==119 && e.ctrlKey ){ 	 //CTRL+F8
			amarExportTemplate(myname);
			return true;
		}
		if(fordebug){
			if(e.altKey && e.keyCode == 49){ //alt+1
				AsDebug.toggleWindow();
				return true;
			}else if(e.altKey && e.keyCode == 50){ //alt+2
				if(typeof OverrideAlt2 == 'function') OverrideAlt2();
				else AsDebug.editDW();
				return true;
			}else if(e.altKey && e.keyCode == 51){ //alt+3
				AsDebug.reloadCacheAll();
				return true;
			}else if(e.keyCode == "27"){ //esc
				AsDebug.hideWindow();
				return true;
			}
		}
	}catch(e){
		alert(e.name+" "+e.number+" :"+e.message); 
		return true;	
	}		
	return false;		
}

//日期检查函数
function isASDate(value,separator){
	if(value==null||value.length<10) return false;
	var sItems = value.split(separator); // value.split("/");

	if (sItems.length!=3) return false;
	if (isNaN(sItems[0])) return false;
	if (isNaN(sItems[1])) return false;
	if (isNaN(sItems[2])) return false;
	//年份必须为4位，月份和日必须为2位
	if (sItems[0].length!=4) return false;
	if (sItems[1].length!=2) return false;
	if (sItems[2].length!=2) return false;

	if(parseInt(sItems[0],10) == 9999){
		if(parseInt(sItems[1],10) != 12 || parseInt(sItems[2],10) != 31){
			return false;
		}
	}
	if (parseInt(sItems[0],10)<1900 || (parseInt(sItems[0],10) != 9999 && parseInt(sItems[0],10)>2200)) return false;
	if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
	if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;

	if ((sItems[1]<=7) && ((sItems[1] % 2)==0) && (sItems[2]>=31)) return false;
	if ((sItems[1]>=8) && ((sItems[1] % 2)==1) && (sItems[2]>=31)) return false;
	//本年不是闰年
	if (!((sItems[0] % 4)==0) && (sItems[1]==2) && (sItems[2]==29)){
		if ((sItems[1]==2) && (sItems[2]==29))
			return false;
	}else{
		if ((sItems[1]==2) && (sItems[2]==30))
			return false;
	}
	return true;
}	

function drawHarbor(myobjname,myact,iDW,iRow_now){
	var dh_sss = new Array();
	var dh_jjj = 0;
	var tmpDocks = harbors[iDW][2];
	var docks = new Array();
	for(iDock=0;iDock<harbors[iDW][2].length;iDock++){
		//boat = getDWControlHtml(myobjname,myact,harbors[iDW][2][iDock][0]);
		boat = arrangeBoats(arrangements,harbors[iDW][2][iDock][0],myobjname,myact,iDW,harbors[iDW][2][iDock][2],harbors[iDW][2][iDock][4],harbors[iDW][2][iDock][5],harbors[iDW][2][iDock][6],harbors[iDW][2][iDock][7],iRow_now);
		docks[iDock] = new Array(harbors[iDW][2][iDock][0],boat);
	}
	//modify by hxd in 2005/07/08 for '
	//return macroReplace(docks,harbors[iDW][1][2],"${DOCK:","}",0,1);
	return macroReplace(docks,amarsoft2Real(harbors[iDW][1][2]),"${DOCK:","}",0,1);
}

/**自动排列输入项*/
function arrangeBoats(myarrangements,myDockID,myobjname,myact,iDW,width,totalColumns,defaultColspan,defaultColspanForLongType,defaultPosition,iRow_now){
	if(!bFreeFormMultiCol) defaultColspan = defaultColspanForLongType;
	var sss=new Array(),jjj=0;
	//modify in 2008/04/10 for bccb dw
	//sss[jjj++]="<table cellspacing=0 cellpadding=4 border=0 width='"+width+"'>"+"\r";
	
	sss[jjj++]="<table id='dztable' cellspacing=0 cellpadding=1 border=0 width='"+width+"'>"+"\r";
	var remainColumns = 0;
	
	//remainColumns = totalColumns;

	var colwidth;
	var a = parseInt(width.replace("%",""),10);
	
	if(a<=100){
		colwidth = (a/totalColumns);
		colwidth = colwidth +"%";
	}else{
		colwidth = a/totalColumns;	
	}
	 
	sss[jjj++]="<tr>";
	for(var j=0; j<totalColumns; j++){
		sss[jjj++]="<td width='"+colwidth+"'></td>";
	}
	sss[jjj++]="</tr>";
	
	for(var j=0; j<myarrangements[iDW].length; j++){
		if(DZ[iDW][1][j][2]==0) continue;
		//取得colspan
		if(myarrangements[iDW][j][1]!=myDockID) continue;
		temp=myarrangements[iDW][j][2];
		if(temp==""){
			if(DZ[iDW][1][j][11]==3)
				colspan = defaultColspanForLongType;
			else if(DZ[iDW][1][j][10].indexOf("width:")>=0)
				colspan = defaultColspanForLongType;
			else if(DZ[iDW][1][j][17].length>=6 && DZ[iDW][1][j][17].substring(DZ[iDW][1][j][17].length-1)!=">")
				colspan = defaultColspanForLongType;
			else
				colspan = defaultColspan;
		}else{
			colspan = temp;
		}

		//取得position
		temp=myarrangements[iDW][j][3];
		if(temp==""){
			position = defaultPosition;
		}else{
			position = temp;
		}

		//显示<tr>
		if ((position=="NEWROW")||(position=="FULLROW")||(colspan > remainColumns)){
			if (remainColumns > 0){
				sss[jjj++]="<td colspan='"+remainColumns+"' "+hmFFBlankTD+">&nbsp;</td>"+"\r";
			}
			remainColumns = totalColumns;
			var sTrBGClass = "info_tr_bg";
			if(dzRowIndex%2==1)sTrBGClass = "info_tr_bg2";
			if(j>0)
				sss[jjj++]="</tr>";
			sss[jjj++]="<tr class='"+sTrBGClass+"'>";
			dzRowIndex++;
		}
		
		//显示内容
		sss[jjj++]=drawInputControl(myarrangements,harbors,defaultColspan,defaultColspanForLongType,myobjname,myact,iDW,j,iRow_now);		
		remainColumns = remainColumns -colspan;

		//显示</tr>
		if (position=="FULLROW" || j==(myarrangements[iDW].length-1)){
			if (remainColumns > 0){
				sss[jjj++]="<td colspan='"+remainColumns+"'  "+hmFFBlankTD+" >&nbsp;</td></tr>"+"\r";
			}
			remainColumns=0;
		}
	}
	
	sss[jjj++]="</table>";
	
	return(sss.join(''));
		
}
//modify by xdzhu in 2013/04/02
//change style for adding default style
function _getStyle(DZ10, style){
	if(DZ10.indexOf("style=\"") < 0) return "style=\""+style+"\"";
	else return DZ10.replace("style=\"", "style=\""+style+";");
}
function resetColNameForValidation(colName,inputName){
	colName = colName.toUpperCase();
	if(_user_validator==undefined || _user_validator.length!=2)return;
	//alert(colName+":" + _user_validator[0].rules[colName]);
	if(_user_validator[0].rules[colName]!=undefined){
		_user_validator[1].rules[inputName] = _user_validator[0].rules[colName];
		_user_validator[1].messages[inputName] = _user_validator[0].messages[colName];
	}
	
	
}
/**显示一个控件*/
function drawInputControl(myarrangement,myharbors,defaultColspan,defaultColspanForLongType,myobjname,myact,iDW,iCol,iRow_now){
	sColspan = myarrangement[iDW][iCol][2];
	//var iColspan=12;
	if(sColspan==""){
		if(DZ[iDW][1][iCol][11]==3){
			iColspan = defaultColspanForLongType;
		}else if(DZ[iDW][1][iCol][10].indexOf("width:")>=0){
			iColspan = defaultColspanForLongType;
		}else if(DZ[iDW][1][iCol][17].length>=6 && DZ[iDW][1][iCol][17].substring(DZ[iDW][1][iCol][17].length-1)!=">"){
			//unit有中文并且过长
			iColspan = defaultColspanForLongType;
		}else{
			iColspan = defaultColspan;
		}
	}else{
		iColspan = parseInt(sColspan,10);
	}
	var colspan=iColspan;

	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	
	var mysss;
	var sss=new Array(),jjj=0;
	
	//modify by hxd in 2008/04/10,2007/12/17 for citibank
	//var myS=new Array("","readonly","disabled","readonly"); 
	var myS=new Array("","readonly","disabled","readonly","readonly","disabled",
						"disabled","disabled","readonly","readonly","readonly",
						"readonly","readonly","readonly","readonly","readonly",
						"readonly","readonly","readonly","readonly","readonly"); 	
	
	var myR=DZ[myi][0][2]; 
	var myFR,myFS; 
	var myAlign=new Array(""," align=left "," align=center "," align=right ");
	var myAlign2=new Array("","left","center","right");
		
	pagesize[myi]=1;  
	var myShowSelect = "",myShowSelectVisible="";
	var myevent_num=""; 
	var j=iRow_now;
	var myi = iDW;
	var i=iCol;

	mysss = DZ[myi][1][i][17];
	//add in 2011/05/20 for readonly button click modify
	//if(myR==1 || (myR==0&&(DZ[myi][1][i][3]==1)) )
	if(myR==1)
		mysss = mysss.replace(/[oO][nN][cC][lL][iI][cC][kK]/g,"onClick2");
	
	var mysMandatorySignal="";
	if(my_notnull[myi][i]==1) mysMandatorySignal=sMandatorySignal;	
	
	try {    
	if(DZ[myi][1][i][11]==3){
		var sTextareaShowLimit="";

		//如果设置了字数限制，并且指定过要显示“(限个汉字)”
		if(bTextareaShowLimit && DZ[myi][1][i][7]>0) sTextareaShowLimit = "(限" + (DZ[myi][1][i][7]/2) +"个汉字)";
		sss[jjj++]=("<td  id=TDR"+j+"F"+i+" "+hmFFTextAreaCaptionTD+" >"+DZ[myi][1][i][0]+ sTextareaShowLimit +mysMandatorySignal+" </td>");
	} else    
		sss[jjj++]=("<td  id=TDR"+j+"F"+i+" "+hmFFCaptionTD+" >"+DZ[myi][1][i][0]+mysMandatorySignal+"</td>");
	} catch(e) { var a=1; }   
	myFS = DZ[myi][1][i][11];  
	sValue = amarMoney(DZ[myi][2][my_index[myi][j]][i],DZ[myi][1][i][12]); 	
	if(myR==1 || (myR==0&&(DZ[myi][1][i][3]==1)) )
		str2=myS[myFS];    
	else
		str2=" ";
	
	if(DZ[myi][1][i][7]==0) str3=" ";			
	else                    str3=" maxlength="+DZ[myi][1][i][7];
	myevent_num=""; 
	
	//modify in 2008/04/10 for bccb number control
	//if( DZ[myi][1][i][12]==2 || DZ[myi][1][i][12]==5)	
	if( DZ[myi][1][i][12]==2 || DZ[myi][1][i][12]==5 || DZ[myi][1][i][12]>10)	
		myevent_num="  onblur=parent.myNumberBL(this) onfocus=parent.myNumberFC(this) onkeypress=parent.myNumberKP(this,event) onkeydown=parent.myNumberKD(this,event) onkeyup=parent.myNumberKU(this,event) onbeforepaste=parent.myNumberBFP(this) "; 
	else {
		myevent_num=" "; 
		//add in 2007/05/22,2008/04/10
		if(DZ[myi][1][i][7]>0)
			myevent_num = " onkeydown=parent.textareaMaxByIndex("+myi+","+j+","+i+") onkeyup=parent.textareaMaxByIndex("+myi+","+j+","+i+") ";
	}

	str3 = str3+myevent_num+ " onblur=parent.trimField(this) ";
	if(DZ[myi][1][i][12]==3 && DZ[myi][1][i][3]==0  )	
		myCale = " "+hmDate+" onclick='javascript:parent.myShowCalendar(\""+myobj.name+"\",\"R"+j+"F"+i+"\",\"dataTable\","+((j-curpage[myi]*pagesize[myi]+1)*(f_c[myi]+1)+i+1)+");'> ";
	else				
		myCale = " ";
	//add in 2011/05/31 for readonly button click modify
	if(myR==1)
		myCale = myCale.replace(/[oO][nN][cC][lL][iI][cC][kK]/g,"onClick2");
	
	if(DZ[myi][1][i][12]==3 && DZ[myi][1][i][3]==0  )	
		myCale2 = sDateReadonlyColor;
	else				
		myCale2 = " ";
	if(myFS==1) {	//input
		if(DZ[myi][1][i][8]==1) 
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' id=R"+j+"F"+i+" name=R"+j+"F"+i+"  "+str3+" >"+mysss+myCale+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
		else
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+_getStyle(DZ[myi][1][i][10], "text-align:"+myAlign2[DZ[myi][1][i][8]]+";")+" type=text " + myCale2 + " value='"+sValue+"' id=R"+j+"F"+i+" name=R"+j+"F"+i+"  "+str3+">"+myCale+mysss+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
	}
	//if(myFS==7) {	//password
	//	if(DZ[myi][1][i][8]==1) 
	//		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input type=password "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' name=R"+j+"F"+i+"  "+str3+" >"+mysss+myCale+"</td>";
	//	else
	//		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input type=password "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' name=R"+j+"F"+i+"  "+str3+" style={text-align:"+myAlign2[DZ[myi][1][i][8]]+";}>"+myCale+mysss+"</td>";
	//}	
	if(myFS==3){ 	//textarea
		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><textarea "+hmFFContentArea+" onkeydown=parent.textareaMaxByIndex("+myi+","+j+","+i+") onkeyup=parent.textareaMaxByIndex("+myi+","+j+","+i+") type=textfield "+str2+DZ[myi][1][i][10]+" id=R"+j+"F"+i+" name=R"+j+"F"+i+" >"+sValue+"</textarea>"+mysss+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";					
	}	
	if(myFS==2){ 	//select
		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><select "+hmFFContentSelect+" "+str2+DZ[myi][1][i][10]+" id=R"+j+"F"+i+" name=R"+j+"F"+i+" value='"+sValue+"' onchange='parent.mE(event,\""+myobj.name+"\");parent.myHandleSelectChangeByIndex("+myi+","+j+","+i+");' >";
		if(bShowSelectButton)
			myShowSelectVisible="display:visible";
		else
			myShowSelectVisible="display:none";
		myShowSelect = " "+ hmSelectButton +" name=btnR"+j+"F"+i+"  style='"+myShowSelectVisible+"' "+str2+" onclick='javascript:parent.myShowSelect(\""+myobj.name+"\",\"R"+j+"F"+i+"\","+j+","+i+ ");' > ";
		for(k=0;k<DZ[myi][1][i][20].length/2;k++){
			//if(DZ[myi][1][i][20][2*k]==DZ[myi][2][my_index[myi][j]][i])
			//转义，防止一些特殊字符的展示问题
			if(DZ[myi][1][i][20][2*k]==amarsoft2Html(DZ[myi][2][my_index[myi][j]][i]))
				sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"' selected>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
			else
				sss[jjj++] = "<option value='"+DZ[myi][1][i][20][2*k]+"'>"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+"</option>";
		}
		sss[jjj++] =  "</select>"+myShowSelect+mysss+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
	}

	if(myFS==5||myFS==6){ //radio
		var mybr = "<br>";
		if(myFS==5) mybr="";
		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" >";
		
		for(var k=0;k<DZ[myi][1][i][20].length/2;k++){
			//modify by hxd in 2008/04/10,2007/12/17 for citibank
			//if(DZ[myi][1][i][20][2*k+1]=='') DZ[myi][1][i][20][2*k+1]='(不选择)';
			if(DZ[myi][1][i][20][2*k+1]=='') continue;

			//注意：Radio放在后面，因为name.indexOf("R")有问题
			if(DZ[myi][1][i][20][2*k]==amarsoft2Html(DZ[myi][2][my_index[myi][j]][i]))
				sss[jjj++] = "<input "+hmGdTdContentRadio+str2+" "+DZ[myi][1][i][10]+" type=radio name=R"+j+"F"+i+"_Radio value='"+DZ[myi][1][i][20][2*k]+"' checked " +
						"onClick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr;
			else
				sss[jjj++] = "<input "+hmGdTdContentRadio+str2+" "+DZ[myi][1][i][10]+" type=radio name=R"+j+"F"+i+"_Radio value='"+DZ[myi][1][i][20][2*k]+"' " +
						"onClick=\"document.all('R"+j+"F"+i+"').value=this.value;parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;")+mybr;
		}
		sss[jjj++] = "<input type=hidden id=R"+j+"F"+i+" name=R"+j+"F"+i+" value='"+sValue+"'  >";
		sss[jjj++] =  mysss+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
	}
	
	if(myFS==7){ //checkbox
		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" >";
		
		for(k=0;k<DZ[myi][1][i][20].length/2;k++){
			if(DZ[myi][1][i][20][2*k+1]=='') continue;
			
			if(DZ[myi][2][my_index[myi][j]][i]=='' || 
					!ArrayOfcontains(DZ[myi][2][my_index[myi][j]][i].split(','),DZ[myi][1][i][20][2*k]))
				sss[jjj++] = "<input "+hmGdTdContentRadio+str2+" "+DZ[myi][1][i][10]+" type=checkbox name=R"+j+"F"+i+"_Checkbox value='"+DZ[myi][1][i][20][2*k]+"' " +
						"onClick=\"document.all('R"+j+"F"+i+"').value = parent.getCheckboxValue("+j+","+i+",'"+myobjname+"');parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;");
			else
				sss[jjj++] = "<input "+hmGdTdContentRadio+str2+" "+DZ[myi][1][i][10]+" type=checkbox name=R"+j+"F"+i+"_Checkbox value='"+DZ[myi][1][i][20][2*k]+"' checked " +
						"onClick=\"document.all('R"+j+"F"+i+"').value = parent.getCheckboxValue("+j+","+i+",'"+myobjname+"');parent.hC(document.all('R"+j+"F"+i+"'),'"+myobjname+"');\">"+DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;");
		}
		sss[jjj++] = "<input type=hidden id=R"+j+"F"+i+" name=R"+j+"F"+i+" value='"+sValue+"'  >";
		sss[jjj++] =  mysss+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
	}
	
	//add by hxd in 2005/11/29
	if(myFS==4){ //treeview(只读框与一个...按钮)(以及一个隐藏的id)
		var sValue_C = "";
		sValue = DZ[myi][2][my_index[myi][j]][i];
		for(k=0;k<DZ[myi][1][i][20].length/2;k++){
			if(DZ[myi][1][i][20][2*k]==sValue)
				sValue_C = DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;");
		}

		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue_C+"' name=R"+j+"F"+i+"_C  "+str3+" style={text-align:"+myAlign2[DZ[myi][1][i][8]]+";} readonly >"+myCale+mysss+"<input type=hidden id=R"+j+"F"+i+" name=R"+j+"F"+i+" value='"+sValue+"' ><input class=inputdate type=button value=\"...\" onClick=parent.popSelectWin('"+DZ[myi][1][i][21]+"',"+myi+","+j+","+i+")>"+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" +"</td>";
	}

	if(myFS==8) {	//PopSelect
		if(DZ[myi][1][i][8]==1) 
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+DZ[myi][1][i][10]+" type=text " + myCale2 + " value='"+sValue+"' id=R"+j+"F"+i+" name=R"+j+"F"+i+"  "+str3+" >"+mysss+myCale+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
		else
			sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" ><input "+hmFFContentInput+" "+str2+_getStyle(DZ[myi][1][i][10], "text-align:"+myAlign2[DZ[myi][1][i][8]]+";")+" type=text " + myCale2 + " value='"+sValue+"' id=R"+j+"F"+i+" name=R"+j+"F"+i+"  "+str3+" >"+myCale+mysss+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
	}
	
	//add by hxd in 2008/04/10,2007/12/17 for citibank
	if(myFS==9){ 	//flat_dropdown
		if(bShowSelectButton)
			myShowSelectVisible="display:visible";
		else
			myShowSelectVisible="display:none";
		myShowSelect = " "+ hmSelectButton +" name=btnR"+j+"F"+i+"  style='"+myShowSelectVisible+"' "+str2+" onclick='javascript:parent.myShowSelect(\""+myobj.name+"\",\"R"+j+"F"+i+"\","+j+","+i+ ");' > ";

		sss[jjj++] = "<td colspan='"+(colspan-1)+"'  "+hmFFContentTD +" >"+
			"<input "+hmFFContentInput+" "+str2+_getStyle(DZ[myi][1][i][10], "overflow-x: visible; width: 60px;")+" type=text " + myCale2 + 
			" value='"+sValue+"' id=R"+j+"F"+i+" name=R"+j+"F"+i+"  "+str3+
			" onblur='parent.mySelectBL(this,"+myi+","+j+","+i+")' >"+
			" <span id=spanR"+j+"F"+i+">"+myGetDDValue(myi,i,sValue)+"</span> "+
			myShowSelect+mysss+ "<label id=R"+j+"F"+i+"_label for=R"+j+"F"+i+" class='' >" + "</td>";
	}
	resetColNameForValidation(DZ[myi][1][i][15],"R"+j+"F"+i);
	return sss.join("");
}

function ArrayOfcontains(aArray,element){
	for(var i=0;i<aArray.length;i++){
		if(aArray[i]==element) return true;
	}
	return false;
}

function getCheckboxValue(iRow,iCol,objname){
	var tempS = '';
	var boxs = window.frames[objname].document.forms[0].elements["R"+iRow+"F"+iCol+"_Checkbox"];
	for(var i=0;i<boxs.length;i++) {
		if(!boxs[i].checked) continue;
		if(tempS=='')
			tempS = tempS.concat(boxs[i].value);
		else if(tempS.length>0)
			tempS = tempS.concat(',',boxs[i].value);
	}
	return tempS;
}

//add by hxd in 2008/04/10,2007/12/17 for citibank 
//modify by hxd in 2008/03/04 for only one-radio 
//单选。。。。。（radio button)。。。。。去掉未选择 
function emptyRadio(iDW,iRow,sCol) { 
	var iCol=getColIndex(iDW,sCol); 
	
	if(typeof(window.frames["myiframe"+iDW].document.all['R'+iRow+'F'+iCol+"_Radio"].length)=="undefined") 
		window.frames["myiframe"+iDW].document.all['R'+iRow+'F'+iCol+"_Radio"].checked=false; 
	else { 
		var ii=0; 
		for(ii=0;ii<window.frames["myiframe"+iDW].document.all['R'+iRow+'F'+iCol+"_Radio"].length;ii++){ 
			window.frames["myiframe"+iDW].document.all['R'+iRow+'F'+iCol+"_Radio"][ii].checked = false; 
		} 
	} 
	setItemValue(iDW,iRow,sCol,""); 
} 

//add by hxd in 2008/04/10,2007/12/17 for citibank
function myGetDDValue(iDW,iField,sValue){
	var myi=iDW;
	var i=iField;
	var k=0;
	var bFind = false;
	for(k=0;k<DZ[myi][1][i][20].length/2;k++){
		if(DZ[myi][1][i][20][2*k]==sValue){
			bFind = true;
			break;
		}			
	}
	if(!bFind)
		return "";
	else
		return DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;");
}

//add by hxd in 2008/04/10,2007/12/17 for citibank
//下拉选择。。。。。。。。无下拉框，但要检验合法性。
function mySelectBL(myobj,iDW,iRow,iField){
	var myi=iDW;
	var i=iField;
	var k=0;
	//try {
	var bFind = false;
	for(k=0;k<DZ[myi][1][i][20].length/2;k++){
		if(DZ[myi][1][i][20][2*k]==myobj.value){
			bFind = true;
			break;
		}			
	}
	if(!bFind){
		alert("输入项["+DZ[myi][1][i][0]+"]错误，请重新输入!");
		if(my_notnull[myi][i]==1)//如果必须输入的，保持焦点
			myobj.select(); 
		else //否则清空内容
		{
			setItemValueByIndex(iDW,iRow,iField,"");
			myobj.value = "";
			window.frames["myiframe"+myi].document.getElementById("spanR"+iRow+"F"+iField).innerHTML = "";
		}
	}else{
		//在后面显示该代码对应的内容
		window.frames["myiframe"+myi].document.getElementById("spanR"+iRow+"F"+iField).innerHTML = DZ[myi][1][i][20][2*k+1].replace(/ /g, "&nbsp;") ;
	}
	//}	
	//catch(E){var a=1;}
}

//add by hxd in 2005/11/29
function popSelectWin(sArgPopSource,iArgDW,iArgRow,iArgCol){
	var sPopSource = sArgPopSource;
	var vPop = sPopSource.split(":");
	
	if(vPop[0]!="Code") return;
	var myCode = vPop[1];
	
	//sObjectType：对象类型
	//iArgDW: 第几个DW，默认为0
	//iArgRow: 第几行，默认为0
	var sObjectType,sPataString,sStyle;

	sObjectType = "SelectCode";
	sPataString = "CodeNo"+","+myCode;
	sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";

	var iDW = iArgDW;
	if(iDW == null) iDW=0;
	var iRow = iArgRow;
	if(iRow == null) iRow=0;
	var iCol = iArgCol;
	if(iCol == null) iCol=0;
	
	var sObjectNoString = selectObjectValue(sObjectType,sPataString,sStyle);
		
	if(typeof(sObjectNoString)=="undefined" ){
		return;	
	}else if(sObjectNoString=="_CANCEL_"  ){
		return;
	}else if(sObjectNoString=="_CLEAR_"){
		setItemValueByIndex(iDW,iRow,iCol,"");

		var objp = window.frames["myiframe"+iDW];
		var itemname = "R"+iRow+"F"+iCol+"_C";
		objp.document.forms[0].elements[itemname].value="";
	}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined"){
		var sObjectNos = sObjectNoString.split("@");
		
		setItemValueByIndex(iDW,iRow,iCol,sObjectNos[0]);

		var objp = window.frames["myiframe"+iDW];
		var itemname = "R"+iRow+"F"+iCol+"_C";
		objp.document.forms[0].elements[itemname].value=sObjectNos[1];
	}else{
		//alert("选取对象编号失败！对象类型："+sObjectType);
		return;
	}

	return sObjectNoString;
}

function MR2_head(myobjname,myact){
	var myi=myobjname.substring(myobjname.length-1);
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<HEAD>");
	sss[jjj++]=(sContentType);
	if(DZ[myi][0][0]==1){
		sss[jjj++]=("<LINK href='"+sPath+"style_dw.css' rel=stylesheet>");
		sss[jjj++]=("<LINK href='"+sSkinPath+"/css/style_dw.css' rel=stylesheet>");
	}else{
		sss[jjj++]=("<LINK href='"+sPath+"style_ff.css' rel=stylesheet>");
		sss[jjj++]=("<LINK href='"+sSkinPath+"/css/style_ff.css' rel=stylesheet>");
	}
	sss[jjj++]=("<LINK href='"+sPath+"../style.css' rel=stylesheet>");
	sss[jjj++]=("</HEAD>");
	
	return sss.join('');
}

function MR2_body(myobjname,myact){
	_user_validator[1] = new Object();
	_user_validator[1].rules = new Object();
	_user_validator[1].messages = new Object();
	
	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	var curPP=0;
	if(myact==5) curPP=0;//myobj.document.forms[0].elements["txtJump"].value;
	
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<BODY oncontextmenu='self.event.returnValue=false' onmousedown='parent.mE(event,\""+myobj.name+"\");' onKeyDown='parent.kD(event,\""+myobj.name+"\")' onKeyUp='parent.kU(event,\""+myobj.name+"\")'>");
	sss[jjj++]=("<div style={position:absolute;width:100%;height:100;overflow: auto;}>");
	if(bNeedCA) 
		sss[jjj++]=(" <object id=doit style='display:none' classid='CLSID:8BE89452-A144-49BC-9643-A3D436D83241' border=0 width=0 height=0></object>  ");
	sss[jjj++]=("<form id='form1' name='form1' class='ffform'>");

	switch(myact){
		case 1:
			curpage[myi]=0;
			break;
		case 2:
			if(curpage[myi]>0) curpage[myi]--;
			break;
		case 3:
			if(curpage[myi]<rr_c[myi]-1) curpage[myi]++;
			break;
		case 4:
			curpage[myi]=rr_c[myi]-1;
			break;				
		case 5:
			curpage[myi]=curPP-1;
			if(curpage[myi]<0) curpage[myi]=0;
			if(curpage[myi]>rr_c[myi]-1) curpage[myi]=rr_c[myi]-1;			
			break;				
	};
		
	sss[jjj++]=("<span style='font-size: 9pt;display:none'>");
	sss[jjj++]=("<a href='javascript:parent.MR2(\""+myobjname+"\",1)'>首笔</a> <a href='javascript:parent.MR2(\""+myobjname+"\",2)'>前一笔</a> <a href='javascript:parent.MR2(\""+myobjname+"\",3)'>后一笔</a> <a href='javascript:parent.MR2(\""+myobjname+"\",4)'>尾笔</a> <br>");
	sss[jjj++]=("共有&nbsp;"+rr_c[myi]+"&nbsp;条记录，当前为第&nbsp;"+(curpage[myi]+1)+"&nbsp;条记录<br>");
	sss[jjj++]=("&nbsp;&nbsp;跳至&nbsp;<input type=text name=txtJump style='FONT-SIZE: 9pt;border-style:groove;text-align:center;width:30pt;height:13pt' size=1 onkeydown='javascript:parent.MRK2(\""+myobjname+"\",5)'>&nbsp;笔");
	sss[jjj++]=("</span>");

	pagesize[myi]=1;  
	
	if(rr_c[myi]>0){
		for(var j=curpage[myi]*pagesize[myi];j<=curpage[myi]*pagesize[myi];j++){
			iCurRow = j; 
	     	
			//modify by hxd in 2005/07/08 for '
			//sss[jjj++] = amarsoft2Real(drawHarbor(myobjname,myact,myi,j));
			sss[jjj++] = amarsoft2Html(drawHarbor(myobjname,myact,myi,j));
		}
	}

	sss[jjj++]=("</form>");
	sss[jjj++]=("</div>");
	sss[jjj++]=("</BODY>");
	return sss.join('');			
}

function MR2(myobjname,myact){
	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  

	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);
	myLastCB(cur_frame,cur_sel_item[cur_frame.substring(cur_frame.length-1)]);
	cur_sel_rec[myi]=-1;		
	cur_sel_item[myi]="";		

	myobj.document.write("");
	myobj.document.close();
	
	var sss=new Array(),jjj=0;
	sss[jjj++]=("<HTML>");
	sss[jjj++]=MR2_head(myobjname,myact);
	sss[jjj++]=MR2_body(myobjname,myact);
	sss[jjj++]=("</HTML>");

	//modify by hxd in 2005/07/08 for '
	//myobj.document.writeln(amarsoft2Html(sss.join('')));		
	myobj.document.writeln((sss.join('')));		
	myobj.document.close();		
		
	window.status="Ready";  
	window.status=myoldstatus;  
	myAfterLoadFreeForm(myi);
}

function MR2_add(myobjname,myact){
	var myoldstatus = window.status;  
	window.status="正在准备数据，请稍候....";  
	var myobj=window.frames[myobjname];
	var myi=myobj.name.substring(myobj.name.length-1);

	if(navigator.appName=="Netscape")
		myobj.document.body.outerHTML = MR2_body(myobjname,myact);
	else{
		myobj.document.write("");
		myobj.document.close();
		
		var sss=new Array(),jjj=0;
		sss[jjj++]=("<HTML>");
		sss[jjj++]=MR2_head(myobjname,myact);
		sss[jjj++]=MR2_body(myobjname,myact);
		sss[jjj++]=("</HTML>");

		//modify by hxd in 2005/07/08 for '
		//myobj.document.writeln(amarsoft2Html(sss.join('')));		
		myobj.document.writeln((sss.join('')));		
		myobj.document.close();		
	}
			
	window.status="Ready";  
	window.status=myoldstatus;  
	myAfterLoadFreeForm(myi);
}

//从my_load_s 和my_load_show_s 提取出公共部分
function getDWDataSort(my_sortorder,sort_which,myobjname,need_change){
	if(my_sortorder==1)   
		my_sortorder=0;  //(升)
	else if(my_sortorder==0)  
		my_sortorder=1;  //(降)
	else if(my_sortorder==2)  
		my_sortorder=0;
	
	var myi=myobjname.substring(myobjname.length-1);
	
	var myoldstatus = window.status;
	window.status="正在从服务器获得数据，请稍候....";
	/*self.showModalDialog(sPath+"GetDWDataSort.jsp?dw="+DZ[myi][0][1]+"&pg=0&"+
			"sortfield="+DZ[myi][1][sort_which][15]+"&sortorder="+my_sortorder+"&rand="+randomNumber(),
			window.self,
			"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");*/
	var sPageURL = sPath+"GetDWDataSort.jsp?dw="+DZ[myi][0][1]+"&pg=0&sortfield="+DZ[myi][1][sort_which][15]+"&sortorder="+my_sortorder;
	var script = $.ajax({url: sPageURL,async: false}).responseText.trim();
	script = replaceAll(replaceAll(script, "<script type=\"text/javascript\">", ""), "</script>", "");
	eval(script);
	
	window.status=myoldstatus;
	  
	init(false);
	needReComputeIndex[myi]=0;
}

//add by hxd in 2008/04/10 for sort
function my_load_s(my_sortorder,sort_which,myobjname,need_change){
	var my_sortorder_old = my_sortorder;		
	getDWDataSort(my_sortorder,sort_which,myobjname,need_change);
	
	my_load(my_sortorder_old,sort_which,myobjname,need_change);	  //因为 my_load还会作sort转换
}
function my_toggle_n(obj){
	var group = obj.nextSibling;
	if(group.style.display == "none") group.style.display = "";
	else group.style.display = "none";
}

//add by hxd in 2008/04/10 for sort
function my_load_show_s(my_sortorder,sort_which,myobjname){
	var my_sortorder_old = my_sortorder;		
	getDWDataSort(my_sortorder,sort_which,myobjname,true);
	
	my_load_show(my_sortorder_old,sort_which,myobjname);
}

//add by hxd in 2008/04/10 for vI_all(check)
function check6789(iEditStyle,sValue){
	return true;
}

function amarValue(sMoney,iType){
	if (sMoney==null || typeof(sMoney)=='undefined') return "";
	//modify in 2008/04/10 for 几位小数
	//if(iType!=2 && iType!=5 )
	if(iType!=2 && iType!=5 && iType<=10)
		return sMoney;
	else{
		//modify in 2008/04/10 for 几位小数
		//if(iType==2)
		if(iType==2 || iType>10){
			if(isNaN(parseFloat(sMoney.replace(/,/g,"")))) return "";
			else return parseFloat(sMoney.replace(/,/g,""));
		}
		if(iType==5){
			if(isNaN(parseInt(sMoney.replace(/,/g,"")))) return "";
			else return parseInt(sMoney.replace(/,/g,""));
		}
	}
}

//将(金额)整数部分转换成三位一小逗的显示格式（当整数部分位数 <=11 时，小数精度   >=6位；整数位越少，小数精度越高）
function amarMoney(dMoney,iType)  //dMoney:需要转换的金额， iType:转换后的小数位数
{
    if (dMoney==null || (dMoney==""&&dMoney!=0) || typeof(dMoney)=='undefined') return "";
    if(parseInt(iType,10)!=2 && parseInt(iType,10)!=5 && parseInt(iType,10)<11 ) return dMoney;
    else{
        if(parseInt(iType,10)>10)  iType=parseInt(iType,10)-10;
        else if(parseInt(iType,10)==5)  iType=0;

        if(dMoney==""){
            if( ("amar"+dMoney)=="amar") return "";
            else dMoney=0.00;
        }
        else
        	dMoney = parseFloat(dMoney,10);
        if(isNaN(dMoney)) dMoney=0.00;
        
        //modified by btan 2011/02/14
        //处理特殊情况。当传入的金额为0，精度要求大于等于6时，精度修正后会以科学技术法表示金额，导致转换出错。
		if(dMoney == 0){
			var sReturnValue = "0.";
			for(var p=0; p<iType; p++){
				sReturnValue += "0";
			}
			return sReturnValue;  //比如 0.000000
		}
        
        var sMoney="",i,sTemp="",itemCount,iLength,digit=3,sign="",s1="",s2="",sResultSet="";
        
        //显示修正。修正原理：对需求的小数位数(iType)的下一位数进行四舍五入运算
        var myFraction = 0.5;  //修正基数 （只能是小数）
			for(var ij=1;ij<=iType;ij++)
				myFraction *= 0.1;

        if(dMoney < 0){
            sign = "-";  //符号位
            dMoney = dMoney - myFraction;  //修正最后一位
            sMoney = dMoney.toString().substring(1); //截去符号位
        }else{
        	dMoney = dMoney + myFraction;
        	sMoney = dMoney.toString();
        }
        
        //分出整数部分和小数部分
        s1 = sMoney.substring(0, sMoney.indexOf("."));  //整数部分
        s2 = sMoney.substring(sMoney.indexOf(".")+1, sMoney.indexOf(".")+1+iType);  //小数部分
       
        //三位一小逗
        iLength = s1.length;  //整数部分的长度（位数）
        itemCount = parseInt((iLength-1)/digit, 10) ;    //计算整数部分的显示段数    
        for (i=0;i<itemCount;i++){
            sTemp = ","+s1.substring(iLength-digit*(i+1),iLength-digit*i)+sTemp;
        }
        
        //将整数部分整理成最终显示模式（符号位+没有截取出来的最高几位+其余整数位）
        sResultSet = sign+s1.substring(0,iLength-digit*i)+sTemp;       
       
        //加上小数部分
        if(iType!=0)    sResultSet = sResultSet + "." + s2;    
       
        return sResultSet;
    }
}

//add by hxd in 2008/04/10
function showMess(mess){
	ShowMessage(mess,true,true);
	setTimeout(hideMessage,500);
}
function waitMess(mess){
	ShowMessage(mess,true,false);
	setTimeout(hideMessage,1000*10);//max时间:等待10s
}
function hideMessage(){
	try{
		var msgDiv = document.getElementById("msgDiv");
		msgDiv.removeChild(document.getElementById("msgTxt"));
		msgDiv.removeChild(document.getElementById("msgTitle"));
		document.body.removeChild(msgDiv);
		document.body.removeChild(document.getElementById("bgDiv"));
		//document.body.removeChild(document.getElementById("msgIfm"));
	}catch(e){ }
}
function ShowMessage(str,showGb,clickHide){
	
	//可以通过对象检查来判断窗口是否已打开
	//采取替换或者取消的操作来避免重复打开
	//提示文字尽量别超过2行,因为背景iframe动态高度不知道怎么弄。
	
 	if(document.getElementById("msgDiv"))
		return ;	 	

	var msgw=300;//信息提示窗口的宽度
	var msgh=125;//信息提示窗口的高度
	var scrollTop = document.body.scrollTop+document.body.clientHeight*0.4+"px";
	
	//**绘制背景层**/	
	var bgObj=document.createElement("div");
	bgObj.setAttribute('id','bgDiv');
	bgObj.className = "message_bg";

	//背景层动作 点击关闭
	if(clickHide)
		bgObj.onclick=hideMessage;
	if(showGb)
		document.body.appendChild(bgObj);
	
	//**绘制信息层**/
	var msgObj=document.createElement("div");
	msgObj.setAttribute("id","msgDiv");
	msgObj.setAttribute("align","center");
	msgObj.className = "message_div";
	
	msgObj.style.top= scrollTop; //"40%";
	msgObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
	msgObj.style.width = msgw + "px";
	msgObj.style.height =msgh + "px";
	
	document.body.appendChild(msgObj);
	
	//**绘制标题层**/ 点击关闭
	var title=document.createElement("h4");
	title.setAttribute("id","msgTitle");
	title.setAttribute("align","left");
	title.className = "message_title";
	
	title.innerHTML="系统处理中...";
	if(clickHide){
		title.innerHTML="关闭";
		title.style.cursor="pointer";			
		title.onclick = hideMessage;
	}	
	
	document.getElementById("msgDiv").appendChild(title);
	
	//**输出提示信息**/
	str = "<br>"+str.replace(/\n/g,"<br>");
	var txt=document.createElement("p");
	txt.style.margin="1em 0";
	txt.setAttribute("id","msgTxt");
	txt.innerHTML=str;
	document.getElementById("msgDiv").appendChild(txt);
}

function beforeInit(bSetPageSize){
	var i = 0, j = 0;
	for(i=0;i<DZ.length;i++) {
		my_notnull_temp[i] = new Array();
		for(j=0;j<f_c[i];j++)
			my_notnull_temp[i][j] = DZ[i][1][j][4];
	}
		
	return true;
}

function beforeInit_show(bSetPageSize){
	var i = 0, j = 0;
	for(i=0;i<DZ.length;i++) {
		my_notnull[i] = new Array();
		for(j=0;j<f_c[i];j++)
			my_notnull_temp[i][j] = DZ[i][1][j][4];
	}
		
	return true;
}

//增加trimField方法 
function trimField(myobj){
	myobj.value=myobj.value.replace(/(^[\s]*)|([\s]*$)/g, "");
}

function beforeMRK1(myobjname,myact,my_sortorder,sort_which){
	return true;
}

function beforeMR1(myobjname,myact,my_sortorder,sort_which,need_change){
	return true;
}

function beforeMRK2(myobjname,myact){
	return true;
}

function beforeMy_load(my_sortorder,sort_which,myobjname,need_change){
	return true;
}

function beforeMy_load_show_action(myobjname,myact,my_sortorder,sort_which){
	return true;
}

function beforeMy_load_show(my_sortorder,sort_which,myobjname){
	return true;
}

function beforeSR(lastRec,iRec,myname){
	return true;
}

function beforeCSS(iRec,myname){
	return true;
}

function beforeSR_show(lastRec,iRec,myname){
	return true;
}

function beforeMyLastCB(myframename,curItemName){
	return true;
}

function beforeHC(obj,objpname){
	return true;
}

function beforeVI(obj,objpname){
	return true;
}

function beforeAsAdd(objname){
	return true;
}

function beforeAsDel(objname){
	return true;
}

function beforeVIAll(objpname){
	return true;
}

function beforeAsSave(objname,afteraction,aftertarget,afterprop){
	if(!vI_all(objname))
		return false;
	else{
		ShowMessage("系统正在处理数据，请等待...",true,false);
		return true;
	}
}

function beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change){
	return true;
}

function before_my_load_show_action_s(myobjname,myact,my_sortorder,sort_which){
	return true;
}

function beforeMyLoadSave(my_sortorder,sort_which,myobjname){
	return true;
}

function beforeAsSaveResult(myobjname){
	return true;
}

function beforeIsModified(objname){
	return true;
}

function beforeCloseCheck(){
	return true;
}

function beforeSetPageSize(i,iSize){
	return true;
}

function setNoCheckRequired(iDw){
	SAVE_TMP=true;
	for(var i=0;i<f_c[iDw];i++) {
		//my_notnull_temp[iDw][i] = my_notnull[iDw][i];
		my_notnull[iDw][i] = 0;
	}
}

function setNeedCheckRequired(iDw){
	SAVE_TMP=false;
	for(var i=0;i<f_c[iDw];i++) 
		my_notnull[iDw][i] = DZ[iDw][1][i][4];
}

/*设置字段的标题*/	
function setItemCaption(iDW,iRow,iCol,sValue){
	try {  
		var mysMandatorySignal="";
		if(my_notnull[iDW][iCol]==1) mysMandatorySignal=sMandatorySignal;	
		
		var obj; 
		obj = window.frames["myiframe"+iDW].document.getElementById("TDR"+iRow+"F"+iCol);
		if(DZ[iDW][1][iCol][11]==3){ 
			var sTextareaShowLimit="";
			//如果设置了字数限制，并且指定过要显示“(限个汉字)”
			if(bTextareaShowLimit && DZ[iDW][1][iCol][7]>0) sTextareaShowLimit = "(限" + (DZ[iDW][1][iCol][7]/2) +"个汉字)";
			obj.innerHTML = sValue + sTextareaShowLimit +mysMandatorySignal;
		} else    
			obj.innerHTML = sValue + mysMandatorySignal;
	} catch(e) { var a=1; }   
} 

//add by syang 2009/11/06 设置指定单元是否必需录入
function setItemRequired(iDW,iRow,sItemName,bRequired){
	var iCol = getColIndex(iDW,sItemName);
	if(bRequired)
		my_notnull[iDW][iCol] = 1;
	else
		my_notnull[iDW][iCol] = 0;
	setItemCaption(iDW,iRow,iCol,DZ[iDW][1][iCol][0]);
	//以下为修改校验规则的处理  begin----------------------------------
	var sInputName = "R"+iRow+"F"+iCol;
	sItemName = sItemName.toUpperCase();
	if(bRequired){
		if(_user_validator.length>1){//info模式
			try{
				$("#"+sInputName,frames["myiframe0"].document).rules("add",{required0 : true,messages:{required0:"请输入"+DZ[iDW][1][iCol][0]}});
			}
			catch(e){
				var rules = _user_validator[1].rules;
				var messages = _user_validator[1].messages;
				if(!rules[sInputName])rules[sInputName] = new Object();
				if(!messages[sInputName])messages[sInputName] = new Object();
				if(!rules[sInputName].required0){
					rules[sInputName].required0 = true;
				}
				if(!messages[sInputName].required0){
					messages[sInputName].required0="请输入"+DZ[iDW][1][iCol][0];
				}
			}
			
		}else{//list模式
			var rules = _user_validator[0].rules;
			var messages = _user_validator[0].messages;
			if(!rules[sItemName])rules[sItemName] = new Object();
			if(!rules[sItemName].required0){
				rules[sItemName].required0 = true;
				messages[sItemName].required0="请输入"+DZ[iDW][1][iCol][0];
			}
		}
	}else{
		if(_user_validator.length>1){//info模式
			try{
				$("#"+sInputName,frames["myiframe0"].document).rules("remove","required0");
			}
			catch(e){
				_user_validator[1].rules[sInputName] = undefined;
				_user_validator[1].messages[sInputName] = undefined;
			}
			
		}else{//list模式
			_user_validator[0].rules[sItemName] = undefined;
			_user_validator[0].messages[sItemName] = undefined;
		}
	}
	//修改校验规则的处理  end----------------------------------
}

//add by syang 2009/11/06 设置指定单元的标题信息
function setItemHeader(iDW,iRow,sItemName,sHeader){
		var iCol = getColIndex(iDW,sItemName);
		setItemCaption(iDW,iRow,iCol,sHeader);
}

function getItemHeader(iDW,iRow,sItemName,sHeader){
	var iCol = getColIndex(iDW,sItemName);
	var obj = window.frames["myiframe"+iDW].document.getElementById("TDR"+iRow+"F"+iCol);
	return obj.innerHTML;
}