<%@ page contentType="text/html; charset=GBK"%><%@ 
 include file="/IncludeBegin.jsp"%><%@ 	
 page import="com.amarsoft.are.jbo.*,com.amarsoft.biz.formatdoc.model.*" %>
 <script>
function checkData(){
	var obj = document.getElementById("fileField");
	var oObjectType = document.getElementById("ObjectType");
	var oObjectNo = document.getElementById("ObjectNo");
	if(oObjectType.value==''){
		alert('�������������');
		oObjectType.focus();
		return false;
	}
	if(oObjectNo.value==''){
		alert('�����������');
		oObjectNo.focus();
		return false;
	}
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
	try{
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var f1 = fso.GetFile(obj.value);	
		if(f1.size>2048*1024){
			alert("�ļ�����2048k�������ϴ�");
			return false;
		}					
	}catch(e){
		//alert(e.name+" "+e.number+" :"+e.message);
	}
	
	var sFileExt = obj.value.substring(iDot+1).toLowerCase();
	if(sFileExt=='amardoc'){
		return true;
	}
	else{
		alert('��֧�������ļ���ʽ��amardoc');
		return false;
	}
}
</script>
<style>
body{
	margin:10px;
}
table{
	
}
</style>
<body>
<form enctype="multipart/form-data" action="SaveUploadFile.jsp?CompClientID=<%=CurComp.getClientID()%>" name="form1" method="post" onSubmit="return checkData()">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td colspan="2" align="center"><strong>�ϴ���ʽ����������</strong></td>
    </tr>
    <tr>
      <td colspan="2" align="left">��������(ObjectType)��
      <input type="text" name="ObjectType" id="ObjectType" /></td>
    </tr>
    <tr>
      <td colspan="2" align="left">������(ObjectNo)��
      <input type="text" name="ObjectNo" id="ObjectNo" /></td>
    </tr>
    <tr>
      <td colspan="2" align="left">ѡ���ϴ��ļ���
      <input type="file" name="fileField" id="fileField" /></td>
    </tr>
    <tr>
      <td align="right"><input type="submit" name="button" id="button" value="�ύ" /></td>
      <td><input type="button" name="close" id="close" value="�ر�" onClick="window.close();"/>
      </td>
    </tr>
  </table>
</form>
</body>
<%@ include file="/IncludeEnd.jsp"%>