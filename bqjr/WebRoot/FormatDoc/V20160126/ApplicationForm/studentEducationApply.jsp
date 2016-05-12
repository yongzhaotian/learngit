<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@page import="com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		还款说明书
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
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
String sStores="";//销售点代码
String sInteriorCode = "";//内部代码
String sTotalPrice = "";//商品总价（元）
String sStoresName = "";//销售点名称
String sApplyType="";//申请类型
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
String sCUSTOMERSERVICERATES="",sMANAGEMENTFEESRATE="",sPdgRatio="",sSTAMPTAX="",sUnitStreet="";
String sReplaceAccount ="";//客户银行账号
String sOpenBranch="",sInputDate="",sBusinessType1="",sBrandType1="",sPrice1="",sBusinessType2="",sBrandType2="",sPrice2="",sBusinessType3="",sBrandType3="",sPrice3="",sFlag8="",sManufacturer1="",sManufacturer2="",sManufacturer3="";//客户开户行
String sReplaceName="",sWorkCorp="",sEmployRecord="",sCommAdd="",sJobTotal="",sJobTime="",sFlag4="";
String sHeadShip="",sIndustryType="",sCellProperty="",sWorkTel="", sWorkTelPlus="",sWorkAdd="",sUnitCountryside="",sUnitRoom="",sUnitNo="";
String sSpouseName="",sSpouseWorkCorp="",sSpouseTel="",sSpouseWorkTel="",sKinshipName="",sRelativeType="",sKinshipTel="",sKinshipAdd="",sOtherContact="",sRelativeType1="";
String sContactTel="",sZE="",sOtherRevenue="",sFamilyMonthIncome="",sCE="", sCreditCycle="", sCreditFeeRate=""; 
String sColleagueContact="",sColleagueContactTel=""; //add by yzhang9 添加同事联系人的两个字段 
//产品月利率、首次还款日、默认还款日、月还款额、贷款发放日
String sMONTHLYINTERESTRATE="",sMonthRepayment="",sPutOutDate="",sfalg6="";
String sDfile = "本人选择银行代扣还款，表明本人同意并授权深圳市佰仟金融服务有限公司可通过银行从本人指定的银行账户（如第50、51、52项所示）将每月还款额（如第36项所示）及其它应还款项转入指定还款账户（如第47、48、49项所示）。本人同意此扣款授权同时适用于之前由深圳市佰仟金融提供服务并签订的一份或多份贷款合同，即深圳市佰仟金融服务有限公司可通过银行从本人指定的上述银行账户内扣划本人在各合同下应偿还的相关款项。本人同意该账户同时可用于因提前还款等引起的资金往来。";

//在计算随心还服务包费时使用
String stypeno = "",sBusinessSum_ = "",sTerm="",bpp = "",sBugPayPkgind = "",bugPayPkgindFee="0.0";

String sUserName = "";
String dFirstIntrestAmt = "";
String putoutno	                =""  ;
String course_education_training1="";
String course_education_training2="";
String course_start_time1        ="";
String course_start_time2        ="";
String course_consultant_name1   ="";
String course_consultant_phone1  ="";
String is_probation1             ="";
String probation_time1           ="";
String course_remarks1           ="";
String course_consultant_name2   ="";
String course_consultant_phone2  ="";
String is_probation2             ="";
String probation_time2           ="";
String course_remarks2           ="";
String school_name               ="";
String school_college            ="";
String school_department         ="";
String school_professional_name  ="";
String school_class              ="";
String school_student_no         ="";
String school_learning           ="";
String school_status_student     ="";
String school_length             ="";
String school_level              ="";
String school_dormitory_telephone="";
String school_counselor_telephone="";
String school_enrollment_date    ="";
String school_expected_date      ="";
String school_address            ="";
String school_township           ="";
String school_street             ="";
String school_community          ="";
String school_room_no            ="";
String school_mailing_address    ="";
String family_parents_name       ="";
String family_parents_relations  ="";
String family_parents_telephone  ="";
String family_parents_fixedline  ="";
String family_parents_company    ="";
String family_parents_companytel ="";
String family_parents_position   ="";
String family_parents_city       ="";
String family_parents_xiang      ="";
String family_parents_village    ="";
String family_parents_community  ="";
String family_parents_room_no    ="";
String family_parents_isloan     ="";
String family_other_name         ="";
String family_other_relations    ="";
String family_other_telephone    ="";
String other_contact_name        ="";
String other_contact_relations   ="";
String other_contact_telephone   ="";
String monthly_income_total      ="";
String monthly_income_source     ="";
String monthly_income_payments   ="";
String monthly_income_other      ="";
String monthly_income_expenditure="";
String monthly_income_record     ="";
String createby                  ="";
String createdate                ="";
String updateby                  ="";
String updatedate                ="";
String school_degree_category    ="";
String promotersname                ="";
String salesexecutivephone    ="";
String spouse_is_tel ="";
String spouse_township="", spouse_street ="",spouse_community="", spouse_room_no="", spouse_address="",spouse_is_education="";
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户sCustomerID化2;]~*/%>
<%
//获得调查报告数据
String sSql = "select bc.insurancesum as CreditFeeRate,bc.CreditCycle as CreditCycle,bc.BusinessType3 as BusinessType3,bc.BrandType3 as BrandType3,bc.Manufacturer3 as Manufacturer3,bc.Price3 as Price3,bc.FIRSTDRAWINGDATE as FIRSTDRAWINGDATE,bc.CustomerID,bc.CustomerName,bc.stores,bc.inputuserid,bc.inputdate,bc.BusinessType,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName, "+
				" bc.TotalPrice,bc.PdgRatio,bc.ReplaceAccount,getitemname('BankCode',bc.OpenBank) as OpenBank,bc.ReplaceName,getusername(bc.Inputuserid) as promotersname,u.mobiletel as salesexecutivephone,"+
				" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,getitemname('BankCode',bc.RepaymentBank) as RepaymentBank,bc.RepaymentName, "+
				"(select typename from business_type where typeno = bc.BusinessType) as ApplyType1,getitemname('BusinessType',bc.productid) as ApplyType,"+
				" PutOutDate,PERIODS,REPAYMENTWAY,getitemname('YesNo',falg6) as falg6, "+
				" bc.BrandType1,bc.Price1,bc.BrandType2,bc.Price2,getTypeName(bc.BusinessRange1,bc.BusinessType1) as BusinessType1,getTypeName(bc.BusinessRange2,bc.BusinessType2) as BusinessType2,bc.Manufacturer1,bc.Manufacturer2, "+
				" getusername(bc.Inputuserid) as UserName, SUBMITDATETIME as SUBMITDATETIME ,info.course_education_training1 ,info.course_education_training2 "+
				",info.course_start_time1         ,info.course_start_time2         "+
				",info.course_consultant_name1    ,info.course_consultant_phone1   "+
				",info.is_probation1              ,info.probation_time1            "+
				",info.course_remarks1            ,info.course_consultant_name2    "+
				",info.course_consultant_phone2   ,info.is_probation2             "+ 
				",info.probation_time2            ,info.course_remarks2         "+   
				",info.school_name                ,info.school_college             "+
				",info.school_department          ,info.school_professional_name   "+
				",info.school_class               ,info.school_student_no          "+
				",info.school_learning            ,info.school_status_student      "+
				",info.school_length              ,getitemname('EducationExperience',info.school_level) as   school_level     "+
				",info.school_dormitory_telephone ,info.school_counselor_telephone "+
				",info.school_enrollment_date     ,info.school_expected_date       "+
				",info.school_address             ,info.school_township            "+
				",info.school_street              ,info.school_community           "+
				",info.school_room_no             ,info.school_mailing_address     "+
				",info.family_parents_name        ,info.family_parents_relations   "+
				",info.family_parents_telephone   ,info.family_parents_fixedline   "+
				",info.family_parents_company     ,info.family_parents_companytel  "+
				",info.family_parents_position    ,info.family_parents_city        "+
				",info.family_parents_xiang       ,info.family_parents_village     "+
				",info.family_parents_community   ,info.family_parents_room_no     "+
				",info.family_parents_isloan      ,info.family_other_name         "+ 
				",info.family_other_relations     ,info.family_other_telephone     "+
				",info.other_contact_name         ,info.other_contact_relations    "+
				",info.other_contact_telephone    ,info.monthly_income_total       "+
				",info.monthly_income_source      ,info.monthly_income_payments    "+
				",info.monthly_income_other       ,info.monthly_income_expenditure "+
				",info.monthly_income_record      ,info.createby              "+     
				",info.createdate                 ,info.updateby            "+       
				",info.updatedate                 ,info.school_degree_category     "+
				",info.tempsaveflag               ,info.sales_consultant_contact   "+
				" ,bc.BugPayPkgind as bpp,getItemName('BugPayPkgind',bc.BugPayPkgind) as BugPayPkgind from Business_Contract bc , business_education_info  info , user_info u where  bc.serialno=info.putoutno(+) and bc.Inputuserid = u.userid(+) and  bc.serialno = '"+sObjectNo+"'";

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
		
		
	
		  course_education_training1=rs2.getString("course_education_training1");
		  course_education_training2=rs2.getString("course_education_training2");
		  course_start_time1        =rs2.getString("course_start_time1");
		  course_start_time2        =rs2.getString("course_start_time2"); 
		  course_consultant_name1   =rs2.getString("course_consultant_name1"); 
		  course_consultant_phone1  =rs2.getString("course_consultant_phone1");
		  is_probation1             =rs2.getString("is_probation1");
		  probation_time1           =rs2.getString("probation_time1");
		  course_remarks1           =rs2.getString("course_remarks1");
		  course_consultant_name2   =rs2.getString("course_consultant_name2");
		  course_consultant_phone2  =rs2.getString("course_consultant_phone2");
		  is_probation2             =rs2.getString("is_probation2");
		  probation_time2           =rs2.getString("probation_time2");
		  course_remarks2           =rs2.getString("course_remarks2");
		  school_name               =rs2.getString("school_name");
		  school_college            =rs2.getString("school_college");
		  school_department         =rs2.getString("school_department");
		  school_professional_name  =rs2.getString("school_professional_name");
		  school_class              =rs2.getString("school_class");
		  school_student_no         =rs2.getString("school_student_no");
		  school_learning           =rs2.getString("school_learning");
		  school_status_student     =rs2.getString("school_status_student");
		  school_length             =rs2.getString("school_length");
		  school_level              =rs2.getString("school_level");
		  school_dormitory_telephone=rs2.getString("school_dormitory_telephone");
		  school_counselor_telephone=rs2.getString("school_counselor_telephone");
		  school_enrollment_date    =rs2.getString("school_enrollment_date");
		  school_expected_date      =rs2.getString("school_expected_date");
		  school_address            =rs2.getString("school_address");
		  school_township           =rs2.getString("school_township");
		  school_street             =rs2.getString("school_street");
		  school_community          =rs2.getString("school_community");
		  school_room_no            =rs2.getString("school_room_no");
		  school_mailing_address    =rs2.getString("school_mailing_address");
		  family_parents_name       =rs2.getString("family_parents_name");
		  family_parents_relations  =rs2.getString("family_parents_relations");
		  family_parents_telephone  =rs2.getString("family_parents_telephone");
		  family_parents_company    =rs2.getString("family_parents_company");
		  family_parents_companytel =rs2.getString("family_parents_companytel");
		  family_parents_position   =rs2.getString("family_parents_position");
		  family_parents_fixedline  =rs2.getString("family_parents_fixedline");
		  family_parents_city       =rs2.getString("family_parents_city");
		  family_parents_xiang      =rs2.getString("family_parents_xiang");
		  family_parents_village    =rs2.getString("family_parents_village");
		  family_parents_community  =rs2.getString("family_parents_community");
		  family_parents_room_no    =rs2.getString("family_parents_room_no");

		  family_other_name         =rs2.getString("family_other_name");
		  family_other_relations    =rs2.getString("family_other_relations");
		  family_other_telephone    =rs2.getString("family_other_telephone");
		  other_contact_name        =rs2.getString("other_contact_name");
		  other_contact_relations   =rs2.getString("other_contact_relations");
		  other_contact_telephone   =rs2.getString("other_contact_telephone");

		  monthly_income_payments   =rs2.getString("monthly_income_payments");
		  monthly_income_other      =rs2.getString("monthly_income_other");
		  monthly_income_expenditure=rs2.getString("monthly_income_expenditure");
		  monthly_income_record     =rs2.getString("monthly_income_record");
		  createby                  =rs2.getString("createby");
		  createdate                =rs2.getString("createdate");
		  updateby                  =rs2.getString("updateby");
		  updatedate                =rs2.getString("updatedate");
		  school_degree_category    =rs2.getString("school_degree_category");
		   promotersname                =rs2.getString("promotersname");
		   salesexecutivephone    =rs2.getString("salesexecutivephone");
		 
		  if(sUserName ==	null)sUserName                   ="&nbsp;";
		  if(dFirstIntrestAmt ==         null)dFirstIntrestAmt            ="&nbsp;";      
		  if(putoutno	             ==    null)putoutno	                   ="&nbsp;";
		  if(course_education_training1==null)course_education_training1  ="&nbsp;";
		  if(course_education_training2==null)course_education_training2  ="&nbsp;";
		  if(course_start_time1        ==null)course_start_time1          ="&nbsp;";
		  if(course_start_time2        ==null)course_start_time2          ="&nbsp;";
		  if(course_consultant_name1   ==null)course_consultant_name1     ="&nbsp;";
		  if(course_consultant_phone1  ==null)course_consultant_phone1    ="&nbsp;";
		  if(is_probation1             ==null)is_probation1               ="&nbsp;";
		  if(probation_time1           ==null)probation_time1             ="&nbsp;";
		  if(course_remarks1           ==null)course_remarks1             ="&nbsp;";
		  if(course_consultant_name2   ==null)course_consultant_name2     ="&nbsp;";
		  if(course_consultant_phone2  ==null)course_consultant_phone2    ="&nbsp;";
		  if(is_probation2             ==null)is_probation2               ="&nbsp;";
		  if(probation_time2           ==null)probation_time2             ="&nbsp;";
		  if(course_remarks2           ==null)course_remarks2             ="&nbsp;";
		  if(school_name               ==null)school_name                 ="&nbsp;";
		  if(school_college            ==null)school_college              ="&nbsp;";
		  if(school_department         ==null)school_department           ="&nbsp;";
		  if(school_professional_name  ==null)school_professional_name    ="&nbsp;";
		  if(school_class              ==null)school_class                ="&nbsp;";
		  if(school_student_no         ==null)school_student_no           ="&nbsp;";
		  if(school_learning           ==null)school_learning             ="&nbsp;";
		  if(school_status_student     ==null)school_status_student       ="&nbsp;";
		  if(school_length             ==null)school_length               ="&nbsp;";
		  if(school_level              ==null)school_level                ="&nbsp;";
		  if(school_dormitory_telephone==null)school_dormitory_telephone  ="&nbsp;";
		  if(school_counselor_telephone==null)school_counselor_telephone  ="&nbsp;";
		  if(school_enrollment_date    ==null)school_enrollment_date      ="&nbsp;";
		  if(school_expected_date      ==null)school_expected_date        ="&nbsp;";
		  if(school_address            ==null)school_address              ="&nbsp;";
		  if(school_township           ==null)school_township             ="&nbsp;";
		  if(school_street             ==null)school_street               ="&nbsp;";
		  if(school_community          ==null)school_community            ="&nbsp;";
		  if(school_room_no            ==null)school_room_no              ="&nbsp;";
		  if(school_mailing_address    ==null)school_mailing_address      ="&nbsp;";
		  if(family_parents_fixedline  ==null)family_parents_fixedline    ="&nbsp;";
		  if(family_parents_city       ==null)family_parents_city         ="&nbsp;";
		  if(family_parents_xiang      ==null)family_parents_xiang        ="&nbsp;";
		  if(family_parents_village    ==null)family_parents_village      ="&nbsp;";
		  if(family_parents_community  ==null)family_parents_community    ="&nbsp;";
		  if(family_parents_room_no    ==null)family_parents_room_no      ="&nbsp;";
		  if(family_parents_isloan     ==null)family_parents_isloan       ="&nbsp;";
		  if(family_other_name         ==null)family_other_name           ="&nbsp;";
		  if(family_other_relations    ==null)family_other_relations      ="&nbsp;";
		  if(family_other_telephone    ==null)family_other_telephone      ="&nbsp;";
		  if(other_contact_name        ==null)other_contact_name          ="&nbsp;";
		  if(other_contact_relations   ==null)other_contact_relations     ="&nbsp;";
		  if(other_contact_telephone   ==null)other_contact_telephone     ="&nbsp;";

		  if(monthly_income_payments   ==null)monthly_income_payments     ="&nbsp;";
		  if(monthly_income_other      ==null)monthly_income_other        ="&nbsp;";
		  if(monthly_income_expenditure==null)monthly_income_expenditure  ="&nbsp;";
		  if(monthly_income_record     ==null)monthly_income_record       ="&nbsp;";
		  if(createby                  ==null)createby                    ="&nbsp;";
		  if(createdate                ==null)createdate                  ="&nbsp;";
		  if(updateby                  ==null)updateby                    ="&nbsp;";
		  if(updatedate                ==null)updatedate                  ="&nbsp;";
		  if(school_degree_category    ==null)school_degree_category      ="&nbsp;";
		  if(promotersname             ==null)promotersname               ="&nbsp;";
		  if(salesexecutivephone                ==null)salesexecutivephone                   ="&nbsp;";
		  
		if(sCreditCycle == null) sCreditCycle ="&nbsp;";
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
		if(repaymentWay==null) repaymentWay="&nbsp;";
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
	           +"getitemname('UnitKind',ii.UnitKind) as IndustryType,getitemname('YesNo',ii.Flag2) as Flag2,getitemname('YesNo',ii.Falg4) as Flag4,getitemname('educationAdd1',ii.Flag8) as Flag8,"
	           +"getitemname('OrgAttribute',ii.CellProperty) as CellProperty,getItemName('Sex',ii.Sex) as sex,ii.WorkTel,ii.WorkTelPlus,getitemname('AreaCode',ii.WorkAdd) as WorkAdd,"
	           +"ii.UnitCountryside,ii.UnitStreet,ii.UnitRoom,ii.UnitNo,ii.CommAdd,getitemname('WorkExperence',ii.JobTotal) as JobTotal,getitemname('WorkExperence',ii.JobTime) as JobTime, "
	           +"ii.SpouseName,ii.SpouseTel,ii.SpouseWorkTel,ii.SpouseWorkCorp,ii.KinshipName,getItemname('FamilyRelativeAccount',ii.RelativeType) as RelativeType, "
	           +"ii.KinshipAdd,ii.OtherContact,getItemname('RelativeAccountOther',ii.Contactrelation) as RelativeType1,ii.kinshiptel,"
	           +"ii.family_parents_name, getitemname('EducationParents',ii.family_parents_relations) as family_parents_relations,  ii.spouse_is_tel,ii.family_parents_company, ii.family_parents_companytel,"
	           +" ii.family_parents_position, ii.spouse_address, ii.spouse_township,  ii.spouse_street,ii.family_parents_telephone, ii.spouse_community,  ii.spouse_room_no,getitemname('YesNo',ii.spouse_is_education) as spouse_is_education ,"
	           +" ii.ContactTel,ii.OtherRevenue+ii.SelfMonthIncome as ZE,ii.OtherRevenue,ii.FamilyMonthIncome,"
	           +"nvl(ii.Alimony,0)  as CE ,ii.monthly_income_total,ii.monthly_income_source from ind_info ii where CustomerID='"+sObjectNo.substring(0, 8)+"'";
  
	
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
		sWorkTelPlus=rs3.getString("WorkTelPlus");
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
		sSpouseWorkTel=rs3.getString("SpouseWorkTel");
		sSpouseWorkCorp=rs3.getString("SpouseWorkCorp");
		sKinshipName= rs3.getString("KinshipName");
		sRelativeType= rs3.getString("RelativeType");
		sKinshipTel = rs3.getString("kinshiptel");
		sKinshipAdd = rs3.getString("KinshipAdd");
		sOtherContact = rs3.getString("OtherContact");
		  family_parents_name       =rs3.getString("family_parents_name");
		  family_parents_relations  =rs3.getString("family_parents_relations");
		  family_parents_telephone  =rs3.getString("family_parents_telephone");
		  family_parents_company    =rs3.getString("family_parents_company");
		  family_parents_companytel =rs3.getString("family_parents_companytel");
		  family_parents_position   =rs3.getString("family_parents_position");
		  spouse_is_tel   =rs3.getString("spouse_is_tel");
		  spouse_township   =rs3.getString("spouse_township");
		  spouse_street   =rs3.getString("spouse_street");
		  spouse_community   =rs3.getString("spouse_community");
		  spouse_room_no   =rs3.getString("spouse_room_no");
		  spouse_address   =rs3.getString("spouse_address");
		//sColleagueContact=rs3.getString("ColleagueContact");//add by yzhang9 添加同事联系人姓名   ="";
		//sColleagueContactTel=rs3.getString("ColleagueContactTel");//add by yzhang9 添加同事联系人电话
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
		  monthly_income_total      =rs3.getString("monthly_income_total");
		  monthly_income_source     =rs3.getString("monthly_income_source");
		  spouse_is_education     =rs3.getString("spouse_is_education");
		  if(spouse_is_education      ==null)spouse_is_education        ="&nbsp;";
		  if(monthly_income_total      ==null)monthly_income_total        ="&nbsp;";
		  if(monthly_income_source     ==null)monthly_income_source       ="&nbsp;";
		  if(spouse_is_tel     ==null)spouse_is_tel       ="&nbsp;";
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
		if(sWorkTelPlus!=null){
			sWorkTel+="-"+sWorkTelPlus;
		}
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
		if(sSpouseWorkTel == null) sSpouseWorkTel ="&nbsp;";
		if(sSpouseWorkCorp == null) sSpouseWorkCorp ="&nbsp;";
		if(sKinshipName == null) sKinshipName ="&nbsp;";
		if(sRelativeType == null) sRelativeType ="&nbsp;";
		if(sKinshipAdd == null) sKinshipAdd="&nbsp;";
		if(sKinshipTel == null) sKinshipTel ="&nbsp;";
		if(sOtherContact == null) sOtherContact ="&nbsp;";
		  if(family_parents_name       ==null)family_parents_name         ="&nbsp;";
		  if(family_parents_relations  ==null)family_parents_relations    ="&nbsp;";
		  if(family_parents_telephone  ==null)family_parents_telephone    ="&nbsp;";
		  if(family_parents_company    ==null)family_parents_company      ="&nbsp;";
		  if(family_parents_companytel ==null)family_parents_companytel   ="&nbsp;";
		  if(family_parents_position   ==null)family_parents_position     ="&nbsp;";
		  if(spouse_is_tel       ==null)spouse_is_tel         ="&nbsp;";
		  if(spouse_township  ==null)spouse_township    ="&nbsp;";
		  if(spouse_street  ==null)spouse_street    ="&nbsp;";
		  if(spouse_community    ==null)spouse_community      ="&nbsp;";
		  if(spouse_room_no ==null)spouse_room_no   ="&nbsp;";
		  if(spouse_address   ==null)spouse_address     ="&nbsp;";
	//	if(sColleagueContact == null) sColleagueContact ="&nbsp;";//add by yzhang9 添加同事联系人姓名 
	//	if(sColleagueContactTel == null) sColleagueContactTel ="&nbsp;";//add by yzhang9 添加同事联系人电话 
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
	if(sApplyNum==null) sApplyNum="&nbsp;";
	sAddress = Sqlca.getString(new SqlObject("select getItemName('AreaCode',CITY)||ADDRESS as Address from STORE_INFO where SNO =:SNO").setParameter("SNO", sStores));
	String sPage = Sqlca.getString(new SqlObject("select documentid from ecm_page where objectno =:ObjectNO and objecttype = 'Business' and typeno = '20002'  order by modifytime desc").setParameter("ObjectNO", sObjectNo));
	//String sPage = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");

	String path = request.getContextPath(); 
	String requestpath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String sLogo = requestpath+"FormatDoc/Images/122.jpg";
	
	String xcPage = Sqlca.getString(new SqlObject("select DOCUMENTID from ecm_page where typeno = '20002' and objectno =:ObjectNo order by MODIFYTIME desc").setParameter("ObjectNo", sObjectNo));
	requestpath = sWebRootPath+"/servlet/ImageServlet?ImageId=";
	xcPage = requestpath+xcPage;

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
	
	String sCreditCycleFile = "";
							  					
	if(!"1".equals(sCreditCycle)) {
		//sCreditCycleFile = "&nbsp;";
		sCreditFeeRate = "0.00";
	}
	String sCreditCycleName = "";
	if ("1".equals(sCreditCycle)) {
		sCreditCycleName = "是";
		sCreditCycleFile = bxcompanyName+"：本人选择参加保险，即表明本人同意深圳市佰仟金融服务有限公司为本人投保“"+bxproductName+"”，并通过身份证号码在"+bxcompanyName+"网站上查询下载保险合同，认可其为本人所投保的保险金额"+InsuranceDescription+"。本人指定深圳市佰仟金融服务有限公司为前述“"+bxproductName+"”合同项下保险金的受益人及/或第一受益人，受益金额为依贷款三方协议的约定仍未偿还款项的余额。本人同时确认已熟知保险合同及相关条款， 且具备保险合同所约定的所有参保资格条件。";
	} else {
		sCreditCycleName = "否";
		bxcompanyName = "&nbsp;";
		sCreditCycleFile = "&nbsp;";
	}
	/* 
	//代扣条约判断
	if(!"1".equals(repaymentWay)){
		sDfile = "&nbsp;";
	} */
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable >");	
	sTemp.append("<table class=table1 align=center  border=0 cellspacing=0 cellpadding=0  width='810' >	");
	
/* 	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");	
	sTemp.append("<td colspan=1 rowspan=2 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' style='width:150px;height:50px;' /></td>");
	sTemp.append("<td class=td1 rowspan=2 align=center colspan=7 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >教育产品（学生）分期购服务申请表</font></td> ");	
	sTemp.append("<td colspan=2 align=left class=td1 ><img src="+request.getContextPath()+"/barcode?msg="+sObjectNo+"&height=7 width='150' height='40' />&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=left class=td1 >协议编码："+sObjectNo+"&nbsp;申请日期："+sInputDate+"&nbsp;</td>");
	sTemp.append("</tr>");

	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >销售点代码："+sStores+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >销售点名称："+sStoresName+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >销售顾问代码："+sInputUserID+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >申请类别：学生教育贷&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >过去在本公司有过几次贷款申请：</b>"+sApplyNum+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >销售点地址："+sAddress+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >产品代码："+sBusinessType+"&nbsp;</td>");
	//sTemp.append("<td colspan=3 align=left class=td1 style='border-left-style: none;' >&nbsp;</td>");
	//sTemp.append("<td colspan=4 align=left class=td1 >内部代码："+sInteriorCode+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>个人资料</b>&nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >1.姓名："+sCustomerName+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >2.性别："+sSex+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >3.身份证号："+sCertID+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >4.发证机关："+sIssueinstitution+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >5.身份证有效期至："+sMaturityDate+"&nbsp;</td>");
	sTemp.append("<td colspan=1 rowspan=4 align=left class=td1 ><div><img src='"+xcPage+"' style='width:100px;height:100px;'/></div></td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >6.手机：<br>"+sMobileTelephone+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >7.电子邮箱："+sEmailAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >8.QQ号码："+sQQNo+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >9.现居住地址是否与户籍地址相同："+sFlag2+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >10.户籍地址："+sNativeplace+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >11.镇/乡："+sVillagetown+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >12.街道/村："+sStreet+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >13.小区/楼盘："+sCommunity+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >14.栋/单元/房间号："+sCellNo+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >15.现居住地址："+sFamilyAdd+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >16.镇/乡："+sCountryside+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >17.街道/村："+sVillagecenter+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >18.小区/楼盘："+sPlot+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >19.栋/单元/房间号："+sRoom+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>分期购服务内容</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >20.课程类型(1)："+sBusinessType1+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >21.课程名称(1)："+sManufacturer1+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >22.课程时长(1)："+sBrandType1+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >23.价格(1)(元)："+sPrice1+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >24.课程类型(2)："+sBusinessType2+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >25.课程名称(2)："+sManufacturer2+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >26.课程时长(2)："+sBrandType2+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >27.价格(2)(元)："+sPrice2+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >28.课程顾问姓名："+course_consultant_name1+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >29.课程顾问联系方式："+course_consultant_phone1+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >30.是否试读："+is_probation1+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >31.试读时间："+probation_time1+"&nbsp;天</td>");
	sTemp.append("</tr>");
	
	/* 
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >24.课程顾问姓名(1)："+course_consultant_name1+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >25.课程顾问联系方式(1)："+course_consultant_phone1+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >26.是否试读(1)："+is_probation1+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >27. 试读时间(1)："+probation_time1+"&nbsp;天</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >32.课程顾问姓名(2)："+course_consultant_name2+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >33.课程顾问联系方式(2)："+course_consultant_phone2+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >34.是否试读(2)："+is_probation2+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >35. 试读时间(2)："+probation_time2+"&nbsp; 天</td>");
	sTemp.append("</tr>"); 
	*/
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >32.课程总价（元）："+sTotalPrice+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >33.自付金额（元）："+sTotalSum+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >34.贷款本金（元）："+sBusinessSum+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >35.分期期数："+sPeriods+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >36.每月还款额（元）："+sMonthRepayMent+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >37.首次还款日："+sFirstDueDate+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >38.首次还款额(元)："+dFirstIntrestAmt+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >39.每月还款日："+sDefaultDueDay+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >40.月贷款利率（%）："+sCreditRate+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >41.月客户服务费率（%）："+sCUSTOMERSERVICERATES+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >42.月财务管理费率（%）："+sMANAGEMENTFEESRATE+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >43.月增值服务费率</br>（%）："+sCreditFeeRate+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >44.印花税（%）："+sSTAMPTAX+"&nbsp;</td>");
	//sTemp.append("<td colspan=2 align=left class=td1 >44.随心还服务费(元): "+bugPayPkgindFee+"&nbsp;&nbsp;&nbsp;是否选择随心还："+sBugPayPkgind+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >45.是否申请参加保险： "+sCreditCycleName+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >46.保险公司名称："+bxcompanyName+"&nbsp;</td>"); //update tangyb
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >"+sCreditCycleFile+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>还款账户信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >47.指定还款账户账号：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sRepaymentNo+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >48.开户银行：<br>&nbsp;&nbsp;&nbsp;&nbsp;招商银行股份有限公司深圳安联支行 &nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >49.户名："+sRepaymentName+"&nbsp;</td>");
	//sTemp.append("<td colspan=2 align=left class=td1 style='border-left-style: none;' ></td>");
	sTemp.append("</tr>");
	
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=left class=td1 >50.客户银行卡号/账号：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sReplaceAccount+"&nbsp;</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >51.客户开户银行：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sOpenBranch+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >52.客户银行账户名：<br>&nbsp;&nbsp;&nbsp;&nbsp;"+sReplaceName+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >53.是否选择银行代扣还款："+("1".equals(repaymentWay)?"是":"否")+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style=' font-size: 8pt;' >"+sDfile+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>学校信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >54.学校全称："+school_name+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >55.所在学院："+school_college+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >56.系："+school_department+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >57.专业名称："+school_professional_name+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >58.班级："+school_class+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >59.学号："+school_student_no+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >60.学习形式："+school_learning+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >61.学籍状态："+school_status_student+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >62.学历类别："+school_degree_category+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >63.学制："+school_length+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >64.层次："+school_level+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >65.学院/宿舍电话："+school_dormitory_telephone+"</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >66.辅导员电话："+school_counselor_telephone+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >67.入学日期："+school_enrollment_date+"&nbsp;</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >68.预计毕业日期："+school_expected_date+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >69.学校地址：省/直辖市:"+school_address+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >70.镇/乡："+school_township+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >71.街道/村："+school_street+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >72.小区/楼盘："+school_community+"</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >73.栋/单元/房间号："+school_room_no+"</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >74.邮寄地址："+sFlag8+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>家庭成员信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >75.父/母姓名："+sKinshipName+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >76.与申请人关系："+family_parents_relations+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >77.父/母联系电话："+sKinshipTel+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >78.家庭固话："+sFamilyTel+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >79.父/母单位名称："+family_parents_company+"</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >80.父/母单位电话："+family_parents_companytel+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >81.父/母职位："+family_parents_position+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >82.父/母现居住地址：省/直辖市:"+spouse_address+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >83.镇/乡："+spouse_township+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >84.街道/村："+spouse_street+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >85.小区/楼盘："+spouse_community+"</td>");
	sTemp.append("<td colspan=1 align=left class=td1 >86.栋/单元/房间号："+spouse_room_no+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >87.父母是否知道贷款 ："+spouse_is_education+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >88.其他亲属姓名："+family_parents_name+"</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >89.与申请人关系："+sRelativeType+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >90.其他亲属联系方式："+family_parents_telephone+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>其他联系人信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr style='height:20px;'>");
	sTemp.append("<td colspan=1 align=left class=td1 >91.联系人姓名："+sOtherContact+"</td>");
	sTemp.append("<td colspan=5 align=left class=td1 >92.与申请人关系："+sRelativeType1+"</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >93.联系电话："+sContactTel+"</td>");
	sTemp.append("</tr>");

	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=center class=td1 bgcolor=#aaaaaa ><b>收入及支出信息</b>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=left class=td1 >94.月收入总额（元）："+monthly_income_total+"</td>");
	sTemp.append("<td colspan=4 align=left class=td1 >95.每月收入来源 :"+monthly_income_source+"</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >96.其他收入（元/月）："+sOtherRevenue+"</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >97.个人支出（元/月）："+sCE+"</td>");
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
	
	sTemp.append("<td colspan=5 align=left class=td1 >提供的申请材料:"+emg+"&nbsp;</td>");
	sTemp.append("<td colspan=3 align=left class=td1 >产品附录：&nbsp;</td>");
	sTemp.append("<td colspan=2 align=left class=td1 >是否签署授权书:"+sfalg6+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left class=td1 ><font style='FONT-FAMILY:宋体; font-size: 8pt;' >本人具有完全民事行为能力签署本申请表并承担相应责任。本人已仔细阅读并完全了解《教育培训贷款三方协议》，并且自愿遵守相关的协议约定。<br>本人保证在此表上填写、确认的内容及向贷款人、深圳市佰仟金融服务有限公司提供的所有相关资料全部真实、有效，如本人提供虚假资料，将承担由此引起的一切责任及损失。本人在此同意贷款人及深圳市佰仟金融服务有限公司按照相关法律法规的规定，向有权机构报送本人的个人信用信息，包括但不限于本申请表项下的信息，同时，授权贷款人及深圳市佰仟金融服务有限公司向任何可能的来源查询本人及配偶的与贷款申请有关的个人信息和个人信用信息，相关查询结果的用途将用于贷款审查和贷款管理。<br>本人同意如因单方面取消申请或不具备借款条件，申请不获批准，本表格及所有已提交的资料无须退还本人，由深圳市佰仟金融服务有限公司处理。贷款人及深圳市佰仟金融服务有限公司有权拒绝本贷款申请而无须给予任何原因解释。</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr style='height:50px;' >");
	sTemp.append("<td colspan=1 rowspan=2 align=left class=td1 >顾问姓名:&nbsp;"+promotersname+"&nbsp;</td>");
	sTemp.append("<td colspan=2 rowspan=2 align=left class=td1 >顾问联系方式:&nbsp;"+salesexecutivephone+"&nbsp;</td>");
	sTemp.append("<td colspan=3 rowspan=2 align=left class=td1 >销售顾问签名:&nbsp;</td>");
	sTemp.append("<td colspan=3 rowspan=2 align=left class=td1 >申请人签名:&nbsp;</td>");
	sTemp.append("<td colspan=1 rowspan=2 align=left class=td1 >日期:&nbsp;"+sInputDate+"</td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");
	/* 
	sTemp.append("<div style='page-break-after: always; '></div>");
	sTemp.append("<div style='visibility: hidden;'>");
	sTemp.append("<table class=table1 align=center  border=0 cellspacing=0 cellpadding=1 style='visibility: hidden;'>");	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 class=td1 ><font style=' font-size: 8pt;' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;分期购消费贷款三方协议<br>"
		+"	一、贷款申请1．中泰信托有限责任公司（以下简称“贷款人”）为依法成立并有效存续的中泰信托，根据中国银行业监督管理委员会颁布的《信托公司管理办法》第十九条的规定，可以发放信托贷款，贷款人拟向借款人发放的贷款资金来源于“中泰-弘瑞系列●佰仟信托贷款单一指定用途资金信托”项下的信托资金。2．在本合同下方签名的自然人借款人（以下简称“借款人”）拟向贷款人申请一笔《分期购服务申请表》（以下简称“《申请表》”，样本请见附件一）中所列明的贷款，用于从《申请表》上所列的零售商（即“销售点”）处购买《申请表》上所列的商品（以下统称“商品”）。3．借款人愿意聘请深圳市佰仟金融服务有限公司（以下简称“佰仟金融”）向借款人提供与本协议项下贷款相关的财务管理服务和客户服务，其服务内容包括但不限于代借款人接收贷款人发放的贷款，并代为向《申请表》上所列的零售商支付商品的对价等。4．贷款人依据其与佰仟金融签署的《消费信贷合作协议》的约定，聘请佰仟金融为其提供推荐借款人、代为向借款人划付贷款本金、代为收取贷款本金及利息、根据本协议约定通知还款、催收欠款等服务。5．若贷款人同意向借款人发放贷款的，借款人同意并确认如下：（1）授权佰仟金融代其接收贷款人发放的贷款本金，并且贷款人向佰仟金融指定的贷款接收账户划付贷款本金视为贷款发放成功；（2）同时，授权佰仟金融用其为借款人代为接收的贷款，进一步代借款人向零售商支付商品价款（即贷款本金），作为借款人购买商品应支付的部分对价（借款人的贷款本金金额应为商品总价扣除借款人自付金额）。6．借款人、佰仟金融、贷款人在此确认，贷款人向佰仟金融指定的贷款接收账户划付贷款本金，即视为贷款人已履行完毕本合同项下的放款义务。7．借款人同意按期足额支付贷款本金、利息、财务管理费、客户服务费、滞纳金（如有）。贷款人授权佰仟金融代为收取借款人支付的贷款本息等款项（包括贷款本金、利息、滞纳金（如有））并向贷款人划付。借款人在此确认知晓上述事宜，并同意按本合同约定向佰仟金融指定的账户偿还前述贷款本息等还款项，并委托佰仟金融向贷款人支付贷款本息等款项。借款人应向佰仟金融支付财务管理费、客户服务费。贷款人、佰仟金融、借款人进一步共同确认以下条款：<br>"
		+"	二、基本贷款条款与定义1．贷款本金：即《申请表》所列“贷款本金”，为借款人购买《申请表》上所列商品应向零售商支付的商品总价款扣除借款人已自付金额。为免歧义，该贷款本金不含借款人向零售商自行支付的金额（即《申请表》所列的“自付金额”），不含根据本合同约定借款人应支付的利息、借款人应向佰仟金融支付的财务管理费、客户服务费。2．贷款利率：即贷款期间适用的贷款利率（符合人民银行有关利率的规定），以《申请表》所列“月贷款利率”为准。3．分期期数、每月还款额：即《申请表》所列“分期期数”和“每月还款额”。本贷款以按月等额本息还款的方式偿还，全额偿还本贷款（以及借款人履行本合同项下其他的支付义务，滞纳金除外）所需的分期期数以及每期应支付的期款以《申请表》所列为准。4．贷款期间：即从借款人《申请表》所列之申请日期开始至最后一笔期款的到期日为止。贷款期间结束后，如借款人仍拖欠本合同项下的任何款项，其还款义务并不因此而解除。5．期款：即借款人每个月应向贷款人及佰仟金融支付的款项，对应《申请表》项下的“每月还款额”。期款金额以本协议第四条第1款约定为准。6．还款到期日：即《申请表》所列第一期期款的还款日——“首次还款日”；与其后的每一期期款还款日——“每月还款日”，为每一日历月的同一天（为方便借款人还款，若申请日期为某月的29日、30日、31日，则首次还款日为协议签订月后第二个月的2日、3日、4日，之后的每月还款日亦为相应月份的2日、3日、4日），前两者统称“还款到期日”。7．本合同：即本《分期购消费贷款三方协议》及附件，以及前述协议的任何后续补充约定或修改的合称，本合同的附件包括《分期购服务申请表》。8．指定还款账户：即佰仟金融开立的借款人还款资金接收账户，贷款人委托佰仟金融用该账户代为收取借款人偿还的贷款本息等款项，借款人向该账户偿还贷款本息并委托佰仟金融进一步向贷款人划付。具体账户信息以《申请表》的记载为准。<br>"
		+"	三、佰仟金融服务1．就本合同，佰仟金融向借款人提供服务内容包括财务管理服务和客户服务：●财务管理服务（1）消费贷款咨询服务；（2）将借款人推荐给贷款人；（3）客户理财服务；（4）代收代付服务，包括代借款人接收贷款人发放的贷款，并且代借款人将贷款用于向《申请表》上所列的零售商支付商品的对价。●	客户服务（1）客户纸质文档、电子文档保管、调阅服务；（2）客户还款渠道维护服务；（3）客户还款信息查询服务；（4）客户还款提醒及到账通知服务。2．就上述服务，佰仟金融向借款人收取财务管理费、客户服务费，佰仟金融有权自主决定财务管理费和客户服务费的金额和收取方式，前述费用在贷款期间内按月收取并包含在每一期期款中。为免歧义，前述费用仅指借款人针对上述服务应向佰仟金融支付的费用。<br>"
		+"	四、还款与费用1．借款人知悉并同意，每期应支付的期款是以下（1）至（3）项之和，期款以元为最小单位：（1）借款人应向贷款人偿还的（佰仟金融代为收取）每月贷款本金和利息（每月偿还的利息为剩余贷款本金乘以月利率），以按月等额本息还款的方式偿还；（2）借款人应向佰仟金融支付的每月财务管理费，为初始贷款本金乘以《申请表》所列之“月财务管理费率”的金额；（3）借款人应向佰仟金融支付的每月客户服务费，为初始贷款本金乘以《申请表》所列之“月客户服务费率”的金额。2．若借款人在《申请表》上不选择银行代扣，则适用第四条第3款和第4款的约定。若借款人在《申请表》上选择银行代扣，则适用第四条第5款和第6款的约定。3．借款人应将每一期期款在还款到期日之前支付至《申请表》上所列的佰仟金融指定还款账户。4．还款时间以指定还款账户实际收到借款人支付款项的到账时间为准，建议借款人提前将期款转入指定还款账户，以确保期款准时足额到账。5．借款人授权佰仟金融从借款人的银行账户划扣到期的期款及所有本合同项下到期应付的其他款项，而无需进一步通知借款人或者得到其同意。银行代扣不得早于还款到期日。借款人在此确认其授权佰仟金融划扣期款的银行账户信息如下：开户行："+sRepaymentNo+";账户名：招商银行深圳四海支行;账号："+sRepaymentName+";6．如果任何本合同项下的银行代扣失败，无论何种原因所致，借款人在本合同项下的还款义务不得因此而减免，如有必要借款人应采用其它合理方式继续清偿债务。7．若借款人在签订本合同时仍有其他未还清的消费贷款，且该消费贷款合同的金融服务公司为深圳市佰仟金融服务有限公司：●	如果借款人在《申请表》上选择银行代扣，则借款人对所有未还清的贷款在此授权银行代扣，银行代扣的账户将以借款人最新授权的账户为准。●	如果借款人在《申请表》上不选择银行代扣，则借款人对所有未还清的贷款在此同意取消所有之前授权的银行代扣。8．到达指定还款账户的款项，按照如下顺序清偿各项债务（包括借款人签订了其他由深圳市佰仟金融服务有限公司作为金融服务公司的消费贷款合同的情形）：●	各期债务包含的各款项按照以下顺序依次清偿：滞纳金（如有）、财务管理费、客户服务费、利息、贷款本金。●	无论合同签订先后，先到期的债务先偿还。●	多笔消费贷款的期款同时到期，先签署的消费贷款先偿还。●	同时到期的多笔消费贷款中，借款人申请了提前还款的消费贷款先偿还。●	若多笔消费贷款于同日签署，且借款人支付的款项不足以同时支付全部应付未付款项的，则各笔贷款按比例偿还。9．借款人应妥善保管本合同项下已还款项的付款证明。因借款人的还款引起争议的，由借款人对其还款情况承担举证责任。10.   如发生溢缴款情况，即借款人实际还款额大于应还款额，借款人有权向佰仟金融申请退还多支付的金额，但借款人应提供相应证明并承担退款时发生的银行汇款手续费。11．本合同第四条之任何规定不可被视为免除借款人对本合同项下任何款项的偿还义务，如滞纳金。<br>"
		+"	五、提前还款1．借款人有权提前偿还本合同项下的贷款并终止本合同。提前还款指于某月份（“提前还款月份”）的还款到期日当天或之前一次性支付以下款项（“提前还款金额”）：●截至提前还款月份的应付利息、滞纳金（如有）、财务管理费和客户服务费；●本合同项下所有尚未偿还的贷款本金；●提前还款费人民币一百元。2．借款人提前还款，应在提前还款月份还款到期日的十五个自然日之前致电佰仟金融申请提前还款并授权其向贷款人办理提前还款手续。佰仟金融的客服人员将告知借款人具体的提前还款金额。3．借款人提前还款，其还款方式与第四条约定的偿还期款方式相同，但提前还款时，银行代扣可以在还款到期日之前发生。4．犹豫期：如借款人《申请表》所列之申请日起的十五个自然日内（包含借款人签署《申请表》当天）向佰仟金融申请提前还款并且在上述十五个自然日内将贷款本金全额付至指定还款账户，贷款人、佰仟金融不收取任何利息和费用。5．除本合同第五条第4款以外，只有借款人在本合同以及任何其他由深圳市佰仟金融服务有限公司作为其金融服务公司的合同项下没有任何逾期款项时，才可申请提前还款。若借款人在前述合同条款项下发生逾期，任何提前还款将自动取消。<br>"
		+"	六、逾期还款1．如果借款人未履行本合同项下的付款义务，其应立即偿还拖欠款项并应当按照本合同第六条的规定向贷款人支付滞纳金。滞纳金按照逾期天数计算，逾期天数是指单笔贷款中最早一笔未全额支付的期款已逾期的天数。2．单笔贷款逾期天数第10天，产生30元人民币的滞纳金；逾期天数第30天，在已产生的滞纳金基础上再额外产生80元人民币的滞纳金；逾期天数第60天，再额外产生100元人民币的滞纳金；逾期天数第90天，再额外产生160元人民币的滞纳金。3．借款人逾期后，其支付的款项将优先用于清偿已经拖欠的期款和滞纳金，故其逾期天数可能因此而减少。但是，如若拖欠的期款并未全额清偿，其逾期天数将会继续累加计算并且当达到上述时间段时，将会产生更多的滞纳金。<br>"
		+"	七、强制提前还款1．以下任何事件发生，贷款人授权佰仟金融可代表贷款人要求借款人立即一次性偿还本合同项下的全部款项：（1）借款人违反本协议项下的任何约定，包括其在本协议项下的陈述与保证不真实；（2）借款人在其与佰仟金融、贷款人签署的其他贷款合同项下发生重大违约；（3）佰仟金融强烈怀疑借款人自贷款申请日起就贷款、财务管理费、客户服务费可能从事过任何欺诈行为或借款人可能无能力根据本合同付款，借款人在此同意并确认本条款的适用以佰仟金融的自主判断为准；（4）若按照佰仟金融的合理判断，借款人发生可能对贷款人或佰仟金融的权利或利益造成负面影响的任何其他情形。2．如果第七条第1款的情形发生在贷款人发放贷款之前，贷款人可以解除本合同，并且贷款人无需发放贷款或者承担任何其他责任。3．若借款人在某一笔期款的还款到期日90天之后仍未完全偿还该笔期款，则佰仟金融可以通知借款人本合同提前终止，终止日为该笔未还期款的还款到期日起第90天，贷款人授权佰仟金融通知借款人应立即一次性偿还以下款项：●	截至合同提前终止日的应付利息、滞纳金和财务管理费、客户服务费；●本合同项下所有尚未偿还的贷款本金；4．若借款人尚有其他未还清的消费贷款，且该消费贷款合同的金融服务公司为深圳市佰仟金融服务有限公司，则其他消费贷款合同的提前终止也将导致本合同的提前终止。<br>"
		+"	八、陈述与保证1．借款人陈述并保证：●借款人为贷款目的提供的所有信息（包括商品信息及《申请表》上填写的其他信息）完整、真实、准确并不存在误导性。●不存在任何可能影响借款人信用的情况，如借款人存在正在进行或将来有可能发生的诉讼、仲裁、行政程序等。●本贷款用途仅限于购买《申请表》上所列商品。因以上任何陈述不真实、不准确而导致的贷款人、佰仟金融的任何损失，均应由借款人足额赔偿。2．借款人应积极配合贷款人和佰仟金融对借款人的信用、贷款使用情况、贷款偿还情况进行监督。3．借款人授权佰仟金融及贷款人为信用评估、数据处理、风险控制、逾期账款催收等任何目的从任何数据库（包括不限于中国人民银行个人信用信息基础数据库）查询借款人的资产、资信及个人信用信息等情况，或者向上述系统报送其个人信息，以及佰仟金融为向借款人提供服务等目的通过任何方式使用其个人信息联系借款人或者授权第三方联系借款人。4．如果借款人违约，借款人同意佰仟金融直接或者经由第三方，通过当面拜访、电话、邮寄、网络等合法形式提醒借款人或者督促借款人对违约行为进行改正，并且同意佰仟金融向该第三方披露此违约事件。5．借款人承认，本合同产生的法律关系与借款人跟零售商之间的买卖合同关系是完全独立的。该买卖合同关系的无效或变更并不影响本合同的法律效力。故借款人不得以与零售商之间的任何纠纷（包括涉及商品质量或售后服务）为由拒绝履行本合同项下的任何义务。6．《申请表》上的借款人信息发生任何变化、借款人个人资产或者财务状况发生重大变化、或者发生了可能影响借款人履行本合同项下义务的任何其他情况时，借款人均应在五个自然日内通知佰仟金融。7.  贷款人、佰仟金融按照借款人签署本合同时在《申请表》上预留的现居住地址和通信方式（或者借款人另行书面或通过佰仟金融服务热线通知佰仟金融、贷款人变更的地址或通信方式）发出与本合同有关的通知。贷款人、佰仟金融以挂号信发出通知的，在挂号信回执所示日为有效送达；以邮件或短信方式发出的通知，以邮件或短信发送成功之日视为有效送达。<br>"
		+"	九、争议解决1．凡因本合同引起的或与本合同有关的任何争议，应通过协商解决，若协商仍无法解决，任何一方应向合同签署地人民法院提起诉讼。败诉方应承担为解决本争议而产生的所有费用，包括但不限于诉讼费、律师费、公证费、交通费等。2．若争议正在解决过程之中，合同各方应继续履行其在本合同项下的所有义务。<br>"
		+"	十、其他约定1．如本合同任何条款之一被司法机关或者其他有权部门认定为无效，该条款将不影响其余条款的有效性。2. 借款人授权佰仟金融保存借款人的本合同原件并同意佰仟金融在借款人付清本合同项下的全部款项之后销毁该原件。3．佰仟金融可不时地向借款人提供关于本合同履行的优惠条款。与本合同的约定相比，该优惠条款将对借款人更有利，经借款人确认后，该优惠条款即生效。4. 借款人确认已经认真阅读并完全理解本协议中的各项条款，且对协议中免除和限制借款人责任的条款已收到贷款人和佰仟金融的提醒注意和特别说明。<br><br><br></td>");
	//sTemp.append("<p align=center><p align=left>贷款人：中泰信托有限责任公司&nbsp;&nbsp;<p align=center>借款人：&nbsp;&nbsp;<p align=right>佰仟金融：深圳市佰仟金融服务有限公司&nbsp;&nbsp;&nbsp;<br><br><br><p align=left>合同签署日：&nbsp;&nbsp;</p><p align=center>合同签订地：广东省深圳市前海深港合作区&nbsp;&nbsp;&nbsp;</p></td>");
	sTemp.append("<tr style='height:50px;border: none;'>");
	sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: left;margin: auto; ' >贷款人：中泰信托有限责任公司</td>");
	sTemp.append("<td colspan=4 width='40%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: center;margin: auto;' >借款人：</td>");
	sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: right;margin: auto;' >佰仟金融：深圳市佰仟金融服务有限公司</td></tr>");
	sTemp.append("<tr style='height:50px; border: none;'>");
	sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: left;margin: auto;' >合同签署日：</td>");
	sTemp.append("<td colspan=4 width='40%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: center;margin: auto;' >合同签订地：广东省深圳市前海深港合作区</td>");
	sTemp.append("<td colspan=3 width='30%' class=td1 style='border: none;'><font style=' font-size: 8pt; text-align: right;margin: auto;' ></td></tr><br><br>");
		
	sTemp.append("</tr>");
	
	sTemp.append("</table>");	
	sTemp.append("</div>");
	 */

	
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