<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe:
			通过用户输入的客户号CustomerID
			从CUSTOMER_INFO中提取得到证件类型CertType和证件号码CertId及客户名称CustomerName
			若表中无此客户资料，则上述变量值返回NULL。
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