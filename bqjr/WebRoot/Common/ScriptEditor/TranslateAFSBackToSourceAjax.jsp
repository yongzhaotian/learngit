<%@page import="com.amarsoft.app.alarm.StringTool"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>
<%
String sReturnValue="";
String sScriptText = CurPage.getParameter("AFScriptSourceAfterEdit");
if (sScriptText==null) sScriptText="";
sScriptText = StringFunction.replace(sScriptText,"$[wave]","~");
sScriptText = Report.transExpression(1,sScriptText.trim(),Sqlca);
sScriptText = SpecialTools.real2Amarsoft(sScriptText);

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sScriptText);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>