<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//���ҳ�����	
	String sDocNo = CurPage.getParameter("DocNo"); //�ĵ����
%>
<head> 
<title>�����븽����Ϣ</title>

<script type="text/javascript">
	function checkItems(){
		//������Ϸ���
		var o = document.forms["SelectAttachment"];
		var sFileName = o.AttachmentFileName.value;
		o.AttachmentFileName.value = sFileName;
		alert(sFileName);
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
	
	function deleteAttachement(){
		var sDocNo = "<%=sDocNo%>";
		var sAttachmentNo = document.forms("SelectAttachment").AttachmentNo.value;
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0){
			alert("��ѡ��һ���ļ���");
			return;
		}else{
			//alert("sDocNo="+sDocNo+";sAttachmentNo="+sAttachmentNo);
			if(confirm("�������ɾ���ø�����")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.config.document.action.AttachmentOperate","attachmentDelete","DocNo="+sDocNo+",AttachmentNo="+sAttachmentNo);
				if(sReturn =="SUCCEEDED"){
					alert("ɾ���ɹ�!");
					parent.openComponentInMe();
				}
			}
		}
	}

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#e3f5ff">
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/Document/AttachmentUpload.jsp?CompClientID=<%=CurComp.getClientID()%>" align="center">
<table align="center">
	<tr>
   		<td class="black9pt" align="left" colspan="3">
   			<font size="2">�����ļ��Ĺ��̷��������裬��Ҫ���Ӷ���ļ�������������Ҫ�ظ�����������������ɺ��뵥����ȷ�������ص���������</font>
   		</td>
   	</tr>
   	<tr>
   		<td class="black9pt" align="left">
   			<font size="2">1.�����������ѡ���ļ�����������Ŀ��м����ļ���·����</font>
   		</td>
   		<td></td>
   		<td class="black9pt" align="left">
   			<font size="2">2.ͨ�����������ӡ������ļ��ƶ�������������</font>
   		</td>
   	</tr>
	<tr>
   		<td class="black9pt" align="left">
   			<font size="2"><strong>�����ļ���</strong></font>
   		</td>
   		<td></td>
   		<td class="black9pt" align="left">
   			<font size="2"><strong>������</strong></font>
   		</td>
   	</tr>
   	<tr>
   		<td align="left" valign="top">
   			<input type="file" size=45 name="AttachmentFileName">
   			<br>
   			<font size="2">ע�⣺ÿ�������Ĵ�С���ܳ���2MB��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>
   			<input type="button" style="width:50px" name="ok" value="ȷ��" onclick="javascript:top.close(); ">
   		</td>
   		<td align="left" valign="top">
   			<input align="left" type="button" style="width:50px"  name="attach" value="����" onclick="javascript:if(checkItems()) { self.SelectAttachment.submit();} ">
   			<input align="left" type="button" style="width:50px"  name="delete" value="ɾ��" onclick="javascript:deleteAttachement(); ">
   			<input type=hidden name="DocNo" value="<%=sDocNo%>" >
   			<input type=hidden name="FileName" value="" >
   		</td>
   		<td align="left">
		    <select name='AttachmentNo' size='12' style='width:100%;hight:10%;max-height: 20%;overflow: auto' multiple='true'>
			<% 
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select * from doc_attachment where DocNo = :DocNo").setParameter("DocNo", sDocNo));
			while(rs.next()){
		    	java.io.File file = new java.io.File(rs.getString("FULLPATH"));
		    	//System.out.println("========================="+rs.getString("FULLPATH"));
				//if(file.exists() && file.isFile()){
	    			out.println("<option value='"+ rs.getString("ATTACHMENTNO") +"' >" + rs.getString("FILENAME") + "</option>");
	   			//}
			}%>
			</select>
   		</td>
   	</tr>
 </table>
</form>
</body>
<%@	include file="/IncludeEnd.jsp"%>