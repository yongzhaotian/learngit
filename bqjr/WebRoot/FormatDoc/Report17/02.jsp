 <%@ page contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;6:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	//int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
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
String sChildrentotal="";//子女数目
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
String sCUSTOMERSERVICERATES="",sMANAGEMENTFEESRATE="",sPdgRatio="",sSTAMPTAX="",sUnitStreet="";
String sReplaceAccount ="";//客户银行账号
String sOpenBranch="";//客户开户行
String sReplaceName="",sWorkCorp="",sEmployRecord="",sCommAdd="",sJobTotal="",sJobTime="",sFlag4="";
String sHeadShip="",sIndustryType="",sCellProperty="",sWorkTel="", sWorkAdd="",sUnitCountryside="",sUnitRoom="",sUnitNo="";
String sSpouseName="",sSpouseTel="",sKinshipName="",sRelativeType="",sKinshipTel="",sKinshipAdd="",sOtherContact="",sRelativeType1="";
String sContactTel="",sZE="",sOtherRevenue="",sFamilyMonthIncome="",sCE=""; 
	 //获得调查报告数据
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
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
	//	sTemp.append("<td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >现金分期服务申请表</font></td> ");	
	//	sTemp.append("</tr>");

/* 		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>销售点代码：</b>"+sStores+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>销售点名称：</b>"+sStoresName+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>销售顾问代码：</b>"+sInputUserID+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>申请类别：</b>"+sApplyType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 ><b>过去在本公司有几次贷款申请：</b>"+sApplyNum+"&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=4 align=left class=td1 >销售点地址："+sAddress+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >产品代码："+sBusinessType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >内部代码："+sInteriorCode+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >贷款用途：&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>个人资料</b>&nbsp;</td>");
		sTemp.append("</tr>");
	
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >1.姓名："+sCustomerName+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >2.性别："+sSex+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >3.身份证号："+sCertID+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >4.发证机关："+sIssueinstitution+"&nbsp;</td>");
		sTemp.append("<td colspan=2 rowspan=3 align=left class=td1 >照片&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >5.身份证有效期："+sMaturityDate+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >6.社保号码/学生号码："+sSino+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >7.教育程度："+sEduExperience+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >8.住宅/宿舍电话："+sFamilyTel+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >9.住宅电话登记人："+sPhoneMan+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >10.手机："+sMobileTelephone+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >11.电子邮箱："+sEmailAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >12.QQ号码："+sQQNo+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >13.婚姻状况："+sMarriage+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >14.子女数目："+sChildrentotal+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >15.住房状况："+sHouse+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >16.户籍地址："+sNativeplace+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >17.镇/乡："+sVillagetown+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >18.街道/村："+sStreet+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >19.小区/楼盘："+sCommunity+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >20.栋/单元/房间号："+sCellNo+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >21.现居住地址："+sFamilyAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >22.镇/乡："+sCountryside+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >23.街道/村："+sVillagecenter+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >24.小区/楼盘："+sPlot+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >25.栋/单元/房间号："+sRoom+"&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 >26.现居住地址是否与户籍地址相同："+sFlag2+"&nbsp;</td>");
		sTemp.append("</tr>");


		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>现金分期明细</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >19.贷款本金："+sBusinessSum+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >20.分期期数："+sPeriods+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >21.每月还款额：&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >22.首次还款日：&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >23.每月还款日：&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >24.月贷款利率："+sCreditRate+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >25.月客户服务费率："+sCUSTOMERSERVICERATES+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >26.月财务管理费率："+sMANAGEMENTFEESRATE+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >27.月手续费率："+sPdgRatio+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >28.印花税："+sSTAMPTAX+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>还款账户信息</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >29.指定还款账号："+sRepaymentNo+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >30.开户银行："+sRepaymentBank+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >31.户名："+sRepaymentName+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >32.客户银行卡号/账号："+sReplaceAccount+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >33.客户开户银行："+sOpenBranch+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >34.客户银行账户户名："+sReplaceName+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >35.银行代扣还款：&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 ><b>代扣显示文本</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>单位信息</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >36.单位/学校/个体全称："+sWorkCorp+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >37.任职部门/班级："+sEmployRecord+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >38.职位："+sHeadShip+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >39.行业类别："+sIndustryType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >40.单位性质："+sCellProperty+"&nbsp;</td>");

		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >41.单位电话："+sWorkTel+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >42.现居住地址："+sWorkAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >43.镇/乡："+sUnitCountryside+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >44.街道/村："+sUnitStreet+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >45.小区/楼盘："+sUnitRoom+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=2 align=left class=td1 >46.栋/单元/房间号："+sUnitNo+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >47.邮寄地址："+sCommAdd+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >48.总工作经验/大学学习时间(年)："+sJobTotal+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >49.现单位工作/个体营业时间/距离毕业时间(月)："+sJobTime+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >50.在现单位是否购买社保："+sFlag4+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>配偶及家庭成员信息</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >47.配偶姓名："+sSpouseName+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >48.配偶移动电话："+sSpouseTel+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >49.配偶单位名称：&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >50.配偶单位电话：&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >51.家庭成员名称："+sKinshipName+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >52.家庭成员类型："+sRelativeType+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >53.家庭成员电话："+sKinshipTel+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >54.家庭成员联系地址："+sKinshipAdd+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>其他联系人信息</b>&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>收入及支出信息</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >55.联系人姓名："+sOtherContact+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >56.与申请人关系："+sRelativeType1+"&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >57.联系电话："+sContactTel+"&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >58.月收入总额（元）："+sZE+"&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >59.其他收入（元/月）："+sOtherRevenue+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >60.家庭月收入（元）："+sFamilyMonthIncome+"&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >61.个人支出（元/月）："+sCE+"&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 bgcolor=#aaaaaa ><b>其他信息</b>&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >提供的申请材料&nbsp;</td>");
		sTemp.append("<td colspan=4 align=left class=td1 >产品附录：&nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >是否签署授权书&nbsp;</td>");
		sTemp.append("</tr>");
		
		sTemp.append("<tr>");
		sTemp.append("<td colspan=10 align=left class=td1 >本人具有完全民事行为能力签署本申请表并承担相应责任。本人已仔细阅读并完全了解《个人消费贷款及相关服务合同条款与条件》，并且自愿遵守相关的合同规定。<br>本人保证在此表上填写、确认的内容及向贷款人、客户服务供应商提供的所有相关资料全部真实、有效，如本人提供虚假资料，将承担由此引起的一切责任及损失。<br>本人在此同意贷款人和客户服务供应商按照相关法律法规的规定，向有权机构报送本人的个人信用信息，包括但不限于本申请表项下的信息，同时，授权贷款人和客户服务供应商向任何可能的来源查询本人及配偶的与贷款申请有关的个人信息和个人信用信息，相关查询结果的用途将用于贷款审查和贷款管理。<br>本人同意如因单方面取消申请或不具备借款条件，申请不获批准，本表格及所有已提交的资料无须退还本人，由客户服务供应商处理。贷款人有权拒绝本贷款申请而无须给予任何原因解释。</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=3 align=left class=td1 >销售顾问姓名 &nbsp;</td>");
		sTemp.append("<td colspan=3 align=left class=td1 >销售顾问签名：&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >客户签名:&nbsp;</td>");
		sTemp.append("<td colspan=2 align=left class=td1 >日期:&nbsp;</td>");
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
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
