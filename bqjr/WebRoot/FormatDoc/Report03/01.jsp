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
	String sCustomerName = "";			//����������
	String sBusinessType = "";			//ҵ��Ʒ��
	String sBusinessTypeName = "";		//����ҵ��Ʒ������
	String sBusinessSum = "";			//���
	String sCurrency = "";				//����
	String sBailRatio = "";				//��֤�������
	String sBusinessRate = "";			//����
	String sPdgRatio = "";				//��������
	String sClassifyResult = "";		//�弶����
	String sVouchType = "";				//������ʽ
	String sPurpose = "";				//�ʽ���;
	double dBusinessSum = 0.0;			//���	
	double dBailRatio = 0.0;			//��֤�������
	double dBusinessRate = 0.0;			//����
	double dPdgRatio = 0.0;				//��������
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,BusinessType,getBusinessName(BusinessType)as BusinessTypeName,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BailRatio,BusinessRate,PdgRatio, "
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		
		dBusinessSum = rs2.getDouble("BusinessSum");
		if(dBusinessSum > 0)
			sBusinessSum = DataConvert.toMoney(dBusinessSum);
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == null) sCurrency = " ";
		
		dBailRatio = rs2.getDouble("BailRatio");
		if(dBailRatio > 0)
			sBailRatio = DataConvert.toMoney(dBailRatio);

		sBusinessRate = DataConvert.toMoney(rs2.getDouble("BusinessRate"));
		//���ʱ���6λС��
        NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
        
        dBusinessRate = rs2.getDouble("BusinessRate");
		if(dBusinessRate > 0)
			sBusinessRate = nf.format(dBusinessRate);
		
		dPdgRatio = rs2.getDouble("PdgRatio");
		if(dPdgRatio > 0)
			sPdgRatio = DataConvert.toMoney(dPdgRatio);
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == null) sVouchType = " ";
		
		sPurpose = rs2.getString("purpose");
		if(sPurpose == null) sPurpose = "  ";
	}
	rs2.getStatement().close();	
	
	String sGuarantyType = "";
	String sSql = 	"select GuarantorName,getItemName('GuarantyType',GuarantyType) from GUARANTY_CONTRACT " +
					" where serialno in " +
					"  (select objectno  from apply_relative "+
					"    where objecttype='GuarantyContract' and serialno='"+sObjectNo+"') order by GuarantyType";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantyType += rs2.getString(1)+"-"+rs2.getString(2)+"<br>&nbsp;<br>";
	}
	rs2.getStatement().close();	

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1��ҵ��ſ�</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >���������ƣ�</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sCustomerName+"</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 > ����ҵ��Ʒ��</td>");
    sTemp.append(" <td width=18% align=center class=td1 > ��� </td>");
    sTemp.append(" <td width=10% align=center class=td1 > ���� </td>");
    sTemp.append(" <td width=17% align=center class=td1 > ��֤�������</td>");
    sTemp.append(" <td width=20% align=center class=td1 > ����/���ʡ�</td>");
    sTemp.append(" <td width=20% align=center class=td1 > �弶���� </td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
    sTemp.append(" <td width=15% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 >"+sCurrency+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sBailRatio+"&nbsp;</td>");
    
    //����ҵ��ȡ�����ʣ�����ҵ��ȡ��������
    if(sBusinessType.substring(0,1).equals("1"))	//����ҵ��
    	sTemp.append(" <td width=15% align=center class=td1 >"+sBusinessRate+"&nbsp;</td>");
    else if(sBusinessType.substring(0,1).equals("2"))	//����ҵ��
    	sTemp.append(" <td width=15% align=center class=td1 >"+sPdgRatio+"&nbsp;</td>");
    else	//����ҵ��
    	sTemp.append(" <td width=15% align=center class=td1 >0.00</td>");
    
    sTemp.append(" <td width=20% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td colspan='6' align=left class=td1 > ��������ҵ��ĵ�����ʽ�;������ݣ�<p>��Ҫ������ʽ��"+sVouchType+"</p>"+sGuarantyType+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td colspan='6' align=left class=td1 > ��������ҵ����ʽ���;��<br>"+sPurpose+"</td>");
    sTemp.append(" </tr>");
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
