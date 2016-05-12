<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@page import="com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		现金贷款申请表 
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
String sCustomerID = "";//客户编号
String sBusinessType = "";//产品编号
String sPurpose="";//贷款用途
String sCustomerName = "";//客户名称
String sCertID = "";//证件号码
String sBusinessSum = "";//贷款金额
String sEndTime = "";//审核时间
String sMonthRepayMent = "";//每月还款额
String sTotalSum="";//自付总金额
String sPeriods="";//期数
String sRepaymentNo="";//还款账号
String sRepaymentBank="";//还款银行
String sRepaymentName="";//还款户名
String sInputUserID="";//销售顾问代码
String sMobileNum="";//销售顾问联系方式
String sStores="";//销售点代码
String sInteriorCode = "";//内部代码
String sTotalPrice = "";//商品总价（元）
String sStoresName = "";//销售点名称
String sApplyType="";//申请类型
String sSubProductType="";//产品子类型 
String sApplyNum="";//申请次数
String sAddress="";//门店地址
String sSex="";//性别
String sIssueinstitution="";//发证机关
String sMaturityDate="";//身份证有效期
String sSino="";//社保号码
String sEduExperience="";//教育程度
String sFamilyTel="";//住宅、宿舍电话
String sPhoneMan="";//住宅电话登记人
String sMobileTelephone="";//手机
String sEmailAdd="";//电子邮箱
String sQQNo="";//QQ号
String sMarriage="";//婚姻状况
int sChildrentotal=0;//子女数目
String sHouse="";//住房状况
String sNativeplace="";//户籍地址
String sVillagetown="";//镇、乡
String sStreet="";//街道、村
String sCommunity="";//小区、楼盘
String sCellNo="";//栋、单元、房间号
String sFamilyAdd="";//现居住地址
String sCountryside="";//镇、乡
String sVillagecenter="";//街道、村
String sPlot="",sRoom="",sFlag2="",sCreditRate="";
String repaymentWay="";
String sCUSTOMERSERVICERATES="",sMANAGEMENTFEESRATE="",sPdgRatio="",sSTAMPTAX="",sUnitStreet="",sMONTHADDSERVICERATE="";
String sReplaceAccount ="";//客户银行账号
String sOpenBranch="",sInputDate="",sBusinessType1="",sBrandType1="",sPrice1="",sBusinessType2="",sBrandType2="",sPrice2="",sBusinessType3="",sBrandType3="",sPrice3="",sFlag8="",sManufacturer1="",sManufacturer2="",sManufacturer3="";//客户开户行
String sReplaceName="",sWorkCorp="",sEmployRecord="",sCommAdd="",sJobTotal="",sJobTime="",sFlag4="";
String sHeadShip="",sIndustryType="",sCellProperty="",sWorkTel="", sWorkAdd="",sUnitCountryside="",sUnitRoom="",sUnitNo="";
String sSpouseName="",sSpouseTel="",sSpouseWorkCorp="",sSpouseWorkTel="",sKinshipName="",sRelativeType="",sKinshipTel="",sKinshipAdd="",sOtherContact="",sRelativeType1="";
String sContactTel="",sZE="",sOtherRevenue="",sFamilyMonthIncome="",sCE="", sCreditCycle="", sCreditFeeRate=""; 
//产品月利率、首次还款日、默认还款日、月还款额、贷款发放日
String sMONTHLYINTERESTRATE="",sMonthRepayment="",sPutOutDate="",sfalg6="";
String sUserName = "";
String dFirstIntrestAmt = "";
String sDfile = "";
String sDfile1 = "本人选择银行代扣还款，表明本人同意并授权贷款人可通过银行从本人指定的借款人银行账户（如第43项所示）将每月还款额（如第29项所示）及其它应还款项转入指定还款账户（如第40、41、42项所示）。本人同意此扣款授权同时适用于之前由深圳市佰仟金融服务有限公司提供服务并已签订的一份或多份贷款合同，即贷款人可通过银行从本人指定的上述银行账户内扣划本人在各合同下应偿还的相关款项。本人同意该账户同时可用于因提前还款等引起的资金往来。";

//在计算随心还服务包费时使用
String stypeno = "",sBusinessSum_ = "",sTerm="",bpp = "",sBugPayPkgind = "",bugPayPkgindFee="0.0";
%>
<%!
	public String getCityName(String str,String flag,Transaction Sqlca) throws Exception {
		String sReturn = str;
		if("省".equals(flag) && str.indexOf("省")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Nativeplace,1, instr(:Nativeplace,'省')) from dual").setParameter("Nativeplace", str));
		}else if("市".equals(flag) && str.indexOf("市")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Nativeplace, instr(:Nativeplace, '省')+1) from dual").setParameter("Nativeplace", str));
		}else if("市".equals(flag) && str.indexOf("州")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Nativeplace,1, instr(:Nativeplace,'省')) from dual").setParameter("Nativeplace", str));
		}else if("区".equals(flag) && str.indexOf("区")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown,1, instr(:Villagetown,'区')) from dual").setParameter("Villagetown", str));
		}else if("区".equals(flag) && str.indexOf("县")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown,1, instr(:Villagetown,'县')) from dual").setParameter("Villagetown", str));
		}else if("区".equals(flag) && str.indexOf("市")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown,1, instr(:Villagetown,'市')) from dual").setParameter("Villagetown", str));
		}else if("镇".equals(flag) && str.indexOf("区") != -1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown, instr(:Villagetown, '区')+1) from dual").setParameter("Villagetown", str));
		}else if("镇".equals(flag) && str.indexOf("县") != -1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown, instr(:Villagetown, '县')+1) from dual").setParameter("Villagetown", str));
		}else if("镇".equals(flag) && str.indexOf("市") != -1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown, instr(:Villagetown, '市')+1) from dual").setParameter("Villagetown", str));
		}
		
		if(null == sReturn) sReturn = "";
		return sReturn;
	}
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户sCustomerID化2;]~*/%>
<%
//获得调查报告数据
String sSql = "select bc.insurancesum as CreditFeeRate,bc.CreditCycle as CreditCycle,bc.BusinessType3 as BusinessType3,bc.BrandType3 as BrandType3,bc.Manufacturer3 as Manufacturer3,bc.Price3 as Price3,bc.FIRSTDRAWINGDATE as FIRSTDRAWINGDATE,bc.CustomerID,bc.CustomerName,bc.stores,bc.inputuserid,bc.inputdate,bc.BusinessType,getitemname('CashPurpose',bc.Purpose) as Purpose,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName, "+
				" bc.TotalPrice,bc.PdgRatio,bc.ReplaceAccount,getitemname('BankCode',bc.OpenBank) as OpenBank,bc.ReplaceName,"+
				" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,getitemname('BankCode',bc.RepaymentBank) as RepaymentBank,bc.RepaymentName, "+
				"(select typename from business_type where typeno = bc.BusinessType) as ApplyType1,getitemname('SubProductType',bc.SubProductType) as SubProductType,getitemname('BusinessType',bc.productid) as ApplyType,"+
				" PutOutDate,PERIODS,REPAYMENTWAY,getitemname('YesNo',falg6) as falg6, "+
				" bc.BrandType1,bc.Price1,bc.BrandType2,bc.Price2,getTypeName(bc.BusinessRange1,bc.BusinessType1) as BusinessType1,getTypeName(bc.BusinessRange2,bc.BusinessType2) as BusinessType2,bc.Manufacturer1,bc.Manufacturer2, "+
				" getusername(bc.Inputuserid) as UserName, SUBMITDATETIME as SUBMITDATETIME " + 
				",bc.BugPayPkgind as bpp,getItemName('BugPayPkgind',bc.BugPayPkgind) as BugPayPkgind from Business_Contract bc where SerialNo = '"+sObjectNo+"'";

ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		bpp = rs2.getString("bpp");//是否购买随心还服务包
		if(bpp==null) bpp = "";
		sBugPayPkgind = rs2.getString("BugPayPkgind");//是否购买随心还服务包
		if(sBugPayPkgind==null || "".equals(sBugPayPkgind)) sBugPayPkgind = "未选择";
		//在计算随心还服务包费时使用
		stypeno = rs2.getString("BusinessType");
		sBusinessSum_ = rs2.getString("BusinessSum");
		sTerm = rs2.getString("PERIODS");
		if(stypeno == null)stypeno="";
		if(sBusinessSum_ == null)sBusinessSum_="";
		if(sTerm == null)sTerm="";
		
		sCreditFeeRate = DataConvert.toMoney(rs2.getString("CreditFeeRate"));
		sCreditCycle = rs2.getString("CreditCycle");
		dFirstIntrestAmt = DataConvert.toMoney(rs2.getString("FIRSTDRAWINGDATE"));
		sCustomerID = rs2.getString("CustomerID");
		sCustomerName = rs2.getString("CustomerName");
		sBusinessType = rs2.getString("BusinessType");
		sPurpose = rs2.getString("Purpose");
		sBusinessSum = DataConvert.toMoney(rs2.getString("BusinessSum"));
		sInteriorCode = rs2.getString("InteriorCode");
		sTotalPrice = DataConvert.toMoney(rs2.getString("TotalPrice"));
		sStoresName = rs2.getString("StoresName");
		sPdgRatio = rs2.getString("PdgRatio");
		sApplyType = rs2.getString("ApplyType");//申请类别  
		sSubProductType= rs2.getString("SubProductType");//产品子类型 
		sTotalSum=DataConvert.toMoney(rs2.getString("TotalSum"));
		sMonthRepayMent=DataConvert.toMoney(rs2.getString("MonthRepayMent"));
		sRepaymentNo=rs2.getString("RepaymentNo");
		sRepaymentBank=rs2.getString("RepaymentBank");
		sRepaymentName=rs2.getString("RepaymentName");
		sInputUserID=rs2.getString("InputUserID");
		sMobileNum = Sqlca.getString(new SqlObject("select mobiletel from user_info where userid = :UserID").setParameter("UserID",sInputUserID));
		sUserName = rs2.getString("UserName");
		sStores=rs2.getString("Stores");
		
		sOpenBranch=rs2.getString("OpenBank");
		sReplaceName=rs2.getString("ReplaceName");
		sReplaceAccount=rs2.getString("ReplaceAccount");
		sMonthRepayment=rs2.getString("MonthRepayment");
		sPutOutDate=rs2.getString("PutOutDate");
		sPeriods=rs2.getString("PERIODS");
		repaymentWay=rs2.getString("REPAYMENTWAY");
		sfalg6= rs2.getString("falg6");
		
		//sInputDate= Sqlca.getString(new SqlObject("SELECT OBJATTRIBUTE1 FROM FLOW_OBJECT WHERE OBJECTNO=:OBJECTNO").setParameter("OBJECTNO", sObjectNo));
		sInputDate = Sqlca.getString(new SqlObject("select salesubmittime from business_contract where SERIALNO =:OBJECTNO").setParameter("OBJECTNO", sObjectNo));
		sBusinessType1= rs2.getString("BusinessType1");
		sBrandType1= rs2.getString("BrandType1");
		sPrice1= rs2.getString("Price1");
		sBusinessType2= rs2.getString("BusinessType2");
		sBrandType2= rs2.getString("BrandType2");
		sPrice2= rs2.getString("Price2");
		sManufacturer1= rs2.getString("Manufacturer1");
		sManufacturer2= rs2.getString("Manufacturer2");
		sBusinessType3= rs2.getString("BusinessType3");
		sBrandType3= rs2.getString("BrandType3");
		sPrice3= rs2.getString("Price3");
		sManufacturer3= rs2.getString("Manufacturer3");
		
		if(sCreditCycle == null) sCreditCycle ="&nbsp;";
		if(sCustomerID == null) sCustomerID ="&nbsp;";
		if(sCustomerName == null) sCustomerName ="&nbsp;";
		if(sBusinessType == null) sBusinessType ="&nbsp;";
		if(sPurpose == null) sPurpose = "&nbsp;";
		if(sBusinessSum == null) sBusinessSum ="&nbsp;";
		if(sInteriorCode == null) sInteriorCode ="&nbsp;";
		if(sStoresName == null) sStoresName ="&nbsp;";
		if(sTotalSum == null) sTotalSum ="&nbsp;";
		if(sMonthRepayMent == null) sMonthRepayMent ="&nbsp;";
		if(sRepaymentNo == null) sRepaymentNo ="&nbsp;";
		if(sRepaymentBank == null) sRepaymentBank ="&nbsp;";
		if(sRepaymentName == null) sRepaymentName ="&nbsp;";
		if(sTotalPrice == null) sTotalPrice ="&nbsp;";
		if(sInputUserID == null) sInputUserID ="&nbsp;";
		if(sMobileNum == null) sMobileNum = "&nbsp";
		if(sStores == null) sStores ="&nbsp;";
		if(sReplaceName == null) sReplaceName ="&nbsp;";
		if(sOpenBranch == null) sOpenBranch ="&nbsp;";
		if(sApplyType == null) sApplyType ="&nbsp;";
		if(sSubProductType == null) sSubProductType ="&nbsp;";//产品子类型 
		if(sReplaceAccount == null) sReplaceAccount ="&nbsp;";
		if(sPdgRatio == null) sPdgRatio ="&nbsp;";
		if(sMonthRepayment == null) sMonthRepayment ="&nbsp;";
		if(sPutOutDate == null) sPutOutDate ="&nbsp;";
		if(sPeriods == null) sPeriods ="&nbsp;";
		if(sfalg6 == null) sfalg6 ="&nbsp;";
		if(sInputDate == null) sInputDate ="&nbsp;";
		
		if(sBusinessType1 == null) sBusinessType1 ="&nbsp;";
		if(sBrandType1 == null) sBrandType1 ="&nbsp;";
		if(sPrice1 == null) sPrice1 ="&nbsp;";
		if(sBusinessType2 == null) sBusinessType2 ="&nbsp;";
		if(sBrandType2 == null) sBrandType2 ="&nbsp;";
		if(sPrice2 == null) sPrice2 ="&nbsp;";
		if(sManufacturer1 == null) sManufacturer1 ="&nbsp;";
		if(sManufacturer2 == null) sManufacturer2 ="&nbsp;";
		if(sBusinessType3 == null) sBusinessType3 ="&nbsp;";
		if(sBrandType3 == null) sBrandType3 ="&nbsp;";
		if(sPrice3 == null) sPrice3 ="&nbsp;";
		if(sManufacturer3 == null) sManufacturer3 ="&nbsp;";

	}
	rs2.getStatement().close();
	
  	String sSql5="select ii.certID,ii.Issueinstitution,ii.MaturityDate,ii.sino,getitemname('EducationExperience',ii.EduExperience) as EduExperience,ii.FamilyTel,"
	           +"ii.PhoneMan,ii.MobileTelephone,ii.EmailAdd,ii.QQNo,getitemname('Marriage',ii.Marriage) as Marriage,ii.Childrentotal,getitemname('FamilyStatus',ii.House) as House,"
	           +"getitemname('AreaCode',ii.nativeplace) as Nativeplace,ii.Villagetown,ii.Street,ii.Community,ii.CellNo,getitemname('AreaCode',ii.FamilyAdd) as FamilyAdd,ii.Countryside,"
	           +"ii.Villagecenter,ii.Plot,ii.Room,ii.WorkCorp,ii.EmployRecord,getitemname('HeadShip',ii.HeadShip) as HeadShip,"
	           +"getitemname('UnitKind',ii.UnitKind) as IndustryType,getitemname('YesNo',ii.Flag2) as Flag2,getitemname('YesNo',ii.Falg4) as Flag4,ii.Flag8 as Flag8,"
	           +"getitemname('OrgAttribute',ii.CellProperty) as CellProperty,getItemName('Sex',ii.Sex) as sex,ii.WorkTel,getitemname('AreaCode',ii.WorkAdd) as WorkAdd,"
	           +"ii.UnitCountryside,ii.UnitStreet,ii.UnitRoom,ii.UnitNo,ii.CommAdd,getitemname('WorkExperence',ii.JobTotal) as JobTotal,getitemname('WorkExperence',ii.JobTime) as JobTime, "
	           +"ii.SpouseName,ii.SpouseTel,ii.SpouseWorkCorp,ii.SpouseWorkTel,ii.KinshipName,getItemname('FamilyRelativeAccount',ii.RelativeType) as RelativeType, "
	           +"ii.KinshipTel,ii.KinshipAdd,ii.OtherContact,getItemname('RelativeAccountOther',ii.Contactrelation) as RelativeType1,"
	           +"ii.ContactTel,ii.OtherRevenue+nvl(ii.SelfMonthIncome,0) as ZE,ii.OtherRevenue,ii.FamilyMonthIncome,"
	           +"nvl(ii.Alimony,0)+nvl(ii.Houserent,0) as CE from ind_info ii where CustomerID='"+sObjectNo.substring(0, 8)+"'";
	
	
	ASResultSet rs3 = Sqlca.getResultSet(sSql5);
	if(rs3.next()){
		sSex=rs3.getString("Sex");
		sCertID=rs3.getString("CertID");
		sIssueinstitution = rs3.getString("Issueinstitution");
		sMaturityDate = rs3.getString("MaturityDate");
		sSino = rs3.getString("Sino");
		sEduExperience = rs3.getString("EduExperience");
		sFamilyTel = rs3.getString("FamilyTel");
		sPhoneMan = rs3.getString("PhoneMan");
		sFlag2 = rs3.getString("Flag2");
		sFlag4 = rs3.getString("Flag4");
		sFlag8 = rs3.getString("Flag8");
		sMobileTelephone = rs3.getString("MobileTelephone");
		sEmailAdd = rs3.getString("EmailAdd");
		sQQNo = rs3.getString("QQNo");
		sMarriage = rs3.getString("Marriage");
		sChildrentotal = rs3.getInt("Childrentotal");  
		sHouse = rs3.getString("House");
		sNativeplace=rs3.getString("Nativeplace");
		sVillagetown=rs3.getString("Villagetown");
		sPlot = rs3.getString("Plot");
		sRoom = rs3.getString("Room");
		sWorkCorp = rs3.getString("WorkCorp");
		sEmployRecord= rs3.getString("EmployRecord");
		sHeadShip = rs3.getString("HeadShip");
		sIndustryType=rs3.getString("IndustryType");
		sCellProperty = rs3.getString("CellProperty");
		sWorkTel = rs3.getString("WorkTel");
		sWorkAdd = rs3.getString("WorkAdd");
		sUnitCountryside = rs3.getString("UnitCountryside");
		sUnitStreet = rs3.getString("UnitStreet");
		sUnitRoom = rs3.getString("UnitRoom");
		sUnitNo = rs3.getString("UnitNo");
		sCommAdd = rs3.getString("CommAdd");
		sJobTotal = rs3.getString("JobTotal");
		sJobTime = rs3.getString("JobTime");
		sSpouseName = rs3.getString("SpouseName");
		sSpouseTel = rs3.getString("SpouseTel");
		sSpouseWorkCorp = rs3.getString("SpouseWorkCorp");
		sSpouseWorkTel = rs3.getString("SpouseWorkTel");
		sKinshipName= rs3.getString("KinshipName");
		sRelativeType= rs3.getString("RelativeType");
		sKinshipTel = rs3.getString("KinshipTel");
		sKinshipAdd = rs3.getString("KinshipAdd");
		sOtherContact = rs3.getString("OtherContact");
		sRelativeType1 = rs3.getString("RelativeType1");
		sContactTel = rs3.getString("ContactTel");
		sZE =DataConvert.toMoney(rs3.getDouble("ZE"));
		sOtherRevenue=DataConvert.toMoney(rs3.getDouble("OtherRevenue"));
		sFamilyMonthIncome = DataConvert.toMoney(rs3.getDouble("FamilyMonthIncome"));
		sCE = DataConvert.toMoney(rs3.getDouble("CE"));
		sStreet = rs3.getString("Street");
		sCommunity = rs3.getString("Community");
		sCellNo = rs3.getString("CellNo");
		sFamilyAdd = rs3.getString("FamilyAdd");
		sCountryside = rs3.getString("Countryside");
		sVillagecenter = rs3.getString("Villagecenter");
		
		if(sSex == null) sSex ="&nbsp;";
		if(sFlag2 == null) sFlag2 ="&nbsp;";
		if(sFlag4 == null) sFlag4 ="&nbsp;";
		if(sFlag8 == null) sFlag8 ="&nbsp;";
		if(sCertID == null) sCertID ="&nbsp;";
		if(sIssueinstitution == null) sIssueinstitution ="&nbsp;";
		if(sMaturityDate == null) sMaturityDate ="&nbsp;";
		if(sSino == null) sSino ="&nbsp;";
		if(sEduExperience == null) sEduExperience ="&nbsp;";
		if(sFamilyTel == null) sFamilyTel="&nbsp;";
		if(sPhoneMan == null) sPhoneMan ="&nbsp;";
		if(sMobileTelephone == null) sMobileTelephone ="&nbsp;";
		if(sEmailAdd == null) sEmailAdd ="&nbsp;";
		if(sQQNo == null) sQQNo ="&nbsp;";
		if(sMarriage == null) sMarriage ="&nbsp;";
		if(sHouse == null) sHouse ="&nbsp;";
		if(sNativeplace == null) sNativeplace ="&nbsp;";
		if(sVillagetown == null) sVillagetown ="&nbsp;";
		if(sPlot == null) sPlot ="&nbsp;";
		if(sRoom == null) sRoom ="&nbsp;";
		if(sWorkCorp == null) sWorkCorp ="&nbsp;";
		if(sEmployRecord == null) sEmployRecord ="&nbsp;";
		if(sHeadShip == null) sHeadShip="&nbsp;";
		if(sIndustryType == null) sIndustryType ="&nbsp;";
		if(sCellProperty == null) sCellProperty ="&nbsp;";
		if(sWorkTel == null) sWorkTel ="&nbsp;";
		if(sWorkAdd == null) sWorkAdd ="&nbsp;";
		if(sUnitCountryside == null) sUnitCountryside ="&nbsp;";
		if(sUnitStreet == null) sUnitStreet ="&nbsp;";
		if(sUnitRoom == null) sUnitRoom ="&nbsp;";
		if(sUnitNo == null) sUnitNo ="&nbsp;";
		if(sCommAdd == null) sCommAdd ="&nbsp;";
		if(sJobTotal == null) sJobTotal ="&nbsp;";
		if(sJobTime == null) sJobTime ="&nbsp;";
		if(sSpouseName == null) sSpouseName ="&nbsp;";
		if(sSpouseTel == null) sSpouseTel ="&nbsp;";
		if(sSpouseWorkCorp == null) sSpouseWorkCorp = "&nbsp;";
		if(sSpouseWorkTel == null) sSpouseWorkTel = "&nbsp;";
		if(sKinshipName == null) sKinshipName ="&nbsp;";
		if(sRelativeType == null) sRelativeType ="&nbsp;";
		if(sKinshipAdd == null) sKinshipAdd="&nbsp;";
		if(sKinshipTel == null) sKinshipTel ="&nbsp;";
		if(sOtherContact == null) sOtherContact ="&nbsp;";
		if(sRelativeType1 == null) sRelativeType1 ="&nbsp;";
		if(sContactTel == null) sContactTel ="&nbsp;";
		if(sZE == null) sZE ="&nbsp;";
		if(sOtherRevenue == null) sOtherRevenue ="&nbsp;";
		if(sFamilyMonthIncome == null) sFamilyMonthIncome ="&nbsp;";
		if(sCE == null) sCE ="&nbsp;";
		if(sCommunity == null) sCommunity ="&nbsp;";
		if(sCellNo == null) sCellNo ="&nbsp;";
		if(sFamilyAdd == null) sFamilyAdd ="&nbsp;";
		if(sCountryside == null) sCountryside ="&nbsp;";
		if(sVillagecenter == null) sVillagecenter ="&nbsp;";
		if(sStreet == null) sStreet ="&nbsp;";

	}
	rs3.getStatement().close(); 
 
	String sSql3="select bt.CUSTOMERSERVICERATES,bt.MANAGEMENTFEESRATE,bt.MONTHLYINTERESTRATE,bt.STAMPTAX,bt.MONTHLYINTERESTRATE  from business_type bt where typeno = (select businessType from business_contract where serialno = '"+sObjectNo+"')";
	ASResultSet rs4 = Sqlca.getResultSet(sSql3);
	  if(rs4.next()){
		  sCUSTOMERSERVICERATES = rs4.getString("CUSTOMERSERVICERATES");
		  sMANAGEMENTFEESRATE = rs4.getString("MANAGEMENTFEESRATE");
		  sSTAMPTAX = rs4.getString("STAMPTAX");
		  sCreditRate=rs4.getString("MONTHLYINTERESTRATE");
		  
			if(sCUSTOMERSERVICERATES == null) sCUSTOMERSERVICERATES ="0&nbsp;";
			if(sMANAGEMENTFEESRATE == null) sMANAGEMENTFEESRATE ="0&nbsp;";
			if(sSTAMPTAX == null) sSTAMPTAX ="0&nbsp;";
			if(sCreditRate == null) sCreditRate="0&nbsp;";
			

	  }
	rs4.getStatement().close();
	
	//首次还款日
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String businessDate = SystemConfig.getBusinessDate();
	if(!sPutOutDate.equals("&nbsp;")){	
		sFirstDueDate = Sqlca.getString(new SqlObject("select FirstDueDate from acct_rpt_segment where objectno = :objectNo ").setParameter("objectNo", sObjectNo));
		sDefaultDueDay = sFirstDueDate.substring(8,10);
	}	

	//随心还服务包费用
	if("1".equals(bpp)){//已购买随心还的
		com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee bppf = new GetBugPayPkgindFee();
		bppf.setStypeno(stypeno);
		bppf.setsBusinessSum_(sBusinessSum_);
		bppf.setsTerm(sTerm);
		bppf.setsBugPayPkgind(bpp);
		bugPayPkgindFee = bppf.getFee(Sqlca);
	}
	
	//sApplyNum = Sqlca.getString(new SqlObject("select count(1) from Business_Contract where CustomerID =:CustomerID and SerialNO <> '"+sObjectNo+"'").setParameter("CustomerID", sCustomerID));
	sApplyNum = Sqlca.getString(new SqlObject("select Severaltimes from ind_info where CustomerID =:CustomerID ").setParameter("CustomerID", sCustomerID));
	if(sApplyNum==null){
		sApplyNum="0";
	}
	sAddress = Sqlca.getString(new SqlObject("select getItemName('AreaCode',CITY)||ADDRESS as Address from STORE_INFO where SNO =:SNO").setParameter("SNO", sStores));
	String sPage = Sqlca.getString(new SqlObject("select documentid from ecm_page where objectno =:ObjectNO and objecttype = 'Business' and typeno = '20002'  order by modifytime desc").setParameter("ObjectNO", sObjectNo));
	//String sPage = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");

	String path = request.getContextPath(); 
	String requestpath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String sLogo = requestpath+"FormatDoc/Images/122.jpg";
	
	String xcPage = Sqlca.getString(new SqlObject("select DOCUMENTID from ecm_page where typeno = '20002' and objectno =:ObjectNo order by MODIFYTIME desc").setParameter("ObjectNo", sObjectNo));
	requestpath = sWebRootPath+"/servlet/ImageServlet?ImageId=";
	xcPage = requestpath+xcPage;
	/* if("非代扣".equals(repaymentWay)){
		sDfile = "&nbsp;";
	} */
	String sSqlbx="SELECT sp.ins_name as bxcompanyName,sp.ins_serviceprovidersname as bxproductName,sp.ins_casepercent as Cash, sp.ins_insurancedescription InsuranceDescription FROM business_contract bc ,bq_insurance_info sp where bc.insuranceno=sp.ins_serialno and bc.serialno='"+sObjectNo+"' ";
	ASResultSet rsbx = Sqlca.getResultSet(sSqlbx);
	String bxcompanyName="",bxproductName = "",Cash="",InsuranceDescription = "";
	if(rsbx.next()){
		bxcompanyName = rsbx.getString("bxcompanyName");
		bxproductName = rsbx.getString("bxproductName");
		Cash = rsbx.getString("Cash");
		InsuranceDescription = rsbx.getString("InsuranceDescription");
		  
		if(bxcompanyName == null) bxcompanyName ="&nbsp;";
		if(bxproductName == null) bxproductName ="&nbsp;";
		if(Cash == null) Cash ="&nbsp;";
		if(InsuranceDescription == null)
			InsuranceDescription = "";
		else
			InsuranceDescription = "（"+InsuranceDescription+"）";
	}
	rsbx.getStatement().close();       
	
	//String sCreditCycleFile = ""+bxcompanyName+"： 本人选择参加保险，即表明本人同意深圳市佰仟金融服务有限公司为本人投保“"+bxproductName+"”，并认可其为本人所投保的保险金额（贷款本金的"+Cash+"倍）。本人指定深圳市佰仟金融服务有限公司为前述“"+bxproductName+"”合同项下身故和残疾保险金的第一受益人，受益金额为依分期购消费贷款三方协议约定仍未偿还的贷款本金。本人同时确认已熟知保险合同及相关条款, 且具备保险合同所约定的所有参保资格条件。";
	
	// CreditCycle		是否投保	
	if(!"1".equals(sCreditCycle)) {
		//sCreditCycleFile = "&nbsp;";
		sCreditFeeRate = "0.00";
	}
	
	String sCreditCycleName = "";
	if ("1".equals(sCreditCycle)){
		sCreditCycleName = "是";
		sDfile = bxcompanyName + "：本人选择参加保险，即表明本人同意深圳市佰仟金融服务有限公司为本人投保“"+bxproductName+"”，并通过身份证号码在"+bxcompanyName+"网站上查询下载保险合同，认可其为本人所投保的保险金额"+InsuranceDescription+"。本人指定深圳市佰仟金融服务有限公司为前述“"+bxproductName+"”合同项下保险金的受益人及/或第一受益人，受益金额为依贷款三方协议的约定仍未偿还款项的余额。本人同时确认已熟知保险合同及相关条款, 且具备保险合同所约定的所有参保资格条件。";
	} else {
		sCreditCycleName = "否";
		bxcompanyName ="&nbsp;";
		sDfile = "&nbsp;";
	}
	/* 
	//代扣条约判断
	if(!"1".equals(repaymentWay)){
		sDfile1 = "&nbsp;";
	} */
	
	//时间处理  add by yzhang9 CCS-466
/* 	if( !"".equals(sInputDate)|| !"&nbsp;".equals(sInputDate)|| sInputDate!=null){
		System.out.println("###########################       "+sInputDate);
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
		sInputDate = df.format(df.parse(sInputDate));
	} */
	
	if("".equals(sInputDate)|| "&nbsp;".equals(sInputDate)|| sInputDate==null){
		sInputDate="&nbsp;";
	}else{
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
		sInputDate = df.format(df.parse(sInputDate));
	}
	
	//System.out.println("###########################  26   "+sFlag2+"$$$$$$$$$  30    "+sCreditCycleName+"*************    55   "+sFlag8);

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='CashApplyReport.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable >");	
	sTemp.append("<table class=table1 align=center  border=0 cellspacing=0 cellpadding=0  width='810' >	");
	
/* 	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");	
	sTemp.append("<td colspan=3 rowspan=2 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("<td class=td1 rowspan=2 align=center colspan=5 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >现金贷款申请表</font></td> ");	
	sTemp.append("<td colspan=2 align=left class=td1 >条形码：<img src="+request.getContextPath()+"/barcode?msg="+sObjectNo+"&height=7 width='150' height='40' />&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >协议编号："+sObjectNo+"<br/>申请日期："+sInputDate+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >销售点代码："+sStores+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >销售点名称："+sStoresName+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >销售顾问代码："+sInputUserID+"&nbsp;</td>");
	//sTemp.append("<td colspan=2 align=left class=td1 >申请类别："+sApplyType+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=left class=td1 >申请类别："+sSubProductType+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=left class=td1 >过去在本公司有过几次贷款申请：</b>"+sApplyNum+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=4 align=left class=td1 >销售点地址："+sAddress+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >产品代码："+sBusinessType+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >贷款用途："+sPurpose+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>个人资料</b>&nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >1.姓名："+sCustomerName+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >2.性别："+sSex+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >3.身份证号码："+sCertID+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >4.发证机关："+sIssueinstitution+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >5.身份证有效期至："+sMaturityDate+"&nbsp;</td>");
	sTemp.append("<td colspan=1 rowspan=3 align=left class=td1 ><div><img src='"+xcPage+"' style='width:120px;height:120px;'/></div></td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >6.社保号码："+sSino+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >7.教育程度："+sEduExperience+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >8.住宅/宿舍电话："+sFamilyTel+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >9.住宅电话登记人："+sPhoneMan+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >10.手机：<br>"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >11.电子邮箱："+sEmailAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >12.QQ号码："+sQQNo+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >13.婚姻状况："+sMarriage+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >14.子女数目："+sChildrentotal+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >15.住房状况："+sHouse+"&nbsp;</td>");
	sTemp.append("</tr>");
	
/* 	sTemp.append("<tr style='height:30px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >13.婚姻状况："+sMarriage+"&nbsp;</td>");
	sTemp.append("<td colspan=5 align=left class=td1 >14.子女数目："+sChildrentotal+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >15.住房状况："+sHouse+"&nbsp;</td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >16.户籍地址：省/直辖市："+sNativeplace+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >17.镇/乡："+sVillagetown+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >18.街道/村："+sStreet+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >19.小区/楼盘："+sCommunity+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >20.栋/单元/房间号："+sCellNo+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >21.现居住地址：省/直辖市："+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >22.镇/乡："+sCountryside+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >23.街道/村："+sVillagecenter+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >24.小区/楼盘："+sPlot+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >25.栋/单元/房间号："+sRoom+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	//sTemp.append("<td colspan=10 align=left class=td1 style='height:30px;' >26.现居住地址是否与户籍地址相同："+sFlag2+"&nbsp;</td>");
	sTemp.append("<td colspan=10 align=left class=td1  >26.现居住地址是否与户籍地址相同：&nbsp;"+("是".equals(sFlag2)?"是■&nbsp;&nbsp;&nbsp;否□</td>":"是□&nbsp;&nbsp;&nbsp;否■</td>"));
	sTemp.append("</tr>");


	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>现金贷款服务内容</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >27.贷款本金（元）："+sBusinessSum+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >28.分期期数："+sPeriods+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >29.每月还款额（元）："+sMonthRepayMent+"&nbsp;</td>");
	//sTemp.append("<td colspan=2 align=left class=td1  >30.是否购买保险：&nbsp;"+("是".equals(sCreditCycleName)?"是■  否□&nbsp;</td>":"是□  否■&nbsp;</td>"));
	sTemp.append("<td colspan=3 align=left class=td1  >30.是否申请参加保险："+("是".equals(sCreditCycleName)?"是■&nbsp;&nbsp;否□</td>":"是□&nbsp;&nbsp;否■</td>"));
	sTemp.append("<td colspan=1 align=left class=td1 >31.保险公司名称："+bxcompanyName+"</td>"); //update tangyb
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >32.每月还款日："+sDefaultDueDay+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >33.月贷款利率（%）："+sCreditRate+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >34.首次还款额（元）："+dFirstIntrestAmt+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >35.首次还款日："+sFirstDueDate+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >36.月客户服务费率（%）："+sCUSTOMERSERVICERATES+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >37.月财务管理费率（%）："+sMANAGEMENTFEESRATE+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >38.月增值服务费率</br>（%）："+sCreditFeeRate+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >39.印花税（%）："+sSTAMPTAX+"&nbsp;</td>");
	//sTemp.append("<td colspan=4 align=left class=td1 >39.随心还服务费(元): "+bugPayPkgindFee+"&nbsp;&nbsp;&nbsp;是否选择随心还："+sBugPayPkgind+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >"+sDfile+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>还款账户信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >40.指定还款账户账号：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sRepaymentNo+"&nbsp;<br></td>");
	sTemp.append("<td colspan=4 align=left class=td1 >41.开户银行：<br>&nbsp;&nbsp;&nbsp;&nbsp;招商银行深圳安联支行 &nbsp;</td>");//为什么默认写死？“sRepaymentBank”
	sTemp.append("<td colspan=3 align=left class=td1 >42.户名："+sRepaymentName+"&nbsp;</td>");
	//sTemp.append("<td colspan=2 align=left class=td1 style='border-left-style: none;' ></td>");
	sTemp.append("</tr>");
	
	
/* 	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >42.客户银行卡号/账号：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sReplaceAccount+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >43.客户开户银行：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sOpenBranch+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >44.客户银行账户名：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sReplaceName+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >43.银行代扣还款："+repaymentWay+"&nbsp;</td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");
 	sTemp.append("<td colspan=9 align=left class=td1 >43. 借款人银行账户信息（用于收款、扣款）：<br/>&nbsp;&nbsp;户名："+sReplaceName
									+"&nbsp;&nbsp;&nbsp;&nbsp;开户行："+sOpenBranch
									+"&nbsp;&nbsp;&nbsp;&nbsp;账号："+sReplaceAccount+"</td>"); 
 	sTemp.append("<td colspan=1 align=left class=td1 >44.是否选择银行代扣还款："+("1".equals(repaymentWay)?"是■&nbsp;&nbsp;否□":"是□&nbsp;&nbsp;否■")+"</td>"); //update tangyb
 	/*
	sTemp.append("<td colspan=9 align=left class=td1 >42. 借款人银行账户信息（用于收款、扣款）：<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;户名："+sReplaceName
			+"&nbsp;&nbsp;&nbsp;&nbsp;开户行："+sOpenBranch+"&nbsp;&nbsp;&nbsp;&nbsp;账号："+sReplaceAccount+"</td>");
	sTemp.append("<td colspan=1 align=left class=td1 style='color: red;' >43.银行代扣还款<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+("代扣".equals(repaymentWay)?"是■  否□&nbsp;</td>":"是□  否■&nbsp;</td>"));
 	*/
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >"+sDfile1+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>单位信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >45.单位/个体全称："+sWorkCorp+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >46.任职部门："+sEmployRecord+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >47.职位："+sHeadShip+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >48.行业类别："+sIndustryType+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >49.单位性质："+sCellProperty+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >50.单位电话："+sWorkTel+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >51.单位地址：省/直辖市："+sWorkAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >52.镇/乡："+sUnitCountryside+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >53.街道/村："+sUnitStreet+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >54.小区/楼盘："+sUnitRoom+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >55.栋/单元/房间号："+sUnitNo+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1  >56.邮寄地址："+("1".equals(sFlag8)?"居住地址■"+"&nbsp;&nbsp;&nbsp;"+"单位地址□":"居住地址□"+"&nbsp;&nbsp;&nbsp;"+"单位地址■")+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >57.总工作经验(年)："+sJobTotal+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >58.现单位工作/个体营业时间(月)："+sJobTime+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >59.在现单位是否购买社保："+sFlag4+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>配偶及家庭成员信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >60.配偶姓名："+sSpouseName+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >61.配偶移动电话："+sSpouseTel+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >62.配偶单位名称："+sSpouseWorkCorp+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >63.配偶单位电话："+sSpouseWorkTel+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >64.家庭成员名称："+sKinshipName+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >65.家庭成员类型："+sRelativeType+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >66.家庭成员电话："+sKinshipTel+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >67.家庭成员联系地址："+sKinshipAdd+"</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>其他联系人信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=3 align=left class=td1 >68.联系人姓名："+sOtherContact+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >69.与申请人关系："+sRelativeType1+"</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >70.联系电话："+sContactTel+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>收入及支出信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >71.月收入总额（元）："+sZE+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >72.其他收入（元/月）："+sOtherRevenue+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >73.家庭月收入（元）："+sFamilyMonthIncome+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >74.个人月支出（元/月）："+sCE+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>其他信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr style='height:20px;'>");
	String emg = "";
	//查询总数
	String querySumSql = "select getecmtypename(typeno) as typename from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 group  by ECM_PAGE.typeNo ";
	ASResultSet rs_2 = Sqlca.getASResultSet(new SqlObject(querySumSql));
	while(rs_2.next()){
		String my_typeName = rs_2.getString("typename");
		emg += my_typeName;
	}
	if(rs_2!=null) {
		rs_2.close();
	}
	
	//日期处理 
	String year =null;
	String month = null;
	String day = null;
	if("".equals(sInputDate)||"&nbsp;".equals(sInputDate)||sInputDate==null){
		year = "&nbsp;&nbsp;";
		month ="&nbsp;&nbsp;";
		day = "&nbsp;&nbsp;";
	}else{
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
		sInputDate = df.format(df.parse(sInputDate));
		year =sInputDate.substring(0,4);
		month = sInputDate.substring(5,7);
		day = sInputDate.substring(8,10);
	}
	
	
	
	
	 
	
	sTemp.append("<td colspan=6 align=left class=td1 >提供的申请材料:"+emg+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >产品附录：&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >是否签署授权书:"+sfalg6+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style='FONT-FAMILY:宋体; font-size: 8pt;' >本人具有完全民事行为能力签署本申请表并承担相应责任。本人已仔细阅读并完全了解《现金贷款三方协议》，并且自愿遵守相关的合同规定。<br><br>本人保证在此表上填写、确认的内容及向贷款人、佰仟金融提供的所有相关资料全部真实、有效，如本人提供虚假资料，将承担由此引起的一切责任及损失。本人在此同意贷款人和佰仟金融按照相关法律法规的规定，向有权机构报送本人的个人信用信息，包括但不限于本申请表项下的信息，同时，授权贷款人和佰仟金融向任何可能的来源查询本人及配偶的与贷款申请有关的个人信息和个人信用信息，相关查询结果的用途将用于贷款审查和贷款管理。<br/>本人同意如因单方面取消申请或不具备借款条件，申请不获批准，本表格及所有已提交的资料无须退还本人，由佰仟金融处理。贷款人有权拒绝本贷款申请而无须给予任何原因解释。</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr style='height:50px;' >");
	sTemp.append("<td colspan=10 rowspan=2 align=left class=td1 >销售顾问姓名:"+sUserName+"&nbsp;销售顾问签名:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;销售顾问联系方式:"+sMobileNum+"&nbsp;&nbsp;客户签名:&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+year+"年"+month+"月"+day+"日&nbsp</td>");
	//sTemp.append("<td colspan=10 rowspan=2 align=left class=td1 >销售顾问姓名:"+sUserName+"&nbsp;&nbsp;&nbsp;销售顾问签名:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;销售顾问联系方式&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请人签名：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+year+"年"+month+"月"+day+"日&nbsp;</td>");
	//sTemp.append("<td colspan=10 rowspan=2 align=left class=td1 >销售顾问姓名:"+sUserName+"&nbsp;&nbsp;&nbsp;销售顾问签名:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;销售顾问联系方式&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请人签名：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年 &nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日&nbsp;</td>");
	
	/* sTemp.append("<td colspan=2 align=left class=td1 >销售顾问姓名："+sUserName+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >销售顾问签名：&nbsp;&nbsp;&nbsp;&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >销售顾问联系方式："+sFamilyMonthIncome+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >申请人签名：&nbsp;&nbsp;&nbsp;&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >"+year+"年"+month+"月"+day+"日&nbsp;</td>"); */
	
	
	sTemp.append("</tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");
	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='111'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='111'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='111'>");
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