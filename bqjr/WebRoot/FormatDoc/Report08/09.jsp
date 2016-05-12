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
	String sCustomerName = "";			//申请人名称
	String sBusinessType = "";			//业务品种
	String sBusinessTypeName = "";		//授信业务品种名称
	String sBusinessSum = "";			//金额
	String sCurrency = "";				//币种
	String sBailRatio = "";				//保证金比例％
	String sBusinessRate = "";			//利率
	String sPdgRatio = "";				//手续费率
	String sClassifyResult = "";		//五级分类
	String sVouchType = "";				//担保方式
	String sPurpose = "";				//资金用途
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,BusinessType,getBusinessName(BusinessType)as BusinessTypeName,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BailRatio,BusinessRate,PdgRatio, "
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose "
										+"from business_Apply where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == null) sCurrency = " ";
		
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));

		sBusinessRate = rs2.getString("BusinessRate");	
		
		sPdgRatio = DataConvert.toMoney(rs2.getDouble("PdgRatio"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == null) sVouchType = " ";
		
		sPurpose = rs2.getString("purpose");
		if(sPurpose == null) sPurpose = "  ";
	}
	
	rs2.getStatement().close();	
	
	String sSql = 	"select GuarantorName,getItemName('GuarantyType',GuarantyType) from GUARANTY_CONTRACT " +
					" where serialno in " +
					"  (select objectno  from apply_relative "+
					"    where objecttype='GUARANTY_CONTRACT' and serialno='"+sObjectNo+"') order by GuarantyType";
	String sGuarantyType = "";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantyType += rs2.getString(1)+"-"+rs2.getString(2)+"<br>&nbsp;<br>";
	}
	
	rs2.getStatement().close();	
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='09.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append(" <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append(" <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >9、<strong>授信方案制定</strong> </font></td>"); 	
	sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 > 授信业务品种</td>");
    sTemp.append(" <td width=18% align=center class=td1 > 金额（万） </td>");
    sTemp.append(" <td width=10% align=center class=td1 > 币种 </td>");
    sTemp.append(" <td width=17% align=center class=td1 > 保证金比例％</td>");
    sTemp.append(" <td width=20% align=center class=td1 > 利率/费率 </td>");
    sTemp.append(" <td width=20% align=center class=td1 > 五级分类 </td>");
    sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
    sTemp.append(" <td width=18% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 >"+sCurrency+"&nbsp;</td>");
    sTemp.append(" <td width=17% align=center class=td1 >"+sBailRatio+"&nbsp;</td>");
    
    //表内业务取月利率，表外业务取手续费率
    if(sBusinessType.substring(0,1).equals("1"))	//表内业务
    	sTemp.append(" <td width=20% align=center class=td1 >"+sBusinessRate+"</td>");
    else if(sBusinessType.substring(0,1).equals("2"))	//表外业务
    	sTemp.append(" <td width=20% align=center class=td1 >"+sPdgRatio+"</td>");
    else	//其他业务
    	sTemp.append(" <td width=20% align=center class=td1 >0.00</td>");
    	
    sTemp.append(" <td width=20% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan='6' align=left class=td1 > 本笔授信业务的担保方式和具体内容： <p>主要担保方式－"+sVouchType+"</p>"+sGuarantyType+"&nbsp;</td>");
    sTemp.append(" </tr>");
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