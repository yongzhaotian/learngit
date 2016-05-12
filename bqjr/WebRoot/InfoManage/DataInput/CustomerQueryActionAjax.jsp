<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* 
	 * Content: 查询客户信息是否存在,客户类型是否为空
	 */
	ASResultSet rs = null;
	String sCustomerType = "NOEXSIT";
	
	//客户号
	String sCustomerID = CurPage.getParameter("CustomerID"); 	
	String sSql =  "select CustomerType from Customer_Info where CustomerID =:CustomerID ";
   	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID)); 
   	if(rs.next()) {
		sCustomerType = rs.getString("CustomerType");
		if (sCustomerType == null) sCustomerType = "";
		if (sCustomerType.equals("")) sCustomerType="EMPTY";
	}	
	rs.getStatement().close();
	out.println(sCustomerType);
%><%@ include file="/IncludeEndAJAX.jsp"%>