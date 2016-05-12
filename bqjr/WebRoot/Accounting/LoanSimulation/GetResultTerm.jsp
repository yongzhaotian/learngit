<!--create by bxzhou at 2003.08.14-->
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
    double MonthPay=0.0D;
    double MonthRate=0.0D;
    double Sum=0.0D;
    int    Term=0;
    
    String sMonthPay = CurComp.getParameter("MonthPay");
    String sMonthRate = CurComp.getParameter("MonthRate");
    String sSum = CurComp.getParameter("Sum");
    
    if(sMonthPay == null || sMonthPay.length() == 0)
		sMonthPay = "";
	else
		MonthPay = Double.parseDouble(sMonthPay);
		
    if(sMonthRate == null || sMonthRate.length() == 0)
		sMonthRate = ""; 
	else
		MonthRate = Double.parseDouble(sMonthRate);
    if(sSum == null || sSum.length() == 0)
		sSum = "";
	else
		Sum = Double.parseDouble(sSum);
	
	if 	(MonthPay-Sum*MonthRate/1000<=0)
    {
%>
    <script language="javascript">
    alert("你的期还款本息额太小！");
    self.returnValue = 0;
	self.close();
    </script>
<%	  
    }
    else
    {
		Term = (int)Math.ceil(Math.round(Math.log10(MonthPay/(MonthPay-Sum*MonthRate/1000))/Math.log10(1+MonthRate/1000)*100)/100);
	}	
%>
<script language="javascript">
    self.returnValue = <%=Term%>;
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>