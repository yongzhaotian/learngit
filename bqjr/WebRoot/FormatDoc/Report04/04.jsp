<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: ����ĵ�?ҳ
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

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	String sOccurTypeName = "0";		//���ŷ�ʽ
	String sBusinessType = "0";		//����Ʒ��
	String sBusinessTypeName = "0";		//����Ʒ��
	String sCurrencyName = "0";		    //����
	String sBusinessSum = "0";			//�ܶ��
	double dBusinessSum = 0;			//�ܶ��
	String sBalanceSum = "0";			//ʵ����� 
	double dBalanceSum = 0;				//ʵ����� 
	String sBailRatio = "0";			//��֤�����
	String sMaturity = "0";				//������
	String sBusinessRate = "0";			//����
	String sPdgRatio = "";				//��������
	String sClassifyResult = "0";		//�弶����
	double dSum1=0;						//���ϼ�
	double dSum2=0;						//���ϼ�
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='04.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='9' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4��������δ���������ҵ����Ϣ(��λ����)</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=13% align=center class=td1 > ���ŷ�ʽ </td>");
	sTemp.append("   <td width=13% align=center class=td1 > ����Ʒ�� </td>");
	sTemp.append("   <td width=8% align=center class=td1 >����</td>");
	sTemp.append("   <td width=11% align=center class=td1 >�ܶ��</td>");
	sTemp.append("   <td width=11% align=center class=td1 >ʵ�����</td>");
	sTemp.append("   <td width=14% align=center class=td1 >��֤�����%</td>");
	sTemp.append("   <td width=9% align=center class=td1 > ������</td>");
	sTemp.append("   <td width=9% align=center class=td1 >��/���ʡ�</td>");
	sTemp.append("   <td width=12% align=center class=td1 > �弶����</td>");
	sTemp.append("   </tr>");

	NumberFormat nf = NumberFormat.getInstance();
    nf.setMinimumFractionDigits(6);
    nf.setMaximumFractionDigits(6);
        
	ASResultSet rs = Sqlca.getResultSet("select getItemName('OccurType',OccurType) as OccurTypeName," +
					"BusinessType,getBusinessName(BusinessType) as BusinessTypeName," +
					"getItemName('Currency',BusinessCurrency) as CurrencyName," +
					"BusinessSum,Balance,"+
					"BailRatio,Maturity,"+
					"BusinessRate,PdgRatio,"+
					"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "+
					"from BUSINESS_CONTRACT "+
					"where CustomerID='"+sCustomerID+"'"+
					" and Balance>=0 and (FinishDate = ' ' or FinishDate is null)");
	while(rs.next())
	{
		sOccurTypeName = rs.getString("OccurTypeName");
		if(sOccurTypeName == null) sOccurTypeName = " ";
		
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";

		sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";

		sCurrencyName = rs.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName = " ";

		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		if (sBusinessSum == null) sBusinessSum = "";
		
		dBusinessSum = rs.getDouble("BusinessSum");
		dSum1 = dSum1+dBusinessSum;

		sBalanceSum = DataConvert.toMoney(rs.getDouble("Balance")/10000);
		if (sBalanceSum == null) sBalanceSum = "";
		
		dBalanceSum = rs.getDouble("Balance");
		dSum2 = dSum2+dBalanceSum;

		sBailRatio = DataConvert.toMoney(rs.getDouble("BailRatio"));
		if (sBailRatio == null) sBailRatio = "";
		
		sPdgRatio = DataConvert.toMoney(rs.getDouble("PdgRatio"));
		if (sPdgRatio == null) sPdgRatio = "";

		sMaturity = rs.getString("Maturity");
		if(sMaturity == null) sMaturity = " ";

		//sBusinessRate = DataConvert.toMoney(rs.getDouble("BusinessRate"));
		//���ʱ���6λС��
		sBusinessRate = nf.format(rs.getDouble("BusinessRate"));
		if (sBusinessRate == null) sBusinessRate = "";

		sClassifyResult = rs.getString("ClassifyResult");	
		if (sClassifyResult == null) sClassifyResult = "";

		sTemp.append("   <tr>");
		sTemp.append("   <td width=13% align=center class=td1 >"+sOccurTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=13% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=8% align=center class=td1 nowrap>"+sCurrencyName+"&nbsp;</td>");
		sTemp.append("   <td width=11% align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   <td width=11% align=right class=td1 >"+sBalanceSum+"&nbsp;</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append("   <td width=9% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		
		//����ҵ��ȡ�����ʣ�����ҵ��ȡ��������
		if(sBusinessType.substring(0,1).equals("1"))	//����ҵ��
			sTemp.append(" <td width=9% align=right class=td1 >"+sBusinessRate+"</td>");
		else if(sBusinessType.substring(0,1).equals("2"))	//����ҵ��
			sTemp.append(" <td width=9% align=right class=td1 >"+sPdgRatio+"</td>");
		else	//����ҵ��
			sTemp.append(" <td width=9% align=right class=td1 >0.00</td>");
		
		sTemp.append("   <td width=12% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs.getStatement().close();

/*
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=3 align=center class=td1 > С�� </td>");
	sTemp.append("   <td width=11% align=right class=td1 >"+DataConvert.toMoney(dSum1)+"&nbsp;</td>");
	sTemp.append("   <td width=11% align=right class=td1 >"+DataConvert.toMoney(dSum2)+"&nbsp;</td>");
	sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
*/
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='CustomerID' value='"+sCustomerID+"'>");
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
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

