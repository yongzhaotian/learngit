<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
/*
 * Content: ����Session ����
 * Input Param:
 *			session����:	attributeName
 *			sessionֵ:	attributeValue
 *
 */
	//��ȡ�����������͸�ʽ
	String	attributeName		 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("attributeName"));
	String	attributeValue 	 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("attributeValue"));
	session.setAttribute(attributeName, attributeValue);
	
%><%@ include file="/IncludeEndAJAX.jsp"%>