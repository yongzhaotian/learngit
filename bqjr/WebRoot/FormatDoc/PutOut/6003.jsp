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
	String sSql = "select ContractSerialNo,DuebillSerialNo,CustomerID,CustomerName,getBusinessName(BusinessType),BusinessSum,"+ 
				  "getitemname('Currency',BusinessCurrency) as BusinessCurrency,LoanType,AccountNo,ConsignAccountNo,PutOutDate,Maturity,BusinessRate, "+ 
				  "BackRate,PdgSum,PdgAccountNo,getItemName('AcceptIntType',AcceptIntType),getItemName('ResumeIntType',ResumeIntType),getItemName('ICCyc',ICCyc),FixCyc, "+ 
				  "getItemName('ChargeType',PdgPayMethod),getItemName('PrecatoryType',BusinessSubType),RiskRate,getOrgName(OperateOrgID),gatheringname "+ 
				  "from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	
	String sContractSerialNo = "";
	String sDuebillSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessSum = "";
	String sBusinessCurrency = "";
	String sLoanType = "";
	String sAccountNo = "";
	String sConsignAccountNo = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sBusinessRate = "";
	String sBackRate = "";
	String sPdgSum = "";
	String sPdgAccountNo = "";
	String sAcceptIntType = "";
	String sResumeIntType = "";
	String sICCyc = "";
	String sFixCyc = "";
	String sPdgPayMethod = "";
	String sBusinessSubType = "";
	String sRiskRate = "";
	String sOperateOrgID = "";
	String sGatheringName = "";
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6003.jsp' name='reportInfo'>");	
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
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(6));
		
		sBusinessCurrency = rs2.getString(7);
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		
		sLoanType = rs2.getString(8);
		if(sLoanType == null) sLoanType = "";
		
		sAccountNo = rs2.getString(9);
		if(sAccountNo == null) sAccountNo = "";
		
		sConsignAccountNo = rs2.getString(10);
		if(sConsignAccountNo == null) sConsignAccountNo = "";
		
		sPutOutDate = rs2.getString(11);
		if(sPutOutDate == null) sPutOutDate = "";
		
		sMaturity = rs2.getString(12);
		if(sMaturity == null) sMaturity = "";
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble(13));
		
		sBackRate = nf.format(rs2.getDouble(14));
		
		sPdgSum = DataConvert.toMoney(rs2.getDouble(15));
		
		sPdgAccountNo = rs2.getString(16);
		if(sPdgAccountNo == null) sPdgAccountNo = "";
		
		sAcceptIntType = rs2.getString(17);
		if(sAcceptIntType == null) sAcceptIntType = "";
		
		sResumeIntType = rs2.getString(18);
		if(sResumeIntType == null) sResumeIntType = "";
		
		sICCyc = rs2.getString(19);
		if(sICCyc == null) sICCyc = "";
		
		sFixCyc = rs2.getString(20);
		if (sFixCyc == null){ 
			sFixCyc = "";
		}else{
			sFixCyc = String.valueOf(Integer.parseInt(sFixCyc));
		}
		
		sPdgPayMethod = rs2.getString(21);
		if(sPdgPayMethod == null) sPdgPayMethod = "";
		
		sBusinessSubType = rs2.getString(22);
		if(sBusinessSubType == null) sBusinessSubType = "";
		
		nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(7);
		sRiskRate = nf.format(rs2.getDouble(23));
		
		sOperateOrgID = rs2.getString(24);
		if(sOperateOrgID == null) sOperateOrgID = "";	
		
		sGatheringName = rs2.getString(25);
		if(sGatheringName == null) sGatheringName = "";	
		
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
		sTemp.append("   <td align=left class=td1 >ΥԼ������(%)</td>");
		sTemp.append("   <td align=left class=td1 >"+sBackRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ί������</td>");
		sTemp.append("   <td align=left class=td1 nowrap>"+sBusinessSubType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ϣ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sICCyc+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�̶�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sFixCyc+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�����Ѽ��շ�ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sPdgPayMethod+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�����ѽ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sPdgSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�����ʺ�</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ί�е�λ�ʺ�</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sConsignAccountNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������֧����</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sPdgAccountNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�Ƹ�Ϣ��־</td>");
		sTemp.append("   <td align=left class=td1 >"+sResumeIntType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��Ϣ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sAcceptIntType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left class=td1 >�������ϵ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sRiskRate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");	
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

