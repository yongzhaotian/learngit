var sScreenWidth = screen.availWidth;
var sScreenHeight = screen.availHeight;
var sDefaultDialogStyle= "dialogWidth="+sScreenWidth+"px;dialogHeight="+sScreenHeight+"px;resizable=yes;maximize:yes;help:no;status:no;";
var OpenStyle="width="+sScreenWidth+"px,height="+sScreenHeight+"px,top=0,left=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
var sDefaultModelessDialogStyle = "dialogLeft="+(sScreenWidth*0.6)+";dialogWidth="+(sScreenWidth*0.4)+"px;dialogHeight="+(sScreenHeight)+"px;resizable=yes;status:yes;maximize:yes;help:no;";

function over_change(index,src,clrOver){
	if (!src.contains(event.fromElement)){ 
 		src.style.cursor = 'pointer';
 		src.background = clrOver;
 	}
}

function out_change(index,src,clrIn){
	if (!src.contains(event.toElement)){
		src.style.cursor = 'default';
		src.background = clrIn;
	}
}

bIsLocked=false;

function checkIfLocked(){
	if(bIsLocked){
		if(!confirm("���Ѿ��õ�����ʽ����һ����ҳ�棬�뿪��ҳ�潫���ܵ��³���\n�ô��󽫲���Ӱ��ϵͳ�������С�\n��ȷ��Ҫ�뿪��ҳ����")) 
			return true;
		else 
			return false;
	}else	
		return true;
}

//���ڼ�麯��	
function isDate(sItemName){
	var value = Query.elements[sItemName].value;
	var sItems = value.split("/");
	
	if (sItems.length!=3) return false;
	if (isNaN(sItems[0])) return false;
	if (isNaN(sItems[1])) return false;
	if (isNaN(sItems[2])) return false;
	if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2150) return false;
	if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
	if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
	return true;
}

//�ı乤������С
function resizeLeft(){
	try{
		if(myleft.width==1){
			myleft.width=myleftwidth;
			//self.mymiddle.style.cssText="cursor:w-resize";
		}else{
			myleftwidth=myleft.width;
			myleft.width=1;
			//self.mymiddle.style.cssText="cursor:e-resize";
		 }
	}catch(e){ }
}
	 
function resizeTop(){
	if(mytop.height==25) {
		mytop.height=mytopheight;
		//self.mymiddle.style.cssText="cursor:w-resize";
	} else {
		mytopheight=top.mytop.height;
		mytop.height=25;
		//self.mymiddle.style.cssText="cursor:e-resize";
	 }
}

function setObjectInfo(sObjectType,sValueString,iArgDW,iArgRow,sStyle){
	//sObjectType����������
	//sValueString��ʽ�� ������� @ ID���� @ ID�ڷ��ش��е�λ�� @ Name���� @ Name�ڷ��ش��е�λ��
	//iArgDW: �ڼ���DW��Ĭ��Ϊ0
	//iArgRow: �ڼ��У�Ĭ��Ϊ0
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var iDW = iArgDW;
	if(iDW == null) iDW=0;
	var iRow = iArgRow;
	if(iRow == null) iRow=0;
	
	var sValues = sValueString.split("@");
	
	var sParaString = sValues[0];
	
	var i=sValues.length;
   	i=i-1;
   	if (i%2!=0){
   		alert("setObjectInfo()���ز����趨����!\r\n��ʽΪ:@ID����@ID�ڷ��ش��е�λ��...");
		return;
   	}else{
		var j=i/2,m,sColumn,iID;	
		//sObjectNoString = PopPage("/SystemManage/SelectionDialog/GetObjectNo.jsp?ObjectType="+sObjectType+"&ParaString="+sParaString,"","dialogWidth:640px;dialogHeight:480px;resizable:yes;scrollbars:no");
		sObjectNoString = selectObjectInfo(sObjectType,sParaString,sStyle);
		if(typeof(sObjectNoString)=="undefined" || sObjectNoString=="null" || sObjectNoString==null || sObjectNoString=="_CANCEL_"){
			return;
		}else if(sObjectNoString=="_CLEAR_"){
			for(m=1;m<=j;m++){
				sColumn = sValues[2*m-1];
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,"");
			}
		}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined"){
			sObjectNos = sObjectNoString.split("@");
			for(m=1;m<=j;m++){
				sColumn = sValues[2*m-1];
				iID = parseInt(sValues[2*m],10);
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,sObjectNos[iID]);
			}
		}else{
			//alert("ѡȡ������ʧ�ܣ��������ͣ�"+sObjectType);
			return;
		}
		return sObjectNoString;
	}	
}
	
function selectObjectInfo(sObjectType,sParaString,sStyle){
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	sObjectNoString = PopPage("/Frame/ObjectSelect.jsp?ObjectType="+sObjectType+"&ParaString="+sParaString,"",sStyle);
	return sObjectNoString;
}

function openObject(sObjectType,sObjectNo,sViewID,sStyle){
	OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,"_blank",sStyle);
}

function OpenObject(sObjectType,sObjectNo,sViewID,sStyle){
	openObject(sObjectType,sObjectNo,sViewID,sStyle);
}

function popObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas){
	popComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"~ObjectNo="+sObjectNo+"~ViewID="+sViewID,sDialogStyle,sDialogParas);
}

function PopObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas){
	popObject(sObjectType,sObjectNo,sViewID,sDialogStyle,sDialogParas);
}

function openObjectInFrame(sObjectType,sObjectNo,sViewID,sFrameID){
	OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID,sFrameID,"");
}

function maximizeWindow(){
	window.moveTo(0,0);
	if (document.all){ 
  		top.window.resizeTo(screen.availWidth,screen.availHeight); 
	} else if (document.layers||document.getElementById){ 
  		if (top.window.outerHeight<screen.availHeight||top.window.outerWidth<screen.availWidth){
    		top.window.outerHeight = screen.availHeight; 
    		top.window.outerWidth = screen.availWidth;
  		}
	}
}

/**
 * add by syang 2009/09/22
 * �Զ�����̽�⺯��
 * @scenarioID ������
 * @bizArgs ҵ�������ʹ��&���ŷֿ�
 * @subTypeNo ��Ҫִ�е������ͱ�ţ��ɲ����˲���
 */
function autoRiskScan(scenarioID,bizArgs,subTypeNo){
	
	var sReturn = false;
	
	if(typeof(scenarioID) == "undefined" || scenarioID.length == 0){
		alert("����̽�⣬��Ҫ�����ţ��봫�볡���Ų�����");
		return sReturn;
	}
	if(typeof(bizArgs) == "undefined" || bizArgs.length == 0){
		alert("����̽�⣬��Ҫҵ�����ݣ��봫��ҵ�����ݲ�����");
		return sReturn;
	}
	if(typeof(subTypeNo) == "undefined" || subTypeNo.length == 0){
		subTypeNo = "";
	}
	
	sceCompID="ScenarioAlarm";
	sceCompUrl="/AppConfig/AutoRiskDetect/ScenarioAlarm.jsp";
	sceCompArgs = "ScenarioNo="+scenarioID+"&SubTypeNo="+subTypeNo+"&BizArg="+encodeURI(bizArgs.replace(/&/gi,","));
	sceStyle = "dialogWidth=900px;dialogHeight=540px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
	//sReturn = popComp(sceCompID,sceCompUrl,sceCompArgs,sceStyle);
	sReturn = PopPage(sceCompUrl+"?"+sceCompArgs,"",sceStyle);
	return sReturn;
}

function getXmlHttpObject() {
	var xmlHttp=null;
	try{
		  // Firefox, Opera 8.0+, Safari
		  xmlHttp=new XMLHttpRequest();
	  }catch (e) {
		  // Internet Explorer
		  try{
		    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
		  }catch (e){
		    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
  	}
	return xmlHttp;
}

function viewSource(){
	var ress  =parent.location;
	window.location="view-source:"+ress;
}
function key_up(e){
	if( document.event.shiftKey  && document.event.ctrlKey && document.event.altKey ){
		alert("ss");
		return;
	}
}
function GetPropertiesString(objObject) //byhu: �˺������Բ쿴����������������
{
   var varProp="";
   var strProperties = objObject.id + "\n";

   for (varProp in objObject){
      strProperties += varProp + " = " + objObject[varProp] + "\n";
   }
   return strProperties;
}

function reloadSelf(){
	//��ס��ǰ��ҳ�ź��к�
	rememberPageRow();
	if(document.forms["DOFilter"]==null){
		self.location.reload();
	} else if(typeof(document.forms["DOFilter"])=="undefined"){
		self.location.reload();
	}else{
		document.forms["DOFilter"].submit();
	}
}
function rememberPageRow(){
	//document.all("DWCurPage").value=curpage[0];
	//document.all("DWCurRow").value=getRow(0);
}

//add by hxd in 2008/04/10 
function reloadCurrentRow_old(iDW,iTempCurrRow){
 	var ii=0,mycond=" 1e1eq2qu3u1 "; 
	for(ii=0;ii<f_c[iDW];ii++){
		if(DZ[iDW][1][ii][1]==1){
			if(DZ[iDW][1][ii][12]==1||DZ[iDW][1][ii][12]==3||DZ[iDW][1][ii][12]==4)
				mycond = mycond + " and " + DZ[iDW][1][ii][15] + "e1eq2qu3u'"+DZ[iDW][2][iTempCurrRow][ii]+"'";
			else
				mycond = mycond + " and " + DZ[iDW][1][ii][15] + "e1eq2qu3u"+DZ[iDW][2][iTempCurrRow][ii];
		}
	}
	
 	var myoldstatus = window.status;   
 	window.status="���ڴӷ�����������ݸ��µ�ǰ��¼�����Ժ�....";   
 	self.showModalDialog(sPath+"GetDWCurrRow.jsp?dw="+DZ[iDW][0][1]+"&cond="+real2Amarsoft(mycond)+"&rand="+amarRand(),window.self,"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no"); 
 	window.status=myoldstatus; 
 	   
	for(ii=0;ii<f_c[iDW];ii++){
		setItemValue(iDW,getRow(iDW),DZ[iDW][1][ii][15],DZ[iDW][2][iTempCurrRow][ii]+"A");
	}
}

//add by hxd in 2008/04/10 
function reloadCurrentRow(_iDW,_iTempCurrRow){
	var iDW=0;
	var iTempCurrRow=0;
	
	if(arguments.length==0){
		iDW = 0;
		iTempCurrRow = getRow(0);
	}
	
	if(arguments.length==1){
		iDW = _iDW ;
		iTempCurrRow = getRow(iDW);
	}
	
	if(arguments.length==2){
		iDW = _iDW ;
		iTempCurrRow = _iTempCurrow;
	}
	
	var bHaveKey = false;
 	var ii=0,mycond=""; 
 	
 	mycond = "dw="+DZ[iDW][0][1]+"&row="+iTempCurrRow;
 	
	for(ii=0;ii<f_c[iDW];ii++){
		if(DZ[iDW][1][ii][1]==1){
			bHaveKey = true;
			mycond = mycond+"&col"+ii+"="+real2Amarsoft(DZ[iDW][2][iTempCurrRow][ii]);
		}
	}
	
	if(!bHaveKey){
		alert("��DW����û�ж������������ܶ�̬���£�");
		return;
	}

 	var myoldstatus = window.status;   
 	window.status="���ڴӷ�����������ݸ��µ�ǰ��¼�����Ժ�....";   
 	self.showModalDialog(sPath+"GetDWCurrRow.jsp?"+mycond+"&rand="+amarRand(),window.self,
 		"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no"); 
 	window.status=myoldstatus; 
 	   
	for(ii=0;ii<f_c[iDW];ii++){
		try {
			setItemValue(iDW,iTempCurrRow,DZ[iDW][1][ii][15],DZ[iDW][2][iTempCurrRow][ii]);
		}catch(e){}
	}	
}

function sessionOut(){
	if(confirm("ȷ���˳���ϵͳ��"))
		OpenPage("/SignOut.jsp","_top","");
}

/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
function getSerialNo(sTableName,sColumnName,sPrefix){
	//ʹ��GetSerialNo.jsp����ռһ����ˮ��
	if(typeof(sPrefix)=="undefined" || sPrefix=="") sPrefix="";
	return RunJspAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix);
}

//*************************begin********************
//Author:thong
//Create Date?2005-9-7 8:20
//Describe:��ҳ�����ύ��ѯ�����󣬳��ֽ�������ֱ���µ�ҳ�������ȫ��load������
//**************************************************
function onSubmit(sUrl,sParameter) {
	var waitingInfo = document.getElementById(getNetuiTagName("waitingInfo"));
	//������ʾ
	waitingInfo.style.display = ""; 
	//������ʼ
	progress_update(); 
	//�������
	for(var i=0;i<1000000;i++){
		j=i+i;
	}
	
	OpenPage(sUrl,sParameter,""); 
}

//Modify Date?2006-2-16 17:20 Ϊ�˼�˲�ͬ��form��������һ������sFormName
function onFromAction(sUrl,sFormName) {
	var waitingInfo = document.getElementById(getNetuiTagName("waitingInfo"));
	waitingInfo.style.display = ""; 
	progress_update(); 
	for(var i=0;i<1000000;i++){
		j=i+i;
	}
	if(sFormName == "report"){
		document.report.action = sUrl;
		document.report.submit();
	}
	if(sFormName == "DOFilter"){
		sUrl.submit();
	}
}

// Build the netui_names table to map the tagId attributes
// to the real id written into the HTML
if (netui_names == null)
var netui_names = new Object();
netui_names.selectButton="portlet_15_1selectButton";
// method which will return a real id for a tagId
function getNetuiTagName(id) {
	return netui_names[id];
}

// method which will return a real id for a tagId,
// the tag parameter will be used to find the scopeId for
// containers that may scope their ids
function getNetuiTagName(id, tag) {
	var scopeId = getScopeId(tag);
	if (scopeId == "")
		return netui_names[id];
	else
		return netui_names[scopeId + "__" + id];
}

// method which get a tag will find any scopeId that,
// was inserted by the containers
function getScopeId(tag) {
	if (tag == null)
		return "";
	if (tag.getAttribute) { 
		if (tag.getAttribute('scopeId') != null)
			return tag.getAttribute('scopeId');
	} 
	if (tag.scopeId != null)
		return tag.scopeId;
		return getScopeId(tag.parentNode);
}

// Build the netui_names table to map the tagId attributes
// to the real id written into the HTML
if (netui_names == null)
var netui_names = new Object();
netui_names.waitingInfo="waitingInfo";

//������
var progressEnd = 18; 
//��������ɫ
var progressColor = 'green'; 
var progressInterval = 200; // set to time between updates (milli-seconds)

var progressAt = progressEnd;
var progressTimer;

function progress_clear() {
	for (var i = 1; i <= progressEnd; i++) 
		document.getElementById('progress'+i).style.backgroundColor = 'transparent';
	progressAt = 0;
}
function progress_update() {
progressAt++;
	if (progressAt > progressEnd) progress_clear();
	else document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
	progressTimer = setTimeout('progress_update()',progressInterval);
}
function progress_stop() {
	clearTimeout(progressTimer);
	progress_clear();
}	
//*******************************end*********************************

//�Բ�����Ԥ����
function setObjectValuePretreat(sObjectType,sParaString,sValueString,iArgDW,iArgRow,sStyle){
	//alert("sParaString="+sParaString);
	var regexp = /#{[A-Za-z0-9]+}/g;
	var cols = sParaString.match(regexp);
	if(cols){
		for(var i=0;i<cols.length;i++){
			var sCol = cols[i].substring(2,cols[i].length-1);
			var sColValue = getItemValue(0, 0, sCol);
			sParaString = sParaString.replace("#{"+sCol+"}", sColValue);
		}
	}
	//alert(sParaString);
	
	setObjectValue(sObjectType,sParaString,sValueString,iArgDW,iArgRow,sStyle);
}

//add zywei 2005/08/31 ��Ҫ��ʹ����select_catalog���Զ����ѯѡ����Ϣ		
function setObjectValue(sObjectType,sParaString,sValueString,iArgDW,iArgRow,sStyle){
	//sObjectType����������
	//sValueString��ʽ�� ������� @ ID���� @ ID�ڷ��ش��е�λ�� @ Name���� @ Name�ڷ��ش��е�λ��
	//iArgDW: �ڼ���DW��Ĭ��Ϊ0
	//iArgRow: �ڼ��У�Ĭ��Ϊ0
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	var iDW = iArgDW;
	if(iDW == null) iDW=0;
	var iRow = iArgRow;
	if(iRow == null) iRow=0;
	
	var sValues = sValueString.split("@");
	
	var i=sValues.length;
 	i=i-1;
 	if (i%2!=0){
 		alert("setObjectValue()���ز����趨����!\r\n��ʽΪ:@ID����@ID�ڷ��ش��е�λ��...");
 		return;
 	}else{
		var j=i/2,m,sColumn,iID;
		var sObjectNoString = selectObjectValue(sObjectType,sParaString,sStyle);
		if(typeof(sObjectNoString)=="undefined" || sObjectNoString=="null" || sObjectNoString==null || sObjectNoString=="_CANCEL_" ){
			return;	
		}else if(sObjectNoString=="_CLEAR_"){
			for(m=1;m<=j;m++){
				sColumn = sValues[2*m-1];
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,"");
			}
		}else if(sObjectNoString!="_NONE_" && sObjectNoString!="undefined"){
			sObjectNos = sObjectNoString.split("@");
			for(m=1;m<=j;m++){
				sColumn = sValues[2*m-1];
				iID = parseInt(sValues[2*m],10);
				
				if(sColumn!="")
					setItemValue(iDW,iRow,sColumn,sObjectNos[iID]);
			}	
		}else{
			//alert("ѡȡ������ʧ�ܣ��������ͣ�"+sObjectType);
			return;
		}
		return sObjectNoString;
	}
}

//add zywei 2005/08/31 ��Ҫ��ʹ����select_catalog���Զ����ѯѡ����Ϣ	
function selectObjectValue(sObjectType,sParaString,sStyle){
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	//sObjectNoString = PopComp("SelectGridDialog","/Frame/SelectGridDialog.jsp","SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
	sObjectNoString = PopPage("/Frame/DialogSelect.jsp?SelName="+sObjectType+"&ParaString="+sParaString,"",sStyle);
	return sObjectNoString;
}

//add zywei 2005/08/31 ��Ҫ��ʹ����select_catalog���Զ����ѯѡ����Ϣ	
function selectMultipleGrid(sObjectType,sParaString,sStyle){
	if(typeof(sStyle)=="undefined" || sStyle=="") sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
	//sObjectNoString = PopComp("SelectGridDialog","/Frame/SelectGridDialog.jsp","SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
	sObjectNoString = PopComp("SelectMultipleGridDialog","/Frame/SelectMultipleGridDialog.jsp","SelName="+sObjectType+"&ParaString="+sParaString,sStyle);
	return sObjectNoString;
}

//add by byhu 2006.08.03 �༭����
function editRule(sTable,sRegisteredColumn){
	sScript=getItemValue(0,getRow(),sRegisteredColumn);
	saveParaToComp("Script="+sScript,"openRuleEditor('"+sTable+"','"+sRegisteredColumn+"')");
	//openRuleEditor(sTable,sRegisteredColumn,sScript);
}

function openRuleEditor(sTable,sColumnName){
	if(sScreenWidth>=1000) sDialogWidth = "950px", sDialogHeight="700px";
	sValue = PopComp("RuleEditor","/Common/Configurator/RuleManage/RuleEditor.jsp","Table="+sTable+"&Column="+sColumnName,"");
	if (sValue!=null && sValue!='undefined') {
		setItemValue(0,getRow(),sColumnName,sValue);
	}
}

/**�����������ȡ����*/
function getCompAttribute(sAttributeID){
	var sReturn = PopPage("/Common/ToolsB/GetCompAttribute.jsp?AttributeID="+sAttributeID);
	return sReturn;
}

/**���Խű�*/
function testRule(sScript){
	sScript = real2Amarsoft(sScript);
	var sData = getCompAttribute("ScenarioPara");
	if(sData==null ||sData=="null" || sData=="") sData = selectObjectValue("SelectAllCBTestApply","","");
	if(typeof(sData)=="undefined" || sData=="") return;
	sDatas = sData.split("@");
	
	var sScriptScenario = getCompAttribute("Scenario");
	if(sScriptScenario==null ||sScriptScenario=="null" || sScriptScenario=="") sScriptScenario = selectObjectValue("SelectAllScriptScenario","","");
	if(typeof(sScriptScenario)=="undefined" || sScriptScenario=="") return;
	if(sScriptScenario=="_CANCEL_") return;
	sScriptScenario = sScriptScenario.split("@")[0];
	
	//var sPath = RunMethod("Configurator","TestBusinessRule",sScriptScenario+",TaskNo="+sDatas[1]+","+sScript);
	var sPath = PopPage("/Common/Configurator/RuleManage/TestScript.jsp?Scenario="+sScriptScenario+"&ParaString=TaskNo="+sDatas[1]+"&Script="+sScript,"","width:0px;height:0px");
	if(typeof(sPath)=="undefined") return;
	if(sPath=="_CANCEL_") return;
	
	if(sPath.indexOf("LogID=")>=0){
		PopComp("DecisionFlow","/Common/Configurator/RuleManage/DecisionFlowDisplay.jsp","Path="+sPath);
	}else{
		alert("����ִ�еĽ��Ϊ:\n\n"+sPath);
	}
}

//���������ͻ
function checkPrimaryKey(sTable,sColumnString){
	if(typeof(sTable)=="undefined" || sTable=="") return false;
	if(typeof(sColumnString)=="undefined" || sColumnString=="") return false;
	var sParameters = "Type=PRIMARYKEY&TableName="+sTable+"";
	var sColumns=sColumnString.split("@");
	for(var i=0;i<sColumns.length;i++){
		if(i==4){
			alert("�ؼ������4��");
			return false;
		}
		sParameters+="&FieldName"+(i+1)+"="+sColumns[i];
		sParameters+="&FieldValue"+(i+1)+"="+getItemValue(0,0,sColumns[i]);
	}
	var sReturnValue = RunJspAjax("/Common/ToolsB/CheckPrimaryKeyAction.jsp?"+sParameters);
	if(sReturnValue == "TRUE"){
		return true;
	}else{
		return false;
	}
}

/**
 * �������ֵ�Ƿ�Ϊ��
 * @param obj
 * @return
 */
function isNull(obj){
	if(obj == null || typeof(obj) == "undefined"){
		return true;
	}
	if(obj == "" || obj.length <= 0){
		return true;
	}
	return false;
}

function setSessionValue(attributeName,attributeValue){
	//ʹ��GetSerialNo.jsp����ռһ����ˮ��
	return RunJspAjax("/Frame/page/sys/SetSessionValue.jsp?attributeName="+attributeName+"&attributeValue="+attributeValue);
}
	