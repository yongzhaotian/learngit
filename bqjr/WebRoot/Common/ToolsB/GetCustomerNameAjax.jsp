<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe:
			ͨ���û�����Ŀͻ����CustomerId��CUSTOMER_INFO����ȡ�ͻ�����CustomerName��
			�������޴˿ͻ����ϣ�����������ֵ����NULL��
		Input Param:
			CustomerID: �ͻ����
		Output Param:
			CustomerName: �ͻ�����
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