<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	/*
		Author:   xdhou  2005.02.25
		Tester:
		Content: ��FORMATDOC_DATA�����ļ�
		Input Param:
			DocID:    formatdoc_catalog�е��ĵ���𣨵��鱨�棬�����鱨�棬...)
			ObjectNo��ҵ����ˮ��

		Output param:
		History Log: 
	 */
	//����������	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sDocID    = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID"));
%>
<html>
<head>
	<title>����������</title>		
	<script type="text/javascript">
		function mykd1(){
			//F3:F5:F11:FullScreen
			if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey) ){
				event.keyCode=0; 
				event.returnValue=false; 
				return false;
			}
		}
		function mykd2(){
			if(myprint10.event.keyCode==114 || myprint10.event.keyCode==116 || myprint10.event.keyCode==122 || (myprint10.event.keyCode==78 && myprint10.event.ctrlKey) ) 	 //F3:F11:FullScreen
			{
				myprint10.event.keyCode=0; 
				myprint10.event.returnValue=false; 
				return false;
			}
		}		
	</script>	
</head>
<body onkeydown=mykd1 >
	<font color=red style="font-size: 16pt;FONT-FAMILY:'����';color:red;background-color:#FFFFFF">
	 ���Ժ�......</font>

	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>
<script type="text/javascript">
	try {	document.body.onkeydown=mykd1; } catch(e) {var a=1;}
	try {	document.onkeydown=mykd1; } catch(e) {var a=1;}
	try {	myprint10.document.body.onkeydown=mykd2; } catch(e) {var a=1;}
	try {	myprint10.document.onkeydown=mykd2; } catch(e) {var a=1;}

	PopPage("/FormatDoc/Report12/<%=sDocID%>.jsp?DocID=<%=sDocID%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo=<%=sSerialNo%>&Method=4&FirstSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
 
	OpenPage("/FormatDoc/PreviewFile.jsp?DocID=<%=sDocID%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self");
</script>
<%@ include file="/IncludeEnd.jsp"%>