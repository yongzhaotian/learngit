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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020202.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.2�������еĵ�����Ϣ����λ����Ԫ��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=25% align=center class=td1 nowrap > ��������ҵ  </td>");
	sTemp.append("   <td width=12% align=center class=td1 nowrap > �Ƿ������ҵ </td>");
	sTemp.append("   <td width=14% align=center class=td1 > ������� </td>");
	sTemp.append("   <td width=14% align=center class=td1 > ����Ʒ�� </td>");
	sTemp.append("   <td width=17% align=center class=td1 > ������ֹ���� </td>");
	sTemp.append("   <td width=14% align=center class=td1 > �弶���� </td>");
	sTemp.append("   </tr>");
	String sSql =  " select BC.CustomerID,BC.CustomerName,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName,"
			+" GC.GuarantyValue,GC.BeginDate,GC.EndDate,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult"
			+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GUARANTY_CONTRACT'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and GC.GuarantorID = '"+sCustomerID+"'";
	
	String sGuarantorID = "";
	String sGuarantorName = "";
	String sGuarantyTypeName = "";
	double dGuarantyValue = 0.0;
	String sGuarantyValue = "";
	String sBeginDate = "";
	String sEndDate = "";
	String sClassifyResult = "";
	String IsRelativer = "";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantorID = rs2.getString(1);
		int I = 0;
		String sSql2 = "select count(*) from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelativeID = '"+sGuarantorID+"'";
		ASResultSet rs3 = Sqlca.getResultSet(sSql2);
		if(rs3.next()) I = rs3.getInt(1);
		rs3.getStatement().close();	
		if(I == 0) IsRelativer = "��"; else IsRelativer = "��";
		
		sGuarantorName = rs2.getString(2);
		if(sGuarantorName == null) sGuarantorName = " ";
		sGuarantyTypeName = rs2.getString(3);
		if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
		dGuarantyValue += rs2.getDouble(4)/10000;
		sGuarantyValue = DataConvert.toMoney(rs2.getDouble(4)/10000);
		if(sGuarantyValue == null) sGuarantyValue = " ";
		sBeginDate = rs2.getString(5);
		if(sBeginDate == null ) sBeginDate = " ";
		sEndDate = rs2.getString(6);
		if(sEndDate == null ) sEndDate = " ";
		sClassifyResult = rs2.getString(7);
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=25% align=center class=td1 >"+sGuarantorName+"&nbsp; </td>");
		sTemp.append("   <td width=16% align=center class=td1 >"+IsRelativer+"&nbsp;</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+sGuarantyValue+"&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
		sTemp.append("   <td width=17% align=center class=td1 >"+sBeginDate+"��"+sEndDate+"&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs2.getStatement().close();
	
	sSql =  " select getitemname('Currency',BC.BusinessCurrency) as CurrencyName,sum(GC.GuarantyValue)"
			+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GUARANTY_CONTRACT'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and GC.GuarantorID = '"+sCustomerID+"' group by BC.BusinessCurrency";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	while(rs2.next())
	{
		sSum += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}	
	rs2.getStatement().close();	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > С��: </td>");
	sTemp.append("   <td colspan='5' align=left class=td1 >"+sSum+"&nbsp;</td>");
	sTemp.append("</tr>");
	
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

