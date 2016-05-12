<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第?页
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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	String sOccurTypeName = "0";		//授信方式
	String sBusinessType = "0";		//授信品种
	String sBusinessTypeName = "0";		//授信品种
	String sCurrencyName = "0";		    //币种
	String sBusinessSum = "0";			//总额度
	double dBusinessSum = 0;			//总额度
	String sBalanceSum = "0";			//实际余额 
	double dBalanceSum = 0;				//实际余额 
	String sBailRatio = "0";			//保证金比例
	String sMaturity = "0";				//到期日
	String sBusinessRate = "0";			//利率
	String sPdgRatio = "";				//手续费率
	String sClassifyResult = "0";		//五级分类
	double dSum1=0;						//金额合计
	double dSum2=0;						//余额合计
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='04.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='9' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4、在我行未结清的授信业务信息(单位：万)</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=13% align=center class=td1 > 授信方式 </td>");
	sTemp.append("   <td width=13% align=center class=td1 > 授信品种 </td>");
	sTemp.append("   <td width=8% align=center class=td1 >币种</td>");
	sTemp.append("   <td width=11% align=center class=td1 >总额度</td>");
	sTemp.append("   <td width=11% align=center class=td1 >实际余额</td>");
	sTemp.append("   <td width=14% align=center class=td1 >保证金比例%</td>");
	sTemp.append("   <td width=9% align=center class=td1 > 到期日</td>");
	sTemp.append("   <td width=9% align=center class=td1 >利/费率‰</td>");
	sTemp.append("   <td width=12% align=center class=td1 > 五级分类</td>");
	sTemp.append("   </tr>");

	NumberFormat nf = NumberFormat.getInstance();
    nf.setMinimumFractionDigits(6);
    nf.setMaximumFractionDigits(6);
        
	ASResultSet rs = Sqlca.getResultSet("select getItemName('OccurType',OccurType) as OccurTypeName," +
					"BusinessType,getBusinessName(BusinessType) as BusinessTypeName," +
					"getItemName('Currency',BusinessCurrency) as CurrencyName," +
					"BusinessSum,Balance,"+
					"BailRatio,Maturity,"+
					"BusinessRate,PdgRatio,"+
					"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "+
					"from BUSINESS_CONTRACT "+
					"where CustomerID='"+sCustomerID+"'"+
					" and Balance>=0 and (FinishDate = ' ' or FinishDate is null)");
	while(rs.next())
	{
		sOccurTypeName = rs.getString("OccurTypeName");
		if(sOccurTypeName == null) sOccurTypeName = " ";
		
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";

		sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";

		sCurrencyName = rs.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName = " ";

		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		if (sBusinessSum == null) sBusinessSum = "";
		
		dBusinessSum = rs.getDouble("BusinessSum");
		dSum1 = dSum1+dBusinessSum;

		sBalanceSum = DataConvert.toMoney(rs.getDouble("Balance")/10000);
		if (sBalanceSum == null) sBalanceSum = "";
		
		dBalanceSum = rs.getDouble("Balance");
		dSum2 = dSum2+dBalanceSum;

		sBailRatio = DataConvert.toMoney(rs.getDouble("BailRatio"));
		if (sBailRatio == null) sBailRatio = "";
		
		sPdgRatio = DataConvert.toMoney(rs.getDouble("PdgRatio"));
		if (sPdgRatio == null) sPdgRatio = "";

		sMaturity = rs.getString("Maturity");
		if(sMaturity == null) sMaturity = " ";

		//sBusinessRate = DataConvert.toMoney(rs.getDouble("BusinessRate"));
		//利率保留6位小数
		sBusinessRate = nf.format(rs.getDouble("BusinessRate"));
		if (sBusinessRate == null) sBusinessRate = "";

		sClassifyResult = rs.getString("ClassifyResult");	
		if (sClassifyResult == null) sClassifyResult = "";

		sTemp.append("   <tr>");
		sTemp.append("   <td width=13% align=center class=td1 >"+sOccurTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=13% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=8% align=center class=td1 nowrap>"+sCurrencyName+"&nbsp;</td>");
		sTemp.append("   <td width=11% align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   <td width=11% align=right class=td1 >"+sBalanceSum+"&nbsp;</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append("   <td width=9% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		
		//表内业务取月利率，表外业务取手续费率
		if(sBusinessType.substring(0,1).equals("1"))	//表内业务
			sTemp.append(" <td width=9% align=right class=td1 >"+sBusinessRate+"</td>");
		else if(sBusinessType.substring(0,1).equals("2"))	//表外业务
			sTemp.append(" <td width=9% align=right class=td1 >"+sPdgRatio+"</td>");
		else	//其他业务
			sTemp.append(" <td width=9% align=right class=td1 >0.00</td>");
		
		sTemp.append("   <td width=12% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs.getStatement().close();

/*
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=3 align=center class=td1 > 小计 </td>");
	sTemp.append("   <td width=11% align=right class=td1 >"+DataConvert.toMoney(dSum1)+"&nbsp;</td>");
	sTemp.append("   <td width=11% align=right class=td1 >"+DataConvert.toMoney(dSum2)+"&nbsp;</td>");
	sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
*/
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

