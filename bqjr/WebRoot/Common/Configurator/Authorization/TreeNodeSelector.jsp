<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//��ȡ��������ѯ���ƺͲ���
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	
	//����ֵת��Ϊ���ַ���
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
%>
<html>
<head> 
<!-- Ϊ��ҳ������,�벻Ҫɾ������ TITLE �еĿո� -->
<title>��ѡ��������Ϣ
 ���������������������������������� ���������������������������������� ����������������������������������
 ���������������������������������� ���������������������������������� ����������������������������������
</title>
</head>
<body class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>
	<tr> 
		<td id="selectPage">
			<iframe name="ObjectList" width=100% height=100% frameborder=0 =no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
		</td>
	</tr>
	<tr>
		<td nowarp bgcolor="" height="25" align=center  colspan="2"> 
			<input type="button" name="ok" value="ȷ��" onClick="javascript:returnSelection()"  border='1'>
			<input type="button" name="ok" value="���" onClick="javascript:clearAll()"  border='1'>
			<input type="button" name="Cancel" value="ȡ��" onClick="javascript:doCancel();" border='1'>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script language=javascript>
	var sObjectInfo="";
	function returnSelection(){
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
	
	OpenComp("TreeNodeSelectDialog","/Common/Configurator/Authorization/TreeNodeDialog.jsp","SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
</script>
<%@ include file="/IncludeEnd.jsp"%>