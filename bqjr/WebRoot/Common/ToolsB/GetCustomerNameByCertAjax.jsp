<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe:
			ͨ���û�����Ŀͻ���CustomerID
			��CUSTOMER_INFO����ȡ�õ�֤������CertType��֤������CertId���ͻ�����CustomerName
			�������޴˿ͻ����ϣ�����������ֵ����NULL��
	*/
	String sReturnValue="";
	String sCertType = CurPage.getParameter("CertType");
	String sCertID = CurPage.getParameter("CertID");
	String sNewSql = "select CustomerName from CUSTOMER_INFO where CertType=:CertType and CertID=:CertID";
	SqlObject so = new SqlObject(sNewSql);
	so.setParameter("CertType",sCertType);
	so.setParameter("CertID",sCertID);
	ASResultSet rs = Sqlca.getResultSet(so);
	String sCustomerName="";
	if (rs.next()){
		sCustomerName=rs.getString("CustomerName");
	}
	rs.getStatement().close();

	ArgTool args = new ArgTool();
	args.addArg(sCustomerName);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@	include file="/IncludeEndAJAX.jsp"%>