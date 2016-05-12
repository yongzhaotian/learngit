<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   smiao 2011.06.02
		Tester:
		Content: 报告的第0页
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

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//获得调查报告数据
	//String sSql2 = "select SerialNo,CustomerName,getOrgName(OperateOrgID) from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";

	
	
	
	String sSql10 =  "select PutoutSerialNo,getItemName('Currency',Currency),PaymentSum,CapitalUse from PAYMENT_INFO  where SerialNo = '"+sObjectNo+"'";
	
	String sContractSerialNo = "";
	String sBCSerialNo = "";
	String sCustomerName = "";
	String sOperateOrgID = "";
	String sPutoutSerialNo = "";

	String sCurrency = "";
	double PaymentSum = 0;
	String sCapitalUse = "";
	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6000.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	

	ASResultSet rs1 = Sqlca.getResultSet(sSql10);

	if(rs1.next()){
		sPutoutSerialNo = rs1.getString(1);
		if(sPutoutSerialNo == null) sPutoutSerialNo = "";
		
		sCurrency = rs1.getString(2);
		if(sCurrency == null) sCurrency = "";
		
		PaymentSum = rs1.getDouble(3);
		
		sCapitalUse = rs1.getString(4);
		if(sCapitalUse == null) sCapitalUse = "";
		
	}
	
	rs1.getStatement().close();
	
	String sSql20 = "select ContractSerialNo,getItemName('Currency',BusinessCurrency) as BusinessCurrency ,BusinessSum,Purpose from BUSINESS_PUTOUT where SerialNo = '"+sPutoutSerialNo+"'";
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql20);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if(sContractSerialNo == null) sContractSerialNo = "";
	}
	rs2.getStatement().close();
	
	String sSql30 = "select SerialNo,CustomerName,getOrgName(OperateOrgID) from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"'";
	ASResultSet rs3 = Sqlca.getResultSet(sSql30);
	if(rs3.next()){
		sBCSerialNo = rs3.getString(1);
		if(sBCSerialNo == null) sBCSerialNo = "";
		
		sCustomerName = rs3.getString(2);
		if(sCustomerName == null) sCustomerName = "";
		
		sOperateOrgID = rs3.getString(3);
		if(sOperateOrgID == null) sOperateOrgID = "";
	}
	rs3.getStatement().close();
	
	
		
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");		
		sTemp.append("   <tr>");
		//colspan需根据实际情况调整，否则导出时会比较不雅
		sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>受托支付申请审批书<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > 申请人（委托人、甲方）：<u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u> </td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > 贷款人（受托方、乙方）：<u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u> </td>");
		sTemp.append("   </tr>");		
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > &nbsp;&nbsp;&nbsp;&nbsp;基于甲方与乙方签订的编号为<u>&nbsp;&nbsp;"+sBCSerialNo+"&nbsp;&nbsp;</u>《借款合同》甲方申请支付（币种）<u>&nbsp;&nbsp;"+sCurrency+"&nbsp;&nbsp;</u>（大写金额）<u>&nbsp;&nbsp;"+StringFunction.numberToChinese(PaymentSum)+"&nbsp;&nbsp;</u>用于<u>&nbsp;&nbsp;"+sCapitalUse+"&nbsp;&nbsp;</u>。<br>&nbsp;&nbsp;&nbsp;&nbsp;甲方不可撤销的委托乙方将该笔信贷资金根据下述支付明细予以对外支付；并将申请该笔用款所需的所有材料附于本申请书之后供乙方审核，甲方承诺本笔信贷资金除用于上述委托乙方对外支付用途外，不以其他任何形式进行支取或自行转账支付，否则将构成甲方对借款合同的违约，乙方有权根据借款合同的约定要求甲方承担相应的违约责任。   </td>");
		sTemp.append("   </tr>");		

		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >申请人（委托人）（加盖预留印鉴） </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>放款专用章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> "+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		
		
		
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >客户经理意见</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >           &nbsp;客户经理：         年           月          日</td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >部门负责人意见</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >           &nbsp;负   责  人：           年           月          日</td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >主管行长意见</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >           &nbsp;主管行长：           年          月          日</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >（注：本申请审批书一式二联，第一联营业网点留存，第二联营销部门留存。）</td>");
		sTemp.append("   </tr>");
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
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");


	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

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

