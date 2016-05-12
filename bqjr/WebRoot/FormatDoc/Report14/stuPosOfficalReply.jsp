<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   ���� 1:display;2:save;3:preview;6:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//��õ��鱨������
	String sSql = "select bc.CreditID,bc.StoreCityCode,bc.SubProductType,bc.SureType,bc.CustomerID,bc.CustomerName,bc.BusinessType,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName,bc.Stores as Stores,getTypeName(bc.BusinessRange1,bc.BusinessType1) as BusinessType1,getTypeName(bc.BusinessRange2,bc.BusinessType2) as BusinessType2,getTypeName(bc.BusinessRange3,bc.BusinessType3) as BusinessType3,"+
					" bc.TotalPrice,bc.BusinessType1,bc.BrandType1,bc.Price1,bc.BusinessType2,bc.BrandType2,bc.Price2,bc.BusinessType3,bc.BrandType3,bc.Price3,getitemname('BankCode',bc.RepaymentBank) as RepaymentBank, "+
					" bc.BusinessType2 btype2, bc.BusinessSum-bc.BusinessSum2 ActualSum,bc.TotalPrice-bc.Price2 BbdTotalPrice," + //CCS-1256 �۱�����by fangxq 20160311
					" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,bc.RepaymentName,bc.PutOutDate,bc.Manufacturer1,bc.Manufacturer2,bc.Manufacturer3,bc.InputDate,bc.InputUserID from Business_Contract bc where SerialNo = '"+sObjectNo+"'";

	String sSureType = "";//ҵ����Դ
	String customerSignUrl = CodeCache.getItem("SignAppUrl","0010").getItemAttribute();
	String salesmanSignUrl = CodeCache.getItem("SignAppUrl","0020").getItemAttribute();
	String appCustomerSign = "&nbsp;&nbsp;<img src='"+customerSignUrl+sObjectNo+"' width='100' height='30'/>";
	String appSalesmanSign = "<img src='"+salesmanSignUrl+sObjectNo+"' width='100' height='30'/>";
	String customerSign = "___________________";//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	String salesmanSign = "";//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	String sCustomerID = "";//�ͻ����
	String sBusinessType = "";//��Ʒ���
	String sCustomerName = "";//�ͻ�����
	String sCertID = "";//֤������
	String sBusinessSum = "";//������
	String sEndTime = "";//���ʱ��
	String sBusinessType1 = "";//��Ʒ����1
	String sBrandType1 = "";//Ʒ���ͺ�1
	String sPrice1="";//�۸�1
	String sBusinessType2 = "";//��Ʒ����2
	String sBrandType2 = "";//Ʒ���ͺ�2
	String sPrice2="";//�۸�2	
	String sBusinessType3 = "";//��Ʒ����3
	String sBrandType3 = "";//Ʒ���ͺ�3
	String sPrice3="";//�۸�3
	String sMonthRepayMent = "";//ÿ�»����
	String sTotalSum="";//�Ը��ܽ��
	String sPeriods="";//����
	String sRepaymentNo="";//�����˺�
	String sRepaymentBank="";//��������
	String sRepaymentName="";//�����
	String sPutOutDate="";//
	String sStores="";//
	String sManufacturer1 = "";
	String sManufacturer2 = "";
	String sManufacturer3 = "";
	String sInputDate = "";
	String sInputUserID = "";
	String sCreditID = "",sStoreCityCode="",sSubProductType="";
	//�Ը���Ԫ��
	//δ�����Ԫ��
	//ÿ�»���Ԫ��
	//��������
	//�״λ�����
	//ÿ�»�����
	//ָ�������˻��˺�
	//��������
	//����
	//���۹�������/����
	//�̼��Ƽ���Ա
	String sInteriorCode = "";//���۵����
	String sTotalPrice = "";//��Ʒ�ܼۣ�Ԫ��
	String sStoresName = "";
	
	//-- CCS-1256 �۱��� by fangxq 20160311 --//
	String btype2 = ""; //�۱����ж���Ŀ���ʹ���
	String sActualSum = ""; //ȥ����Ʒ����2�Ĵ����
	String sBbdTotalPrice = "";//ȥ���۱����۸񣨼۸�2������Ʒ�ܼ�
	//-- end --//

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	String sDay = StringFunction.getToday().replaceAll("/","");
	sTemp.append("	<form method='post' action='ApproveReport.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable >");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		sCreditID = rs2.getString("CreditID");
		sStoreCityCode = rs2.getString("StoreCityCode");
		sSubProductType = rs2.getString("SubProductType");
		sSureType = rs2.getString("SureType");
		sCustomerID = rs2.getString("CustomerID");
		sCustomerName = rs2.getString("CustomerName");
		sBusinessType = rs2.getString("BusinessType");
		sBusinessSum = DataConvert.toMoney(rs2.getString("BusinessSum"));
		sInteriorCode = rs2.getString("InteriorCode");
		sTotalPrice = DataConvert.toMoney(rs2.getString("TotalPrice"));
		sStoresName = rs2.getString("StoresName");
		sBusinessType1 = rs2.getString("BusinessType1");
		sBrandType1 = rs2.getString("BrandType1");
		sPrice1 = DataConvert.toMoney(rs2.getString("Price1"));
		sBusinessType2 = rs2.getString("BusinessType2");
		sBrandType2 = rs2.getString("BrandType2");
		sPrice2 = DataConvert.toMoney(rs2.getString("Price2"));
		sBusinessType3 = rs2.getString("BusinessType3");
		sBrandType3 = rs2.getString("BrandType3");
		sPrice3 = DataConvert.toMoney(rs2.getString("Price3"));
		sTotalSum=DataConvert.toMoney(rs2.getString("TotalSum"));
		sMonthRepayMent=DataConvert.toMoney(rs2.getString("MonthRepayMent"));
		sRepaymentNo=rs2.getString("RepaymentNo");
		//sRepaymentBank=rs2.getString("RepaymentBank");
		sRepaymentName=rs2.getString("RepaymentName");
		sPutOutDate=rs2.getString("PutOutDate");
		sPeriods=rs2.getString("Periods");
		sStores=rs2.getString("Stores");
		sManufacturer1 = rs2.getString("Manufacturer1");
		sManufacturer2 = rs2.getString("Manufacturer2");
		sManufacturer3 = rs2.getString("Manufacturer3");
		
		//CCS-1256 �۱���   by fangxq 
		btype2 = rs2.getString("btype2"); //�۱����ж���Ŀ���ʹ���
		sActualSum=rs2.getString("ActualSum");
		sBbdTotalPrice = rs2.getString("BbdTotalPrice");
		//end
		
		//sInputDate = rs2.getString("InputDate");
		sInputDate = Sqlca.getString(new SqlObject("SELECT PHASEOPINION3 FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
		if (sInputDate == null) {
			sInputDate = Sqlca.getString(new SqlObject("SELECT endtime FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
		}
		sInputUserID = rs2.getString("InputUserID");

		if(sCustomerID == null) sCustomerID ="&nbsp;";
		if(sCustomerName == null) sCustomerName ="&nbsp;";
		if(sBusinessType == null) sBusinessType ="&nbsp;";
		if(sBusinessSum == null) sBusinessSum ="&nbsp;";
		if(sInteriorCode == null) sInteriorCode ="&nbsp;";
		if(sStoresName == null) sStoresName ="&nbsp;";
		if(sBusinessType1 == null) sBusinessType1 ="&nbsp;";
		if(sBrandType1 == null) sBrandType1 ="&nbsp;";
		if(sPrice1 == null) sPrice1 ="&nbsp;";
		if(sBusinessType2 == null) sBusinessType2 ="&nbsp;";
		if(sBrandType2 == null) sBrandType2 ="&nbsp;";
		if(sPrice2 == null) sPrice2 ="&nbsp;";
		if(sBusinessType3 == null) sBusinessType3 ="&nbsp;";
		if(sBrandType3 == null) sBrandType3 ="&nbsp;";
		if(sPrice3 == null) sPrice3 ="&nbsp;";
		if(sTotalSum == null) sTotalSum ="&nbsp;";
		if(sMonthRepayMent == null) sMonthRepayMent ="&nbsp;";
		if(sRepaymentNo == null) sRepaymentNo ="&nbsp;";
		//if(sRepaymentBank == null) sRepaymentBank ="&nbsp;";
		if(sRepaymentName == null) sRepaymentName ="&nbsp;";
		if(sTotalPrice == null) sTotalPrice ="&nbsp;";
		if(sPutOutDate == null) sPutOutDate ="&nbsp;";
		if(sPeriods == null) sPeriods ="&nbsp;";
		if(sStores == null) sStores ="&nbsp;";
		if(sManufacturer1 == null) sManufacturer1 ="&nbsp;";
		if(sManufacturer2 == null) sManufacturer2 ="&nbsp;";
		if(sManufacturer3 == null) sManufacturer3 ="&nbsp;";
		if(sInputDate == null) sInputDate ="&nbsp;";
		if(sInputUserID == null) sInputUserID ="&nbsp;";

		//CCS-1256 �۱�����by fangxq 20160311
		if(sActualSum == null) sActualSum = "&nbsp;";
		if(sBbdTotalPrice == null) sBbdTotalPrice = "&nbsp;";
		//end
		
		//sRepaymentBank = "�������������ĺ�֧��";
		
	}

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

	//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	//sSureType = "APP";
	if("APP".equals(sSureType)){
		customerSign = appCustomerSign;
		salesmanSign = appSalesmanSign;
	}
	
	String sAddress = Sqlca.getString(new SqlObject("select getItemName('AreaCode',CITY)||ADDRESS as Address from STORE_INFO where SNO =:SNO").setParameter("SNO", sStores));
	
	//ȡ��ͬ״̬
	String sContractStatus = Sqlca.getString(new SqlObject("select CASE WHEN ContractStatus IN ( '020', '050','080','090') THEN '����׼'  WHEN ContractStatus = '010' THEN '�ѷ��'  WHEN ContractStatus = '100' THEN '��ȡ��' ELSE getItemName('ContractStatus',ContractStatus) END from business_contract where SerialNo =:ObjectNo").setParameter("ObjectNo", sObjectNo));
	
	//�״λ�����
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String businessDate = SystemConfig.getBusinessDate();
	if(!sPutOutDate.equals("&nbsp;")){	
		sFirstDueDate = Sqlca.getString(new SqlObject("select FirstDueDate from acct_rpt_segment where objectno = :objectNo ").setParameter("objectNo", sObjectNo));
		sDefaultDueDay = sFirstDueDate.substring(8,10);
	}
	//Double sFutureAmt = Arith.round(Double.parseDouble(sMonthRepayMent)*Integer.parseInt(sPeriods, 10),2);//Ӧ���ܽ��
	String sFutureAmt = DataConvert.toMoney(sBusinessSum);//δ������

	
	sCertID = Sqlca.getString("select CertID from Customer_Info where CustomerID = '"+sCustomerID+"'");
	//sEndTime = Sqlca.getString("");
		
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=0 >	");
		
		sTemp.append("   <tr>");
		sTemp.append("<td colspan=1 rowspan=2 style='margin-left:30%' align=left><img src='"+sWebRootPath+"/FormatDoc/Images/121.jpg' /></td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	
		sTemp.append("<table class=table1 width='660' height='300' align=center border=0 cellspacing=0 cellpadding=0 >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><b>�������鼰�Ը����֧��ȷ����</b></td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>��ͬ��ţ�</b>"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>�̼ң�</b>"+sStoresName+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>�̼ҵ�ַ��</b>"+sAddress+"&nbsp;</td>");
		//sTemp.append("   <td colspan=2 align=left class=td1 ><b>���۵���룺</b>"+sInteriorCode+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>���۵���룺</b>"+sStores+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >1.�ͻ�������"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >2.����֤���룺"+sCertID+"&nbsp;</td>");
		
		//CCS-1256  �۱��� by fangxq 20160314
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >3.��Ʒ�ܼۣ�Ԫ����"+sBbdTotalPrice+"&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >3.��Ʒ�ܼۣ�Ԫ����"+sTotalPrice+"&nbsp;</td>");
		}
		//end 
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >4.��Ʒ���ͣ�1����"+sBusinessType1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >5.��Ʒ�ͺţ�1����"+sManufacturer1+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >6.Ʒ�ƣ�1����"+sBrandType1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >7.�۸�1����"+sPrice1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		
		//CCS-1256  �۱��� by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >8.��Ʒ���ͣ�2����&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >9.��Ʒ�ͺţ�2����&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.Ʒ�ƣ�2����&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >11.�۸�2����&nbsp;</td>");
			
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >8.��Ʒ���ͣ�2����"+sBusinessType2+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >9.��Ʒ�ͺţ�2����"+sManufacturer2+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.Ʒ�ƣ�2����"+sBrandType2+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >11.�۸�2����"+sPrice2+"&nbsp;</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >8.��Ʒ���ͣ�3����"+sBusinessType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >9.��Ʒ�ͺţ�3����"+sManufacturer3+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >10.Ʒ�ƣ�3����"+sBrandType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >11.�۸�3����"+sPrice3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		//sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.������� : ǩ���/�ܾ�/ȡ��/�Ƴ�</b>&nbsp;</td>");
		sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.������� : "+sContractStatus+"&nbsp;</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>II.���Ѵ�������ժҪ</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >12.�Ը���Ԫ����"+sTotalSum+"&nbsp;</td>");
		
		//CCS-1256  �۱��� by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=4 align=left class=td1 >13.δ�����Ԫ����"+sActualSum+"&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=4 align=left class=td1 >13.δ�����Ԫ����"+sFutureAmt+"&nbsp;</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >14.��Ʒ���룺"+sBusinessType+"&nbsp;</td>");
		
		//CCS-1256  �۱��� by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >15.�����Ԫ����"+sActualSum+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.����������"+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.�״λ����գ�"+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.ÿ�»����գ�"+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >19.ָ�������˻��˺ţ�"+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >20.�������У�"+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >21.������"+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͻ����̼�ǩ���ļ���ȷ�ϣ��Ա��ļ�ǩ��ʱ����1��������Ʒ����׼ȷ����2���ͻ���֧��"+sTotalSum+"ԪΪ�Ը�����3�������º��̼�����֪ͨ�ͻ��������̼�֮������ʹ����δ�Ӵ����˴��յ�����𣬷���ͻ����̼Ҿ���Ϊ��Ʒ�ۿ���ȫ��֧���������������Ը�����4������Э������Ʒ�����ͬ�Ƕ����ķ��ɹ�ϵ�������˲����̼����ṩ��Ʒ�������е��κ����Σ���5���繺�����Ʒ�ǻ����ͻ���ȡ�ø���Ʒ��ȡ��ƾ֤��������Ʒ�����Э���е�����һ�£���������ʹ�ã���6���繺�����Ʒ�Ƿ������ۿͻ��Ƿ�ʵ�����ܸ÷��񣬿ͻ����밴�մ���Э�鳥�����</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.ϵͳʹ��&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >22.������ڼ�ʱ�䣺"+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.���۹�������/���룺"+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.���۹���ǩ����"+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >25.�̼��Ƽ���Ա��</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >26.�̼ҽ�����ǩ����</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >15.�����Ԫ����"+sBusinessSum+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.ÿ�»���Ԫ����"+sMonthRepayMent+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.����������"+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.�״λ����գ�"+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >19.ÿ�»����գ�"+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >20.ָ�������˻��˺ţ�"+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >21.�������У�"+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >22.������"+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͻ����̼�ǩ���ļ���ȷ�ϣ��Ա��ļ�ǩ��ʱ����1��������Ʒ����׼ȷ����2���ͻ���֧��"+sTotalSum+"ԪΪ�Ը�����3�������º��̼�����֪ͨ�ͻ��������̼�֮������ʹ����δ�Ӵ����˴��յ�����𣬷���ͻ����̼Ҿ���Ϊ��Ʒ�ۿ���ȫ��֧���������������Ը�����4������Э������Ʒ�����ͬ�Ƕ����ķ��ɹ�ϵ�������˲����̼����ṩ��Ʒ�������е��κ����Σ���5���繺�����Ʒ�ǻ����ͻ���ȡ�ø���Ʒ��ȡ��ƾ֤��������Ʒ�����Э���е�����һ�£���������ʹ�ã���6���繺�����Ʒ�Ƿ������ۿͻ��Ƿ�ʵ�����ܸ÷��񣬿ͻ����밴�մ���Э�鳥�����</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.ϵͳʹ��&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.������ڼ�ʱ�䣺"+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.���۹�������/���룺"+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >25.���۹���ǩ����"+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >26.�̼��Ƽ���Ա��</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >27.�̼ҽ�����ǩ����</td>");
		}
		//end
		
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 >�̼����ƣ����£���_____________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ͻ�ǩ��:"+customerSign+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	sTemp.append("</div>");	
	sTemp.append("<div align=center>");	
	sTemp.append("<font style=' font-size: 9pt;' >�汾��XF_TY_TY_2016030902 �̼���</font></br>");//update  by fangxq 20160316 �۱���
	sTemp.append("----------------------------------------------------------------------------------");
	sTemp.append("</div>");	
	
	sTemp.append("<div id=reporttable >");
		
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=0 >	");
		
		sTemp.append("   <tr>");
		sTemp.append("<td colspan=1 rowspan=2 style='margin-left:30%' align=left><img src='"+sWebRootPath+"/FormatDoc/Images/121.jpg' /></td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		
		sTemp.append("<table class=table1 width='660' height='300' align=center border=0 cellspacing=0 cellpadding=0  >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><b>�������鼰�Ը����֧��ȷ����</b></td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>��ͬ��ţ�</b>"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>�̼ң�</b>"+sStoresName+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>�̼ҵ�ַ��</b>"+sAddress+"&nbsp;</td>");
		//sTemp.append("   <td colspan=2 align=left class=td1 ><b>���۵���룺</b>"+sInteriorCode+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>���۵���룺</b>"+sStores+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >1.�ͻ�������"+sCustomerName+"</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >2.����֤���룺"+sCertID+"</td>");
		
		//CCS-1256  �۱��� by fangxq 20160314
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >3.��Ʒ�ܼۣ�Ԫ����"+sBbdTotalPrice+"</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >3.��Ʒ�ܼۣ�Ԫ����"+sTotalPrice+"</td>");
		}
		//end 
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >4.��Ʒ���ͣ�1����"+sBusinessType1+"</td>");
		sTemp.append("   <td align=left class=td1 >5.��Ʒ�ͺţ�1����"+sManufacturer1+"</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >6.Ʒ�ƣ�1����"+sBrandType1+"</td>");
		sTemp.append("   <td align=left class=td1 >7.�۸�1����"+sPrice1+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		
		//CCS-1256  �۱��� by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >8.��Ʒ���ͣ�2����&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >9.��Ʒ�ͺţ�2����&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.Ʒ�ƣ�2����&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >11.�۸�2����&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >8.��Ʒ���ͣ�2����"+sBusinessType2+"</td>");
			sTemp.append("   <td align=left class=td1 >9.��Ʒ�ͺţ�2����"+sManufacturer2+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.Ʒ�ƣ�2����"+sBrandType2+"</td>");
			sTemp.append("   <td align=left class=td1 >11.�۸�2����"+sPrice2+"</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >8.��Ʒ���ͣ�3����"+sBusinessType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >9.��Ʒ�ͺţ�3����"+sManufacturer3+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >10.Ʒ�ƣ�3����"+sBrandType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >11.�۸�3����"+sPrice3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		//sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.������� : ǩ���/�ܾ�/ȡ��/�Ƴ�</b>&nbsp;</td>");
		sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.������� : "+sContractStatus+"&nbsp;</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>II.���Ѵ�������ժҪ</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >12.�Ը���Ԫ����"+sTotalSum+"</td>");
		
		//CCS-1256  �۱��� by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=4 align=left class=td1 >13.δ�����Ԫ����"+sActualSum+"&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=4 align=left class=td1 >13.δ�����Ԫ����"+sFutureAmt+"</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >14.��Ʒ���룺"+sBusinessType+"</td>");
		
		//CCS-1256  �۱��� by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >15.�����Ԫ����"+sActualSum+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.����������"+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.�״λ����գ�"+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.ÿ�»����գ�"+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >19.ָ�������˻��˺ţ�"+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >20.�������У�"+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >21.������"+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͻ����̼�ǩ���ļ���ȷ�ϣ��Ա��ļ�ǩ��ʱ����1��������Ʒ����׼ȷ����2���ͻ���֧��"+sTotalSum+"ԪΪ�Ը�����3�������º��̼�����֪ͨ�ͻ��������̼�֮������ʹ����δ�Ӵ����˴��յ�����𣬷���ͻ����̼Ҿ���Ϊ��Ʒ�ۿ���ȫ��֧���������������Ը�����4������Э������Ʒ�����ͬ�Ƕ����ķ��ɹ�ϵ�������˲����̼����ṩ��Ʒ�������е��κ����Σ���5���繺�����Ʒ�ǻ����ͻ���ȡ�ø���Ʒ��ȡ��ƾ֤��������Ʒ�����Э���е�����һ�£���������ʹ�ã���6���繺�����Ʒ�Ƿ������ۿͻ��Ƿ�ʵ�����ܸ÷��񣬿ͻ����밴�մ���Э�鳥�����</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.ϵͳʹ��&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >22.������ڼ�ʱ�䣺"+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.���۹�������/���룺"+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.���۹���ǩ����"+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >25.�̼��Ƽ���Ա��</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >26.�̼ҽ�����ǩ����</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >15.�����Ԫ����"+sBusinessSum+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.ÿ�»���Ԫ����"+sMonthRepayMent+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.����������"+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.�״λ����գ�"+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >19.ÿ�»����գ�"+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >20.ָ�������˻��˺ţ�"+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >21.�������У�"+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >22.������"+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͻ����̼�ǩ���ļ���ȷ�ϣ��Ա��ļ�ǩ��ʱ����1��������Ʒ����׼ȷ����2���ͻ���֧��"+sTotalSum+"ԪΪ�Ը�����3�������º��̼�����֪ͨ�ͻ��������̼�֮������ʹ����δ�Ӵ����˴��յ�����𣬷���ͻ����̼Ҿ���Ϊ��Ʒ�ۿ���ȫ��֧���������������Ը�����4������Э������Ʒ�����ͬ�Ƕ����ķ��ɹ�ϵ�������˲����̼����ṩ��Ʒ�������е��κ����Σ���5���繺�����Ʒ�ǻ����ͻ���ȡ�ø���Ʒ��ȡ��ƾ֤��������Ʒ�����Э���е�����һ�£���������ʹ�ã���6���繺�����Ʒ�Ƿ������ۿͻ��Ƿ�ʵ�����ܸ÷��񣬿ͻ����밴�մ���Э�鳥�����</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.ϵͳʹ��&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.������ڼ�ʱ�䣺"+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.���۹�������/���룺"+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >25.���۹���ǩ����"+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >26.�̼��Ƽ���Ա��</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >27.�̼ҽ�����ǩ����</td>");
		}
		//end
		
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 >�̼����ƣ����£���_____________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ͻ�ǩ��:"+customerSign+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	sTemp.append("</div>");	
	sTemp.append("<div align=center>");	
	sTemp.append("<font style=' font-size: 9pt;' >�汾��XF_TY_TY_2016030902��˾��</font></br>");//update by fangxq 20160316 �۱���
	sTemp.append("</div>");	
	
	
	rs2.getStatement().close();	
	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='111'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='111'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='111'>");
	sTemp.append("</form>");	
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");
	
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
