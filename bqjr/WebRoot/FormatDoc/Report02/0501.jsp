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
	String sReportScopeName = "";	//报表口径
	String sAuditFlag = "";			//报表是否已经过审计
	String sAuditOffice = "";		//审计事务所名称
	String sAuditOpinion = "";		//审计意见
	String sReportDate = "";		//最近一期截止日期
	
	String sSql = "select getItemName('ReportScope',ReportScope) as ReportScopeName,"+
				  "getItemName('Y/N',AuditFlag) as AuditFlag,AuditOffice,AuditOpinion,ReportDate "+
				  "from CUSTOMER_FSRECORD where CustomerID = '"+sCustomerID+"' order by ReportDate DESC";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sReportScopeName = rs2.getString("ReportScopeName");
		if(sReportScopeName == null) sReportScopeName = " ";
		
		sAuditFlag = rs2.getString("AuditFlag");
		if(sAuditFlag == null) sAuditFlag = " ";
		
		sAuditOffice = rs2.getString("AuditOffice");
		if(sAuditOffice == null) sAuditOffice = " ";
		
		sAuditOpinion = rs2.getString("AuditOpinion");
		if(sAuditOpinion == null) sAuditOpinion = " ";
		
		sReportDate = rs2.getString("ReportDate");
		if(sReportDate == null) sReportDate = " ";
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0501.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5、申请人财务分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.1、财务报表说明</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=center class=td1 > 报表口径 </td>");
	sTemp.append("   <td width=75% colspan='6' align=center class=td1 >"+sReportScopeName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=center class=td1 > 报表是否已经过审计</td>");
	sTemp.append("   <td width=25% colspan=2 align=left class=td1 >"+sAuditFlag+"&nbsp;</td>");
	sTemp.append("   <td width=25% colspan=2 align=center class=td1 > 审计事务所名称 </td>");
	sTemp.append("   <td width=25% colspan=2 align=left class=td1 >"+sAuditOffice+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=center class=td1 > 审计意见</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sAuditOpinion+"&nbsp;</td>");
	sTemp.append("   <td colspan=2 align=center class=td1 > 最近一期截止日期 </td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sReportDate+"&nbsp;</td>");
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