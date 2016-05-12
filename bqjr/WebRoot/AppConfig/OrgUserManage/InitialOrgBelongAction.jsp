<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.InitOrgBelong"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 获得客户编号
		Input Param:
			
		Output param:
			CustomerID：客户编号
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title></title>
<%
	String sResult = "false" ;
	InitOrgBelong initOrgBelong = new InitOrgBelong() ;
	sResult = initOrgBelong.run(Sqlca)+"" ;
	
	Sqlca.executeSQL(" delete from SYSTEM_LOG where EventType = 'reloadCache' ");
%>

<script language=javascript>
	self.returnValue = "<%=sResult%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
