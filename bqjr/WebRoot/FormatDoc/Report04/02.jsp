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
	String sCountNum = ""; 	
	String sNewCustomer = "是";		//新客户  
	String sEnterpriseName = "&nbsp;";	//客户名称       
	String sCreditLevel = "&nbsp;";		//信用等级       	
	String sLicenseNo = "&nbsp;";         //营业执照号码   
	String sCorpID = "&nbsp;";            //组织机构代码   
	String sRegisterCapital = "&nbsp;";   //注册资本       
	String sRCCurrency = "&nbsp;";        //币种           
	String sPaiclUpCapital = "&nbsp;";    //实收资本       
	String sPCCurrency = "&nbsp;";        //币种           
	String sMostBusiness = "&nbsp;";      //主营业务： 
	String sIsWarner = "";				//是否我行风险预警客户

	//获得调查报告数据
//***********************************************************************	
	
	//判断是否新客户 如果为1则是新客户，否则为老客户
	ASResultSet rs2 = Sqlca.getResultSet("select count(*) as CountNum from business_Apply where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		sCountNum = rs2.getString("CountNum");
		if(sCountNum == null || sCountNum.equals("1")) sNewCustomer = "否";
	}
	rs2.getStatement().close();

	rs2 = Sqlca.getResultSet("select EnterpriseName,"+		//客户名称
					"CreditLevel,"+			//信用等级
					"LicenseNo,"+                   //营业执照号码
					"CorpID,"+                      //组织机构代码
					"RegisterCapital,"+             //注册资本
					"getItemName('Currency',RCCurrency) as RCCurrency,"+                  //币种
					"PaiclUpCapital,"+              //实收资本
					"getItemName('Currency',PCCurrency) as PCCurrency,"+                  //币种
					"MostBusiness "+                //主营业务：
					" from ent_info Where CustomerID ='"+sCustomerID+"'");	
	if(rs2.next())
	{
		sEnterpriseName = rs2.getString("EnterpriseName");	//客户名称       
		if (sEnterpriseName == null || sEnterpriseName.equals("")) sEnterpriseName = "&nbsp;";

		sCreditLevel = rs2.getString("CreditLevel");	//信用等级
		if (sCreditLevel == null || sCreditLevel.equals("")|| sCreditLevel.equals(" ")) sCreditLevel = "&nbsp;";

		sLicenseNo = rs2.getString("LicenseNo");         //营业执照号码   
		if (sLicenseNo == null || sLicenseNo.equals("")) sLicenseNo = "&nbsp;";

		sCorpID = rs2.getString("CorpID");            //组织机构代码   
		if (sCorpID == null || sCorpID.equals("")) sCorpID = "&nbsp;";

		sRegisterCapital = DataConvert.toMoney(rs2.getDouble("RegisterCapital")/10000);   //注册资本       
		if (sRegisterCapital == null || sRegisterCapital.equals("")) sRegisterCapital = "&nbsp;";

		sRCCurrency = rs2.getString("RCCurrency");        //币种           
		if (sRCCurrency == null || sRCCurrency.equals("")) sRCCurrency = "&nbsp;";

		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble("PaiclUpCapital")/10000);    //实收资本       
		if (sPaiclUpCapital == null || sPaiclUpCapital.equals("")) sPaiclUpCapital = "&nbsp;";

		sPCCurrency = rs2.getString("PCCurrency");        //币种           
		if (sPCCurrency == null || sPCCurrency.equals("")) sPCCurrency = "&nbsp;";

		sMostBusiness = rs2.getString("MostBusiness");      //主营业务：        
		if (sMostBusiness == null || sMostBusiness.equals("")) sMostBusiness = "&nbsp;";
	}
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select count(*) from Business_Contract where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)>1)sNewCustomer = "否";
		 else sNewCustomer = "是";
	}
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType in('010','020') and CustomerID = '"+sCustomerID+"'");
	if(rs2.next()) 
	{
		if(rs2.getInt(1) >=1 ) sIsWarner = "是";
		else sIsWarner = "否";
	}
	rs2.getStatement().close();

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='8' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2、申请人信息</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=19% align=center class=td1 >客户名称</td>");
	sTemp.append("   <td colspan=4 align=left class=td1 >"+sEnterpriseName+"&nbsp;</td>");
	sTemp.append("   <td width=14% align=center class=td1 >信用等级</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sCreditLevel+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >营业执照号码</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sLicenseNo+"&nbsp;</td>");
	sTemp.append("   <td width=24% align=center class=td1 >组织机构代码</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sCorpID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 > 注册资本(万) </td>");
	sTemp.append("   <td width=14% align=right class=td1 >"+sRegisterCapital+"&nbsp;</td>");
	sTemp.append("   <td width=7% align=center class=td1 > 币种</td>");
	sTemp.append("   <td width=8% align=left class=td1 >"+sRCCurrency+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 > 实收资本(万) </td>");
	sTemp.append("   <td align=right class=td1 >"+sPaiclUpCapital+"&nbsp;</td>");
	sTemp.append("   <td width=6% align=center class=td1 > 币种 </td>");
	sTemp.append("   <td width=8% align=left class=td1 >"+sRCCurrency+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 > 是否新客户 </td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sNewCustomer+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 > 是否我行风险<br>预警客户</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sIsWarner+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left class=td1 > 经营范围：<br>"+sMostBusiness+"&nbsp;</td>"); 
	sTemp.append("   </tr>");
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

