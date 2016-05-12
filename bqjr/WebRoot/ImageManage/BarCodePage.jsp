<!DOCTYPE html>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//获得组件参数 条形码值
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if( sObjectNo == null ) sObjectNo = "";
	
%>

<html>
<head>
<title>条形码打印</title>
</head>
<body>
	<object id="amarsoftECMObject" classid="clsid:FED91F2B-DDF8-42E7-9CBF-6FA56B80EDF3" codebase="AmarECM_ActiveXSetup.CAB#version=1,0,0" width="100%" border="0" style="margin:0px;border-width: 0;padding-top: 0px;"></object>
	<script type="text/javascript" >
           function initActiveX() {
               var obj = document.getElementById("amarsoftECMObject");
               obj.height = 0;
               obj.ShowBarCodePrintWindow( "<%=sObjectNo%>" );
           }
           
       	$(document).ready(function(){
       		initActiveX();
       		window.close();
    	});
      </script>
</body>
</html>



<%@ include file="/IncludeEnd.jsp"%>