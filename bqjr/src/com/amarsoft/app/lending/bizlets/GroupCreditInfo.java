package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


public class GroupCreditInfo {
   Transaction Sqlca = null;
   public String sResult="";
   public double UsedTotal=0.0;
   public double Totalsum=0.0;

   public GroupCreditInfo()
   {

   }

   //ȡ����
   public double getRate(String sCurrency, String sCurrency2, Transaction Sqlca) throws Exception {

      double d = 0.0, d1 = 0.0, d2 = 0.0;
      ASResultSet asresultset = null;
      String s4 = " Select nvl(Price3,0) as Price3 From ERATE_INFO Where Efficientdate =(select max(Efficientdate) from ERATE_INFO) And Currency = :sCurrency ";
      String s5 = " Select nvl(Price3,0) as Price3 From ERATE_INFO Where Efficientdate =(select max(Efficientdate) from ERATE_INFO) And Currency = :sCurrency2 ";
      try {
         asresultset = Sqlca.getASResultSet(new SqlObject(s4).setParameter("sCurrency", sCurrency));
         if (asresultset.next())
            d1 = asresultset.getDouble("Price3");
         ASResultSet asresultset1 = Sqlca.getASResultSet(new SqlObject(s5).setParameter("sCurrency2", sCurrency2));
         if (asresultset1.next())
            d2 = asresultset1.getDouble("Price3");
         asresultset1.getStatement().close();
         if (d1 == 0.0D || d2 == 0.0D)
            d = 1.0D;
         else
            d = d1 / d2;
      }
      catch (Exception exception) {
         exception.printStackTrace();
      }
      finally {
    	  asresultset.getStatement().close();
      }
      return d;
   }
   //���ʹ�ñ�
   public  void AggregateCredit(String sGroupNo, Transaction Sqlca) throws Exception {

      StringBuffer temp = new StringBuffer();
      String result="";
      //��������
      ASResultSet rs = null;
      ASResultSet rsdata = null;
      ASResultSet rsResult = null;
      //�������
      String sSql = "", sSqldata = "", sSqldata3;
      String sSerialNo = "", sBusinessSum = "", sBusinessType = "",
      sCurrency = "", sCreditSum = "", sSimpleName = "";
      String sEnterpriseName = "", sCustomerID = "", sCustomerName = "",
      sBusinessCurrency2 = "", sBusinessSum2 = "";
      String sBalance2 = "", sObjectNo = "", sCreditBalance = "",
      sBusinessCurrency = "", sDescribe6 = "", sMaturity = "";
      String sMaturity2 = "", sBusinessTypeLevel = "";
      String FlagBool = "0", sMemberDescrible = "", sAttribute2 = "";
      String sName2 = "", sName3 = "", sName4 = "";
      double dTotalBusinessSum = 0.0;
      double dTotalBalance = 0.0;
      double dTotal = 0.0;
      double dTotalsum=0.0;
      int iCount6 = 0;
      double[] dBusinessSum = new double[1000];
      double[] dBusinessSum3 = new double[1000];
      double[] dBalance3 = new double[1000];
      double[] dApproveTotal = new double[1000];
      double[] dBusinessSum5 = new double[1000];
      double[] dBalance5 = new double[1000];
      String[] CurrencyTotal = new String[1000];
      String[] CurrencyTotal3 = new String[1000];
      String[] CurrencyTotal5 = new String[1000];

      String[][] BusinessSum = new String[1000][1000];
      String[][] sBusinessSum3 = new String[1000][1000];
      String[][] sBalance3 = new String[1000][1000];
      String[][] Currency = new String[1000][1000];
      String[][] CreditSum = new String[1000][1000];
      String[][] BusinessType = new String[1000][1000];

      int i = 0, j = 0, k = 0, m = 0, n = 0, p = 0, iCount = 0, iCount2 = 0,u = 0;

      sSql = " select getcustomername(CustomerID) as  customername from AGGREGATE_MEMBER " +
        " where AggregateNo=:sGroupNo and Attribute1='1' ";
      rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sGroupNo", sGroupNo));
      if (rs.next()) {
         sSimpleName = rs.getString("customername");
         sEnterpriseName = rs.getString("customername");
         if (sSimpleName == null)
            sSimpleName = "";
         if (sEnterpriseName == null)
            sEnterpriseName = "";
      }
      rs.getStatement().close();

      sSql = " select Attribute2 from AGGREGATE_MEMBER where  AggregateNo=:sGroupNo ";
      rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sGroupNo", sGroupNo));
      while (rs.next()) {
         sAttribute2 = rs.getString("Attribute2");
         if (sAttribute2 == null)
            sAttribute2 = "";
      }
      rs.getStatement().close();

      temp.append("	<STYLE>");
      temp.append("	.table1{border: solid; border-width: 1px 1px 2px 2px; border-color: #000000 black #000000 #000000;} ");
      temp.append("	.table2{border: solid; border-width: 0px 1px 2px 2px; border-color: #000000 black #000000 #000000;} ");
      temp.append("	.table3{border: solid; border-width: 1px 1px 0px 2px; border-color: #000000 black #000000 #000000;}");
      temp.append("	.td1{border-color: #000000 #000000 black black; height:25px;border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000}");
      temp.append("	</STYLE>	");
      temp.append("<body class=\"ReportPage\" leftmargin=\"0\" topmargin=\"0\" onload=\" \"  style=\"overflow-x:scroll;overflow-y:scroll\" >");
      temp.append("<table align='center' cellspacing=0 cellpadding=0 width='100%' style='display=none;'>");
      temp.append("	<tr>");
      temp.append("		<td height=30 valign='middle' style='BORDER-bottom: #000000 0px solid;'></td>");
      temp.append("	</tr>");
      temp.append("</table>");
      temp.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" >");
      temp.append("	<tr id=\"DetailTitle\" class=\"DetailTitle\" >");
      temp.append("	    <td colspan=2>");
      temp.append("	    </td>");
      temp.append("	</tr>");
      temp.append("	<tr height=1 valign=top id=\"buttonback\" >");
      temp.append("		<td colspan=2>");
      temp.append("			<table>");
      temp.append("	    	</table>");
      temp.append("		</td>");
      temp.append("	</tr>");
      temp.append("	<tr height=1 >");
      temp.append("	    <td colspan=2>&nbsp;</td>");
      temp.append("	</tr>	");
      temp.append("	<tr valign=\"top\" >");
      temp.append("		 <td>&nbsp;</td>");
      temp.append("	    <td style='BORDER-bottom: #000000 1px solid;' > ");
      temp.append("	    	   <div id=reporttable>");
      temp.append("					<table width=\"640\" border=0 cellspacing=0 cellpadding=0 bgcolor=#FFFFFF>");
      temp.append("						<tr>");
      temp.append("						    <td align=center  height=60px>");
      if (sAttribute2.equals("1")) {
         temp.append("						        <font style=\" font-size: 20pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#FFFFFF\"><B>һ�༯�ſͻ����ʹ�ñ�</B></font>             ");
      }
      else {
         temp.append("						        <font style=\" font-size: 20pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#FFFFFF\"><B>���༯�ſͻ����ʹ�ñ�</B></font>             ");
      }
      temp.append("						    </td>");
      temp.append("						</tr>");
      temp.append("						<tr>");
      temp.append("                            <td  colspan=9 align=left bgcolor=white>&nbsp;</td>");
      temp.append("						  </tr>");
      temp.append("						<tr>");
      temp.append(
        "                            <td  colspan=9 align=left bgcolor=white>���ƣ�&nbsp;" +
        sSimpleName + "&nbsp;</td>");
      temp.append("						  </tr>");
      temp.append("						<tr>");
      temp.append("                            <td  colspan=9 align=right bgcolor=white>��λ:��Ԫ</td>");
      temp.append("						  </tr>");
      temp.append("				 	</table>");
      temp.append(
        "				 	<table class=table1 width=640  border=1 cellspacing=0 cellpadding=0");
      temp.append(
        "						bgcolor=white bordercolor=black bordercolordark=black >");

      //��ͷ
      temp.append("	<tr>");
      temp.append("	<td class=td1 rowspan=2 nowrap align=middle>��ҵ����</td>");
      temp.append("    <td class=td1 rowspan=2 nowrap align=middle>��������</td>");
      temp.append("    <td class=td1 rowspan=2 align=middle>&nbsp;</td>");

      temp.append("    <td class=td1 colspan=3 align=middle>������Ϣ</td>");
      temp.append("    <td class=td1 colspan=3 align=middle>���ʹ����Ϣ</td>");
      temp.append("  </tr>");
      temp.append("  <tr>");
      temp.append("    <td class=td1 nowrap align=middle>������</td>");
      temp.append("    <td class=td1 nowrap align=middle>��������</td>");
      temp.append("   <td class=td1 nowrap align=middle>�������</td>");
      temp.append("    <td class=td1 nowrap align=middle>��ͬ����</td>");
      temp.append("    <td class=td1 nowrap align=middle>��ͬ���</td>");
      temp.append("    <td class=td1 nowrap align=middle>��ͬ���</td>");
      temp.append("  </tr>");
      if (sAttribute2.equals("1")) {
         //���Ź�˾��Ϣ
         sSql = " select SerialNo,getErate(BusinessCurrency,'01','" + StringFunction.getToday() +"')*nvl(BusinessSum,0) as BusinessSum" +
	           " from BUSINESS_APPROVE " +
	           " where  CustomerID in (select CustomerID from AGGREGATE_MEMBER where  AggregateNo=:sGroupNo and Attribute1='1') " +
	           " and CreditMode='1' and phaseno='1000' and nvl(CreditType,'01')!='11' and approveflag='1' and nvl(effectflag,'01') = '01' " +
	           " order by putoutdate ";
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sGroupNo", sGroupNo));
         //ȡ�ڲ�������ˮ�ţ�����������
         while (rs.next()) {
            sSerialNo = rs.getString("SerialNo");
            sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum") /10000.0);
            dTotal = rs.getDouble("BusinessSum");
            dTotalsum = rs.getDouble("BusinessSum");
            if (sSerialNo == null)
               sSerialNo = "";
            if (sBusinessSum == null)
               sBusinessSum = "";
         }
         rs.getStatement().close();
         temp.append("<tr>");
         temp.append("<td class=td1 align=middle  colspan=9 bgcolor=#aaaaaa height='40px'><font style=\" font-size: 14pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#aaaaaa\";>���Ź�˾��Ϣ</font></td>");
         temp.append("</tr> ");

         //�����¼
         temp.append("<tr>");
         temp.append("<td class=td1 align=left  colspan=1 ><B>" +
                     sEnterpriseName + "&nbsp;</B></td>");
         temp.append("<td class=td1 align=left  colspan=1 >�ڲ�����</td>");
         temp.append("<td class=td1 align=left nowrap colspan=1 >�����ܶ��</td>");

         temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;" +
                     sSerialNo + "</a></td>");
         temp.append("<td class=td1 align=middle  colspan=1 >�����</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;" +
                     sBusinessSum + "</td>");
         temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
         temp.append("</tr> ");
         //ȡ��������Ʒ����ϸ
         sSql = " select getBusinessName(BusinessType) as BusinessType,getItemName('Currency',Currency) as Currency," +
           " sum(nvl(CreditSum,0)) as CreditSum " +
           " from CREDIT_INFO where  Objectno=:sSerialNo and ObjectType='BusinessApprove'" +
           " group by  BusinessType,Currency order by Currency";
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sSerialNo", sSerialNo));
         while (rs.next()) {
            sBusinessType = rs.getString("BusinessType");
            sCurrency = rs.getString("Currency");
            sCreditSum = DataConvert.toMoney(rs.getDouble("CreditSum") /10000.0);

            if (sBusinessType == null)
               sBusinessType = "";
            if (sCurrency == null)
               sCurrency = "";
            if (sCreditSum == null)
               sCreditSum = "";

            temp.append("<tr>");
            temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >" + sBusinessType +
                        "&nbsp;</td>");

            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >" + sCurrency +
                        "</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;" +
                        sCreditSum + "</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
            temp.append("</tr> ");
         }
         rs.getStatement().close();
      }
      dBusinessSum[0] = 0.0;
      CurrencyTotal[0] = "01";

      dBusinessSum3[0] = 0.0;
      dBalance3[0] = 0.0;
      CurrencyTotal3[0] = "01";

      dBusinessSum5[0] = 0.0;
      dBalance5[0] = 0.0;
      CurrencyTotal5[0] = "01";

      //���ų�Ա
      temp.append("<tr>");
      temp.append("<td class=td1 align=middle  colspan=9 bgcolor=#aaaaaa height='40px'><font style=\" font-size: 14pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#aaaaaa\";>���ų�Ա��Ϣ</font></td>");
      //temp.append("<td class=td1 align=left  colspan=8 >&nbsp;</td>");
      temp.append("</tr> ");

      k++;
      n++;
      p++;
      //���ų�Ա
      sSqldata = " select CustomerID,getCustomerName(CustomerID) as CustomerName, " +
	        " MemberDescrible from AGGREGATE_MEMBER" +
	        " where  AggregateNo=:sGroupNo and Attribute1='0' order by CustomerID";
      rsdata = Sqlca.getASResultSet(new SqlObject(sSqldata).setParameter("sGroupNo", sGroupNo));
      //���ų�Աѭ��
      while (rsdata.next()) {
         dTotalBusinessSum = 0.0;
         dTotalBalance = 0.0;
         sCustomerID = rsdata.getString("CustomerID");
         sCustomerName = rsdata.getString("CustomerName");
         sMemberDescrible = rsdata.getString("MemberDescrible");
         if (sCustomerID == null)
            sCustomerID = "";
         if (sCustomerName == null)
            sCustomerName = "";
         if (sMemberDescrible == null)
            sMemberDescrible = "";

            //��Ա��˾�ۺ�����Э���Ӧ���������ۺ���������
            //��ȡ������  ��ʼ���������ڵ���Ч�ۺ���������
         sSql = " select SerialNo,Describe6,Maturity from BUSINESS_APPROVE " +
         	" WHERE CreditMode='1' and CustomerID=:sCustomerID " +
         	" and ( MONTHS_BETWEEN(TO_DATE('"+StringFunction.getToday()+"','YYYY/MM/DD'),TO_DATE(PUTOUTDATE,'YYYY/MM/DD'))<=3 or PUTOUTDATE is null) " +
         	" and phaseno='1000' and nvl(CreditType,'01')!='11' and approveflag='1' " +
         	" and nvl(effectflag,'01') = '01' order by maturity ";
         ARE.getLog().info("��ʼ���������ڵ���Ч�ۺ���������sSql====" + sSql);
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID));
         while (rs.next()) {
            sObjectNo = rs.getString("SerialNo");
            sDescribe6 = rs.getString("Describe6");
            sMaturity = rs.getString("Maturity");

            if (sDescribe6 == null)
               sDescribe6 = "";
            if (sObjectNo == null)
               sObjectNo = "";
            if (sMaturity == null)
               sMaturity = "";
         }
         rs.getStatement().close();

         //�ڲ��ۺ���������020
         if (sDescribe6.equals("020")) {
            sSql = " select count(SerialNo) from BUSINESS_CONTRACT where  CustomerID=:sCustomerID " +
              " and nvl(CreditType,'01')!='11' " +
              " and CreditMode='2' and phaseno='1000' and CreditAggreeMent=:sObjectNo " +
              " and (Maturity>='"+StringFunction.getToday()+"' " +
              		"or Maturity is null " +
              		"or nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)";
            rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID).setParameter("sObjectNo", sObjectNo));
            if (rs.next()) {
               iCount = rs.getInt(1);
            }
            rs.getStatement().close();
            //�ڲ��ۺ�����������δ����ĺ�ͬ������δ����
            if (sMaturity.compareTo(StringFunction.getToday()) >= 0 ||
                iCount > 0) {
               sSql = " select BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency2," +
                 " nvl(BusinessSum,0) as BusinessSum" +
                 " from BUSINESS_APPROVE BA where  SerialNo=:sObjectNo ";
               rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
               if (rs.next()) {
                  sCurrency = rs.getString("Currency2");
                  sBusinessCurrency = rs.getString("BusinessCurrency");
                  BusinessSum[j][i] = DataConvert.toMoney(rs.getDouble("BusinessSum") / 10000.0);

                  if (BusinessSum[j][i] == null)
                     BusinessSum[j][i] = "";
                  if (sCurrency == null)
                     sCurrency = "";
                  if (sBusinessCurrency == null)
                     sBusinessCurrency = "";
                  //����С��
                  dApproveTotal[u] = dApproveTotal[u] +rs.getDouble("BusinessSum") * getRate(rs.getString("BusinessCurrency"), "01", Sqlca);

                  FlagBool = "0";
                  for (m = 0; m < k; m++) {
                     if ( !rs.getString("BusinessCurrency").equals(CurrencyTotal[m]) ) continue;
                        dBusinessSum[m] = dBusinessSum[m] + rs.getDouble("BusinessSum");
                        FlagBool = "1";
                     
                  }
                  if (FlagBool.equals("0")) {
                     dBusinessSum[k] = rs.getDouble("BusinessSum");
                     CurrencyTotal[k] = sCurrency;
                     k++;
                  }

                  temp.append("<tr>");
                  temp.append("<td class=td1 align=left  colspan=1 >" +
                              sCustomerName + "&nbsp;</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >�ڲ�����</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >���Ŷ��</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >&nbsp;" +
                              sObjectNo + "</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;" +
                              sCurrency + "</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;" +
                              BusinessSum[j][i] + "</td>");
                  temp.append(
                    "<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
                  temp.append(
                    "<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                  temp.append(
                    "<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                  temp.append("</tr> ");
                  i++;
                  //sObjectNo="";
                  sCurrency = "";
                  sCustomerName = "";
               }
               rs.getStatement().close();

               //�ڲ��ۺ�����������δ����ĺ�ͬ������δ����  ����Ʒ����ϸ
               i = 0;
               sSql = " select BusinessType,getBusinessName(BusinessType) as BusinessType2,Currency,getItemName('Currency',Currency) as Currency2," +
                 " sum(nvl(CreditSum,0)) as CreditSum " +
                 " from CREDIT_INFO where  Objectno=:sObjectNo" +
                 " and ObjectType='BusinessApprove'" +
                 " group by  BusinessType,Currency order by BusinessType,Currency ";
               ARE.getLog().info("�ۺ�����Э���Ӧ���������ۺ�������������Ʒ����ϸ sSql====" + sSql);
               rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
               while (rs.next()) {
                  sBusinessType = rs.getString("BusinessType");
                  BusinessType[j][i] = rs.getString("BusinessType2");
                  sCurrency = rs.getString("Currency");
                  Currency[j][i] = rs.getString("Currency2");
                  CreditSum[j][i] = DataConvert.toMoney(rs.getDouble("CreditSum") / 10000.0);

                  if (BusinessType[j][i] == null)
                     BusinessType[j][i] = "";
                  if (Currency[j][i] == null)
                     Currency[j][i] = "";
                  if (CreditSum[j][i] == null)
                     CreditSum[j][i] = "";
                  if (sCurrency == null)
                     sCurrency = "";
                  if (sBusinessType == null)
                     sBusinessType = "";
                  
                  SqlObject so=null;

                  //ȡ��ͬ���
                  if (!sBusinessType.equals(sBusinessTypeLevel)) {
                     sSqldata3 =
                       " select BusinessCurrency as BusinessCurrency2," +
                       " sum(getErate(BusinessCurrency,'"+sCurrency+"','"+StringFunction.getToday()+"')*nvl(BusinessSum,0)) as BusinessSum," +
                       " sum(getErate(BusinessCurrency,'"+sCurrency+ "','"+StringFunction.getToday()+"')* (nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0))) as Balance " +
                       " from BUSINESS_CONTRACT " +
                       " where CustomerID =:sCustomerID and nvl(CreditType,'01')!='11' " +
                       " and BusinessType like :sBusinessType " +
                       " and (BusinessCurrency in" +
                       " (select ItemNo from Code_Library where codeno='Currency' " +
                       " minus select Currency from Credit_Info where Objectno=:sObjectNo " +
                       " and ObjectType='BusinessApprove' and BusinessType =:sBusinessType) or BusinessCurrency =:sCurrency" +
                       ")" +
                       " and CreditMode='2' and phaseno='1000' " +
                       " and (Maturity>='" + StringFunction.getToday() + "' or  Maturity is null or nvl(balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)" +
                       " and CreditAggreement=:CreditAggreement  " +
                       " group by BusinessCurrency ";
                     ARE.getLog().info("ȡ��ͬ���BUSINESS_APPROVE    sSqldata3====" +sSqldata3);
                     so=new SqlObject(sSqldata3);
                     so.setParameter("sCustomerID", sCustomerID);
                     so.setParameter("sBusinessType", sBusinessType+"%");
                     so.setParameter("sObjectNo", sObjectNo);
                     so.setParameter("sBusinessType", sBusinessType);
                     so.setParameter("sCurrency", sCurrency);
                     so.setParameter("CreditAggreement", sObjectNo);
                     rsResult = Sqlca.getASResultSet(so);
                  }
                  else {
                     sSqldata3 =
                       " select BusinessCurrency as BusinessCurrency2," +
                       " getItemName('Currency',BusinessCurrency) AS BusinessCurrency," +
                       " sum(getErate(BusinessCurrency,'"+sCurrency+"','"+StringFunction.getToday()+"')* nvl(BusinessSum,0)) as BusinessSum," +
                       " sum(getErate(BusinessCurrency,'"+sCurrency+"','"+StringFunction.getToday()+"')* (nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0))) as Balance " +
                       " from BUSINESS_CONTRACT " +
                       " where CustomerID=:sCustomerID and nvl(CreditType,'01')!='11' " +
                       " and BusinessType like :sBusinessType and BusinessCurrency=:sCurrency" +
                       " and CreditMode='2' and phaseno='1000' " +
                       " and (Maturity>='" + StringFunction.getToday() + "' or  Maturity is null or nvl(balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)" +
                       " and CreditAggreement=:sObjectNo " +
                       " group by BusinessCurrency  ";
                     ARE.getLog().info("ȡ��ͬ���BUSINESS_APPROVE    sSqldata3====" +sSqldata3);
                     so=new SqlObject(sSqldata3);
                     so.setParameter("sCustomerID", sCustomerID);
                     so.setParameter("sBusinessType", sBusinessType+"%");
                     so.setParameter("sCurrency", sCurrency);
                     so.setParameter("sObjectNo", sObjectNo);
                     rsResult = Sqlca.getASResultSet(so);
                  }
                  if (rsResult.next()) {
                     sBusinessSum3[j][i] = DataConvert.toMoney(rsResult.
                       getDouble("BusinessSum") / 10000.0);
                     sBalance3[j][i] = DataConvert.toMoney(rsResult.getDouble("Balance") / 10000.0);

                    /* FlagBool = "0";
                     for (m = 0; m < p; m++) {
                        if (rsResult.getString("BusinessCurrency2").equals(
                          CurrencyTotal5[m])) {
                           dBusinessSum5[m] = dBusinessSum5[m] +
                             rsResult.getDouble("BusinessSum");
                           dBalance5[m] = dBalance5[m] +
                             rsResult.getDouble("Balance");
                           FlagBool = "1";
                        }
                     }
                     if (FlagBool.equals("0")) {
                        dBusinessSum5[m] = rsResult.getDouble("BusinessSum");
                        dBalance5[m] = rsResult.getDouble("Balance");
                        CurrencyTotal5[m] = rsResult.getString(
                          "BusinessCurrency2");
                        p++;
                     }

                     //��ͬС�������
                     dTotalBusinessSum = dTotalBusinessSum +
                       rsResult.getDouble("BusinessSum") *
                       getRate(sCurrency, "01", Sqlca);
                     dTotalBalance = dTotalBalance +
                       rsResult.getDouble("Balance") *
                       getRate(sCurrency, "01", Sqlca);
                  */
                  }
                  rsResult.getStatement().close();
                  if (sBusinessSum3[j][i] == null)
                     sBusinessSum3[j][i] = "";
                  if (sBalance3[j][i] == null)
                     sBalance3[j][i] = "";

                  temp.append("<tr>");
                  temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >"+BusinessType[j][i]+"&nbsp;</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+CreditSum[j][i]+"</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBusinessSum3[j][i]+"</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBalance3[j][i]+"</td>");
                  temp.append("</tr> ");
                  sBusinessTypeLevel = sBusinessType;
                  i++;

                  sCustomerName = "";
               }
               rs.getStatement().close();
            }
         }
         else if (sDescribe6.equals("010")) {
            sSerialNo = "";
            //��������
            sSql = " select count(*) from BUSINESS_CONTRACT where  CustomerID=:sCustomerID " +
              " and nvl(CreditType,'01')!='11' " +
              " and CreditMode='1' and phaseno='1000' and RelativeSerialNo=:sObjectNo ";
            ARE.getLog().info("�������� sSql" + sSql);
            rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID).setParameter("sObjectNo", sObjectNo));
            if (rs.next()) {
               iCount6 = rs.getInt(1);
            }
            rs.getStatement().close();
            //���������ۺ�����Э�飬ȡЭ����ˮ�ź͵�����
            if (iCount6 > 0) {
               sSql = " select SerialNo,Maturity from BUSINESS_CONTRACT where  CustomerID=:sCustomerID " +
                 " and nvl(CreditType,'01')!='11' " +
                 " and CreditMode='1' and phaseno='1000' and RelativeSerialNo=:sObjectNo ";
               rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID).setParameter("sObjectNo", sObjectNo));
               if (rs.next()) {
                  sSerialNo = rs.getString("SerialNo");
                  sMaturity2 = rs.getString("Maturity");
                  if (sMaturity2 == null)
                     sMaturity2 = "";
                  if (sSerialNo == null)
                     sSerialNo = "";
               }
               rs.getStatement().close();
            }
            // ������û��Э�� ȡ������Ϣ
            if (iCount6 == 0) {
               sSql = " select BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency2," +
                 " nvl(BusinessSum,0) as BusinessSum" +
                 " from BUSINESS_APPROVE BA where  SerialNo=:sObjectNo ";
               rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
               if (rs.next()) {
                  sCurrency = rs.getString("Currency2");
                  sBusinessCurrency = rs.getString("BusinessCurrency");
                  BusinessSum[j][i] = DataConvert.toMoney(rs.getDouble("BusinessSum") / 10000.0);

                  if (BusinessSum[j][i] == null)
                     BusinessSum[j][i] = "";
                  if (sCurrency == null)
                     sCurrency = "";
                  if (sBusinessCurrency == null)
                     sBusinessCurrency = "";

                  //����С��
                  dApproveTotal[u] = dApproveTotal[u] + rs.getDouble("BusinessSum") * getRate(rs.getString("BusinessCurrency"), "01", Sqlca);

                  FlagBool = "0";
                  for (m = 0; m < k; m++) {
                     if ( !rs.getString("BusinessCurrency").equals(CurrencyTotal[m]) ) continue;
                    
                     dBusinessSum[m] = dBusinessSum[m] + rs.getDouble("BusinessSum");
                     FlagBool = "1";
                  }
                  if (FlagBool.equals("0")) {
                     dBusinessSum[k] = rs.getDouble("BusinessSum");
                     CurrencyTotal[k] = sCurrency;
                     k++;
                  }

                  temp.append("<tr>");
                  temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >�ۺ�����</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >���Ŷ��</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >&nbsp;"+sObjectNo+"</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+sCurrency+"</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+BusinessSum[j][i]+"</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                  temp.append("</tr> ");
                  i++;
                  sCurrency = "";
                  sCustomerName = "";
               }
               rs.getStatement().close();
               //�ۺ�����Э���Ӧ����������Ʒ����ϸ
               i = 0;
               sSql = " select BusinessType,getBusinessName(BusinessType) as BusinessType2,Currency,getItemName('Currency',Currency) as Currency2," +
                 " sum(nvl(CreditSum,0)) as CreditSum " +
                 " from CREDIT_INFO " +
                 " where  Objectno=:sObjectNo and ObjectType='BusinessApprove'" +
                 " group by  BusinessType,Currency order by BusinessType,Currency ";
               ARE.getLog().info("�ۺ�����Э���Ӧ����������Ʒ����ϸ    sSql====" + sSql);
               rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
               while (rs.next()) {
                  sBusinessType = rs.getString("BusinessType");
                  BusinessType[j][i] = rs.getString("BusinessType2");
                  sCurrency = rs.getString("Currency");
                  Currency[j][i] = rs.getString("Currency2");
                  CreditSum[j][i] = DataConvert.toMoney(rs.getDouble("CreditSum") / 10000.0);

                  if (BusinessType[j][i] == null)
                     BusinessType[j][i] = "";
                  if (Currency[j][i] == null)
                     Currency[j][i] = "";
                  if (CreditSum[j][i] == null)
                     CreditSum[j][i] = "";
                  if (sCurrency == null)
                     sCurrency = "";
                  if (sBusinessType == null)
                     sBusinessType = "";

                  temp.append("<tr>");
                  temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
                  temp.append("<td class=td1 align=left  colspan=1 >"+BusinessType[j][i]+"</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+CreditSum[j][i]+"</td>");
                  temp.append("<td class=td1 align=middle  colspan=1 >&nbsp</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                  temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                  temp.append("</tr> ");
                  i++;
                  sCustomerName = "";
               }
               rs.getStatement().close();
            }
            else {
               // ��������Э�飬Э��δ���ڻ�Э���º�ͬδ����
               sSql =
                 " select count(SerialNo) from BUSINESS_CONTRACT where  CustomerID=:sCustomerID " +
                 " and nvl(CreditType,'01')!='11' " +
                 " and CreditMode='2' and phaseno='1000' and CreditAggreement=:sSerialNo " +
                 " and (Maturity>='"+StringFunction.getToday()+"' or Maturity is null" +
                 " or nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)";
               rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID).setParameter("sSerialNo", sSerialNo));
               if (rs.next()) {
                  iCount2 = rs.getInt(1);
               }
               rs.getStatement().close();
               //Э��δ���ڣ�����Э������δ�����ͬ��ȡ������Ϣ
               if (sMaturity2.compareTo(StringFunction.getToday()) >= 0 ||
                   iCount2 > 0) {
                  sSql = " select BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency2," +
                    " nvl(BusinessSum,0) as BusinessSum" +
                    " from BUSINESS_APPROVE BA where  SerialNo=:sObjectNo ";
                  rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
                  if (rs.next()) {
                     sCurrency = rs.getString("Currency2");
                     sBusinessCurrency = rs.getString("BusinessCurrency");
                     BusinessSum[j][i] = DataConvert.toMoney(rs.getDouble("BusinessSum") / 10000.0);

                     if (BusinessSum[j][i] == null)
                        BusinessSum[j][i] = "";
                     if (sCurrency == null)
                        sCurrency = "";
                     if (sBusinessCurrency == null)
                        sBusinessCurrency = "";

                        //����С��
                     dApproveTotal[u] = dApproveTotal[u] + rs.getDouble("BusinessSum") * getRate(rs.getString("BusinessCurrency"), "01", Sqlca);

                     FlagBool = "0";
                     for (m = 0; m < k; m++) {
                        if (rs.getString("BusinessCurrency").equals(CurrencyTotal[m])) {
                           dBusinessSum[m] = dBusinessSum[m] + rs.getDouble("BusinessSum");
                           FlagBool = "1";
                        }
                     }
                     if (FlagBool.equals("0")) {
                        dBusinessSum[k] = rs.getDouble("BusinessSum");
                        CurrencyTotal[k] = sCurrency;
                        k++;
                     }

                     temp.append("<tr>");
                     temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
                     temp.append("<td class=td1 align=left  colspan=1 >�ۺ�����</td>");
                     temp.append("<td class=td1 align=left  colspan=1 >���Ŷ��</td>");
                     temp.append("<td class=td1 align=left  colspan=1 >&nbsp;"+sObjectNo+"</td>");
                     temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+sCurrency+"</td>");
                     temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+BusinessSum[j][i]+"</td>");
                     temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
                     temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                     temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
                     temp.append("</tr> ");

                     i++;
                     //sObjectNo="";
                     sCurrency = "";
                     sCustomerName = "";
                  }
                  rs.getStatement().close();

                  //�ۺ�����Э���Ӧ�ۺ���������������Ʒ����ϸ
                  i = 0;
                  sSql = " select BusinessType,getBusinessName(BusinessType) as BusinessType2,Currency,getItemName('Currency',Currency) as Currency2," +
                    " sum(nvl(CreditSum,0)) as CreditSum " +
                    " from CREDIT_INFO " +
                    " where  Objectno=:sObjectNo and ObjectType='BusinessApprove'" +
                    " group by  BusinessType,Currency order by BusinessType,Currency ";
                  ARE.getLog().info("�ۺ�����Э���Ӧ���������ۺ�������������Ʒ����ϸCREDIT_INFO    sSql====" + sSql);
                  rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
                  while (rs.next()) {
                     sBusinessType = rs.getString("BusinessType");
                     BusinessType[j][i] = rs.getString("BusinessType2");
                     sCurrency = rs.getString("Currency");
                     Currency[j][i] = rs.getString("Currency2");
                     CreditSum[j][i] = DataConvert.toMoney(rs.getDouble("CreditSum") / 10000.0);

                     if (BusinessType[j][i] == null)
                        BusinessType[j][i] = "";
                     if (Currency[j][i] == null)
                        Currency[j][i] = "";
                     if (CreditSum[j][i] == null)
                        CreditSum[j][i] = "";
                     if (sCurrency == null)
                        sCurrency = "";
                     if (sBusinessType == null)
                        sBusinessType = "";

                     SqlObject so=null;
                        //ȡ��ͬ���
                     if (!sBusinessType.equals(sBusinessTypeLevel)) {
                        sSqldata3 =
                          " select BusinessCurrency as BusinessCurrency2," +
                          " sum(getErate(BusinessCurrency,'"+sCurrency+"','"+StringFunction.getToday()+"')* nvl(BusinessSum,0)) as BusinessSum," +
                          " sum(getErate(BusinessCurrency,'"+sCurrency+"','"+StringFunction.getToday()+"')*" +
                          " (nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0))) as Balance " +
                          " from BUSINESS_CONTRACT " +
                          " where  CustomerID=:sCustomerID and nvl(CreditType,'01')!='11' " +
                          " and BusinessType like :sBusinessType " +
                          " and (BusinessCurrency in" +
                          " (select ItemNo from Code_Library where codeno='Currency' " +
                          " minus select Currency from Credit_Info where Objectno=:sObjectNo " +
                          " and ObjectType='BusinessApprove' and BusinessType=:sBusinessType) " +
                          " or BusinessCurrency =:sCurrency)" +
                          " and CreditMode='2' and phaseno='1000' " +
                          " and (Maturity>='" + StringFunction.getToday() + "' or  Maturity is null or nvl(balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)" +
                          " and CreditAggreement in(select SerialNo from business_contract where relativeserialno=:sObjectNo and creditmode='1')  " +
                          " group by BusinessCurrency";
                        ARE.getLog().info("ȡ��ͬ���BUSINESS_APPROVE    sSqldata3====" + sSqldata3);
                        so=new SqlObject(sSqldata3);
                        so.setParameter("sCustomerID", sCustomerID);
                        so.setParameter("sBusinessType", sBusinessType+"%");
                        so.setParameter("sObjectNo", sObjectNo);
                        so.setParameter("sBusinessType", sBusinessType);
                        so.setParameter("sCurrency", sCurrency);
                        so.setParameter("sObjectNo", sObjectNo);
                        rsResult = Sqlca.getASResultSet(so);
                     }
                     else {
                        sSqldata3 = " select BusinessCurrency as BusinessCurrency2,getItemName('Currency',BusinessCurrency) AS BusinessCurrency," +
                          " sum(getErate(BusinessCurrency,'"+sCurrency+"','"+StringFunction.getToday()+"')* nvl(BusinessSum,0)) as BusinessSum," +
                          " sum(getErate(BusinessCurrency,'"+sCurrency+"','" + StringFunction.getToday() + "')*" +
                          " (nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0))) as Balance " +
                          " from BUSINESS_CONTRACT " +
                          " where CustomerID=:sCustomerID and nvl(CreditType,'01')!='11' " +
                          " and BusinessType like :sBusinessType and BusinessCurrency=:sCurrency" +
                          " and CreditMode='2' and phaseno='1000' " +
                          " and (Maturity>='" + StringFunction.getToday() + "' or  Maturity is null or nvl(balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)" +
                          " and CreditAggreement in(select serialno from business_contract where relativeserialno=:sObjectNo and creditmode='1')  " +
                          " group by BusinessCurrency  ";
                        ARE.getLog().info("ȡ��ͬ���BUSINESS_APPROVE    sSqldata3====" + sSqldata3);
                        so=new SqlObject(sSqldata3);
                        so.setParameter("sCustomerID", sCustomerID);
                        so.setParameter("sBusinessType", sBusinessType+"%");
                        so.setParameter("sCurrency", sCurrency);
                        so.setParameter("sObjectNo", sObjectNo);
                        rsResult = Sqlca.getASResultSet(so);
                     }
                     if (rsResult.next()) {
                        sBusinessSum3[j][i] = DataConvert.toMoney(rsResult.getDouble("BusinessSum") / 10000.0);
                        sBalance3[j][i] = DataConvert.toMoney(rsResult.getDouble("Balance") / 10000.0);
                        /*FlagBool = "0";
                        for (m = 0; m < p; m++) {
                           if (rsResult.getString("BusinessCurrency2").equals(
                             CurrencyTotal5[m])) {
                              dBusinessSum5[m] = dBusinessSum5[m] +
                                rsResult.getDouble("BusinessSum");
                              dBalance5[m] = dBalance5[m] +
                                rsResult.getDouble("Balance");
                              FlagBool = "1";
                           }
                        }
                        if (FlagBool.equals("0")) {
                           dBusinessSum5[m] = rsResult.getDouble("BusinessSum");
                           dBalance5[m] = rsResult.getDouble("Balance");
                           CurrencyTotal5[m] = rsResult.getString(
                             "BusinessCurrency2");
                           p++;
                        }

                        //��ͬС�������
                        dTotalBusinessSum = dTotalBusinessSum +
                          rsResult.getDouble("BusinessSum") *
                          getRate(sCurrency, "01", Sqlca);
                        dTotalBalance = dTotalBalance +
                          rsResult.getDouble("Balance") *
                          getRate(sCurrency, "01", Sqlca);
                     */
                     }
                     rsResult.getStatement().close();
                     if (sBusinessSum3[j][i] == null)
                        sBusinessSum3[j][i] = "";
                     if (sBalance3[j][i] == null)
                        sBalance3[j][i] = "";

                     temp.append("<tr>");
                     temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
                     temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
                     temp.append("<td class=td1 align=left  colspan=1 >"+BusinessType[j][i]+"</td>");
                     temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
                     temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
                     temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+CreditSum[j][i]+"</td>");
                     if (sBusinessSum3[j][i].equals("") &&sBalance3[j][i].equals("")) {
                        temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
                     }else {
                        temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
                     }
                     temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBusinessSum3[j][i]+"</td>");
                     temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBalance3[j][i]+"</td>");
                     temp.append("</tr> ");
                     sBusinessTypeLevel = sBusinessType;
                     i++;
                     sCustomerName = "";
                  }
                  rs.getStatement().close();
               }

            }
         }

         i = 0;
         //���ʵ�������������Ч
         sObjectNo = "";
         sSql = " select SerialNo,getBusinessName(BusinessType) as BusinessType,BusinessCurrency as BusinessCurrency2," +
           " getItemName('Currency',BusinessCurrency) AS BusinessCurrency," +
           " nvl(BusinessSum,0) as BusinessSum" +
           " from BUSINESS_APPROVE BA where  CustomerID=:sCustomerID and nvl(CreditType,'01')!='11' " +
           " and CreditMode='2' and phaseno='1000' and approveflag='1' " +
           " and ( MONTHS_BETWEEN(TO_DATE('"+StringFunction.getToday()+"','YYYY/MM/DD'),TO_DATE(PUTOUTDATE,'YYYY/MM/DD'))<=3 or PUTOUTDATE is null ) " +
           " and ( Maturity>='"+StringFunction.getToday()+"' or Maturity is null) ";
         ARE.getLog().info("���ʵ�������������Ч  sSql====" + sSql);
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID));
         sName3 = "���ʵ���";
         while (rs.next()) {
            sObjectNo = rs.getString("SerialNo");
            BusinessType[j][i] = rs.getString("BusinessType");
            Currency[j][i] = rs.getString("BusinessCurrency");
            sCurrency = rs.getString("BusinessCurrency2");
            BusinessSum[j][i] = DataConvert.toMoney(rs.getDouble("BusinessSum") / 10000.0);

            if (BusinessSum[j][i] == null)
               BusinessSum[j][i] = "";
            if (sCurrency == null)
               sCurrency = "";
            if (sObjectNo == null)
               sObjectNo = "";
            if (BusinessType[j][i] == null)
               BusinessType[j][i] = "";

               //����С��
            dApproveTotal[u] = dApproveTotal[u] + rs.getDouble("BusinessSum") * getRate(rs.getString("BusinessCurrency2"), "01", Sqlca);

            FlagBool = "0";
            for (m = 0; m < k; m++) {
               if (rs.getString("BusinessCurrency2").equals(CurrencyTotal[m])) {
                  dBusinessSum[m] = dBusinessSum[m] + rs.getDouble("BusinessSum");
                  FlagBool = "1";
               }
            }
            if (FlagBool.equals("0")) {
               dBusinessSum[k] = rs.getDouble("BusinessSum");
               CurrencyTotal[k] = sCurrency;
               k++;
            }
            sBusinessSum2 = "";
            sBalance2 = "";
            sSqldata3 = " select BusinessCurrency as BusinessCurrency2,getItemName('Currency',BusinessCurrency) AS BusinessCurrency," +
              " nvl(BusinessSum,0) as BusinessSum," +
              " (nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)) as Balance " +
              " from BUSINESS_CONTRACT " +
              " where  CustomerID=:sCustomerID and nvl(CreditType,'01')!='11' " +
              " and CreditMode='2' and phaseno='1000'  and" +
              " (Maturity>='" + StringFunction.getToday() + "' or  Maturity is null or nvl(balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0) " +
              " and RelativeSerialNo=:sObjectNo  ";
            ARE.getLog().info("���ʵ��������к�ͬ��δ���壩,������Ч    sSqldata3====" +sSqldata3);
            rsResult = Sqlca.getASResultSet(new SqlObject(sSqldata3).setParameter("sCustomerID", sCustomerID).setParameter("sObjectNo", sObjectNo));
            if (rsResult.next()) {
               sBusinessCurrency2 = rsResult.getString("BusinessCurrency");
               sBusinessSum2 = DataConvert.toMoney(rsResult.getDouble("BusinessSum") / 10000.0);
               sBalance2 = DataConvert.toMoney(rsResult.getDouble("Balance") / 10000.0);

               if (sBusinessCurrency2 == null)
                  sBusinessCurrency2 = "";
               if (sBusinessSum2 == null)
                  sBusinessSum2 = "";
               if (sBalance2 == null)
                  sBalance2 = "";
               /*
               FlagBool = "0";
               for (m = 0; m < p; m++) {
                  if (rsResult.getString("BusinessCurrency2").equals(
                    CurrencyTotal5[m])) {
                     dBusinessSum5[m] = dBusinessSum5[m] +
                       rsResult.getDouble("BusinessSum");
                     dBalance5[m] = dBalance5[m] + rsResult.getDouble("Balance");
                     FlagBool = "1";
                  }
               }
               if (FlagBool.equals("0")) {
                  dBusinessSum5[m] = rsResult.getDouble("BusinessSum");
                  dBalance5[m] = rsResult.getDouble("Balance");
                  CurrencyTotal5[m] = rsResult.getString("BusinessCurrency2");
                  p++;
               }

               //��ͬС�������
               dTotalBusinessSum = dTotalBusinessSum +
                 rsResult.getDouble("BusinessSum") *
                 getRate(rsResult.getString("BusinessCurrency2"), "01", Sqlca);
               dTotalBalance = dTotalBalance +
                 rsResult.getDouble("Balance") *
                 getRate(rsResult.getString("BusinessCurrency2"), "01", Sqlca);
                */
            }
            rsResult.getStatement().close();
            if (sBusinessSum2.equals("") && sBalance2.equals("")) {
               sBusinessCurrency2 = "";
            }

            temp.append("<tr>");
            temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >"+sName3+"&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >"+BusinessType[j][i]+"&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+sObjectNo+"</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+BusinessSum[j][i]+"</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+sBusinessCurrency2+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBusinessSum2+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBalance2+"</td>");
            temp.append("</tr> ");
            i++;
            //sObjectNo="";
            sName3 = "";
            sCustomerName = "";
         }
         rs.getStatement().close();
         i = 0;
         //������ҵ��
         //������ҵ�񣬻���������Ч������δ����ĺ�ͬ
         //����������Ч�ۺ�����Э��
         sObjectNo = "";
         sSql =
           " select getBusinessName(BusinessType) as BusinessType,Currency,CreditBalance," +
           " getItemName('Currency',Currency) AS BusinessCurrency," +
           " nvl(CreditSum,0) as BusinessSum,nvl(CreditBalance,0) as CreditBalance" +
           " from CREDIT_INFO " +
           " where  ObjectNo in (select serialno from BUSINESS_CONTRACT " +
           " where CreditMode='1' and phaseno='1000' " +
           " and RelativeSerialNo is null and CustomerID=:sCustomerID1 " +
           " and finishdate is null and nvl(FreezeType,'01') !='04'" +
           " and ( Maturity>='" + StringFunction.getToday() + "' or Maturity is null) and Maturity in(select max(Maturity) from BUSINESS_CONTRACT " +
           " where CreditMode='1' and phaseno='1000' " +
           " and RelativeSerialNo is null and CustomerID=:sCustomerID2 " +
           " and finishdate is null and nvl(FreezeType,'01') !='04')" +
           ") order by BusinessType,Currency";
         ARE.getLog().info("����������Ч�ۺ�����Э��sSql====" + sSql);
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID1", sCustomerID).setParameter("sCustomerID2", sCustomerID));
         sName2 = "��������Э��";
         while (rs.next()) {

            BusinessType[j][i] = rs.getString("BusinessType");
            Currency[j][i] = rs.getString("BusinessCurrency");
            BusinessSum[j][i] = DataConvert.toMoney(rs.getDouble("BusinessSum") / 10000.0);
            sCreditBalance = DataConvert.toMoney(rs.getDouble("CreditBalance") / 10000.0);

            if (sCreditBalance == null)
               sCreditBalance = "";
            if (BusinessSum[j][i] == null)
               BusinessSum[j][i] = "";
            if (Currency[j][i] == null)
               Currency[j][i] = "";
            if (BusinessType[j][i] == null)
               BusinessType[j][i] = "";

            FlagBool = "0";
            for (m = 0; m < n; m++) {
               if (rs.getString("Currency").equals(CurrencyTotal3[m])) {
                  dBusinessSum3[m] = dBusinessSum3[m] + rs.getDouble("BusinessSum");
                  dBalance3[m] = dBalance3[m] + rs.getDouble("CreditBalance");
                  FlagBool = "1";
               }
            }
            if (FlagBool.equals("0")) {
               dBusinessSum3[n] = rs.getDouble("BusinessSum");
               dBalance3[n] = rs.getDouble("CreditBalance");
               CurrencyTotal3[n] = rs.getString("Currency");
               n++;
            }

            FlagBool = "0";
            for (m = 0; m < p; m++) {
               if (rs.getString("Currency").equals(CurrencyTotal5[m])) {
                  dBusinessSum5[m] = dBusinessSum5[m] + rs.getDouble("BusinessSum");
                  dBalance5[m] = dBalance5[m] + rs.getDouble("CreditBalance");
                  FlagBool = "1";
               }
            }
            if (FlagBool.equals("0")) {
               dBusinessSum5[m] = rs.getDouble("BusinessSum");
               dBalance5[m] = rs.getDouble("CreditBalance");
               CurrencyTotal5[m] = rs.getString("Currency");
               p++;
            }

            //��ͬС�������
            dTotalBusinessSum = dTotalBusinessSum + rs.getDouble("BusinessSum") * getRate(rs.getString("Currency"), "01", Sqlca);
            dTotalBalance = dTotalBalance + rs.getDouble("CreditBalance") * getRate(rs.getString("Currency"), "01", Sqlca);
            if (BusinessSum[j][i].equals("") && sCreditBalance.equals("")) {
               Currency[j][i] = "";
            }
            temp.append("<tr>");
            temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >"+sName2+"&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >"+BusinessType[j][i]+"&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+BusinessSum[j][i]+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sCreditBalance+"</td>");
            temp.append("</tr> ");
            i++;
            sCustomerName = "";
            sName2 = "";
         }
         rs.getStatement().close();
         i = 0;
         //����������Ч�ۺ�����Э��ȡ��ͬ
         sSql = " select getBusinessName(BusinessType) as BusinessType,BusinessCurrency as  BusinessCurrency2," +
           " getItemName('Currency',BusinessCurrency) AS BusinessCurrency," +
           " sum(nvl(BusinessSum,0)*getErate(BusinessCurrency,'01','"+StringFunction.getToday()+"')) as BusinessSum," +
           " sum((nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0))*getErate(BusinessCurrency,'01','"+StringFunction.getToday()+"')) as Balance " +
           " from BUSINESS_CONTRACT " +
           " where CreditAggreement in (select serialno from BUSINESS_CONTRACT " +
           " where CreditMode='1' and phaseno='1000' " +
           " and RelativeSerialNo is null and CustomerID=:sCustomerID1 and nvl(CreditType,'01')!='11' " +
           " and (finishdate is not null or nvl(FreezeType,'01') ='04' or Maturity< '"+StringFunction.getToday()+"') " +
           " and Maturity in (select max(Maturity) from BUSINESS_CONTRACT where CreditMode='1' and phaseno='1000' " +
           " and RelativeSerialNo is null and CustomerID=:sCustomerID2 " +
           " and nvl(CreditType,'01')!='11' and (finishdate is not null or nvl(FreezeType,'01')='04' or Maturity<'"+StringFunction.getToday()+"') " +
           " )) " +
           " and (Maturity>='" + StringFunction.getToday() + "' or  Maturity is null or nvl(balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)" +
           " and CreditMode='2' and phaseno='1000' group by BusinessType,BusinessCurrency order by BusinessType,BusinessCurrency";
         ARE.getLog().info("����������Ч�ۺ�����Э��ȡ��ͬ   sSql====" + sSql);
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID1", sCustomerID).setParameter("sCustomerID2", sCustomerID));
         while (rs.next()) {
            BusinessType[j][i] = rs.getString("BusinessType");
            Currency[j][i] = rs.getString("BusinessCurrency");
            BusinessSum[j][i] = DataConvert.toMoney(rs.getDouble("BusinessSum") / 10000.0);
            sBalance2 = DataConvert.toMoney(rs.getDouble("Balance") / 10000.0);

            if (sBalance2 == null)
               sBalance2 = "";
            if (BusinessSum[j][i] == null)
               BusinessSum[j][i] = "";
            if (Currency[j][i] == null)
               Currency[j][i] = "";
            if (BusinessType[j][i] == null)
               BusinessType[j][i] = "";

            FlagBool = "0";
            for (m = 0; m < n; m++) {
               if (rs.getString("BusinessCurrency2").equals(CurrencyTotal3[m])) {
                  dBusinessSum3[m] = dBusinessSum3[m] + rs.getDouble("BusinessSum");
                  dBalance3[m] = dBalance5[m] + rs.getDouble("Balance");
                  FlagBool = "1";
               }
            }
            if (FlagBool.equals("0")) {
               dBusinessSum3[m] = rs.getDouble("BusinessSum");
               dBalance3[m] = rs.getDouble("Balance");
               CurrencyTotal3[m] = rs.getString("BusinessCurrency2");
               n++;
            }

            FlagBool = "0";
            for (m = 0; m < p; m++) {
               if (rs.getString("BusinessCurrency2").equals(CurrencyTotal5[m])) {
                  dBusinessSum5[m] = dBusinessSum5[m] + rs.getDouble("BusinessSum");
                  dBalance5[m] = dBalance5[m] + rs.getDouble("Balance");
                  FlagBool = "1";
               }
            }
            if (FlagBool.equals("0")) {
               dBusinessSum5[m] = rs.getDouble("BusinessSum");
               dBalance5[m] = rs.getDouble("Balance");
               CurrencyTotal5[m] = rs.getString("BusinessCurrency2");
               p++;
            }

            //��ͬС�������
            dTotalBusinessSum = dTotalBusinessSum + rs.getDouble("BusinessSum") * getRate(rs.getString("BusinessCurrency2"), "01", Sqlca);
            dTotalBalance = dTotalBalance + rs.getDouble("Balance") * getRate(rs.getString("BusinessCurrency2"), "01", Sqlca);
            if (BusinessSum[j][i].equals("") && sBalance2.equals("")) {
               Currency[j][i] = "";
            }
            temp.append("<tr>");
            temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >��������Э��</td>");
            temp.append("<td class=td1 align=left  colspan=1 >"+BusinessType[j][i]+"&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+BusinessSum[j][i]+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBalance2+"</td>");
            temp.append("</tr> ");
            i++;
            sCustomerName = "";
         }
         rs.getStatement().close();
         i = 0;
         //��������ҵ���ͬ������������Ч������δ����ĺ�ͬ
         sSql = " select getBusinessName(BusinessType) as BusinessType," +
           " getItemName('Currency',BusinessCurrency) AS BusinessCurrency,BusinessCurrency as BusinessCurrency2," +
           " sum(nvl(BusinessSum,0)) as BusinessSum,sum(nvl(Balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)) as Balance " +
           " from BUSINESS_CONTRACT where  CreditMode='2' and phaseno='1000' " +
           " and (RelativeSerialNo is null or RelativeSerialNo in(select SerialNo from BUSINESS_APPROVE " +
           " WHERE CustomerID=:sCustomerID and nvl(CreditType,'01')!='11'  AND CreditMode='2' and  phaseno='1000' and approveflag='1' " +
           " and (( MONTHS_BETWEEN(TO_DATE('"+StringFunction.getToday()+"','YYYY/MM/DD'),TO_DATE(PUTOUTDATE,'YYYY/MM/DD'))>3 ) " +
           " or ( Maturity<'" + StringFunction.getToday() + "')) " +
           " ))" +
           " and CreditAggreement is null and CustomerID=:sCustomerID2 and nvl(CreditType,'01')!='11' " +
           " and (Maturity>='" + StringFunction.getToday() + "' or Maturity is null or nvl(balance1,0)+nvl(Balance2,0)+nvl(InterestSum1,0)>0)" +
           " group by BusinessType,BusinessCurrency order by BusinessType,BusinessCurrency";
         ARE.getLog().info("��������ҵ���ͬ������������Ч������δ����ĺ�ͬ sSql====" + sSql);
         rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID).setParameter("sCustomerID2", sCustomerID));
         sName4 = "�������ĺ�ͬ";
         while (rs.next()) {
            BusinessType[j][i] = rs.getString("BusinessType");
            Currency[j][i] = rs.getString("BusinessCurrency");
            BusinessSum[j][i] = DataConvert.toMoney(rs.getDouble("BusinessSum") / 10000.0);
            sBalance2 = DataConvert.toMoney(rs.getDouble("Balance") / 10000.0);

            if (sBalance2 == null)
               sBalance2 = "";
            if (BusinessSum[j][i] == null)
               BusinessSum[j][i] = "";
            if (Currency[j][i] == null)
               Currency[j][i] = "";
            if (BusinessType[j][i] == null)
               BusinessType[j][i] = "";

            FlagBool = "0";
            for (m = 0; m < n; m++) {
               if (rs.getString("BusinessCurrency2").equals(CurrencyTotal3[m])) {
                  dBusinessSum3[m] = dBusinessSum3[m] + rs.getDouble("BusinessSum");
                  dBalance3[m] = dBalance3[m] + rs.getDouble("Balance");
                  FlagBool = "1";
               }
            }
            if (FlagBool.equals("0")) {
               dBusinessSum3[n] = rs.getDouble("BusinessSum");
               dBalance3[n] = rs.getDouble("Balance");
               CurrencyTotal3[n] = rs.getString("BusinessCurrency2");
               n++;
            }

            FlagBool = "0";
            for (m = 0; m < p; m++) {
               if (rs.getString("BusinessCurrency2").equals(CurrencyTotal5[m])) {
                  dBusinessSum5[m] = dBusinessSum5[m] + rs.getDouble("BusinessSum");
                  dBalance5[m] = dBalance5[m] + rs.getDouble("Balance");
                  FlagBool = "1";
               }
            }
            if (FlagBool.equals("0")) {
               dBusinessSum5[m] = rs.getDouble("BusinessSum");
               dBalance5[m] = rs.getDouble("Balance");
               CurrencyTotal5[m] = rs.getString("BusinessCurrency2");
               p++;
            }

            //��ͬС�������
            dTotalBusinessSum = dTotalBusinessSum + rs.getDouble("BusinessSum") * getRate(rs.getString("BusinessCurrency2"), "01", Sqlca);
            dTotalBalance = dTotalBalance + rs.getDouble("Balance") * getRate(rs.getString("BusinessCurrency2"), "01", Sqlca);
            if (BusinessSum[j][i].equals("") && sBalance2.equals("")) {
               Currency[j][i] = "";
            }
            temp.append("<tr>");
            temp.append("<td class=td1 align=left  colspan=1 >"+sCustomerName+"&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >"+sName4+"&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >"+BusinessType[j][i]+"&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+Currency[j][i]+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+BusinessSum[j][i]+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+sBalance2+"</td>");
            temp.append("</tr> ");
            i++;
            sName4 = "";
            sCustomerName = "";
         }
         rs.getStatement().close();
         //����С��
         //dApproveTotal[u]=dApproveTotal[u];
         //��˾С�� û��ҵ��Ŀͻ�����ʾС��
         if (sCustomerName.equals("")) {
            temp.append("<tr>");
            temp.append("<td class=td1 align=left  colspan=1 ><B>ռ���ܶ��С��</B></td>");
            temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >�����</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dApproveTotal[u] / 10000.0)+"</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >�����</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dTotalBusinessSum / 10000.0)+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dTotalBalance / 10000.0)+"</td>");
            temp.append("</tr> ");
         }
         j++;
         i = 0;
         u++;
      }
      rsdata.getStatement().close();

      temp.append("<tr>");
      temp.append("<td class=td1 align=middle  colspan=9 bgcolor=#aaaaaa height='40px'><font style=\" font-size: 14pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#aaaaaa\";>ռ���ܶ����Ϣ</font></td>");
      temp.append("</tr> ");

      for (m = 0; m < k; m++) {
         //ARE.getLog().info("CurrencyTotal["+m+"]"+CurrencyTotal[m]);
    	  ARE.getLog().info("dBusinessSum[" + m + "]" + dBusinessSum[m]);
      }

      for (m = 0; m < k; m++) {
         //ARE.getLog().info("CurrencyTotal3["+m+"]"+CurrencyTotal3[m]);
         //ARE.getLog().info("dBusinessSum3["+m+"]"+dBusinessSum3[m]);
      }
      //���С��
      String sName = "";
      double dsum = 0, dBala = 0.0;
      // ���������г�
      for (m = 1; m < k; m++) {
         dsum = 0;
         dBala = 0.0;

         for (i = 1; i < p; i++) {
            if (CurrencyTotal5[i].equals(CurrencyTotal[m])) {
               dsum = dBusinessSum5[i];
               dBala = dBalance5[i];
            }
         }

         sSql = " select Itemname from code_library where codeno='Currency' " +
           " and itemno='" + CurrencyTotal[m] + "'";
         rs = Sqlca.getASResultSet(sSql);
         if (rs.next()) {
            sName = rs.getString("Itemname");
         }
         rs.getStatement().close();
         if (sName == null)
            sName = "";

         temp.append("<tr>");
         temp.append("<td class=td1 align=left  colspan=1 ><B>ռ���ܶ�����С��</B></td>");
         temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+sName+"</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBusinessSum[m] / 10000.0)+"</td>");
         temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+sName+"</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dsum / 10000.0)+"</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBala / 10000.0)+"</td>");
         temp.append("</tr> ");
      }
      //��ͬ���ֲ���������
      String sFlag = "";
      for (m = 1; m < p; m++) {
         sFlag = "false";
         for (i = 1; i < k; i++) {
            if (CurrencyTotal[i].equals(CurrencyTotal5[m])) {
               sFlag = "true";
            }
         }
         if (sFlag == "false") {
            sSql =
              " select Itemname from code_library where codeno='Currency' " +
              " and itemno='" + CurrencyTotal5[m] + "'";
            rs = Sqlca.getASResultSet(sSql);
            if (rs.next()) {
               sName = rs.getString("Itemname");
            }
            rs.getStatement().close();
            if (sName == null)
               sName = "";

            temp.append("<tr>");
            temp.append("<td class=td1 align=left  colspan=1 ><B>ռ���ܶ�����С��</B></td>");
            temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
            temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;"+sName+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBusinessSum5[m] / 10000.0)+"</td>");
            temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBalance5[m] / 10000.0)+"</td>");
            temp.append("</tr> ");
         }
      }

      //�����С��
      temp.append("<tr>");
      temp.append("<td class=td1 align=left  colspan=1 ><B>ռ���ܶ�������С��</B></td>");
      temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
      temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
      temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
      temp.append("<td class=td1 align=middle  colspan=1 >�����</td>");
      temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBusinessSum[0] / 10000.0)+"</td>");
      temp.append("<td class=td1 align=middle  colspan=1 >�����</td>");
      temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBusinessSum5[0] / 10000.0)+"</td>");
      temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBalance5[0] / 10000.0)+"</td>");
      temp.append("</tr> ");
      //����Һϼ�
      //�����ϼ�
      double dsum5 = 0.0;
      dsum = 0;
      dBala = 0.0;
      for (i = 0; i < k; i++) {
         dsum = dsum + dBusinessSum[i] * getRate(CurrencyTotal[i], "01", Sqlca);
      }
      //��ͬ�ϼ�
      for (i = 0; i < p; i++) {
         if (CurrencyTotal5[i] == null)
            CurrencyTotal5[i] = "";
         	dsum5 = dsum5 + dBusinessSum5[i] * getRate(CurrencyTotal5[i], "01", Sqlca);
         	dBala = dBala + dBalance5[i] * getRate(CurrencyTotal5[i], "01", Sqlca);
      }
      temp.append("<tr>");
      temp.append("<td class=td1 align=left  colspan=1 ><B>ռ���ܶ�ȱ���Һϼ�</B></td>");
      temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
      temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
      temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
      temp.append("<td class=td1 align=middle nowrap colspan=1 >�����</td>");
      temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dsum / 10000.0)+"</td>");
      temp.append("<td class=td1 align=middle nowrap colspan=1 >�����</td>");
      temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dsum5 / 10000.0)+"</td>");
      temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBala / 10000.0)+"</td>");
      temp.append("</tr> ");
      if (sAttribute2.equals("1")) {
         temp.append("<tr>");
         temp.append("<td class=td1 align=middle  colspan=9 bgcolor=#aaaaaa height='40px'><font style=\" font-size: 14pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#aaaaaa\";>���ö����Ϣ</font></td>");
         temp.append("</tr> ");

         //���ã���������ȣ�����Һϼƣ�
         dTotal = dTotal - dsum;
         for (i = 0; i < n; i++) {
            if (CurrencyTotal3[i] == null)
            	CurrencyTotal3[i] = "";
            	dTotal = dTotal - dBusinessSum3[i] * getRate(CurrencyTotal3[i], "01", Sqlca);
            	//dBala=dBala+dBalance5[i]*getRate(CurrencyTotal5[i],"01",Sqlca);
         }
         temp.append("<tr>");
         temp.append("<td class=td1 align=left  colspan=4 ><B>���ã���������ȣ�����Һϼƣ�</B></td>");
         //temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
         //temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
         //temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=middle nowrap colspan=1 >�����</td>");
         temp.append("<td class=td1 align=right nowrap colspan=1 >&nbsp;"+DataConvert.toMoney(dTotal / 10000.0)+"</td>");
         temp.append("<td class=td1 align=middle  colspan=3 >&nbsp;</td>");
         //temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
         //temp.append("<td class=td1 align=right  colspan=1 >&nbsp;</td>");
         temp.append("</tr> ");
      }
      else {
         dsum5 = 0.0;
         dsum = 0;
         dBala = 0.0;
         for (i = 0; i < m; i++) {
            if (CurrencyTotal[i] == null)
            	CurrencyTotal[i] = "";
            	dsum = dsum + dBusinessSum[i] * getRate(CurrencyTotal[i], "01", Sqlca);
            	//dBala=dBala+dBalance5[i]*getRate(CurrencyTotal5[i],"01",Sqlca);
         }
         for (i = 0; i < n; i++) {
            if (CurrencyTotal3[i] == null)
            	CurrencyTotal3[i] = "";
            	dsum = dsum + dBusinessSum3[i] * getRate(CurrencyTotal3[i], "01", Sqlca);
            	//dBala=dBala+dBalance5[i]*getRate(CurrencyTotal5[i],"01",Sqlca);
         }
         for (i = 0; i < p; i++) {
            if (CurrencyTotal[i] == null)
            	CurrencyTotal[i] = "";
            	dsum5 = dsum5 + dBusinessSum5[i] * getRate(CurrencyTotal5[i], "01", Sqlca);
            	dBala = dBala + dBalance5[i] * getRate(CurrencyTotal5[i], "01", Sqlca);
         }
         temp.append("<tr>");
         temp.append("<td class=td1 align=left  colspan=1 ><B>�����ܶ��</B></td>");
         temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=left  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=middle  colspan=1 >&nbsp;</td>");
         temp.append("<td class=td1 align=middle nowrap colspan=1 >�����</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dsum / 10000.0)+"</td>");
         temp.append("<td class=td1 align=middle  colspan=1 >�����</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dsum5 / 10000.0)+"</td>");
         temp.append("<td class=td1 align=right  colspan=1 >&nbsp;"+DataConvert.toMoney(dBala / 10000.0)+"</td>");
         temp.append("</tr> ");
      }
      temp.append("</body>");

      temp.append("                    </table>");
      temp.append("			</div>");
      temp.append("		</td>");
      temp.append("	</tr>");

      temp.append("</table>");

      result = temp.toString();
      result = StringFunction.replace(result, "<TABLE ", "<TABLE align=center ");
      result = StringFunction.replace(result, "\\r\\n", "<br>");
      //return result;
      this.sResult=result;
      this.Totalsum=dTotalsum;
      this.UsedTotal=dTotal;
   }
/*   //����ʹ��
    public static void main(String [] argv)
    {
      try
      {
         AggregateCreditInfo aggregate= new AggregateCreditInfo();
         Transaction Sqlca = null;//new Transaction("XD");//���ݿ����ֱ���ķ�ʽ

        System.out.println("-----------------begin--------------------");
        aggregate.AggregateCredit("",Sqlca);
        String s = aggregate.sResult;
        System.out.println("-----------------end--------------------");
      }catch(Exception e){
        System.out.println("main:"+e.toString());
      }

    }
*/
}                          