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
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	//��ñ��
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '06__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "6."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='060105.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[j]+".5�������еĵ�����Ϣ</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=25% align=center class=td1 nowrap > ��������ҵ  </td>");
	sTemp.append("   <td width=12% align=center class=td1 > �Ƿ������ҵ </td>");
	sTemp.append("   <td width=14% align=center class=td1 > ������� </td>");
	sTemp.append("   <td width=14% align=center class=td1 > ����Ʒ�� </td>");
	sTemp.append("   <td width=17% align=center class=td1 > ������ֹ���� </td>");
	sTemp.append("   <td width=14% align=center class=td1 > �弶���� </td>");
	sTemp.append("   </tr>");
	sSql =  " select BC.CustomerID,BC.CustomerName,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName,"
			+" GC.GuarantyValue,GC.BeginDate,GC.EndDate,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult"
			+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
			+" where CR.ObjectNo = GC.serialNo"
			+" and CR.ObjectType = 'GUARANTY_CONTRACT'"
			+" and BC.SerialNo=CR.SerialNo"
			+" and (GC.GuarantorID is not null or GC.GuarantorID <> ' ')"
			+" and GC.GuarantorID = '"+sGuarangtorID+"'";
	//out.println(sSql);
	String sGuarantorID = "";
	String sGuarantorName = "";
	String sGuarantyTypeName = "";
	double dGuarantyValue = 0.0;
	String sGuarantyValue = "";
	String sBeginDate = "";
	String sEndDate = "";
	String sClassifyResult = "";
	String IsRelativer = "";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantorID = rs2.getString(1);
		int I = 0;
		String sSql2 = "select count(*) from CUSTOMER_RELATIVE where CustomerID = '"+sGuarangtorID+"' and RelativeID = '"+sGuarantorID+"'";
		
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
	/*
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='2' align=left class=td1 > С��: </td>");
	sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dGuarantyValue)+"&nbsp;</td>");
	sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
	sTemp.append("</tr>");
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