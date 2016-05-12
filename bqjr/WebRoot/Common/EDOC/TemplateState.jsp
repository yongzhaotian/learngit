<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.edoc.EDocument"%>
<%@page import="org.jdom.JDOMException"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  fmwu 2008/01/09
		Tester:
		Content: 电子文档模板状态
		Input Param:

		Output param:
	 */
	%>
<%/*~END~*/%>

<%
String sEDocNo = DataConvert.toString((String)CurComp.getParameter("EDocNo"));
String sTagList = "";
String sCheckTagList = "";
String sStateFmt="正常";
String sStateDef="正常";

//格式文件状态
String sFullPathFmt = Sqlca.getString("select FullPathFmt from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
if (sFullPathFmt == null) sFullPathFmt="";
java.io.File dFileFmt=new java.io.File(sFullPathFmt);
if(!dFileFmt.exists())	{
	sStateFmt="<strong><font color=red>文档格式文件不存在，需要重新上传！!</font></strong>";
}
else {
	try {
		sTagList = EDocument.getTagList(sFullPathFmt);
	} catch (IOException e) {
		throw new JDOMException("模板格式文件的格式不符合要求，请重新上传符合要求规范的格式文件");
	}
}

String sFullPathDef = Sqlca.getString("select FullPathDef from EDOC_DEFINE where EDocNo='"+sEDocNo+"'");
if (sFullPathDef == null) sFullPathDef="";
java.io.File dFileDef =new java.io.File(sFullPathDef);
if(!dFileDef.exists())	{
	sStateDef="<strong><font color=red>数据定义文件不存在，需要重新上传！!</font></strong>";
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
<title>电子文档状态</title>
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
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","查看格式文件","查看格式文件","javascript:TemplateViewFmt()",sResourcesPath)%>
		  <%
		  }
		  %>
   		  </td>
          <td>	
		  <%
		  if (dFileDef.exists()) {
	      %>
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","查看数据定义文件","查看数据定义文件","javascript:TemplateViewDef()",sResourcesPath)%>
		  <%
		  }
		  %>
   		  </td>
          <td>	
		  <%
		  if (dFileFmt.exists() && dFileDef.exists()) {
	      %>
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","查看文档示例","查看文档示例","javascript:TemplateViewExample()",sResourcesPath)%>
		  <%
		  }
		  %>
   		  </td>
        </tr>
        <tr>
          <td><b>格式文件状态:</b></td>
          <td><%=sStateFmt%> </td>
        </tr>
        <tr>
          <td><b>数据定义文件状态:</b></td>
          <td><%=sStateDef%> </td>
        </tr>
        <tr>
          <td><b>文档格式文件存在的标签列表:</b></td>
          <td>	
          <TEXTAREA NAME="TagList" ROWS="24" COLS="120"><%=sTagList%></TEXTAREA>
          </td>
        </tr>
        <tr>
          <td><b>数据定义和格式文件标签检查:</b></td>
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
	/*~[Describe=格式文件查看;InputParam=无;OutPutParam=无;]~*/
	function TemplateViewFmt()
	{
		sEDocNo = "<%=sEDocNo%>";
		popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Fmt");
	}

	/*~[Describe=定义文件查看;InputParam=无;OutPutParam=无;]~*/
	function TemplateViewDef()
	{
		sEDocNo = "<%=sEDocNo%>";
		popComp("TemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Def");
	}

	/*~[Describe=生成文件预览;InputParam=无;OutPutParam=无;]~*/
	function TemplateViewExample()
	{
		sEDocNo = "<%=sEDocNo%>";
	    popComp("TemplateViewExample","/Common/EDOC/TemplateViewExample.jsp","EDocNo="+sEDocNo);		
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>