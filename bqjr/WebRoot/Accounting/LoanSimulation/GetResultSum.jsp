<!--create by bxzhou at 2003.08.14-->
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
    double MonthPay=0.0D;
    double MonthRate=0.0D;
    int    Term=0;
    double LoanSum=0.0D; 
    
    String sMonthPay = CurPage.getParameter("MonthPay");
    String sMonthRate = CurPage.getParameter("MonthRate");
    String sTerm = CurPage.getParameter("Term");
    
    if(sMonthPay == null || sMonthPay.length() == 0)
		sMonthPay = "";
	else
		MonthPay = Double.parseDouble(sMonthPay);
    if(sMonthRate == null || sMonthRate.length() == 0)
		sMonthRate = "";
	else
		MonthRate = Double.parseDouble(sMonthRate);
    if(sTerm == null || sTerm.length() == 0)
		sTerm = "";
	else
		Term = Integer.parseInt(sTerm);

	LoanSum = Math.round(MonthPay/(MonthRate / 1000 +  MonthRate /(1000 * (Math.pow(1 + MonthRate / 1000,Term)-1)))*100)/100;
%>
<script language="javascript">
	self.returnValue = <%=LoanSum%>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>