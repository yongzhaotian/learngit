<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
String sCustomerID 	= DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
String sStrips[][] = {
	{"true","������Ŀǰ���Ŵ�ҵ��" ,"180","CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,""},
	{"true","�������" ,"100","RiskReport","/CreditManage/RiskReport/RiskReport.jsp","CustomerID="+sCustomerID,""},
	{"true","����Ķ��","100","CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,""},
	}; 
%>

<%@include file="/Resources/CodeParts/Strip05.jsp"%>

<%@ include file="/IncludeEnd.jsp"%>
