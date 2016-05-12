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
	String sSql = "SELECT bc.InputDate,bc.CreditID,bc.StoreCityCode,bc.SubProductType,bc.businessType,bc.bugPayPkgind,bc.CreditCycle as CreditCycle,(bc.businesssum*bc.insurancesum*0.01) as CreditFeeRate,bc.FIRSTDRAWINGDATE,bc.customerid,bc.customername,bc.businesssum,bt.Monthlyinterestrate as creditrate,bc.repaymentno,"+
                 "getItemName('BankCode',bc.repaymentbank) as repaymentbank,bc.repaymentname,bc.monthrepayment,bc.periods,"+
	"bt.monthlyInterestRate,(bc.businesssum*bt.CUSTOMERSERVICERATES * 0.01) as serviceFee,bc.PutOutDate,"+
                 "(bc.businesssum*bt.MANAGEMENTFEESRATE * 0.01) as manageFee from business_type bt,business_contract bc where bc.BusinessType=bt.TypeNo and bc.serialno='"+sObjectNo+"' ";
System.out.println("===="+sSql);
ASResultSet rs = Sqlca.getASResultSet(sSql);
	String sInputDate = "",sCreditID = "",sStoreCityCode="",sSubProductType="";
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

	//�ڼ������Ļ��������ʱʹ��
	String stypeno = "",sBusinessSum_ = "",sTerm="",sBugPayPkgind="",bugPayPkgindFee="0.0";

	if (rs.next()){
		sInputDate = rs.getString("InputDate");
		sCreditID = rs.getString("CreditID");
		sStoreCityCode = rs.getString("StoreCityCode");
		sSubProductType = rs.getString("SubProductType");
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
	
	//��������
	sRepaymentBank = Sqlca.getString(new SqlObject("select getItemName('LoanSubBank',subBankName) as subBankName " + 
		" from ProvidersCity where SerialNo=:SerialNo and AreaCode=:AreaCode " + 
			" and ProductType=:ProductType").setParameter("SerialNo", sCreditID)
				.setParameter("AreaCode", sStoreCityCode).setParameter("ProductType", sSubProductType));
	if(sRepaymentBank == null){
		sRepaymentBank = Sqlca.getString(new SqlObject("select getItemName('LoanSubBank',subBankName) as subBankName " + 
				" from ProvidersCity_Log where SerialNo=:SerialNo and AreaCode=:AreaCode " + 
				" and ProductType=:ProductType and :InputDate between beginTime and endTime").setParameter("SerialNo", sCreditID)
					.setParameter("AreaCode", sStoreCityCode).setParameter("ProductType", sSubProductType)
					.setParameter("InputDate", sInputDate));
	};

	//�״λ�����
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String businessDate = SystemConfig.getBusinessDate();
	if(!sPutOutDate.equals("&nbsp;")){	
		sFirstDueDate = Sqlca.getString(new SqlObject("select FirstDueDate from acct_rpt_segment where objectno = :objectNo ").setParameter("objectNo", sObjectNo));
		sDefaultDueDay = sFirstDueDate.substring(8,10);
	}
	
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
	//sTemp.append("<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable style='position:relative;'>");
	//΢�Ź��ں�  CCS-869 POS������С��ʿ�������������ں�
	sTemp.append("<div style='position:absolute;left:510px;top:420px;'><table style='border:1px;' width='120' >");
	//sTemp.append("<tr><td style='border:0px;text-align=center; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;'>΢�ŷ����</td></tr>");
	//sTemp.append("<tr><td style='border:0px;text-align=center; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;'>bqfenqigou</td></tr>");
	//sTemp.append("<tr><td><img src='"+sWebRootPath+"/FormatDoc/Images/gongzhonghao.jpg' style='width:120px;height:120px'></td></tr>");
	sTemp.append("</table></div>");
	
	sTemp.append("<table  style='border:1px;' width='700' align=center>");
	sTemp.append("<tr >");	
	sTemp.append("<td colspan=1 rowspan=2 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/logo2.jpg' /><br><img src='"+sWebRootPath+"/FormatDoc/Images/caixian.png' /></td>");
	sTemp.append("</tr>");
	sTemp.append("<tr><td style='border:0px;'>&nbsp;</td></tr>");
	
  	sTemp.append("<tr>");   
	sTemp.append("<td style='border:0px;text-align:center; font-size: 20pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;background-color:white' colspan=6>����С��ʿ<br><br></td>");
	sTemp.append("</tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;>�𾴵�"+sCustomerName+" ����/Ůʿ:</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;&nbsp;&nbsp;���ĸ�л��ѡ���Ǫ���ڣ�</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 >&nbsp;&nbsp;&nbsp;<span style='text-decoration: underline; '><u>���ķ��ڴ�����Ϣ���£�</u></span></td></tr>");
	
	
	sTemp.append("<tr><td><table style='border:0; cellspacing:0 ;cellpadding:0; width:426.0px;margin-left:5.15pt;border-collapse:collapse'>");
	sTemp.append("<tr>");
	sTemp.append("<td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;�����Ԫ��:&yen;"+sBusinessSum+"&nbsp;</td>");
	sTemp.append("<td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;��������:"+sPeriods+"&nbsp;</td></tr>"); 
	sTemp.append("<tr><td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;�״λ����:&yen;"+sFirstPayAmt+"&nbsp;</td>");
	sTemp.append("<td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;ÿ�»����:&yen;"+sMonthRepayment+"&nbsp;</td></tr>"); 
	sTemp.append("<tr><td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;�״λ�����:"+sFirstDueDate+"&nbsp;</td>");
	sTemp.append("<td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;ÿ�»�����:"+sDefaultDueDay+"&nbsp;</td></tr>"); 
	sTemp.append("<tr><td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;�¿ͻ�����ѣ�Ԫ��:&yen;"+sServiceFee+"&nbsp;</td>");
	sTemp.append("<td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;�´������ʣ�%��:"+sCreditRate+"&nbsp;</td></tr>"); 
	sTemp.append("<tr><td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;�²������ѣ�Ԫ��:&yen;"+sManageFee+"&nbsp;</td>");
	sTemp.append("<td style='border:solid 1px;text-align:left; font-size: 10pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; '>&nbsp;&nbsp;&nbsp;����ֵ����ѽ��(Ԫ):&yen;"+sCreditFeeRate+"&nbsp;</td></tr>"); 
	sTemp.append("</table></td></tr>");
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
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>&nbsp;&nbsp;<span style='text-decoration: underline; '><u>��ÿ�»���ָ���˻���Ϣ����:</u></span></td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;����:"+sRepaymentName+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;ָ�������˺�:"+sRepaymentNo+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;��������:"+sRepaymentBank+"&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;</td></tr>");

	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>&nbsp;&nbsp;��˾������ṩ�Ĵ��������˻��а��¿۳���Ӧ��������ڻ��������ǰȷ�����������㣬�Ա�ɹ��ۿ��ۿ�ɹ�����δѡ�����д��۷���������ͨ�����ĸ��������˻���ʹ�����·�ʽ���</td></tr>");
 	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;<b>1.</b>�ֻ�����ת�ˣ�24Сʱ���񡢷�����&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;<b>2.</b>��������ת�ˣ�������á���Ч�ɿ�&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;<b>3.</b>�װ������������ն˻�������򵥡�ʡʱʡ��(�����е���ʹ��)&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 11pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;<b>4.</b>���й�̨ת�ˣ�������㡢���ر���&nbsp;</td></tr>");
	//sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>���������������Ǫ����������΢�š��򲦴�ͻ�����<br/>4009987101�����ǽ�Ϊ���ṩרҵ��Э����</td></tr>");
	
	sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black;>&nbsp;</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>��ܰ����:</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>1.Ϊ��֤���Ŀ��ʱ���ˣ���������ǰ7���ڻ����˻��д����Դ���ÿ�»�����Ǯ����л���ʱ������ȷ�������д����23λָ�������˺ţ�������������󣬾��뱣�����Ļ���ֽ��ƾ������ӽ�����</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>2.������ʹ���������еķ������㼰����ƽ̨���л�����������������˴�Ϊ�������Ӱ�����Ļ����ʱ�估�������ü�¼��</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'>3.����֪Ϥ�����պ�ͬ����Լ��������δ�ܰ�ʱ���������֧�����ڷ��ã��������������������ϱ�������������Ϣ�������ݿ⼰�����������������Ż�����</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '><u><b>�𾴵Ŀͻ�������ý���α�����������ð����ҵ�ٷ��ͷ�����թƭ�İ�������Ǫ���ڲ�����õ绰���߶��ŷ�ʽҪ�����ṩ���п���Ϣ���뾯�貢Զ��թƭ��</b></u></td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'><br/>�������Ķ�����������������ݡ������ļ�һʽ���ݣ��ͻ�����˾������һ�ݣ�</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'><br/>�����������ɨ�����¶�ά����µ��Ǫ���ڿͷ����ߣ�400-9987-101�����ǽ��߳�Ϊ������!</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>ɨһɨ��ע����</td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����_GB2312;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>���ྪϲ��</td></tr>");
	sTemp.append("<tr><td><img src='"+sWebRootPath+"/FormatDoc/Images/gongzhonghao.jpg' style='width:120px;height:120px'></td></tr>");
	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 13pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px;'><br/>�ͻ�ǩ��:_______________&nbsp;&nbsp;&nbsp;����:___<u>"+SystemConfig.getBusinessDate()+"</u>___</td></tr>");	


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
	sTemp.append("<div align='left'>");
	sTemp.append("<font size:8px> �汾��: J_XF_TY_TY_2016030801 </font>");
	sTemp.append("</div>");	


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