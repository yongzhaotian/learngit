<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
/*
 * Content: 设置Session 属性
 * Input Param:
 *			session属性:	attributeName
 *			session值:	attributeValue
 *
 */
	//获取表名、列名和格式
	String	attributeName		 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("attributeName"));
	String	attributeValue 	 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("attributeValue"));
	session.setAttribute(attributeName, attributeValue);
	
%><%@ include file="/IncludeEndAJAX.jsp"%>