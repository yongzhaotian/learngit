<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2007.03.13
		Tester:
		Content: �ͻ���Ϣһ��
		Input Param:
		Output param:fhuang ������� 2007.03.15
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������������ͻ�����
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";	
%>
<%/*~END~*/%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�ͻ���Ϣһ��</title>
<style type="text/css">
<!--
.tableborder1 {
	border: 1px solid #999999;
}
.underlinetd {
	border-bottom-width: 1px;
	border-bottom-style: dashed;
	border-bottom-color: #DCDCDC;
}
-->
</style>
</head>



<%!
	//�����ʲ���ծ���е�����
	public String[][] getPropertyValue(String sReportNo,Transaction Sqlca) throws Exception
	{
		//����±��ʲ���ծ�����ʲ�,�����ʲ�,�����ʽ�,Ӧ���ʿ��,����Ӧ�տ�,���,����Ͷ�ʜQ��,�̶��ʲ���ֵ,�����ʲ��Q��,������ծ,���ڽ�һ���ڵ��ڵĳ��ڸ�ծ,Ӧ��Ʊ��,Ӧ���ʿ�,���ڸ�ծ�ϼ�,������Ȩ��,ʵ���ʱ�
		String sProperty [][] = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
		ASResultSet rs = null;
		double dValue = 0 ;  //����±��ʲ���ծ�����ʲ��ܼ�
		double dFValue = 0 ; //����±��ʲ���ծ���и�ծ�ϼ�
		
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value from REPORT_DATA where ReportNo = :ReportNo And RowSubject ='804'").setParameter("ReportNo",sReportNo));
		if(rs.next())
		{	
			sProperty[0][0] = DataConvert.toMoney(rs.getDouble("Col2value"));
			sProperty[1][0] = "100";
			dValue = rs.getDouble("Col2value");
		}
		rs.getStatement().close();
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value from REPORT_DATA where ReportNo = :ReportNo And RowSubject ='807'").setParameter("ReportNo",sReportNo));
		if(rs.next())
		{
			dFValue = rs.getDouble("Col2value");
		}
		rs.getStatement().close();

		if (dValue >0.008)
		{
			//���ڽ�һ���ڵ��ڵĳ��ڸ�ծ
			rs = Sqlca.getASResultSet(new SqlObject("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('201','211')").setParameter("ReportNo",sReportNo));
			
			if(rs.next())
			{
				sProperty[0][10] = DataConvert.toMoney(rs.getDouble("Col2value"));
				sProperty[1][10] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
			}
			rs.getStatement().close();

			rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('801','101','106','108','110','19h','119','19m','805','202','203','806','808','301')").setParameter("ReportNo",sReportNo));
			while(rs.next())
			{
				String sRowSubject = rs.getString("RowSubject");
				if(sRowSubject==null) sRowSubject = "";
				if (sRowSubject.equals("801"))	//�����ʲ��ϼ� 
				{
					sProperty[0][1] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][1] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("101"))	//�����ʽ�
				{		
					sProperty[0][2] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][2] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//Ӧ���ʿ��
				{
					sProperty[0][3] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][3] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//����Ӧ�տ�
				{
					sProperty[0][4] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][4] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("110"))	//���
				{
					sProperty[0][5] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][5] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19h"))	//����Ͷ�ʜQ��(��ȱ�����Ӧ��Ŀ)
				{
					sProperty[0][6] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][6] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//�̶��ʲ���ֵ
				{
					sProperty[0][7] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][7] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//�����ʲ��Q��(��ȱ�����Ӧ��Ŀ)
				{
					sProperty[0][8] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][8] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("805"))	//������ծ
				{
					sProperty[0][9] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][9] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("202"))	//Ӧ��Ʊ��
				{
					sProperty[0][11] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][11] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("203"))	//Ӧ���ʿ�
				{
					sProperty[0][12] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][12] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("806"))	//���ڸ�ծ�ϼ�
				{
					sProperty[0][13] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][13] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("808"))	//������Ȩ��
				{
					sProperty[0][14] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][14] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("301"))	//ʵ���ʱ�
				{
					sProperty[0][15] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][15] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
			}
			rs.getStatement().close();
		}

		return sProperty;		
	}
	//����������е�����
	public String[][] getSYValue(String sReportNo,Transaction Sqlca) throws Exception
	{
		String ssyValue[][] = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
		ASResultSet rs = null;
		double dsyValue = 0.00;//��Ӫҵ����
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('501','502','505','503','507','508','509','515','517')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("501"))		//��Ӫҵ������
			{
				ssyValue[0][0] = DataConvert.toMoney(rs.getDouble("Col2value"));
				dsyValue = rs.getDouble("Col2value");
				ssyValue[1][0] = "100";		
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
			{
				ssyValue[0][1] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][1] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);	
			}
			else if (sRowSubject.equals("505"))	//��Ӫҵ������
			{
				ssyValue[0][2] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][2] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("503"))	//Ӫҵ����
			{
				ssyValue[0][3] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][3] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("507"))	//�������
			{
				ssyValue[0][4] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][4] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("508"))	//�������
			{
				ssyValue[0][5] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][5] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("509"))	//Ӫҵ����
			{
				ssyValue[0][6] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][6] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue[0][7] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][7] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue[0][8] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[0][8] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs.getStatement().close();	
		return ssyValue;
	}
	//�����ֽ��������е�����
	public String[] getXJValue(String sReportNo,Transaction Sqlca) throws Exception
	{
		String[] sxjValue = {"0","0","0","0","0","0"};
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('a20','a27','810','811','812','813')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("a20"))		//��Ӫ��ֽ�������
			{
				sxjValue[0] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("a27"))	//��Ӫ��ֽ�������
			{
				sxjValue[1] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("810"))	//��Ӫ��ֽ�������
			{
				sxjValue[2] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue[3] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
			{
				sxjValue[4] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("813"))	//���ֽ�����
			{
				sxjValue[5] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			
		}
		rs.getStatement().close();	
		return sxjValue;
	}
	
	//���㳥ծ����,ӯ������,Ӫ������
	public String[] getCZValue(String sReportNo,Transaction Sqlca) throws Exception	
	{
		String[] sczValue = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('914','915','916','911','999','901','909','932','907','908','905',' ','906')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("914"))		//��Ϣ���ϱ���
			{
				sczValue[0] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("915"))	//��������
			{
				sczValue[1] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("916"))	//�ٶ�����
			{
				sczValue[2] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("911"))	//�ʲ���ծ����
			{
				sczValue[3] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("999"))	//���ֽ�����/��ծ��
			{
				sczValue[4] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("901"))	//����������
			{
				sczValue[5] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("909"))	//���ʲ�������
			{
				sczValue[6] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("932"))	//���ʲ�������
			{
				sczValue[7] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("907"))	//Ӧ���ʿ���ת��
			{
				sczValue[8] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("908"))	//�����ת��
			{
				sczValue[9] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("905"))	//���ʲ���ת��
			{
				sczValue[10] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals(" "))	//�����ʲ���ת��(����)
			{
				sczValue[11] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("906"))	//�̶��ʲ���ת��
			{
				sczValue[12] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}						
		}
		rs.getStatement().close();	
		return sczValue;
	}
	
	public String[] getYLValue(String sReportNo,Transaction Sqlca) throws Exception	
	{
		//��������,Ӫҵ������������Ͷ�����棬������
		String[] sylValue = {"0","0","0","0","0"};
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('501','509','505','510','517')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("501"))		//��������
			{
				sylValue[0] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("509"))	//Ӫҵ����
			{
				sylValue[1] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("505"))	//��������
			{
				sylValue[2] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("510"))	//Ͷ������
			{
				sylValue[3] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				sylValue[4] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
		}
		rs.getStatement().close();	
		return sylValue;
	}
%>






<%
	//------------------------------------�ͻ��Ļ�����Ϣ-------------------------
	String sSql = "";
	ASResultSet rs = null;
	String sCustomerName = "";		//�ͻ�����
	String sRegisterAdd = "";		//ע���ַ
	String sOfficeAdd = "";			//�칫��ַ
	String sOrgType = "";			//��ҵ����
	String sIndustryType = "";		//������ҵ����
	String sScope = "";				//��ҵ��ģ
	String sSetupDate = "";			//��ҵ��������
	String sCreditLevel = "";		//���м������õȼ�
	String sLoanCardNo = "";		//�������
	String sLicenseNo = "";			//����Ӫҵִ�պ���
	String sLicenseDate = ""; 		//Ӫҵִ�յǼ���
	String sLicenseMaturity = "";	//Ӫҵִ�յ�����
	String sRCCurrency = "";		//ע���ʱ�����
	double dRegisterCapital = 0.00;	//ע���ʱ�
	String sPCCurrency = "";		//ʵ���ʱ�����
	double dPaiclUpCapital = 0.00;	//ʵ���ʱ�
	String sFictitiousPerson = "";	//����������
	String sMostBusiness = "";		//��Ӫ��Χ
	String sHasIERight = "";		//���޽����ھ�ӪȨ
	String sListingCorpType = "";	//���й�˾����	
	
	sSql = " select EnterpriseName,RegisterAdd,OfficeAdd,getItemName('OrgType',OrgType) as OrgType,"+
		   " getItemName('IndustryType',IndustryType) as IndustryType,"+
		   " getItemName('Scope',Scope) as Scope,SetupDate,getItemName('CreditLevel',CreditLevel) as CreditLevel,"+
		   " LoanCardNo,LicenseNo,LicenseDate,LicenseMaturity,"+
		   " getItemName('Currency',RCCurrency) as RCCurrency,RegisterCapital,"+
		   " getItemName('Currency',PCCurrency) as PCCurrency,PaiclUpCapital,"+
		   " FictitiousPerson,MostBusiness,getItemName('HaveNot',HasIERight) as HasIERight,"+
		   " getItemName('ListingCorpType',ListingCorpOrNot) as ListingCorpType "+
		   " from ENT_INFO where CustomerID=:CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next())
	{
		sCustomerName = rs.getString("EnterpriseName");
		sRegisterAdd = rs.getString("RegisterAdd");
		sOfficeAdd = rs.getString("OfficeAdd");
		sOrgType = rs.getString("OrgType");
		sIndustryType = rs.getString("IndustryType");
		sScope = rs.getString("Scope");
		sSetupDate = rs.getString("SetupDate");
		sCreditLevel = rs.getString("CreditLevel");
		sLoanCardNo = rs.getString("LoanCardNo");
		sLicenseNo = rs.getString("LicenseNo");
		sLicenseDate = rs.getString("LicenseDate");
		sLicenseMaturity = rs.getString("LicenseMaturity");
		sRCCurrency = rs.getString("RCCurrency");
		dRegisterCapital = rs.getDouble("RegisterCapital");
		sPCCurrency = rs.getString("PCCurrency");
		dPaiclUpCapital = rs.getDouble("PaiclUpCapital");
		sFictitiousPerson = rs.getString("FictitiousPerson");
		sMostBusiness = rs.getString("MostBusiness");
		sHasIERight = rs.getString("HasIERight");
		sListingCorpType = rs.getString("ListingCorpType");
		
		if(sCustomerName==null) sCustomerName = "";
		if(sRegisterAdd==null) sRegisterAdd = "";
		if(sOfficeAdd==null) sOfficeAdd = "";
		if(sOrgType==null) sOrgType = "";
		if(sIndustryType==null) sIndustryType = "";
		if(sScope==null) sScope = "";
		if(sSetupDate==null) sSetupDate = "";
		if(sCreditLevel==null) sCreditLevel = "";
		if(sLoanCardNo==null) sLoanCardNo = "";
		if(sLicenseNo==null) sLicenseNo = "";
		if(sLicenseDate==null) sLicenseDate = "";
		if(sLicenseMaturity==null) sLicenseMaturity = "";
		if(sRCCurrency==null) sRCCurrency = "";
		if(sPCCurrency==null) sPCCurrency = "";
		if(sFictitiousPerson==null) sFictitiousPerson = "";
		if(sMostBusiness==null) sMostBusiness = "";
		if(sHasIERight==null) sHasIERight = "";
		if(sListingCorpType==null) sListingCorpType = "";
	}
	rs.getStatement().close();
	
	//-------------------------------�ɶ����----------------------------------
	ASResultSet rs1 = null;
	sSql = " Select CustomerName,getItemName('Currency',CurrencyType) as CurrencyType,InvestmentSum "+
		   " from CUSTOMER_RELATIVE where CustomerID=:CustomerID "+
		   " and RelationShip like '52%' and length(RelationShip)>2 and EffStatus='1'";
	rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//---------------------------�����ȨͶ��------------------------------------
	ASResultSet rs2 = null;
	sSql = " Select CustomerName,getItemName('Currency',CurrencyType) as CurrencyType,InvestmentSum "+
		   " from CUSTOMER_RELATIVE where CustomerID=:CustomerID "+
		   " and RelationShip like '02%' and length(RelationShip)>2 and EffStatus='1'";
	rs2 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//--------------------------��Ʊ�������--------------------------------------
	ASResultSet rs3 = null;
	sSql = " Select IPODate,getItemName('IPOName',BourseName) as BourseName,StockCode,StockName "+
		   " from ENT_IPO where CustomerID=:CustomerID";
	rs3 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//-------------------------ծȯ�������---------------------------------------
	ASResultSet rs4 = null;
	sSql = " select IssueDate,getItemName('BondType',BondType) as BondType,"+
		   " getItemName('Currency',BondCurrency) as BondCurrency,BondSum "+
		   " from ENT_BONDISSUE where CustomerID=:CustomerID";
	rs4 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//----------------------------����������������Ϣ����;��----------------------
	ASResultSet rs5 = null;
	sSql = " select getBusinessName(BusinessType) as BusinessType,"+
		   " getItemName('OccurType',OccurType) as OccurType,"+
		   " getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		   " BusinessSum,OccurDate,TermMonth,TermDay,"+
		   " getItemName('VouchType',VouchType) as VouchType,"+
		   " getOrgName(OperateOrgID) as OperateOrgName "+
		   " from Business_Apply BA "+
		   " where CustomerID=:CustomerID "+
		   " and PigeonholeDate is null "+
		   " and exists (select 1 from FLOW_OBJECT where ObjectType='CreditApply' "+
		   " and ObjectNo =BA.SerialNo and PhaseNo not in ('0010','1000','8000'))";
	rs5 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//-----------------------�����Ŷ��(ռ�ý���ռ�ñ�������)-----------------------------------------
	ASResultSet rs6 = null;
	sSql = " Select getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		   " BusinessSum,PutoutDate,Maturity,LimitationTerm,UseTerm "+
		   " from Business_Contract "+
		   " where CustomerID=:CustomerID "+
		   " and BusinessType like '3%' "+
		   " and PigeonholeDate is null "+
		   " and FreezeFlag not in ('2','3','4') ";
	rs6 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//----------------------���ŷ�����ϸ(ռ�ý���ռ�ñ�������)-----------------------------------------
	ASResultSet rs7 = null;
	sSql = " select getBusinessName(CL.BusinessType) as BusinessType,"+
		   " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrency,"+
		   " CL.LineSum1 as LineSum1,CL.LineSum2 as LineSum2,"+
		   " CL.BailRatio as BailRatio,getItemName('YesNo',CL.Rotative) as Rotative "+
		   " from Business_Contract BC,CL_Info CL "+
		   " where BC.CustomerID=:CustomerID "+
		   " and BC.SerialNo=CL.BCSerialNo "+
		   " and CL.ParentLineID is not null "+
		   " and BC.BusinessType like '3%' "+
		   " and BC.PigeonholeDate is null "+
		   " and BC.FreezeFlag not in ('2','3','4') ";
	rs7 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));	
	
	//--------------------δ���������ҵ��-----------------------------------------
	ASResultSet rs8 = null; 
	sSql = " select getBusinessName(BusinessType) as BusinessType,"+
	       " getItemName('OccurType',OccurType) as OccurType,"+
		   " getItemName('VouchType',VouchType) as VouchType,"+
		   " BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		   " BusinessRate,PutoutDate,Maturity,"+
		   " getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "+
		   " from Business_Contract "+
		   " where CustomerID=:CustomerID "+
		   " and (FinishDate = ' ' or FinishDate is null) "+
		   " and (BusinessType like '1%' or BusinessType like '2%')"; 
	rs8 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//----------------------------------�ļ�����-----------------------------------
	ASResultSet rs9 = null; 
	sSql = " Select NormalBalance,(NormalBalance-NormalBalanceLY) as NormalBalance1,"+
		   " OverDueBalance,(OverDueBalance-OverDueBalanceLY) as OverDueBalance1,"+
		   " DullBalance,(DullBalance-DullBalanceLY) as DullBalance1,"+
		   " BadBalance,(BadBalance-BadBalanceLY) as BadBalance1 "+
		   " from T_Fact_Loan_M "+
		   " where InputDate=(Select Max(InputDate) from T_Fact_Loan_M)"+
		   " and CustomerID=:CustomerID";
	rs9 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));	 
	
	//-----------------------------------�弶����------------------------------------
	ASResultSet rs10 = null;
	sSql = " Select ClassifySum1,(ClassifySum1-ClassifySum1ly) as ClassifySum11,"+
		   " ClassifySum2,(ClassifySum2-ClassifySum2ly) as ClassifySum22,"+
		   " ClassifySum3,(ClassifySum3-ClassifySum3ly) as ClassifySum33,"+
		   " ClassifySum4,(ClassifySum4-ClassifySum4ly) as ClassifySum44,"+
		   " ClassifySum5,(ClassifySum5-ClassifySum5ly) as ClassifySum55 "+
		   " from T_Fact_Loan_M "+
		   " where InputDate=(Select Max(InputDate) from T_Fact_Loan_M)"+
		   " and CustomerID=:CustomerID";
	rs10 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID)); 
	
	//-------------------------------���굽��ҵ��------------------------------------
	ASResultSet rs11 = null;	
	String sYear = (StringFunction.getToday()).substring(0,4);//����
	String sQuater3 = sYear+"/03/31";
	String sQuater6 = sYear+"/06/30";
	String sQuater9 = sYear+"/09/30";
	String sQuater12 = sYear+"/12/31";
	SqlObject so = null;
	String sNewSql = "";	
	double dLoanBalance[] = {0.00,0.00,0.00,0.00,0.00};
	double dBillBalance[] = {0.00,0.00,0.00,0.00,0.00};
	double dCardBalance[] = {0.00,0.00,0.00,0.00,0.00};
	sNewSql = " Select Sum(BusinessSum) as Balance, "+
		   " Sum(Case when Maturity<='"+sQuater3+"' then BusinessSum else 0 end) as Balance1,"+
		   " Sum(Case when Maturity>')"+sQuater3+"' and Maturity<='"+sQuater6+"' then BusinessSum else 0 end) as Balance2,"+
		   " Sum(Case when Maturity>')"+sQuater6+"' and Maturity<='"+sQuater9+"' then BusinessSum else 0 end) as Balance3,"+
		   " Sum(Case when Maturity>')"+sQuater9+"' and Maturity<='"+sQuater12+"' then BusinessSum else 0 end) as Balance4 "+
		   " from Business_Contract "+
		   " where CustomerID = :CustomerID "+
		   " and substr(BusinessType,1,4) in ('1010','1030','1040','1050','1060','1080','1110','1090','2030','2040','2070','2080','2090','2100') "+
		   " and BusinessType not in ('1080007','1080005','1090010','1090020','1090030','1090040','1090050')"+
		   " and Maturity like :Year";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Year",sYear+"%");
	rs11 = Sqlca.getASResultSet(so);
	if(rs11.next())
	{
		dLoanBalance [0] = rs11.getDouble("Balance");
		dLoanBalance [1] = rs11.getDouble("Balance1");
		dLoanBalance [2] = rs11.getDouble("Balance2");
		dLoanBalance [3] = rs11.getDouble("Balance3");
		dLoanBalance [4] = rs11.getDouble("Balance4");
	} 
	rs11.getStatement().close();  
	sNewSql = " Select Sum(BusinessSum) as Balance, "+
		   " Sum(Case when Maturity<='"+sQuater3+"' then BusinessSum else 0 end) as Balance1,"+
		   " Sum(Case when Maturity>')"+sQuater3+"' and Maturity<='"+sQuater6+"' then BusinessSum else 0 end) as Balance2,"+
		   " Sum(Case when Maturity>')"+sQuater6+"' and Maturity<='"+sQuater9+"' then BusinessSum else 0 end) as Balance3,"+
		   " Sum(Case when Maturity>')"+sQuater9+"' and Maturity<='"+sQuater12+"' then BusinessSum else 0 end) as Balance4 "+
		   " from Business_Contract "+
		   " where CustomerID = :CustomerID "+
		   " and BusinessType ='2010'"+
		   " and Maturity like :Year";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Year",sYear+"%");
	rs11 = Sqlca.getASResultSet(so);
	if(rs11.next()){
		dBillBalance [0] = rs11.getDouble("Balance");
		dBillBalance [1] = rs11.getDouble("Balance1");
		dBillBalance [2] = rs11.getDouble("Balance2");
		dBillBalance [3] = rs11.getDouble("Balance3");
		dBillBalance [4] = rs11.getDouble("Balance4");
	} 
	rs11.getStatement().close();
	sNewSql = " Select Sum(BusinessSum) as Balance, "+
		   " Sum(Case when Maturity<='"+sQuater3+"' then BusinessSum else 0 end) as Balance1,"+
		   " Sum(Case when Maturity>')"+sQuater3+"' and Maturity<='"+sQuater6+"' then BusinessSum else 0 end) as Balance2,"+
		   " Sum(Case when Maturity>')"+sQuater6+"' and Maturity<='"+sQuater9+"' then BusinessSum else 0 end) as Balance3,"+
		   " Sum(Case when Maturity>')"+sQuater9+"' and Maturity<='"+sQuater12+"' then BusinessSum else 0 end) as Balance4 "+
		   " from Business_Contract "+
		   " where CustomerID = :CustomerID "+
		   " and BusinessType in ('1090010','1080007','1080005')"+
		   " and Maturity like :Year";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Year",sYear+"%");
	rs11 = Sqlca.getASResultSet(so);
	if(rs11.next()){
		dCardBalance [0] = rs11.getDouble("Balance");
		dCardBalance [1] = rs11.getDouble("Balance1");
		dCardBalance [2] = rs11.getDouble("Balance2");
		dCardBalance [3] = rs11.getDouble("Balance3");
		dCardBalance [4] = rs11.getDouble("Balance4");
	} 
	rs11.getStatement().close();

	
	//-----------------------��Լ���------------------------------------------
	double dBalance[] = {0.00,0.00,0.00,0.00,0.00,0.00,0.00};
	sNewSql = " Select Sum(BusinessSum) as Balance,"+
		   " Sum(decode(OccurType,'015',1,0)*BusinessSum) as Balance2,"+
		   " Sum(decode(OccurType,'060',1,0)*BusinessSum) as Balance3,"+
		   " Sum(decode(OccurType,'020',1,0)*BusinessSum) as Balance4,"+
		   " Sum(OverDueBalance+DullBalance+BadBalance) as Balance5,"+
		   " Sum(decode(ClassifyResult,'03',1,'04',1,'05','1',0)*BusinessSum) as Balance6 "+
		   " from Business_Contract "+
		   " where CustomerID = :CustomerID "+
		   " and Maturity like :Year"+
		   " and Maturity <= :Date";
	sNewSql = "select OrderNo from REG_COMP_DEF where CompID=:CompID";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Year",sYear+"%");
	so.setParameter("Date",StringFunction.getToday()+"%");
	rs11 = Sqlca.getASResultSet(so);
	if(rs11.next()){
		dBalance[0] = rs11.getDouble("Balance");
		dBalance[2] = rs11.getDouble("Balance2");
		dBalance[3] = rs11.getDouble("Balance3");
		dBalance[4] = rs11.getDouble("Balance4");
		dBalance[5] = rs11.getDouble("Balance5");
		dBalance[6] = rs11.getDouble("Balance6");
	}
	dBalance[1] = dBalance[0]-dBalance[2]-dBalance[3]-dBalance[4]-dBalance[5]-dBalance[6];
	rs11.getStatement().close();
	
	//****************************�ʲ���ծ��***********************************************	
	String sReportDate = "";	//����
	String sLastMonth = "";		//����
	String sBeginYear = "";		//���
	String sLastYear = "";		//ȥ��ͬ�� 
	String sReportNo = ""; 		//�����
	
	//����±��ʲ���ծ�����ʲ�,�����ʲ�,�����ʽ�,Ӧ���ʿ��,����Ӧ�տ�,���,����Ͷ�ʜQ��,�̶��ʲ���ֵ,�����ʲ��Q��,������ծ,���ڽ�һ���ڵ��ڵĳ��ڸ�ծ,Ӧ��Ʊ��,Ӧ���ʿ�,���ڸ�ծ�ϼ�,������Ȩ��,ʵ���ʱ�
	String[][] sProperty1 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	String[][] sProperty2 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	String[][] sProperty3 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	String[][] sProperty4 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	
	//ȡ�����ʲ���ծ������
	sNewSql="select ReportDate,ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo1 like '%1' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo =:ObjectNo2 And ModelNo like '%1')";
	so = new SqlObject(sNewSql);
	so.setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID);
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sReportDate = rs.getString("ReportDate");	//����
		if(sReportDate == null) sReportDate = "";
		sReportNo = rs.getString("ReportNo");	//����ʲ���ծ���
		if(sReportNo == null) sReportNo = "";
	}	
	rs.getStatement().close();

	if(!sReportNo.equals("")){
		sProperty1 = getPropertyValue(sReportNo,Sqlca);
	}
	
	if(!sReportDate.equals("")){
		sLastMonth = StringFunction.getRelativeAccountMonth(sReportDate,"month",-1);
		sLastYear  = StringFunction.getRelativeAccountMonth(sReportDate,"month",-12);
		sBeginYear = sLastYear.substring(0,4)+"/12";
	}
	
	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
				" where ObjectNo =:ObjectNo And ModelNo like '%1' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sLastMonth));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sProperty2 = getPropertyValue(sReportNo,Sqlca);
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
				" where ObjectNo =:ObjectNo And ModelNo like '%1' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sBeginYear));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sProperty3 = getPropertyValue(sReportNo,Sqlca);
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%1' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sLastYear));
	if(sReportNo==null) sReportNo = "";

	if(!sReportNo.equals("")){
		sProperty4 = getPropertyValue(sReportNo,Sqlca);
	}
	
	//-----------------------------�����-----------------------------------
	String sSYMonth = "";
	String sSYYear1 = "";
	String sSYYear2 = "";
	String sSYYear3 = "";
	String[][] sSYValue1 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
	String[][] sSYValue2 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
	String[][] sSYValue3 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
	String[][] sSYValue4 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
		
	//ȡ�������������
	 rs = Sqlca.getASResultSet(new SqlObject("select ReportDate,ReportNo from REPORT_RECORD "+
		  " where ObjectNo =:ObjectNo1 And ModelNo like '%2' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo =:ObjectNo2 And ModelNo like '%2')").setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID));
	if(rs.next()){
		sSYMonth = rs.getString("ReportDate");	//����
		if(sSYMonth == null) sSYMonth = "";
		sReportNo = rs.getString("ReportNo");	//���������
		if(sReportNo == null) sReportNo = "";
	}
	rs.getStatement().close();
	if(!sReportNo.equals("")){
		sSYValue1 = getSYValue(sReportNo,Sqlca);
	}
	if(!sSYMonth.equals("")){
		String sTemp = sSYMonth.substring(0,4)+"/12";
		sSYYear1  = StringFunction.getRelativeAccountMonth(sTemp,"month",-12);
		sSYYear2  = StringFunction.getRelativeAccountMonth(sTemp,"month",-24);
		sSYYear3  = StringFunction.getRelativeAccountMonth(sTemp,"month",-36);
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%2' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sSYYear1));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sSYValue2 = getSYValue(sReportNo,Sqlca);
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%2' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sSYYear2));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sSYValue3 = getSYValue(sReportNo,Sqlca);
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  			" where ObjectNo =:ObjectNo And ModelNo like '%2' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sSYYear3));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sSYValue4 = getSYValue(sReportNo,Sqlca);
	}
	
	//---------------------------------�ֽ�������------------------------------------------	
	String sXJMonth = "";
	String sXJYear1 = "";
	String sXJYear2 = "";
	String sXJYear3 = "";
	String[] sXJValue1 = {"0","0","0","0","0","0"};
	String[] sXJValue2 = {"0","0","0","0","0","0"};
	String[] sXJValue3 = {"0","0","0","0","0","0"};
	String[] sXJValue4 = {"0","0","0","0","0","0"};
	//ȡ�����ֽ�����������
	 rs = Sqlca.getASResultSet(new SqlObject("select ReportDate,ReportNo from REPORT_RECORD "+
			  " where ObjectNo =:ObjectNo1 And ModelNo like '%8' And  ReportDate = (select max(Reportdate) from REPORT_RECORD "+
			  "Where ObjectNo =:ObjectNo2 And ModelNo like '%8')").setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID));
	if(rs.next()){
		sXJMonth = rs.getString("ReportDate");	//����
		if(sXJMonth == null) sXJMonth = "";
		sReportNo = rs.getString("ReportNo");	//���������
		if(sReportNo == null) sReportNo = "";
	}
	rs.getStatement().close();
	if(!sReportNo.equals("")){
		sXJValue1 = getXJValue(sReportNo,Sqlca);
	}
	if(!sXJMonth.equals("")){
		String sTemp = sXJMonth.substring(0,4)+"/12";
		sXJYear1  = StringFunction.getRelativeAccountMonth(sTemp,"month",-12);
		sXJYear2  = StringFunction.getRelativeAccountMonth(sTemp,"month",-24);
		sXJYear3  = StringFunction.getRelativeAccountMonth(sTemp,"month",-36);
	}
	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
				" where ObjectNo =:ObjectNo And ModelNo like '%8' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sXJYear1));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sXJValue2 = getXJValue(sReportNo,Sqlca);
	}
	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%8' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sXJYear2));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sXJValue3 = getXJValue(sReportNo,Sqlca);
	}
	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%8' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sXJYear3));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sXJValue4 = getXJValue(sReportNo,Sqlca);
	}
	
	//------------------------------------��ծ����------------------------------
	String sCZMonth1 = "";
	String sCZMonth2 = "";
	String sCZMonth3 = "";
	String sCZMonth4 = "";
	String[] sCZValue1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sCZValue2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sCZValue3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sCZValue4 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	//ȡ���²���ָ�������
	 rs = Sqlca.getASResultSet(new SqlObject("select ReportDate,ReportNo from REPORT_RECORD "+
			  " where ObjectNo =:ObjectNo1 And ModelNo like '%9' And  ReportDate = (select max(Reportdate) from REPORT_RECORD "+
			  " Where ObjectNo =:ObjectNo2 And ModelNo like '%9')").setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID));
	if(rs.next()){
		sCZMonth1 = rs.getString("ReportDate");	//����
		if(sCZMonth1 == null) sCZMonth1 = "";
		sReportNo = rs.getString("ReportNo");	//���������
		if(sReportNo == null) sReportNo = "";
	}
	rs.getStatement().close();
	if(!sReportNo.equals("")){
		sCZValue1 = getCZValue(sReportNo,Sqlca);
	}
	if(!sCZMonth1.equals("")){
		sCZMonth4 = StringFunction.getRelativeAccountMonth(sCZMonth1,"month",-12);//ȥ��ͬ��
		sCZMonth2  = sCZMonth4.substring(0,4)+"/12";//�����
		sCZMonth3 = StringFunction.getRelativeAccountMonth(sCZMonth2,"month",-12);//ǰ���
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%9' And  ReportDate =:ReportDate").setParameter("ObjectNo1",sCustomerID).setParameter("ReportDate",sCZMonth2));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sCZValue2 = getCZValue(sReportNo,Sqlca);
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%9' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sCZMonth3));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sCZValue3 = getCZValue(sReportNo,Sqlca);
	}

	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%9' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sCZMonth4));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sCZValue4 = getCZValue(sReportNo,Sqlca);
	}

	//---------------------------------ӯ�������е�5������-----------------------------------------------
	String[] sYLValue1 = {"0","0","0","0","0"};
	String[] sYLValue2 = {"0","0","0","0","0"};
	String[] sYLValue3 = {"0","0","0","0","0"};
	String[] sYLValue4 = {"0","0","0","0","0"};
	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%2' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sCZMonth1));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sYLValue1 = getYLValue(sReportNo,Sqlca);
	}
	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%2' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sCZMonth2));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sYLValue2 = getYLValue(sReportNo,Sqlca);
	}
		sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
		  		" where ObjectNo =:ObjectNo And ModelNo like '%2' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sCZMonth3));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sYLValue3 = getYLValue(sReportNo,Sqlca);
	}
	sReportNo = Sqlca.getString(new SqlObject("select ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo like '%2' And  ReportDate =:ReportDate").setParameter("ObjectNo",sCustomerID).setParameter("ReportDate",sCZMonth4));
	if(sReportNo==null) sReportNo = "";
	if(!sReportNo.equals("")){
		sYLValue4 = getYLValue(sReportNo,Sqlca);
	}
%>


<body>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
  <tr>
   <td class="underlinetd" colspan="4"><table width="100%" height="1783" border="0" cellpadding="2" cellspacing="0">
     <tr>
       <td colspan="9" bgcolor="#DCDCDC" class="tableborder1">�ͻ��ſ�</td>
       </tr>
     <tr>
       <td colspan="2" class="underlinetd">�ͻ�����</td>
       <td width="6%" class="underlinetd"><%=sCustomerName%></td>
       <td width="17%" class="underlinetd">ע���ַ</td>
       <td width="16%" class="underlinetd"><%=sRegisterAdd%></td>
       <td width="14%" class="underlinetd">�칫��ַ</td>
       <td width="11%" class="underlinetd"><%=sOfficeAdd%></td>
       <td width="10%" class="underlinetd">��ҵ����</td>
       <td width="10%" class="underlinetd"><%=sOrgType%></td>
     </tr>
     <tr>
       <td colspan="2" class="underlinetd">������ҵ����</td>
       <td class="underlinetd"><%=sIndustryType%></td>
       <td class="underlinetd">��ҵ��ģ</td>
       <td class="underlinetd"><%=sScope%></td>
       <td class="underlinetd">��ҵ��������</td>
       <td class="underlinetd"><%=sSetupDate%></td>
       <td class="underlinetd">���м������õȼ�</td>
       <td class="underlinetd"><%=sCreditLevel%></td>
     </tr>
	  <tr>
       <td colspan="2" class="underlinetd">�����</td>
       <td class="underlinetd"><%=sLoanCardNo%></td>
       <td class="underlinetd">Ӫҵִ�պ�</td>
       <td class="underlinetd"><%=sLicenseNo%></td>
       <td class="underlinetd">Ӫҵִ�յǼ���</td>
       <td class="underlinetd"><%=sLicenseDate%></td>
       <td class="underlinetd">Ӫҵִ�յ�����</td>
       <td class="underlinetd"><%=sLicenseMaturity%></td>
     </tr>
	  <tr>
       <td colspan="2" class="underlinetd">ע���ʱ�����</td>
       <td class="underlinetd"><%=sRCCurrency%></td>
       <td class="underlinetd">ע���ʱ�</td>
       <td class="underlinetd"><%=DataConvert.toMoney(dRegisterCapital)%></td>
       <td class="underlinetd">ʵ���ʱ�����</td>
       <td class="underlinetd"><%=sPCCurrency%></td>
       <td class="underlinetd">ʵ���ʱ�</td>
       <td class="underlinetd"><%=DataConvert.toMoney(dPaiclUpCapital)%></td>
     </tr>	 
	  <tr>
       <td colspan="2" class="underlinetd">���˴���</td>
       <td class="underlinetd"><%=sFictitiousPerson%></td>
       <td class="underlinetd">��Ӫ��Χ</td>
       <td class="underlinetd"><%=sMostBusiness%></td>
       <td class="underlinetd">���޽����ھ�ӪȨ</td>
       <td class="underlinetd"><%=sHasIERight%></td>
       <td class="underlinetd">���й�˾����</td>
       <td class="underlinetd"><%=sListingCorpType%></td>
     </tr>
     <tr>
       <td height="19" colspan="5" bgcolor="#DCDCDC" class="tableborder1">�ɶ����</td>
       <td height="19" colspan="4" bgcolor="#DCDCDC" class="tableborder1">�����ȨͶ�����</td>
       </tr>
     <tr>
       <td height="19" colspan="5" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">�ɶ�����</td>
           <td valign="top" class="underlinetd">Ͷ�ʱ���</td>
           <td valign="top" class="underlinetd">Ͷ�ʽ��</td>
         </tr>
         <%
         	while(rs1.next())
         	{
         %>         
         <tr>
           <td class="underlinetd"><%=rs1.getString("CustomerName")%></td>
           <td class="underlinetd"><%=rs1.getString("CurrencyType")%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs1.getDouble("InvestmentSum"))%></td>
         </tr>
         <%
         	}
         	rs1.getStatement().close();
         %>
       </table></td>
       <td colspan="4" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">Ͷ����ҵ����</td>
           <td valign="top" class="underlinetd">���ʱ���</td>
           <td valign="top" class="underlinetd">���ʽ��</td>
         </tr>   
         <%
         	while(rs2.next())
         	{
         %>        
         <tr>
           <td class="underlinetd"><%=rs2.getString("CustomerName")%></td>
           <td class="underlinetd"><%=rs2.getString("CurrencyType")%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs2.getDouble("InvestmentSum"))%></td>
         </tr>
         <%
         	}
         	rs2.getStatement().close();
         %>      
       </table></td>
       </tr>
     <tr>
       <td height="18" colspan="5" bgcolor="#DCDCDC" class="tableborder1">��Ʊ��Ϣ</td>
       <td colspan="4" bgcolor="#DCDCDC" class="tableborder1">ծȨ��Ϣ</td>
       </tr>
     <tr>
       <td colspan="5" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">����ʱ��</td>
           <td valign="top" class="underlinetd">���е�</td>
           <td valign="top" class="underlinetd">��Ʊ����</td>
		   <td valign="top" class="underlinetd">��Ʊ���</td>
         </tr>  
         <%
         	while(rs3.next())
         	{
         %>        
         <tr>
           <td class="underlinetd"><%=rs3.getString("IPODate")%></td>
           <td class="underlinetd"><%=rs3.getString("BourseName")%></td>
           <td class="underlinetd"><%=rs3.getString("StockCode")%></td>
		   <td class="underlinetd"><%=rs3.getString("StockName")%></td>
         </tr>
         <%
         	}
         	rs3.getStatement().close();
         %>                  
       </table></td>
       <td colspan="4" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">����ʱ��</td>
           <td valign="top" class="underlinetd">ծȯ����</td>
           <td valign="top" class="underlinetd">���б���</td>
		   <td valign="top" class="underlinetd">���н��</td>
         </tr>        
         <%
         	while(rs4.next())
         	{
         %>        
         <tr>
           <td class="underlinetd"><%=rs4.getString("IssueDate")%></td>
           <td class="underlinetd"><%=rs4.getString("BondType")%></td>
           <td class="underlinetd"><%=rs4.getString("BondCurrency")%></td>
		   <td class="underlinetd"><%=DataConvert.toMoney(rs4.getDouble("BondSum"))%></td>
         </tr>
         <%
         	}
         	rs4.getStatement().close();
         %>        
       </table></td>
       </tr>	
	 <tr>
       <td height="18" colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0" class="tableborder1">
	   	 <tr>
       		<td height="18" colspan="8" bgcolor="#DCDCDC" class="tableborder1">������Ϣ</td>
       	 </tr>
         <tr>
           <td width="1" bgcolor="#DCDCDC">�ʲ���ծ��</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <tr>
                 <td width="12%" rowspan="2" valign="top" class="underlinetd">��Ŀ</td>
               <%
               	if(!sReportDate.equals(""))
               	{
               %>
                 <td colspan="2" valign="top" class="underlinetd"><%=sReportDate.substring(0,4)%>��<%=sReportDate.substring(5,7)%>��</td>
                <%
                }
                else
                {
                %>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;��&nbsp;��</td>	
                <%
                }
                %>
                 <td colspan="2" valign="top" class="underlinetd">����</td>
                 <td colspan="2" valign="top" class="underlinetd">���</td>
                 <td colspan="2" valign="top" class="underlinetd">ȥ��ͬ��</td>
                 </tr>
               <tr>
                 <td width="11%" class="underlinetd">��ֵ</td>
                 <td width="12%" class="underlinetd">ռ��(%)</td>
                 <td width="10%" class="underlinetd">��ֵ</td>
                 <td width="10%" class="underlinetd">ռ��(%)</td>
                 <td width="9%" class="underlinetd">��ֵ</td>
                 <td width="10%" class="underlinetd">ռ��(%)</td>
                 <td width="11%" class="underlinetd">��ֵ</td>
                 <td width="15%" class="underlinetd">ռ��(%)</td>
               </tr>
			   <tr>
                 <td class="underlinetd">���ʲ�</td>
                 <td class="underlinetd"><%=sProperty1[0][0]%></td>
                 <td class="underlinetd"><%=sProperty1[1][0]%></td>
                 <td class="underlinetd"><%=sProperty2[0][0]%></td>
                 <td class="underlinetd"><%=sProperty2[1][0]%></td>
                 <td class="underlinetd"><%=sProperty3[0][0]%></td>
                 <td class="underlinetd"><%=sProperty3[1][0]%></td>
                 <td class="underlinetd"><%=sProperty4[0][0]%></td>
                 <td class="underlinetd"><%=sProperty4[1][0]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">�����ʲ�</td>
                 <td class="underlinetd"><%=sProperty1[0][1]%></td>
                 <td class="underlinetd"><%=sProperty1[1][1]%></td>
                 <td class="underlinetd"><%=sProperty2[0][1]%></td>
                 <td class="underlinetd"><%=sProperty2[1][1]%></td>
                 <td class="underlinetd"><%=sProperty3[0][1]%></td>
                 <td class="underlinetd"><%=sProperty3[1][1]%></td>
                 <td class="underlinetd"><%=sProperty4[0][1]%></td>
                 <td class="underlinetd"><%=sProperty4[1][1]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">�����ʽ�</td>
                 <td class="underlinetd"><%=sProperty1[0][2]%></td>
                 <td class="underlinetd"><%=sProperty1[1][2]%></td>
                 <td class="underlinetd"><%=sProperty2[0][2]%></td>
                 <td class="underlinetd"><%=sProperty2[1][2]%></td>
                 <td class="underlinetd"><%=sProperty3[0][2]%></td>
                 <td class="underlinetd"><%=sProperty3[1][2]%></td>
                 <td class="underlinetd"><%=sProperty4[0][2]%></td>
                 <td class="underlinetd"><%=sProperty4[1][2]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">Ӧ���ʿ�Q��</td>
                 <td class="underlinetd"><%=sProperty1[0][3]%></td>
                 <td class="underlinetd"><%=sProperty1[1][3]%></td>
                 <td class="underlinetd"><%=sProperty2[0][3]%></td>
                 <td class="underlinetd"><%=sProperty2[1][3]%></td>
                 <td class="underlinetd"><%=sProperty3[0][3]%></td>
                 <td class="underlinetd"><%=sProperty3[1][3]%></td>
                 <td class="underlinetd"><%=sProperty4[0][3]%></td>
                 <td class="underlinetd"><%=sProperty4[1][3]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">����Ӧ�տ�</td>
                 <td class="underlinetd"><%=sProperty1[0][4]%></td>
                 <td class="underlinetd"><%=sProperty1[1][4]%></td>
                 <td class="underlinetd"><%=sProperty2[0][4]%></td>
                 <td class="underlinetd"><%=sProperty2[1][4]%></td>
                 <td class="underlinetd"><%=sProperty3[0][4]%></td>
                 <td class="underlinetd"><%=sProperty3[1][4]%></td>
                 <td class="underlinetd"><%=sProperty4[0][4]%></td>
                 <td class="underlinetd"><%=sProperty4[1][4]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">���</td>
                 <td class="underlinetd"><%=sProperty1[0][5]%></td>
                 <td class="underlinetd"><%=sProperty1[1][5]%></td>
                 <td class="underlinetd"><%=sProperty2[0][5]%></td>
                 <td class="underlinetd"><%=sProperty2[1][5]%></td>
                 <td class="underlinetd"><%=sProperty3[0][5]%></td>
                 <td class="underlinetd"><%=sProperty3[1][5]%></td>
                 <td class="underlinetd"><%=sProperty4[0][5]%></td>
                 <td class="underlinetd"><%=sProperty4[1][5]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">����Ͷ�ʜQ��</td>
                 <td class="underlinetd"><%=sProperty1[0][6]%></td>
                 <td class="underlinetd"><%=sProperty1[1][6]%></td>
                 <td class="underlinetd"><%=sProperty2[0][6]%></td>
                 <td class="underlinetd"><%=sProperty2[1][6]%></td>
                 <td class="underlinetd"><%=sProperty3[0][6]%></td>
                 <td class="underlinetd"><%=sProperty3[1][6]%></td>
                 <td class="underlinetd"><%=sProperty4[0][6]%></td>
                 <td class="underlinetd"><%=sProperty4[1][6]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">�̶��ʲ���ֵ</td>
                 <td class="underlinetd"><%=sProperty1[0][7]%></td>
                 <td class="underlinetd"><%=sProperty1[1][7]%></td>
                 <td class="underlinetd"><%=sProperty2[0][7]%></td>
                 <td class="underlinetd"><%=sProperty2[1][7]%></td>
                 <td class="underlinetd"><%=sProperty3[0][7]%></td>
                 <td class="underlinetd"><%=sProperty3[1][7]%></td>
                 <td class="underlinetd"><%=sProperty4[0][7]%></td>
                 <td class="underlinetd"><%=sProperty4[1][7]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">�����ʲ��Q��</td>
                 <td class="underlinetd"><%=sProperty1[0][8]%></td>
                 <td class="underlinetd"><%=sProperty1[1][8]%></td>
                 <td class="underlinetd"><%=sProperty2[0][8]%></td>
                 <td class="underlinetd"><%=sProperty2[1][8]%></td>
                 <td class="underlinetd"><%=sProperty3[0][8]%></td>
                 <td class="underlinetd"><%=sProperty3[1][8]%></td>
                 <td class="underlinetd"><%=sProperty4[0][8]%></td>
                 <td class="underlinetd"><%=sProperty4[1][8]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">������ծ</td>
                 <td class="underlinetd"><%=sProperty1[0][9]%></td>
                 <td class="underlinetd"><%=sProperty1[1][9]%></td>
                 <td class="underlinetd"><%=sProperty2[0][9]%></td>
                 <td class="underlinetd"><%=sProperty2[1][9]%></td>
                 <td class="underlinetd"><%=sProperty3[0][9]%></td>
                 <td class="underlinetd"><%=sProperty3[1][9]%></td>
                 <td class="underlinetd"><%=sProperty4[0][9]%></td>
                 <td class="underlinetd"><%=sProperty4[1][9]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">���ڽ�һ���ڵ��ڵĳ��ڸ�ծ</td>
                 <td class="underlinetd"><%=sProperty1[0][10]%></td>
                 <td class="underlinetd"><%=sProperty1[1][10]%></td>
                 <td class="underlinetd"><%=sProperty2[0][10]%></td>
                 <td class="underlinetd"><%=sProperty2[1][10]%></td>
                 <td class="underlinetd"><%=sProperty3[0][10]%></td>
                 <td class="underlinetd"><%=sProperty3[1][10]%></td>
                 <td class="underlinetd"><%=sProperty4[0][10]%></td>
                 <td class="underlinetd"><%=sProperty4[1][10]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">Ӧ��Ʊ��</td>
                 <td class="underlinetd"><%=sProperty1[0][11]%></td>
                 <td class="underlinetd"><%=sProperty1[1][11]%></td>
                 <td class="underlinetd"><%=sProperty2[0][11]%></td>
                 <td class="underlinetd"><%=sProperty2[1][11]%></td>
                 <td class="underlinetd"><%=sProperty3[0][11]%></td>
                 <td class="underlinetd"><%=sProperty3[1][11]%></td>
                 <td class="underlinetd"><%=sProperty4[0][11]%></td>
                 <td class="underlinetd"><%=sProperty4[1][11]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">Ӧ���ʿ�</td>
                 <td class="underlinetd"><%=sProperty1[0][12]%></td>
                 <td class="underlinetd"><%=sProperty1[1][12]%></td>
                 <td class="underlinetd"><%=sProperty2[0][12]%></td>
                 <td class="underlinetd"><%=sProperty2[1][12]%></td>
                 <td class="underlinetd"><%=sProperty3[0][12]%></td>
                 <td class="underlinetd"><%=sProperty3[1][12]%></td>
                 <td class="underlinetd"><%=sProperty4[0][12]%></td>
                 <td class="underlinetd"><%=sProperty4[1][12]%></td>
               </tr>
			    <tr>
                 <td class="underlinetd">���ڸ�ծ�ϼ�</td>
                 <td class="underlinetd"><%=sProperty1[0][13]%></td>
                 <td class="underlinetd"><%=sProperty1[1][13]%></td>
                 <td class="underlinetd"><%=sProperty2[0][13]%></td>
                 <td class="underlinetd"><%=sProperty2[1][13]%></td>
                 <td class="underlinetd"><%=sProperty3[0][13]%></td>
                 <td class="underlinetd"><%=sProperty3[1][13]%></td>
                 <td class="underlinetd"><%=sProperty4[0][13]%></td>
                 <td class="underlinetd"><%=sProperty4[1][13]%></td>
               </tr>
			    <tr>
                 <td class="underlinetd">������Ȩ��</td>
                 <td class="underlinetd"><%=sProperty1[0][14]%></td>
                 <td class="underlinetd"><%=sProperty1[1][14]%></td>
                 <td class="underlinetd"><%=sProperty2[0][14]%></td>
                 <td class="underlinetd"><%=sProperty2[1][14]%></td>
                 <td class="underlinetd"><%=sProperty3[0][14]%></td>
                 <td class="underlinetd"><%=sProperty3[1][14]%></td>
                 <td class="underlinetd"><%=sProperty4[0][14]%></td>
                 <td class="underlinetd"><%=sProperty4[1][14]%></td>
               </tr>
			    <tr>
                 <td class="underlinetd">ʵ���ʱ�</td>
                 <td class="underlinetd"><%=sProperty1[0][15]%></td>
                 <td class="underlinetd"><%=sProperty1[1][15]%></td>
                 <td class="underlinetd"><%=sProperty2[0][15]%></td>
                 <td class="underlinetd"><%=sProperty2[1][15]%></td>
                 <td class="underlinetd"><%=sProperty3[0][15]%></td>
                 <td class="underlinetd"><%=sProperty3[1][15]%></td>
                 <td class="underlinetd"><%=sProperty4[0][15]%></td>
                 <td class="underlinetd"><%=sProperty4[1][15]%></td>
               </tr>
           </table></td>		   
         </tr>
		 <tr>
           <td width="1" bgcolor="#DCDCDC">�����</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               	if(!sSYMonth.equals(""))
               	{
               %>
               <tr>
                 <td width="10%" rowspan="2" valign="top" class="underlinetd">��Ŀ</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYMonth.substring(0,4)%>��<%=sSYMonth.substring(5,7)%>��</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYYear1.substring(0,4)%>��</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYYear2.substring(0,4)%>��</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYYear3.substring(0,4)%>��</td>
                 </tr>
               <tr>
               <%
               	}
               	else
               	{
               %>
               <tr>
                 <td width="10%" rowspan="2" valign="top" class="underlinetd">��Ŀ</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;��&nbsp;��</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;��</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;��</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;��</td>
               </tr>
              <% 
              	}
              %>
               <tr>
                 <td width="17%" class="underlinetd">��ֵ</td>
                 <td width="13%" class="underlinetd">ռ��(%)</td>
                 <td width="7%" class="underlinetd">��ֵ</td>
                 <td width="13%" class="underlinetd">ռ��(%)</td>
                 <td width="7%" class="underlinetd">��ֵ</td>
                 <td width="13%" class="underlinetd">ռ��(%)</td>
                 <td width="7%" class="underlinetd">��ֵ</td>
                 <td width="13%" class="underlinetd">ռ��(%)</td>
               </tr>
			   <tr>
                 <td class="underlinetd">��Ӫҵ������</td>
                 <td class="underlinetd"><%=sSYValue1[0][0]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][0]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][0]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][0]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][0]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][0]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][0]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][0]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">��Ӫҵ��ɱ�</td>
                 <td class="underlinetd"><%=sSYValue1[0][1]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][1]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][1]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][1]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][1]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][1]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][1]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][1]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">��Ӫҵ������</td>
                 <td class="underlinetd"><%=sSYValue1[0][2]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][2]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][2]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][2]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][2]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][2]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][2]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][2]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">Ӫҵ����</td>
                 <td class="underlinetd"><%=sSYValue1[0][3]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][3]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][3]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][3]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][3]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][3]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][3]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][3]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">�������</td>
                 <td class="underlinetd"><%=sSYValue1[0][4]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][4]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][4]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][4]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][4]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][4]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][4]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][4]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">�������</td>
                 <td class="underlinetd"><%=sSYValue1[0][5]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][5]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][5]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][5]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][5]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][5]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][5]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][5]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">Ӫҵ����</td>
                 <td class="underlinetd"><%=sSYValue1[0][6]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][6]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][6]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][6]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][6]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][6]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][6]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][6]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">�����ܶ�</td>
                 <td class="underlinetd"><%=sSYValue1[0][7]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][7]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][7]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][7]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][7]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][7]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][7]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][7]%></td>
               </tr>
			   <tr>
                 <td class="underlinetd">������</td>
                 <td class="underlinetd"><%=sSYValue1[0][8]%></td>
                 <td class="underlinetd"><%=sSYValue1[1][8]%></td>
                 <td class="underlinetd"><%=sSYValue2[0][8]%></td>
                 <td class="underlinetd"><%=sSYValue2[1][8]%></td>
                 <td class="underlinetd"><%=sSYValue3[0][8]%></td>
                 <td class="underlinetd"><%=sSYValue3[1][8]%></td>
                 <td class="underlinetd"><%=sSYValue4[0][8]%></td>
                 <td class="underlinetd"><%=sSYValue4[1][8]%></td>
               </tr>			   
           </table></td>		   
         </tr>
		  <tr>
           <td width="1" bgcolor="#DCDCDC">�ֽ�������</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sXJMonth.equals(""))
               {
               %>
               <tr>
                 <td width="15%" rowspan="2" valign="top" class="underlinetd">��Ŀ</td>
                 <td width="22%" valign="top" class="underlinetd"><%=sXJMonth.substring(0,4)%>��<%=sXJMonth.substring(5,7)%>��</td>
                 <td width="22%" valign="top" class="underlinetd"><%=sXJYear1.substring(0,4)%>��</td>
                 <td width="29%" valign="top" class="underlinetd"><%=sXJYear2.substring(0,4)%>��</td>
                 <td width="12%" valign="top" class="underlinetd"><%=sXJYear3.substring(0,4)%>��</td>
                 </tr>
                 <%
                 }
                 else
                 {	
                 %>
               <tr>
                 <td width="15%" rowspan="2" valign="top" class="underlinetd">��Ŀ</td>
                 <td width="22%" valign="top" class="underlinetd">&nbsp;��&nbsp;��</td>
                 <td width="22%" valign="top" class="underlinetd">&nbsp;��</td>
                 <td width="29%" valign="top" class="underlinetd">&nbsp;��</td>
                 <td width="12%" valign="top" class="underlinetd">&nbsp;��</td>
                </tr>                 
                 <%
                 	}
                 %>
               <tr>
                 <td class="underlinetd">��ֵ</td>
                 <td class="underlinetd">��ֵ</td>
                 <td class="underlinetd">��ֵ</td>
                 <td class="underlinetd">��ֵ</td>
                 </tr>
			   <tr>
                 <td class="underlinetd">��Ӫ��ֽ�������</td>
                 <td class="underlinetd"><%=sXJValue1[0]%></td>
                 <td class="underlinetd"><%=sXJValue2[0]%></td>
                 <td class="underlinetd"><%=sXJValue3[0]%></td>
                 <td class="underlinetd"><%=sXJValue4[0]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">��Ӫ��ֽ�������</td>
                 <td class="underlinetd"><%=sXJValue1[1]%></td>
                 <td class="underlinetd"><%=sXJValue2[1]%></td>
                 <td class="underlinetd"><%=sXJValue3[1]%></td>
                 <td class="underlinetd"><%=sXJValue4[1]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">��Ӫ��ֽ�������</td>
                 <td class="underlinetd"><%=sXJValue1[2]%></td>
                 <td class="underlinetd"><%=sXJValue2[2]%></td>
                 <td class="underlinetd"><%=sXJValue3[2]%></td>
                 <td class="underlinetd"><%=sXJValue4[2]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">Ͷ�ʻ�ֽ�������</td>
                 <td class="underlinetd"><%=sXJValue1[3]%></td>
                 <td class="underlinetd"><%=sXJValue2[3]%></td>
                 <td class="underlinetd"><%=sXJValue3[3]%></td>
                 <td class="underlinetd"><%=sXJValue4[3]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">���ʻ�ֽ�������</td>
                 <td class="underlinetd"><%=sXJValue1[4]%></td>
                 <td class="underlinetd"><%=sXJValue2[4]%></td>
                 <td class="underlinetd"><%=sXJValue3[4]%></td>
                 <td class="underlinetd"><%=sXJValue4[4]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">���ֽ�����</td>
                 <td class="underlinetd"><%=sXJValue1[5]%></td>
                 <td class="underlinetd"><%=sXJValue2[5]%></td>
                 <td class="underlinetd"><%=sXJValue3[5]%></td>
                 <td class="underlinetd"><%=sXJValue4[5]%></td>
                 </tr>			  			   
           </table></td>		   
         </tr>
		 <tr>
           <td width="1" bgcolor="#DCDCDC">��ծ����</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sCZMonth1.equals(""))
               {
               %>
               <tr>
                 <td width="23%" valign="top" class="underlinetd">��Ŀ</td>
                 <td width="20%" valign="top" class="underlinetd"><%=sCZMonth1.substring(0,4)%>��<%=sCZMonth1.substring(5,7)%>��</td>
                 <td width="18%" valign="top" class="underlinetd">�����</td>
                 <td width="23%" valign="top" class="underlinetd">&nbsp;ǰ���</td>
                 <td width="16%" valign="top" class="underlinetd">&nbsp;ȥ��ͬ��</td>
               </tr>
                 <%
                 }
                 else
                 {	
                 %>
               <tr>
                 <td width="23%" valign="top" class="underlinetd">��Ŀ</td>
                 <td width="20%" valign="top" class="underlinetd"> &nbsp;��&nbsp;��</td>
                 <td width="18%" valign="top" class="underlinetd">�����</td>
                 <td width="23%" valign="top" class="underlinetd">&nbsp;ǰ���</td>
                 <td width="16%" valign="top" class="underlinetd">&nbsp;ȥ��ͬ��</td>
               </tr> 
                 <%
                 	}
                 %>                                 
               <tr>
                 <td valign="top" class="underlinetd">Ϣ˰ǰ������Ϣ���ϱ���</td>
                 <td class="underlinetd"><%=sCZValue1[0]%></td>
                 <td class="underlinetd"><%=sCZValue2[0]%></td>
                 <td class="underlinetd"><%=sCZValue3[0]%></td>
                 <td class="underlinetd"><%=sCZValue4[0]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">�������� (%)</td>
                 <td class="underlinetd"><%=sCZValue1[1]%></td>
                 <td class="underlinetd"><%=sCZValue2[1]%></td>
                 <td class="underlinetd"><%=sCZValue3[1]%></td>
                 <td class="underlinetd"><%=sCZValue4[1]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">�ٶ����� (%)</td>
                 <td class="underlinetd"><%=sCZValue1[2]%></td>
                 <td class="underlinetd"><%=sCZValue2[2]%></td>
                 <td class="underlinetd"><%=sCZValue3[2]%></td>
                 <td class="underlinetd"><%=sCZValue4[2]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">�ʲ���ծ�� (%)</td>
                 <td class="underlinetd"><%=sCZValue1[3]%></td>
                 <td class="underlinetd"><%=sCZValue2[3]%></td>
                 <td class="underlinetd"><%=sCZValue3[3]%></td>
                 <td class="underlinetd"><%=sCZValue4[3]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">��Ӫ������ľ��ֽ�����/��ծ��</td>
                 <td class="underlinetd"><%=sCZValue1[4]%></td>
                 <td class="underlinetd"><%=sCZValue2[4]%></td>
                 <td class="underlinetd"><%=sCZValue3[4]%></td>
                 <td class="underlinetd"><%=sCZValue4[4]%></td>
                 </tr>		  			   
           </table></td>		   
         </tr>
		 <tr>
           <td width="1" bgcolor="#DCDCDC">ӯ������</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sCZMonth1.equals(""))
               {
               %>
               <tr>
                 <td valign="top" class="underlinetd">��Ŀ</td>
                 <td valign="top" class="underlinetd"> <%=sCZMonth1.substring(0,4)%>��<%=sCZMonth1.substring(5,7)%>��</td>
                 <td valign="top" class="underlinetd">�����</td>
                 <td valign="top" class="underlinetd">&nbsp;ǰ���</td>
                 <td valign="top" class="underlinetd">&nbsp;ȥ��ͬ��</td>
                 </tr>
                 <%
                 }
                 else
                 {	
                 %>
               <tr>
                 <td valign="top" class="underlinetd">��Ŀ</td>
                 <td valign="top" class="underlinetd"> &nbsp;��&nbsp;��</td>
                 <td valign="top" class="underlinetd">�����</td>
                 <td valign="top" class="underlinetd">&nbsp;ǰ���</td>
                 <td valign="top" class="underlinetd">&nbsp;ȥ��ͬ��</td>
                 </tr>
                 <%
                 }
                 %>                                                    
               <tr>
                 <td valign="top" class="underlinetd">��������</td>
                 <td class="underlinetd"><%=sYLValue1[0]%></td>
                 <td class="underlinetd"><%=sYLValue2[0]%></td>
                 <td class="underlinetd"><%=sYLValue3[0]%></td>
                 <td class="underlinetd"><%=sYLValue4[0]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">Ӫҵ����</td>
                 <td class="underlinetd"><%=sYLValue1[1]%></td>
                 <td class="underlinetd"><%=sYLValue2[1]%></td>
                 <td class="underlinetd"><%=sYLValue3[1]%></td>
                 <td class="underlinetd"><%=sYLValue4[1]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">��������</td>
                 <td class="underlinetd"><%=sYLValue1[2]%></td>
                 <td class="underlinetd"><%=sYLValue2[2]%></td>
                 <td class="underlinetd"><%=sYLValue3[2]%></td>
                 <td class="underlinetd"><%=sYLValue4[2]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">Ͷ������</td>
                 <td class="underlinetd"><%=sYLValue1[3]%></td>
                 <td class="underlinetd"><%=sYLValue2[3]%></td>
                 <td class="underlinetd"><%=sYLValue3[3]%></td>
                 <td class="underlinetd"><%=sYLValue4[3]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">������</td>
                 <td class="underlinetd"><%=sYLValue1[4]%></td>
                 <td class="underlinetd"><%=sYLValue2[4]%></td>
                 <td class="underlinetd"><%=sYLValue3[4]%></td>
                 <td class="underlinetd"><%=sYLValue4[4]%></td>
                 </tr>	
				<tr>
                 <td class="underlinetd">����������(%)</td>
                 <td class="underlinetd"><%=sCZValue1[5]%></td>
                 <td class="underlinetd"><%=sCZValue2[5]%></td>
                 <td class="underlinetd"><%=sCZValue3[5]%></td>
                 <td class="underlinetd"><%=sCZValue4[5]%></td>
                 </tr>
				<tr>
                 <td class="underlinetd">���ʲ�������(%)</td>
                 <td class="underlinetd"><%=sCZValue1[6]%></td>
                 <td class="underlinetd"><%=sCZValue2[6]%></td>
                 <td class="underlinetd"><%=sCZValue3[6]%></td>
                 <td class="underlinetd"><%=sCZValue4[6]%></td>
                 </tr>
				<tr>
                 <td class="underlinetd">���ʲ�������(%)</td>
                 <td class="underlinetd"><%=sCZValue1[7]%></td>
                 <td class="underlinetd"><%=sCZValue2[7]%></td>
                 <td class="underlinetd"><%=sCZValue3[7]%></td>
                 <td class="underlinetd"><%=sCZValue4[7]%></td>
                 </tr>  			   
           </table></td>		   
         </tr>
		 <tr>
           <td width="1" bgcolor="#DCDCDC">Ӫ������</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sCZMonth1.equals(""))
               {
               %>
               <tr>
                 <td valign="top" class="underlinetd">��Ŀ</td>
                 <td valign="top" class="underlinetd">  <%=sCZMonth1.substring(0,4)%>��<%=sCZMonth1.substring(5,7)%>��</td>
                 <td valign="top" class="underlinetd">�����</td>
                 <td valign="top" class="underlinetd">&nbsp;ǰ���</td>
                 <td valign="top" class="underlinetd">&nbsp;ȥ��ͬ��</td>
                 </tr>
                 <%
                 }
                 else
                 {	
                 %> 
               <tr>
                 <td valign="top" class="underlinetd">��Ŀ</td>
                 <td valign="top" class="underlinetd"> &nbsp;��&nbsp;��</td>
                 <td valign="top" class="underlinetd">�����</td>
                 <td valign="top" class="underlinetd">&nbsp;ǰ���</td>
                 <td valign="top" class="underlinetd">&nbsp;ȥ��ͬ��</td>
                 </tr>
                 <%
                 }
                 %>                                                    
               <tr>
                 <td valign="top" class="underlinetd">Ӧ���ʿ���ת����</td>
                 <td class="underlinetd"><%=sCZValue1[8]%></td>
                 <td class="underlinetd"><%=sCZValue2[8]%></td>
                 <td class="underlinetd"><%=sCZValue3[8]%></td>
                 <td class="underlinetd"><%=sCZValue4[8]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">�����ת����</td>
                 <td class="underlinetd"><%=sCZValue1[9]%></td>
                 <td class="underlinetd"><%=sCZValue2[9]%></td>
                 <td class="underlinetd"><%=sCZValue3[9]%></td>
                 <td class="underlinetd"><%=sCZValue4[9]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">���ʲ���ת��</td>
                 <td class="underlinetd"><%=sCZValue1[10]%></td>
                 <td class="underlinetd"><%=sCZValue2[10]%></td>
                 <td class="underlinetd"><%=sCZValue3[10]%></td>
                 <td class="underlinetd"><%=sCZValue4[10]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">�����ʲ���ת��</td>
                 <td class="underlinetd"><%=sCZValue1[11]%></td>
                 <td class="underlinetd"><%=sCZValue2[11]%></td>
                 <td class="underlinetd"><%=sCZValue3[11]%></td>
                 <td class="underlinetd"><%=sCZValue4[11]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">�̶��ʲ���ת��</td>
                 <td class="underlinetd"><%=sCZValue1[12]%></td>
                 <td class="underlinetd"><%=sCZValue2[12]%></td>
                 <td class="underlinetd"><%=sCZValue3[12]%></td>
                 <td class="underlinetd"><%=sCZValue4[12]%></td>
                 </tr>	 			   
           </table></td>		   
         </tr>
       </table></td>
       </tr>
	  <tr>
       <td height="18" colspan="9" bgcolor="#DCDCDC" class="tableborder1">����������������Ϣ(��;)</td>
       </tr>
	  <tr>
       <td height="18" colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">ҵ��Ʒ��</td>
           <td valign="top" class="underlinetd">��������</td>
           <td valign="top" class="underlinetd">����</td>
           <td valign="top" class="underlinetd">������</td>
           <td valign="top" class="underlinetd">��������</td>
           <td valign="top" class="underlinetd">����(��)</td>
           <td valign="top" class="underlinetd">��(��)</td>
           <td valign="top" class="underlinetd">��Ҫ������ʽ</td>
           <td valign="top" class="underlinetd">�������</td>
         </tr>
         <%
         	while(rs5.next())
         	{
         %>
         <tr>
           <td class="underlinetd"><%=rs5.getString("BusinessType")%></td>
           <td class="underlinetd"><%=rs5.getString("Occurtype")%></td>
           <td class="underlinetd"><%=rs5.getString("BusinessCurrency")%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs5.getDouble("BusinessSum"))%></td>
           <td class="underlinetd"><%=rs5.getString("OccurDate")%></td>
           <td class="underlinetd"><%=rs5.getInt("TermMonth")%></td>
           <td class="underlinetd"><%=rs5.getInt("TermDay")%></td>
           <td class="underlinetd"><%=rs5.getString("VouchType")%></td>
           <td class="underlinetd"><%=rs5.getString("OperateOrgName")%></td>
         </tr>
         <%
         	}
         	rs5.getStatement().close();
         %>
       </table>
       </td>
       </tr>
       
       
       <%
       	if(rs6.next())
       	{
       %>
	 <tr>
       <td width="2%" rowspan="5" bgcolor="#DCDCDC" class="tableborder1">���Ŷ����Ϣ</td>
       <td width="14%" height="18" class="underlinetd">���ű���</td>
       <td height="18" class="underlinetd"><%=rs6.getString("BusinessCurrency")%></td>
       <td height="18" class="underlinetd">�����ܽ��</td>
       <td height="18" class="underlinetd"><%=DataConvert.toMoney(rs6.getDouble("BusinessSum"))%></td>
       <td height="18" class="underlinetd">������ʼ��</td>
       <td height="18" class="underlinetd"><%=rs6.getString("PutoutDate")%></td>
       <td height="18" class="underlinetd">���ŵ�����</td>
       <td height="18" class="underlinetd"><%=rs6.getString("Maturity")%></td>
	 </tr>
	   <tr>
       <td height="18" class="underlinetd">���ʹ���������</td>
       <td height="18" class="underlinetd"><%=rs6.getString("LimitationTerm")%></td>
       <td height="18" class="underlinetd">�������ҵ����ٵ�������</td>
       <td height="18" class="underlinetd"><%=rs6.getString("UseTerm")%></td>
       <td height="18" class="underlinetd">ռ�ý��</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">ռ�ñ���(%)</td>
       <td height="18" class="underlinetd">&nbsp;</td>
	   </tr>
	   <%
	   	}
	   	else
	   	{
	   %>
	  <tr>
       <td width="2%" rowspan="5" bgcolor="#DCDCDC" class="tableborder1">���Ŷ����Ϣ</td>
       <td width="14%" height="18" class="underlinetd">���ű���</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">�����ܽ��</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">������ʼ��</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">���ŵ�����</td>
       <td height="18" class="underlinetd">&nbsp;</td>
	 </tr>
	   <tr>
       <td height="18" class="underlinetd">���ʹ���������</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">�������ҵ����ٵ�������</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">ռ�ý��</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">ռ�ñ���(%)</td>
       <td height="18" class="underlinetd">&nbsp;</td>
      </tr>
      <%
      	}
      	rs6.getStatement().close();
      %> 
      
      
	   <tr>
       <td height="18" colspan="8" bgcolor="#DCDCDC" class="tableborder1">���ŷ�����ϸ��Ϣ</td>
       </tr>
	   <tr>
       <td height="18" class="underlinetd">����Ʒ��</td>
       <td height="18" class="underlinetd">���ű���</td>
       <td height="18" class="underlinetd">�����޶�</td>
       <td height="18" class="underlinetd">�����޶�</td>
       <td height="18" class="underlinetd">��ͱ�֤�����</td>
       <td height="18" class="underlinetd">�Ƿ�ѭ��</td>
       <td height="18" class="underlinetd">ռ�ý��</td>
       <td height="18" class="underlinetd">ռ�ñ���(%)</td>
	   </tr> 
	   <%
	   	while(rs7.next())
	   	{
	   %>
	    <tr>
       <td height="18" class="underlinetd"><%=rs7.getString("BusinessType")%></td>
       <td height="18" class="underlinetd"><%=rs7.getString("BusinessCurrency")%></td>
       <td height="18" class="underlinetd"><%=DataConvert.toMoney(rs7.getDouble("LineSum1"))%></td>
       <td height="18" class="underlinetd"><%=DataConvert.toMoney(rs7.getDouble("LineSum2"))%></td>
       <td height="18" class="underlinetd"><%=DataConvert.toMoney(rs7.getDouble("BailRatio"))%></td>
       <td height="18" class="underlinetd"><%=rs7.getString("Rotative")%></td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">&nbsp;</td>
	   </tr>
	   <%
	   	}
	   	rs7.getStatement().close();
	   %>
	 <tr>
       <td height="18" colspan="9" bgcolor="#DCDCDC" class="tableborder1">������δ��������ҵ����Ϣ</td>
       </tr>
     <tr>
       <td colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">

         <tr>
           <td class="underlinetd">����ҵ��Ʒ��</td>
           <td class="underlinetd">��������</td>
           <td class="underlinetd">��Ҫ������ʽ</td>
           <td class="underlinetd">���</td>
           <td class="underlinetd">����</td>
           <td class="underlinetd">����</td>
           <td class="underlinetd">������</td>
           <td class="underlinetd">������</td>
           <td class="underlinetd">�弶����</td>
         </tr>
       <%
	   	while(rs8.next())
	   	{
	   %>
		 <tr>
           <td class="underlinetd"><%=rs8.getString("BusinessType")%></td>
           <td class="underlinetd"><%=rs8.getString("OccurType")%></td>
           <td class="underlinetd"><%=rs8.getString("VouchType")%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs8.getDouble("BusinessSum"))%></td>
           <td class="underlinetd"><%=rs8.getString("BusinessCurrency")%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs8.getDouble("BusinessRate"))%></td>
           <td class="underlinetd"><%=rs8.getString("PutoutDate")%></td>
           <td class="underlinetd"><%=rs8.getString("Maturity")%></td>
           <td class="underlinetd"><%=rs8.getString("ClassifyResult")%></td>
         </tr>
       <%
       }
       rs8.getStatement().close();
       %>  
       </table></td>
     </tr>
	 <tr>
       <td height="18" colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <%
         	if(rs9.next())
         	{
         %>
         <tr>
           <td width="2%" rowspan="5" valign="top" bgcolor="#DCDCDC" class="tableborder1">����ҵ������״��</td>
           <td width="10%" rowspan="2" valign="top" class="underlinetd">�ļ��������</td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="10%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("NormalBalance"))%></td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="11%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("NormalBalance1"))%></td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="11%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("OverDueBalance"))%></td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="20%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("OverDueBalance1"))%></td>
         </tr>
         <tr>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("DullBalance"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("DullBalance1"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("BadBalance"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("BadBalance1"))%></td>
         </tr>
		<%
			}
			else
			{
		%>
         <tr>
           <td width="2%" rowspan="5" valign="top" bgcolor="#DCDCDC" class="tableborder1">����ҵ������״��</td>
           <td width="10%" rowspan="2" valign="top" class="underlinetd">�ļ��������</td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="10%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="11%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="11%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="9%" valign="top" class="underlinetd">���������</td>
           <td width="20%" valign="top" class="underlinetd">&nbsp;</td>
         </tr>
         <tr>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
         </tr>
         <%
         }
         rs9.getStatement().close();
         if(rs10.next())
         {
         %>		
		  <tr>
           <td rowspan="3" class="underlinetd">�弶�������</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum1"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum11"))%></td>
           <td class="underlinetd">��ע�����</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum2"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum22"))%></td>
		  </tr>
		  <tr>
           <td class="underlinetd">�μ������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum3"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum33"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum4"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum44"))%></td>
         </tr>
		  <tr>
           <td class="underlinetd">��ʧ�����</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum5"))%></td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum55"))%></td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
		  </tr>
		  <%
		  }
		  else
		  {
		  %>
		 <tr>
           <td rowspan="3" class="underlinetd">�弶�������</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">��ע�����</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
		  </tr>
		  <tr>
           <td class="underlinetd">�μ������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
         </tr>
		  <tr>
           <td class="underlinetd">��ʧ�����</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">���������</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
		  </tr>
		  <%
		  }
		  rs10.getStatement().close();
		  %>
       </table></td>
       </tr>
	 <tr>
       <td height="18" colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td width="2%" rowspan="5" valign="top" bgcolor="#DCDCDC" class="tableborder1">���ڵ������</td>
           <td colspan="2" valign="top" class="underlinetd">���굽��ҵ��</td>
           <td width="7%" rowspan="5" valign="top" class="underlinetd">����</td>
           <td width="10%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="7%" valign="top" class="underlinetd">����</td>
           <td width="14%" valign="top" class="underlinetd">�жһ�Ʊ</td>
           <td width="20%" valign="top" class="underlinetd">����֤</td>
         </tr>
         <tr>
           <td width="11%" class="underlinetd">�����ܶ�</td>
           <td width="29%" class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[0])%></td>
           <td class="underlinetd">һ����</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[1])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[1])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[1])%></td>
         </tr>
		 <tr>
           <td class="underlinetd">�жһ�Ʊ�ܶ�</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[0])%></td>
           <td class="underlinetd">������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[2])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[2])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[2])%></td>
         </tr>
		 <tr>
           <td class="underlinetd">����֤�ܶ�</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[0])%></td>
           <td class="underlinetd">������</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[3])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[3])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[3])%></td>
         </tr>
		 <tr>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">�ļ���</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[4])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[4])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[4])%></td>
         </tr>
       </table></td>
       </tr>
	  <tr>
       <td height="18" colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td width="2%" rowspan="2" valign="top" bgcolor="#DCDCDC" class="tableborder1">��Լ���</td>
           <td width="14%" rowspan="2" valign="top" class="underlinetd">�����ѵ��ڴ����ܶ�</td>
           <td width="12%" rowspan="2" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[0])%></td>
           <td width="14%" valign="top" class="underlinetd">�����ջ�</td>
           <td width="2%" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[1])%></td>
           <td width="25%" valign="top" class="underlinetd">չ��</td>
           <td width="2%" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[2])%></td>
           <td width="27%" valign="top" class="underlinetd">���ɽ���</td>
           <td width="2%" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[3])%></td>
         </tr>
         <tr>
           <td class="underlinetd">���»���</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBalance[4])%></td>
           <td class="underlinetd">����(���ڡ����͡�����)</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBalance[5])%></td>
           <td class="underlinetd">�������μ������ɡ���ʧ��</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBalance[6])%></td>
         </tr>
       </table></td>
       </tr>
   </table></td>
  </tr>
</table>
</body>
</html>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
		function openFeedbackInfo()
		{
			PopComp("CollectionFeedbackInfo","/CBCollection/CollectionMonitor/CollectionFeedbackInfo.jsp","","_Blank")
		}
		
		function openTips()
		{
			PopPage("/CBCollection/PhoneCollection/PhoneCollectionTips.jsp","","resizable=yes;dialogWidth=80;dialogHeight=60;center:yes;status:no;statusbar:no");
		}		
			
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
