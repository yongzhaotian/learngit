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
			CustomerName: �ͻ�����
	*/
	String sCustomerID = CurPage.getParameter("CustomerID");
	ASResultSet rs = Sqlca.getResultSet(new SqlObject("select CertType,CertID,CustomerName from CUSTOMER_INFO where CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID));
	String sCertType="";
	String sCertID="";
	String sReturnValue="";
	String sCustomerName="";
	if (rs.next()){
		sCertType=rs.getString("CertType");
		sCertID=rs.getString("CertID");
		sCustomerName=rs.getString("CustomerName");
	}else{
		return;
	}
	rs.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sCertType);
	args.addArg(sCertID);
	args.addArg(sCustomerName);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@	include file="/IncludeEndAJAX.jsp"%>