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
<%
	//获得调查报告数据
	

	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020302.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.2、授信客户在我行的融资情况</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=16% align=center class=td1 > 类别 </td>");
	sTemp.append("   <td width=18% align=center class=td1 > 授信机构 </td>");
	sTemp.append("   <td width=14% align=center class=td1 > 余额(万) </td>");
	sTemp.append("   <td width=14% align=center class=td1 > 敞口(万)</td>");
	sTemp.append("   <td width=24% align=center class=td1 > 担保方式 </td>");
	sTemp.append("   <td width=14% align=center class=td1 > 到期日 </td>");
	sTemp.append("   </tr>");
	
	String sSql = "";
	ASResultSet rs = null;
	String sOrgName = "";//授信机构
	double dBalance = 0.00;//余额
	double dBusinessSum = 0.00;//敞口
	String sVouchTypeName = "";//担保方式
	String sMaturity = "";//到期日
	
	int iCount = 0;//统计是否存在记录
	double dBalance1 = 0.00;//短期贷款余额合计数
	double dBusinessSum1 = 0.00;//短期贷款敞口合计数
	double dBalance2 = 0.00;//银行承兑汇票余额合计数
	double dBusinessSum2 = 0.00;//银行承兑汇票敞口合计数
	double dBalance3 = 0.00;//长期借款余额合计数
	double dBusinessSum3 = 0.00;//长期借款敞口合计数
	double dBalance4 = 0.00;//长期借款余额合计数
	double dBusinessSum4 = 0.00;//长期借款敞口合计数
	
	
	//----------------------------------短期贷款-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='1010010' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance1 = rs.getDouble("Balance");
		dBusinessSum1 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> 短期贷款 </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='1010010' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//授信机构
		    dBalance = rs.getDouble("Balance");//余额
			dBusinessSum = rs.getDouble("BusinessSum");//敞口
			sVouchTypeName = rs.getString("VouchTypeName");//担保方式
			sMaturity = rs.getString("Maturity");//到期日
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> 短期贷款 </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance1)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum1)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}
	
	//----------------------------------银行承兑汇票-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='2010' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance2 = rs.getDouble("Balance");
		dBusinessSum2 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> 银行承兑汇票 </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='2010' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//授信机构
		    dBalance = rs.getDouble("Balance");//余额
			dBusinessSum = rs.getDouble("BusinessSum");//敞口
			sVouchTypeName = rs.getString("VouchTypeName");//担保方式
			sMaturity = rs.getString("Maturity");//到期日
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> 银行承兑汇票 </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance2)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum2)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}

	//----------------------------------长期借款-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='1010020' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance3 = rs.getDouble("Balance");
		dBusinessSum3 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> 长期借款 </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='1010020' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//授信机构
		    dBalance = rs.getDouble("Balance");//余额
			dBusinessSum = rs.getDouble("BusinessSum");//敞口
			sVouchTypeName = rs.getString("VouchTypeName");//担保方式
			sMaturity = rs.getString("Maturity");//到期日
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> 长期借款 </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance3)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum3)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}
	//----------------------------------商票贴现-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='1020020' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance4 = rs.getDouble("Balance");
		dBusinessSum4 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> 商票贴现 </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='1020020' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//授信机构
		    dBalance = rs.getDouble("Balance");//余额
			dBusinessSum = rs.getDouble("BusinessSum");//敞口
			sVouchTypeName = rs.getString("VouchTypeName");//担保方式
			sMaturity = rs.getString("Maturity");//到期日
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> 商票贴现 </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >小计</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance4)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum4)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}
	sTemp.append("   <tr>");
	sTemp.append("   <td width=18% align=center colspan=3 class=td1 >敞口总计</td>");
	sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum1+dBusinessSum2+dBusinessSum3+dBusinessSum4)+"</td>");
	sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
	sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
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