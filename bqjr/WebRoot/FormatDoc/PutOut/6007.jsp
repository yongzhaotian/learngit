<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//��õ��鱨������
	
	String sSql = "select ContractSerialNo,DuebillSerialNo,CustomerID,CustomerName,"+
				  "getBusinessName(BusinessType) as BusinessTypeName,"+
				  "getItemName('NegotiateType',BusinessSubType),getItemName('NegotiateKind',BusinessSubType1),"+
				  "NegotiateNo,getitemname('Currency',BusinessCurrency) as BusinessCurrency,"+
				  "LoanType,getItemName('CreditLineFlag',CreditLineFlag),CreditAggreement,PutOutDate,"+
				  "Maturity,BusinessSum,getItemName('AdjustRateType',AdjustRateType),AdjustRateTerm,"+
				  "getItemName('ICCyc',ICCyc),FixCyc,BusinessRate,getItemName('AcceptIntType',AcceptIntType),getItemName('ResumeIntType',ResumeIntType),"+
				  "LoanAccountNo,AccountNo,SecondPayAccount,getItemName('RateFloatType',RateFloatType),"+
				  "getItemName('OverIntType',OverIntType),getItemName('RateAdjustCyc',RateAdjustCyc),getOrgName(OperateOrgID),OperateUserID,LoanType,GatheringName,RateFloat"+
				  " from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	String sContractSerialNo = "";
	String sDuebillSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessSubType = "";
	String sBusinessSubType1 = "";
	String sNegotiateNo = "";
	String sBusinessCurrency = "";
	String sLoanType = "";
	String sCreditLineFlag = "";
	String sCreditAggreement = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sBusinessSum = "";
	String sAdjustRateType = "";
	String sAdjustRateTerm = "";
	String sICCyc = "";
	String sFixCyc = "";
	String sBusinessRate = "";
	String sAcceptIntType = "";
	String sResumeIntType = "";
	String sLoanAccountNo = "";
	String sAccountNo = "";
	String sSecondPayAccount = "";
	String sRateFloatType = "";
	String sOverIntType = "";
	String sRateAdjustCyc = "";
	String sOperateOrgID = "";
	String sOperateUserID = "";
	String sGatheringName = "";
	String sRateFloat = "";

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6007.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if(sContractSerialNo == null) sContractSerialNo = "";
		
		sDuebillSerialNo = rs2.getString(2);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sCustomerID = rs2.getString(3);
		if(sCustomerID == null) sCustomerID = "";
		
		sCustomerName = rs2.getString(4);
		if(sCustomerName == null) sCustomerName = "";
		
		sBusinessTypeName = rs2.getString(5);
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		
		sBusinessSubType = rs2.getString(6);
		if(sBusinessSubType == null) sBusinessSubType = "";
		
		sBusinessSubType1 = rs2.getString(7);
		if(sBusinessSubType1 == null) sBusinessSubType1 = "";
		
		sNegotiateNo = rs2.getString(8);
		if(sNegotiateNo == null) sNegotiateNo = "";
		
		sBusinessCurrency = rs2.getString(9);
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		
		sLoanType = rs2.getString(10);
		if(sLoanType == null) sLoanType = "";
		
		sCreditLineFlag = rs2.getString(11);
		if(sCreditLineFlag == null) sCreditLineFlag = "";
		
		sCreditAggreement = rs2.getString(12);
		if(sCreditAggreement == null) sCreditAggreement = "";
		
		sPutOutDate = rs2.getString(13);
		if(sPutOutDate == null) sPutOutDate = "";
		
		sMaturity = rs2.getString(14);
		if(sMaturity == null) sMaturity = "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(15));
		
		sAdjustRateType = rs2.getString(16);
		if(sAdjustRateType == null) sAdjustRateType = "";
		
		sAdjustRateTerm = rs2.getString(17);
		if(sAdjustRateTerm == null) sAdjustRateTerm = "";
		
		sICCyc = rs2.getString(18);
		if(sICCyc == null) sICCyc = "";
		
		sFixCyc = rs2.getString(19);
		if (sFixCyc == null){ 
			sFixCyc = "";
		}else{
			sFixCyc = String.valueOf(Integer.parseInt(sFixCyc));
		}
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble(20));
		
		sAcceptIntType = rs2.getString(21);
		if(sAcceptIntType == null) sAcceptIntType = "";
		
		sResumeIntType = rs2.getString(22);
		if(sResumeIntType == null) sResumeIntType = "";
		
		sLoanAccountNo = rs2.getString(23);
		if(sLoanAccountNo == null) sLoanAccountNo = "";
		
		sAccountNo = rs2.getString(24);
		if(sAccountNo == null) sAccountNo = "";
		
		sSecondPayAccount = rs2.getString(25);
		if(sSecondPayAccount == null) sSecondPayAccount = "";
		
		sRateFloatType = rs2.getString(26);
		if(sRateFloatType == null) sRateFloatType = "";
		
		sOverIntType = rs2.getString(27);
		if(sOverIntType == null) sOverIntType = "";
		
		sRateAdjustCyc = rs2.getString(28);
		if(sRateAdjustCyc == null) sRateAdjustCyc = "";
		
		sOperateOrgID = rs2.getString(29);
		if(sOperateOrgID == null) sOperateOrgID = "";
		
		sOperateUserID = rs2.getString(30);
		if(sOperateUserID == null) sOperateUserID = "";
		
		sGatheringName = rs2.getString(31);
		if(sGatheringName == null) sGatheringName = "";
		
		sRateFloat = nf.format(rs2.getDouble(32));
			
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
		sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>�ſ�֪ͨ��<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>֧�У�������Ʋ��ţ� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>�������ˣ�������ҵ��:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ�������ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰������������	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > ��ͬ��ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >������ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");		
		sTemp.append("   <td align=left class=td1 >�ͻ���</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ͻ�����</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 nowrap>"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >Ѻ������</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSubType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >Ѻ������</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSubType1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��������</td>");
		sTemp.append("   <td align=left class=td1 >"+sLoanType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >������������</td>");
		sTemp.append("   <td align=left class=td1 >"+sGatheringName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���Ž��</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ϣ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >������</td>");
		sTemp.append("   <td align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ִ��������(��)</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���ʵ�����ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sAdjustRateType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���ʵ�������</td>");
		sTemp.append("   <td align=left class=td1 >"+sAdjustRateTerm+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ϣ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sICCyc+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�̶�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sFixCyc+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sRateFloatType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���ʵ�������</td>");
		sTemp.append("   <td align=left class=td1 >"+sRateAdjustCyc+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�Ƹ�Ϣ��־</td>");
		sTemp.append("   <td align=left class=td1 >"+sResumeIntType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���ڼ�Ϣ��ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sOverIntType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�����ʺ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���������ʺ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sLoanAccountNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ڶ������ʺ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sSecondPayAccount+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��ȴ����־</td>");
		sTemp.append("   <td align=left class=td1 >"+sCreditLineFlag+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���Э����</td>");
		sTemp.append("   <td align=left class=td1 >"+sCreditAggreement+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��Ϣ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sAcceptIntType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�����ʺ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >Ѻ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sNegotiateNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > �ſ���������ǩ�֣� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>�ſ�ר���£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> ���ڣ�"+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�</td>");
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
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

