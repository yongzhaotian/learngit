<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDocId = CurPage.getParameter("DocID");
	String sDirId = CurPage.getParameter("DirID");
%>
<style>
body{
	margin:10px;
}
table{
	
}
</style>
<body>
<form enctype="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/FormatDoc/FDConfig/SaveUploadModelFile.jsp?CompClientID=<%=CurComp.getClientID()%>" name="form1" method="post" onSubmit="return checkData()">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td colspan="2" align="center"><strong>�ϴ�ģ���ļ�</strong></td>
    </tr>
    <tr>
      <td width="50%">��ʽ�������ţ�<%=sDocId%></td>
      <td width="50%">�ڵ��ţ�<%=sDirId%></td>
    </tr>
    <tr>
      <td colspan="2" align="left">ѡ���ϴ��ļ���
      <input type="file" size="55" name="fileField" id="fileField" /></td>
    </tr>
    <tr>
      <td align="right"><input type="submit" name="button" id="button" value="�ύ" /></td>
      <td><input type="button" name="close" id="close" value="�ر�" onClick="window.close();"/>
      	<input type="hidden" name="DOCID" value="<%=sDocId%>">
      	<input type="hidden" name="DIRID" value="<%=sDirId%>">
      </td>
    </tr>
  </table>
</form>
</body>
<script>
function checkData(){
	var obj = document.getElementById("fileField");
	var sFileName = obj.value;
	if(obj.value==''){
		alert('��ѡ���ϴ��ļ�');
		return false;
	}
	var iDot = obj.value.lastIndexOf(".");
	if(iDot==-1){
		alert('�Ƿ����ļ��ṹ');
		return false;
	}

	//������Ϸ���
	var fileSize;
	if(typeof(ActiveXObject) == "function"){ // IE
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var f1 = fso.GetFile(sFileName);
		fileSize = f1.size;
	}else{
		fileSize = obj.files[0].size;
	}
	if(fileSize > 2*1024*1024){
		alert("�ļ�����2048k�������ϴ���");
		return false;
	}
	
	var sFileExt = obj.value.substring(iDot+1).toLowerCase();
	if(sFileExt=='html' || sFileExt=='htm' || sFileExt=='xhtml'){
		return true;
	}else{
		alert('��֧�������ļ���ʽ��htm,html,xhtml');
		return false;
	}
}
</script>
<%@ include file="/IncludeEnd.jsp"%>