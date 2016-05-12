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

	String sBCSerialNo = "";		//贷款合同编号
	String sBusinessTypeName = "";	//业务品种
	String sCurrency = "";			//币种
	String sBusinessSum = "";		//贷款金额
	String sBalance = "";			//贷款余额
	String sGuarantyName = "";		//担保物名称
	String sGuarantyType = "";		//担保物类型
	String sGuarantyAmount= "";		//担保物数量
	String sEvalNetValue = "";		//评估价值
	String sEvalDate = "";			//评估时间
	String sSumEval = "";			//担保比率
	String sOwnerName = "";			//权利人名称
	String sGuarantyRightID = "";	//权证号
	String sInsureCertNo = "";		//抵押物保险单编号

	sSql =  " select BC.SerialNo,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
			" getItemName('Currency',BC.BusinessCurrency) as Currency, "+
			" BC.BusinessSum,BC.Balance,GI.GUARANTYNAME,getItemName('GuarantyList',GI.GuarantyType) as GuarantyType, "+
			" GI.GuarantyAmount,GI.EvalNetValue,GI.EvalDate,BC.BusinessSum/GI.EvalNetValue as SumEval,GI.OWNERNAME, "+
			" GI.GUARANTYRIGHTID,GI.InsureCertNo "+
			" from GUARANTY_INFO GI,GUARANTY_RELATIVE GR,GUARANTY_CONTRACT GC,BUSINESS_CONTRACT BC "+
			" where GR.ObjectType = 'BusinessContract' "+
			" and GR.ObjectNo = BC.SerialNo "+
			" and GR.ContractNo = GC.SerialNo "+
			" and GI.GuarantyID = GR.GuarantyID "+
			" and GC.ContractStatus = '020' "+
			" and GC.CustomerID = '"+sObjectNo+"' ";
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<% 
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >附录三、抵质押物信息</font></td>"); 	
	sTemp.append("   </tr>");	
	
   	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sBCSerialNo =(String)rs.getString(1);
		if(sBCSerialNo == null) sBCSerialNo = " ";

		sBusinessTypeName =(String)rs.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName = " "; 

		sCurrency =(String)rs.getString(3);
		if(sCurrency == null) sCurrency = " ";

		sBusinessSum =DataConvert.toMoney(rs.getDouble(4));

		sBalance =DataConvert.toMoney(rs.getDouble(5));

		sGuarantyName =(String)rs.getString(6);
		if(sGuarantyName == null) sGuarantyName = " ";

		sGuarantyType =(String)rs.getString(7);
		if(sGuarantyType == null) sGuarantyType = " ";

		sGuarantyAmount =DataConvert.toMoney(rs.getDouble(8));

		sEvalNetValue =DataConvert.toMoney(rs.getDouble(9));
		
		sEvalDate =(String)rs.getString(10);
		if(sEvalDate == null) sEvalDate = " ";

		sSumEval =DataConvert.toMoney(rs.getDouble(11));

		sOwnerName =(String)rs.getString(12);
		if(sOwnerName == null) sOwnerName = " ";

		sGuarantyRightID =(String)rs.getString(13);
		if(sGuarantyRightID == null) sGuarantyRightID = " ";

		sInsureCertNo =(String)rs.getString(14);
		if(sInsureCertNo == null) sInsureCertNo = " ";
		
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >合同编号 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sBCSerialNo+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >业务品种</td>");
	    sTemp.append("   <td align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >币种 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sCurrency+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >合同金额</td>");
	    sTemp.append("   <td align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >合同余额</td>");
	    sTemp.append("   <td align=right class=td1 >"+sBalance+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >担保物名称</td>");
	    sTemp.append("   <td align=center class=td1 >"+sGuarantyName+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >担保物类型 </td>");
	    sTemp.append("   <td align=center class=td1 >"+sGuarantyType+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >担保物数量</td>");
	    sTemp.append("   <td align=right class=td1 >"+sGuarantyAmount+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >评估价值</td>");
		sTemp.append("   <td align=right class=td1 >"+sEvalNetValue+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >评估时间</td>");
		sTemp.append("   <td align=center class=td1 >"+sEvalDate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >担保比率</td>");
		sTemp.append("   <td align=right class=td1 >"+sSumEval+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >权利人名称</td>");
		sTemp.append("   <td align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >权证号</td>");
		sTemp.append("   <td align=center class=td1 >"+sGuarantyRightID+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >抵押物保险单编号</td>");
		sTemp.append("   <td align=center class=td1 >"+sInsureCertNo+"&nbsp;</td>");
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

