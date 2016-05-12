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
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	String sSql = "select OccurOrg,BusinessType,getItemName('OtherBusinessType',BusinessType) as BusinessTypeName, "+
	              "Balance,BeginDate,Maturity,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "+
	              "from CUSTOMER_OACTIVITY where CustomerID = '"+sCustomerID+"'";
	String sOccurOrg = "";
	String sBusinessType = "";
	String sBusinessTypeName = "";
	String sBalance  = "";
	String sBeginDate = "";
	String sMaturity = "";
	String sClassifyResult = "";
	double dBalance = 0.0;
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020303.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.3、在他行未结清授信业务信息（单位：万元） </font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=17% align=center class=td1 > 行名  </td>");
    sTemp.append("   <td colspan='2' align=center class=td1 > 品种 </td>");
    sTemp.append("   <td width=16% align=center class=td1 > 授信业务余额 </td>");
    sTemp.append("   <td width=16% align=center class=td1 > 起始日 </td>");
    sTemp.append("   <td width=16% align=center class=td1 > 到期日 </td>");
    sTemp.append("   <td width=21% align=center class=td1 > 五级分类 </td>");
	sTemp.append("   </tr>");

	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
	sOccurOrg = rs2.getString(1);
	if(sOccurOrg == null) sOccurOrg = " ";
	sBusinessType = rs2.getString(2);
	sBusinessTypeName = rs2.getString(3);
	if(sBusinessTypeName == null) sBusinessTypeName = " ";
	sBalance = DataConvert.toMoney(rs2.getDouble(4));
	sBeginDate = rs2.getString(5);
	if(sBeginDate == null) sBeginDate = " ";
	sMaturity = rs2.getString(6);
	if(sMaturity == null) sMaturity = " ";
	sClassifyResult = rs2.getString(7);
	if(sClassifyResult == null) sClassifyResult = " ";
	
	if(sBusinessType.equals("020"))
	{
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=17% rowspan='2' align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	    sTemp.append("   <td width=6% align=center class=td1 > 表<br>内</td>");
	    sTemp.append("   <td width=12% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	    sTemp.append("   <td width=16% align=right class=td1 >"+sBalance+"&nbsp; </td>");
	    sTemp.append("   <td width=16% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
	    sTemp.append("   <td width=16% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
	    sTemp.append("   <td width=21% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=6% align=center class=td1 > 表外敞口  </td>");
	    sTemp.append("   <td width=12% align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td width=16% align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td width=16% align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td width=16% align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td width=21% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=17% rowspan='2' align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	    sTemp.append("   <td width=6% align=center class=td1 > 表<br>内</td>");
	    sTemp.append("   <td width=12% align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td width=16% align=center class=td1 >&nbsp; </td>");
	    sTemp.append("   <td width=16% align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td width=16% align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td width=21% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=6% align=center class=td1 > 表外敞口  </td>");
	    sTemp.append("   <td width=12% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	    sTemp.append("   <td width=16% align=right class=td1 >"+sBalance+"&nbsp; </td>");
	    sTemp.append("   <td width=16% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
	    sTemp.append("   <td width=16% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
	    sTemp.append("   <td width=21% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	/*
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=17% align=center class=td1 > 小计  </td>");
    sTemp.append("   <td colspan='6' align=center class=td1 >&nbsp;  </td>");
    sTemp.append("   </tr>");
    */
    }
    rs2.getStatement().close();	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='7' align=left class=td1 >分析总结在他行未结清授信情况，重点分析财务报表中短期债务和长期债务与人民银行贷款记录中不符情况。<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
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
	editor_generate('describe1');		//需要html编辑,input是没必要 
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
