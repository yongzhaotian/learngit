<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.amarsoft.are.*"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.disk.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*"%>
<html>
<head>
<title>上传文件</title>
<SCRIPT TYPE="text/javascript">
// check that file selected
function fileSelected(){
	var filename = document.uploadFileForm.file.value;
	if((filename.length>0) && (filename!="undefined")) 
   		return true;
	else{
	   alert("没有选择文件！");
	   return false;
   }	
}
</SCRIPT>
</head>
<body>
<%
	if(FileUpload.isMultipartContent(request)){ //上传处理接收	
		DiskFileItemFactory factory = new DiskFileItemFactory(); //Create a factory for disk-based file items
		factory.setSizeThreshold(102400); //大于100K的文件，需要缓冲
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
			out.println("上传文件的位置参数不正确！");
		}else{
			folder = java.net.URLDecoder.decode(folder,"GBK");
			File fd = new File(folder);
			if(!(fd.exists() && fd.isDirectory())){
				out.println("上传文件的位置不存在！");
				return;
			}else{
				//保存文件
				iter = items.iterator();
				while (iter.hasNext()) {
				    FileItem item = (FileItem) iter.next();
				    if (item.isFormField()) continue;
				    String fileName = item.getName();
				    //可以大胆的假定上传的文件都来自于windows系统,因此可以用\分割
				    String fn[] = fileName.split("\\\\");
				    fileName = fn[fn.length-1];
				    try{
				    	saveTo = new File(fd,fileName);
				    	item.write(saveTo);
				    }catch(Exception ex){
				    	out.println("<font color='red'>上传文件<b>\""+fileName+"\"</b>失败！</font>");
				    	out.println("<p>错误原因："+ex.getMessage());
				    }
				    break;
				}
			}
		}
%>
	上传文件"<b><%=saveTo.getName()%>"成功！</b>
<% 		
	}else{//非上传文件接收，显示文件浏览的画面
		String folder = request.getParameter("folder");
		if(folder==null){
			out.println("上传文件的参数不正确！");
		}else{
%>
			<h2>请选择要上传的文件：</h2>
			<form method="POST" enctype="multipart/form-data" name="uploadFileForm" action="UploadFile.jsp" onSubmit="return fileSelected()">
				<input type="hidden" name="folder" value="<%=folder%>">
			<table style="width: 100%">
				<tr><td><input type="file" name="file"></td></tr>
				<tr><td><input type="submit" value="上传文件"></td></tr>
			</table>
			</form>
<%		}
	}
%>
<p><input type=button value="关闭返回" onClick="javascript:window.opener.location.reload();window.close();">	
</body>
</html>