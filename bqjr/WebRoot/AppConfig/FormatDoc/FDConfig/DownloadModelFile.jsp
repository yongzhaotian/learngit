<%@ page language="java" import="com.amarsoft.are.jbo.*,java.io.*" contentType="text/html; charset=GBK" pageEncoding="GBK"%><%
	String sJspFileName = request.getParameter("JspFileName");
	String sHtmlFileName = request.getParameter("HtmlFileName");
	//����ļ�����
	String fileName = sJspFileName;
	if(fileName==null ||"".equals(fileName)) fileName=sHtmlFileName;
	InputStream inStream = request.getSession().getServletContext().getResourceAsStream(fileName);
	if(inStream==null){
		out.println(fileName+":�����ڣ�");
		return;	
	}
	byte abyte0[] = new byte[102400];
	int k = -1;
	while ((k = inStream.read(abyte0, 0, 102400)) != -1) {
	}
	inStream.close();
	//��ʼ���������ļ�
	String sFileName = fileName.substring(fileName.lastIndexOf("/")+1);
	ServletContext sc = request.getSession().getServletContext();
	response.setContentType("unknown");
	response.addHeader("Content-Disposition", "attachment; filename=\""+ sFileName +"\"");
	javax.servlet.ServletOutputStream sout = response.getOutputStream();
	sout.write(abyte0);
	sout.flush();
	sout.close();
%>