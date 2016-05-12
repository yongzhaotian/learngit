<%@page import="com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		����˵����
		Author:   xiongtao  2005.02.18
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
			ɾ���ͻ�ǩ�����ݣ� by dahl 2015-4-23
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 30;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
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
	String sFirstDueYear="";
	String sFirstDueMonth="";
	
	//�ڼ������Ļ��������ʱʹ��
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

		//�ڼ������Ļ��������ʱʹ��
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
	
	//�״λ�����
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String businessDate = SystemConfig.getBusinessDate();
	if(!sPutOutDate.equals("&nbsp;")){	
		sFirstDueDate = Sqlca.getString(new SqlObject("select FirstDueDate from acct_rpt_segment where objectno = :objectNo ").setParameter("objectNo", sObjectNo));
		
		sDefaultDueDay = sFirstDueDate.substring(8,10);
	}
	sFirstDueYear=sFirstDueDate.substring(0, 4);
	sFirstDueMonth=sFirstDueDate.substring(5, 7);

	//���Ļ����������
	if("1".equals(sBugPayPkgind)){//�ѹ������Ļ���
		com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee bppf = new GetBugPayPkgindFee();
		bppf.setStypeno(stypeno);
		bppf.setsBusinessSum_(sBusinessSum_);
		bppf.setsTerm(sTerm);
		bppf.setsBugPayPkgind(sBugPayPkgind);
		bugPayPkgindFee = bppf.getFee(Sqlca);
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table  style='border:1px;' width='700' align=center>	");
	sTemp.append("<tr >");	
	sTemp.append("<td colspan=1 rowspan=2 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("</tr>");	
	sTemp.append("<tr><td style='border:0px;'>&nbsp;</td></tr>");
	
  	sTemp.append("<tr>");   
	sTemp.append("<td style='border:0px;text-align:center; font-size: 20pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;background-color:white' colspan=6>����С��ʿ<br><br></td>");
	sTemp.append("</tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>�𾴵�"+sCustomerName+" ����/Ůʿ:</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>���ĸ�л��ѡ���Ǫ���ڣ�</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-indent:2em; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>�������Ʒ�ʣ�ÿ�½�"+sMonthRepayment+"Ԫ,���봥�ֿɼ���</td></tr>");
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 style='text-decoration: underline;'><u>�����ڴ������Ϣ���£�</u></td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>�����Ԫ��:&yen;"+sBusinessSum+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����������"+sPeriods+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>ÿ�»����գ�"+sDefaultDueDay+"��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ÿ���»����:&yen;"+sMonthRepayment+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>�״λ�����:"+sFirstDueYear+"��"+sFirstDueMonth+"��"+sDefaultDueDay+"��&nbsp;&nbsp;&nbsp;&nbsp;�״λ����:&yen;"+sFirstPayAmt+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6>�´������ʣ�%��:"+sCreditRate+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�¿ͻ�����ѣ�Ԫ��:"+sServiceFee+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=6>�²������ѣ�Ԫ��:"+sManageFee+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ֵ����ѽ�Ԫ��:"+sCreditFeeRate+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=6>�����Ļ�����ѽ�Ԫ��:"+bugPayPkgindFee+"&nbsp;</td></tr>");
	String sq = "select count(serialno) as contractnum from business_contract where CustomerID=(select customerid from Business_contract where serialno = '"+sObjectNo+"') and serialno <> '"+sObjectNo+"'";
	 /* ASResultSet re = Sqlca.getASResultSet(sq);
	  while(re.next()){
		  int i=1;
		sContractNum=re.getString("ContractNum");
		 if(sContractNum == null) sContractNum="";
		 i++;
		 while(i>=2){
		   sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 15pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;���ڴ�֪Ϥ��ͬ�⣺����������˾���ڶ�ʴ��Ϊ�˷������Ļ����˾Ӧ����Ҫ�󽫶�ʴ���Ӧ�����ϲ����㣬��ͳһ�����գ�����״λ�������������ÿ�»������ڽ�һ�µ���������ܻ�����䡣:&nbsp;</td></tr>");
		 }
		
	  } */
	  
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6'>��������£����ǻ�����ṩ�������˻��а��¿۳���Ӧ�Ŀ����ۿ�ɹ���<u>������ͨ�����ĸ��������˻���ʹ�����·�ʽ���</u></td></tr>");
	
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>�ֻ�����ת�ˣ����輴�ã���ݼ�</td></tr>");
	
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>��������ת�ˣ��㲻��������ݼ�</td></tr>");

	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>���й�̨ת�ˣ���ҪЯ���������п�ǰ�����й�̨����</td></tr>");

	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '><u>��ÿ�»���ָ���˻���Ϣ���£�</u>&nbsp;</td></tr>");
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>����:"+sRepaymentName+"&nbsp;</td></tr>");
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>ָ�������˺�:"+sRepaymentNo+"&nbsp;</td></tr>");
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>�������У��������йɷ����޹�˾���ڰ���֧��&nbsp;</td></tr>");//update CCS-399(���Ѵ�Ĭ����ʾΪ���ĺ�֧�С����ֽ��Ĭ����ʾΪ������֧��  ��;)
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 15pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>�����������ӭ�µ��Ǫ���ڿͻ����ߣ�4009987101�����ǽ�Ϊ���ṩרҵ�ķ���&nbsp;</td></tr>");

	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");

	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>��ܰ���ѣ�&nbsp;</td></tr>");
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>1.	��������ǰ7���ڻ����˻��д����Դ���ÿ�»�����Ǯ���ʱ����������õĸ������ü�¼��Ϊ��֤���Ļ��ʱ���ˣ����л���ʱ������ȷ�������д����23λָ�������˺�"+sRepaymentNo+",������������󣬾��뱣�����Ļ���ֽ��ƾ������ӽ�����</td></tr>");
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>2.	������ʹ���������еķ������㼰����ƽ̨���л����������Ҫ�����ֽ��������Ա������Ӱ�����Ļ����ʱ�估�����������������</td></tr>");
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 '>3.	����֪Ϥ�����պ�ͬ����Լ���������δ�ܰ�ʱ�������Ҫ֧�����ڷ��á�</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=6 '>&nbsp;</td></tr>");

	sTemp.append("<tr><td colspan=2 style='border:0px;'>&nbsp;</td></tr>");
	
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
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>