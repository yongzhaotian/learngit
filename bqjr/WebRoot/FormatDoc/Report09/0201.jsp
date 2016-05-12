<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   fhuang  2006.01.09
		Tester:
		Content: 中小企业调查报告
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
	String sRegisterAdd = "";		//注册地址
	String sRegisterCapital = "";	//注册资本
	String sPaiclUpCapital = "";	//实收资本
	String SetupDate = "";			//成立时间
	String MostBusiness = "";		//主营业务
	String sCustomerName = "";//企业名称
	String sWebAdd = "";//网址
	String sLicenseNo = "";//营业执照号码
	String sYearCheck = "是";//是否年检（如果企业信息表中有这个字段请自行取值）
	String sIndustryTypeName = "";//行业
	int iEmployeeNumber = 0;//职工人数
	String sPerson = "";//法定代表人
	String sBasicBank = "";//基本账户行
	String sLoanCardNo = "";//贷款卡卡号

	String sControlPerson = "";//实际控制人(目前默认法定代表人，如有实际控制人请自行取值)
	int iCountYear = 10;//从业年限(目前还没有这个字段)
	String sBadRecord = "否";//是否有不良记录(目前还没有这个字段)

	String sOfficeTel = "";//公司电话
	String sOfficeFax = "";//公司传真	
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,RegisterCapital,PaiclUpCapital,"
							+"SetupDate,MostBusiness,EnterpriseName,WebAdd,LicenseNo,"
							+"getItemName('IndustryType',IndustryType) as IndustryTypeName,"
							+"EmployeeNumber,FictitiousPerson,BasicBank,LoanCardNo,"
							+"OfficeTel,OfficeFax "
							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString("RegisterAdd");
		if(sRegisterAdd == null) sRegisterAdd=" ";
				
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble("RegisterCapital")/10000);
		
		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble("PaiclUpCapital")/10000);
		
		SetupDate = rs2.getString("SetupDate");
		if(SetupDate == null) SetupDate=" ";
		
		
		MostBusiness = rs2.getString("MostBusiness");
		if(MostBusiness == null) MostBusiness=" ";
		
		sCustomerName = rs2.getString("EnterpriseName");
		if(sCustomerName == null) sCustomerName=" ";
		
		sWebAdd = rs2.getString("WebAdd");
		if(sWebAdd == null) sWebAdd=" ";
		
		sLicenseNo = rs2.getString("LicenseNo");
		if(sLicenseNo == null) sLicenseNo=" ";
		
		sIndustryTypeName = rs2.getString("IndustryTypeName");
		if(sIndustryTypeName == null) sIndustryTypeName=" ";
		
		iEmployeeNumber = rs2.getInt("EmployeeNumber");
		
		sPerson = rs2.getString("FictitiousPerson");
		if(sPerson == null) sPerson=" ";
		
		sBasicBank = rs2.getString("BasicBank");
		if(sBasicBank == null) sBasicBank=" ";
		
		sLoanCardNo = rs2.getString("LoanCardNo");
		if(sLoanCardNo == null) sLoanCardNo=" ";
		
		sOfficeTel = rs2.getString("OfficeTel");
		if(sOfficeTel == null) sOfficeTel=" ";
		
		sOfficeFax = rs2.getString("OfficeFax");
		if(sOfficeFax == null) sOfficeFax=" ";
	}
	rs2.getStatement().close();	
	
	String sFictitiousPerson = "";//股东名称
	double  dInvestmentSum = 0.00;//投资金额
	double  dInvestmentProp = 0.00;//投资比例
	String sSql = "";
	
	sSql = "select CustomerName,round(InvestmentSum/10000,2) as InvestmentSum,InvestmentProp "+
	       " from CUSTOMER_RELATIVE " +
		   " where CustomerID = '"+sCustomerID+"' "+
		   " and RelationShip like '52%' "+
		   " and length(RelationShip)>2 "+
		   " and EffStatus='1'";
    rs2 = Sqlca.getASResultSet(sSql);
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2、客户调查分析</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1、基本情况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=12 align=center class=td1 > <B>基本情况</B> </td>");
    sTemp.append(" </tr>");	
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > 名称 </td>");
    sTemp.append("     <td colspan=6 class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("     <td colspan=2  class=td1 > 成立年限 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+SetupDate+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td colspan=2 class=td1 > 注册地址 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sRegisterAdd+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 注册资本 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sRegisterCapital+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 网址 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sWebAdd+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > 经营范围</td>");
	sTemp.append("     <td colspan=2 class=td1 >"+MostBusiness+"&nbsp;</td>");
	sTemp.append("     <td colspan=2 class=td1 > 行业 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sIndustryTypeName+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 人数 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+iEmployeeNumber+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > 营业执照 </td>");
    sTemp.append("     <td colspan=6 class=td1 >"+sLicenseNo+"&nbsp;</td>");
    sTemp.append("     <td colspan=2  class=td1 > 是否年检 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sYearCheck+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
    sTemp.append("     <td colspan=2 class=td1 > 法定代表人 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sPerson+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 基本开户行 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sBasicBank+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 贷款卡卡号 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sLoanCardNo+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
    sTemp.append("     <td colspan=2 class=td1 > 实际控制人 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sPerson+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 从业年限 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+iCountYear+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 是否有不良记录 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sBadRecord+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > 经办人 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sPerson+"&nbsp;</td>");
    sTemp.append("     <td colspan=2  class=td1 > 电话 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sOfficeTel+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > 传真 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sOfficeFax+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=12 align=center class=td1 > <B>股权情况</B> </td>");
    sTemp.append(" </tr>");	
    sTemp.append("   <tr>");
    sTemp.append("     <td colspan=4 class=td1 align=center > 主要股东 </td>");
    sTemp.append("     <td colspan=4 class=td1 align=center> 投资金额（万元） </td>");
    sTemp.append("     <td colspan=4 class=td1 align=center> 占比(%) </td>");
    sTemp.append("  </tr>");
    while(rs2.next())
    {
    	sFictitiousPerson = rs2.getString("CustomerName");
    	dInvestmentSum = rs2.getDouble("InvestmentSum");
    	dInvestmentProp = rs2.getDouble("InvestmentProp");
    	if(sFictitiousPerson == null) sFictitiousPerson = " ";
    	sTemp.append("   <tr>");
	    sTemp.append("     <td colspan=4 class=td1 align=center> "+sFictitiousPerson+"&nbsp;</td>");
	    sTemp.append("     <td colspan=4 class=td1 align=center> "+DataConvert.toMoney(dInvestmentSum)+"&nbsp;</td>");
	    sTemp.append("     <td colspan=4 class=td1 align=center>  "+DataConvert.toMoney(dInvestmentProp)+"&nbsp;</td>");
	    sTemp.append("  </tr>");
	}
    rs2.getStatement().close();
    
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
