<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   JBai  2005.12.20
		Tester:
		Content: ����ͻ����
		Input Param:
			
		Output param:
			CustomerID���ͻ����
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<%	
	//����������ͻ����
	String sCustomerID = DBKeyHelp.getSerialNo("CUSTOMER_INFO","CertID",Sqlca);
	sCustomerID = "X"+sCustomerID;
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sCustomerID);
	sCustomerID = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sCustomerID);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
