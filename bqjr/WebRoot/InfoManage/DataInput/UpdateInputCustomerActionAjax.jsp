<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: ���¿ͻ�����
		Input Param:
			                CustomerID:�ͻ����
			                CustomerType:�ͻ�����
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>���¿ͻ�����</title>
<%
	String sSql,sReturnValue="";
	ASResultSet rs = null;
	SqlObject so = null;
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerType"));	
	String sToday = StringFunction.getToday();
	
	try{
		sSql = 	" Update CUSTOMER_INFO set CustomerType =:CustomerType,"+
				" InputDate =:InputDate, "+
				" InputOrgID =:InputOrgID, "+
				" InputUserID =:InputUserID "+
				" where CustomerID =:CustomerID";
		so = new SqlObject(sSql).setParameter("CustomerType",sCustomerType)
		.setParameter("InputDate",sToday).setParameter("InputOrgID",CurOrg.getOrgID())
		.setParameter("InputUserID",CurUser.getUserID()).setParameter("CustomerID",sCustomerID);
		Sqlca.executeSQL(so);
		
		sSql = 	" Update ENT_INFO set OrgNature =:OrgNature,"+
				" InputDate =:InputDate, "+
				" InputOrgID =:InputOrgID, "+
				" InputUserID =:InputUserID "+
				" where CustomerID =:CustomerID";
		so = new SqlObject(sSql).setParameter("OrgNature",sCustomerType)
				.setParameter("InputDate",sToday).setParameter("InputOrgID",CurOrg.getOrgID())
				.setParameter("InputUserID",CurUser.getUserID()).setParameter("CustomerID",sCustomerID);		
		Sqlca.executeSQL(so);
		sReturnValue="succeed";
	}catch(Exception e){
		e.fillInStackTrace();
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>