<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@page import="com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		�ֽ��������� 
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
String sCustomerID = "";//�ͻ����
String sBusinessType = "";//��Ʒ���
String sPurpose="";//������;
String sCustomerName = "";//�ͻ�����
String sCertID = "";//֤������
String sBusinessSum = "";//������
String sEndTime = "";//���ʱ��
String sMonthRepayMent = "";//ÿ�»����
String sTotalSum="";//�Ը��ܽ��
String sPeriods="";//����
String sRepaymentNo="";//�����˺�
String sRepaymentBank="";//��������
String sRepaymentName="";//�����
String sInputUserID="";//���۹��ʴ���
String sMobileNum="";//���۹�����ϵ��ʽ
String sStores="";//���۵����
String sInteriorCode = "";//�ڲ�����
String sTotalPrice = "";//��Ʒ�ܼۣ�Ԫ��
String sStoresName = "";//���۵�����
String sApplyType="";//��������
String sSubProductType="";//��Ʒ������ 
String sApplyNum="";//�������
String sAddress="";//�ŵ��ַ
String sSex="";//�Ա�
String sIssueinstitution="";//��֤����
String sMaturityDate="";//����֤��Ч��
String sSino="";//�籣����
String sEduExperience="";//�����̶�
String sFamilyTel="";//סլ������绰
String sPhoneMan="";//סլ�绰�Ǽ���
String sMobileTelephone="";//�ֻ�
String sEmailAdd="";//��������
String sQQNo="";//QQ��
String sMarriage="";//����״��
int sChildrentotal=0;//��Ů��Ŀ
String sHouse="";//ס��״��
String sNativeplace="";//������ַ
String sVillagetown="";//����
String sStreet="";//�ֵ�����
String sCommunity="";//С����¥��
String sCellNo="";//������Ԫ�������
String sFamilyAdd="";//�־�ס��ַ
String sCountryside="";//����
String sVillagecenter="";//�ֵ�����
String sPlot="",sRoom="",sFlag2="",sCreditRate="";
String repaymentWay="";
String sCUSTOMERSERVICERATES="",sMANAGEMENTFEESRATE="",sPdgRatio="",sSTAMPTAX="",sUnitStreet="",sMONTHADDSERVICERATE="";
String sReplaceAccount ="";//�ͻ������˺�
String sOpenBranch="",sInputDate="",sBusinessType1="",sBrandType1="",sPrice1="",sBusinessType2="",sBrandType2="",sPrice2="",sBusinessType3="",sBrandType3="",sPrice3="",sFlag8="",sManufacturer1="",sManufacturer2="",sManufacturer3="";//�ͻ�������
String sReplaceName="",sWorkCorp="",sEmployRecord="",sCommAdd="",sJobTotal="",sJobTime="",sFlag4="";
String sHeadShip="",sIndustryType="",sCellProperty="",sWorkTel="", sWorkAdd="",sUnitCountryside="",sUnitRoom="",sUnitNo="";
String sSpouseName="",sSpouseTel="",sSpouseWorkCorp="",sSpouseWorkTel="",sKinshipName="",sRelativeType="",sKinshipTel="",sKinshipAdd="",sOtherContact="",sRelativeType1="";
String sContactTel="",sZE="",sOtherRevenue="",sFamilyMonthIncome="",sCE="", sCreditCycle="", sCreditFeeRate=""; 
//��Ʒ�����ʡ��״λ����ա�Ĭ�ϻ����ա��»����������
String sMONTHLYINTERESTRATE="",sMonthRepayment="",sPutOutDate="",sfalg6="";
String sUserName = "";
String dFirstIntrestAmt = "";
//�ڼ������Ļ��������ʱʹ��
String stypeno = "",sBusinessSum_ = "",sTerm="",bpp = "",sBugPayPkgind = "",bugPayPkgindFee="0.0";

String sDfile = "***�������޹�˾��  ����ѡ��μӱ��գ�����������ͬ�������а�Ǫ���ڷ������޹�˾Ϊ����Ͷ�������ղ�Ʒ���ơ�����ͨ������֤�������񰲲Ʋ����չ�˾��վ�ϲ�ѯ���ر��պ�ͬ���Ͽ���Ϊ������Ͷ���ı��ս������ı���  ����������ָ�������а�Ǫ���ڷ������޹�˾Ϊǰ�������ղ�Ʒ���ơ���ͬ�������ʺͲм����ս�ĵ�һ�����ˣ�������Ϊ���ֽ������Ѵ�������Э��Լ����δ�����Ĵ���𡣱���ͬʱȷ������֪���պ�ͬ���������, �Ҿ߱����պ�ͬ��Լ�������вα��ʸ�������";
String sDfile1 = "����ѡ�����д��ۻ����������ͬ�Ⲣ��Ȩ�����˿�ͨ�����дӱ���ָ���Ľ���������˻������44����ʾ����ÿ�»������29����ʾ��������Ӧ������ת��ָ�������˻������41����ʾ��������ͬ��˿ۿ���Ȩͬʱ������֮ǰ�ɰ�Ǫ�����ṩ������ǩ����һ�ݻ��ݴ����ͬ���������˿�ͨ�����дӱ���ָ�������������˻��ڿۻ������ڸ���ͬ��Ӧ��������ؿ������ͬ����˻�ͬʱ����������ǰ�����������ʽ�������";
%>
<%!
	public String getCityName(String str,String flag,Transaction Sqlca) throws Exception {
		String sReturn = str;
		if("ʡ".equals(flag) && str.indexOf("ʡ")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Nativeplace,1, instr(:Nativeplace,'ʡ')) from dual").setParameter("Nativeplace", str));
		}else if("��".equals(flag) && str.indexOf("��")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Nativeplace, instr(:Nativeplace, 'ʡ')+1) from dual").setParameter("Nativeplace", str));
		}else if("��".equals(flag) && str.indexOf("��")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Nativeplace,1, instr(:Nativeplace,'ʡ')) from dual").setParameter("Nativeplace", str));
		}else if("��".equals(flag) && str.indexOf("��")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown,1, instr(:Villagetown,'��')) from dual").setParameter("Villagetown", str));
		}else if("��".equals(flag) && str.indexOf("��")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown,1, instr(:Villagetown,'��')) from dual").setParameter("Villagetown", str));
		}else if("��".equals(flag) && str.indexOf("��")!=-1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown,1, instr(:Villagetown,'��')) from dual").setParameter("Villagetown", str));
		}else if("��".equals(flag) && str.indexOf("��") != -1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown, instr(:Villagetown, '��')+1) from dual").setParameter("Villagetown", str));
		}else if("��".equals(flag) && str.indexOf("��") != -1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown, instr(:Villagetown, '��')+1) from dual").setParameter("Villagetown", str));
		}else if("��".equals(flag) && str.indexOf("��") != -1)
		{
			sReturn = Sqlca.getString(new SqlObject("select substr(:Villagetown, instr(:Villagetown, '��')+1) from dual").setParameter("Villagetown", str));
		}
		
		if(null == sReturn) sReturn = "";
		return sReturn;
	}
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ�sCustomerID��2;]~*/%>
<%
//��õ��鱨������
String sSql = "select bc.insurancesum as CreditFeeRate,bc.CreditCycle as CreditCycle,bc.BusinessType3 as BusinessType3,bc.BrandType3 as BrandType3,bc.Manufacturer3 as Manufacturer3,bc.Price3 as Price3,bc.FIRSTDRAWINGDATE as FIRSTDRAWINGDATE,bc.CustomerID,bc.CustomerName,bc.stores,bc.inputuserid,bc.inputdate,bc.BusinessType,getitemname('CashPurpose',bc.Purpose) as Purpose,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName, "+
				" bc.TotalPrice,bc.PdgRatio,bc.ReplaceAccount,getitemname('BankCode',bc.OpenBank) as OpenBank,bc.ReplaceName,"+
				" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,getitemname('BankCode',bc.RepaymentBank) as RepaymentBank,bc.RepaymentName, "+
				"(select typename from business_type where typeno = bc.BusinessType) as ApplyType1,getitemname('SubProductType',bc.SubProductType) as SubProductType,getitemname('BusinessType',bc.productid) as ApplyType,"+
				" PutOutDate,PERIODS,REPAYMENTWAY,getitemname('YesNo',falg6) as falg6, "+
				" bc.BrandType1,bc.Price1,bc.BrandType2,bc.Price2,getTypeName(bc.BusinessRange1,bc.BusinessType1) as BusinessType1,getTypeName(bc.BusinessRange2,bc.BusinessType2) as BusinessType2,bc.Manufacturer1,bc.Manufacturer2, "+
				" getusername(bc.Inputuserid) as UserName, SUBMITDATETIME as SUBMITDATETIME " + 
				" ,BugPayPkgind as bpp,getItemName('BugPayPkgind',BugPayPkgind) as BugPayPkgind from Business_Contract bc where SerialNo = '"+sObjectNo+"'";

ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		bpp = rs2.getString("bpp");//�Ƿ������Ļ������
		if(bpp==null) bpp = "";
		sBugPayPkgind = rs2.getString("BugPayPkgind");//�Ƿ������Ļ������
		if(sBugPayPkgind==null || "".equals(sBugPayPkgind)) sBugPayPkgind = "δѡ��";
		//�ڼ������Ļ��������ʱʹ��
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
		sApplyType = rs2.getString("ApplyType");//�������  
		sSubProductType= rs2.getString("SubProductType");//��Ʒ������ 
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
		sInputDate = Sqlca.getString(new SqlObject("SELECT FT1.PHASEOPINION4 FROM FLOW_TASK FT1 WHERE SERIALNO=(SELECT MIN(FT2.SERIALNO) FROM FLOW_TASK FT2 WHERE FT2.OBJECTNO=:OBJECTNO)").setParameter("OBJECTNO", sObjectNo));
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
		if(sSubProductType == null) sSubProductType ="&nbsp;";//��Ʒ������ 
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
	
	//�״λ�����
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String businessDate = SystemConfig.getBusinessDate();
	if(!sPutOutDate.equals("&nbsp;")){	
		sFirstDueDate = Sqlca.getString(new SqlObject("select FirstDueDate from acct_rpt_segment where objectno = :objectNo ").setParameter("objectNo", sObjectNo));
		sDefaultDueDay = sFirstDueDate.substring(8,10);
	}	

	//���Ļ����������
	if("1".equals(bpp)){//�ѹ������Ļ���
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
	/* if("�Ǵ���".equals(repaymentWay)){
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
			InsuranceDescription = "��"+InsuranceDescription+"��";
	}
	rsbx.getStatement().close();       
	
	String sCreditCycleFile = ""+bxcompanyName+"�� ����ѡ��μӱ��գ�����������ͬ�������а�Ǫ���ڷ������޹�˾Ϊ����Ͷ����"+bxproductName+"�������Ͽ���Ϊ������Ͷ���ı��ս�������"+Cash+"����������ָ�������а�Ǫ���ڷ������޹�˾Ϊǰ����"+bxproductName+"����ͬ�������ʺͲм����ս�ĵ�һ�����ˣ�������Ϊ�����ڹ����Ѵ�������Э��Լ����δ�����Ĵ���𡣱���ͬʱȷ������֪���պ�ͬ���������, �Ҿ߱����պ�ͬ��Լ�������вα��ʸ�������";
	
	// CreditCycle		�Ƿ�Ͷ��	
	if(!"1".equals(sCreditCycle)) {
		//sCreditCycleFile = "&nbsp;";
		sCreditFeeRate = "0.00";
	}
	String sCreditCycleName = "";
	if ("1".equals(sCreditCycle)) sCreditCycleName = "��";
	else sCreditCycleName = "��";
	
	//ʱ�䴦��  add by yzhang9 CCS-466
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
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
	sTemp.append("<td class=td1 rowspan=2 align=center colspan=5 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��Ǯô�����������</font></td> ");	
	sTemp.append("<td colspan=2 align=left class=td1 >�����룺<img src="+request.getContextPath()+"/barcode?msg="+sObjectNo+"&height=7 width='150' height='40' />&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	//sTemp.append("<td colspan=3 align=left class=td1 >��ͬ��ţ�"+sObjectNo+"&nbsp;�������ڣ�"+sInputDate+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >��ͬ��ţ�"+sObjectNo+"<br/>�������ڣ�"+sInputDate+"&nbsp;</td>");
	sTemp.append("</tr>");

	
	sTemp.append("<tr>");
	//sTemp.append("<td colspan=2 align=left class=td1 >�������"+sApplyType+"&nbsp;</td>"); 
	sTemp.append("<td colspan=3 align=left class=td1 >��Ʒ���룺"+sBusinessType+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >������;��"+sPurpose+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >�������"+sSubProductType+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=left class=td1 >��ȥ�ڱ���˾�й����δ������룺</b>"+sApplyNum+"&nbsp;</td>");
//	sTemp.append("</tr>");
//	sTemp.append("<tr>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>��������</b>&nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >1.������"+sCustomerName+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >2.�Ա�"+sSex+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >3.����֤���룺"+sCertID+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >4.��֤���أ�"+sIssueinstitution+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >5.����֤��Ч������"+sMaturityDate+"&nbsp;</td>");
	sTemp.append("<td colspan=1 rowspan=3 align=left class=td1 ><div><img src='"+xcPage+"' style='width:120px;height:120px;'/></div></td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >6.�籣���룺"+sSino+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >7.�����̶ȣ�"+sEduExperience+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >8.סլ/����绰��"+sFamilyTel+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >9.סլ�绰�Ǽ��ˣ�"+sPhoneMan+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >10.�ֻ���<br>"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >11.�������䣺"+sEmailAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >12.QQ���룺"+sQQNo+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >13.����״����"+sMarriage+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >14.��Ů��Ŀ��"+sChildrentotal+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >15.ס��״����"+sHouse+"&nbsp;</td>");
	sTemp.append("</tr>");
	
/* 	sTemp.append("<tr style='height:30px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >13.����״����"+sMarriage+"&nbsp;</td>");
	sTemp.append("<td colspan=5 align=left class=td1 >14.��Ů��Ŀ��"+sChildrentotal+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >15.ס��״����"+sHouse+"&nbsp;</td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >16.������ַ��ʡ/ֱϽ�У�"+sNativeplace+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >17.��/�磺"+sVillagetown+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >18.�ֵ�/�壺"+sStreet+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >19.С��/¥�̣�"+sCommunity+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >20.��/��Ԫ/����ţ�"+sCellNo+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >21.�־�ס��ַ��ʡ/ֱϽ�У�"+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >22.��/�磺"+sCountryside+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >23.�ֵ�/�壺"+sVillagecenter+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >24.С��/¥�̣�"+sPlot+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >25.��/��Ԫ/����ţ�"+sRoom+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	//sTemp.append("<td colspan=10 align=left class=td1 style='height:30px;' >26.�־�ס��ַ�Ƿ��뻧����ַ��ͬ��"+sFlag2+"&nbsp;</td>");
	sTemp.append("<td colspan=10 align=left class=td1  >26.�־�ס��ַ�Ƿ��뻧����ַ��ͬ��&nbsp;"+("��".equals(sFlag2)?"�ǡ�  ���&nbsp;</td>":"�ǡ�  ���&nbsp;</td>"));
	sTemp.append("</tr>");


	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>�ֽ�����������</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >27.�����Ԫ����"+sBusinessSum+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >28.����������"+sPeriods+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >29.ÿ�»���Ԫ����"+sMonthRepayMent+"&nbsp;</td>");
	//sTemp.append("<td colspan=3 align=left class=td1 style='color: red;' >30.�Ƿ����գ�"+sCreditCycleName+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1  >30.�Ƿ����գ�&nbsp;"+("��".equals(sCreditCycleName)?"�ǡ�  ���&nbsp;</td>":"�ǡ�  ���&nbsp;</td>"));
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=3 align=left class=td1 >31.ÿ�»����գ�"+sDefaultDueDay+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >32.�´������ʣ�%����"+sCreditRate+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >33.�״λ���Ԫ����"+dFirstIntrestAmt+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >34.�״λ����գ�"+sFirstDueDate+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=3 align=left class=td1 >35.�¿ͻ�������ʣ�%����"+sCUSTOMERSERVICERATES+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >36.�²���������ʣ�%����"+sMANAGEMENTFEESRATE+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >37.����ֵ�������</br>��%����"+sCreditFeeRate+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >38.ӡ��˰��%����"+sSTAMPTAX+"&nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 style='height:30px;' >39.�Ƿ������Ļ��������"+sBugPayPkgind+"&nbsp;</td>");
	sTemp.append("<td colspan=8 align=left class=td1 >40.�����Ļ������(Ԫ)��"+bugPayPkgindFee+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >"+sDfile+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>�����˻���Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >41.ָ�������˻��˺ţ�<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sRepaymentNo+"&nbsp;<br></td>");
	sTemp.append("<td colspan=4 align=left class=td1 >42.�������У�<br>&nbsp;&nbsp;&nbsp;&nbsp;�����������ڰ���֧�� &nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >43.������"+sRepaymentName+"&nbsp;</td>");
	//sTemp.append("<td colspan=2 align=left class=td1 style='border-left-style: none;' ></td>");
	sTemp.append("</tr>");
	
	
/* 	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >42.�ͻ����п���/�˺ţ�<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sReplaceAccount+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >43.�ͻ��������У�<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sOpenBranch+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >44.�ͻ������˻�����<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sReplaceName+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >43.���д��ۻ��"+repaymentWay+"&nbsp;</td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");
/* 	sTemp.append("<td colspan=9 align=left class=td1 >42. ����������˻���Ϣ�������տ�ۿ��������"+sReplaceName
									+"&nbsp;&nbsp;&nbsp;&nbsp;�����У�"+sOpenBranch
									+"&nbsp;&nbsp;&nbsp;&nbsp;�˺ţ�"+sReplaceAccount+"</td>"); 
  sTemp.append("<td colspan=1 align=left class=td1 style='color: red;' >43.���д��ۻ���<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+("����".equals(repaymentWay)?"�ǡ�  ���&nbsp;</td>":"�ǡ�  ���&nbsp;</td>"));
*/
	sTemp.append("<td colspan=9 align=left class=td1 >44. ����������˻���Ϣ�������տ�ۿ��<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������"+sReplaceName
			+"&nbsp;&nbsp;&nbsp;&nbsp;�����У�"+sOpenBranch+"&nbsp;&nbsp;&nbsp;&nbsp;�˺ţ�"+sReplaceAccount+"</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >45.���д��ۻ��"+("1".equals(repaymentWay)?"�ǡ�  ���&nbsp;</td>":"�ǡ�  ���&nbsp;</td>"));
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >"+sDfile1+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>��λ��Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >46.��λ/����ȫ�ƣ�"+sWorkCorp+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >47.��ְ���ţ�"+sEmployRecord+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >48.ְλ��"+sHeadShip+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >49.��ҵ���"+sIndustryType+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >50.��λ���ʣ�"+sCellProperty+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >51.��λ�绰��"+sWorkTel+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >52. ��λ��ַ��ʡ/ֱϽ�У�"+sWorkAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >53.��/�磺"+sUnitCountryside+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >54.�ֵ�/�壺"+sUnitStreet+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >55.С��/¥�̣�"+sUnitRoom+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >56.��/��Ԫ/����ţ�"+sUnitNo+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	//sTemp.append("<td colspan=3 align=left class=td1 >55. �ʼĵ�ַ��"+sFlag8+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1  >57.�ʼĵ�ַ��"+("1".equals(sFlag8)?"��ס��ַ��"+"&nbsp;&nbsp;&nbsp;"+"��λ��ַ��":"��ס��ַ��"+"&nbsp;&nbsp;&nbsp;"+"��λ��ַ��")+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >58.�ܹ�������(��)��"+sJobTotal+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >59.�ֵ�λ����/����Ӫҵʱ��(��)��"+sJobTime+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >60.���ֵ�λ�Ƿ����籣��"+sFlag4+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>��ż����ͥ��Ա��Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >61.��ż������"+sSpouseName+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >62.��ż�ƶ��绰��"+sSpouseTel+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >63.��ż��λ���ƣ�</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >64.��ż��λ�绰��</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >65.��ͥ��Ա���ƣ�"+sKinshipName+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >66.��ͥ��Ա���ͣ�"+sRelativeType+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >67.��ͥ��Ա�绰��"+sKinshipTel+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >68.��ͥ��Ա��ϵ��ַ��"+sKinshipAdd+"</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>������ϵ����Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=3 align=left class=td1 >69.��ϵ��������"+sOtherContact+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >70.�������˹�ϵ��"+sRelativeType1+"</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >71.��ϵ�绰��"+sContactTel+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>���뼰֧����Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >72.�������ܶԪ����"+sZE+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >73.�������루Ԫ/�£���"+sOtherRevenue+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >74.��ͥ�����루Ԫ����"+sFamilyMonthIncome+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >75.������֧����Ԫ/�£���"+sCE+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>������Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr style='height:20px;'>");
	String emg = "";
	//��ѯ����
	String querySumSql = "select getecmtypename(typeno) as typename from ECM_PAGE where ECM_PAGE.objectNo='"+sObjectNo+"' and  ECM_PAGE.documentId is not null and length(ECM_PAGE.documentId)>0 group  by ECM_PAGE.typeNo ";
	ASResultSet rs_2 = Sqlca.getASResultSet(new SqlObject(querySumSql));
	while(rs_2.next()){
		String my_typeName = rs_2.getString("typename");
		emg += my_typeName;
	}
	if(rs_2!=null) {
		rs_2.close();
	}
	
	//���ڴ��� 
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
	
	
	
	
	 
	
	sTemp.append("<td colspan=6 align=left class=td1 >�ṩ���������:"+emg+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >��Ʒ��¼��&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >�Ƿ�ǩ����Ȩ��:"+sfalg6+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
//	sTemp.append("<td colspan=10 align=left class=td1 ><font style='FONT-FAMILY:����; font-size: 8pt;' >���˾�����ȫ������Ϊ����ǩ����������е���Ӧ���Ρ���������ϸ�Ķ�����ȫ�˽⡶�ֽ�������Ѵ�������Э�顷��������Ը������صĺ�ͬ�涨��<br>���˱�֤�ڴ˱�����д��ȷ�ϵ����ݼ�������ˡ���Ǫ�����ṩ�������������ȫ����ʵ����Ч���籾���ṩ������ϣ����е��ɴ������һ�����μ���ʧ�������ڴ�ͬ������˺Ͱ�Ǫ���ڰ�����ط��ɷ���Ĺ涨������Ȩ�������ͱ��˵ĸ���������Ϣ�������������ڱ���������µ���Ϣ��ͬʱ����Ȩ�����˺Ͱ�Ǫ�������κο��ܵ���Դ��ѯ���˼���ż������������йصĸ�����Ϣ�͸���������Ϣ����ز�ѯ�������;�����ڴ������ʹ��������<br>����ͬ�����򵥷���ȡ������򲻾߱�������������벻����׼���������������ύ�����������˻����ˣ��ɰ�Ǫ���ڴ�������������Ȩ�ܾ��������������������κ�ԭ����͡�</td>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style='FONT-FAMILY:����; font-size: 8pt;' >��������ϸ�Ķ�������������ݣ�����������������������˵����ȷ�����������Ϊ�������ȫ�������ѳ�����Ⲣ��ȫ���ܡ�����ȷ�ϸ������֮����Ϊ������Ը֮��ʵ��˼���ͬ�ⰴ�������֮���ݳе���Ӧ����</td>");
	sTemp.append("</tr>");
	
	//sTemp.append("<tr>");
//	sTemp.append("<td colspan=10 align=left class=td1 ><font style='FONT-FAMILY:����; font-size: 8pt;' >���˾�����ȫ������Ϊ����ǩ����������е���Ӧ���Ρ���������ϸ�Ķ�����ȫ�˽⡶�ֽ��������Э�顷��������Ը������صĺ�ͬ�涨��<br>���˱�֤�ڴ˱�����д��ȷ�ϵ����ݼ�������ˡ���Ǫ�����ṩ�������������ȫ����ʵ����Ч���籾���ṩ������ϣ����е��ɴ������һ�����μ���ʧ�������ڴ�ͬ������˺Ͱ�Ǫ���ڰ�����ط��ɷ���Ĺ涨������Ȩ�������ͱ��˵ĸ���������Ϣ�������������ڱ���������µ���Ϣ��ͬʱ����Ȩ�����˺Ͱ�Ǫ�������κο��ܵ���Դ��ѯ���˼���ż������������йصĸ�����Ϣ�͸���������Ϣ����ز�ѯ�������;�����ڴ������ʹ��������<br/>����ͬ�����򵥷���ȡ������򲻾߱�������������벻����׼���������������ύ�����������˻����ˣ��ɰ�Ǫ���ڴ�������������Ȩ�ܾ��������������������κ�ԭ����͡�</td>");
//	sTemp.append("</tr>");
	//sTemp.append("<tr style='height:50px;' >");
	//sTemp.append("<td colspan=10 rowspan=2 align=left class=td1 >���۹�������:"+sUserName+"&nbsp;���۹���ǩ��:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���۹�����ϵ��ʽ:"+sMobileNum+"&nbsp;&nbsp;�ͻ�ǩ��:&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+year+"��"+month+"��"+day+"��&nbsp</td>");
	//sTemp.append("<td colspan=10 rowspan=2 align=left class=td1 >���۹�������:"+sUserName+"&nbsp;&nbsp;&nbsp;���۹���ǩ��:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���۹�����ϵ��ʽ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ǩ����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+year+"��"+month+"��"+day+"��&nbsp;</td>");
	//sTemp.append("<td colspan=10 rowspan=2 align=left class=td1 >���۹�������:"+sUserName+"&nbsp;&nbsp;&nbsp;���۹���ǩ��:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���۹�����ϵ��ʽ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ǩ����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;</td>");
	
	/* sTemp.append("<td colspan=2 align=left class=td1 >���۹���������"+sUserName+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >���۹���ǩ����&nbsp;&nbsp;&nbsp;&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >���۹�����ϵ��ʽ��"+sFamilyMonthIncome+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >������ǩ����&nbsp;&nbsp;&nbsp;&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >"+year+"��"+month+"��"+day+"��&nbsp;</td>"); */
	
	
	//sTemp.append("</tr>");
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

<script type="text/javascript">
<%	
	if(sMethod.equals("2")){  //2:save
%>
		alert("����ɹ���");
<%
	}
	if(sMethod.equals("2") || sMethod.equals("5")){  //2:save,5:autosave
%>
	    var objW;
	    if(typeof(window.opener)=='undefined')
	       objW=window.parent;     
	    else
	       objW=window.opener.top;
	    objW.bEditHtmlChange = false;
<%
    }
	if(sMethod.equals("3")){
		session.setAttribute(sPreviewContent,sReportInfo);
%>
		//alert("<%=sPreviewContent%>");
		var CurOpenStyle = "width=1200,height=600,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";
		OpenPage("/Resources/CodeParts/Preview01.jsp?sid=<%=sPreviewContent%>","_blank02",CurOpenStyle);
		//popComp("Preview01","/Resources/CodeParts/Preview01.jsp","sid="+"<%=sPreviewContent%>",CurOpenStyle);
<%
	}
	if(sMethod.equals("4")){  //4:export
		//cdeng 2009-02-12 �޸��ĵ��洢·���������Ե������������Ŀ¼
		ASResultSet rsPath = null;
		String sSql99="",sSavePath="",sfSerialNo="",sSql2="";
		if(sFirstSection.equals("1")){
			sSql99=" select SerialNo,SavePath from FORMATDOC_RECORD where ObjectType=:ObjectType and ObjectNo=:ObjectNo and DocID=:DocID ";
			rsPath = Sqlca.getASResultSet(new SqlObject(sSql99).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("DocID", sDocID));
			if(rsPath.next()){
				sfSerialNo = rsPath.getString("SerialNo");
				sSavePath = rsPath.getString("SavePath");
			}
			rsPath.getStatement().close();
	
			if(sfSerialNo==null) sfSerialNo="";
			if(sSavePath==null) sSavePath="";
		}
	
		//export to file
	    String sSerialNoNew = MessageDigest.getDigestAsUpperHexString("MD5", sDocID+sObjectNo+sObjectType);
	    
	    //�ж�·���Ƿ���ڣ�����������Զ�����
		java.io.File dFile=null;
		String sBasePath = CurConfig.getConfigure("WorkDocSavePath");
		if(sBasePath == null || sBasePath.equals(""))
			sBasePath=application.getRealPath("/FormatDoc/WorkDoc");
		
		//update CCS-505 ��ͬģ�����ڷ�������δ����/��/�շ�Ŀ¼��ţ������������  by rqiao 20150311
		//String sFileSavePath=sBasePath+"/"+StringFunction.getToday().substring(0,4);
		String sFileSavePath=sBasePath+"/"+StringFunction.getToday();
		//end
		
		try {
			dFile=new java.io.File(sFileSavePath);
			if(!dFile.exists()) {
				dFile.mkdirs();
			}
		}catch (Exception e) {
			 ARE.getLog().error(e.getMessage(),e);
		        throw e;
		}
		String sFileName = sFileSavePath+"/"+sSerialNoNew+".html";
		SqlObject asql = null;
		if(sFirstSection.equals("1")){
			if(sfSerialNo.equals("")){
				sSql2=" insert into FORMATDOC_RECORD(SerialNo,ObjectType,ObjectNo,DocID,SavePath) values(:SerialNo,:ObjectType,:ObjectNo,:DocID,:SavePath)";
				asql = new SqlObject(sSql2);
				asql.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("DocID", sDocID).setParameter("SavePath", sFileName);
			}else if(!sfSerialNo.equals("") && !sSavePath.equals(sFileName)){
				sSql2=" update FORMATDOC_RECORD set SavePath=:SavePath where ObjectType=:ObjectType and ObjectNo=:ObjectNo and DocID=:DocID";
				asql = new SqlObject(sSql2);
				asql.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("DocID", sDocID).setParameter("SavePath", sFileName);
			}
		}
		
	    java.io.File file = new java.io.File(sFileName);
	    java.io.FileOutputStream fileOut = null;
		
		if(sFirstSection.equals("1"))
			fileOut = new java.io.FileOutputStream(file,false);
		else
			fileOut = new java.io.FileOutputStream(file,true);
		
		if(sFirstSection.equals("1")){
	        String st0="<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\"><title>"+sObjectNo+"-�����</title>";
	        String st1="<STYLE>.table1 {  border: solid; border-width: 1px 1px 2px 2px; border-color: #000000 black #000000 #000000} .td1 {  border-color: #000000 #000000 black black; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000} </STYLE>	";
	        String st2="<script type=\"text/javascript\">";
	        String st3="function mykd() {if(event.keyCode==114 || event.keyCode==116 || event.keyCode==122 || (event.keyCode==78 && event.ctrlKey) )  { event.keyCode=0; event.returnValue=false; return false; } } ";
	        String st4="function ExportToWord(){ var oWD = new ActiveXObject('word.Application'); oWD.Application.Visible = true; var oDC =oWD.Documents.Add('',0,1); var oRange =oDC.Range(0,1);  var sel=parent.document.body.createTextRange(); oTblExport = parent.document.getElementById('reportContent'); if (oTblExport != null) { sel.moveToElementText(oTblExport); sel.execCommand('Copy'); parent.document.body.blur(); oRange.Paste(); } } ";
	        String st5="</script>";
	        String st6="<style> @media print { INPUT  {display:none }} </style>";
	        String st7="<body style='word-break:break-all' > <div id=div1 style=\"display:none\" > <object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style=\"display:none\" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object> ";
	        String st8="<input type=button value='��ӡ����' onclick=\"WebBrowser1.ExecWB(8,1)\"> <input type=button value='��ӡԤ��' onclick=\"WebBrowser1.ExecWB(7,1)\"> <input type=button value='��ӡ' onclick=\"WebBrowser1.ExecWB(6,1)\"> <input type=button value='����Ϊ' onclick=\"WebBrowser1.ExecWB(4,1)\"> <!--<input type=button value='������word' onclick=\"ExportToWord()\">--> <input type=button value='�ر�' onclick=\"WebBrowser1.ExecWB(45,1)\"><p></div></body>  ";
	        String st9="<script type=\"text/javascript\"> if(window.dialogArguments==\"myprint10\") div1.style.cssText=\"display:none\"; else div1.style.cssText=\"display:block\"; ";
	        String st10="try {	document.body.onkeydown=mykd; } catch(e) {var a=1;} try {	document.onkeydown=mykd; } catch(e) {var a=1;} try {	document.oncontextmenu=Function(\"return false;\"); } catch(e) {var a=1;}</script>";
	
	        fileOut.write(st0.getBytes("GBK"));    
	        fileOut.write(st1.getBytes("GBK"));    
	        fileOut.write(st2.getBytes("GBK"));    
	        fileOut.write(st3.getBytes("GBK"));    
	        fileOut.write(st4.getBytes("GBK")); //��ExportToWord����Ҳд��html
	        fileOut.write(st5.getBytes("GBK"));
	        fileOut.write(st6.getBytes("GBK"));    
	        fileOut.write(st7.getBytes("GBK"));    
	        fileOut.write(st8.getBytes("GBK"));    
	        fileOut.write(st9.getBytes("GBK"));    
	        fileOut.write(st10.getBytes("GBK"));
	        
	        //����������ǰ����div��ǩ
	        fileOut.write("<div id=reportContent>".getBytes("GBK"));
		}
		
		fileOut.write(sReportInfo.getBytes("GBK"));
		if(sFirstSection.equals("END")){
			//����βҳ����div��ǩ
		    fileOut.write("</div>".getBytes("GBK"));
		}
		fileOut.close();
		if(sFirstSection.equals("1")&&!sSql2.equals("")){
			Sqlca.executeSQL(asql);
		}
%>
	self.close();
<%
	}
%>	
</script>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Report01;Describe=����ҳ��;]~*/%>	
<%	
	if(sMethod.equals("1")){  //1:display
%>
	<%@include file="/Resources/CodeParts/Report01.jsp"%>
	<script type="text/javascript">
	//����
	function my_save(){
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "2"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}
	
	//Ԥ��
	function my_preview(){
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "3"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}		
	
	//����
	function my_export(){
		reportInfo.target = "mypost0";
		reportInfo.Method.value = "4"; //1:display;2:save;3:preview;4:export
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}	
	
	//���
	function my_finish(){
		if(confirm("���������ɸñ�����")){
			sReturn=PopPage("/CreditManage/CreditCheck/FinishInspectAction.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","","");
			if(sReturn=="Inspectunfinish")
				alert("�ô����鱨���޷���ɣ�������ɷ��շ��࣡");
			if(sReturn=="Purposeunfinish")
				alert("�ô�����;�����޷���ɣ�������������¼���ÿ��¼��");
			if(sReturn=="finished"){
				alert("�ñ�������ɣ�");
			}
		}
	}
	
	//�Զ�����
    function my_autosave(){
        reportInfo.target = "mypost0";
        reportInfo.Method.value = "5"; 		//1:display;2:save;3:preview;4:export;5:autosave
        reportInfo.Rand.value = randomNumber();
        reportInfo.submit();                   
    }
    if(bEditHtmlAutoSave) window.setInterval(my_autosave, 60000); //ÿ1�����Զ�����	
</script>
<%
	}
%>	
<%/*~END~*/%>

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