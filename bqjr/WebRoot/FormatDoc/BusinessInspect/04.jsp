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
	

	String sEvaluateDate = "";
	String sAccountMonth = "";
	String sEvaluateScore = "";
	String sModelName = "";
	String sEvaluateResult = "";
	String sOrgName = "";
	String sCognScore = "";
	String sUserName = "";
	String sCognResult = "";

	sSql = " select ObjectType,ObjectNo,SerialNo,CognDate,C.ModelName,R.ModelNo,EvaluateDate,AccountMonth,EvaluateScore,EvaluateResult,"+
	       " OrgID,getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName,"+
	       " CognScore,CognResult,CognOrgID,getOrgName(CognOrgID) as CognOrgName,CognUserID,getUserName(CognUserID) as CognUserName "+
	       " from EVALUATE_RECORD R,EVALUATE_CATALOG C" + 
	       " where ObjectType='"+sObjectType + "' and ObjectNo='"+ sObjectNo + "' and R.ModelNo=C.ModelNo";
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/04.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >附录二、业务信息</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > 1、客户信用评估信息 </font></td>");
   	sTemp.append("   </tr>");
   	rs = Sqlca.getResultSet(sSql);
   	while(rs.next())
	{
		sEvaluateDate =(String)rs.getString("EvaluateDate");
		if(sEvaluateDate == null) sEvaluateDate = " ";

		sAccountMonth =(String)rs.getString("AccountMonth");
		if(sAccountMonth == null) sAccountMonth = " "; 

		sEvaluateScore =(String)rs.getString("EvaluateScore");
		if(sEvaluateScore == null) sEvaluateScore = " ";

		sModelName =(String)rs.getString("ModelName");
		if(sModelName == null) sModelName = " ";

		sEvaluateResult =(String)rs.getString("EvaluateResult");
		if(sEvaluateResult == null) sEvaluateResult = " ";

		sOrgName =(String)rs.getString("OrgName");
		if(sOrgName == null) sOrgName = " ";

		sCognScore =(String)rs.getString("CognScore");
		if(sCognScore == null) sCognScore = " ";

		sUserName =(String)rs.getString("UserName");
		if(sUserName == null) sUserName = " ";

		sCognResult =(String)rs.getString("CognResult");
		if(sCognResult == null) sCognResult = " ";
		
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >评估日期 </td>");
	    sTemp.append("   <td colspan=3 align=left class=td1 >"+sEvaluateDate+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >会计月份</td>");
	    sTemp.append("   <td width=26% align=left class=td1 >"+sAccountMonth+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >系统评估得分</td>");
	    sTemp.append("   <td width=20% align=left class=td1 >"+sEvaluateScore+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >评估模型 </td>");
	    sTemp.append("   <td align=left class=td1 >"+sModelName+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >系统评估结果</td>");
	    sTemp.append("   <td align=left class=td1 >"+sEvaluateResult+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >评估单位</td>");
	    sTemp.append("   <td align=left class=td1 >"+sOrgName+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >直接认定得分</td>");
	    sTemp.append("   <td align=celeftnter class=td1 >"+sCognScore+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >评估客户经理  </td>");
	    sTemp.append("   <td align=left class=td1 >"+sUserName+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >直接认定结果</td>");
	    sTemp.append("   <td align=left class=td1 >"+sCognResult+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
	   	sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
	   	sTemp.append("   </tr>");
	}
	rs.getStatement().close();
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > 2、业务台账</font></td>");
   	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > 2.1、表内未终结业务</font></td>");
   	sTemp.append("   </tr>");
	String sCustomerName = "";
	String sOperateOrgName = "";
	String sBusinessTypeName = "";
	String sOccurTypeName = "";
	String sBCSerialNo = "";
	String sCurrency = "";
	String sBusinessSum = "";
	String sBalance = "";
	String sBailSum = "";
	String sOverdueBalance = "";
	String sFineBalance = "";
	String sBusinessRate = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sVouchTypeName = "";
	String sRiskRate = "";
	String sClassifyResult = "";

	sSql =  " select SerialNo,CustomerName, "+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName, "+					
			" OccurType,getItemName('OccurType',OccurType) as OccurTypeName, "+			
			" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency, "+
			" BusinessSum,Balance,BailSum,OverdueBalance,BusinessRate, "+
			" (InterestBalance1+InterestBalance2+FineBalance1+FineBalance2) as FineBalance, "+
			" PutOutDate,Maturity, "+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,RiskRate, "+
			" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult, "+
		    " getOrgName(ManageOrgID) as OrgName, "+
		    " getUserName(ManageUserID) as UserName, "+
			" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName "+
			" from BUSINESS_CONTRACT "+
			" where CustomerID = '"+sObjectNo+"' "+
			" and Balance >= 0 "+
			" and OffSheetFlag in ('EntOn','IndOn') "+
			" and (FinishDate=' ' or FinishDate is null) ";
	
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sCustomerName =(String)rs.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = " ";

		sOperateOrgName =(String)rs.getString("OperateOrgName");
		if(sOperateOrgName == null) sOperateOrgName = " "; 

		sBusinessTypeName =(String)rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";

		sOccurTypeName =(String)rs.getString("OccurTypeName");
		if(sOccurTypeName == null) sOccurTypeName = " ";

		sBCSerialNo =(String)rs.getString("SerialNo");
		if(sBCSerialNo == null) sBCSerialNo = " ";

		sCurrency =(String)rs.getString("Currency");
		if(sCurrency == null) sCurrency = " ";

		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum"));
		if(sBusinessSum == null) sBusinessSum = "0.0";

		sBalance = DataConvert.toMoney(rs.getDouble("Balance"));
		if(sBalance == null) sBalance = "0.0";

		sBailSum = DataConvert.toMoney(rs.getDouble("BailSum"));
		if(sBailSum == null) sBailSum = "0.0";

		sOverdueBalance = DataConvert.toMoney(rs.getDouble("OverdueBalance"));
		if(sOverdueBalance == null) sOverdueBalance = "0.0";

		sFineBalance = DataConvert.toMoney(rs.getDouble("FineBalance"));
		if(sFineBalance == null) sFineBalance = "0.0";

		sBusinessRate =(String)rs.getString("BusinessRate");
		if(sBusinessRate == null) sBusinessRate = "0.0";

		sPutOutDate =(String)rs.getString("PutOutDate");
		if(sPutOutDate == null) sPutOutDate = " ";

		sMaturity =(String)rs.getString("Maturity");
		if(sMaturity == null) sMaturity = " ";

		sVouchTypeName =(String)rs.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName = " ";

		sRiskRate =(String)rs.getString("RiskRate");
		if(sRiskRate == null) sRiskRate = " ";

		sUserName =(String)rs.getString("UserName");
		if(sUserName == null) sUserName = " ";

		sClassifyResult =(String)rs.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >客户名称 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >经办机构</td>");
	    sTemp.append("   <td align=center class=td1 >"+sOperateOrgName+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >业务品种 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >发生类型</td>");
	    sTemp.append("   <td align=center class=td1 >"+sOccurTypeName+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >合同编号 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sBCSerialNo+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >币种</td>");
	    sTemp.append("   <td align=center class=td1 >"+sCurrency+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >合同金额 </td>");
	    sTemp.append("   <td align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >余额</td>");
	    sTemp.append("   <td align=right class=td1 >"+sBalance+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >保证金</td>");
		sTemp.append("   <td align=right class=td1 >"+sBailSum+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >逾期/垫款金额</td>");
		sTemp.append("   <td align=right class=td1 >"+sOverdueBalance+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >欠息金额</td>");
		sTemp.append("   <td align=right class=td1 >"+sFineBalance+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >利率(‰)</td>");
		sTemp.append("   <td align=right class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >起始日期</td>");
		sTemp.append("   <td align=center class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >到期日期</td>");
		sTemp.append("   <td align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >担保方式</td>");
		sTemp.append("   <td align=center class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >风险度</td>");
		sTemp.append("   <td align=center class=td1 >"+sRiskRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >客户经理</td>");
		sTemp.append("   <td align=center class=td1 >"+sUserName+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >风险分类</td>");
		sTemp.append("   <td align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
	   	sTemp.append("   </tr>");
	}
	rs.getStatement().close();
		
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > 2.2、表外未终结业务</font></td>");
   	sTemp.append("   </tr>");
   	
	sSql =  " select SerialNo,CustomerName, "+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName, "+					
			" OccurType,getItemName('OccurType',OccurType) as OccurTypeName, "+			
			" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency, "+
			" BusinessSum,Balance,BailSum,OverdueBalance,BusinessRate, "+
			" (InterestBalance1+InterestBalance2+FineBalance1+FineBalance2) as FineBalance, "+
			" PutOutDate,Maturity, "+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,RiskRate, "+
			" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult, "+
		    " getOrgName(ManageOrgID) as OrgName, "+
		    " getUserName(ManageUserID) as UserName, "+
			" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName "+
			" from BUSINESS_CONTRACT "+
			" where CustomerID = '"+sObjectNo+"' "+
			" and Balance >= 0 "+
			" and OffSheetFlag in ('EntOff','IndOff') "+
			" and (FinishDate=' ' or FinishDate is null) ";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sCustomerName =(String)rs.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = " ";

		sOperateOrgName =(String)rs.getString("OperateOrgName");
		if(sOperateOrgName == null) sOperateOrgName = " "; 

		sBusinessTypeName =(String)rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";

		sOccurTypeName =(String)rs.getString("OccurTypeName");
		if(sOccurTypeName == null) sOccurTypeName = " ";

		sBCSerialNo =(String)rs.getString("SerialNo");
		if(sBCSerialNo == null) sBCSerialNo = " ";

		sCurrency =(String)rs.getString("Currency");
		if(sCurrency == null) sCurrency = " ";

		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum"));
		if(sBusinessSum == null) sBusinessSum = "0.0";

		sBalance = DataConvert.toMoney(rs.getDouble("Balance"));
		if(sBalance == null) sBalance = "0.0";

		sBailSum = DataConvert.toMoney(rs.getDouble("BailSum"));
		if(sBailSum == null) sBailSum = "0.0";

		sOverdueBalance = DataConvert.toMoney(rs.getDouble("OverdueBalance"));
		if(sOverdueBalance == null) sOverdueBalance = "0.0";

		sFineBalance = DataConvert.toMoney(rs.getDouble("FineBalance"));
		if(sFineBalance == null) sFineBalance = "0.0";

		sBusinessRate =DataConvert.toMoney(rs.getDouble("BusinessRate"));

		sPutOutDate =(String)rs.getString("PutOutDate");
		if(sPutOutDate == null) sPutOutDate = " ";

		sMaturity =(String)rs.getString("Maturity");
		if(sMaturity == null) sMaturity = " ";

		sVouchTypeName =(String)rs.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName = " ";

		sRiskRate =(String)rs.getString("RiskRate");
		if(sRiskRate == null) sRiskRate = " ";

		sUserName =(String)rs.getString("UserName");
		if(sUserName == null) sUserName = " ";

		sClassifyResult =(String)rs.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >客户名称 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >经办机构</td>");
	    sTemp.append("   <td align=center class=td1 >"+sOperateOrgName+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >业务品种 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >发生类型</td>");
	    sTemp.append("   <td align=center class=td1 >"+sOccurTypeName+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >合同编号 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sBCSerialNo+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >币种</td>");
	    sTemp.append("   <td align=center class=td1 >"+sCurrency+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >合同金额 </td>");
	    sTemp.append("   <td align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >余额</td>");
	    sTemp.append("   <td align=right class=td1 >"+sBalance+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >保证金</td>");
		sTemp.append("   <td align=right class=td1 >"+sBailSum+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >逾期/垫款金额</td>");
		sTemp.append("   <td align=right class=td1 >"+sOverdueBalance+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >欠息金额</td>");
		sTemp.append("   <td align=right class=td1 >"+sFineBalance+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >利率(‰)</td>");
		sTemp.append("   <td align=right class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >起始日期</td>");
		sTemp.append("   <td align=center class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >到期日期</td>");
		sTemp.append("   <td align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >担保方式</td>");
		sTemp.append("   <td align=center class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >风险度</td>");
		sTemp.append("   <td align=center class=td1 >"+sRiskRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >客户经理</td>");
		sTemp.append("   <td align=center class=td1 >"+sUserName+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >风险分类</td>");
		sTemp.append("   <td align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
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

