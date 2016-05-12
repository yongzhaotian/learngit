<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   JBai  2005.12.20
		Tester:
		Content: 虚拟客户编号
		Input Param:
			
		Output param:
			CustomerID：客户编号
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<%	
	//定义变量：客户编号
	String sCustomerID = DBKeyHelp.getSerialNo("CUSTOMER_INFO","CertID",Sqlca);
	sCustomerID = "X"+sCustomerID;
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sCustomerID);
	sCustomerID = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sCustomerID);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
