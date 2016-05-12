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
	String sCustomerName = "";
	String sBusinessTypeName = "";
	double dBusinessSum = 0.0;
	String sCurrency = "";
	double dBailRatio = 0.0;
	double dBusinessRate = 0.0;
	String sClassifyResult = "";
	String sVouchType = "";
	String sPurpose = "";
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getBusinessName(BusinessType)as BusinessType,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BailRatio,BusinessRate,"
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose "
										+"from business_Apply where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessTypeName = rs2.getString("BusinessType");
		if(sBusinessTypeName == "") sBusinessTypeName = "&nbsp;";
		
		dBusinessSum = rs2.getDouble("BusinessSum")/10000;
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == "") sCurrency = "&nbsp;";
		
		dBailRatio = rs2.getDouble("BailRatio");
		
		dBusinessRate = rs2.getDouble("BusinessRate");
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == "") sClassifyResult = "&nbsp;";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == "") sVouchType = "&nbsp;";
		
		sPurpose = rs2.getString("purpose");
		if(sPurpose == "") sPurpose = "&nbsp;";
	}
	
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020305.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.5、银行诉讼情况</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >");
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

