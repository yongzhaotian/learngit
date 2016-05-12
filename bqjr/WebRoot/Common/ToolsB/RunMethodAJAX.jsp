<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	 String sClassName = CurPage.getParameter("ClassName");
	String sMethodName = CurPage.getParameter("MethodName");
	String sArgs = CurPage.getParameter("Args"); 
	
	ASMethod method = new ASMethod(sClassName,sMethodName,Sqlca);
	Any anyValue  = method.execute(sArgs);
	out.print(anyValue.toStringValue()); 
%><%@ include file="/IncludeEndAJAX.jsp"%>