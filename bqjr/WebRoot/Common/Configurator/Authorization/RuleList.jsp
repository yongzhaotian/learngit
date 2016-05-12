<%@ page contentType="text/html; charset=GBK"%>
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
<title>授权规则列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Common/Configurator/Authorization/css/style.css" />
</head>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//String sSql; 
	
	//获得组件参数	
	String sSceneId = DataConvert.toString(CurPage.getParameter("SceneID"));
	String sRuleId = DataConvert.toString(CurPage.getParameter("RuleId"));
	//ARE.getLog().debug("sSceneId="+sSceneId);
	//ARE.getLog().debug("sRuleId="+sRuleId);
	
	//String sQueryObject = DataConvert.toString(CurPage.getParameter("QueryObject"));
	//ARE.getLog().debug("sQueryObject="+sQueryObject);
	//ARE.getLog().debug("recordNo======"+CurPage.getParameter("RecordNo"));
	//ARE.getLog().info(com.amarsoft.sadre.cache.RuleScenes.getRuleScenes());
%>
<%/*~END~*/%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%

		SUIQuery query = SQOSimplyFactory.getQueryObject("RuleList");
		//query.addFilter("", arg1);
		query.executeQuery(CurPage, Sqlca,sWebRootPath);
%>
<%
	/*~END~*/
%>
<script src="js/ajaxsbmt.js" type="text/javascript"></script>
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onload="loadAnchor('<%=sRuleId%>')">
<%
		query.generateButtons(out,sWebRootPath);
%>
		<div id="sqddata" style="overflow:auto;width=100%;height=92%">
<%
		out.println(query.generateHTMLScript());
%>
		</div>
</body>
</html>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	function myNew(sceneId){
		OpenPage("/Common/Configurator/Authorization/RuleInfo.jsp?SceneId="+sceneId,"_self","");
	}

	function mydetail(id){
		var Ids = id.split("@");
		OpenPage("/Common/Configurator/Authorization/RuleInfo.jsp?SceneId="+Ids[0]+"&RuleId="+Ids[1],"_self","");
	}
	
	function mydelete(id){
		if(typeof(id)!="undefined" && id.length>0){
			var Ids = id.split("@");		//ruleid@sceneid
			if(confirm("确定要删除规则["+Ids[1]+"]吗?")){
				var reqParams = Ids[1]+","+Ids[0];
				var sReturn = RunMethod("PublicMethod","AuthorDeleteRule",reqParams);
				if(sReturn == "SUCCESSFUL"){
					alert("规则["+Ids[1]+"]删除成功!");
					top.refreshMe();
				}else{
					alert("规则["+Ids[1]+"]删除失败!");
				}
			}
		}else{
			alert("错误的参数:"+id);
		}
	}
	
	function loadAnchor(ruleId){
		window.location.hash = "#"+ruleId;
	}
	
	function jumpTo(){
		var jumpId = document.getElementById("jumpId").value;
		loadAnchor(jumpId);
	}
	
	function myImport(){

		var sParaString = "CurSceneId@<%=sSceneId%>";
		var sReturn = PopPage("/Common/Configurator/Authorization/TreeNodeSelector.jsp?SelName=ImportScene&ParaString="+sParaString,"","dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)!="undefiend" && sReturn!="_CANCEL_" && sReturn!="_CLEAR_"){
			sReturn=sReturn.split("@");
			
			xmlHttp=getXmlHttpObject();
			if (xmlHttp==null){
			  alert ("Your browser does not support AJAX!");
			  return;
			}
			xmlHttp.open("POST", "RuleImport.jsp", true);
			xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			xmlHttp.onreadystatechange=getImportStateChanged;
			
			var reqParmas = "CompClientID=<%=CurComp.getClientID()%>&PageClientID=<%=CurPage.getClientID()%>";
			reqParmas += "&CurScene=<%=sSceneId%>&SceneId="+sReturn[0]+"&RuleId="+sReturn[1]+"&rand1="+randomNumber();
			//alert(reqParmas);
			xmlHttp.send(reqParmas);
			
		}else if(sReturn=="_CLEAR_"){
			return;
		}else{
			return;
		}
	}
	
	function getImportStateChanged() { 
		if (xmlHttp.readyState==4){ 
			//ajaxmessage = xmlHttp.responseText;
			//document.getElementById("MyResult").innerHTML = xmlHttp.responseText;
			//alert(xmlHttp.responseText);
			alert("授权规则保存成功!规则需在重新载入后生效!");
			document.getElementById("new").disabled = false;
			document.getElementById("import").disabled = false;
			parent.refreshMe();
		}else{
			//ajaxmessage = "Loading Data......,Powered by AJAX.";
			document.getElementById("MyResult").innerHTML = "<img src=\"ico/loading.gif\">正在保存...";
			document.getElementById("new").disabled = true;
			document.getElementById("import").disabled = true;
		}
	}
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
