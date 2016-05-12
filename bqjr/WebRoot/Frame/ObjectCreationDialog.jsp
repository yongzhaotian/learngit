<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")).trim();
	String sParaString = DataConvert.toRealString(iPostChange,(String)request.getParameter("ParaString"));
	if(sParaString==null) sParaString="";
	sParaString = StringFunction.replace(sParaString,"~","&");
	
	ASResultSet rs=null;
	String sSql = "";
	String sObjectAttribute = "";
	String sCreationDialogURL = "",sCreationDialogCompID="";
	String sObjectTypeName = "";
	
	sSql = "select ObjectName,ObjectAttribute from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
	rs = SqlcaRepository.getResultSet(sSql);
	if(rs.next()){
		sObjectAttribute = rs.getString("ObjectAttribute").trim();
		sObjectTypeName = rs.getString("ObjectName").trim();
	}
	rs.getStatement().close();
	
	sCreationDialogURL = StringFunction.getProfileString(sObjectAttribute,"CreationDialog");
	sCreationDialogCompID = StringFunction.getProfileString(sObjectAttribute,"CreationDialogCompID");
	if(sCreationDialogCompID==null || sCreationDialogCompID.equals(""))
		sCreationDialogCompID = sObjectType+"CreationDialog";
	
%>
<html>
<head> 
<!-- Ϊ��ҳ������,�벻Ҫɾ������ TITLE �еĿո� -->
<title>�����봴�� < <%=sObjectTypeName%> > �Ĳ���</title>
</head>

<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>

<%
if(sCreationDialogURL==null || sCreationDialogURL.equals("")){
%>
	<tr> 
			<td id="selectPage" valign=top>
				<p>û�ж�����󴴽����ڡ�����"ҵ�������������"ģ�鶨�� CreationDialog ���ԡ�</p>
			</td>
	</tr>
<%
}else{
%>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectCreationInfo" width=100% height=100% frameborder=0 =no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
	
<%
}
%>
	<tr>
		<td nowarp bgcolor="" height="25" align=center  colspan="2"> 
			<input type="button" name="ok" value="ȷ��" onClick="javascript:doCreatAndReturn()"  border='1'>
			<input type="button" name="Cancel" value="ȡ��" onClick="javascript:doCancel();" border='1'>
		</td>
	</tr>
</form>
</table>

</body>
</html>
<script type="text/javascript">

	/*~[Describe=ʵ��ȷ�Ϲ���;InputParam=��;OutPutParam=��;]~*/
	function doCreatAndReturn()
	{
		ObjectCreationInfo.doCreation();
	}
	
	/*~[Describe=ʵ��ȡ������;InputParam=��;OutPutParam=��;]~*/	
	function doCancel()
	{
		self.returnValue='_CANCEL_';
		self.close();
	}
	<%
	if(sCreationDialogURL!=null && !sCreationDialogURL.equals("")){
		%>
		OpenComp("<%=sCreationDialogCompID%>","<%=sCreationDialogURL%>","<%=sParaString%>","ObjectCreationInfo","");
		<%
	}
	%>
</script>

<%@ include file="/IncludeEnd.jsp"%>
