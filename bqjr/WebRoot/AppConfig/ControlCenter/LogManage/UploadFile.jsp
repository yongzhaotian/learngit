<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.amarsoft.are.*"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.disk.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*"%>
<html>
<head>
<title>�ϴ��ļ�</title>
<SCRIPT TYPE="text/javascript">
// check that file selected
function fileSelected(){
	var filename = document.uploadFileForm.file.value;
	if((filename.length>0) && (filename!="undefined")) 
   		return true;
	else{
	   alert("û��ѡ���ļ���");
	   return false;
   }	
}
</SCRIPT>
</head>
<body>
<%
	if(FileUpload.isMultipartContent(request)){ //�ϴ��������	
		DiskFileItemFactory factory = new DiskFileItemFactory(); //Create a factory for disk-based file items
		factory.setSizeThreshold(102400); //����100K���ļ�����Ҫ����
		ServletFileUpload upload = new ServletFileUpload(factory);//Create a new file upload handler
		upload.setSizeMax(-1); //Set overall request size constraint
		List items = upload.parseRequest(request);
		Iterator iter = items.iterator();
		
		File saveTo = null;
		
		//get folder
		String folder = null;
		while (iter.hasNext()) {
		    FileItem item = (FileItem) iter.next();
		    if (!item.isFormField()) continue;
		    if (item.getFieldName().equals("folder")) {
		    	folder = item.getString();
		    	break;
		    }
		}
		if(folder==null){
			out.println("�ϴ��ļ���λ�ò�������ȷ��");
		}else{
			folder = java.net.URLDecoder.decode(folder,"GBK");
			File fd = new File(folder);
			if(!(fd.exists() && fd.isDirectory())){
				out.println("�ϴ��ļ���λ�ò����ڣ�");
				return;
			}else{
				//�����ļ�
				iter = items.iterator();
				while (iter.hasNext()) {
				    FileItem item = (FileItem) iter.next();
				    if (item.isFormField()) continue;
				    String fileName = item.getName();
				    //���Դ󵨵ļٶ��ϴ����ļ���������windowsϵͳ,��˿�����\�ָ�
				    String fn[] = fileName.split("\\\\");
				    fileName = fn[fn.length-1];
				    try{
				    	saveTo = new File(fd,fileName);
				    	item.write(saveTo);
				    }catch(Exception ex){
				    	out.println("<font color='red'>�ϴ��ļ�<b>\""+fileName+"\"</b>ʧ�ܣ�</font>");
				    	out.println("<p>����ԭ��"+ex.getMessage());
				    }
				    break;
				}
			}
		}
%>
	�ϴ��ļ�"<b><%=saveTo.getName()%>"�ɹ���</b>
<% 		
	}else{//���ϴ��ļ����գ���ʾ�ļ�����Ļ���
		String folder = request.getParameter("folder");
		if(folder==null){
			out.println("�ϴ��ļ��Ĳ�������ȷ��");
		}else{
%>
			<h2>��ѡ��Ҫ�ϴ����ļ���</h2>
			<form method="POST" enctype="multipart/form-data" name="uploadFileForm" action="UploadFile.jsp" onSubmit="return fileSelected()">
				<input type="hidden" name="folder" value="<%=folder%>">
			<table style="width: 100%">
				<tr><td><input type="file" name="file"></td></tr>
				<tr><td><input type="submit" value="�ϴ��ļ�"></td></tr>
			</table>
			</form>
<%		}
	}
%>
<p><input type=button value="�رշ���" onClick="javascript:window.opener.location.reload();window.close();">	
</body>
</html>