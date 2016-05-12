<%@ page contentType="text/html; charset=GBK"%><%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

com.amarsoft.awe.RuntimeContext CurARC = (com.amarsoft.awe.RuntimeContext)session.getAttribute("CurARC");
if(CurARC == null) throw new Exception("------Timeout------");

try{
	String sSelectSkin = request.getParameter("SelectSkin");
	CurARC.setAttribute("Skin", sSelectSkin);
	out.print("SUCCEEDED");
}catch(Exception e){
    e.printStackTrace();
    com.amarsoft.are.ARE.getLog().error(e.getMessage(),e);
    throw e;
}%>