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
	
	String sSql = "select ContractSerialNo,DuebillSerialNo,CustomerID,CustomerName,getBusinessName(BusinessType),"+
				  "getitemname('Currency',BusinessCurrency) as BusinessCurrency,LoanType,getItemName('CreditLineFlag',CreditLineFlag),CreditAggreement,"+
				  "getItemName('CreditKind',CreditKind),PutOutDate,Maturity,ContractSum,BusinessSum,Purpose,getItemName('AdjustRateType',AdjustRateType),"+
				  "AdjustRateTerm,getItemName('ICCyc',ICCyc),FixCyc,BusinessRate,getItemName('AcceptIntType',AcceptIntType),getItemName('PreIntType',PreIntType),"+
				  "getItemName('ResumeIntType',ResumeIntType),AccountNo,LoanAccountNo,SecondPayAccount,getItemName('OverIntType',OverIntType),"+
				  "getItemName('RateAdjustCyc',RateAdjustCyc),getItemName('RateFloatType',RateFloatType),RiskRate,getOrgName(OperateOrgID),GatheringName,RateFloat "+
				  "from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";

	String sSql10 = "select SerialNo,getItemName('PaymentMode',PaymentMode),PaymentDate,PayeeName,PayeeBank,PayeeAccount,getItemName('Currency',Currency),PaymentSum,Remark,getUserName(InputUserID),InputDate "+
					"from PAYMENT_INFO  where PutoutSerialNo = '"+sObjectNo+"'";

	String sContractSerialNo = "";
	String sDuebillSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessCurrency = "";
	String sLoanType = "";
	String sCreditLineFlag = "";
	String sCreditAggreement = "";
	String sCreditKind = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sContractSum = "";
	String sBusinessSum = "";
	String sPurpose = "";
	String sAdjustRateType = "";
	String sAdjustRateTerm = "";
	String sICCyc = "";
	String sFixCyc = "";
	String sBusinessRate = "";
	String sAcceptIntType = "";
	String sPreIntType = "";
	String sResumeIntType = "";
	String sAccountNo = "";
	String sLoanAccountNo = "";
	String sSecondPayAccount = "";
	String sOverIntType = "";
	String sRateAdjustCyc = "";
	String sRateFloatType = "";
	String sRateFloat = "";
	String sRiskRate = "";
	String sOperateOrgID = "";
	String sGatheringName = "";
	String[] sGuarantor = null;
	String sTemp1 = getGuarantyNameByBP(sObjectNo,Sqlca);
	if(sTemp1==null || sTemp1.length()==0) sTemp1=" , ";
	sGuarantor = sTemp1.split(",");
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6002.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if(sContractSerialNo == null) sContractSerialNo = "";
		
		sDuebillSerialNo = rs2.getString(2);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sCustomerID = rs2.getString(3);
		if(sCustomerID == null) sCustomerID = "";
		
		sCustomerName = rs2.getString(4);
		if(sCustomerName == null) sCustomerName = "";
		
		sBusinessTypeName = rs2.getString(5);
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		
		sBusinessCurrency = rs2.getString(6);
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		
		sLoanType = rs2.getString(7);
		if(sLoanType == null) sLoanType = "";
		
		sCreditLineFlag = rs2.getString(8);
		if(sCreditLineFlag == null) sCreditLineFlag = "";
		
		sCreditAggreement = rs2.getString(9);
		if(sCreditAggreement == null) sCreditAggreement = "";
		
		sCreditKind = rs2.getString(10);
		if(sCreditKind == null) sCreditKind = "";
		
		sPutOutDate = rs2.getString(11);
		if(sPutOutDate == null) sPutOutDate = "";
		
		sMaturity = rs2.getString(12);
		if(sMaturity == null) sMaturity = "";
		
		sContractSum = DataConvert.toMoney(rs2.getDouble(13));
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(14));
		
		sPurpose = rs2.getString(15);
		if(sPurpose == null) sPurpose = "";
		
		sAdjustRateType = rs2.getString(16);
		if(sAdjustRateType == null) sAdjustRateType = "";
		
		sAdjustRateTerm = rs2.getString(17);
		if(sAdjustRateTerm == null) sAdjustRateTerm = "";
		
		sICCyc = rs2.getString(18);
		if(sAcceptIntType == null) sAcceptIntType = "";
		
		sFixCyc = rs2.getString(19);
		if (sFixCyc == null){ 
			sFixCyc = "";
		}else{
			sFixCyc = String.valueOf(Integer.parseInt(sFixCyc));
		}
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble(20));
		
		sRateFloat = nf.format(rs2.getDouble(33));
		
		sAcceptIntType = rs2.getString(21);
		if(sAcceptIntType == null) sAcceptIntType = "";
		
		sPreIntType = rs2.getString(22);
		if(sPreIntType == null) sPreIntType = "";
		
		sResumeIntType = rs2.getString(23);
		if(sResumeIntType == null) sResumeIntType = "";
		
		sAccountNo = rs2.getString(24);
		if(sAccountNo == null) sAccountNo = "";
		
		sLoanAccountNo = rs2.getString(25);
		if(sLoanAccountNo == null) sLoanAccountNo = "";
		
		sSecondPayAccount = rs2.getString(26);
		if(sSecondPayAccount == null) sSecondPayAccount = "";
		
		sOverIntType = rs2.getString(27);
		if(sOverIntType == null) sOverIntType = "";
		
		sRateAdjustCyc = rs2.getString(28);
		if(sRateAdjustCyc == null) sRateAdjustCyc = "";
		
		sRateFloatType = rs2.getString(29);
		if(sRateFloatType == null) sRateFloatType = "";
		
		nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(7);
		sRiskRate = nf.format(rs2.getDouble(30));
		sOperateOrgID = rs2.getString(31);
		if(sOperateOrgID == null) sOperateOrgID = "";
		sGatheringName = rs2.getString(32);
		if(sGatheringName == null) sGatheringName = "";
		rs2.getStatement().close();	
		ASResultSet rs3 = Sqlca.getResultSet(sSql10);
		int N = rs3.getRowCount();
		String[][] value = new String[N][11];
		for(int i = 0;rs3.next();i++){
			for(int j = 0;j < 11; j++){
				if(j == 7){
					value[i][7] = DataConvert.toMoney(rs3.getDouble(8));
				}else{
				value[i][j] = rs3.getString(j+1);
				}
			}
		}
		rs3.getStatement().close();
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		//colspan需根据实际情况调整，否则导出时会比较不雅
		sTemp.append("   <td class=td1 align=center colspan='9' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>放款通知书<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>支行（部）会计部门： </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=9 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>（申请人）的授信业务:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>已经按我行业务审批程序报经有权审批人审批同意，并通过放款中心审核，请你部按照本通知书要求，办理记账手续：	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2  align=left class=td1 > 合同流水号</td>");
		sTemp.append("   <td colspan=3  align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=2  align=left class=td1 >出帐流水号</td>");
		sTemp.append("   <td colspan=2  align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >客户号</td>");
		sTemp.append("   <td colspan=7 align=left class=td1 >"+sCustomerID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >客户名称</td>");
		sTemp.append("   <td colspan=7 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >贷款形式</td>");
		sTemp.append("   <td colspan=7 align=left class=td1 >"+sCreditKind+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >担保人客户号</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sGuarantor[0]+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >担保单位名称</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sGuarantor[1]+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >币种</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >贷款类型</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sLoanType+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >贷款类型名称</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sGatheringName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >发放金额</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >合同金额</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sContractSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >起息日</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >到期日</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >执行月利率(‰)</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >结算帐号</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >利率调整方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sAdjustRateType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >利率调整日期</td>");
		sTemp.append("   <td align=left class=td1 >"+sAdjustRateTerm+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >利率调整周期</td>");
		sTemp.append("   <td align=left class=td1 >"+sRateAdjustCyc+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >浮动方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sRateFloatType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >执行月利率(‰)</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >浮动率/点</td>");
		sTemp.append("   <td align=left class=td1 >"+sRateFloat+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >计息周期</td>");
		sTemp.append("   <td align=left class=td1 >"+sICCyc+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >固定周期</td>");
		sTemp.append("   <td align=left class=td1 >"+sFixCyc+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >结算帐号</td>");
		sTemp.append("   <td align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >贷款入帐帐号</td>");
		sTemp.append("   <td align=left class=td1 >"+sLoanAccountNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >第二还款帐号</td>");
		sTemp.append("   <td align=left class=td1 >"+sSecondPayAccount+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >逾期计息方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sOverIntType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >额度贷款标志</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCreditLineFlag+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >授信额度编号</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCreditAggreement+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >收息类型</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sAcceptIntType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >预收息标志</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sPreIntType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >计复息标志</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sResumeIntType+"&nbsp;</td>");	    
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >贷款用途</td>");
		sTemp.append("   <td colspan=7 align=left class=td1 >"+sPurpose+"&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >贷款风险系数</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sRiskRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
				
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 align=left class=td1 >支付编号</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >支付方式</td>");
		sTemp.append("   <td colspan=1  align=left class=td1 >支付日期</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >收款人名称</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >开户银行</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >收款人账户</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >币种</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >支付金额(元)</td>");
		sTemp.append("   </tr>");
		
		for(int i = 0; i<N; i++)
		{
			sTemp.append("   <tr>");	
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][0]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][1]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][2]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][3]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][4]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][5]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][6]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][7]+"</td>");

			sTemp.append("   </tr>");
		}
		
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=9 class=td1 > 放款中心主管签字： </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=9 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>放款专用章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> 日期："+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=9 class=td1 >（此通知书共三联，交客户经理、会计和文档管理员各一份）</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");	
	}

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