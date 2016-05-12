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
	
	String sSql = " select  getBusinessName(BusinessType) as BusinessTypeName," +
		   		  " BusinessSum,getItemName('Currency',BusinessCurrency) as CurrencyName,"+
		          " BailRatio,BusinessRate,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "+
		          " from BUSINESS_CONTRACT "+
		          " where CustomerID = '"+sCustomerID+"'"+
		          " and Balance>=0 and (FinishDate = ' ' or FinishDate is null)";
	String sBusinessTypeName = "";
	double dBusinessSum = 0.0;
	String sBusinessSum = "";
	String sCurrencyName = "";
	String sBailRatio = "";
	String sBusinessRate = "";
	String sClassifyResult = "";
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020302.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append(" <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append(" <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.2、在我行的授信业务信息</font></td>"); 	
	sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td width=22% align=center class=td1 > 授信业务品种</td>");
    sTemp.append(" <td width=18% align=center class=td1 > 金额（万） </td>");
    sTemp.append(" <td width=10% align=center class=td1 > 币种 </td>");
    sTemp.append(" <td width=22% align=center class=td1 > 保证金比例％</td>");
    sTemp.append(" <td width=16% align=center class=td1 > 利率/费率 </td>");
    sTemp.append(" <td width=22% align=center class=td1 > 五级分类 </td>");
    sTemp.append(" </tr>");
    
    ASResultSet rs2 = Sqlca.getASResultSet(sSql);
	while(rs2.next())
	{	
		sBusinessTypeName = rs2.getString(1);
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
		dBusinessSum += rs2.getDouble(2)/10000;
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(2)/10000);
		if(sBusinessSum == null) sBusinessSum="0.0";
		sCurrencyName = rs2.getString(3);
		if(sCurrencyName == null) sCurrencyName=" ";
		sBailRatio = DataConvert.toMoney(rs2.getDouble(4));
		sBusinessRate = DataConvert.toMoney(rs2.getDouble(5));
		sClassifyResult = rs2.getString(6);
		if(sClassifyResult == null) sClassifyResult=" ";
		sTemp.append(" <tr>");
		sTemp.append(" <td width=22% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append(" <td width=18% align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append(" <td width=10% align=center class=td1 >"+sCurrencyName+"&nbsp;</td>");
		sTemp.append(" <td width=22% align=right class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append(" <td width=16% align=right class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append(" <td width=22% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append(" </tr>");
	}
	rs2.getStatement().close();
	
	sSql = " select getItemName('Currency',BusinessCurrency) as CurrencyName,sum(BusinessSum)"+
           " from BUSINESS_CONTRACT "+
           " where CustomerID = '"+sCustomerID+"' and Balance>=0 and (FinishDate = ' ' or FinishDate is null) group by BusinessCurrency";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	while(rs2.next())
	{
		sSum += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}	
	rs2.getStatement().close();	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > 小计: </td>");
	sTemp.append("   <td colspan='5' align=left class=td1 >"+sSum+"&nbsp;</td>");
	sTemp.append("</tr>");
	/*
	sTemp.append(" <tr>");
  	sTemp.append(" <td width=22% align=center class=td1 >授信业务敞口合计</td>");
    sTemp.append(" <td width=18% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=22% align=center class=td1 > 在我行信用记录</td>");
    sTemp.append(" <td colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append(" </tr>");
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