<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* 
	 * Content: ��ѯ�ͻ���Ϣ�Ƿ����,�ͻ������Ƿ�Ϊ��
	 */
	ASResultSet rs = null;
	String sCustomerType = "NOEXSIT";
	
	//�ͻ���
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