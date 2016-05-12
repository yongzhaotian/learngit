<%@ page contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//文档编号
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
%>
<html>
<head> 
<title>请输入附件信息</title>
<script type="text/javascript">
	function checkItems(){
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
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
			fileSize = o.AttachmentFileName.files[0].size;
		}
		if(fileSize > 10*1024*1024){
			alert("请选择小于10M文件进行导入！");
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
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AttachmentUpload2.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">
<table align="center">
	<tr>
    		<td class="black9pt"  align="left">
    			<font size="2">请选择一个文件进行导入:</font>
    		</td> 
    	</tr>
    	<tr>
    		<td>   
    			<input type="file" size=60  name="AttachmentFileName"> 
    		</td>
    	</tr>
      	<tr>
      		<td>
      			&nbsp;&nbsp;
    			<input type=hidden name="CompClientID" value="<%=CurComp.getClientID()%>" >
    			<input type=hidden name="DocNo" value="<%=sDocNo%>" >
    			<input type=hidden name="FileName" value="" >
    		</td> 
    	</tr>
    	<tr>
      		<td>
      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="ok" value="确认" onclick="javascript:if(checkItems()) { SelectAttachment.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="Cancel" value="取消" onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
	</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>