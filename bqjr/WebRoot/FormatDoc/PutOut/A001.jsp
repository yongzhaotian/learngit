<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
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

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//获得调查报告数据
	
	String sSql = "select ContractSerialNo,CustomerID,CustomerName,getBusinessName(BusinessType) as BusinessTypeName, "+
				  " getitemname('Currency',BusinessCurrency) as BusinessCurrency,BusinessSum,PutOutDate, "+
				  " getItemName('VouchType',VouchType) as VouchTypeName,BillNo,Purpose,getItemName('LCTermType',RateAdjustCyc),FZANBalance, "+
				  " Term1,Term2,getitemname('Currency',BailCurrency) as BailCurrency,BailRatio,BailAccount,getOrgName(OperateOrgID) as OperateOrgName "+
				  " from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	String sContractSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessCurrency = "";
	String sBusinessSum = "";
	String sPutOutDate = "";
	String sVouchTypeName = "";
	String sBillNo = "";
	String sPurpose = "";
	String sRateAdjustCyc = "";
	String sFZANBalance = "";
	String sTerm1 = "";
	String sTerm2 = "";
	String sBailCurrency = "";
	String sBailRatio = "";
	String sBailAccount = "";
	String sOperateOrgName = "";
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='A001.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo= "";
		
		sCustomerID = rs2.getString(2);
		if( sCustomerID==null) sCustomerID= "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName= "";
		
		sBusinessTypeName = rs2.getString(4);
		if( sBusinessTypeName==null) sBusinessTypeName= "";

		
		sBusinessCurrency = rs2.getString(5);
		if( sBusinessCurrency==null) sBusinessCurrency= "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(6));
		
		sPutOutDate = rs2.getString(7);
		if( sPutOutDate==null) sPutOutDate = "";
		
		sVouchTypeName = rs2.getString(8);
		if( sVouchTypeName==null) sVouchTypeName = "";
		
		sBillNo = rs2.getString(9);
		if( sBillNo==null) sBillNo = "";
		
		sPurpose = rs2.getString(10);
		if( sPurpose==null) sPurpose = "";
		
		sRateAdjustCyc = rs2.getString(11);
		if( sRateAdjustCyc==null) sRateAdjustCyc = "";
		
		sFZANBalance = DataConvert.toMoney(rs2.getDouble(12));
		
		sTerm1 = rs2.getString(13);
		if( sTerm1==null) sTerm1 = "";
		
		sTerm2 = rs2.getString(14);
		if( sTerm2==null) sTerm2 = "";
		
		sBailCurrency = rs2.getString(15);
		if( sBailCurrency==null) sBailCurrency= "";
		
		sBailRatio = DataConvert.toMoney(rs2.getDouble(16));
		
		sBailAccount = rs2.getString(17);
		if( sBailAccount==null) sBailAccount= "";
		
		sOperateOrgName = rs2.getString("OperateOrgName");
		if(sOperateOrgName == null) sOperateOrgName = "";
			
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		//colspan需根据实际情况调整，否则导出时会比较不雅
		sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>放款通知书<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgName+"&nbsp;&nbsp;</u>支行（部）会计部门： </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>（申请人）的授信业务:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>已经按我行业务审批程序报经有权审批人审批同意，并通过放款中心审核，请你部按照本通知书要求，办理记账手续：	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 >出帐流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > 合同流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >业务品种</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >客户编号</td>");
		sTemp.append("   <td align=left class=td1 >"+sCustomerID+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >客户名称</td>");
		sTemp.append("   <td align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >信用证币种</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >信用证金额</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >开证日</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >主要担保方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >信用证编号</td>");
		sTemp.append("   <td align=left class=td1 >"+sBillNo+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >其他条件和要求</td>");
		sTemp.append("   <td align=left class=td1 >"+sPurpose+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >信用证期限类型</td>");
		sTemp.append("   <td align=left class=td1 >"+sRateAdjustCyc+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >信用证效期</td>");
		sTemp.append("   <td align=left class=td1 >"+sTerm1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >信用证装期</td>");
		sTemp.append("   <td align=left class=td1 >"+sTerm2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >保证金币种</td>");
		sTemp.append("   <td align=left class=td1 >"+sBailCurrency+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >保证金比例(%)</td>");
		sTemp.append("   <td align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >保证金帐号</td>");
		sTemp.append("   <td align=left class=td1 >"+sBailAccount+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > 放款中心主管签字： </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>放款专用章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> 日期："+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >（此通知书共三联，交客户经理、会计和文档管理员各一份）</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	    
	}
	rs2.getStatement().close();		
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

