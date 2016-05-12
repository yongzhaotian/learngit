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
	String sBasicBanck = "";
	String sBasicAccount = "";
	String sMyBank = "";
	String sMyBankAccount = "";
	String sAccountDate = "";
	String sCreditDate = "";
	String sOtherBank = "";
	String sOtherBankAccount = "";
	
	ASResultSet rs2 = Sqlca.getResultSet("select BasicBank,BasicAccount,MyBank,MyBankAccount,"
							+"AccountDate,CreditDate,OtherBank,OtherBankAccount "
							+"from ENT_INFO "
							+"where CustomerID ='"+sCustomerID+"'");
	if(rs2.next())
	{
		sBasicBanck = rs2.getString(1);
		if(sBasicBanck == null) sBasicBanck = " ";
		
		sBasicAccount = rs2.getString(2);
		if(sBasicAccount == null) sBasicAccount = " ";
		
		sMyBank = rs2.getString(3);
		if(sMyBank == null) sMyBank = " ";
		
		sMyBankAccount = rs2.getString(4);
		if(sMyBankAccount == null) sMyBankAccount = " ";
		
		sAccountDate = rs2.getString(5);
		if(sAccountDate == null) sAccountDate = " ";
		
		sCreditDate = rs2.getString(6);
		if(sCreditDate == null) sCreditDate = " ";
		
		sOtherBank = rs2.getString(7);
		if(sOtherBank == null) sOtherBank = "";
		
		sOtherBankAccount = rs2.getString(8);
		if(sOtherBankAccount == null) sOtherBankAccount = "";
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("<tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("<td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3、银企合作关系</font></td>"); 	
	sTemp.append("</tr>");
	sTemp.append("<tr>");	
	sTemp.append("<td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.1、合作概况</font></td>"); 	
	sTemp.append("</tr>");	
	sTemp.append("<tr>");
  	sTemp.append("<td width=20% align=center class=td1 > 基本帐户行  </td>");
    sTemp.append("<td width=35% align=left class=td1 >"+sBasicBanck+"&nbsp;</td>");
    sTemp.append("<td width=10% align=center class=td1 > 帐号 </td>");
    sTemp.append("<td width=35% align=left class=td1 >"+sBasicAccount+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
  	sTemp.append("<td width=20% align=center class=td1 > 我行开户行  </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sMyBank+"&nbsp;</td>");
    sTemp.append("<td width=20% align=center class=td1 > 帐号 </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sMyBankAccount+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
  	sTemp.append("<td width=20% align=center class=td1 > 开户时间  </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sAccountDate+"&nbsp;</td>");
    sTemp.append("<td width=20% align=center class=td1 nowrap > 与我行建立信贷关系日期 </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sCreditDate+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
  	sTemp.append("<td width=20% align=center class=td1 > 其他主要开户行</td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sOtherBank+"&nbsp;</td>");
    sTemp.append("<td width=20% align=center class=td1 > 帐号 </td>");
    sTemp.append("<td width=30% align=left class=td1 >"+sOtherBankAccount+"&nbsp;</td>");
	sTemp.append("</tr>");	
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