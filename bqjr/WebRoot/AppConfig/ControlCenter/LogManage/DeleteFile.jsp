<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String file = CurPage.getParameter("file");
	if(file==null){
		out.println("û�д���Ҫɾ�����ļ���");
		return;
	}
	File f = new File(java.net.URLDecoder.decode(file,"GBK"));
	try{
		if(f.delete()){
			out.println("�ļ�\""+f.getName()+"\"ɾ���ɹ���");
		}else{
			out.println("�ļ�\""+f.getName()+"\"ɾ��ʧ�ܣ�");
		}
	}catch(Exception e){
		ARE.getLog().debug(e);
		out.println("<center>");
		out.println("�ļ�\""+f.getName()+"\"ɾ��ʧ�ܣ�");
		out.println("<p>����ԭ��"+e.getMessage());
		out.println("</center>");
	}
%><%@ include file="/IncludeEndAJAX.jsp"%>