<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第?页
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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
/*
'	String sRegisterAdd = "";		//注册地址
'	String sOfficeAdd = "";			//办公地址
'	String sOrgType = "";		//企业性质
'	String sIndustryType = "";		//行业类型
'	String sRegisterCapital = "";	//注册资本
'	String sPaiclUpCapital = "";	//实收资本
'	String sScopeName = "";			//企业规模
'	String CreditLevel = "";		//信用等级
'	String FictitiousPerson = "";	//法人代表
'	String SetupDate = "";			//成立时间
'	String GroupFlag = "";			//是否征信标准集团客户
'	String MostBusiness = "";		//主营业务
'	String ListingCorpType = "";	//上市公司类型
	
'	//申请人基本信息
'	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,OfficeAdd,getitemname('OrgType',OrgType) as OrgTypeName,"
'							+"getitemName('IndustryType',IndustryType) as IndustryType,RegisterCapital,PaiclUpCapital,getitemname('Scope',Scope) as ScopeName,"
'							+"getItemName('CreditLevel',CreditLevel),FictitiousPerson,SetupDate,getItemName('YesNo',GroupFlag) as GroupFlag,"
'							+"MostBusiness,getItemname('ListingCorpType',ListingCorpOrNot) as ListingCorpType "
'							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
'	
'	if(rs2.next())
'	{
'		sRegisterAdd = rs2.getString(1);
'		if(sRegisterAdd == null) sRegisterAdd=" ";
'		
'		sOfficeAdd = rs2.getString(2);
'		if(sOfficeAdd == null) sOfficeAdd=" ";
'		
'		sOrgType = rs2.getString(3);
'		if(sOrgType == null) sOrgType=" ";
'		
'		sIndustryType = rs2.getString(4);
'		if(sIndustryType == null) sIndustryType=" ";
'		
'		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(5)/10000);
'		
'		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble(6)/10000);
'		
'		sScopeName = rs2.getString(7);
'		if(sScopeName == null) sScopeName=" ";
'		
'		CreditLevel = rs2.getString(8);
'		if(CreditLevel == null) CreditLevel=" ";
'		
'		FictitiousPerson = rs2.getString(9);
'		if(FictitiousPerson == null) FictitiousPerson=" ";
'		
'		SetupDate = rs2.getString(10);
'		if(SetupDate == null) SetupDate=" ";
'		
'		GroupFlag = rs2.getString(11);
'		if(GroupFlag == null) GroupFlag=" ";
'		
'		MostBusiness = rs2.getString(12);
'		if(MostBusiness == null) MostBusiness=" ";
'		
'		ListingCorpOrNot = rs2.getString(13);
'		if(ListingCorpOrNot == null) ListingCorpOrNot=" ";
'	}
'	rs2.getStatement().close();	

'String sNewCustomer = " ";//是否新客户
'	rs2 = Sqlca.getResultSet("select count(*) from BUSINESS_CONTRACT where CustomerID='"+sCustomerID+"'");
'	if(rs2.next())
'	{
'		 if(rs2.getInt(1)>1)sNewCustomer = "否";
'		 else sNewCustomer = "是";
'	}
'	rs2.getStatement().close();	
'	
'	String sIsDirector = " ";//是否我行股东
'	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '040' and CustomerID='"+sCustomerID+"'");
'	if(rs2.next())
'	{
'		 if(rs2.getInt(1)==0)sIsDirector = "否";
'		 else sIsDirector = "是";
'	}
'	rs2.getStatement().close();	
'	
'	String sIsWarner = "";	//是否我行风险预警客户
'	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType in('010','020') and CustomerID = '"+sCustomerID+"'");
'	if(rs2.next()) 
'	{
'		if(rs2.getInt(1) >=1 ) sIsWarner = "是";
'		else sIsWarner = "否";
'	}
'	rs2.getStatement().close();
'	
'	String sBourseName = "";//上市地点
'	String sIPODate = "";	//上市时间
'	String sStockName = "";	//股票简称
'	String sStockCode = "";	//股票代码
'	
'	rs2 = Sqlca.getResultSet("select BourseName,IPODate,StockName,StockCode from ENT_IPO where CustomerID='"+sCustomerID+"' Order by IPODate DESC");
'	if(rs2.next())
'	{
'		sBourseName = rs2.getString(1);
'		if(sBourseName == null) sBourseName=" ";
'		sIPODate = rs2.getString(2);
'		if(sIPODate == null) sIPODate=" ";
'		sStockName = rs2.getString(3);
'		if(sStockName == null) sStockName=" ";
'		sStockCode = rs2.getString(4);
'		if(sStockCode == null) sStockCode=" ";
'	}
'	rs2.getStatement().close();
*/

//Add by zhaominglei 060308

	String sCustomerName = "";			//姓名
	String sCertType = "";			//证件类型
	String sCertID = "";				//证件号码
	String sSex = "";						//性别
	String sBirthday = "";			//出生日期
	String sEduExperience = "";	//最高学历
	String sEduDegree = "";			//最高学位
	String sNativePlace = "";		//户籍地址
	String sMarriage = "";			//婚姻状况
	String sFamilyAdd = "";			//居住地址
	String sFamilyZIP = "";		//居住地址邮编
	String sCommAdd = "";				//通讯地址
	String sCommZip = "";				//通讯地址邮编
	String sOccupation = "";		//职业	
	String sHeadShip = "";			//职务
	String sPosition = "";			//职称
	String sIndustryTypeName = "";	//目前从事行业
	String sWorkCorp = "";			//单位名称
	
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getItemName('CertType',CertType) as CertType,CertID,getItemName('Sex',Sex) as Sex,Birthday,getItemName('EducationExperience',EduExperience) as EduExperience,getItemName('EducationDegree',EduDegree) as EduDegree,"
							+"NativePlace,getItemName('Marriage',Marriage) as Marriage,FamilyAdd,FamilyZIP,CommAdd,CommZip,getItemName('Occupation',Occupation) as Occupation,getItemName('HeadShip',HeadShip) as HeadShip,"
							+"getItemName('TechPost',Position) as Position,getItemName('IndustryType',UnitKind) as IndustryTypeName,WorkCorp "
							+"from IND_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName=" ";
		
		sCertType = rs2.getString(2);
		if(sCertType == null) sCertType=" ";
		
		sCertID = rs2.getString(3);
		if(sCertID == null) sCertID=" ";
		
		sSex = rs2.getString(4);
		if(sSex == null) sSex=" ";
		
		sBirthday = rs2.getString(5);
		if(sBirthday == null) sBirthday=" ";
		
		sEduExperience = rs2.getString(6);
		if(sEduExperience == null) sEduExperience=" ";
		
		sEduDegree = rs2.getString(7);
		if(sEduDegree == null) sEduDegree=" ";
		
		sNativePlace = rs2.getString(8);
		if(sNativePlace == null) sNativePlace=" ";
		
		sMarriage = rs2.getString(9);
		if(sMarriage == null) sMarriage=" ";
		
		sFamilyAdd = rs2.getString(10);
		if(sFamilyAdd == null) sFamilyAdd=" ";
		
		sFamilyZIP = rs2.getString(11);
		if(sFamilyZIP == null) sFamilyZIP=" ";
		
		sCommAdd = rs2.getString(12);
		if(sCommAdd == null) sCommAdd=" ";
		
		sCommZip = rs2.getString(13);
		if(sCommZip == null) sCommZip=" ";
		
		sOccupation = rs2.getString(14);
		if(sOccupation == null) sOccupation=" ";
		
		sHeadShip = rs2.getString(15);
		if(sHeadShip == null) sHeadShip=" ";
		
		sPosition = rs2.getString(16);
		if(sPosition == null) sPosition=" ";
		
		sIndustryTypeName = rs2.getString(17);
		if(sIndustryTypeName == null) sIndustryTypeName=" ";
		
		sWorkCorp = rs2.getString(18);
		if(sWorkCorp == null) sWorkCorp=" ";

	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2 申请人基本信息</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1、概况</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 > 姓名 </td>");
    sTemp.append(" <td colspan='3' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 证件类型 </td>");
    sTemp.append("     <td colspan='1' align=left class=td1 >"+sCertType+"&nbsp;</td>");
	sTemp.append("     <td align=center class=td1 > 证件号码 </td>");
	sTemp.append("     <td width=15% align=left class=td1 >"+sCertID+"&nbsp;</td>");
	 sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td width=17% align=center class=td1 > 性别 </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sSex+"&nbsp;</td>");
   	sTemp.append("     <td align=center class=td1 > 出生日期 </td>");
    sTemp.append("     <td align=left class=td1 >"+sBirthday+"&nbsp;</td>");
     sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > 最高学历 </td>");
    sTemp.append("     <td align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
	sTemp.append("     <td align=center class=td1 > 最高学位 </td>");
    sTemp.append("     <td align=left class=td1 >"+sEduDegree+"&nbsp;</td>");
   sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > 户籍地址 </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 婚姻状况 </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sMarriage+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 居住地址 </td>");
    sTemp.append("     <td align=left class=td1 >"+sFamilyAdd+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 居住地址邮编 </td>");
    sTemp.append("     <td align=left class=td1 >"+sFamilyZIP+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 通讯地址 </td>");
    sTemp.append("     <td align=left class=td1 >"+sCommAdd+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 通讯地址邮编 </td>");
    sTemp.append("     <td align=left class=td1 >"+sCommZip+"&nbsp;</td>");
    sTemp.append("  </tr>");
//	sTemp.append("   <tr>");
//	sTemp.append("     <td colspan='4' align=left class=td1 > 经营范围：<br>"+MostBusiness+"&nbsp;</td>");
//    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 职业 </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sOccupation+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > 职务 </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sHeadShip+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 职称 </td>");
    sTemp.append("    <td colspan='3' align=center class=td1 >"+sPosition+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > 目前从事行业 </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sIndustryTypeName+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > 单位名称 </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sWorkCorp+"&nbsp;</td>");
//End by zhaominglei 060308
    
    sTemp.append(" </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='CustomerID' value='"+sCustomerID+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.getClientID()+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.getClientID()+"'>");
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
