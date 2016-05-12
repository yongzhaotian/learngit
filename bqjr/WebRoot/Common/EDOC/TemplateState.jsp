<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.edoc.EDocument"%>
<%@page import="org.jdom.JDOMException"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  fmwu 2008/01/09
		Tester:
		Content: �����ĵ�ģ��״̬
		Input Param:

		Output param:
	 */
	%>
<%/*~END~*/%>

<%
String sEDocNo = DataConvert.toString((String)CurComp.getParameter("EDocNo"));
String sTagList = "";
String sCheckTagList = "";
String sStateFmt="����";
String sStateDef="����";

//��ʽ�ļ�״̬
String sFullPathFmt = Sqlca.getString("select FullPathFmt from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
if (sFullPathFmt == null) sFullPathFmt="";
java.io.File dFileFmt=new java.io.File(sFullPathFmt);
if(!dFileFmt.exists())	{
	sStateFmt="<strong><font color=red>�ĵ���ʽ�ļ������ڣ���Ҫ�����ϴ���!</font></strong>";
}
else {
	try {
		sTagList = EDocument.getTagList(sFullPathFmt);
	} catch (IOException e) {
		throw new JDOMException("ģ���ʽ�ļ��ĸ�ʽ������Ҫ���������ϴ�����Ҫ��淶�ĸ�ʽ�ļ�");
	}
}

String sFullPathDef = Sqlca.getString("select FullPathDef from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
if (sFullPathDef == null) sFullPathDef="";
java.io.File dFileDef =new java.io.File(sFullPathDef);
if(!dFileDef.exists())	{
	sStateDef="<strong><font color=red>���ݶ����ļ������ڣ���Ҫ�����ϴ���!</font></strong>";
}
else {
	if (dFileFmt.exists()) {
		EDocument doc = new EDocument(sFullPathFmt,sFullPathDef);
		sCheckTagList = doc.checkTag();
	}
}

%>
<html>
<head>
<title>�����ĵ�״̬</title>
</head>

<body leftmargin="0" topmargin="0" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="99%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
    <table width="90%" align=center border="0" cellspacing="0" cellpadding="4">
        <tr>
          <td>&nbsp; </td>
        </tr>
        <tr>
		  <td>
		  <%
		  if (dFileFmt.exists()) {
	      %>
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�鿴��ʽ�ļ�","�鿴��ʽ�ļ�","javascript:TemplateViewFmt()",sResourcesPath)%>
		  <%
		  }
		  %>
   		  </td>
          <td>	
		  <%
		  if (dFileDef.exists()) {
	      %>
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�鿴���ݶ����ļ�","�鿴���ݶ����ļ�","javascript:TemplateViewDef()",sResourcesPath)%>
		  <%
		  }
		  %>
   		  </td>
          <td>	
		  <%
		  if (dFileFmt.exists() && dFileDef.exists()) {
	      %>
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�鿴�ĵ�ʾ��","�鿴�ĵ�ʾ��","javascript:TemplateViewExample()",sResourcesPath)%>
		  <%
		  }
		  %>
   		  </td>
        </tr>
        <tr>
          <td><b>��ʽ�ļ�״̬:</b></td>
          <td><%=sStateFmt%> </td>
        </tr>
        <tr>
          <td><b>���ݶ����ļ�״̬:</b></td>
          <td><%=sStateDef%> </td>
        </tr>
        <tr>
          <td><b>�ĵ���ʽ�ļ����ڵı�ǩ�б�:</b></td>
          <td>	
          <TEXTAREA NAME="TagList" ROWS="24" COLS="120"><%=sTagList%></TEXTAREA>
          </td>
        </tr>
        <tr>
          <td><b>���ݶ���͸�ʽ�ļ���ǩ���:</b></td>
          <td>	
          <TEXTAREA NAME="CheckList" ROWS="10" COLS="120"><%=sCheckTagList%></TEXTAREA>
          </td>
        </tr>
	</table>
	</td>
  </tr>
</table>
</body>
</html>
<script language="javascript">
	/*~[Describe=��ʽ�ļ��鿴;InputParam=��;OutPutParam=��;]~*/
	function TemplateViewFmt()
	{
		sEDocNo = "<%=sEDocNo%>";
		popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Fmt");
	}

	/*~[Describe=�����ļ��鿴;InputParam=��;OutPutParam=��;]~*/
	function TemplateViewDef()
	{
		sEDocNo = "<%=sEDocNo%>";
		popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Def");
	}

	/*~[Describe=�����ļ�Ԥ��;InputParam=��;OutPutParam=��;]~*/
	function TemplateViewExample()
	{
		sEDocNo = "<%=sEDocNo%>";
	    popComp("TemplateViewExample","/Common/EDOC/TemplateViewExample.jsp","EDocNo="+sEDocNo);		
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>