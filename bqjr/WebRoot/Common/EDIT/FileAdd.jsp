<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xdhou 2004.03.24
 * Tester:
 * Content: �ϴ��ļ�
 * Input Param:
 *                  SerialNo:��ˮ��-Ŀ¼��
 * Output param:
 * History Log:     
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
    String sSerialNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
%>
<html>
<head> 
<title>�����ļ�</title>

<script type="text/javascript">

	function checkItems(){
		//������Ϸ���
		        
       
		var sFileName="",sDelay="";

		sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;		
		if (sFileName=="")			
		{
			alert("��ѡ��һ���ļ���!");
			return false;
		}	

		/*
		try {
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var f1 = fso.GetFile(SelectAttachment.AttachmentFileName.value);			
		}catch(e) {
			alert(e.name+" "+e.number+" :"+e.message);
		}
		
		if(f1.size>800*1024) {alert("�ļ�����800k�������ϴ���");return false;}
		*/
		
		return true;
	}	   
	
	function myclick()
	{
		if(checkItems()) 
		{ 
			/*
			var sFileName="";
						
			sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;	
	        var pos = 0;
	        var i = 0;
	        var start = 0;
	        var end = 0;
	        pos = sFileName.lastIndexOf("/");
	        if(pos != -1)
	            sFileName =  sFileName.substring(pos + 1, sFileName.length);
	        pos = sFileName.lastIndexOf("\\");
	        if(pos != -1)
	            sFileName = sFileName.substring(pos + 1, sFileName.length);

			window.opener.HtmlEdit.document.body.innerHTML = window.opener.HtmlEdit.document.body.innerHTML+"<br><img src='<%=sWebRootPath%>/FormatDoc/Upload/<%=sSerialNo%>_"+sFileName+"'>";
			*/
			 
			self.SelectAttachment.submit();
		}
	}
</script>

</head>
<body bgcolor="#D3D3D3">
<table align = "center">
<tr>
	<td>
		<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/Common/EDIT/FileUpload.jsp?SerialNo=<%=sSerialNo%>">
			��ѡ��һ���ļ���Ϊ�����ϴ��� <p>	
			<input type="file" size=30  name="AttachmentFileName"> <p>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="ok" value="ȷ��" onclick="javascipt:myclick();">&nbsp;&nbsp; 
			<input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:self.returnValue='_none_';self.close()">
		</form>
	</td>
</tr>
<tr>
	<td>
		��ʾ����������ͼƬ�������룬ѡ��ͼƬ���밴Ctrl+X��Ȼ��ѹ��ͣ����Ҫ�����λ�ã��ٰ�Ctrl+V��
	</td>
</tr>
</table>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>