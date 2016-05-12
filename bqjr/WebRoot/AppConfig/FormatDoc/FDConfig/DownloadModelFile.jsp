<%@ page language="java" import="com.amarsoft.are.jbo.*,java.io.*" contentType="text/html; charset=GBK" pageEncoding="GBK"%><%
	String sJspFileName = request.getParameter("JspFileName");
	String sHtmlFileName = request.getParameter("HtmlFileName");
	//获得文件内容
	String fileName = sJspFileName;
	if(fileName==null ||"".equals(fileName)) fileName=sHtmlFileName;
	InputStream inStream = request.getSession().getServletContext().getResourceAsStream(fileName);
	if(inStream==null){
		out.println(fileName+":不存在！");
		return;	
	}
	byte abyte0[] = new byte[102400];
	int k = -1;
	while ((k = inStream.read(abyte0, 0, 102400)) != -1) {
	}
	inStream.close();
	//开始生成下载文件
	String sFileName = fileName.substring(fileName.lastIndexOf("/")+1);
	ServletContext sc = request.getSession().getServletContext();
	response.setContentType("unknown");
	response.addHeader("Content-Disposition", "attachment; filename=\""+ sFileName +"\"");
	javax.servlet.ServletOutputStream sout = response.getOutputStream();
	sout.write(abyte0);
	sout.flush();
	sout.close();
%>