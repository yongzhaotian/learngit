<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
	  	页面说明: 选择附件框 
	*/
%>
<html>
<head> 
<title>请输入附件信息</title>
<script type="text/javascript">
	function checkItems(){
		//检查代码合法性		
		var o = document.forms["SelectFile"];
		var sFileName = o.LoadFileName.value;
		o.FileName.value=sFileName;	
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("请选择一个文件名!");
			return false;
		}
		var fileSize;
		if(typeof(ActiveXObject) == "function"){ // IE
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var f1 = fso.GetFile(sFileName);
			fileSize = f1.size;
		}else{
			fileSize = o.LoadFileName.files[0].size;
		}
		if(fileSize > 2*1024*1024){
			alert("文件大于2048k，不能上传！");
			return false;
		}
		return true;
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3">
<form name="SelectFile" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/Frame/Test/file/LoadExcelFile.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">
<table align="center">
	<tr>
   		<td class="black9pt"  align="left">
   			<font size="2">请选择一个文件作为附件上传:</font>
   		</td> 
   	</tr>
   	<tr>
   		<td>   
   			<input type="file" size=60  name="LoadFileName"> 
   		</td>
   	</tr>
   	<tr>
   		<td>      					
   			<input type=hidden name="FileName" value="" >
   		</td> 
   	</tr>
   	<tr>
     	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width:50px"  name="ok" value="确认" onclick="javascript:if(checkItems()) { self.SelectFile.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width:50px"  name="Cancel" value="取消" onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
	</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>