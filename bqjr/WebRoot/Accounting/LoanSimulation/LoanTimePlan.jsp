<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>×ÉÑ¯°´½ÒÊý¶î</title> 
</head>

<!--
<body class="pagebackground" leftmargin="0" topmargin="0" onload="init();my_loadshow(2,0,'myiframe0');" >
-->
<body class="pagebackground" leftmargin="0" topmargin="0" onload="">
<object ID="AsOne" WIDTH=0 HEIGHT=0 
      <%=(String)session.getValue("CABNAME")%> >
</object>
<table border="0" width="100%" height="98%" cellspacing="0" cellpadding="0" >
<tr>
    <td colpsan=3>
		<iframe name="myiframe0" src="" width=100% height=100% frameborder=1></iframe>
    </td>
    <td colpsan=3>
		<iframe name="myiframe1" src="" width=100% height=100% frameborder=1></iframe>
    </td>
</tr>
</table>
</body>

</html>


<script language=javascript>	
	OpenPage("/Accounting/LoanSimulation/LoanSum.jsp","myiframe0");
	OpenPage("/Accounting/LoanSimulation/LoanTerm.jsp","myiframe1");
//	OpenPage("/Accounting/LoanSimulation/LoanMonthPay.jsp","myiframe2");
</script>	
<%@ include file="/IncludeEnd.jsp"%>