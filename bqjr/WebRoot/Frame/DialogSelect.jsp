<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	if(sParaString == null) sParaString = "";
	
	ASResultSet rs=null;
	String sSql = "";
	String sSelBrowseMode = "";
	String sAttribute4 = "";
	String sTips = "";
		
	sSql = " select SelBrowseMode,Attribute4 from SELECT_CATALOG where SelName = '"+sSelName+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sSelBrowseMode = rs.getString("SelBrowseMode");	
		sAttribute4 = rs.getString("Attribute4");
		if(sSelBrowseMode == null) sSelBrowseMode = "";
		if(sAttribute4 == null) sAttribute4 = "";
	}
	rs.getStatement().close();
%>
<html>
<head> 
<!-- Ϊ��ҳ������,�벻Ҫɾ������ TITLE �еĿո� -->
<title>��ѡ��������Ϣ
 ���������������������������������� ���������������������������������� ����������������������������������
 ���������������������������������� ���������������������������������� ����������������������������������
</title>
</head>
<body class="pagebackground" style="overflow: auto;overflow-x:visible;overflow-y:visible">
<table width="100%" border='0' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>

<%
if(sSelBrowseMode.equals("")){
%>
	<tr> 
			<td id="selectPage" valign=top>
				<p>û�ж������ѡ�񴰿ڡ�����"��������ѡ������"ģ�鶨�� SelBrowseMode ���ԡ�</p>
			</td>
	</tr>
<%
}else{
	if(sAttribute4.equals("1")){ //��Ҫ���ݼ����������в�ѯ���������ʾ��
%>
	<tr style='width:100%; height:1px'>
	<td><font style=' font-size: 9pt;FONT-FAMILY:����;color:red;'>��������Ӧ�Ĳ�ѯ�������������ѯ����ť��ò�ѯ�����</font></td>
	</tr>
<% 
	}
%>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectList" width=100% height=100% frameborder=0 scrolling=no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
<%
}
%>
	<tr>
		<td nowarp bgcolor="#f6fbfe" height="25" align=center valign="middle" colspan="2" style="border-top:1px solid #6c8aa2"> 
			<input type="button" name="ok" value="ȷ��" onClick="javascript:returnSelection()"  border='1'>
			<input type="button" name="ok" value="���" onClick="javascript:clearAll()"  border='1'>
			<input type="button" name="Cancel" value="ȡ��" onClick="javascript:doCancel();" border='1'>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script type="text/javascript">
	var sObjectInfo="";
	function returnSelection(){
		sSelBrowseMode = "<%=sSelBrowseMode%>";
		if(sSelBrowseMode == "Grid")
			ObjectList.returnValue();			
		else{
			//�������ͼ�Ļ�
			ObjectList.getMulti();
		}
		
		if(sObjectInfo==""){
			if(confirm("����δ����ѡ��ȷ��Ҫ������")){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
		top.returnValue=sObjectInfo;
		top.close();
	}

	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}

	function doCancel(){
		top.returnValue='_CANCEL_';
		top.close();
	}

	/*~[Describe=֧��ESC�ر�ҳ��;InputParam=��;OutPutParam=��;]~*/
	document.onkeydown = function(){
		if(event.keyCode==27){
			top.returnValue = "_CANCEL_"; 
			top.close();
		}
	};
	
	<%
	if(sSelBrowseMode!=null && !sSelBrowseMode.equals("")){
		if(sSelBrowseMode.equals("Grid")){
		%>		
		OpenComp("SelectGridDialog","/Frame/SelectGridDialog.jsp","SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
		<%
		}else if(sSelBrowseMode.equals("TreeView")){
		%>
		OpenComp("SelectTreeViewDialog","/Frame/SelectTreeViewDialog.jsp","SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
		<%
		}
	}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>