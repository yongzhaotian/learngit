<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
	  	ҳ��˵��: ѡ�񸽼��� 
	*/
%>
<html>
<head> 
<title>�����븽����Ϣ</title>
<script type="text/javascript">
	function checkItems(){
		//������Ϸ���		
		var o = document.forms["SelectFile"];
		var sFileName = o.LoadFileName.value;
		o.FileName.value=sFileName;	
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("��ѡ��һ���ļ���!");
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
			alert("�ļ�����2048k�������ϴ���");
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
   			<font size="2">��ѡ��һ���ļ���Ϊ�����ϴ�:</font>
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
		<input type="button" style="width:50px"  name="ok" value="ȷ��" onclick="javascript:if(checkItems()) { self.SelectFile.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
	</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>