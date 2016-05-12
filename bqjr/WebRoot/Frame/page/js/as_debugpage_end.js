var DWPrintHandler;
var webocx1;
var DWPrintStatus = 0;
if(navigator.appName=="Netscape"){
	document.getElementById("trp").style.display="none";
	document.getElementById("trf").style.display="block";
	document.getElementById("tdp").innerHTML ="";
	document.getElementById("tdc").innerHTML = "";
	//document.getElementById("debugTool_subdiv").style.height="400px";
}
else{
	document.getElementById("trp").style.display="block";
	document.getElementById("trf").style.display="none";
}
function as_PrintScreen(){
    DWPrintHandler = undefined;
    AsDebug.reportError();
    //webocx1 = document.getElementById("WebOcx1");
    webocx1 = new ActiveXObject("AmarTool.PScreenControl");
    DWPrintStatus = webocx1.getRunStatus();
    DWPrintHandler = window.setInterval(as_printS0, 100);
    //var sFileName = obj.PrintScreen();
    
}
function as_printS0(){
    if(document.getElementById('reportError').style.display=='none' && DWPrintStatus == 1){
        var sFileName = webocx1.PrintScreen();
        AsDebug.reportError();
        document.getElementById('IMGPScrren').src = sFileName + "?random=" + Math.random();
        //alert(document.getElementById('IMGPScrren').src);
        var imgdata = document.getElementById('imgdata');
        imgdata.value = webocx1.getByteStr(sFileName);
        window.clearInterval(DWPrintHandler);
    }
}
function AS_PE_CheckData(){
    var obj = document.getElementById('taError');
    if(obj.value ==''){
        alert('请输入出错描述');
        obj.focus();
        return false;
    }
    document.getElementById("url").value = AsDebug.getURL();
    try{
    	document.getElementById("dono").value = DisplayDONO;
    }
    catch(e){}
    if(navigator.appName=="Netscape"){
    	FReportError.enctype = "multipart/form-data";
    	FReportError.action = sWebRootPath + "/Frame/page/debug/tools/ReportErrorFromFile.jsp?CompClientID=" + sCompClientID;
    }
    return true;
}
function viewReportedError(){
	$("#sp_report_overdiv_top").click();
	AsControl.OpenDynamicTab("我报告的问题","/AppMain/ErrorReport/UserGUI/ReportedErrorView.jsp","",top,"maincenter",false);
}