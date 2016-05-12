<%@page contentType="text/html; charset=GBK"%><%@
page buffer="64kb" errorPage="/Frame/page/control/ErrorPage.jsp"%><%@
page import="com.amarsoft.are.ARE"%><%@
page import="com.amarsoft.awe.RuntimeContext"%><%@
page import="com.amarsoft.awe.control.model.ComponentSession"
%><%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);
try{
	RuntimeContext CurARC= (RuntimeContext)session.getAttribute("CurARC");
	if(CurARC != null)  {
		String sToDestroyClientID = (String)request.getParameter("ToDestroyClientID");
		ComponentSession compSession = (ComponentSession)CurARC.getCompSession();
		if(sToDestroyClientID!=null && !"null".equals(sToDestroyClientID)){
			compSession.lookUpAndDestroy(sToDestroyClientID);
		}
	}
}catch(Exception e){
	e.printStackTrace();
	ARE.getLog().error(e.getMessage(),e);
}
%>