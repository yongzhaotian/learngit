<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//�ĵ����
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String isNtfs = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isNtfs"));
	String company=DataConvert.toRealString(iPostChange, (String)CurComp.getParameter("company"));
	if(isNtfs==null) isNtfs="";
	
	ARE.getLog().debug("������sType="+sType+",sObjectNo="+sObjectNo+",isNtfs="+isNtfs);
%>
<html>
<head> 
<title>�����븽����Ϣ</title>
<script type="text/javascript">
	function checkItems(){
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
// 		o.FileName.value=sFileName;	
		o.FileName.value=encodeURI(o.AttachmentFileName.value);
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
			fileSize = o.AttachmentFileName.files[0].size;
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
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/BusinessManage/RetailManage/StoreAttachmentUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">
<table align="center">
	<tr>
    		<td class="black9pt"  align="left">
    			<font size="2">��ѡ��һ���ļ���Ϊ�����ϴ�:</font>
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
<%--     			<input type=hidden name="DocNo" value="<%=sDocNo%>" > --%>
    			<input type=hidden name="Type" value="<%=sType%>" >
    			<input type=hidden name="company" value="<%=company%>" >
    			<input type=hidden name="ObjectNo" value="<%=sObjectNo%>" >
    			<input type=hidden name="FileName" value="" >
    			<input type=hidden name="isNtfs" value="<%=isNtfs %>" >
    		</td> 
    	</tr>
    	<tr>
      		<td>
      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="ok" value="ȷ��" onclick="javascript:if(checkItems()) { SelectAttachment.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
	</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>