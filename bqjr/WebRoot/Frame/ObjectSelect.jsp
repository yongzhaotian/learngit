<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)request.getParameter("ParaString"));
	if(sParaString==null) sParaString="";
	sParaString = StringFunction.replace(sParaString,"~","&");
	sParaString = StringFunction.replace(sParaString,"^","%");
	ASResultSet rs=null;
	String sSql = "";
	String sObjectAttribute = "";
	String sSelectionDialogURL = "",sSelectionDialogCompID="";
	String sObjectTypeName = "";
	
	sSql = "select ObjectName,ObjectAttribute from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
	rs = SqlcaRepository.getResultSet(sSql);
	if(rs.next()){
		sObjectAttribute = rs.getString("ObjectAttribute");
		sObjectTypeName = rs.getString("ObjectName");
	}
	rs.getStatement().close();
	
	sSelectionDialogURL = StringFunction.getProfileString(sObjectAttribute,"SelectionDialog");
	if(sSelectionDialogURL!=null)	sSelectionDialogURL = sSelectionDialogURL.trim();
	sSelectionDialogCompID = StringFunction.getProfileString(sObjectAttribute,"SelectionDialogCompID");
	if(sSelectionDialogCompID==null || sSelectionDialogCompID.equals(""))
		sSelectionDialogCompID = sObjectType+"SelectionDialog";
%>
<html>
<head> 
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择<%=sObjectTypeName%>
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>

<%
if(sSelectionDialogURL==null || sSelectionDialogURL.equals("")){
%>
	<tr> 
			<td id="selectPage" valign=top>
				<p>没有定义对象选择窗口。请在"业务对象类型设置"模块定义 SelectionDialog 属性。</p>
			</td>
	</tr>
<%
}else{
%>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectList" width=100% height=100% frameborder=0 =no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
	
<%
}
%>
	<tr>
		<td nowarp bgcolor="" height="25" align=center  colspan="2"> 
			<input type="button" name="ok" value="确认" onClick="javascript:returnSelection()"  border='1'>
			<input type="button" name="ok" value="清空" onClick="javascript:clearAll()"  border='1'>
			<input type="button" name="Cancel" value="取消" onClick="javascript:doCancel();" border='1'>
		</td>
	</tr>
</form>
</table>

</body>
</html>
<script type="text/javascript">
	var sObjectInfo="";
	function returnSelection()
	{		
		if(sObjectInfo==""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
		self.returnValue=sObjectInfo;
		self.close();
	}

	function clearAll()
	{
		self.returnValue='_CLEAR_';
		self.close();
	
	}

	function doCancel()
	{
		self.returnValue='_CANCEL_';
		self.close();
	}
	<%
	if(sSelectionDialogURL!=null && !sSelectionDialogURL.equals("")){
		%>
		OpenComp("<%=sSelectionDialogCompID%>","<%=sSelectionDialogURL%>","<%=sParaString%>","ObjectList","");
		<%
	}
	%>
</script>

<%@ include file="/IncludeEnd.jsp"%>
