 <%@ page contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
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
	//int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
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
String sMaturityDate="";//���֤��Ч��
String sSino="";//�籣����
String sEduExperience="";//�����̶�
String sFamilyTel="";//סլ������绰
String sPhoneMan="";//סլ�绰�Ǽ���
String sMobileTelephone="";//�ֻ�
String sEmailAdd="";//��������
String sQQNo="";//QQ��
String sMarriage="";//����״��
String sChildrentotal="";//��Ů��Ŀ
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
String sCUSTOMERSERVICERATES="",sMANAGEMENTFEESRATE="",sPdgRatio="",sSTAMPTAX="",sUnitStreet="";
String sReplaceAccount ="";//�ͻ������˺�
String sOpenBranch="";//�ͻ�������
String sReplaceName="",sWorkCorp="",sEmployRecord="",sCommAdd="",sJobTotal="",sJobTime="",sFlag4="";
String sHeadShip="",sIndustryType="",sCellProperty="",sWorkTel="", sWorkAdd="",sUnitCountryside="",sUnitRoom="",sUnitNo="";
String sSpouseName="",sSpouseTel="",sKinshipName="",sRelativeType="",sKinshipTel="",sKinshipAdd="",sOtherContact="",sRelativeType1="";
String sContactTel="",sZE="",sOtherRevenue="",sFamilyMonthIncome="",sCE=""; 
	 //��õ��鱨������
	String sSql = "select bc.CustomerID,bc.CustomerName,bc.stores,bc.inputuserid,bc.BusinessType,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName, "+
					" bc.TotalPrice,bc.CreditRate,bc.PdgRatio,bc.ReplaceAccount,getBankName(OpenBranch) as OpenBranch,bc.ReplaceName,"+
					" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,bc.RepaymentBank,bc.RepaymentName, "+
					"getitemname('BusinessType',bc.BusinessType) as ApplyType from Business_Contract bc where SerialNo = '"+sObjectNo+"'";

	
	String sSql2="select ii.certID,ii.Issueinstitution,ii.MaturityDate,ii.sino,ii.EduExperience,ii.FamilyTel,"
	           +"ii.PhoneMan,ii.MobileTelephone,ii.EmailAdd,ii.QQNo,ii.Marriage,ii.Childrentotal,ii.House,"
	           +"ii.nativeplace,ii.Villagetown,ii.Street,ii.Community,ii.CellNo,getitemname('AreaCode',ii.FamilyAdd) as FamilyAdd,ii.Countryside,"
	           +"ii.Villagecenter,ii.Plot,ii.Room,ii.WorkCorp,ii.EmployRecord,getitemname('HeadShip',ii.HeadShip) as HeadShip,"
	           +"getitemname('IndustryType',ii.UnitKind) as IndustryType,"
	           +"ii.CellProperty,getItemName('Sex',ii.Sex) as sex,ii.WorkTel,getitemname('AreaCode',ii.WorkAdd) as WorkAdd,"
	           +"ii.UnitCountryside,ii.UnitStreet,ii.UnitRoom,ii.UnitNo,ii.CommAdd,ii.JobTotal,ii.JobTime, "
	           +"ii.SpouseName,ii.SpouseTel,ii.KinshipName,getItemname('FamilyRelativeAccount',ii.RelativeType) as RelativeType, "
	           +"ii.KinshipTel,ii.KinshipAdd,ii.OtherContact,getItemname('RelativeAccountOther',ii.Contactrelation) as RelativeType1,"
	           +"ii.ContactTel,ii.OtherRevenue+ii.FamilyMonthIncome as ZE,ii.OtherRevenue,ii.FamilyMonthIncome,"
	           +"ii.Alimony+ii.Houserent as CE from ind_info ii where CustomerID='"+sCustomerID+"'";
	
	String sSql3="select bt.CUSTOMERSERVICERATES,bt.MANAGEMENTFEESRATE,bt.STAMPTAX from business_type bt where typeno = (select businessType from business_contract where serialno = '"+sObjectNo+"')";
	 
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	String sDay = StringFunction.getToday().replaceAll("/","");
	sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
    sTemp.append("<div id=reporttable>");
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
		sCreditRate=rs2.getString("CreditRate");
		sOpenBranch=rs2.getString("OpenBranch");
		sReplaceName=rs2.getString("ReplaceName");
				
		if(sCustomerID == null) sCustomerID ="&nbsp;";
		if(sCustomerName == null) sCustomerName ="&nbsp;";
		if(sBusinessType == null) sBusinessType ="&nbsp;";
		if(sBusinessSum == null) sBusinessSum ="&nbsp;";
		if(sInteriorCode == null) sInteriorCode ="&nbsp;";
		if(sStoresName == null) sStoresName ="&nbsp;";
		if(sCreditRate == null) sCreditRate="&nbsp;";
		if(sTotalSum == null) sTotalSum ="&nbsp;";
		if(sMonthRepayMent == null) sMonthRepayMent ="&nbsp;";
		if(sRepaymentNo == null) sRepaymentNo ="&nbsp;";
		if(sRepaymentBank == null) sRepaymentBank ="&nbsp;";
		if(sRepaymentName == null) sRepaymentName ="&nbsp;";
		if(sTotalPrice == null) sTotalPrice ="&nbsp;";
		if(sInputUserID == null) sInputUserID ="&nbsp;";
		if(sStores == null) sStores ="&nbsp;";

	}
	
	rs2.getStatement().close();
	 
	ASResultSet rs3 = Sqlca.getResultSet(sSql2);
	if(rs3.next()){
		sSex=rs3.getString("Sex");
		sCertID=rs3.getString("CertID");
		sIssueinstitution = rs3.getString("Issueinstitution");
		sMaturityDate = rs3.getString("MaturityDate");
		sSino = rs3.getString("Sino");
		sEduExperience = rs3.getString("EduExperience");
		sFamilyTel = rs3.getString("FamilyTel");
		sPhoneMan = rs3.getString("PhoneMan");
		sMobileTelephone = rs3.getString("MobileTelephone");
		sEmailAdd = rs3.getString("EmailAdd");
		sQQNo = rs3.getString("QQNo");
		sMarriage = rs3.getString("Marriage");
		sChildrentotal = rs3.getString("Childrentotal");
		sHouse = rs3.getString("House");
		sNativeplace=rs3.getString("Nativeplace");
		sVillagetown=rs3.getString("Villagetown");
		sStreet = rs3.getString("Street");
		sCommunity = rs3.getString("Community");
		sCellNo = rs3.getString("CellNo");
		sFamilyAdd = rs3.getString("FamilyAdd");
		sCountryside = rs3.getString("Countryside");
		sVillagecenter = rs3.getString("Villagecenter");
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
		sZE =rs3.getString("ZE");
		sOtherRevenue=rs3.getString("OtherRevenue");
		sFamilyMonthIncome = rs3.getString("FamilyMonthIncome");
		sCE = rs3.getString("CE");
		
		if(sSex == null) sSex ="&nbsp;";
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
		if(sChildrentotal == null) sChildrentotal ="&nbsp;";
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
	
	}
	
	rs3.getStatement().close();

	ASResultSet rs4 = Sqlca.getResultSet(sSql3);
  if(rs4.next()){
	  sCUSTOMERSERVICERATES = rs4.getString("CUSTOMERSERVICERATES");
	  sMANAGEMENTFEESRATE = rs4.getString("MANAGEMENTFEESRATE");
	  sSTAMPTAX = rs4.getString("STAMPTAX");
	  sReplaceAccount = rs4.getString("ReplaceAccount");
  }
	
  rs4.getStatement().close();
	
	
	
	sTemp.append("<table class=table1 width='660' align=center border=0 cellspacing=0 cellpadding=2  >	");
/* 		sTemp.append("<tr>");
		sTemp.append("<td colspan=4 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
		sTemp.append("</tr>"); */
	//	sTemp.append("<tr>");	
	//	sTemp.append("<td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ֽ���ڷ��������</font></td> ");	
	//	sTemp.append("</tr>");

/* 		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>���۵���룺</b>"+sStores+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>���۵����ƣ�</b>"+sStoresName+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>���۹��ʴ��룺</b>"+sInputUserID+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>�������</b>"+sApplyType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>��ȥ�ڱ���˾�м��δ������룺</b>"+sApplyNum+"&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=4 align=left class=td1 >���۵��ַ��"+sAddress+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >��Ʒ���룺"+sBusinessType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >�ڲ����룺"+sInteriorCode+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >������;��&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>��������</b>&nbsp;</td>");
		sTemp.append("</tr>");
	
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >1.������"+sCustomerName+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >2.�Ա�"+sSex+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >3.���֤�ţ�"+sCertID+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >4.��֤���أ�"+sIssueinstitution+"&nbsp;</td>");
		sTemp.append("<td colspan=2 rowspan=3 align=left class=td1 >��Ƭ&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >5.���֤��Ч�ڣ�"+sMaturityDate+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >6.�籣����/ѧ�����룺"+sSino+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >7.�����̶ȣ�"+sEduExperience+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >8.סլ/����绰��"+sFamilyTel+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >9.סլ�绰�Ǽ��ˣ�"+sPhoneMan+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >10.�ֻ���"+sMobileTelephone+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >11.�������䣺"+sEmailAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >12.QQ���룺"+sQQNo+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >13.����״����"+sMarriage+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >14.��Ů��Ŀ��"+sChildrentotal+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >15.ס��״����"+sHouse+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >16.������ַ��"+sNativeplace+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >17.��/�磺"+sVillagetown+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >18.�ֵ�/�壺"+sStreet+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >19.С��/¥�̣�"+sCommunity+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >20.��/��Ԫ/����ţ�"+sCellNo+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >21.�־�ס��ַ��"+sFamilyAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >22.��/�磺"+sCountryside+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >23.�ֵ�/�壺"+sVillagecenter+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >24.С��/¥�̣�"+sPlot+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >25.��/��Ԫ/����ţ�"+sRoom+"&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 >26.�־�ס��ַ�Ƿ��뻧����ַ��ͬ��"+sFlag2+"&nbsp;</td>");
		sTemp.append("</tr>");


		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>�ֽ������ϸ</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >19.�����"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >20.����������"+sPeriods+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >21.ÿ�»���&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >22.�״λ����գ�&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >23.ÿ�»����գ�&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >24.�´������ʣ�"+sCreditRate+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >25.�¿ͻ�������ʣ�"+sCUSTOMERSERVICERATES+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >26.�²��������ʣ�"+sMANAGEMENTFEESRATE+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >27.���������ʣ�"+sPdgRatio+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >28.ӡ��˰��"+sSTAMPTAX+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>�����˻���Ϣ</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >29.ָ�������˺ţ�"+sRepaymentNo+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >30.�������У�"+sRepaymentBank+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >31.������"+sRepaymentName+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >32.�ͻ����п���/�˺ţ�"+sReplaceAccount+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >33.�ͻ��������У�"+sOpenBranch+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >34.�ͻ������˻�������"+sReplaceName+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >35.���д��ۻ��&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 ><b>������ʾ�ı�</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>��λ��Ϣ</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >36.��λ/ѧУ/����ȫ�ƣ�"+sWorkCorp+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >37.��ְ����/�༶��"+sEmployRecord+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >38.ְλ��"+sHeadShip+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >39.��ҵ���"+sIndustryType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >40.��λ���ʣ�"+sCellProperty+"&nbsp;</td>");

		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >41.��λ�绰��"+sWorkTel+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >42.�־�ס��ַ��"+sWorkAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >43.��/�磺"+sUnitCountryside+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >44.�ֵ�/�壺"+sUnitStreet+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >45.С��/¥�̣�"+sUnitRoom+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >46.��/��Ԫ/����ţ�"+sUnitNo+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >47.�ʼĵ�ַ��"+sCommAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >48.�ܹ�������/��ѧѧϰʱ��(��)��"+sJobTotal+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >49.�ֵ�λ����/����Ӫҵʱ��/�����ҵʱ��(��)��"+sJobTime+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >50.���ֵ�λ�Ƿ����籣��"+sFlag4+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>��ż����ͥ��Ա��Ϣ</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >47.��ż������"+sSpouseName+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >48.��ż�ƶ��绰��"+sSpouseTel+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >49.��ż��λ���ƣ�&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >50.��ż��λ�绰��&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >51.��ͥ��Ա���ƣ�"+sKinshipName+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >52.��ͥ��Ա���ͣ�"+sRelativeType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >53.��ͥ��Ա�绰��"+sKinshipTel+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >54.��ͥ��Ա��ϵ��ַ��"+sKinshipAdd+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>������ϵ����Ϣ</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>���뼰֧����Ϣ</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >55.��ϵ��������"+sOtherContact+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >56.�������˹�ϵ��"+sRelativeType1+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >57.��ϵ�绰��"+sContactTel+"&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >58.�������ܶԪ����"+sZE+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >59.�������루Ԫ/�£���"+sOtherRevenue+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >60.��ͥ�����루Ԫ����"+sFamilyMonthIncome+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >61.����֧����Ԫ/�£���"+sCE+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>������Ϣ</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >�ṩ���������&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >��Ʒ��¼��&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >�Ƿ�ǩ����Ȩ��&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 >���˾�����ȫ������Ϊ����ǩ��������е���Ӧ���Ρ���������ϸ�Ķ�����ȫ�˽⡶�������Ѵ����ط����ͬ��������������������Ը������صĺ�ͬ�涨��<br>���˱�֤�ڴ˱�����д��ȷ�ϵ����ݼ�������ˡ��ͻ�����Ӧ���ṩ�������������ȫ����ʵ����Ч���籾���ṩ������ϣ����е��ɴ������һ�����μ���ʧ��<br>�����ڴ�ͬ������˺Ϳͻ�����Ӧ�̰�����ط��ɷ���Ĺ涨������Ȩ�������ͱ��˵ĸ���������Ϣ�������������ڱ���������µ���Ϣ��ͬʱ����Ȩ�����˺Ϳͻ�����Ӧ�����κο��ܵ���Դ��ѯ���˼���ż������������йصĸ�����Ϣ�͸���������Ϣ����ز�ѯ�������;�����ڴ������ʹ������<br>����ͬ�����򵥷���ȡ������򲻾߱�������������벻����׼��������������ύ�����������˻����ˣ��ɿͻ�����Ӧ�̴�����������Ȩ�ܾ��������������������κ�ԭ����͡�</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >���۹������� &nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >���۹���ǩ����&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >�ͻ�ǩ��:&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >����:&nbsp;</td>");
		sTemp.append("</tr>");
*/
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
