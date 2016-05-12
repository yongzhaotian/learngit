<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
	
	String sSql = " select ContractSerialNo,CustomerID,CustomerName,BailAccount,"+
				  " getItemName('GuaranteeType',VouchType) as VouchType,getItemName('KeapOrder',CorpusPayMethod),"+
				  " SecondPayAccount,BusinessSum,PutOutDate,Maturity,getBusinessName(BusinessType) as BusinessTypeName,getOrgName(OperateOrgID),SerialNo,DuebillSerialNo "+
				  " from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	String sContractSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBailAccount = "";
	String sVouchType = "";
	String sCorpusPayMethod = "";
	String sSecondPayAccount = "";
	String sBusinessSum = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sBusinessTypeName = "";
	String sOperateOrgID = "";
	String sSerialNo1 = "";
	String sGatheringName = "";
	String sAccountNo = "";
	String sAboutBankName = "";
	String sBillSum = "";
	String sUserName = "";
	String sOrgName = "";
	String sDuebillSerialNo = "";
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='8315.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo= "";
		
		sCustomerID = rs2.getString(2);
		if( sCustomerID==null) sCustomerID= "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName= "";
		
		sBailAccount = rs2.getString(4);
		if(sBailAccount ==null) sBailAccount= "";
		
		sVouchType = rs2.getString(5);
		if(sVouchType ==null) sVouchType= "";
		
		sCorpusPayMethod = rs2.getString(6);
		if(sCorpusPayMethod ==null) sCorpusPayMethod= "";
		
		sSecondPayAccount = rs2.getString(7);
		if(sSecondPayAccount ==null) sSecondPayAccount= "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(8));
		
		sPutOutDate = rs2.getString(9);
		if(sPutOutDate ==null) sPutOutDate= "";
		
		sMaturity = rs2.getString(10);
		if( sMaturity==null) sMaturity= "";
		
		sBusinessTypeName = rs2.getString(11);
		
		sOperateOrgID = rs2.getString(12);
		
		sSerialNo1 = rs2.getString(13);
		
		sDuebillSerialNo = rs2.getString(14);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		//colspan需根据实际情况调整，否则导出时会比较不雅
		sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>放款通知书<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>支行（部）会计部门： </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>（申请人）的授信业务:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>已经按我行业务审批程序报经有权审批人审批同意，并通过放款中心审核，请你部按照本通知书要求，办理记账手续：	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=24% align=left class=td1 > 承兑协议流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >出帐流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >客户号</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >客户名称</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 nowrap>"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >保证金帐号</td>");
		sTemp.append("   <td align=left class=td1 >"+sBailAccount+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >保证金到期扣款顺序</td>");
		sTemp.append("   <td align=left class=td1 >"+sCorpusPayMethod+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >保证方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sVouchType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >汇票总金额(元)</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >签发日期</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >到期日期</td>");
		sTemp.append("   <td align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > 放款中心主管签字： </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>放款专用章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> 日期："+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >（此通知书共三联，交客户经理、会计和文档管理员各一份）</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
		sTemp.append("   </tr>");
	  sSql = "select GatheringName,AccountNo,AboutBankName,BillSum,"+
	   		   "getUserName(inputuserid),getOrgName(inputorgid) from bill_info "+
			     "where objectno in (select CONTRACTSERIALNO from BUSINESS_PUTOUT where serialno = '"+sSerialNo1+"')";
		ASResultSet rs3 = Sqlca.getResultSet(sSql);
		while(rs3.next())
		{
						
			sBillSum = DataConvert.toMoney(rs3.getDouble(5));
			
			sGatheringName = rs3.getString(2);
			if(sGatheringName == null) sGatheringName = "";
			
			sAccountNo = rs3.getString(3);
			if(sAccountNo == null) sAccountNo = "";
			
			sAboutBankName = rs3.getString(4);
			if(sAboutBankName == null) sAboutBankName = "";
			
			sUserName = rs3.getString(6);
			if(sUserName == null) sUserName = "";
			
			sOrgName = rs3.getString(7);
			if(sOrgName == null) sOrgName = "";
				
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left class=td1 >收款人户名</td>");
			sTemp.append("   <td align=left class=td1 nowrap>"+sGatheringName+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >收款人帐号</td>");
			sTemp.append("   <td align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left class=td1 >收款行行名</td>");
			sTemp.append("   <td align=left class=td1 >"+sAboutBankName+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >金额(元)</td>");
			sTemp.append("   <td align=left class=td1 >"+sBillSum+"&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left class=td1 >登记人</td>");
			sTemp.append("   <td align=left class=td1 >"+sUserName+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >登记机构</td>");
			sTemp.append("   <td align=left class=td1 >"+sOrgName+"&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=4 align=center class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
			sTemp.append("   </tr>");
    }
    rs3.getStatement().close();	
		sTemp.append("</table>");	
	    	
	}
	
	rs2.getStatement().close();	
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

