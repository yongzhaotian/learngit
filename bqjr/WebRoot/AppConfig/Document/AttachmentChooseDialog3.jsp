<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//�ĵ����
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	//��ȡ�жϴ�ǰ���Ǵ�������ݲ���
	String uploadPeriod = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("uploadPeriod"));
	if (sTypeNo == null) sTypeNo = "";
	if (sDocNo == null) sDocNo = "";
	if (uploadPeriod == null) uploadPeriod = "";
%>
<html>
<head> 
<title>�����븽����Ϣ</title>
<script type="text/javascript">
	function checkItems(){
		var ItemArray = ["GIF","JPEG","JPG","PNG"];
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
		if (typeof(sFileName) == "undefined" || sFileName==""){
			alert("��ѡ��һ���ļ���!");
			return false;
		}
		var ItemStr =sFileName.split(".");
		var index =$.inArray(ItemStr[ItemStr.length-1].toUpperCase(),ItemArray);

		if(index==-1){
			alert("�ϴ�ʧ�ܣ�Ӱ�����ϱ�����gif,jpeg,jpg,png�е�һ��");
			return false;
		}
		o.FileName.value=sFileName;
		
		

		return true;
	}	   

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#D3D3D3">
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AttachmentUpload3.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">
<table align="center"  style="margin-top: 20px;">
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
    			<input type=hidden name="DocNo" value="<%=sDocNo%>" >
    			<input type=hidden name="TypeNo" value="<%=sTypeNo%>"/>
    			<input type=hidden name="FileName" value="" >
    			<!-- ���ݴ�ǰ�������� -->
    			<input type=hidden name="uploadPeriod" value="<%=uploadPeriod%>" />
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