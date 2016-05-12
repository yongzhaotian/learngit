<%@ page contentType="text/html; charset=GBK"%><%@ 
 include file="/IncludeBegin.jsp"%>
<HTML  id=dlgImage STYLE="width: 432px; height: 194px; ">
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta http-equiv="MSThemeCompatible" content="Yes">
<TITLE>插入图片</TITLE>
<style>
  html, body, button, div, input, select, fieldset { font-family: MS Shell Dlg; font-size:8pt; position: absolute; };
</style>
<SCRIPT defer>

function _CloseOnEsc() {
  if (event.keyCode == 27) { window.close(); return; }
}

function _getTextRange(elm) {
  var r = elm.parentTextEdit.createTextRange();
  r.moveToElementText(elm);
  return r;
}

window.onerror = HandleError;

function HandleError(message, url, line) {
  var str = "An error has occurred in this dialog." + "\n\n"
  + "Error: " + line + "\n" + message;
  alert(str);
  window.close();
  return true;
}

function Init() {
  var elmSelectedImage;
  var htmlSelectionControl = "Control";
  var globalDoc = window.dialogArguments;
  var grngMaster = globalDoc.selection.createRange();
  
  // event handlers  
  document.body.onkeypress = _CloseOnEsc;
  btnOK.onclick = new Function("btnOKClick()");

  txtFileName.fImageLoaded = false;
  txtFileName.intImageWidth = 0;
  txtFileName.intImageHeight = 0;
 
  if (globalDoc.selection.type == htmlSelectionControl) {
    if (grngMaster.length == 1) {
      elmSelectedImage = grngMaster.item(0);
      if (elmSelectedImage.tagName == "IMG") {
        txtFileName.fImageLoaded = true;
        if (elmSelectedImage.src) {
          txtFileName.value          = elmSelectedImage.src.replace(/^[^*]*(\*\*\*)/, "$1");  // fix placeholder src values that editor converted to abs paths
          txtFileName.intImageHeight = elmSelectedImage.height;
          txtFileName.intImageWidth  = elmSelectedImage.width;
          txtVertical.value          = elmSelectedImage.vspace;
          txtHorizontal.value        = elmSelectedImage.hspace;
          txtBorder.value            = elmSelectedImage.border;
          txtAltText.value           = elmSelectedImage.alt;
          selAlignment.value         = elmSelectedImage.align;
        }
      }
    }
  }
  txtFileName.value = txtFileName.value || "http://";
  //txtFileName.focus();
}

function _isValidNumber(txtBox) {
  var val = parseInt(txtBox);
  if (isNaN(val) || val < 0 || val > 999) { return false; }
  return true;
}

var bFileUploaded = false;
var sFileName = "";

function btnOKClick() {
  
  		//add in 2005/04/11
  		var sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;		
		if (sFileName=="")			
		{
			alert("请选择一个文件名!");
			document.forms("SelectAttachment").AttachmentFileName.focus();
			return false;
		}
		else	
		{
			/*
			try {
				var fso = new ActiveXObject("Scripting.FileSystemObject");
				var f1 = fso.GetFile(SelectAttachment.AttachmentFileName.value);			
			}catch(e) {
				alert(e.name+" "+e.number+" :"+e.message);
			}
			
			if(f1.size>1536*1024) {alert("文件大于1536k，不能上传！");return false;}
			*/
			
			bFileUploaded = false;
			//var setTimer=setTimeout("btnOKClick_2()",500);
			document.forms("SelectAttachment").submit();
			document.all("btnOK").style.display = "none";
			document.all("btnCancel").style.display = "none";
			document.all("AttachmentFileName").style.display = "none";
			document.all("mytips").style.display = "none";
			document.all("mytips2").style.display = "block";
			
		}
}

function btnOKClick_2() {

  if(!bFileUploaded) return;
  bFileUploaded = false;
  
  var elmImage;
  var intAlignment;
  var htmlSelectionControl = "Control";
  var globalDoc = window.dialogArguments;
  var grngMaster = globalDoc.selection.createRange();
  
  //txtFileName.value = globalDoc.sWebRootPath+sFileName;	
  txtFileName.value = sFileName;

  // error checking

  if (!txtFileName.value || txtFileName.value == "http://") { 
    alert("Image URL must be specified.");
    //txtFileName.focus();
    return;
  }
  if (txtHorizontal.value && !_isValidNumber(txtHorizontal.value)) {
    alert("Horizontal spacing must be a number between 0 and 999.");
    //txtHorizontal.focus();
    return;
  }
  if (txtBorder.value && !_isValidNumber(txtBorder.value)) {
    alert("Border thickness must be a number between 0 and 999.");
    //txtBorder.focus();
    return;
  }
  if (txtVertical.value && !_isValidNumber(txtVertical.value)) {
    alert("Vertical spacing must be a number between 0 and 999.");
    //txtVertical.focus();
    return;
  }

  // delete selected content and replace with image
  if (globalDoc.selection.type == htmlSelectionControl && !txtFileName.fImageLoaded) {
    grngMaster.execCommand('Delete');
    grngMaster = globalDoc.selection.createRange();
  }
    
  idstr = "\" id=\"556e697175657e537472696e67";     // new image creation ID
  if (!txtFileName.fImageLoaded) {
    grngMaster.execCommand("InsertImage", false, idstr);
    elmImage = globalDoc.all['556e697175657e537472696e67'];
    elmImage.removeAttribute("id");
    elmImage.removeAttribute("src");
    grngMaster.moveStart("character", -1);
  } else {
    elmImage = grngMaster.item(0);
    if (elmImage.src != txtFileName.value) {
      grngMaster.execCommand('Delete');
      grngMaster = globalDoc.selection.createRange();
      grngMaster.execCommand("InsertImage", false, idstr);
      elmImage = globalDoc.all['556e697175657e537472696e67'];
      elmImage.removeAttribute("id");
      elmImage.removeAttribute("src");
      grngMaster.moveStart("character", -1);
      txtFileName.fImageLoaded = false;
    }
    grngMaster = _getTextRange(elmImage);
  }

  if (txtFileName.fImageLoaded) {
    elmImage.style.width = txtFileName.intImageWidth;
    elmImage.style.height = txtFileName.intImageHeight;
  }

  if (txtFileName.value.length > 2040) {
    txtFileName.value = txtFileName.value.substring(0,2040);
  }
  //alert(sWebRootPath);
  //elmImage.src ="<%=request.getScheme()+"://" + request.getServerName() + ":" + request.getServerPort()%>" + sWebRootPath + "/servlet/viewpic?filename=" + txtFileName.value.substring(4) + "&contenttype=text/html&viewtype=view";
  elmImage.src ="<%=request.getScheme()+"://" + request.getServerName() + ":" + request.getServerPort()%>" + sWebRootPath + "/servlet/viewpic?filename=" + txtFileName.value + "&contenttype=text/html&viewtype=view";
  
  if (txtHorizontal.value != "") { elmImage.hspace = parseInt(txtHorizontal.value); }
  else                           { elmImage.hspace = 0; }

  if (txtVertical.value != "") { elmImage.vspace = parseInt(txtVertical.value); }
  else                         { elmImage.vspace = 0; }
  
  elmImage.alt = txtAltText.value;

  if (txtBorder.value != "") { elmImage.border = parseInt(txtBorder.value); }
  else                       { elmImage.border = 0; }

  elmImage.align = selAlignment.value;
  grngMaster.collapse(false);
  grngMaster.select();
  //alert(0);
  //add in 2005/04/11
  //elmImage.onreadystatechange=function(){if(this.width>600){this.style.width=600;this.style.height=this.height*600.0/this.width;}};
  //elmImage.onload = function(){alert(22);};
  //if(elmImage.width>600){elmImage.style.width=600;elmImage.style.height=elmImage.height*600.0/elmImage.width;}
  //alert(elmImage.width + "," + elmImage.height);
  alert("上传成功！");
  if(elmImage.width>600){elmImage.style.width=600;elmImage.style.height=elmImage.height*600.0/elmImage.width;}
  
  
  window.close();
}

</SCRIPT>
</HEAD>
<BODY id=bdy onload="Init()" style="background: threedface; color: windowtext;" scroll=no>

<iframe name=iframe0 style="display:none;left: 31.36em; top: 5.0647em; width: 17em; height: 6.2em;" > </iframe>
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" target=iframe0 action="../fileupload.jsp?CompClientID=<%=sCompClientID %>">
			<br>
			<div id=mytips >&nbsp;&nbsp;请选择一个文件作为附件上传： </div>	
			<div id=mytips2 style="display:none" >&nbsp;&nbsp;正在上传文件，请稍候... </div>	
		    <br>&nbsp;&nbsp;
		    <input type="file" size=40  name="AttachmentFileName"> 
</form>

<div id=divall style="display:none">

<DIV id=divFileName style="left: 0.98em; top: 1.2168em; width: 7em; height: 1.2168em; ">Image URL:</DIV>
<INPUT ID=txtFileName type=text style="left: 8.54em; top: 1.0647em; width: 21.5em;height: 2.1294em; " tabIndex=10 onfocus="select()">

<DIV id=divAltText style="left: 0.98em; top: 4.1067em; width: 6.58em; height: 1.2168em; ">Alternate Text:</DIV>
<INPUT type=text ID=txtAltText tabIndex=15 style="left: 8.54em; top: 3.8025em; width: 21.5em; height: 2.1294em; " onfocus="select()">

<FIELDSET id=fldLayout style="left: .9em; top: 7.1em; width: 17.08em; height: 7.6em;">
<LEGEND id=lgdLayout>Layout</LEGEND>
</FIELDSET>

<FIELDSET id=fldSpacing style="left: 18.9em; top: 7.1em; width: 11em; height: 7.6em;">
<LEGEND id=lgdSpacing>Spacing</LEGEND>
</FIELDSET>

<DIV id=divAlign style="left: 1.82em; top: 9.126em; width: 4.76em; height: 1.2168em; ">Alignment:</DIV>
<SELECT size=1 ID=selAlignment tabIndex=20 style="left: 10.36em; top: 8.8218em; width: 6.72em; height: 1.2168em; ">
<OPTION id=optNotSet value=""> Not set </OPTION>
<OPTION id=optLeft value=left> Left </OPTION>
<OPTION id=optRight value=right> Right </OPTION>
<OPTION id=optTexttop value=textTop> Texttop </OPTION>
<OPTION id=optAbsMiddle value=absMiddle > Absmiddle </OPTION>
<OPTION id=optBaseline value=baseline SELECTED > Baseline </OPTION>
<OPTION id=optAbsBottom value=absBottom> Absbottom </OPTION>
<OPTION id=optBottom value=bottom> Bottom </OPTION>
<OPTION id=optMiddle value=middle > Middle </OPTION>
<OPTION id=optTop value=top> Top </OPTION>
</SELECT>

<DIV id=divHoriz style="left: 19.88em; top: 9.126em; width: 4.76em; height: 1.2168em; ">Horizontal:</DIV>
<INPUT ID=txtHorizontal style="left: 24.92em; top: 8.8218em; width: 4.2em; height: 2.1294em; ime-mode: disabled;" type=text size=3 maxlength=3 value="" tabIndex=25 onfocus="select()">

<DIV id=divBorder style="left: 1.82em; top: 12.0159em; width: 8.12em; height: 1.2168em; ">Border Thickness:</DIV>
<INPUT ID=txtBorder style="left: 10.36em; top: 11.5596em; width: 6.72em; height: 2.1294em; ime-mode: disabled;" type=text size=3 maxlength=3 value="" tabIndex=21 onfocus="select()">

<DIV id=divVert style="left: 19.88em; top: 12.0159em; width: 3.64em; height: 1.2168em; ">Vertical:</DIV>
<INPUT ID=txtVertical style="left: 24.92em; top: 11.5596em; width: 4.2em; height: 2.1294em; ime-mode: disabled;" type=text size=3 maxlength=3 value="" tabIndex=30 onfocus="select()">

</div>

<BUTTON ID=btnOK style="left: 31.36em; top: 1.0647em; width: 7em; height: 2.2em; " type=submit tabIndex=40>确定</BUTTON>
<BUTTON ID=btnCancel style="left: 31.36em; top: 3.6504em; width: 7em; height: 2.2em; " type=reset tabIndex=45 onClick="window.close();">取消</BUTTON>
</BODY>
</HTML>
<%@ include file="/IncludeEnd.jsp"%>