<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe:
			ͨ���û�����Ŀͻ���CustomerID
			��CUSTOMER_INFO����ȡ�õ�֤������CertType��֤������CertId���ͻ�����CustomerName
			�������޴˿ͻ����ϣ�����������ֵ����NULL��
		Input Param:
			CustomerID: �ͻ����
		Output Param:
			CertType: ֤������
			CertID: ֤������
			CustomerID: �ͻ����
			CustomerName: �ͻ�����
	*/
	String sCustomerName="",sCustomerID="",sReturnValue="";
	String sCertType = CurPage.getParameter("CertType");
	String sCertID = CurPage.getParameter("CertID");
	String sNewSql = "select CustomerID,CustomerName from CUSTOMER_INFO where CertType=:CertType and CertID=:CertID";
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sNewSql).setParameter("CertType",sCertType).setParameter("CertID",sCertID));
	if (rs.next()){
		sCustomerID=rs.getString("CustomerID");
		sCustomerName=rs.getString("CustomerName");
	}
	rs.getStatement().close();

	ArgTool args = new ArgTool();
	args.addArg(sCustomerID);
	args.addArg(sCustomerName);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@	include file="/IncludeEndAJAX.jsp"%>