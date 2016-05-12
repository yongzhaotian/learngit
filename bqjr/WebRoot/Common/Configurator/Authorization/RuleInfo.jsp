<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.sadre.jsr94.admin.RuleImpl"%>
<%@page import="com.amarsoft.sadre.app.ui.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zllin 2011-01-06
		Tester: 
		Content: 
		Input Param:
			ThreadID	场景项下的规则列表
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>授权规则详情</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Common/Configurator/Authorization/css/style.css" />
</head>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//String sSql; 
	
	//获得组件参数	
	String sSceneId = DataConvert.toString(CurPage.getParameter("SceneId"));
	String sRuleId = DataConvert.toString(CurPage.getParameter("RuleId"));
	ARE.getLog().debug("sSceneId="+sSceneId);
	ARE.getLog().debug("sRuleId="+sRuleId);
%>
<%/*~END~*/%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%

		SUIQuery query = SQOSimplyFactory.getQueryObject("RuleInfo");
		//query.executeQuery(CurPage, Sqlca);
		query.executeQuery(CurPage, Sqlca,sWebRootPath);
%>
<%
	/*~END~*/
%>
<script src="<%=sWebRootPath%>/Common/Configurator/Authorization/js/ajaxsbmt.js" type="text/javascript"></script>
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" >
<%
		query.generateButtons(out,sWebRootPath);
%>
		<div id="sqddata" style="overflow:auto;width=100%;height=92%">
			<form id="RuleDetail" method="post" action="<%=sWebRootPath%>/Common/Configurator/Authorization/RuleProc.jsp">
				<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
				<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
<%
		out.println(query.generateHTMLScript());
%>
			</form>
		</div>
</body>
</html>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	
	function myAdd(){
		
		var includeDMS = document.getElementById("DimensionIds").value;
		var sReturn = PopPage("/Common/Configurator/Authorization/ElementSelect.jsp?iniString="+includeDMS+"&type=SceneDimension&sceneId=<%=sSceneId%>","","dialogWidth=550px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_" || sReturn=="_CLEAR_"){
			return ;		//do nothing
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//没有做出选择
			
			xmlHttp=getXmlHttpObject();
			if (xmlHttp==null){
			  alert ("Your browser does not support AJAX!");
			  return;
			}
			xmlHttp.open("POST", "Add2Rule.jsp", true);
			xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			xmlHttp.onreadystatechange=getAddStateChanged;
			var reqParmas = "currentDMS="+selectedValue[0]+"&privouseDMS="+includeDMS;
			reqParmas += "&CompClientID=<%=sCompClientID%>";
			//alert(reqParmas);
			xmlHttp.send(reqParmas);
		}
	}
	
	function getAddStateChanged() { 
		if (xmlHttp.readyState==4){ 
			document.getElementById("dmsdata").innerHTML = xmlHttp.responseText;
			document.getElementById("add").disabled = false;
			//document.getElementById("DimensionIds").value = dmsAfterAdd;
		}else{
			document.getElementById("dmsdata").innerHTML = "<img src=\"<%=sWebRootPath%>/Common/Configurator/Authorization/ico/loading.gif\">正在添加...";
			document.getElementById("add").disabled = true;
		}
	}
	
	function mySave(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		xmlHttp.open("POST", "RuleProc.jsp", true);
		xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xmlHttp.onreadystatechange=getSaveStateChanged;
		var reqParmas = getquerystring("RuleDetail")+"&rand1="+randomNumber();
		//alert(reqParmas);
		xmlHttp.send(reqParmas);
	}
	
	function getSaveStateChanged() { 
		if (xmlHttp.readyState==4){ 
			//ajaxmessage = xmlHttp.responseText;
			document.getElementById("MyResult").innerHTML = xmlHttp.responseText;
			document.getElementById("return").disabled = false;
			document.getElementById("save").disabled = false;
		}else{
			//ajaxmessage = "Loading Data......,Powered by AJAX.";
			document.getElementById("MyResult").innerHTML = "<img src=\"<%=sWebRootPath%>/Common/Configurator/Authorization/ico/loading.gif\">正在保存...";
			document.getElementById("return").disabled = true;
			document.getElementById("save").disabled = true;
		}
	}
	
	function myReturn(sceneId){
		OpenPage("/Common/Configurator/Authorization/RuleList.jsp?SceneID="+sceneId+"&RuleId=<%=sRuleId%>","_self","");
	}
	
	function doSelection(id){
		
		if(typeof(id)=="undefined" || id.length==0){
			alert("授权维度编号["+id+"]非法!");
			return;
		}
		
		var objForm = document.forms["RuleDetail"];
		var selectionIds = objForm.elements["sadre_value_"+id].value;
		if(typeof(selectionIds)=="undefined"){
			return;
		}
		
		var sReturn = PopPage("/Common/Configurator/Authorization/ElementSelect.jsp?iniString="+selectionIds+"&type=RuleConf&dimensionID="+id+"&rand="+randomNumber(),"","dialogWidth=550px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_" || sReturn=="_CLEAR_"){
			return ;		//do nothing
		}
		
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//没有做出选择
			objForm.elements["sadre_value_"+id].value = selectedValue[0];
			
			var selectionNames = objForm.elements["name_text_"+id].value;
			if(typeof(selectionNames)=="undefined"){
				return;
			}
			objForm.elements["name_text_"+id].value = selectedValue[1];
		}
		
	}
	
	function doImportVar(id){
		if(typeof(id)=="undefined" || id.length==0){
			alert("授权参数编号["+id+"]非法!");
			return;
		}
		
		var sReturn = PopPage("/Common/Configurator/Authorization/TreeNodeSelector.jsp?SelName=DIMENSION&ParaString=type@Number","","dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
			return ;		//do nothing
		}
		var objForm = document.forms["RuleDetail"];
		if(sReturn=="_CLEAR_"){
			objForm.elements["sadre_value_"+id].value = "";
			return;
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//没有做出选择
			objForm.elements["sadre_value_"+id].value = selectedValue[0];
		}
	}
	
	function selectRefRule(){
		
		var objForm = document.forms["RuleDetail"];
		var refRules = objForm.elements["RefRules"].value;
		if(typeof(refRules)=="undefined"){
			return;
		}
		//取规则类型,只有独立规则才允许选择前置规则
		var obj = document.all.RuleType;
        if(typeof(obj)!="undefined" || obj.length!=0){
           for(var i=0;i<obj.length;i++){
             if(obj[i].checked && obj[i].value =="1"){
				var currentRule = objForm.elements["RuleId"].value;
				var sReturn = PopPage("/Common/Configurator/Authorization/ElementSelect.jsp?iniString="+refRules+"&type=RefRule&SceneId=<%=sSceneId%>&currentRule="+currentRule,"","dialogWidth=550px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
				if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
					return ;		//do nothing
				}
				if(sReturn=="_CLEAR_"){
					objForm.elements["RefRules"].value="";
					return;
				}
				var selectedValue = sReturn.split("@");
				if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//没有做出选择
					objForm.elements["RefRules"].value = selectedValue[0];
				}
             }
           }
        } 
	}
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
