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

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//判断该报告是否完成
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	String sClassifyDate = "";
	String sUserName = "";
	String sOrgName = "";
	String sBusinessTypeName = "";
	String sCurrency = "";
	String sBCSerialNo = "";
	String sBusinessSum = "";
	String sBalance = "";
	String sResult1Name = "";
	String sCustomerName = "";
	String sOccurType = "";
	//按照合同资产风险分类
	sSql =  " select BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.SerialNo,BC.CustomerName,getItemName('OccurType',BC.OccurType) as OccurType,"+
			" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			" BC.BusinessSum,BC.Balance,"+
			" CR.ClassifyDate,"+
			" CR.Result1,getItemName('ClassifyResult',CR.Result1) as Result1Name,"+
			" CR.UserID,getUserName(CR.UserID) as UserName,"+
			" CR.OrgID,getOrgName(CR.OrgID) as OrgName"+
			" from BUSINESS_CONTRACT BC,CLASSIFY_RECORD CR "+
			" where CR.ObjectType = 'BusinessContract' "+
			" and CR.ObjectNo = BC.SerialNo "+
			" and CR.UserID = '"+CurUser.getUserID()+"' "+
			" and BC.CustomerID = '"+sObjectNo+"' "+
			" order by CR.ClassifyDate desc";
	//按照借据资产风险分类
	/*
	sSql =  " select BD.BusinessType,getBusinessName(BD.BusinessType) as BusinessTypeName,"+
			" BD.SerialNo,BD.CustomerName,getItemName('OccurType',BD.OccurType) as OccurType,"+
			" BD.BusinessCurrency,getItemName('Currency',BD.BusinessCurrency) as Currency,"+
			" BD.BusinessSum,BD.Balance,"+
			" CR.ClassifyDate,"+
			" CR.Result1,getItemName('ClassifyResult',CR.Result1) as Result1Name,"+
			" CR.UserID,getUserName(CR.UserID) as UserName,"+
			" CR.OrgID,getOrgName(CR.OrgID) as OrgName"+
			" from BUSINESS_DUEBILL BD,CLASSIFY_RECORD CR "+
			" where CR.ObjectType = 'BusinessDueBill' "+
			" and CR.ObjectNo = BD.SerialNo "+
			" and CR.UserID = '"+CurUser.getUserID()+"' "+
			" and BD.CustomerID = '"+sObjectNo+"' "+
			" order by CR.ClassifyDate desc";
	*/
	rs = Sqlca.getResultSet(sSql);
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >附录一、风险分类意见</font></td>"); 	
	sTemp.append("   </tr>");
	while(rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "";
		
		sOccurType = rs.getString("OccurType");
		if(sOccurType == null) sOccurType = "";
		
		sClassifyDate =(String)rs.getString("ClassifyDate");
		if(sClassifyDate == null) sClassifyDate = " ";

		sUserName =(String)rs.getString("UserName");
		if(sUserName == null) sUserName = " "; 

		sOrgName =(String)rs.getString("OrgName");
		if(sOrgName == null) sOrgName = " ";

		sBusinessTypeName =(String)rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";

		sCurrency =(String)rs.getString("Currency");
		if(sCurrency == null) sCurrency = " ";

		sBCSerialNo =(String)rs.getString("SerialNo");
		if(sBCSerialNo == null) sBCSerialNo = " ";

		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum"));

		sBalance =DataConvert.toMoney(rs.getDouble("Balance"));

		sResult1Name =(String)rs.getString("Result1Name");
		if(sResult1Name == null) sResult1Name = " ";
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=center class=td1 >分类时间：</td>");
	    sTemp.append("   <td colspan=5 align=center class=td1 >"+sClassifyDate+"&nbsp;</td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >客户名称：</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=center class=td1 >发生类型：</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sOccurType+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >客户经理：</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sUserName+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=center class=td1 >所属机构：</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sOrgName+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >业务品种：</td>");
		sTemp.append("   <td width=20% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=center class=td1 >币种:</td>");
		sTemp.append("   <td align=center class=td1 >"+sCurrency+"&nbsp;</td>");
		sTemp.append("   <td width=15% align=center class=td1 >合同编号：</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sBCSerialNo+"&nbsp;</td>");
		/*
		sTemp.append("   <td width=15% align=center class=td1 >借据编号：</td>");
		sTemp.append("   <td width=15% align=center class=td1 >"+sBCSerialNo+"&nbsp;</td>");
		*/
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >合同金额：</td>");
		sTemp.append("   <td colspan=2 align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
		/*
		sTemp.append("   <td align=center class=td1 >借据金额：</td>");
		sTemp.append("   <td colspan=2 align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
		*/
		sTemp.append("   <td align=center class=td1 >余额：</td>");
		sTemp.append("   <td colspan=2 align=right class=td1 >"+sBalance+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr align=left>");
		sTemp.append("   <td colspan=6 class=td1 >分类意见：<br>"+sResult1Name+"&nbsp;</td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
	    sTemp.append("   </tr>");
	}
	rs.getStatement().close();
	
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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

