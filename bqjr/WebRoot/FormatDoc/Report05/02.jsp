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
	String sCustomerName = "";			//客户名称
	String sCreditLevel = "";		    //信用等级
	String sLicenseNo = "";		        //营业执照号码
	String sCorpID = "";		    //组织机构代码
	
	String sRegisterCapital = "";	    //注册资本
	String sCurrency = "";				//币种
	String sPaiclUpCapital = "";		//实收资本
	String sNewCustomer = " ";			//是否新客户
	String sIsWarner = "";				//是否我行风险预警客户
	String sMostBusiness = "";			//主营业务

	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getitemname('Currency',BusinessCurrency) as CurrencyName from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	if(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName = "&nbsp;";

		sCurrency = rs2.getString(2);
		if(sCurrency == null) sCurrency = " ";
	}
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select CreditLevel,LicenseNo,CorpID,RegisterCapital,PaiclUpCapital,MostBusiness from ENT_INFO where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		sCreditLevel = rs2.getString(1);
		if(sCreditLevel == null) sCreditLevel = " ";

		sLicenseNo = rs2.getString(2);
		if(sLicenseNo == null) sLicenseNo = " ";
		
		sCorpID = rs2.getString(3);
		if(sCorpID == null) sCorpID = " ";

		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(4)/10000);
		
		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble(5)/10000);

		sMostBusiness = rs2.getString(6);
		if(sMostBusiness == null) sMostBusiness = " ";
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
	sTemp.append("   <td colspan=4 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
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
	sTemp.append("   <td width=14% align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
	sTemp.append("   <td width=7% align=center class=td1 > 币种</td>");
	sTemp.append("   <td width=8% align=left class=td1 >"+sCurrency+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 > 实收资本(万) </td>");
	sTemp.append("   <td align=left class=td1 >"+sPaiclUpCapital+"&nbsp;</td>");
	sTemp.append("   <td width=6% align=center class=td1 > 币种 </td>");
	sTemp.append("   <td width=8% align=left class=td1 >"+sCurrency+"&nbsp;</td>");
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

