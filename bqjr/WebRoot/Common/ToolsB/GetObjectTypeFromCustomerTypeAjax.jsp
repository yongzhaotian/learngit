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
	String sCustomerType = CurPage.getParameter("CustomerType");
	String sObjectType = "";
	String sReturnValue="";
	String sNewSql = "select Attribute1 from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo=:ItemNo";
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sNewSql).setParameter("ItemNo",sCustomerType));
	if (rs.next()){
		sReturnValue = rs.getString("Attribute1");
		if(sObjectType==null||"".equals(sObjectType)) sReturnValue = "NULL";//��������δ����
	}else{
		sReturnValue="NOTEXISTS";//ϵͳ���޴˿ͻ�����
	}
	rs.getStatement().close();

	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@	include file="/IncludeEndAJAX.jsp"%>