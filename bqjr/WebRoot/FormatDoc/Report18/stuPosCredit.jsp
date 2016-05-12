<%@page import="com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		还款说明书
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
	int iDescribeCount = 30;	//这个是页面需要输入的个数，必须写对：客户化1
	int iCount = 1;
	int iCountNew = 20 ;
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	String sSql = "SELECT bc.businessType,bc.bugPayPkgind,bc.CreditCycle as CreditCycle,(bc.businesssum*bc.insurancesum*0.01) as CreditFeeRate,bc.FIRSTDRAWINGDATE,bc.customerid,bc.customername,bc.businesssum,bt.Monthlyinterestrate as creditrate,bc.repaymentno,"+
                 "getItemName('BankCode',bc.repaymentbank) as repaymentbank,bc.repaymentname,bc.monthrepayment,bc.periods,"+
	"bt.monthlyInterestRate,(bc.businesssum*bt.CUSTOMERSERVICERATES * 0.01) as serviceFee,bc.PutOutDate,"+
                 "(bc.businesssum*bt.MANAGEMENTFEESRATE * 0.01) as manageFee from business_type bt,business_contract bc where bc.BusinessType=bt.TypeNo and bc.serialno='"+sObjectNo+"' ";
System.out.println("===="+sSql);
ASResultSet rs = Sqlca.getASResultSet(sSql);
	String sCustomerID="";
    String sServiceFee="";
	String sManageFee = "";
	String sCustomerName = "";
	String sBusinessSum="";
	String sPaymentSum = "";
	String sCreditRate = "";
	String sRepaymentNo="";
	String sRepaymentBank="";
	String sRepaymentName="";
	String sMonthRepayment="";
	String sPeriods="";
	String sContractNum="";
	String sPutOutDate = "";
	String sFirstPayAmt = "";
	String sCreditFeeRate = "";
	String CreditCycle = "";
	
	//在计算随心还服务包费时使用
	String stypeno = "",sBusinessSum_ = "",sTerm="",sBugPayPkgind="",bugPayPkgindFee="0.0";

	if (rs.next()){
		sCreditFeeRate = DataConvert.toMoney(rs.getDouble("CreditFeeRate"));
		if (sCreditFeeRate == null) sCreditFeeRate  = "&nbsp;";	
		sFirstPayAmt = DataConvert.toMoney(rs.getDouble("FIRSTDRAWINGDATE"));
		if (sFirstPayAmt == null) sFirstPayAmt  = "&nbsp;";	
		sCustomerID = rs.getString("CustomerID");
		if (sCustomerID == null) sCustomerID  = "&nbsp;";
		sCustomerName = rs.getString("CustomerName");
		if (sCustomerName == null) sCustomerName  = "&nbsp;";	
		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum"));
		if (sBusinessSum == null) sBusinessSum  = "&nbsp;";	
		// sPaymentSum = DataConvert.toMoney(rs.getDouble("PaymentSum"));
		if (sPaymentSum == null) sPaymentSum  = "&nbsp;";		
		sCreditRate = rs.getString("CreditRate");
		if (sCreditRate == null) sCreditRate  = "&nbsp;";
		sRepaymentNo=rs.getString("RepaymentNo");
		if (sRepaymentNo == null) sRepaymentNo  = "&nbsp;";
		sRepaymentBank = rs.getString("RepaymentBank");
		if (sRepaymentBank == null) sRepaymentBank  = "&nbsp;";
		sRepaymentName=rs.getString("RepaymentName");
		if(sRepaymentName == null) sRepaymentName="&nbsp;";
		sMonthRepayment = rs.getString("MonthRepayment");
		if(sMonthRepayment == null) sMonthRepayment="&nbsp;";
		sPeriods = rs.getString("Periods");
		if(sPeriods == null) sPeriods="&nbsp;";
		sServiceFee = DataConvert.toMoney(rs.getDouble("ServiceFee"));
		if(sServiceFee == null) sServiceFee="&nbsp;";
		sManageFee = DataConvert.toMoney(rs.getDouble("ManageFee"));
		if(sManageFee == null) sManageFee="&nbsp;";
		sPutOutDate = rs.getString("PutOutDate");
		if(sPutOutDate == null) sPutOutDate = "&nbsp;";
		CreditCycle = rs.getString("CreditCycle");
		if(CreditCycle == null) CreditCycle = "&nbsp;";
		if(!"1".equals(CreditCycle)) sCreditFeeRate = "0.0";

		//在计算随心还服务包费时使用
		stypeno = rs.getString("businessType");
		sBusinessSum_ = rs.getString("BusinessSum");
		sTerm = rs.getString("Periods");
		sBugPayPkgind = rs.getString("bugPayPkgind");
		if(stypeno == null)stypeno="";
		if(sBugPayPkgind == null)sBugPayPkgind="";
		if(sBusinessSum_ == null)sBusinessSum_="";
		if(sTerm == null)sTerm="";
	}
	rs.getStatement().close();
	
	//首次还款日
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String businessDate = SystemConfig.getBusinessDate();
	if(!sPutOutDate.equals("&nbsp;")){	
		sFirstDueDate = Sqlca.getString(new SqlObject("select FirstDueDate from acct_rpt_segment where objectno = :objectNo ").setParameter("objectNo", sObjectNo));
		sDefaultDueDay = sFirstDueDate.substring(8,10);
	}

	//随心还服务包费用
	if("1".equals(sBugPayPkgind)){//已购买随心还的
		com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee bppf = new GetBugPayPkgindFee();
		bppf.setStypeno(stypeno);
		bppf.setsBusinessSum_(sBusinessSum_);
		bppf.setsTerm(sTerm);
		bppf.setsBugPayPkgind(sBugPayPkgind);
		bugPayPkgindFee = bppf.getFee(Sqlca);
	}

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable style='position:relative;'>");
	//微信公众号  CCS-869 POS贷还款小贴士增加自助服务公众号
	sTemp.append("<div style='position:absolute;left:510px;top:420px;'><table style='border:1px;' width='120' >");
	sTemp.append("<tr><td style='border:0px;text-align=center; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black;'>微信服务号</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align=center; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black;'>bqfenqigou</td></tr>");
	sTemp.append("<tr><td><img src='"+sWebRootPath+"/FormatDoc/Images/gongzhonghao.jpg' style='width:120px;height:120px'></td></tr>");
	sTemp.append("</table></div>");
	
	sTemp.append("<table  style='border:1px;' width='700' align=center>");
	sTemp.append("<tr >");	
	sTemp.append("<td colspan=1 rowspan=2 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("</tr>");	
	sTemp.append("<tr><td style='border:0px;'>&nbsp;</td></tr>");
	
  	sTemp.append("<tr>");   
	sTemp.append("<td style='border:0px;text-align:center; font-size: 20pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black;background-color:white' colspan=6>还款小贴士<br><br></td>");
	sTemp.append("</tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>尊敬的"+sCustomerName+" 先生/女士:</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;&nbsp;&nbsp;衷心感谢您选择佰仟金融！</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-indent:2em; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;&nbsp;&nbsp;爱生活，爱品质，每月仅"+sMonthRepayment+"元,梦想不能等过期，细水长流筑未来！</td></tr>");
	//sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 >&nbsp;&nbsp;&nbsp;<span style='text-decoration: underline; '><u>您分期付款的信息如下：</u></span></td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;贷款本金（元）:&yen;"+sBusinessSum+"</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;首次还款额:&yen;"+sFirstPayAmt+"&nbsp;其余各期月付金额:&yen;"+sMonthRepayment+"&nbsp;分期期数："+sPeriods+"</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;首次还款日:"+sFirstDueDate+"&nbsp;每月还款日："+sDefaultDueDay+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;月贷款利率（%）:"+sCreditRate+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;月客户服务费（元）:"+sServiceFee+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;月财务管理费（元）:"+sManageFee+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;月增值服务费金额(元):"+sCreditFeeRate+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6>&nbsp;&nbsp;&nbsp;月随心还服务费金额(元):"+bugPayPkgindFee+"&nbsp;</td></tr>");
	String sq = "select count(serialno) as contractnum from business_contract where CustomerID=(select customerid from Business_contract where serialno = '"+sObjectNo+"') and serialno <> '"+sObjectNo+"'";
	 /* ASResultSet re = Sqlca.getASResultSet(sq);
	  while(re.next()){
		  int i=1;
		sContractNum=re.getString("ContractNum");
		 if(sContractNum == null) sContractNum="";
		 i++;
		 while(i>=2){
		   sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 15pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;您在此知悉并同意：鉴于您与我司存在多笔贷款，为了方便您的还款，我司应您的要求将多笔贷款应还款额合并计算，并统一还款日，因此首次还款额与其余各期每月还款额存在金额不一致的情况，但总还款金额不变。:&nbsp;</td></tr>");
		 }
		
	  } */
	  
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>&nbsp;&nbsp;<span style='text-decoration: underline; '><u>您每月还款指定账户信息如下:</u></span></td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;户名:"+sRepaymentName+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;指定还款账号:"+sRepaymentNo+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;开户银行:招商银行深圳四海支行&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;</td></tr>");

	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>&nbsp;&nbsp;<span style='text-decoration: underline; '><u>您可以通过您的个人银行账户，使用如下方式还款:</u></span></td></tr>");
 	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;手机银行转帐：即需即用，快捷简单&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;网上银行转帐：足不出户，快捷简单&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;银行柜台转帐：需要携带您的银行卡前往银行柜台办理&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>如需帮助，请加入佰仟“自助服务微信”或拨打客户热线<br/>4009987101，我们将为您提供专业的协助。</td></tr>");
	
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '><span style='text-decoration: underline; '>温馨提醒:</span></td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>1.敬请您提前7天准备，按时还款，保持良好的个人信用记录。为保证您的还款及时到账，进行还款时，请正确输入或填写您的23位指定还款账号"+sRepaymentNo+",还款操作结束后，敬请保留您的还款纸质凭条或电子截屏。</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>2.敬请您使用正规银行的服务网点及技术平台进行还款操作，不要交纳现金给其他人员，以免影响您的还款到账时间及产生其他不良后果。</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>3.敬请知悉，按照合同条款约定，如果您未能按时还款，您需要支付逾期费用。</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'><br/>本人已阅读并理解上述文字内容。（本文件一式两份，客户及我司各留存一份）</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:黑体;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'><br/>客户签名:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期:"+SystemConfig.getBusinessDate()+"</td></tr>");	


	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>