<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2007.03.13
		Tester:
		Content: 客户信息一览
		Input Param:
		Output param:fhuang 填充数据 2007.03.15
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数，客户代码
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";	
%>
<%/*~END~*/%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>客户信息一览</title>
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
	//计算资产负债表中的内容
	public String[][] getPropertyValue(String sReportNo,Transaction Sqlca) throws Exception
	{
		//最近月报资产负债表总资产,流动资产,货币资金,应收帐款净额,其他应收款,存货,长期投资淨额,固定资产净值,无形资产淨额,流动负债,短期借款及一年内到期的长期负债,应付票据,应付帐款,长期负债合计,所有者权益,实收资本
		String sProperty [][] = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
		ASResultSet rs = null;
		double dValue = 0 ;  //最近月报资产负债表中资产总计
		double dFValue = 0 ; //最近月报资产负债表中负债合计
		
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
			//短期借款及一年内到期的长期负债
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
				if (sRowSubject.equals("801"))	//流动资产合计 
				{
					sProperty[0][1] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][1] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("101"))	//货币资金
				{		
					sProperty[0][2] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][2] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//应收帐款净额
				{
					sProperty[0][3] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][3] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//其他应收款
				{
					sProperty[0][4] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][4] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("110"))	//存货
				{
					sProperty[0][5] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][5] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19h"))	//长期投资淨额(暂缺，请对应科目)
				{
					sProperty[0][6] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][6] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//固定资产净值
				{
					sProperty[0][7] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][7] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//无形资产淨额(暂缺，请对应科目)
				{
					sProperty[0][8] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][8] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("805"))	//流动负债
				{
					sProperty[0][9] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][9] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("202"))	//应付票据
				{
					sProperty[0][11] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][11] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("203"))	//应付帐款
				{
					sProperty[0][12] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][12] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("806"))	//长期负债合计
				{
					sProperty[0][13] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][13] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("808"))	//所有者权益
				{
					sProperty[0][14] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][14] = DataConvert.toMoney(rs.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("301"))	//实收资本
				{
					sProperty[0][15] = DataConvert.toMoney(rs.getDouble("Col2value"));
					sProperty[1][15] = DataConvert.toMoney(rs.getDouble("Col2value")/dValue*100);
				}
			}
			rs.getStatement().close();
		}

		return sProperty;		
	}
	//计算损益表中的内容
	public String[][] getSYValue(String sReportNo,Transaction Sqlca) throws Exception
	{
		String ssyValue[][] = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
		ASResultSet rs = null;
		double dsyValue = 0.00;//主营业收入
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('501','502','505','503','507','508','509','515','517')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("501"))		//主营业务收入
			{
				ssyValue[0][0] = DataConvert.toMoney(rs.getDouble("Col2value"));
				dsyValue = rs.getDouble("Col2value");
				ssyValue[1][0] = "100";		
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//主营业务成本
			{
				ssyValue[0][1] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][1] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);	
			}
			else if (sRowSubject.equals("505"))	//主营业务利润
			{
				ssyValue[0][2] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][2] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("503"))	//营业费用
			{
				ssyValue[0][3] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][3] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("507"))	//管理费用
			{
				ssyValue[0][4] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][4] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("508"))	//财务费用
			{
				ssyValue[0][5] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][5] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("509"))	//营业利润
			{
				ssyValue[0][6] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][6] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//利润总额
			{
				ssyValue[0][7] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[1][7] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//净利润
			{
				ssyValue[0][8] = DataConvert.toMoney(rs.getDouble("Col2value"));
				ssyValue[0][8] = DataConvert.toMoney(rs.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs.getStatement().close();	
		return ssyValue;
	}
	//计算现金流量表中的内容
	public String[] getXJValue(String sReportNo,Transaction Sqlca) throws Exception
	{
		String[] sxjValue = {"0","0","0","0","0","0"};
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('a20','a27','810','811','812','813')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("a20"))		//经营活动现金流入量
			{
				sxjValue[0] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("a27"))	//经营活动现金流出量
			{
				sxjValue[1] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("810"))	//经营活动现金流净额
			{
				sxjValue[2] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue[3] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue[4] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("813"))	//净现金流量
			{
				sxjValue[5] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			
		}
		rs.getStatement().close();	
		return sxjValue;
	}
	
	//计算偿债能力,盈利能力,营运能力
	public String[] getCZValue(String sReportNo,Transaction Sqlca) throws Exception	
	{
		String[] sczValue = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('914','915','916','911','999','901','909','932','907','908','905',' ','906')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("914"))		//利息保障倍数
			{
				sczValue[0] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("915"))	//流动比率
			{
				sczValue[1] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("916"))	//速动比率
			{
				sczValue[2] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("911"))	//资产负债比率
			{
				sczValue[3] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("999"))	//净现金流量/总债务
			{
				sczValue[4] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("901"))	//销售利润率
			{
				sczValue[5] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("909"))	//总资产报酬率
			{
				sczValue[6] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("932"))	//净资产收益率
			{
				sczValue[7] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("907"))	//应收帐款周转率
			{
				sczValue[8] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("908"))	//存货周转率
			{
				sczValue[9] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("905"))	//总资产周转率
			{
				sczValue[10] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals(" "))	//流动资产周转率(待定)
			{
				sczValue[11] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("906"))	//固定资产周转率
			{
				sczValue[12] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}						
		}
		rs.getStatement().close();	
		return sczValue;
	}
	
	public String[] getYLValue(String sReportNo,Transaction Sqlca) throws Exception	
	{
		//销售收入,营业利润，销售利润，投资收益，净利润
		String[] sylValue = {"0","0","0","0","0"};
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(new SqlObject("select Col2value,RowSubject from REPORT_DATA where ReportNo = :ReportNo And RowSubject in ('501','509','505','510','517')").setParameter("ReportNo",sReportNo));
		while(rs.next())
		{
			String sRowSubject = rs.getString("RowSubject");
			if(sRowSubject == null) sRowSubject = "";
			if (sRowSubject.equals("501"))		//销售收入
			{
				sylValue[0] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("509"))	//营业利润
			{
				sylValue[1] = DataConvert.toMoney(rs.getDouble("Col2value"));
			}
			else if (sRowSubject.equals("505"))	//销售利润
			{
				sylValue[2] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("510"))	//投资收益
			{
				sylValue[3] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("517"))	//净利润
			{
				sylValue[4] = DataConvert.toMoney(rs.getDouble("Col2value"));		
			}
		}
		rs.getStatement().close();	
		return sylValue;
	}
%>






<%
	//------------------------------------客户的基本信息-------------------------
	String sSql = "";
	ASResultSet rs = null;
	String sCustomerName = "";		//客户名称
	String sRegisterAdd = "";		//注册地址
	String sOfficeAdd = "";			//办公地址
	String sOrgType = "";			//企业类型
	String sIndustryType = "";		//国标行业分类
	String sScope = "";				//企业规模
	String sSetupDate = "";			//企业成立日期
	String sCreditLevel = "";		//本行即期信用等级
	String sLoanCardNo = "";		//贷款卡编码
	String sLicenseNo = "";			//工商营业执照号码
	String sLicenseDate = ""; 		//营业执照登记日
	String sLicenseMaturity = "";	//营业执照到期日
	String sRCCurrency = "";		//注册资本币种
	double dRegisterCapital = 0.00;	//注册资本
	String sPCCurrency = "";		//实收资本币种
	double dPaiclUpCapital = 0.00;	//实收资本
	String sFictitiousPerson = "";	//法定代表人
	String sMostBusiness = "";		//经营范围
	String sHasIERight = "";		//有无进出口经营权
	String sListingCorpType = "";	//上市公司类型	
	
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
	
	//-------------------------------股东情况----------------------------------
	ASResultSet rs1 = null;
	sSql = " Select CustomerName,getItemName('Currency',CurrencyType) as CurrencyType,InvestmentSum "+
		   " from CUSTOMER_RELATIVE where CustomerID=:CustomerID "+
		   " and RelationShip like '52%' and length(RelationShip)>2 and EffStatus='1'";
	rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//---------------------------对外股权投资------------------------------------
	ASResultSet rs2 = null;
	sSql = " Select CustomerName,getItemName('Currency',CurrencyType) as CurrencyType,InvestmentSum "+
		   " from CUSTOMER_RELATIVE where CustomerID=:CustomerID "+
		   " and RelationShip like '02%' and length(RelationShip)>2 and EffStatus='1'";
	rs2 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//--------------------------股票发行情况--------------------------------------
	ASResultSet rs3 = null;
	sSql = " Select IPODate,getItemName('IPOName',BourseName) as BourseName,StockCode,StockName "+
		   " from ENT_IPO where CustomerID=:CustomerID";
	rs3 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//-------------------------债券发行情况---------------------------------------
	ASResultSet rs4 = null;
	sSql = " select IssueDate,getItemName('BondType',BondType) as BondType,"+
		   " getItemName('Currency',BondCurrency) as BondCurrency,BondSum "+
		   " from ENT_BONDISSUE where CustomerID=:CustomerID";
	rs4 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//----------------------------在我行授信申请信息（在途）----------------------
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
	
	//-----------------------总授信额度(占用金额和占用比例待定)-----------------------------------------
	ASResultSet rs6 = null;
	sSql = " Select getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		   " BusinessSum,PutoutDate,Maturity,LimitationTerm,UseTerm "+
		   " from Business_Contract "+
		   " where CustomerID=:CustomerID "+
		   " and BusinessType like '3%' "+
		   " and PigeonholeDate is null "+
		   " and FreezeFlag not in ('2','3','4') ";
	rs6 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	
	//----------------------授信方案明细(占用金额和占用比例待定)-----------------------------------------
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
	
	//--------------------未结清的授信业务-----------------------------------------
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
	
	//----------------------------------四级分类-----------------------------------
	ASResultSet rs9 = null; 
	sSql = " Select NormalBalance,(NormalBalance-NormalBalanceLY) as NormalBalance1,"+
		   " OverDueBalance,(OverDueBalance-OverDueBalanceLY) as OverDueBalance1,"+
		   " DullBalance,(DullBalance-DullBalanceLY) as DullBalance1,"+
		   " BadBalance,(BadBalance-BadBalanceLY) as BadBalance1 "+
		   " from T_Fact_Loan_M "+
		   " where InputDate=(Select Max(InputDate) from T_Fact_Loan_M)"+
		   " and CustomerID=:CustomerID";
	rs9 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));	 
	
	//-----------------------------------五级分类------------------------------------
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
	
	//-------------------------------本年到期业务------------------------------------
	ASResultSet rs11 = null;	
	String sYear = (StringFunction.getToday()).substring(0,4);//本年
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

	
	//-----------------------履约情况------------------------------------------
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
	
	//****************************资产负债表***********************************************	
	String sReportDate = "";	//本月
	String sLastMonth = "";		//上月
	String sBeginYear = "";		//年初
	String sLastYear = "";		//去年同期 
	String sReportNo = ""; 		//报表号
	
	//最近月报资产负债表总资产,流动资产,货币资金,应收帐款净额,其他应收款,存货,长期投资淨额,固定资产净值,无形资产淨额,流动负债,短期借款及一年内到期的长期负债,应付票据,应付帐款,长期负债合计,所有者权益,实收资本
	String[][] sProperty1 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	String[][] sProperty2 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	String[][] sProperty3 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	String[][] sProperty4 = {{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}};
	
	//取最新资产负债表日期
	sNewSql="select ReportDate,ReportNo from REPORT_RECORD "+
	  		" where ObjectNo =:ObjectNo And ModelNo1 like '%1' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo =:ObjectNo2 And ModelNo like '%1')";
	so = new SqlObject(sNewSql);
	so.setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID);
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sReportDate = rs.getString("ReportDate");	//日期
		if(sReportDate == null) sReportDate = "";
		sReportNo = rs.getString("ReportNo");	//最近资产负债表号
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
	
	//-----------------------------损益表-----------------------------------
	String sSYMonth = "";
	String sSYYear1 = "";
	String sSYYear2 = "";
	String sSYYear3 = "";
	String[][] sSYValue1 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
	String[][] sSYValue2 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
	String[][] sSYValue3 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
	String[][] sSYValue4 = {{"0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0"}};
		
	//取最新损益表日期
	 rs = Sqlca.getASResultSet(new SqlObject("select ReportDate,ReportNo from REPORT_RECORD "+
		  " where ObjectNo =:ObjectNo1 And ModelNo like '%2' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo =:ObjectNo2 And ModelNo like '%2')").setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID));
	if(rs.next()){
		sSYMonth = rs.getString("ReportDate");	//日期
		if(sSYMonth == null) sSYMonth = "";
		sReportNo = rs.getString("ReportNo");	//最近损益表号
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
	
	//---------------------------------现金流量表------------------------------------------	
	String sXJMonth = "";
	String sXJYear1 = "";
	String sXJYear2 = "";
	String sXJYear3 = "";
	String[] sXJValue1 = {"0","0","0","0","0","0"};
	String[] sXJValue2 = {"0","0","0","0","0","0"};
	String[] sXJValue3 = {"0","0","0","0","0","0"};
	String[] sXJValue4 = {"0","0","0","0","0","0"};
	//取最新现金流量表日期
	 rs = Sqlca.getASResultSet(new SqlObject("select ReportDate,ReportNo from REPORT_RECORD "+
			  " where ObjectNo =:ObjectNo1 And ModelNo like '%8' And  ReportDate = (select max(Reportdate) from REPORT_RECORD "+
			  "Where ObjectNo =:ObjectNo2 And ModelNo like '%8')").setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID));
	if(rs.next()){
		sXJMonth = rs.getString("ReportDate");	//日期
		if(sXJMonth == null) sXJMonth = "";
		sReportNo = rs.getString("ReportNo");	//最近损益表号
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
	
	//------------------------------------偿债能力------------------------------
	String sCZMonth1 = "";
	String sCZMonth2 = "";
	String sCZMonth3 = "";
	String sCZMonth4 = "";
	String[] sCZValue1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sCZValue2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sCZValue3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sCZValue4 = {"0","0","0","0","0","0","0","0","0","0","0","0","0"};
	//取最新财务指标表日期
	 rs = Sqlca.getASResultSet(new SqlObject("select ReportDate,ReportNo from REPORT_RECORD "+
			  " where ObjectNo =:ObjectNo1 And ModelNo like '%9' And  ReportDate = (select max(Reportdate) from REPORT_RECORD "+
			  " Where ObjectNo =:ObjectNo2 And ModelNo like '%9')").setParameter("ObjectNo1",sCustomerID).setParameter("ObjectNo2",sCustomerID));
	if(rs.next()){
		sCZMonth1 = rs.getString("ReportDate");	//日期
		if(sCZMonth1 == null) sCZMonth1 = "";
		sReportNo = rs.getString("ReportNo");	//最近损益表号
		if(sReportNo == null) sReportNo = "";
	}
	rs.getStatement().close();
	if(!sReportNo.equals("")){
		sCZValue1 = getCZValue(sReportNo,Sqlca);
	}
	if(!sCZMonth1.equals("")){
		sCZMonth4 = StringFunction.getRelativeAccountMonth(sCZMonth1,"month",-12);//去年同期
		sCZMonth2  = sCZMonth4.substring(0,4)+"/12";//上年度
		sCZMonth3 = StringFunction.getRelativeAccountMonth(sCZMonth2,"month",-12);//前年度
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

	//---------------------------------盈利能力中的5项内容-----------------------------------------------
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
       <td colspan="9" bgcolor="#DCDCDC" class="tableborder1">客户概况</td>
       </tr>
     <tr>
       <td colspan="2" class="underlinetd">客户名称</td>
       <td width="6%" class="underlinetd"><%=sCustomerName%></td>
       <td width="17%" class="underlinetd">注册地址</td>
       <td width="16%" class="underlinetd"><%=sRegisterAdd%></td>
       <td width="14%" class="underlinetd">办公地址</td>
       <td width="11%" class="underlinetd"><%=sOfficeAdd%></td>
       <td width="10%" class="underlinetd">企业类型</td>
       <td width="10%" class="underlinetd"><%=sOrgType%></td>
     </tr>
     <tr>
       <td colspan="2" class="underlinetd">国标行业分类</td>
       <td class="underlinetd"><%=sIndustryType%></td>
       <td class="underlinetd">企业规模</td>
       <td class="underlinetd"><%=sScope%></td>
       <td class="underlinetd">企业成立日期</td>
       <td class="underlinetd"><%=sSetupDate%></td>
       <td class="underlinetd">本行即期信用等级</td>
       <td class="underlinetd"><%=sCreditLevel%></td>
     </tr>
	  <tr>
       <td colspan="2" class="underlinetd">贷款卡号</td>
       <td class="underlinetd"><%=sLoanCardNo%></td>
       <td class="underlinetd">营业执照号</td>
       <td class="underlinetd"><%=sLicenseNo%></td>
       <td class="underlinetd">营业执照登记日</td>
       <td class="underlinetd"><%=sLicenseDate%></td>
       <td class="underlinetd">营业执照到期日</td>
       <td class="underlinetd"><%=sLicenseMaturity%></td>
     </tr>
	  <tr>
       <td colspan="2" class="underlinetd">注册资本币种</td>
       <td class="underlinetd"><%=sRCCurrency%></td>
       <td class="underlinetd">注册资本</td>
       <td class="underlinetd"><%=DataConvert.toMoney(dRegisterCapital)%></td>
       <td class="underlinetd">实收资本币种</td>
       <td class="underlinetd"><%=sPCCurrency%></td>
       <td class="underlinetd">实收资本</td>
       <td class="underlinetd"><%=DataConvert.toMoney(dPaiclUpCapital)%></td>
     </tr>	 
	  <tr>
       <td colspan="2" class="underlinetd">法人代表</td>
       <td class="underlinetd"><%=sFictitiousPerson%></td>
       <td class="underlinetd">经营范围</td>
       <td class="underlinetd"><%=sMostBusiness%></td>
       <td class="underlinetd">有无进出口经营权</td>
       <td class="underlinetd"><%=sHasIERight%></td>
       <td class="underlinetd">上市公司类型</td>
       <td class="underlinetd"><%=sListingCorpType%></td>
     </tr>
     <tr>
       <td height="19" colspan="5" bgcolor="#DCDCDC" class="tableborder1">股东情况</td>
       <td height="19" colspan="4" bgcolor="#DCDCDC" class="tableborder1">对外股权投资情况</td>
       </tr>
     <tr>
       <td height="19" colspan="5" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">股东名称</td>
           <td valign="top" class="underlinetd">投资币种</td>
           <td valign="top" class="underlinetd">投资金额</td>
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
           <td valign="top" class="underlinetd">投向企业名称</td>
           <td valign="top" class="underlinetd">出资币种</td>
           <td valign="top" class="underlinetd">出资金额</td>
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
       <td height="18" colspan="5" bgcolor="#DCDCDC" class="tableborder1">股票信息</td>
       <td colspan="4" bgcolor="#DCDCDC" class="tableborder1">债权信息</td>
       </tr>
     <tr>
       <td colspan="5" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">上市时间</td>
           <td valign="top" class="underlinetd">上市地</td>
           <td valign="top" class="underlinetd">股票代码</td>
		   <td valign="top" class="underlinetd">股票简称</td>
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
           <td valign="top" class="underlinetd">发行时间</td>
           <td valign="top" class="underlinetd">债券类型</td>
           <td valign="top" class="underlinetd">发行币种</td>
		   <td valign="top" class="underlinetd">发行金额</td>
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
       		<td height="18" colspan="8" bgcolor="#DCDCDC" class="tableborder1">财务信息</td>
       	 </tr>
         <tr>
           <td width="1" bgcolor="#DCDCDC">资产负债表</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <tr>
                 <td width="12%" rowspan="2" valign="top" class="underlinetd">项目</td>
               <%
               	if(!sReportDate.equals(""))
               	{
               %>
                 <td colspan="2" valign="top" class="underlinetd"><%=sReportDate.substring(0,4)%>年<%=sReportDate.substring(5,7)%>月</td>
                <%
                }
                else
                {
                %>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;年&nbsp;月</td>	
                <%
                }
                %>
                 <td colspan="2" valign="top" class="underlinetd">上月</td>
                 <td colspan="2" valign="top" class="underlinetd">年初</td>
                 <td colspan="2" valign="top" class="underlinetd">去年同期</td>
                 </tr>
               <tr>
                 <td width="11%" class="underlinetd">数值</td>
                 <td width="12%" class="underlinetd">占比(%)</td>
                 <td width="10%" class="underlinetd">数值</td>
                 <td width="10%" class="underlinetd">占比(%)</td>
                 <td width="9%" class="underlinetd">数值</td>
                 <td width="10%" class="underlinetd">占比(%)</td>
                 <td width="11%" class="underlinetd">数值</td>
                 <td width="15%" class="underlinetd">占比(%)</td>
               </tr>
			   <tr>
                 <td class="underlinetd">总资产</td>
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
                 <td class="underlinetd">流动资产</td>
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
                 <td class="underlinetd">货币资金</td>
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
                 <td class="underlinetd">应收帐款淨额</td>
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
                 <td class="underlinetd">其他应收款</td>
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
                 <td class="underlinetd">存货</td>
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
                 <td class="underlinetd">长期投资淨额</td>
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
                 <td class="underlinetd">固定资产净值</td>
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
                 <td class="underlinetd">无形资产淨额</td>
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
                 <td class="underlinetd">流动负债</td>
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
                 <td class="underlinetd">短期借款及一年内到期的长期负债</td>
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
                 <td class="underlinetd">应付票据</td>
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
                 <td class="underlinetd">应付帐款</td>
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
                 <td class="underlinetd">长期负债合计</td>
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
                 <td class="underlinetd">所有者权益</td>
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
                 <td class="underlinetd">实收资本</td>
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
           <td width="1" bgcolor="#DCDCDC">损益表</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               	if(!sSYMonth.equals(""))
               	{
               %>
               <tr>
                 <td width="10%" rowspan="2" valign="top" class="underlinetd">项目</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYMonth.substring(0,4)%>年<%=sSYMonth.substring(5,7)%>月</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYYear1.substring(0,4)%>年</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYYear2.substring(0,4)%>年</td>
                 <td colspan="2" valign="top" class="underlinetd"><%=sSYYear3.substring(0,4)%>年</td>
                 </tr>
               <tr>
               <%
               	}
               	else
               	{
               %>
               <tr>
                 <td width="10%" rowspan="2" valign="top" class="underlinetd">项目</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;年&nbsp;月</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;年</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;年</td>
                 <td colspan="2" valign="top" class="underlinetd">&nbsp;年</td>
               </tr>
              <% 
              	}
              %>
               <tr>
                 <td width="17%" class="underlinetd">数值</td>
                 <td width="13%" class="underlinetd">占比(%)</td>
                 <td width="7%" class="underlinetd">数值</td>
                 <td width="13%" class="underlinetd">占比(%)</td>
                 <td width="7%" class="underlinetd">数值</td>
                 <td width="13%" class="underlinetd">占比(%)</td>
                 <td width="7%" class="underlinetd">数值</td>
                 <td width="13%" class="underlinetd">占比(%)</td>
               </tr>
			   <tr>
                 <td class="underlinetd">主营业务收入</td>
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
                 <td class="underlinetd">主营业务成本</td>
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
                 <td class="underlinetd">主营业务利润</td>
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
                 <td class="underlinetd">营业费用</td>
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
                 <td class="underlinetd">管理费用</td>
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
                 <td class="underlinetd">财务费用</td>
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
                 <td class="underlinetd">营业利润</td>
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
                 <td class="underlinetd">利润总额</td>
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
                 <td class="underlinetd">净利润</td>
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
           <td width="1" bgcolor="#DCDCDC">现金流量表</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sXJMonth.equals(""))
               {
               %>
               <tr>
                 <td width="15%" rowspan="2" valign="top" class="underlinetd">项目</td>
                 <td width="22%" valign="top" class="underlinetd"><%=sXJMonth.substring(0,4)%>年<%=sXJMonth.substring(5,7)%>月</td>
                 <td width="22%" valign="top" class="underlinetd"><%=sXJYear1.substring(0,4)%>年</td>
                 <td width="29%" valign="top" class="underlinetd"><%=sXJYear2.substring(0,4)%>年</td>
                 <td width="12%" valign="top" class="underlinetd"><%=sXJYear3.substring(0,4)%>年</td>
                 </tr>
                 <%
                 }
                 else
                 {	
                 %>
               <tr>
                 <td width="15%" rowspan="2" valign="top" class="underlinetd">项目</td>
                 <td width="22%" valign="top" class="underlinetd">&nbsp;年&nbsp;月</td>
                 <td width="22%" valign="top" class="underlinetd">&nbsp;年</td>
                 <td width="29%" valign="top" class="underlinetd">&nbsp;年</td>
                 <td width="12%" valign="top" class="underlinetd">&nbsp;年</td>
                </tr>                 
                 <%
                 	}
                 %>
               <tr>
                 <td class="underlinetd">数值</td>
                 <td class="underlinetd">数值</td>
                 <td class="underlinetd">数值</td>
                 <td class="underlinetd">数值</td>
                 </tr>
			   <tr>
                 <td class="underlinetd">经营活动现金流入量</td>
                 <td class="underlinetd"><%=sXJValue1[0]%></td>
                 <td class="underlinetd"><%=sXJValue2[0]%></td>
                 <td class="underlinetd"><%=sXJValue3[0]%></td>
                 <td class="underlinetd"><%=sXJValue4[0]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">经营活动现金流出量</td>
                 <td class="underlinetd"><%=sXJValue1[1]%></td>
                 <td class="underlinetd"><%=sXJValue2[1]%></td>
                 <td class="underlinetd"><%=sXJValue3[1]%></td>
                 <td class="underlinetd"><%=sXJValue4[1]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">经营活动现金流净额</td>
                 <td class="underlinetd"><%=sXJValue1[2]%></td>
                 <td class="underlinetd"><%=sXJValue2[2]%></td>
                 <td class="underlinetd"><%=sXJValue3[2]%></td>
                 <td class="underlinetd"><%=sXJValue4[2]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">投资活动现金流净额</td>
                 <td class="underlinetd"><%=sXJValue1[3]%></td>
                 <td class="underlinetd"><%=sXJValue2[3]%></td>
                 <td class="underlinetd"><%=sXJValue3[3]%></td>
                 <td class="underlinetd"><%=sXJValue4[3]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">筹资活动现金流净额</td>
                 <td class="underlinetd"><%=sXJValue1[4]%></td>
                 <td class="underlinetd"><%=sXJValue2[4]%></td>
                 <td class="underlinetd"><%=sXJValue3[4]%></td>
                 <td class="underlinetd"><%=sXJValue4[4]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">净现金流量</td>
                 <td class="underlinetd"><%=sXJValue1[5]%></td>
                 <td class="underlinetd"><%=sXJValue2[5]%></td>
                 <td class="underlinetd"><%=sXJValue3[5]%></td>
                 <td class="underlinetd"><%=sXJValue4[5]%></td>
                 </tr>			  			   
           </table></td>		   
         </tr>
		 <tr>
           <td width="1" bgcolor="#DCDCDC">偿债能力</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sCZMonth1.equals(""))
               {
               %>
               <tr>
                 <td width="23%" valign="top" class="underlinetd">项目</td>
                 <td width="20%" valign="top" class="underlinetd"><%=sCZMonth1.substring(0,4)%>年<%=sCZMonth1.substring(5,7)%>月</td>
                 <td width="18%" valign="top" class="underlinetd">上年度</td>
                 <td width="23%" valign="top" class="underlinetd">&nbsp;前年度</td>
                 <td width="16%" valign="top" class="underlinetd">&nbsp;去年同期</td>
               </tr>
                 <%
                 }
                 else
                 {	
                 %>
               <tr>
                 <td width="23%" valign="top" class="underlinetd">项目</td>
                 <td width="20%" valign="top" class="underlinetd"> &nbsp;年&nbsp;月</td>
                 <td width="18%" valign="top" class="underlinetd">上年度</td>
                 <td width="23%" valign="top" class="underlinetd">&nbsp;前年度</td>
                 <td width="16%" valign="top" class="underlinetd">&nbsp;去年同期</td>
               </tr> 
                 <%
                 	}
                 %>                                 
               <tr>
                 <td valign="top" class="underlinetd">息税前利润利息保障倍数</td>
                 <td class="underlinetd"><%=sCZValue1[0]%></td>
                 <td class="underlinetd"><%=sCZValue2[0]%></td>
                 <td class="underlinetd"><%=sCZValue3[0]%></td>
                 <td class="underlinetd"><%=sCZValue4[0]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">流动比率 (%)</td>
                 <td class="underlinetd"><%=sCZValue1[1]%></td>
                 <td class="underlinetd"><%=sCZValue2[1]%></td>
                 <td class="underlinetd"><%=sCZValue3[1]%></td>
                 <td class="underlinetd"><%=sCZValue4[1]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">速动比率 (%)</td>
                 <td class="underlinetd"><%=sCZValue1[2]%></td>
                 <td class="underlinetd"><%=sCZValue2[2]%></td>
                 <td class="underlinetd"><%=sCZValue3[2]%></td>
                 <td class="underlinetd"><%=sCZValue4[2]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">资产负债率 (%)</td>
                 <td class="underlinetd"><%=sCZValue1[3]%></td>
                 <td class="underlinetd"><%=sCZValue2[3]%></td>
                 <td class="underlinetd"><%=sCZValue3[3]%></td>
                 <td class="underlinetd"><%=sCZValue4[3]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">经营活动产生的净现金流量/总债务</td>
                 <td class="underlinetd"><%=sCZValue1[4]%></td>
                 <td class="underlinetd"><%=sCZValue2[4]%></td>
                 <td class="underlinetd"><%=sCZValue3[4]%></td>
                 <td class="underlinetd"><%=sCZValue4[4]%></td>
                 </tr>		  			   
           </table></td>		   
         </tr>
		 <tr>
           <td width="1" bgcolor="#DCDCDC">盈利能力</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sCZMonth1.equals(""))
               {
               %>
               <tr>
                 <td valign="top" class="underlinetd">项目</td>
                 <td valign="top" class="underlinetd"> <%=sCZMonth1.substring(0,4)%>年<%=sCZMonth1.substring(5,7)%>月</td>
                 <td valign="top" class="underlinetd">上年度</td>
                 <td valign="top" class="underlinetd">&nbsp;前年度</td>
                 <td valign="top" class="underlinetd">&nbsp;去年同期</td>
                 </tr>
                 <%
                 }
                 else
                 {	
                 %>
               <tr>
                 <td valign="top" class="underlinetd">项目</td>
                 <td valign="top" class="underlinetd"> &nbsp;年&nbsp;月</td>
                 <td valign="top" class="underlinetd">上年度</td>
                 <td valign="top" class="underlinetd">&nbsp;前年度</td>
                 <td valign="top" class="underlinetd">&nbsp;去年同期</td>
                 </tr>
                 <%
                 }
                 %>                                                    
               <tr>
                 <td valign="top" class="underlinetd">销售收入</td>
                 <td class="underlinetd"><%=sYLValue1[0]%></td>
                 <td class="underlinetd"><%=sYLValue2[0]%></td>
                 <td class="underlinetd"><%=sYLValue3[0]%></td>
                 <td class="underlinetd"><%=sYLValue4[0]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">营业利润</td>
                 <td class="underlinetd"><%=sYLValue1[1]%></td>
                 <td class="underlinetd"><%=sYLValue2[1]%></td>
                 <td class="underlinetd"><%=sYLValue3[1]%></td>
                 <td class="underlinetd"><%=sYLValue4[1]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">销售利润</td>
                 <td class="underlinetd"><%=sYLValue1[2]%></td>
                 <td class="underlinetd"><%=sYLValue2[2]%></td>
                 <td class="underlinetd"><%=sYLValue3[2]%></td>
                 <td class="underlinetd"><%=sYLValue4[2]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">投资收益</td>
                 <td class="underlinetd"><%=sYLValue1[3]%></td>
                 <td class="underlinetd"><%=sYLValue2[3]%></td>
                 <td class="underlinetd"><%=sYLValue3[3]%></td>
                 <td class="underlinetd"><%=sYLValue4[3]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">净利润</td>
                 <td class="underlinetd"><%=sYLValue1[4]%></td>
                 <td class="underlinetd"><%=sYLValue2[4]%></td>
                 <td class="underlinetd"><%=sYLValue3[4]%></td>
                 <td class="underlinetd"><%=sYLValue4[4]%></td>
                 </tr>	
				<tr>
                 <td class="underlinetd">销售利润率(%)</td>
                 <td class="underlinetd"><%=sCZValue1[5]%></td>
                 <td class="underlinetd"><%=sCZValue2[5]%></td>
                 <td class="underlinetd"><%=sCZValue3[5]%></td>
                 <td class="underlinetd"><%=sCZValue4[5]%></td>
                 </tr>
				<tr>
                 <td class="underlinetd">总资产利润率(%)</td>
                 <td class="underlinetd"><%=sCZValue1[6]%></td>
                 <td class="underlinetd"><%=sCZValue2[6]%></td>
                 <td class="underlinetd"><%=sCZValue3[6]%></td>
                 <td class="underlinetd"><%=sCZValue4[6]%></td>
                 </tr>
				<tr>
                 <td class="underlinetd">净资产利润率(%)</td>
                 <td class="underlinetd"><%=sCZValue1[7]%></td>
                 <td class="underlinetd"><%=sCZValue2[7]%></td>
                 <td class="underlinetd"><%=sCZValue3[7]%></td>
                 <td class="underlinetd"><%=sCZValue4[7]%></td>
                 </tr>  			   
           </table></td>		   
         </tr>
		 <tr>
           <td width="1" bgcolor="#DCDCDC">营运能力</td>
           <td><table width="100%" border="0" cellpadding="2" cellspacing="0">
               <%
               if(!sCZMonth1.equals(""))
               {
               %>
               <tr>
                 <td valign="top" class="underlinetd">项目</td>
                 <td valign="top" class="underlinetd">  <%=sCZMonth1.substring(0,4)%>年<%=sCZMonth1.substring(5,7)%>月</td>
                 <td valign="top" class="underlinetd">上年度</td>
                 <td valign="top" class="underlinetd">&nbsp;前年度</td>
                 <td valign="top" class="underlinetd">&nbsp;去年同期</td>
                 </tr>
                 <%
                 }
                 else
                 {	
                 %> 
               <tr>
                 <td valign="top" class="underlinetd">项目</td>
                 <td valign="top" class="underlinetd"> &nbsp;年&nbsp;月</td>
                 <td valign="top" class="underlinetd">上年度</td>
                 <td valign="top" class="underlinetd">&nbsp;前年度</td>
                 <td valign="top" class="underlinetd">&nbsp;去年同期</td>
                 </tr>
                 <%
                 }
                 %>                                                    
               <tr>
                 <td valign="top" class="underlinetd">应收帐款周转天数</td>
                 <td class="underlinetd"><%=sCZValue1[8]%></td>
                 <td class="underlinetd"><%=sCZValue2[8]%></td>
                 <td class="underlinetd"><%=sCZValue3[8]%></td>
                 <td class="underlinetd"><%=sCZValue4[8]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">存货周转天数</td>
                 <td class="underlinetd"><%=sCZValue1[9]%></td>
                 <td class="underlinetd"><%=sCZValue2[9]%></td>
                 <td class="underlinetd"><%=sCZValue3[9]%></td>
                 <td class="underlinetd"><%=sCZValue4[9]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">总资产周转率</td>
                 <td class="underlinetd"><%=sCZValue1[10]%></td>
                 <td class="underlinetd"><%=sCZValue2[10]%></td>
                 <td class="underlinetd"><%=sCZValue3[10]%></td>
                 <td class="underlinetd"><%=sCZValue4[10]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">流动资产周转率</td>
                 <td class="underlinetd"><%=sCZValue1[11]%></td>
                 <td class="underlinetd"><%=sCZValue2[11]%></td>
                 <td class="underlinetd"><%=sCZValue3[11]%></td>
                 <td class="underlinetd"><%=sCZValue4[11]%></td>
                 </tr>
			   <tr>
                 <td class="underlinetd">固定资产周转率</td>
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
       <td height="18" colspan="9" bgcolor="#DCDCDC" class="tableborder1">在我行授信申请信息(在途)</td>
       </tr>
	  <tr>
       <td height="18" colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td valign="top" class="underlinetd">业务品种</td>
           <td valign="top" class="underlinetd">发生类型</td>
           <td valign="top" class="underlinetd">币种</td>
           <td valign="top" class="underlinetd">申请金额</td>
           <td valign="top" class="underlinetd">申请日期</td>
           <td valign="top" class="underlinetd">期限(月)</td>
           <td valign="top" class="underlinetd">零(天)</td>
           <td valign="top" class="underlinetd">主要担保方式</td>
           <td valign="top" class="underlinetd">经办机构</td>
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
       <td width="2%" rowspan="5" bgcolor="#DCDCDC" class="tableborder1">授信额度信息</td>
       <td width="14%" height="18" class="underlinetd">授信币种</td>
       <td height="18" class="underlinetd"><%=rs6.getString("BusinessCurrency")%></td>
       <td height="18" class="underlinetd">授信总金额</td>
       <td height="18" class="underlinetd"><%=DataConvert.toMoney(rs6.getDouble("BusinessSum"))%></td>
       <td height="18" class="underlinetd">授信起始日</td>
       <td height="18" class="underlinetd"><%=rs6.getString("PutoutDate")%></td>
       <td height="18" class="underlinetd">授信到期日</td>
       <td height="18" class="underlinetd"><%=rs6.getString("Maturity")%></td>
	 </tr>
	   <tr>
       <td height="18" class="underlinetd">额度使用最迟日期</td>
       <td height="18" class="underlinetd"><%=rs6.getString("LimitationTerm")%></td>
       <td height="18" class="underlinetd">额度项下业务最迟到期日期</td>
       <td height="18" class="underlinetd"><%=rs6.getString("UseTerm")%></td>
       <td height="18" class="underlinetd">占用金额</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">占用比例(%)</td>
       <td height="18" class="underlinetd">&nbsp;</td>
	   </tr>
	   <%
	   	}
	   	else
	   	{
	   %>
	  <tr>
       <td width="2%" rowspan="5" bgcolor="#DCDCDC" class="tableborder1">授信额度信息</td>
       <td width="14%" height="18" class="underlinetd">授信币种</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">授信总金额</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">授信起始日</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">授信到期日</td>
       <td height="18" class="underlinetd">&nbsp;</td>
	 </tr>
	   <tr>
       <td height="18" class="underlinetd">额度使用最迟日期</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">额度项下业务最迟到期日期</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">占用金额</td>
       <td height="18" class="underlinetd">&nbsp;</td>
       <td height="18" class="underlinetd">占用比例(%)</td>
       <td height="18" class="underlinetd">&nbsp;</td>
      </tr>
      <%
      	}
      	rs6.getStatement().close();
      %> 
      
      
	   <tr>
       <td height="18" colspan="8" bgcolor="#DCDCDC" class="tableborder1">授信方案明细信息</td>
       </tr>
	   <tr>
       <td height="18" class="underlinetd">授信品种</td>
       <td height="18" class="underlinetd">授信币种</td>
       <td height="18" class="underlinetd">授信限额</td>
       <td height="18" class="underlinetd">敞口限额</td>
       <td height="18" class="underlinetd">最低保证金比率</td>
       <td height="18" class="underlinetd">是否循环</td>
       <td height="18" class="underlinetd">占用金额</td>
       <td height="18" class="underlinetd">占用比例(%)</td>
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
       <td height="18" colspan="9" bgcolor="#DCDCDC" class="tableborder1">在我行未结清授信业务信息</td>
       </tr>
     <tr>
       <td colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">

         <tr>
           <td class="underlinetd">授信业务品种</td>
           <td class="underlinetd">发生类型</td>
           <td class="underlinetd">主要担保方式</td>
           <td class="underlinetd">金额</td>
           <td class="underlinetd">币种</td>
           <td class="underlinetd">利率</td>
           <td class="underlinetd">发放日</td>
           <td class="underlinetd">到期日</td>
           <td class="underlinetd">五级分类</td>
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
           <td width="2%" rowspan="5" valign="top" bgcolor="#DCDCDC" class="tableborder1">授信业务质量状况</td>
           <td width="10%" rowspan="2" valign="top" class="underlinetd">四级分类贷款</td>
           <td width="9%" valign="top" class="underlinetd">正常类余额</td>
           <td width="10%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("NormalBalance"))%></td>
           <td width="9%" valign="top" class="underlinetd">比年初增减</td>
           <td width="11%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("NormalBalance1"))%></td>
           <td width="9%" valign="top" class="underlinetd">逾期类余额</td>
           <td width="11%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("OverDueBalance"))%></td>
           <td width="9%" valign="top" class="underlinetd">比年初增减</td>
           <td width="20%" valign="top" class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("OverDueBalance1"))%></td>
         </tr>
         <tr>
           <td class="underlinetd">呆滞类余额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("DullBalance"))%></td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("DullBalance1"))%></td>
           <td class="underlinetd">呆账类余额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("BadBalance"))%></td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs9.getDouble("BadBalance1"))%></td>
         </tr>
		<%
			}
			else
			{
		%>
         <tr>
           <td width="2%" rowspan="5" valign="top" bgcolor="#DCDCDC" class="tableborder1">授信业务质量状况</td>
           <td width="10%" rowspan="2" valign="top" class="underlinetd">四级分类贷款</td>
           <td width="9%" valign="top" class="underlinetd">正常类余额</td>
           <td width="10%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="9%" valign="top" class="underlinetd">比年初增减</td>
           <td width="11%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="9%" valign="top" class="underlinetd">逾期类余额</td>
           <td width="11%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="9%" valign="top" class="underlinetd">比年初增减</td>
           <td width="20%" valign="top" class="underlinetd">&nbsp;</td>
         </tr>
         <tr>
           <td class="underlinetd">呆滞类余额</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">呆账类余额</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd">&nbsp;</td>
         </tr>
         <%
         }
         rs9.getStatement().close();
         if(rs10.next())
         {
         %>		
		  <tr>
           <td rowspan="3" class="underlinetd">五级分类贷款</td>
           <td class="underlinetd">正常类余额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum1"))%></td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum11"))%></td>
           <td class="underlinetd">关注类余额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum2"))%></td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum22"))%></td>
		  </tr>
		  <tr>
           <td class="underlinetd">次级类余额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum3"))%></td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum33"))%></td>
           <td class="underlinetd">可疑类余额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum4"))%></td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum44"))%></td>
         </tr>
		  <tr>
           <td class="underlinetd">损失类余额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(rs10.getDouble("ClassifySum5"))%></td>
           <td class="underlinetd">比年初增减</td>
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
           <td rowspan="3" class="underlinetd">五级分类贷款</td>
           <td class="underlinetd">正常类余额</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">关注类余额</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd">&nbsp;</td>
		  </tr>
		  <tr>
           <td class="underlinetd">次级类余额</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">可疑类余额</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">比年初增减</td>
           <td class="underlinetd">&nbsp;</td>
         </tr>
		  <tr>
           <td class="underlinetd">损失类余额</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">比年初增减</td>
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
           <td width="2%" rowspan="5" valign="top" bgcolor="#DCDCDC" class="tableborder1">年内到期情况</td>
           <td colspan="2" valign="top" class="underlinetd">本年到期业务</td>
           <td width="7%" rowspan="5" valign="top" class="underlinetd">其中</td>
           <td width="10%" valign="top" class="underlinetd">&nbsp;</td>
           <td width="7%" valign="top" class="underlinetd">贷款</td>
           <td width="14%" valign="top" class="underlinetd">承兑汇票</td>
           <td width="20%" valign="top" class="underlinetd">信用证</td>
         </tr>
         <tr>
           <td width="11%" class="underlinetd">贷款总额</td>
           <td width="29%" class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[0])%></td>
           <td class="underlinetd">一季度</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[1])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[1])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[1])%></td>
         </tr>
		 <tr>
           <td class="underlinetd">承兑汇票总额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[0])%></td>
           <td class="underlinetd">二季度</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[2])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[2])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[2])%></td>
         </tr>
		 <tr>
           <td class="underlinetd">信用证总额</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[0])%></td>
           <td class="underlinetd">三季度</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[3])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[3])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[3])%></td>
         </tr>
		 <tr>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">&nbsp;</td>
           <td class="underlinetd">四季度</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dLoanBalance[4])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBillBalance[4])%></td>
           <td class="underlinetd"><%=DataConvert.toMoney(dCardBalance[4])%></td>
         </tr>
       </table></td>
       </tr>
	  <tr>
       <td height="18" colspan="9" class="underlinetd"><table width="100%" border="0" cellpadding="2" cellspacing="0">
         <tr>
           <td width="2%" rowspan="2" valign="top" bgcolor="#DCDCDC" class="tableborder1">履约情况</td>
           <td width="14%" rowspan="2" valign="top" class="underlinetd">本年已到期贷款总额</td>
           <td width="12%" rowspan="2" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[0])%></td>
           <td width="14%" valign="top" class="underlinetd">正常收回</td>
           <td width="2%" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[1])%></td>
           <td width="25%" valign="top" class="underlinetd">展期</td>
           <td width="2%" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[2])%></td>
           <td width="27%" valign="top" class="underlinetd">还旧借新</td>
           <td width="2%" valign="top" class="underlinetd"><%=DataConvert.toMoney(dBalance[3])%></td>
         </tr>
         <tr>
           <td class="underlinetd">借新换旧</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBalance[4])%></td>
           <td class="underlinetd">不良(逾期、呆滞、呆帐)</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBalance[5])%></td>
           <td class="underlinetd">不良（次级、可疑、损失）</td>
           <td class="underlinetd"><%=DataConvert.toMoney(dBalance[6])%></td>
         </tr>
       </table></td>
       </tr>
   </table></td>
  </tr>
</table>
</body>
</html>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

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
