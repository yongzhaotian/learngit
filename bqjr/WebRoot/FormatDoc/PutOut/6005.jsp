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
				  "getitemname('Currency',BusinessCurrency) as BusinessCurrency,"+
				  "LoanType,PutOutDate,Maturity,BusinessSum,getItemName('AdjustRateType',AdjustRateType),"+
				  "AdjustRateTerm,getItemName('ICCyc',ICCyc),FixCyc,BusinessRate,LoanAccountNo,"+
				  "getItemName('RateFloatType',RateFloatType),getItemName('OverIntType',OverIntType),"+
				  "getItemName('RateAdjustCyc',RateAdjustCyc),RateFloat,getItemName('GroupType',BusinessSubType),getOrgName(OperateOrgID),GatheringName "+
				  "from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	String sSql10 = "select SerialNo,getItemName('PaymentMode',PaymentMode),PaymentDate,PayeeName,PayeeBank,PayeeAccount,getItemName('Currency',Currency),PaymentSum,Remark,getUserName(InputUserID),InputDate "+
					"from PAYMENT_INFO  where PutoutSerialNo = '"+sObjectNo+"'";

	String sContractSerialNo = "";
	String sDuebillSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessCurrency = "";
	String sLoanType = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sBusinessSum = "";
	String sAdjustRateType = "";
	String sAdjustRateTerm = "";
	String sICCyc = "";
	String sFixCyc = "";
	String sBusinessRate = "";
	String sLoanAccountNo = "";
	String sRateFloatType = "";
	String sOverIntType = "";
	String sRateAdjustCyc = "";
	String sRateFloat = "";
	String sBusinessSubType = "";
	String sOperateOrgID = "";
	String sGatheringName = "";
	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6005.jsp' name='reportInfo'>");	
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
		
		sBusinessCurrency = rs2.getString(6);
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		
		sLoanType = rs2.getString(7);
		if(sLoanType == null) sLoanType = "";
		
		sPutOutDate = rs2.getString(8);
		if(sPutOutDate == null) sPutOutDate = "";
		
		sMaturity = rs2.getString(9);
		if(sMaturity == null) sMaturity = "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(10));
		
		sAdjustRateType = rs2.getString(11);
		if(sAdjustRateType == null) sAdjustRateType = "";
		
		sAdjustRateTerm = rs2.getString(12);
		if(sAdjustRateTerm == null) sAdjustRateTerm = "";
		
		sICCyc = rs2.getString(13);
		if(sICCyc == null) sICCyc = "";
		
		sFixCyc = rs2.getString(14);
		if (sFixCyc == null){ 
			sFixCyc = "";
		}else{
			sFixCyc = String.valueOf(Integer.parseInt(sFixCyc));
		}
		 
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble(15));
		
		sLoanAccountNo = rs2.getString(16);
		if(sLoanAccountNo == null) sLoanAccountNo = "";
		
		sRateFloatType = rs2.getString(17);
		if(sRateFloatType == null) sRateFloatType = "";
		
		sOverIntType = rs2.getString(18);
		if(sOverIntType == null) sOverIntType = "";
		
		sRateAdjustCyc = rs2.getString(19);
		if(sRateAdjustCyc == null) sRateAdjustCyc = "";
		
		sRateFloat = nf.format(rs2.getDouble(20));
		
		sBusinessSubType = rs2.getString(21);
		if(sBusinessSubType == null) sBusinessSubType = "";
		
		sOperateOrgID = rs2.getString(22);
		if(sOperateOrgID == null) sOperateOrgID = "";
		
		sGatheringName = rs2.getString(23);
		if(sGatheringName == null) sGatheringName = "";	
		
		rs2.getStatement().close();	
		
		ASResultSet rs3 = Sqlca.getResultSet(sSql10);
		int N = rs3.getRowCount();
						
		String[][] value = new String[N][11];
		
		for(int i = 0;rs3.next();i++){
			for(int j = 0;j < 11; j++){
				if(j == 7){
					value[i][7] = DataConvert.toMoney(rs3.getDouble(8));
				}else{
				value[i][j] = rs3.getString(j+1);
				}
			}
		}
		rs3.getStatement().close();
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
		sTemp.append("   <td class=td1 align=center colspan='9' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>�ſ�֪ͨ��<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>֧�У�������Ʋ��ţ� </td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=9 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>�������ˣ�������ҵ��:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ�������ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰������������	   </td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2  align=left class=td1 > ��ͬ��ˮ��</td>");
		sTemp.append("   <td colspan=3  align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=2  align=left class=td1 >������ˮ��</td>");
		sTemp.append("   <td colspan=2  align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >�ͻ���</td>");
	    sTemp.append("   <td colspan=7 align=left class=td1 >"+sCustomerID+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >�ͻ�����</td>");
	    sTemp.append("   <td colspan=7 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >���Ŵ�������</td>");
	    sTemp.append("   <td colspan=3 align=left class=td1 >"+sBusinessSubType+"&nbsp;</td>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >����</td>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >��������</td>");
	    sTemp.append("   <td colspan=3 align=left class=td1 >"+sLoanType+"&nbsp;</td>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >������������</td>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >"+sGatheringName+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >���Ž��</td>");
	    sTemp.append("   <td colspan=7  align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >��Ϣ��</td>");
	    sTemp.append("   <td colspan=3 align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >������</td>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >ִ��������(��)</td>");
	    sTemp.append("   <td colspan=3 align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
	   	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   </tr>");
	    /*
	    sTemp.append("   <tr>");
	    sTemp.append("   <td align=left class=td1 >���ʵ�����ʽ</td>");
	    sTemp.append("   <td align=left class=td1 >"+sAdjustRateType+"&nbsp;</td>");
	    sTemp.append("   <td align=left class=td1 >���ʵ�������</td>");
		sTemp.append("   <td align=left class=td1 >"+sAdjustRateTerm+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td align=left class=td1 >���ʵ�������</td>");
	    sTemp.append("   <td align=left class=td1 >"+sRateAdjustCyc+"&nbsp;</td>");
	   	sTemp.append("   <td align=left class=td1 >������ʽ</td>");
	    sTemp.append("   <td align=left class=td1 >"+sRateFloatType+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td align=left class=td1 >���ڼ�Ϣ��ʽ</td>");
	    sTemp.append("   <td align=left class=td1 >"+sOverIntType+"&nbsp;</td>");
	    sTemp.append("   <td align=left class=td1 >������/��</td>");
	    sTemp.append("   <td align=left class=td1 >"+sRateFloat+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ϣ����</td>");
	    sTemp.append("   <td align=left class=td1 >"+sICCyc+"&nbsp;</td>");
	    sTemp.append("   <td align=left class=td1 >�̶�����</td>");
	    sTemp.append("   <td align=left class=td1 >"+sFixCyc+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���������ʺ�</td>");
	    sTemp.append("   <td align=left class=td1 >"+sLoanAccountNo+"&nbsp;</td>");
	   	sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		*/		
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 align=left class=td1 >֧�����</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >֧����ʽ</td>");
		sTemp.append("   <td colspan=1  align=left class=td1 >֧������</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >�տ�������</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >��������</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >�տ����˻�</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >����</td>");
		sTemp.append("   <td colspan=1 align=left class=td1 >֧�����(Ԫ)</td>");
		sTemp.append("   </tr>");
		
		for(int i = 0; i<N; i++)
		{
			sTemp.append("   <tr>");	
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][0]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][1]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][2]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][3]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][4]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][5]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][6]+"</td>");
			
			sTemp.append("   <td colspan=1 align=left class=td1 >"+value[i][7]+"</td>");

			sTemp.append("   </tr>");
		}
		
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=9 class=td1 > �ſ���������ǩ�֣� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=9 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=9 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>�ſ�ר���£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> ���ڣ�"+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=9 class=td1 >����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	    	
	}
	

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

