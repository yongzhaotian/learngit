<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Describe:
			通过用户输入的客户编号CustomerId从CUSTOMER_INFO中提取客户名称CustomerName。
			若表中无此客户资料，则上述变量值返回NULL。
		Input Param:
			CustomerID: 客户编号
		Output Param:
			CustomerName: 客户名称
	*/
	String sCustomerType = CurPage.getParameter("CustomerType");
	String sObjectType = "";
	String sReturnValue="";
	String sNewSql = "select Attribute1 from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo=:ItemNo";
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sNewSql).setParameter("ItemNo",sCustomerType));
	if (rs.next()){
		sReturnValue = rs.getString("Attribute1");
		if(sObjectType==null||"".equals(sObjectType)) sReturnValue = "NULL";//对象类型未定义
	}else{
		sReturnValue="NOTEXISTS";//系统中无此客户类型
	}
	rs.getStatement().close();

	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@	include file="/IncludeEndAJAX.jsp"%>