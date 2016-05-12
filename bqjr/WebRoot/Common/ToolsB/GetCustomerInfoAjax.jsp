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
			CustomerName: 客户名称
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sCertType);
	args.addArg(sCertID);
	args.addArg(sCustomerName);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@	include file="/IncludeEndAJAX.jsp"%>