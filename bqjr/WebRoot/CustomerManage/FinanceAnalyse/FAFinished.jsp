<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>

<html>
<head>
<style type='text/css'>
<!--
.mytable {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}
.mytd {  border-color: #000000 #000000 black black; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 9pt; color: #000000}
.mytable2 {  border-style: none; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px}
-->
</style>

<script type="text/javascript">

</script>

</head>

<body bgcolor="White" leftmargin=0 topmargin=0>
<br>
<table width=90% align=center   >  
<tr valign=top><td align=center >
<%

	out.println((String)session.getAttribute("faEntNames")+"<br>");
	
	String startTime,endTime,statItem,method,sSqlFrom,chartType,sItems;
	startTime = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("startTime"));
	endTime   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("endTime"));
	statItem  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("chkStat"));
	chartType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("chartType"));
	sItems    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Items"));

	
	sSqlFrom = "from FINANCE_DATA,FINANCE_ITEM where CustomerID ='"+ (String)session.getAttribute("faEntIDs")
			 +"' and AccountMonth >='" + startTime + "' and AccountMonth <='"+endTime
			 +"' and FinanceItemNo = ItemNo and ItemNo in ("+sItems+")";
	
		
	CrossTable ct = new CrossTable(sSqlFrom,"AccountMonth","ItemName,ItemNo",statItem,Sqlca);
	ct.RowOrder = "order by ItemNo";
	ct.TableStyle = " class='mytable'  cellspacing='0' cellpadding='0'";
	ct.ColStyle = " class='mytd' height=23 nowrap width=50 align=center ";
	ct.RowStyle = " class='mytd' height=23 nowrap width=50";
	ct.ValueStyle = " class='mytd' height=23 nowrap align=right width=50";
	out.println(ct.init());
	
	session.setAttribute("crossTable",ct);
	//session.setAttribute("chartType",chartType);
%>
</td>
</tr>
<tr>
<td align=center>

</td>
</tr>
</table>
<center>
<!--
<input type="button" value="¹Ø±Õ´°¿Ú" onclick="javascript:self.close();">
-->
</center>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>