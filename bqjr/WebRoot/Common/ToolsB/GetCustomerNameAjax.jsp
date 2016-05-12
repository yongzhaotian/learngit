<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe:
			通过用户输入的客户编号CustomerId从CUSTOMER_INFO中提取客户名称CustomerName。
			若表中无此客户资料，则上述变量值返回NULL。
		Input Param:
			CustomerID: 客户编号
		Output Param:
			CustomerName: 客户名称
	*/
	String sReturnValue="";
	String sCustomerID = CurPage.getParameter("CustomerID");
	ASResultSet rs = Sqlca.getResultSet(new SqlObject("select CustomerName from CUSTOMER_INFO where CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID));
	String sCustomerName="";
	if (rs.next()){
		sCustomerName=rs.getString("CustomerName");
	}
	rs.getStatement().close();
	out.println(sReturnValue);
%><%@	include file="/IncludeEndAJAX.jsp"%>