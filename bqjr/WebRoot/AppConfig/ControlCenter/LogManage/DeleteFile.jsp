<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String file = CurPage.getParameter("file");
	if(file==null){
		out.println("没有传递要删除的文件！");
		return;
	}
	File f = new File(java.net.URLDecoder.decode(file,"GBK"));
	try{
		if(f.delete()){
			out.println("文件\""+f.getName()+"\"删除成功！");
		}else{
			out.println("文件\""+f.getName()+"\"删除失败！");
		}
	}catch(Exception e){
		ARE.getLog().debug(e);
		out.println("<center>");
		out.println("文件\""+f.getName()+"\"删除失败！");
		out.println("<p>错误原因："+e.getMessage());
		out.println("</center>");
	}
%><%@ include file="/IncludeEndAJAX.jsp"%>