<%@page import="com.amarsoft.app.flow.ui.*,java.awt.GraphicsEnvironment"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	out.clear();
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	response.setContentType("image/jpeg");

	if (!GraphicsEnvironment.isHeadless()) { 
		System.setProperty("java.awt.headless", "true"); 
	 }
	
	String sFlowNo = CurPage.getParameter("flowNo");
	String sObjectType = CurPage.getParameter("objectType");
	String sObjectNo = CurPage.getParameter("objectNo");

	ImageCreator creator = new ImageCreator(sFlowNo, sObjectType, sObjectNo, Sqlca,
			request.getSession().getServletContext().getRealPath("/Frame/page/resources/images/flow"));
	//将图像输出到servlet输出流中。
	ServletOutputStream sos = response.getOutputStream();
	creator.run(sos);
	//out.println("图片创建成功");
	sos.flush();
	sos.close();
	out.clear(); 
	out = pageContext.pushBody(); 
%><%@ include file="/IncludeEndAJAX.jsp"%>