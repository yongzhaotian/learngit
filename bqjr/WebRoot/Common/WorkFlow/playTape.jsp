<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%

String sWmaURL = DataConvert.toRealString(iPostChange,CurComp.getParameter("WmaURL"));
if (sWmaURL == null) sWmaURL = "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>Insert title here</title>
</head>
<body>
<object id="mPlayer1" width=500 height=200 classid="CLSID:6BF52A52-394A-11D3-B153-00C04F79FAA6">
   <param name="URL" value="<%=sWmaURL%>">
   <param name="rate" value="1">
   <param name="balance" value="0">
   <param name="defaultFrame" value>
   <param name="playCount" value="1">
   <param name="currentMarker" value="0">
   <param name="invokeURLs" value="1">
   <param name="baseURL" value>
   <param name="volume" value="100">
   <param name="mute" value="0">
   <param name="uiMode" value="full">
   <param name="stretchToFit" value="1">
   <param name="windowlessVideo" value="0">
   <param name="enabled" value="1">
   <param name="enableContextMenu" value="1">
   <param name="fullScreen" value="0">
   <param name="SAMIStyle" value>
   <param name="SAMILang" value>
   <param name="SAMIFilename" value>
   <param name="captioningID" value>
   <param name="enableErrorDialogs" value="0">
   <param name="_cx" value="7779">
   <param name="_cy" value="1693">
 </object>   
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
