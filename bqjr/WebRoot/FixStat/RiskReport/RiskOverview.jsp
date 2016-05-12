<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
String sCustomerID 	= DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
String sStrips[][] = {
	{"true","申请人目前的信贷业务" ,"180","CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,""},
	{"true","风险情况" ,"100","RiskReport","/CreditManage/RiskReport/RiskReport.jsp","CustomerID="+sCustomerID,""},
	{"true","建议的额度","100","CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,""},
	}; 
%>

<%@include file="/Resources/CodeParts/Strip05.jsp"%>

<%@ include file="/IncludeEnd.jsp"%>
