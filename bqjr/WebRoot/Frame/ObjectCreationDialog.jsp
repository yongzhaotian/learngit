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
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请输入创建 < <%=sObjectTypeName%> > 的参数</title>
</head>

<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>

<%
if(sCreationDialogURL==null || sCreationDialogURL.equals("")){
%>
	<tr> 
			<td id="selectPage" valign=top>
				<p>没有定义对象创建窗口。请在"业务对象类型设置"模块定义 CreationDialog 属性。</p>
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
			<input type="button" name="ok" value="确认" onClick="javascript:doCreatAndReturn()"  border='1'>
			<input type="button" name="Cancel" value="取消" onClick="javascript:doCancel();" border='1'>
		</td>
	</tr>
</form>
</table>

</body>
</html>
<script type="text/javascript">

	/*~[Describe=实现确认功能;InputParam=无;OutPutParam=无;]~*/
	function doCreatAndReturn()
	{
		ObjectCreationInfo.doCreation();
	}
	
	/*~[Describe=实现取消功能;InputParam=无;OutPutParam=无;]~*/	
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
