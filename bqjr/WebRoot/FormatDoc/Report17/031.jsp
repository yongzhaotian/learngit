<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
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
String sCustomerID = "";//�ͻ����
String sBusinessType = "";//��Ʒ���
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
String sStores="";//���۵����
String sInteriorCode = "";//�ڲ�����
String sTotalPrice = "";//��Ʒ�ܼۣ�Ԫ��
String sStoresName = "";//���۵�����
String sApplyType="";//��������
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
String sCUSTOMERSERVICERATES="",sMANAGEMENTFEESRATE="",sPdgRatio="",sSTAMPTAX="",sUnitStreet="";
String sReplaceAccount ="";//�ͻ������˺�
String sOpenBranch="",sInputDate="",sBusinessType1="",sBrandType1="",sPrice1="",sBusinessType2="",sBrandType2="",sPrice2="",sFlag8="",sManufacturer1="",sManufacturer2="";//�ͻ�������
String sReplaceName="",sWorkCorp="",sEmployRecord="",sCommAdd="",sJobTotal="",sJobTime="",sFlag4="";
String sHeadShip="",sIndustryType="",sCellProperty="",sWorkTel="", sWorkAdd="",sUnitCountryside="",sUnitRoom="",sUnitNo="";
String sSpouseName="",sSpouseTel="",sKinshipName="",sRelativeType="",sKinshipTel="",sKinshipAdd="",sOtherContact="",sRelativeType1="";
String sContactTel="",sZE="",sOtherRevenue="",sFamilyMonthIncome="",sCE=""; 
//��Ʒ�����ʡ��״λ����ա�Ĭ�ϻ����ա��»����������
String sMONTHLYINTERESTRATE="",sMonthRepayment="",sPutOutDate="",sfalg6="";
String sDfile = "����ѡ�����д��ۻ����������ͬ�Ⲣ��Ȩ�����˿�ͨ�����дӱ���ָ���������˻������53����ʾ����ÿ�»������43����ʾ��������Ӧ������ת��ָ�������˻������50����ʾ��������ͬ��˿ۿ���Ȩͬʱ������֮ǰ��ǩ����һ�ݻ��ݸ�������������ͬ���������˿�ͨ�����дӱ���ָ�������������˻��ڿۻ������ڸ���ͬ��Ӧ��������ؿ������ͬ����˻�ͬʱ����������ǰ�����������ʽ�������";

	 
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
//��õ��鱨������
String sSql = "select bc.CustomerID,bc.CustomerName,bc.stores,bc.inputuserid,bc.inputdate,bc.BusinessType,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName, "+
				" bc.TotalPrice,bc.PdgRatio,bc.ReplaceAccount,getitemname('BankCode',bc.OpenBank) as OpenBank,bc.ReplaceName,"+
				" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,getitemname('BankCode',bc.RepaymentBank) as RepaymentBank,bc.RepaymentName, "+
				"(select typename from business_type where typeno = bc.BusinessType) as ApplyType1,getitemname('BusinessType',bc.productid) as ApplyType,"+
				" PutOutDate,PERIODS,getitemname('RepaymentWay',REPAYMENTWAY) as REPAYMENTWAY,getitemname('YesNo',falg6) as falg6, "+
				" bc.BrandType1,bc.Price1,bc.BrandType2,bc.Price2,getTypeName(bc.BusinessRange1,bc.BusinessType1) as BusinessType1,getTypeName(bc.BusinessRange2,bc.BusinessType2) as BusinessType2,bc.Manufacturer1,bc.Manufacturer2 "+
				" from Business_Contract bc where SerialNo = '"+sObjectNo+"'";

ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		sCustomerID = rs2.getString("CustomerID");
		sCustomerName = rs2.getString("CustomerName");
		sBusinessType = rs2.getString("BusinessType");
		sBusinessSum = DataConvert.toMoney(rs2.getString("BusinessSum"));
		sInteriorCode = rs2.getString("InteriorCode");
		sTotalPrice = DataConvert.toMoney(rs2.getString("TotalPrice"));
		sStoresName = rs2.getString("StoresName");
		sPdgRatio = rs2.getString("PdgRatio");
		sApplyType = rs2.getString("ApplyType");
		sTotalSum=DataConvert.toMoney(rs2.getString("TotalSum"));
		sMonthRepayMent=DataConvert.toMoney(rs2.getString("MonthRepayMent"));
		sRepaymentNo=rs2.getString("RepaymentNo");
		sRepaymentBank=rs2.getString("RepaymentBank");
		sRepaymentName=rs2.getString("RepaymentName");
		sInputUserID=rs2.getString("InputUserID");
		sStores=rs2.getString("Stores");
		
		sOpenBranch=rs2.getString("OpenBank");
		sReplaceName=rs2.getString("ReplaceName");
		sReplaceAccount=rs2.getString("ReplaceAccount");
		sMonthRepayment=rs2.getString("MonthRepayment");
		sPutOutDate=rs2.getString("PutOutDate");
		sPeriods=rs2.getString("PERIODS");
		repaymentWay=rs2.getString("REPAYMENTWAY");
		sfalg6= rs2.getString("falg6");
		
		sInputDate= rs2.getString("inputdate");
		sBusinessType1= rs2.getString("BusinessType1");
		sBrandType1= rs2.getString("BrandType1");
		sPrice1= rs2.getString("Price1");
		sBusinessType2= rs2.getString("BusinessType2");
		sBrandType2= rs2.getString("BrandType2");
		sPrice2= rs2.getString("Price2");
		sManufacturer1= rs2.getString("Manufacturer1");
		sManufacturer2= rs2.getString("Manufacturer2");

				
		if(sCustomerID == null) sCustomerID ="&nbsp;";
		if(sCustomerName == null) sCustomerName ="&nbsp;";
		if(sBusinessType == null) sBusinessType ="&nbsp;";
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
		if(sStores == null) sStores ="&nbsp;";
		if(sReplaceName == null) sReplaceName ="&nbsp;";
		if(sOpenBranch == null) sOpenBranch ="&nbsp;";
		if(sApplyType == null) sApplyType ="&nbsp;";
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

	}
	rs2.getStatement().close();
	
  	String sSql5="select ii.certID,ii.Issueinstitution,ii.MaturityDate,ii.sino,getitemname('EducationExperience',ii.EduExperience) as EduExperience,ii.FamilyTel,"
	           +"ii.PhoneMan,ii.MobileTelephone,ii.EmailAdd,ii.QQNo,getitemname('Marriage',ii.Marriage) as Marriage,ii.Childrentotal,getitemname('FamilyStatus',ii.House) as House,"
	           +"getitemname('AreaCode',ii.nativeplace) as Nativeplace,ii.Villagetown,ii.Street,ii.Community,ii.CellNo,getitemname('AreaCode',ii.FamilyAdd) as FamilyAdd,ii.Countryside,"
	           +"ii.Villagecenter,ii.Plot,ii.Room,ii.WorkCorp,ii.EmployRecord,getitemname('HeadShip',ii.HeadShip) as HeadShip,"
	           +"getitemname('UnitKind',ii.UnitKind) as IndustryType,getitemname('YesNo',ii.Flag2) as Flag2,getitemname('YesNo',ii.Falg4) as Flag4,getitemname('AddNo',ii.Flag8) as Flag8,"
	           +"getitemname('OrgAttribute',ii.CellProperty) as CellProperty,getItemName('Sex',ii.Sex) as sex,ii.WorkTel,getitemname('AreaCode',ii.WorkAdd) as WorkAdd,"
	           +"ii.UnitCountryside,ii.UnitStreet,ii.UnitRoom,ii.UnitNo,ii.CommAdd,getitemname('WorkExperence',ii.JobTotal) as JobTotal,getitemname('WorkExperence',ii.JobTime) as JobTime, "
	           +"ii.SpouseName,ii.SpouseTel,ii.KinshipName,getItemname('FamilyRelativeAccount',ii.RelativeType) as RelativeType, "
	           +"ii.KinshipTel,ii.KinshipAdd,ii.OtherContact,getItemname('RelativeAccountOther',ii.Contactrelation) as RelativeType1,"
	           +"ii.ContactTel,ii.OtherRevenue+ii.FamilyMonthIncome as ZE,ii.OtherRevenue,ii.FamilyMonthIncome,"
	           +"nvl(ii.Alimony,0)+nvl(ii.Houserent,0) as CE from ind_info ii where CustomerID='"+sCustomerID+"'";
	
	
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
 
	String sSql3="select bt.CUSTOMERSERVICERATES,bt.MANAGEMENTFEESRATE,bt.MONTHLYINTERESTRATE,bt.STAMPTAX,bt.MONTHLYINTERESTRATE from business_type bt where typeno = (select businessType from business_contract where serialno = '"+sObjectNo+"')";
	ASResultSet rs4 = Sqlca.getResultSet(sSql3);
	  if(rs4.next()){
		  sCUSTOMERSERVICERATES = rs4.getString("CUSTOMERSERVICERATES");
		  sMANAGEMENTFEESRATE = rs4.getString("MANAGEMENTFEESRATE");
		  sSTAMPTAX = rs4.getString("STAMPTAX");
		  sCreditRate=rs4.getString("MONTHLYINTERESTRATE");
		  
			if(sCUSTOMERSERVICERATES == null) sCUSTOMERSERVICERATES ="&nbsp;";
			if(sMANAGEMENTFEESRATE == null) sMANAGEMENTFEESRATE ="&nbsp;";
			if(sSTAMPTAX == null) sSTAMPTAX ="&nbsp;";
			if(sCreditRate == null) sCreditRate="&nbsp;";

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
	
	sApplyNum = Sqlca.getString(new SqlObject("select count(1) from Business_Contract where CustomerID =:CustomerID and SerialNO <> '"+sObjectNo+"'").setParameter("CustomerID", sCustomerID));
	sAddress = Sqlca.getString(new SqlObject("select getItemName('AreaCode',CITY)||ADDRESS as Address from STORE_INFO where SNO =:SNO").setParameter("SNO", sStores));
	String sPage = Sqlca.getString(new SqlObject("select documentid from ecm_page where objectno =:ObjectNO and objecttype = 'Business' and typeno = '20002'").setParameter("ObjectNO", sObjectNo));

	String path = request.getContextPath(); 
	String requestpath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String sLogo = requestpath+"FormatDoc/Images/122.jpg";
	
	String xcPage = Sqlca.getString(new SqlObject("select DOCUMENTID from ecm_page where typeno = '20002' and objectno =:ObjectNo and rownum = 1 order by MODIFYTIME desc").setParameter("ObjectNo", sObjectNo));
	xcPage = requestpath+xcPage;
	if(repaymentWay.equals("�Ǵ���")){
		sDfile = "&nbsp;";
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 align=center  border=0 cellspacing=0 cellpadding=0  width='800' >	");
	
/* 	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");	
	sTemp.append("<td colspan=1 rowspan=2 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("<td class=td1 rowspan=2 align=center colspan=7 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ֽ���ڷ��������</font></td> ");	
	sTemp.append("<td colspan=2 align=left class=td1 ><img src="+request.getContextPath()+"/barcode?msg="+sObjectNo+"&height=7 width='150' height='40' />&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >��ͬ��ţ�"+sObjectNo+"&nbsp;�������ڣ�"+sInputDate+"&nbsp;</td>");
	sTemp.append("</tr>");

	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >���۵���룺"+sStores+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >���۵����ƣ�"+sStoresName+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >���۹��ʴ��룺"+sInputUserID+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >�������"+sApplyType+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >��ȥ�ڱ���˾�й����δ������룺</b>"+sApplyNum+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >���۵��ַ��"+sAddress+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >��Ʒ���룺"+sBusinessType+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >�ڲ����룺"+sInteriorCode+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>��������</b>&nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >1.������"+sCustomerName+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >2.�Ա�"+sSex+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >3.����֤�ţ�"+sCertID+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >4.��֤���أ�"+sIssueinstitution+"&nbsp;</td>");
	sTemp.append("<td colspan=1 rowspan=3 align=left class=td1 ><div><img src='"+xcPage+"' style='width:120px;height:120px;'/></div></td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >5.����֤��Ч������"+sMaturityDate+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >6.�籣����/ѧ�����룺"+sSino+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >7.�����̶ȣ�"+sEduExperience+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >8.סլ/����绰��"+sFamilyTel+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >9.סլ�绰�Ǽ��ˣ�"+sPhoneMan+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >10.�ֻ���"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >11.�������䣺"+sEmailAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >12.QQ���룺"+sQQNo+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >13.����״����"+sMarriage+"&nbsp;</td>");
	sTemp.append("<td colspan=5 align=left class=td1 >14.��Ů��Ŀ��"+sChildrentotal+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >15.ס��״����"+sHouse+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >16.������ַ��"+sNativeplace+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >17.��/�磺"+sVillagetown+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >18.�ֵ�/�壺"+sStreet+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >19.С��/¥�̣�"+sCommunity+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >20.��/��Ԫ/����ţ�"+sCellNo+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >21.�־�ס��ַ��"+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >22.��/�磺"+sCountryside+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >23.�ֵ�/�壺"+sVillagecenter+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >24.С��/¥�̣�"+sPlot+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >25.��/��Ԫ/����ţ�"+sRoom+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 >26.�־�ס��ַ�Ƿ��뻧����ַ��ͬ��"+sFlag2+"&nbsp;</td>");
	sTemp.append("</tr>");


	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>���ڹ���������</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >27.��Ʒ����(1)��"+sBusinessType1+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >28.Ʒ��(1)��"+sManufacturer1+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >29.��Ʒ�ͺ�(1)��"+sBrandType1+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >30.�۸�(1)(Ԫ)��"+sPrice1+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >31.��Ʒ����(2)��"+sBusinessType2+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >32.Ʒ��(2)��"+sManufacturer2+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >33.��Ʒ�ͺ�(2)��"+sBrandType2+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >34.�۸�(2)(Ԫ)��"+sPrice2+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >35.��Ʒ�ܼۣ�Ԫ����"+sTotalPrice+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >36.�Ը���Ԫ����"+sTotalSum+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >37.�����Ԫ����"+sBusinessSum+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >38.����������"+sPeriods+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >39.ÿ�»���Ԫ����"+sMonthRepayMent+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >40.�״λ����գ�"+sFirstDueDate+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >41.ÿ�»����գ�"+sDefaultDueDay+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >42.�´������ʣ�%����"+sCreditRate+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >43.�¿ͻ�������ʣ�%����"+sCUSTOMERSERVICERATES+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >44.�²���������ʣ�%����"+sMANAGEMENTFEESRATE+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >45.ӡ��˰��%����"+sSTAMPTAX+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>�����˻���Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >46.ָ�������˻��˺ţ�"+sRepaymentNo+"&nbsp;<br></td>");
	sTemp.append("<td colspan=3 align=left class=td1 >47.�������У��������������ĺ�֧�� &nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >48.������"+sRepaymentName+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >49.�ͻ����п���/�˺ţ�"+sReplaceAccount+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >50.�ͻ��������У�"+sOpenBranch+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >51.�ͻ������˻�����"+sReplaceName+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >52.���д��ۻ��"+repaymentWay+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >"+sDfile+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>��λ��Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >53.��λ/ѧУ/����ȫ�ƣ�"+sWorkCorp+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >54.��ְ����/�༶��"+sEmployRecord+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >55.ְλ��"+sHeadShip+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >56.��ҵ���"+sIndustryType+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >57.��λ���ʣ�"+sCellProperty+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >58.��λ�绰��"+sWorkTel+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >59.��λ��ַ��"+sWorkAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >60.��/�磺"+sUnitCountryside+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >61.�ֵ�/�壺"+sUnitStreet+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >62.С��/¥�̣�"+sUnitRoom+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >63.��/��Ԫ/����ţ�"+sUnitNo+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >64.�ʼĵ�ַ��"+sFlag8+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >65.�ܹ�������/��ѧѧϰʱ��(��)��"+sJobTotal+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >66.�ֵ�λ����/����Ӫҵʱ��/�����ҵʱ��(��)��"+sJobTime+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >67.���ֵ�λ�Ƿ����籣��"+sFlag4+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>��ż����ͥ��Ա��Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >68.��ż������"+sSpouseName+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >69.��ż�ƶ��绰��"+sSpouseTel+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >70.��ż��λ���ƣ�</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >71.��ż��λ�绰��</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >72.��ͥ��Ա���ƣ�"+sKinshipName+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >73.��ͥ��Ա���ͣ�"+sRelativeType+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >74.��ͥ��Ա�绰��"+sKinshipTel+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >75.��ͥ��Ա��ϵ��ַ��"+sKinshipAdd+"</td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>������ϵ����Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >76.��ϵ��������"+sOtherContact+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >77.�������˹�ϵ��"+sRelativeType1+"</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >78.��ϵ�绰��"+sContactTel+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>���뼰֧����Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >79.�������ܶԪ����"+sZE+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >80.�������루Ԫ/�£���"+sOtherRevenue+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >81.��ͥ�����루Ԫ����"+sFamilyMonthIncome+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >82.����֧����Ԫ/�£���"+sCE+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>������Ϣ</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >�ṩ���������:&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >��Ʒ��¼��&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >�Ƿ�ǩ����Ȩ��:"+sfalg6+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >���˾�����ȫ������Ϊ����ǩ����������е���Ӧ���Ρ���������ϸ�Ķ�����ȫ�˽⡶���ڹ����Ѵ�������Э�顷��������Ը������صĺ�ͬ�涨��<br>���˱�֤�ڴ˱�����д��ȷ�ϵ����ݼ�������ˡ���Ǫ�����ṩ�������������ȫ����ʵ����Ч���籾���ṩ������ϣ����е��ɴ������һ�����μ���ʧ�������ڴ�ͬ������˺Ͱ�Ǫ���ڰ�����ط��ɷ���Ĺ涨������Ȩ�������ͱ��˵ĸ���������Ϣ�������������ڱ���������µ���Ϣ��ͬʱ����Ȩ�����˺Ͱ�Ǫ�������κο��ܵ���Դ��ѯ���˼���ż������������йصĸ�����Ϣ�͸���������Ϣ����ز�ѯ�������;�����ڴ������ʹ��������<br>����ͬ�����򵥷���ȡ������򲻾߱�������������벻����׼���������������ύ�����������˻����ˣ��ɰ�Ǫ���ڴ�������������Ȩ�ܾ��������������������κ�ԭ����͡�</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >���۹�������: &nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >���۹���ǩ����&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >�ͻ�ǩ��:&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >����:&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<div>");
	sTemp.append("<br>");
	sTemp.append("<br>");
	sTemp.append("<br>");
	sTemp.append("<br>");
	sTemp.append("</p>");
	sTemp.append("</div>");
	
	if(repaymentWay.equals("�Ǵ���")){
		
		sTemp.append("<br>");
		sTemp.append("<br>");
		sTemp.append("<br>");
		sTemp.append("<br>");
	}
	
	sTemp.append("<table class=table1 align=center  border=0 cellspacing=0 cellpadding=2  width='800'>");	
	sTemp.append("<div>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 class=td1 ><font style=' font-size: 8pt;' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ֽ�������Ѵ�������Э��<br>"
		+"	һ����������1����̩�����������ι�˾�����¼�ơ������ˡ���Ϊ������������Ч��������̩���У������й�����ҵ�ල����ίԱ��䲼�ġ����й�˾�����취����ʮ�����Ĺ涨�����Է������д���������������˷��ŵĴ����ʽ���Դ�ڡ���̩-����ϵ�С��Ǫ���д��һָ����;�ʽ����С����µ������ʽ�2���ڱ���ͬ�·�ǩ������Ȼ�˽���ˣ����¼�ơ�����ˡ����������������һ�ʡ����ڹ�����������������¼�ơ�������������������������һ�����������Ĵ�����ڴӡ�������������е������̣��������۵㡱��������������������е���Ʒ������ͳ�ơ���Ʒ������3�������Ը��Ƹ�������а�Ǫ���ڷ������޹�˾�����¼�ơ���Ǫ���ڡ����������ṩ�뱾Э�����´�����صĲ����������Ϳͻ�������������ݰ����������ڴ�����˽��մ����˷��ŵĴ������Ϊ��������������е�������֧����Ʒ�ĶԼ۵ȡ�4�����������������Ǫ����ǩ��ġ������Ŵ�����Э�顷��Լ����Ƹ���Ǫ����Ϊ���ṩ�Ƽ�����ˡ���Ϊ�����˻�������𡢴�Ϊ��ȡ�������Ϣ�����ݱ�Э��Լ��֪ͨ�������Ƿ��ȷ���5����������ͬ�������˷��Ŵ���ģ������ͬ�Ⲣȷ�����£���1����Ȩ��Ǫ���ڴ�����մ����˷��ŵĴ���𣬲��Ҵ��������Ǫ����ָ���Ĵ�������˻������������Ϊ����ųɹ�����2��ͬʱ����Ȩ��Ǫ��������Ϊ����˴�Ϊ���յĴ����һ�����������������֧����Ʒ�ۿ������𣩣���Ϊ����˹�����ƷӦ֧���Ĳ��ֶԼۣ�����˵Ĵ������ӦΪ��Ʒ�ܼۿ۳�������Ը�����6������ˡ���Ǫ���ڡ��������ڴ�ȷ�ϣ����������Ǫ����ָ���Ĵ�������˻���������𣬼���Ϊ��������������ϱ���ͬ���µķſ�����7�������ͬ�ⰴ�����֧���������Ϣ����������ѡ��ͻ�����ѡ����ɽ����У�����������Ȩ��Ǫ���ڴ�Ϊ��ȡ�����֧���Ĵ��Ϣ�ȿ�������������Ϣ�����ɽ����У�����������˻�����������ڴ�ȷ��֪���������ˣ���ͬ�ⰴ����ͬԼ�����Ǫ����ָ�����˻�����ǰ�����Ϣ�Ȼ������ί�а�Ǫ�����������֧�����Ϣ�ȿ�������Ӧ���Ǫ����֧����������ѡ��ͻ�����ѡ������ˡ���Ǫ���ڡ�����˽�һ����ͬȷ���������<br>"
		+"	�����������������붨��1������𣺼�������������С�����𡱣�Ϊ����˹������������������ƷӦ��������֧������Ʒ�ܼۿ�۳���������Ը���Ϊ�����壬�ô���𲻺������������������֧���Ľ���������������еġ��Ը��������������ݱ���ͬԼ�������Ӧ֧������Ϣ�������Ӧ���Ǫ����֧���Ĳ�������ѡ��ͻ�����ѡ�2���������ʣ��������ڼ����õĴ������ʣ��������������й����ʵĹ涨�����ԡ�����������С��´������ʡ�Ϊ׼��3������������ÿ�»�����������������С������������͡�ÿ�»������������԰��µȶϢ����ķ�ʽ������ȫ���������Լ���������б���ͬ����������֧���������ɽ���⣩����ķ��������Լ�ÿ��Ӧ֧�����ڿ��ԡ������������Ϊ׼��4�������ڼ䣺���ӽ���ˡ������������֮�������ڿ�ʼ�����һ���ڿ�ĵ�����Ϊֹ�������ڼ����������������Ƿ����ͬ���µ��κο���仹�����񲢲���˶������5���ڿ�������ÿ����Ӧ������˼���Ǫ����֧���Ŀ����Ӧ������������µġ�ÿ�»������ڿ����Ա�Э���������1��Լ��Ϊ׼��6��������գ���������������е�һ���ڿ�Ļ����ա������״λ����ա���������ÿһ���ڿ���ա�����ÿ�»����ա���Ϊÿһ�����µ�ͬһ�죨Ϊ�������˻������������Ϊĳ�µ�29�ա�30�ա�31�գ����״λ�����ΪЭ��ǩ���º�ڶ����µ�2�ա�3�ա�4�գ�֮���ÿ�»�������Ϊ��Ӧ�·ݵ�2�ա�3�ա�4�գ���ǰ����ͳ�ơ�������ա���7������ͬ�����������ڹ����Ѵ�������Э�顷���������Լ�ǰ��Э����κκ�������Լ�����޸ĵĺϳƣ�����ͬ�ĸ������������ڹ��������������8��ָ�������˻�������Ǫ���ڿ����Ľ���˻����ʽ�����˻���������ί�а�Ǫ�����ø��˻���Ϊ��ȡ����˳����Ĵ��Ϣ�ȿ�����������˻��������Ϣ��ί�а�Ǫ���ڽ�һ��������˻����������˻���Ϣ�ԡ���������ļ���Ϊ׼��<br>"
		+"	������Ǫ���ڷ���1���ͱ���ͬ����Ǫ�����������ṩ�������ݰ��������������Ϳͻ����񣺡�����������1�����Ѵ�����ѯ���񣻣�2����������Ƽ��������ˣ���3���ͻ����Ʒ��񣻣�4�����մ������񣬰���������˽��մ����˷��ŵĴ�����Ҵ�����˽�����������������������е�������֧����Ʒ�ĶԼۡ���	�ͻ�����1���ͻ�ֽ���ĵ��������ĵ����ܡ����ķ��񣻣�2���ͻ���������ά�����񣻣�3���ͻ�������Ϣ��ѯ���񣻣�4���ͻ��������Ѽ�����֪ͨ����2�����������񣬰�Ǫ������������ȡ��������ѡ��ͻ�����ѣ���Ǫ������Ȩ����������������ѺͿͻ�����ѵĽ�����ȡ��ʽ��ǰ�������ڴ����ڼ��ڰ�����ȡ��������ÿһ���ڿ��С�Ϊ�����壬ǰ�����ý�ָ����������������Ӧ���Ǫ����֧���ķ��á�<br>"
		+"	�ġ����������1�������֪Ϥ��ͬ�⣬ÿ��Ӧ֧�����ڿ������£�1������3����֮�ͣ��ڿ���ԪΪ��С��λ����1�������Ӧ������˳����ģ���Ǫ���ڴ�Ϊ��ȡ��ÿ�´�������Ϣ��ÿ�³�������ϢΪʣ��������������ʣ����԰��µȶϢ����ķ�ʽ��������2�������Ӧ���Ǫ����֧����ÿ�²�������ѣ�Ϊ��ʼ�������ԡ������������֮���²���������ʡ��Ľ���3�������Ӧ���Ǫ����֧����ÿ�¿ͻ�����ѣ�Ϊ��ʼ�������ԡ������������֮���¿ͻ�������ʡ��Ľ�2����������ڡ���������ϲ�ѡ�����д��ۣ������õ�������3��͵�4���Լ������������ڡ����������ѡ�����д��ۣ������õ�������5��͵�6���Լ����3�������Ӧ��ÿһ���ڿ��ڻ������֮ǰ֧������������������еİ�Ǫ����ָ�������˻���4������ʱ����ָ�������˻�ʵ���յ������֧������ĵ���ʱ��Ϊ׼������������ǰ���ڿ�ת��ָ�������˻�����ȷ���ڿ�׼ʱ���ˡ�5���������Ȩ��Ǫ���ڴӽ���˵������˻����۵��ڵ��ڿ���б���ͬ���µ���Ӧ������������������һ��֪ͨ����˻��ߵõ���ͬ�⡣���д��۲������ڻ�����ա�������ڴ�ȷ������Ȩ��Ǫ���ڻ����ڿ�������˻���Ϣ���£������У�"+sRepaymentNo+";�˻������������������ĺ�֧��;�˺ţ�"+sRepaymentName+";6������κα���ͬ���µ����д���ʧ�ܣ����ۺ���ԭ�����£�������ڱ���ͬ���µĻ������񲻵���˶����⣬���б�Ҫ�����Ӧ��������������ʽ�����峥ծ��7�����������ǩ������ͬʱ��������δ��������Ѵ���Ҹ����Ѵ����ͬ�Ľ��ڷ���˾Ϊ�����а�Ǫ���ڷ������޹�˾����	���������ڡ����������ѡ�����д��ۣ������˶�����δ����Ĵ����ڴ���Ȩ���д��ۣ����д��۵��˻����Խ����������Ȩ���˻�Ϊ׼����	���������ڡ���������ϲ�ѡ�����д��ۣ������˶�����δ����Ĵ����ڴ�ͬ��ȡ������֮ǰ��Ȩ�����д��ۡ�8������ָ�������˻��Ŀ����������˳���峥����ծ�񣨰��������ǩ���������������а�Ǫ���ڷ������޹�˾��Ϊ���ڷ���˾�����Ѵ����ͬ�����Σ�����	����ծ������ĸ����������˳�������峥�����ɽ����У�����������ѡ��ͻ�����ѡ���Ϣ������𡣡�	���ۺ�ͬǩ���Ⱥ��ȵ��ڵ�ծ���ȳ�������	������Ѵ�����ڿ�ͬʱ���ڣ���ǩ������Ѵ����ȳ�������	ͬʱ���ڵĶ�����Ѵ����У��������������ǰ��������Ѵ����ȳ�������	��������Ѵ�����ͬ��ǩ���ҽ����֧���Ŀ������ͬʱ֧��ȫ��Ӧ��δ������ģ�����ʴ������������9�������Ӧ���Ʊ��ܱ���ͬ�����ѻ�����ĸ���֤���������˵Ļ�����������ģ��ɽ���˶��仹������е���֤���Ρ�10.   �緢����ɿ�������������ʵ�ʻ�������Ӧ�����������Ȩ���Ǫ���������˻���֧���Ľ��������Ӧ�ṩ��Ӧ֤�����е��˿�ʱ���������л�������ѡ�11������ͬ������֮�κι涨���ɱ���Ϊ�������˶Ա���ͬ�����κο���ĳ������������ɽ�<br>"
		+"	�塢��ǰ����1���������Ȩ��ǰ��������ͬ���µĴ����ֹ����ͬ����ǰ����ָ��ĳ�·ݣ�����ǰ�����·ݡ����Ļ�����յ����֮ǰһ����֧�����¿������ǰ����������������ǰ�����·ݵ�Ӧ����Ϣ�����ɽ����У�����������ѺͿͻ�����ѣ��񱾺�ͬ����������δ�����Ĵ���𣻡���ǰ����������һ��Ԫ��2���������ǰ���Ӧ����ǰ�����·ݻ�����յ�ʮ�����Ȼ��֮ǰ�µ��Ǫ����������ǰ�����Ȩ��������˰�����ǰ������������Ǫ���ڵĿͷ���Ա����֪����˾������ǰ�����3���������ǰ����仹�ʽ�������Լ���ĳ����ڿʽ��ͬ������ǰ����ʱ�����д��ۿ����ڻ������֮ǰ������4����ԥ�ڣ������ˡ������������֮���������ʮ�����Ȼ���ڣ����������ǩ������������죩���Ǫ����������ǰ�����������ʮ�����Ȼ���ڽ������ȫ���ָ�������˻��������ˡ���Ǫ���ڲ���ȡ�κ���Ϣ�ͷ��á�5��������ͬ��������4�����⣬ֻ�н�����ڱ���ͬ�Լ��κ������������а�Ǫ���ڷ������޹�˾��Ϊ����ڷ���˾�ĺ�ͬ����û���κ����ڿ���ʱ���ſ�������ǰ������������ǰ����ͬ�������·������ڣ��κ���ǰ����Զ�ȡ����<br>"
		+"	�������ڻ���1����������δ���б���ͬ���µĸ���������Ӧ����������Ƿ���Ӧ�����ձ���ͬ�������Ĺ涨�������֧�����ɽ����ɽ��������������㣬����������ָ���ʴ���������һ��δȫ��֧�����ڿ������ڵ�������2�����ʴ�������������10�죬����30Ԫ����ҵ����ɽ�����������30�죬���Ѳ��������ɽ�������ٶ������80Ԫ����ҵ����ɽ�����������60�죬�ٶ������100Ԫ����ҵ����ɽ�����������90�죬�ٶ������160Ԫ����ҵ����ɽ�3����������ں���֧���Ŀ�����������峥�Ѿ���Ƿ���ڿ�����ɽ𣬹�����������������˶����١����ǣ�������Ƿ���ڿδȫ���峥��������������������ۼӼ��㲢�ҵ��ﵽ����ʱ���ʱ�����������������ɽ�<br>"
		+"	�ߡ�ǿ����ǰ����1�������κ��¼���������������Ȩ��Ǫ���ڿɴ���������Ҫ����������һ���Գ�������ͬ���µ�ȫ�������1�������Υ����Э�����µ��κ�Լ�����������ڱ�Э�����µĳ����뱣֤����ʵ����2��������������Ǫ���ڡ�������ǩ������������ͬ���·����ش�ΥԼ����3����Ǫ����ǿ�һ��ɽ�����Դ�����������ʹ����������ѡ��ͻ�����ѿ��ܴ��¹��κ���թ��Ϊ�����˿������������ݱ���ͬ���������ڴ�ͬ�Ⲣȷ�ϱ�����������԰�Ǫ���ڵ������ж�Ϊ׼����4�������հ�Ǫ���ڵĺ����жϣ�����˷������ܶԴ����˻��Ǫ���ڵ�Ȩ����������ɸ���Ӱ����κ��������Ρ�2�������������1������η����ڴ����˷��Ŵ���֮ǰ�������˿��Խ������ͬ�����Ҵ��������跢�Ŵ�����߳е��κ��������Ρ�3�����������ĳһ���ڿ�Ļ������90��֮����δ��ȫ�����ñ��ڿ���Ǫ���ڿ���֪ͨ����˱���ͬ��ǰ��ֹ����ֹ��Ϊ�ñ�δ���ڿ�Ļ���������90�죬��������Ȩ��Ǫ����֪ͨ�����Ӧ����һ���Գ������¿����	������ͬ��ǰ��ֹ�յ�Ӧ����Ϣ�����ɽ�Ͳ�������ѡ��ͻ�����ѣ��񱾺�ͬ����������δ�����Ĵ����4�����������������δ��������Ѵ���Ҹ����Ѵ����ͬ�Ľ��ڷ���˾Ϊ�����а�Ǫ���ڷ������޹�˾�����������Ѵ����ͬ����ǰ��ֹҲ�����±���ͬ����ǰ��ֹ��<br>"
		+"	�ˡ������뱣֤1������˳�������֤��������Ϊ����Ŀ���ṩ��������Ϣ��������Ʒ��Ϣ���������������д��������Ϣ����������ʵ��׼ȷ�����������ԡ��񲻴����κο���Ӱ���������õ�����������˴������ڽ��л����п��ܷ��������ϡ��ٲá���������ȡ��񱾴�����;�����ڹ������������������Ʒ���������κγ�������ʵ����׼ȷ�����µĴ����ˡ���Ǫ���ڵ��κ���ʧ����Ӧ�ɽ��������⳥��2�������Ӧ������ϴ����˺Ͱ�Ǫ���ڶԽ���˵����á�����ʹ������������������мල��3���������Ȩ��Ǫ���ڼ�������Ϊ�������������ݴ��������տ��ơ������˿���յ��κ�Ŀ�Ĵ��κ����ݿ⣨�����������й��������и���������Ϣ�������ݿ⣩��ѯ����˵��ʲ������ż�����������Ϣ�����������������ϵͳ�����������Ϣ���Լ���Ǫ����Ϊ�������ṩ�����Ŀ��ͨ���κη�ʽʹ���������Ϣ��ϵ����˻�����Ȩ��������ϵ����ˡ�4����������ΥԼ�������ͬ���Ǫ����ֱ�ӻ��߾��ɵ�������ͨ������ݷá��绰���ʼġ�����ȺϷ���ʽ���ѽ���˻��߶��ٽ���˶�ΥԼ��Ϊ���и���������ͬ���Ǫ������õ�������¶��ΥԼ�¼���5������˳��ϣ�����ͬ�����ķ��ɹ�ϵ�����˸�������֮���������ͬ��ϵ����ȫ�����ġ���������ͬ��ϵ����Ч��������Ӱ�챾��ͬ�ķ���Ч�����ʽ���˲�������������֮����κξ��ף������漰��Ʒ�������ۺ����Ϊ�ɾܾ����б���ͬ���µ��κ�����6������������ϵĽ������Ϣ�����κα仯������˸����ʲ����߲���״�������ش�仯�����߷����˿���Ӱ���������б���ͬ����������κ��������ʱ������˾�Ӧ�������Ȼ����֪ͨ��Ǫ���ڡ�7.  �����ˡ���Ǫ���ڰ��ս����ǩ�𱾺�ͬʱ�ڡ����������Ԥ�����־�ס��ַ��ͨ�ŷ�ʽ�����߽�������������ͨ����Ǫ���ڷ�������֪ͨ��Ǫ���ڡ������˱���ĵ�ַ��ͨ�ŷ�ʽ�������뱾��ͬ�йص�֪ͨ�������ˡ���Ǫ�����ԹҺ��ŷ���֪ͨ�ģ��ڹҺ��Ż�ִ��ʾ��Ϊ��Ч�ʹ���ʼ�����ŷ�ʽ������֪ͨ�����ʼ�����ŷ��ͳɹ�֮����Ϊ��Ч�ʹ<br>"
		+"	�š�������1�����򱾺�ͬ����Ļ��뱾��ͬ�йص��κ����飬Ӧͨ��Э�̽������Э�����޷�������κ�һ��Ӧ���ͬǩ�������Ժ�������ϡ����߷�Ӧ�е�Ϊ�������������������з��ã����������������Ϸѡ���ʦ�ѡ���֤�ѡ���ͨ�ѵȡ�2�����������ڽ������֮�У���ͬ����Ӧ�����������ڱ���ͬ���µ���������<br>"
		+"	ʮ������Լ��1���籾��ͬ�κ�����֮һ��˾�����ػ���������Ȩ�����϶�Ϊ��Ч���������Ӱ�������������Ч�ԡ�2. �������Ȩ��Ǫ���ڱ������˵ı���ͬԭ����ͬ���Ǫ�����ڽ���˸��屾��ͬ���µ�ȫ������֮�����ٸ�ԭ����3����Ǫ���ڿɲ�ʱ���������ṩ���ڱ���ͬ���е��Ż�����뱾��ͬ��Լ����ȣ����Ż�����Խ���˸��������������ȷ�Ϻ󣬸��Ż������Ч��4. �����ȷ���Ѿ������Ķ�����ȫ���ⱾЭ���еĸ�������Ҷ�Э������������ƽ�������ε��������յ������˺Ͱ�Ǫ���ڵ�����ע����ر�˵����<br>"
		+"�����ˣ���̩�����������ι�˾&nbsp;&nbsp;&nbsp;&nbsp;����ˣ�&nbsp;&nbsp;&nbsp;��Ǫ���ڣ������а�Ǫ���ڷ������޹�˾<br>��ͬǩ���գ�&nbsp;&nbsp;&nbsp;&nbsp;��ͬǩ���أ��㶫ʡ������ǰ����ۺ�����</td>");
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
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>