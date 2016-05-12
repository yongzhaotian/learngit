<%@page import="com.amarsoft.awe.dw.ui.util.WordConvertor"%>
<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@page import="com.amarsoft.biz.formatdoc.model.score.*"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<script type="text/javascript">var _editor_url = "<%=sWebRootPath%>/Frame/page/resources/htmledit/";</script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.validate.min-1.8.1.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Resources/1/Support/checkdatavalidity.js"> </script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/as_formatdoc.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/chart/json2.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/as_common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/js/dw/as_dw_common.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/page/resources/htmledit/as_htmleditor.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/widget.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/formatdoc.css">

<%String sMethod = CurPage.getParameter("Method");
if(sMethod == null || sMethod.equals("")) sMethod = IFormatDocData.FDDATA_DISPLAY;
//System.out.println("sMethod=" + sMethod);
String showSave = "true";
if(sMethod.equals(IFormatDocData.FDDATA_SCORE) || sMethod.equals(IFormatDocData.FDDATA_CHECK)  || sMethod.equals(IFormatDocData.FDDATA_SAVESCORE) )
	showSave = "false";
String sSerialNo = CurPage.getParameter("DataSerialNo");
String result = "";//处理信息
FormatDocConfig fconfig = new FormatDocConfig(request);
FormatDocData oData = (FormatDocData)FormatDocHelp.getFDDataObject(sSerialNo,"com.amarsoft",fconfig);
%>
<body>
<%@ include file="/Frame/page/jspf/ui/widget/dw/overdiv.jspf"%>
<table class="list_data_tablecommon"  id="ListTable">
<tr height=1 id="ButtonTR">
	<td id="ListButtonArea" class="listdw_out_buttonarea" valign=top>
		<%
			String[][] sButtons = {
				{showSave,"","Button","保存","保存当前节点的调查报告","saveFormatDocData()","","","",""},
				{"true","","Button","预览","预览当前节点的调查报告","previewFormatDocData()","","","",""},
				{showSave,"","Button","刷新自动获取的内容","刷新当前节点的自动获取的内容","refreshFormatDocData()","","","",""},
				{showSave,"","Button","刷新所有节点内容","刷新所有节点内容","refreshFormatDocDataForAll()","","","",""}
			};
		%><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
    </td>
</tr>
<tr id="trFDDataContent" >
	<td id="tdFDDataContent" >
	<iframe name=mypost0 src="<%=sWebRootPath%>/AppMain/Blank.jsp" frameborder=0 width=1 height=1 style="display:none"> </iframe>
	<form method='post' action='<%=sWebRootPath%>/AppConfig/FormatDoc/InvokeTemplate.jsp' name='frmFDDataContent' id='frmFDDataContent'>
<%
	if( sMethod.equals(IFormatDocData.FDDATA_DISPLAY)){
		out.println("<table align=\"center\" style=\"width:662px;table-layout:fixed;\" background='"+fconfig.getHttpRootPath() + oData.getWatermark() +"'><tr><td style=\"white-space:nowrap;overflow:hidden;\">" + oData.getHtml(sMethod,"GBK") + "</td></tr></table>");//获得HTML
	}else if (sMethod.equals(IFormatDocData.FDDATA_SCORE)
			|| sMethod.equals(IFormatDocData.FDDATA_CHECK)
			|| sMethod.equals(IFormatDocData.FDDATA_SAVESCORE)) {
		out.println("<table align=\"center\" style=\"width:662px;table-layout:fixed;\" background='"+fconfig.getHttpRootPath() + oData.getWatermark() +"'><tr><td style=\"white-space:nowrap;overflow:hidden;\">" + oData.getHtml(sMethod,"GBK") + "</td></tr></table>");//获得HTML
		ScoreHandler scorehandler = FormatDocHelp.getScoreHandler(sSerialNo);
		if(sMethod.equals(IFormatDocData.FDDATA_SCORE)){
			out.println(scorehandler.createEditContent(request,sSerialNo));
		}else if(sMethod.equals(IFormatDocData.FDDATA_SAVESCORE)){
			try{
				out.println(scorehandler.createSaveContent(request,sSerialNo));
				result = "分数保存成功！";
			}catch(Exception e){
				result = "分数保存失败:" + e.toString();
			}
		}else{
			out.println(scorehandler.createReadonlyContent(request,sSerialNo));
		}
	}else if( sMethod.equals(IFormatDocData.FDDATA_PREVIEW) || sMethod.equals(IFormatDocData.FDDATA_EXPORT) ){
		out.println("<table align=\"center\" style=\"width:662px;table-layout:fixed;\" background='"+fconfig.getHttpRootPath() + oData.getWatermark() +"'><tr><td style=\"white-space:nowrap;overflow:hidden;\">" + oData.getHtml(sMethod,"GBK") + "</td></tr></table>");//获得HTML
	}else if( sMethod.equals(IFormatDocData.FDDATA_REFRESH) ){ //"强制刷新"需要刷新本页面,需要重新获得HTML
		try{
			oData.forceRefreshObject();
			//out.println(oData.getHtml(IFormatDocData.FDDATA_DISPLAY,"GBK"));//获得HTML
			out.println("<table align=\"center\" style=\"width:662px;table-layout:fixed;\" background='"+fconfig.getHttpRootPath() + oData.getWatermark() +"'><tr><td style=\"white-space:nowrap;overflow:hidden;\">" + oData.getHtml(IFormatDocData.FDDATA_DISPLAY,"GBK") + "</td></tr></table>");//获得HTML
			result = "刷新成功！";
		}catch(Exception e){
			result = "刷新失败：" + e.toString();
		}
	}else if( sMethod.equals(IFormatDocData.FDDATA_SAVE) || sMethod.equals(IFormatDocData.FDDATA_AUTOSAVE) ){ //"保存"不用刷新本页面,不需要重新获得HTML
		try{
			result = oData.checkInput(request);
			if(result.equals("")){
				oData.fillObject(request);
				//ARE.getLog().info("oData[DataSerialNo="+oData.getDataSerialNo()+",Objectno="+oData.getRecordObjectNo()+"]fillObject()");
				if(sMethod.equals(IFormatDocData.FDDATA_SAVE))
					oData.saveObject(true);
				else
					oData.saveObject();
				//ARE.getLog().info("oData[DataSerialNo="+oData.getDataSerialNo()+",Objectno="+oData.getRecordObjectNo()+"]saveObject()");
				out.println("<table align=\"center\" style=\"width:662px;table-layout:fixed;\" background='"+fconfig.getHttpRootPath() + oData.getWatermark() +"'><tr><td style=\"white-space:nowrap;overflow:hidden;\">" + oData.getHtml(IFormatDocData.FDDATA_DISPLAY,"GBK") + "</td></tr></table>");//获得HTML
				result = "保存成功！";
			}else{
				ARE.getLog().error("oData[DataSerialNo="+oData.getDataSerialNo()+",Objectno="+oData.getRecordObjectNo()+"]checkInput() fail:" + result);
				result = "保存失败："+WordConvertor.convertJava2Js(result)+"未通过数据检查";
			}
		}catch(Exception e){
			e.printStackTrace();
			ARE.getLog().error("oData[DataSerialNo="+oData.getDataSerialNo()+",Objectno="+oData.getRecordObjectNo()+"]保存失败：" + e.toString());
			result = "保存失败：" + e.toString();
		}
	}
%>
		<input type='hidden' name='DataSerialNo' value='<%=sSerialNo%>' >
		<input type='hidden' name='Method' value='1' >
		<input type='hidden' name='Rand' value='' >
		<input type='hidden' name='CompClientID' value='<%=CurComp.getClientID()%>'>
	</form>
	</td>
</tr>
</table>
</body>
<script type="text/javascript">
<%	if( sMethod.equals(IFormatDocData.FDDATA_SAVE) || sMethod.equals(IFormatDocData.FDDATA_REFRESH) || sMethod.equals(IFormatDocData.FDDATA_SAVESCORE)){%>
	<%if("1".equals(CurPage.getParameter("gonext"))){%>
		alert("<%=result%>并跳转到下一个");
	<%}else{%>
		if("<%=result%>"=="保存成功！" || "<%=result%>"=="刷新成功！"){
			resetDWDialog("<%=result%>",false);
		}
		else
			alert("<%=result%>");
	<%}%>
<%}%>

function checkModified(){
	 var sUnloadMessage = "\n\r当前页面内容已经被修改，\n\r按“取消”则留在当前页，然后再按当前页上的“保存”按钮以保存修改过的数据，\n\r按“确定”则不保存修改过的数据并且离开当前页．";
	 if(as_isPageChanged()){
		 return confirm(sUnloadMessage);
	 }
	 return true;
}
function as_isPageChanged(){
	setNewValue();
	oldFormValues = oldFormValues.replace(/<[tT][eE][xX][tT][aA][rR][eE][aA][\w\W]+?<\/[tT][eE][xX][tT][aA][rR][eE][aA]>/g,'').replace(/<[iI][fF][rR][aA][mM][eE][\w\W]+?<\/[iI][fF][rR][aA][mM][eE]>/g,'');
	oldFormValues = oldFormValues.replace(/<NOBR[\w\W]+?<\/NOBR>/g,'');
	newFormValues = newFormValues.replace(/<[tT][eE][xX][tT][aA][rR][eE][aA][\w\W]+?<\/[tT][eE][xX][tT][aA][rR][eE][aA]>/g,'').replace(/<[iI][fF][rR][aA][mM][eE][\w\W]+?<\/[iI][fF][rR][aA][mM][eE]>/g,'');
	newFormValues = newFormValues.replace(/<NOBR[\w\W]+?<\/NOBR>/g,'');
	//document.getElementById("oldc").value = oldFormValues;
	//document.getElementById("newc").value = newFormValues;
	return (oldFormValues!=newFormValues) || bEditHtmlChange || bEditHtmlChange2;
}
jQuery.validator.addMethod("required0",function(value,element,param){
	if(SAVE_TMP==true){
		return true;
	}else{
		if ( !this.depend(param, element) )
			return "dependency-mismatch";
		switch( element.nodeName.toLowerCase() ) {
		case 'select':
			var options = $("option:selected", element);
			return options.length > 0 && ( element.type == "select-multiple" || ($.browser.msie && !(options[0].attributes['value'].specified) ? options[0].text : options[0].value).length > 0);
		case 'input':
			if ( this.checkable(element) )
				return this.getLength(value, element) > 0;
		default:
			return $.trim(value).length > 0;
		}
	}
});
function getItemValue(arg0,arg1,inputname){
	var objs = document.getElementsByName(inputname);
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
		
	function showErrors(){
		//var error = _user_validator.toString();
		//error = error.replace(/<br>/g,"\n");
		//alert("出错了，请检查数据");
		var list = $("#frmFDDataContent").validate().errorList;
		var sErrors = "";
		for(var i=0;i<list.length;i++){
			sErrors += list[i].message + "\n";
		}
		alert("出错了，请检查输入是否合法");
		if(list[0].element){
			try{
				document.getElementsByName(list[0].element.name)[0].focus();
			}catch(e){}
		}
	}

	function saveFormatDocData(){
		frmFDDataContent.target = "_self";  //"保存"不用刷新本页面
		frmFDDataContent.Method.value = "<%=IFormatDocData.FDDATA_SAVE%>";
		frmFDDataContent.Rand.value = randomNumber();
		if(iV_allF()){
			setOldValue();
			bEditHtmlChange = false;
			bEditHtmlChange2 = false;
			openDWDialog();
			frmFDDataContent.submit();
			//resetDWDialog("保存成功",true);
		}else{
			showErrors();
		}
	}

	function previewFormatDocData(){
		AsControl.PopView("/AppConfig/FormatDoc/PreviewNode.jsp","DataSerialNo=<%=sSerialNo%>",
				"dialogWidth=680px;dialogHeight=600px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	}

	function refreshFormatDocData(){
		openDWDialog();
		frmFDDataContent.target = "_self";  //"强制刷新"需要刷新本页面
		frmFDDataContent.Method.value = "<%=IFormatDocData.FDDATA_REFRESH%>";
		frmFDDataContent.Rand.value = randomNumber();
		frmFDDataContent.submit();
	}

	function refreshFormatDocDataForAll(){
		showMess('刷新所有节点可能会比较消耗时间,请耐心等待');
		if(refreshFormatDoc('<%=oData.getDocID()%>','<%=oData.getRecordObjectNo()%>','<%=oData.getRecordObjectType()%>',true)==false){
			alert('刷新失败');
			return;
		}else{
			alert('刷新成功');
		}
		frmFDDataContent.target = "_self";  //"强制刷新"需要刷新本页面
		frmFDDataContent.Method.value = "<%=IFormatDocData.FDDATA_DISPLAY%>";
		frmFDDataContent.Rand.value = randomNumber();
		frmFDDataContent.submit();			
	}
<%	
	if(sMethod.equals(IFormatDocData.FDDATA_DISPLAY) || sMethod.equals(IFormatDocData.FDDATA_SAVE) || sMethod.equals(IFormatDocData.FDDATA_REFRESH))  //1:display
	{
	%>
	if("<%=result%>"=="保存成功！" || "<%=result%>"=="刷新成功！")
		openDWDialog("<br><font color=red><b><%=result%></b></font>,<br><br>重新加载，请耐心等待……");
	else{
		openDWDialog("正在加载中，请耐心等待……");
	}
	var config = new Object();
	var iEle = 0,iTextareaLength = 0;;
	var iEleCount = document.all.length; 
	var aTextarea = new Array(); 
	for(var iEle = 0; iEle < iEleCount; iEle++ ){
		if(document.all[iEle].tagName == "TEXTAREA" && document.all[iEle].getAttribute("rich")!="false")
			aTextarea[iTextareaLength++] = document.all[iEle].id;
	}
	var FDEditorEventHandler;
	var FDEditorDivName = new Array();
	try{
		for (var iEle = 0; iEle < iTextareaLength; iEle++ ){
			//alert("aTextarea[iEle]=" + aTextarea[iEle]);
			editor_generate(aTextarea[iEle]);
			FDEditorDivName[iEle] = "_"+aTextarea[iEle]+"_cMenu";
			//alert("FDEditorDivName[iEle]=" + FDEditorDivName[iEle]);
			//alert(frames[0].document.getElementById("_"+aTextarea[iEle]+"_cMenu"));
		}
	}catch(e){}
	
	FDEditorEventHandler = window.setInterval(checkFDEditor, 1000);
	function checkFDEditor(){
		for(var iEle=0;iEle<iTextareaLength;iEle++){
			//if(frames[0].document.getElementById(FDEditorDivName[iEle])==null){
			if(!document.all['_'+aTextarea[iEle]+'_editor']){
				break;
			}
		}
		autoCloseDWDialog();
		window.clearInterval(FDEditorEventHandler);
	}
	<%
	}
%>	
</script>
<%@ include file="/IncludeEnd.jsp"%>