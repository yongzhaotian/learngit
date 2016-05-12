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
	
	String sSql = "select ContractSerialNo,getBusinessName(BusinessType) as BusinessTypeName,CustomerName,ContractSum,PutOutDate,Maturity,"+
				  " OpenBankName,OpenBankAdd,OpenBankZip,getItemName('CreditType1',PZType),Address3,getItemName('Type1',Type1),AboutBankID,AboutBankName,"+
				  " getItemName('Type1',Type2),AboutBankID2,AboutBankName2,getItemName('Type1',Type3),AboutBankID3,ThirdPartyAccounts,Name1,"+
				  " Address1,ThirdPartyID1,Name2,Address2,Zip2,BusinessSum,BailAccount,Term1,Term2,getItemName('CreditPayMethod',MFeePayMethod),TermDay,"+
				  " getItemName('IsAgree',Type4),getItemName('IsAgree',Type5),Type8,Type9,SecuritiesType,getItemName('SendType',Type6),getItemName('CostPerson',Type7),getOrgName(OperateOrgID)"+
				  " from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	
	String sContractSerialNo = "";
	String sBusinessTypeName = "";
	String sCustomerName = "";
	String sContractSum = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sOpenBankName = "";
	String sOpenBankAdd = "";
	String sOpenBankZip = "";
	String sPZType = "";
	String sAddress3 = "";
	String sType1 = "";
	String sAboutBankID = "";
	String sAboutBankName = "";
	String sType2 = "";
	String sAboutBankID2 = "";
	String sAboutBankName2 = "";
	String sType3 = "";
	String sAboutBankID3 = "";
	String sThirdPartyAccounts = "";
	String sName1 = "";
	String sAddress1 = "";
	String sThirdPartyID1 = "";
	String sName2 = "";
	String sAddress2 = "";
	String sZip2 = "";
	String sBusinessSum = "";
	String sBailAccount = "";
	String sTerm1 = "";
	String sTerm2 = "";
	String sMFeePayMethod = "";
	String sTermDay = "";
	String sType4 = "";
	String sType5 = "";
	String sType8 = "";
	String sType9 = "";
	String sSecuritiesType = "";
	String sType6 = "";
	String sType7 = "";
	String sOperateOrgID = "";
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6801.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo = "";
		
		sBusinessTypeName = rs2.getString(2);
		if( sBusinessTypeName==null) sBusinessTypeName = "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName = "";
		
		sContractSum = DataConvert.toMoney(rs2.getDouble(4));
		
		sPutOutDate = rs2.getString(5);
		if(sPutOutDate ==null) sPutOutDate = "";
		
		sMaturity = rs2.getString(6);
		if( sMaturity==null) sMaturity = "";
		
		sOpenBankName = rs2.getString(7);
		if( sOpenBankName ==null) sOpenBankName = "";
		
		sOpenBankAdd = rs2.getString(8);
		if( sOpenBankAdd==null) sOpenBankAdd = "";
		
		sOpenBankZip = rs2.getString(9);
		if( sOpenBankZip==null) sOpenBankZip = "";
		
		sPZType = rs2.getString(10);
		if( sPZType ==null) sPZType = "";
		
		sAddress3 = rs2.getString(11);
		if( sAddress3 ==null) sAddress3 = "";
		
		sType1 = rs2.getString(12);
		if( sType1==null) sType1= "";
		
		sAboutBankID = rs2.getString(13);
		if( sAboutBankID ==null) sAboutBankID = "";
		
		sAboutBankName = rs2.getString(14);
		if( sAboutBankName ==null) sAboutBankName = "";
		
		sType2 = rs2.getString(15);
		if( sType2 ==null) sType2 = "";
		
		sAboutBankID2 = rs2.getString(16);
		if( sAboutBankID2 ==null) sAboutBankID2 = "";
		
		sAboutBankName2 = rs2.getString(17);
		if( sAboutBankName2 ==null) sAboutBankName2 = "";
		
		sType3 = rs2.getString(18);
		if( sType3 ==null) sType3 = "";
		
		sAboutBankID3 = rs2.getString(19);
		if( sAboutBankID3 ==null) sAboutBankID3 = "";
		
		sThirdPartyAccounts = rs2.getString(20);
		if( sThirdPartyAccounts ==null) sThirdPartyAccounts = "";
		
		sName1 = rs2.getString(21);
		if( sName1 ==null) sName1 = "";
		
		sAddress1 = rs2.getString(22);
		if( sAddress1 ==null) sAddress1 = "";
		
		sThirdPartyID1 = rs2.getString(23);
		if( sThirdPartyID1 ==null) sThirdPartyID1 = "";
		
		sName2 = rs2.getString(24);
		if( sName2 ==null) sName2 = "";
		
		sAddress2 = rs2.getString(25);
		if( sAddress2 ==null) sAddress2 = "";
		
		sZip2 = rs2.getString(26);
		if( sZip2 ==null) sZip2 = "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(27));
		
		sBailAccount = rs2.getString(28);
		if( sBailAccount ==null) sBailAccount = "";
		
		sTerm1 = rs2.getString(29);
		if( sTerm1 ==null) sTerm1 = "";
		
		sTerm2 = rs2.getString(30);
		if( sTerm2 ==null) sTerm2 = "";
		
		sMFeePayMethod = rs2.getString(31);
		if( sMFeePayMethod ==null) sMFeePayMethod = "";
		
		sTermDay = rs2.getString(32);
		if( sTermDay ==null) sTermDay = "";
		
		sType4 = rs2.getString(33);
		if( sType4 ==null) sType4 = "";
		
		sType5 = rs2.getString(34);
		if( sType5 ==null) sType5 = "";
		
		sType8 = rs2.getString(35);
		if( sType8 ==null) sType8 = "";
		
		sType9 = rs2.getString(36);
		if( sType9 ==null) sType9 = "";
		
		sSecuritiesType = rs2.getString(37);
		if( sSecuritiesType ==null) sSecuritiesType = "";
		
		sType6 = rs2.getString(38);
		if( sType6==null) sType6 = "";
		
		sType7 = rs2.getString(39);
		if( sType7==null) sType7="";
		
		sOperateOrgID = rs2.getString(40);	
		if( sOperateOrgID==null) sOperateOrgID="";
		
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
		sTemp.append("   <td width=20% align=left class=td1 > 合同流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >出帐流水号</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >客户名称</td>");
		sTemp.append("   <td align=left class=td1 nowrap>"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >合同金额（元）</td>");
		sTemp.append("   <td align=left class=td1 >"+sContractSum+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >业务日期</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >信用证有效期</td>");
		sTemp.append("   <td align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >开证行行名</td>");
		sTemp.append("   <td align=left class=td1 >"+sOpenBankName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >开证行地址</td>");
		sTemp.append("   <td align=left class=td1 >"+sOpenBankAdd+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >开证行邮编</td>");
		sTemp.append("   <td align=left class=td1 >"+sOpenBankZip+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >信用证性质</td>");
		sTemp.append("   <td align=left class=td1 >"+sPZType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >信用证有效地</td>");
		sTemp.append("   <td align=left class=td1 >"+sAddress3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >通知行类别</td>");
		sTemp.append("   <td align=left class=td1 >"+sType1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >通知行行号</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >通知行行名</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >受益行类别</td>");
		sTemp.append("   <td align=left class=td1 >"+sType2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >受益行行号</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankID2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >受益行行名</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankName2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >议付行类别</td>");
		sTemp.append("   <td align=left class=td1 >"+sType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >议付行行号</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankID3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >开证申请人账号</td>");
		sTemp.append("   <td align=left class=td1 >"+sThirdPartyAccounts+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >开证申请人名称</td>");
		sTemp.append("   <td align=left class=td1 >"+sName1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >开证申请人地址</td>");
		sTemp.append("   <td align=left class=td1 >"+sAddress1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >受益人账号</td>");
		sTemp.append("   <td align=left class=td1 >"+sThirdPartyID1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >受益人名称</td>");
		sTemp.append("   <td align=left class=td1 >"+sName2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >受益人地址</td>");
		sTemp.append("   <td align=left class=td1 >"+sAddress2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >受益人邮编</td>");
		sTemp.append("   <td align=left class=td1 >"+sZip2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >交易金额</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >保证金账号</td>");
		sTemp.append("   <td align=left class=td1 >"+sBailAccount+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >最晚装运期</td>");
		sTemp.append("   <td align=left class=td1 >"+sTerm1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >交单期</td>");
		sTemp.append("   <td align=left class=td1 >"+sTerm2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >付款方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sMFeePayMethod+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >付款期限(天)</td>");
		sTemp.append("   <td align=left class=td1 >"+sTermDay+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >分批装运</td>");
		sTemp.append("   <td align=left class=td1 >"+sType4+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >转运</td>");
		sTemp.append("   <td align=left class=td1 >"+sType5+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >装运地</td>");
		sTemp.append("   <td align=left class=td1 >"+sType8+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >货物运输目的地</td>");
		sTemp.append("   <td align=left class=td1 >"+sType9+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >运输方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sSecuritiesType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >发送方式</td>");
		sTemp.append("   <td align=left class=td1 >"+sType6+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >费用承担人</td>");
		sTemp.append("   <td align=left class=td1 >"+sType7+"&nbsp;</td>");
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

