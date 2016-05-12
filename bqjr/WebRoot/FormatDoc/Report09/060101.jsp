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
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//担保客户ID号
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	//获得保证人客户类型
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = '"+sGuarangtorID+"'";
	String sCustomerType = "";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sCustomerType = rs2.getString(1);
	rs2.getStatement().close();
	if(sCustomerType==null) sCustomerType="";
	sCustomerType=sCustomerType.substring(0,2);
	
	String sRegisterAdd = "";		//注册地址
	String sOfficeAdd = "";			//办公地址
	String sOrgType = "";		//企业性质
	String sIndustryType = "";		//行业类型
	String sRegisterCapital = "";	//注册资本
	String sPaiclUpCapital = "";	//实收资本
	String sScopeName = "";			//企业规模
	String CreditLevel = "";		//信用等级
	String FictitiousPerson = "";	//法人代表
	String SetupDate = "";			//成立时间
	String GroupFlag = "";			//是否征信标准集团客户
	String MostBusiness = "";		//主营业务
	String ListingCorpType = "";	//上市公司类型
	
	//申请人基本信息
	rs2 = Sqlca.getResultSet("select RegisterAdd,OfficeAdd,getitemname('OrgType',OrgType) as OrgTypeName,"
							+"getitemName('IndustryType',IndustryType) as IndustryType,RegisterCapital,PaiclUpCapital,getitemname('Scope',Scope) as ScopeName,"
							+"CreditLevel,FictitiousPerson,SetupDate,getItemName('YesNo',GroupFlag) as GroupFlag,"
							+"MostBusiness,getItemname('ListingCorpType',ListingCorpOrNot) as ListingCorpType "
							+"from ENT_INFO where CustomerID='"+sGuarangtorID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString(1);
		if(sRegisterAdd == null) sRegisterAdd=" ";
		
		sOfficeAdd = rs2.getString(2);
		if(sOfficeAdd == null) sOfficeAdd=" ";
		
		sOrgType = rs2.getString(3);
		if(sOrgType == null) sOrgType=" ";
		
		sIndustryType = rs2.getString(4);
		if(sIndustryType == null) sIndustryType=" ";
		
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(5)/10000);
		
		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble(6)/10000);
		
		sScopeName = rs2.getString(7);
		if(sScopeName == null) sScopeName=" ";
		
		CreditLevel = rs2.getString(8);
		if(CreditLevel == null) CreditLevel=" ";
		
		FictitiousPerson = rs2.getString(9);
		if(FictitiousPerson == null) FictitiousPerson=" ";
		
		SetupDate = rs2.getString(10);
		if(SetupDate == null) SetupDate=" ";
		
		GroupFlag = rs2.getString(11);
		if(GroupFlag == null) GroupFlag=" ";
		
		MostBusiness = rs2.getString(12);
		if(MostBusiness == null) MostBusiness=" ";
		
		ListingCorpType = rs2.getString(13);
		if(ListingCorpType == null) ListingCorpType=" ";
	}
	rs2.getStatement().close();	
	
	String sNewCustomer = " ";//是否新客户
	rs2 = Sqlca.getResultSet("select count(*) from BUSINESS_CONTRACT where CustomerID='"+sGuarangtorID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)>1)sNewCustomer = "否";
		 else sNewCustomer = "是";
	}
	rs2.getStatement().close();	
	
	String sIsDirector = " ";//是否我行股东
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '040' and CustomerID='"+sGuarangtorID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)==0)sIsDirector = "否";
		 else sIsDirector = "是";
	}
	rs2.getStatement().close();	
	
	String sIsWarner = "";	//是否我行风险预警客户
	
	
	String sBourseName = "";//上市地点
	String sIPODate = "";	//上市时间
	String sStockName = "";	//股票简称
	String sStockCode = "";	//股票代码
	
	
	
	//获得编号
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '06__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "6."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='060101.jsp' name='reportInfo'>");
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	if(j==0)
	{
		sTemp.append("   <tr>");
		sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6 担保方式分析</font></td> ");	
		sTemp.append("   </tr>");
	}	
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6.1、保证方式</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6.1.1、保证人基本信息（单位：万元）</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 > 注册地址 </td>");
    sTemp.append(" <td colspan='3' align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 办公地址 </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sOfficeAdd+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 企业性质 </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sOrgType+"&nbsp;</td>");
    sTemp.append("     <td width=17% align=center class=td1 > 行业分类 </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sIndustryType+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 注册资本 </td>");
    sTemp.append("     <td align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 实收资本 </td>");
    sTemp.append("     <td align=left class=td1 >"+sPaiclUpCapital+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 企业规模 </td>");
    sTemp.append("     <td align=left class=td1 >"+sScopeName+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 信用等级 </td>");
    sTemp.append("     <td align=left class=td1 >"+CreditLevel+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 法人代表 </td>");
    sTemp.append("     <td align=left class=td1 >"+FictitiousPerson+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > 成立时间 </td>");
    sTemp.append("     <td align=left class=td1 >"+SetupDate+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > 是否新客户 </td>");
    sTemp.append("     <td align=left class=td1 >"+sNewCustomer+"&nbsp;</td>");
    
	sTemp.append("     <td align=center class=td1 > 是否我行股东 </td>");
    sTemp.append("     <td align=left class=td1 >"+sIsDirector+"&nbsp;</td>");
    
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td colspan='4' align=left class=td1 > 经营范围：<br>"+MostBusiness+"&nbsp;</td>");
    sTemp.append("  </tr>");
	
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
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