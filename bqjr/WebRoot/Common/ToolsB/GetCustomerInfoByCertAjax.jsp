<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe:
			通过用户输入的客户号CustomerID
			从CUSTOMER_INFO中提取得到证件类型CertType和证件号码CertId及客户名称CustomerName
			若表中无此客户资料，则上述变量值返回NULL。
		Input Param:
			CustomerID: 客户编号
		Output Param:
			CertType: 证件类型
			CertID: 证件号码
			CustomerID: 客户编号
			CustomerName: 客户名称
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