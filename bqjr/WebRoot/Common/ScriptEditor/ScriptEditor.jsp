<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
String sScriptText = CurPage.getParameter("ScriptText");
String sLanguageSpec = CurPage.getParameter("LanguageSpec");
String sScriptLanguage = CurPage.getParameter("ScriptLanguage");
sLanguageSpec  = SpecialTools.real2Amarsoft(sLanguageSpec);
sScriptText = StringFunction.replace(sScriptText,"$[wave]","~");
%>

<HTML>
<table>
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="5">
	<tr height=1>
	    <td>
			<INPUT TYPE="button" text="Script" value="确定" onclick="returnText()">
			<INPUT TYPE="button" text="Script" value="取消" onclick="cancel()">
	    </td>
	</tr>
	<tr>
	    <td>
		<OBJECT
			  id="Amar" Name="Amar"
			  classid="clsid:4AE2D9E0-67A5-4747-9FCE-DE25AB2A669A"
			  codebase="<%=sResourcesPath%>/Cab/AmarWebControls.dll#version=1,0,0,0"
			  width="100%" height="100%" align=center>
		</OBJECT>
	    </td>
	</tr>
</table>

<Script>
	Amar.doAction('SetScript',amarsoft2Real('<%=sScriptText%>'));
	//Amar.doAction('InitByXMLFile','D:\\projects\\u.pf\\credit6\\Resources\\1\\Cab\\test1.xml');
	var sXML ="<%=sLanguageSpec%>";
	//Amar.doAction('InitByXML',amarsoft2Real(sXML));

	function returnText(){
		self.returnValue = real2Amarsoft(Amar.getAction('GetScript',''));
		self.close();
	}
	function cancel(){
		self.close();
	}
</Script>
</HTML>
<%@ include file="/IncludeEnd.jsp"%>