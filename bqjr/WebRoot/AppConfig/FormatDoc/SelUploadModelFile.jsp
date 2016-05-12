<%@ page contentType="text/html; charset=GBK"%><%@ 
 include file="/IncludeBegin.jsp"%><%@ 	
 page import="com.amarsoft.are.jbo.*,com.amarsoft.biz.formatdoc.model.*" %>
 <script>
function checkData(){
	var obj = document.getElementById("fileField");
	var oObjectType = document.getElementById("ObjectType");
	var oObjectNo = document.getElementById("ObjectNo");
	if(oObjectType.value==''){
		alert('请输入对象类型');
		oObjectType.focus();
		return false;
	}
	if(oObjectNo.value==''){
		alert('请输入对象编号');
		oObjectNo.focus();
		return false;
	}
	if(obj.value==''){
		alert('请选择上传文件');
		return false;
	}
	var iDot = obj.value.lastIndexOf(".");
	if(iDot==-1){
		alert('非法的文件结构');
		return false;
	}

	//检查代码合法性
	try{
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var f1 = fso.GetFile(obj.value);	
		if(f1.size>2048*1024){
			alert("文件大于2048k，不能上传");
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
		alert('仅支持如下文件格式：amardoc');
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
      <td colspan="2" align="center"><strong>上传格式化离线资料</strong></td>
    </tr>
    <tr>
      <td colspan="2" align="left">对象类型(ObjectType)：
      <input type="text" name="ObjectType" id="ObjectType" /></td>
    </tr>
    <tr>
      <td colspan="2" align="left">对象编号(ObjectNo)：
      <input type="text" name="ObjectNo" id="ObjectNo" /></td>
    </tr>
    <tr>
      <td colspan="2" align="left">选择上传文件：
      <input type="file" name="fileField" id="fileField" /></td>
    </tr>
    <tr>
      <td align="right"><input type="submit" name="button" id="button" value="提交" /></td>
      <td><input type="button" name="close" id="close" value="关闭" onClick="window.close();"/>
      </td>
    </tr>
  </table>
</form>
</body>
<%@ include file="/IncludeEnd.jsp"%>