<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sExpression = null;
	/*
	sExpression = "!CustomerManager.GetCustomerName(2000042779)";
	sExpression = Expression.pretreatMethod(sExpression,Sqlca);
	String sReturn = Expression.getExpressionValue(sExpression,Sqlca).stringValue();
	out.println(sReturn);
	*/
	ASMethod asm = new ASMethod("CustomerManager","GetCustomerName",Sqlca);
	Any anyValue  = asm.execute("2000043984");
	out.println(anyValue.toString());
	
	/*
	BizletExecutor executor = new BizletExecutor();
	ASValuePool para = new ASValuePool();
	para.setAttribute("CustomerID","2000043984");
	Object oReturn = executor.execute(Sqlca,"com.amarsoft.app.lending.bizlets.GetCustomerName",para);
	*/
%>
<%@ include file="/IncludeEnd.jsp"%>
