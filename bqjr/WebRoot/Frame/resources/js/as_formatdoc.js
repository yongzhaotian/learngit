var SAVE_TMP = false;
var bEditHtml = false; 
var bEditHtmlChange = false;
var bEditHtmlChange2= false;
var oldFormValues = new Array();
var newFormValues = new Array();
var _user_validator;

$().ready(function(){
	try{
		setOldValue();
		//�󶨿�ݼ�
		jQuery.initObjectKeyArray();
	}catch(e){}
});


/*//����Ǳ�������֤�ǿ�,����ݴ�����֤
function getItemValue(arg0,arg1,inputname){
	//alert(inputname);
	var objs = document.getElementsByName(inputname);
	//alert(obj.value);
	//if(obj.getAttribute("truevalue"))
	if(objs.length>1){
		var result = "";
		for(var i=0;i<objs.length;i++){
			if(result==""){
				if(objs[i].checked)
					result = objs[i].value;
			}
			else{
				if(objs[i].checked)
					result += "," + objs[i].value;
			}
		}
		return result;
	}
	//return obj.getAttribute("truevalue");
	else
		return objs[0].value;
}
*/
function iV_allF(){
	var result = true;
	//alert("_user_validator="+ _user_validator);
	if(_user_validator){
		result = $("#frmFDDataContent").validate(_user_validator).form();
		try{
			result = $("#frmFDDataContent").validate(_user_validator).form();
		}
		catch(e){
			alert("У���������" + e.message);
		}
	}
	return result;
}
function setOldValue(){
	oldFormValues = document.getElementById('frmFDDataContent').innerHTML;
}
function setNewValue(){
	newFormValues = document.getElementById('frmFDDataContent').innerHTML;
}


/*����Ϊ�ṩҳ�������õķ���,�������ϰ汾�ĸ�ʽ������
 *  ͨ�÷����� fillFormatDoc ��д���桢fillFormatDocWithOpen ��д���沢�򿪡�productFormatDoc ���ɱ��桢 previewFormatDoc Ԥ�����桢  ExportToPdf ����PDF
 *  �°汾������scoreFormatDoc �� refreshFormatDoc ˢ�±��桢 checkFormatDoc У�鱨�桢 importOfflineFormatDoc �������߱��桢 importOfflineModelFormatDoc �������߱���ģ�塢 
 *  		exportOfflineModelFormatDoc �������߱���ģ�塢 exportOfflineFormatDoc �������߱���
 */
function fillFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function fillFormatDocWithOpen(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	var sReturn = AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
	if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn =="SUCCESS"){
		AsControl.OpenView("/AppConfig/FormatDoc/FormatDocView.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType,"_blank",OpenStyle); 
	}
}

function productFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/ProduceFile.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function previewFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	AsControl.PopView("/AppConfig/FormatDoc/PreviewFile.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds+"&rand="+randomNumber(),"");
}

function scoreFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","Method=7&DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function checkFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	return AsControl.RunJsp("/AppConfig/FormatDoc/AddData.jsp","Method=8&DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
}

function refreshFormatDoc(typeNo,objectNo,objectType,usedocid){
	if(usedocid)
		return AsControl.RunJsp("/AppConfig/FormatDoc/RefreshData.jsp","DocID="+typeNo+"&ObjectNo="+objectNo+"&ObjectType="+objectType);
	else
		return AsControl.RunJsp("/AppConfig/FormatDoc/RefreshData.jsp","TypeNo="+typeNo+"&DocID="+typeNo+"&ObjectNo="+objectNo+"&ObjectType="+objectType);
}

function importOfflineFormatDoc(){
	OpenPage('/AppConfig/FormatDoc/SelUploadFile.jsp','','width=400,height=150');
}

function importOfflineModelFormatDoc(){
	OpenPage('/AppConfig/FormatDoc/SelUploadModelFile.jsp','','width=400,height=150');
}

function exportOfflineModelFormatDoc(docID){
	exportOfflineFormatDoc(docID,"999999999","999999999","");
}

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

function exportOfflineFormatDoc(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	var sReturn = AsControl.RunJsp("/AppConfig/FormatDoc/ProductOfflineFile.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
	if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn!="FAILED"){
		//alert("�����������ļ�:"+ sReturn);
		var sFormName="form"+randomNumber();
		var targetFrameName=generateIframe();
		var sHTML = "";
		sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action="+sWebRootPath+"/servlet/view/file > ";
		sHTML+="<div style='display:none'>";
		sHTML+="<input name=filename value='"+sReturn+"' >";
		//sHTML+="<input name=contenttype value='application/pdf'>";
		sHTML+="<input name=contenttype value='unknown'>";
		sHTML+="<input name=viewtype value='unknown'>";
		sHTML+="</div>";
		sHTML+="</form>";
		document.body.insertAdjacentHTML("afterBegin",sHTML);
		var oForm = document.forms[sFormName];
		oForm.submit();
	}
}

function exportToPdf(docID,objectNo,objectType,excludeDirIds){
	if(excludeDirIds==undefined) excludeDirIds="";
	var sReturn = AsControl.RunJsp("/AppConfig/FormatDoc/ProducePdf.jsp","DocID="+docID+"&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ExcludeDirIds="+excludeDirIds);
	if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn!="FAILED"){
		//alert("������pdf:"+ sReturn);
		var sFormName="form"+randomNumber();
		var targetFrameName=generateIframe();
		var sHTML = "";
		sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action="+sWebRootPath+"/servlet/view/file > ";
		sHTML+="<div style='display:none'>";
		sHTML+="<input name=filename value='"+sReturn+"' >";
		sHTML+="<input name=contenttype value='application/pdf'>";
		//sHTML+="<input name=contenttype value='unknown'>";
		sHTML+="<input name=viewtype value='view'>";
		sHTML+="</div>";
		sHTML+="</form>";
		document.body.insertAdjacentHTML("afterBegin",sHTML);
		var oForm = document.forms[sFormName];
		oForm.submit();		
	}
}

function amarCopy(){
	try {
		var sel=parent.document.body.createTextRange(); 
		var oTblExport = parent.document.getElementById('reportContent'); 
		if (oTblExport != null) {
			sel.moveToElementText(oTblExport);
			sel.execCommand('Copy');//alert(sel.htmlText.replace(/<\s*[Ss][Cc][Rr][Ii][Pp][Tt][\w\W]+?<\s*\/\s*[Ss][Cc][Rr][Ii][Pp][Tt]\s*>/g,'')); 
		}
	} catch (e) {	var a = 1; }
}
function autoCopy(){
	amarCopy();
	alert("�Ѿ����Ƶ�ճ����!");
}
function exportToWord(){
	var oWD = new ActiveXObject('Word.Application');
	oWD.Application.Visible = true;
	var oDC =oWD.Documents.Add('',0,1);
	var oRange =oDC.Range(0,1);
	amarCopy();
	oRange.Paste(); 
}