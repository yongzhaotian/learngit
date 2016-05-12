<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   fhuang  2006.01.09
		Tester:
		Content: 中小企业调查报告
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020303.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	    
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.3、授信客户在其它金融机构的融资情况</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=16% align=center class=td1 > 类别 </td>");
	sTemp.append("   <td width=18% align=center class=td1 > 授信机构 </td>");
	sTemp.append("   <td width=16% align=center class=td1 > 余额(万) </td>");
	sTemp.append("   <td width=16% align=center class=td1 > 敞口(万)</td>");
	sTemp.append("   <td width=16% align=center class=td1 > 起始日 </td>");
	sTemp.append("   <td width=16% align=center class=td1 > 到期日 </td>");
	sTemp.append("   </tr>");

	String sSql = "";
	ASResultSet rs = null;
	String sOrgName = "";//授信机构
	String sBusinessName = "";//品种
	double dBalance = 0.00;//余额
	double dBusinessSum = 0.00;//敞口
	String sBeginDate = "";// 起始日
	String sMaturity = "";//到期日
	
	double dBalance1 = 0.00;//贷款余额合计数
	double dBusinessSum1 = 0.00;//贷款敞口合计数

	sSql = "select OccurOrg,Round(Balance/10000,2) as Balance,"+
		   "Round(BusinessSum/10000,2) as BusinessSum, "+
		   "getItemName('OtherBusinessType',BusinessType) as BusinessName,"+
		   "BeginDate,Maturity "+
		   "from CUSTOMER_OACTIVITY "+
		   "where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next())
	{
		sOrgName = rs.getString("OccurOrg");
		dBalance = rs.getDouble("Balance");
		dBusinessSum = rs.getDouble("BusinessSum");
		sBusinessName = rs.getString("BusinessName");
		sBeginDate = rs.getString("BeginDate");
		sMaturity = rs.getString("Maturity");
		dBalance1 += dBalance;
		dBusinessSum1 += dBusinessSum;
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 > "+sBusinessName+" </td>");
		sTemp.append("   <td width=18% align=center class=td1 > "+sOrgName+"</td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBalance)+" </td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBusinessSum)+"</td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+sBeginDate+" </td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+sMaturity+" </td>");
		sTemp.append("   </tr>");
	}
	rs.getStatement().close();
	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=16% align=center class=td1 colspan=2 > 合计 </td>");
	sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBalance1)+" </td>");
	sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBusinessSum1)+"</td>");
	sTemp.append("   <td width=16% align=center class=td1 > &nbsp; </td>");
	sTemp.append("   <td width=16% align=center class=td1 >&nbsp; </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='CustomerID' value='"+sCustomerID+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.getClientID()+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.getClientID()+"'>");
	sTemp.append("</form>");	



	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script type="text/javascript">
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();    
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>