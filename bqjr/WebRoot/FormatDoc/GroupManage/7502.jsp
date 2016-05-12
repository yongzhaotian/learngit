<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/* Author:   djia  2009.10.22
	 * Tester:
	 * Content: 集团客户关联搜索格式化报告的第0页
	 * Input Param:
	 * 		必须传入的参数：
	 * 			DocID:	  文档template
	 * 			ObjectNo：业务号
	 * 			SerialNo: 调查报告流水号
	 * 		可选的参数：
	 * 			Method:   其中 1:display;2:save;3:preview;4:export
	 * 			FirstSection: 判断是否为报告的第一页
	 * Output param:
	 *      	 
	 * History Log: 
	 */	
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	String sCustomerID = "";
	String sRelaMaCustID = "";
	String sRelaChildCustID = "";
	String sSENTERPRISENAME = "";
	String sMaENTERPRISENAME = "";
	String sMaCORPID = "";
	String sMaFICTITIOUSPERSON = "";
	String sMaUnfinishedBusiness = "";
	String sManageOrgName = "";
	String sManageUserName = "";
	String sChildENTERPRISENAME = "";
	String sChildCORPID = "";
	String sChildFICTITIOUSPERSON = "";
	String sChildUnfinishedBusiness = "";
	String sChildManageOrgName = "";
	String sChildManageUserName = "";
	String listItem[];

	//获得母公司和子公司编号
    String sSql = "select CustomerID,RelaMaCustID,RelaChildCustID from group_result where SerialNo = '"+sObjectNo.substring(0,16)+"'";
	ASResultSet rss = Sqlca.getASResultSet(sSql);
	if(rss.next())
	{
		sCustomerID = rss.getString("CustomerID");
		sRelaMaCustID = rss.getString("RelaMaCustID");
		sRelaChildCustID = rss.getString("RelaChildCustID");
	}
	rss.getStatement().close();
	listItem = sRelaChildCustID.split("@");
	
	//获得源公司数据
    String sSqls = "select ENTERPRISENAME from ENT_INFO where CUSTOMERID = '"+sCustomerID+"'";
	ASResultSet rss1 = Sqlca.getASResultSet(sSqls);
	if(rss1.next())
	{
		sSENTERPRISENAME = rss1.getString("ENTERPRISENAME");
		if( sSENTERPRISENAME==null) sSENTERPRISENAME= "";
	}
	rss1.getStatement().close();
	
	//获得认定书母公司数据
    //String sSql0 = "select ENTERPRISENAME,CORPID,FICTITIOUSPERSON from ENT_INFO where CUSTOMERID = '"+sCustomerID+"'";
    String sSql0 = "select CustomerID,ENTERPRISENAME,CORPID,FICTITIOUSPERSON,getItemName('HaveNot',getNotEndBusiness(CustomerID)) as UnfinishedBusiness,getManageOrgName(CustomerID) as ManageOrgName,  getManageUserName(CustomerID) as ManageUserName  from ENT_INFO where CUSTOMERID = '"+sRelaMaCustID+"'";
	ASResultSet rs0 = Sqlca.getASResultSet(sSql0);
	if(rs0.next())
	{
		sMaENTERPRISENAME = rs0.getString("ENTERPRISENAME");
		if( sMaENTERPRISENAME==null) sMaENTERPRISENAME= "";
		
		sMaCORPID = rs0.getString("CORPID");
		if( sMaCORPID==null) sMaCORPID= "";
		
		sMaFICTITIOUSPERSON = rs0.getString("FICTITIOUSPERSON");
		if( sMaFICTITIOUSPERSON==null) sMaFICTITIOUSPERSON= "";
		
		sMaUnfinishedBusiness = rs0.getString("UnfinishedBusiness");
		if( sMaUnfinishedBusiness==null) sMaUnfinishedBusiness= "";
		
		sManageOrgName = rs0.getString("ManageOrgName");
		if( sManageOrgName==null) sManageOrgName= "";
		
		sManageUserName = rs0.getString("ManageUserName");
		if( sManageUserName==null) sManageUserName= "";
	}
	rs0.getStatement().close();
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<style type=\"text/css\"> p.thicker {font-weight: 900} </style>");
	sTemp.append("	<form method='post' action='7502.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=center colspan=28 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>集团客户认定申请书<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 ><u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>:<br> &nbsp;&nbsp;&nbsp;&nbsp;我行/部在对&nbsp;'"+sSENTERPRISENAME+"'&nbsp;进行授信前期调查时，根据收集到的信息，确定该客户具有集团关系特征。现按照《中国XX银行法人客户信贷政策手册》的规定，特向贵部上报此名单（见下表），请认定是否按照集团客户进行授信管理。（详细说明及资料附后）</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 > <p class=\"thicker\"> 集团名称 </p></td>");
		sTemp.append("   <td colspan=11 align=left class=td1 nowrap>&nbsp;</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=5% align=left class=td1 > <p class=\"thicker\"> 集团简称 </p> </td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=5% align=left class=td1 > <p class=\"thicker\"> 集团总部（母公司）所在地 </p> </td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 > <p class=\"thicker\"> 母公司信息 </p> </td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 成员公司名称 </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 证件类型号码 </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 法定代表人 </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 是否存在授信申请或未结清业务（不含低风险业务）</p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> 管户机构 </p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> 管户客户经理 </p> </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaENTERPRISENAME+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaCORPID+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaFICTITIOUSPERSON+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaUnfinishedBusiness+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=left class=td1 >"+sManageOrgName+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=left class=td1 >"+sManageUserName+"&nbsp;</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 > <p class=\"thicker\"> 子公司成员名单 </p> </td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 成员公司名称 </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 证件类型号码 </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 法定代表人 </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> 是否存在授信申请或未结清业务（不含低风险业务）</p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> 管户机构 </p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> 管户客户经理 </p> </td>");
		sTemp.append("   </tr>");
		
		
	for(int k=0; k<listItem.length; k++){
		String sSql2 = "select CustomerID,ENTERPRISENAME,CORPID,FICTITIOUSPERSON,getItemName('HaveNot',getNotEndBusiness(CustomerID)) as UnfinishedBusiness,getManageOrgName(CustomerID) as ManageOrgName,  getManageUserName(CustomerID) as ManageUserName from ENT_INFO where CUSTOMERID = '"+listItem[k]+"'";
		ASResultSet rs2 = Sqlca.getASResultSet(sSql2);
		if(rs2.next())
		{	
			sChildENTERPRISENAME = rs2.getString("ENTERPRISENAME");
			if( sChildENTERPRISENAME==null) sChildENTERPRISENAME= "";
			
			sChildCORPID = rs2.getString("CORPID");
			if( sChildCORPID==null) sChildCORPID= "";
			
			sChildFICTITIOUSPERSON = rs2.getString("FICTITIOUSPERSON");
			if( sChildFICTITIOUSPERSON==null) sChildFICTITIOUSPERSON= "";
			
			sChildUnfinishedBusiness = rs2.getString("UnfinishedBusiness");
			if( sChildUnfinishedBusiness==null) sChildUnfinishedBusiness= "";
			
			sChildManageOrgName = rs2.getString("ManageOrgName");
			if( sChildManageOrgName==null) sChildManageOrgName= "";
			
			sChildManageUserName = rs2.getString("ManageUserName");
			if( sChildManageUserName==null) sChildManageUserName= "";
		}
		rs2.getStatement().close();
	
		sTemp.append("   <tr>");		
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildENTERPRISENAME+"&nbsp;</td>");	
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildCORPID+"&nbsp;</td>");		
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildFICTITIOUSPERSON+"&nbsp;</td>");	
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildUnfinishedBusiness+"&nbsp;</td>");	
		sTemp.append("   <td width=10% align=left class=td1 >"+sChildManageOrgName+"&nbsp;</td>");	
		sTemp.append("   <td width=10% align=left class=td1 >"+sChildManageUserName+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
		
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=12 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>填报单位：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> 年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</td>");
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
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");

	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

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

