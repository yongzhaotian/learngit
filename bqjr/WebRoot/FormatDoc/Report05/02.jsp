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
	String sCustomerName = "";			//�ͻ�����
	String sCreditLevel = "";		    //���õȼ�
	String sLicenseNo = "";		        //Ӫҵִ�պ���
	String sCorpID = "";		    //��֯��������
	
	String sRegisterCapital = "";	    //ע���ʱ�
	String sCurrency = "";				//����
	String sPaiclUpCapital = "";		//ʵ���ʱ�
	String sNewCustomer = " ";			//�Ƿ��¿ͻ�
	String sIsWarner = "";				//�Ƿ����з���Ԥ���ͻ�
	String sMostBusiness = "";			//��Ӫҵ��

	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getitemname('Currency',BusinessCurrency) as CurrencyName from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	if(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName = "&nbsp;";

		sCurrency = rs2.getString(2);
		if(sCurrency == null) sCurrency = " ";
	}
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select CreditLevel,LicenseNo,CorpID,RegisterCapital,PaiclUpCapital,MostBusiness from ENT_INFO where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		sCreditLevel = rs2.getString(1);
		if(sCreditLevel == null) sCreditLevel = " ";

		sLicenseNo = rs2.getString(2);
		if(sLicenseNo == null) sLicenseNo = " ";
		
		sCorpID = rs2.getString(3);
		if(sCorpID == null) sCorpID = " ";

		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(4)/10000);
		
		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble(5)/10000);

		sMostBusiness = rs2.getString(6);
		if(sMostBusiness == null) sMostBusiness = " ";
	}
	rs2.getStatement().close();

	rs2 = Sqlca.getResultSet("select count(*) from Business_Contract where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)>1)sNewCustomer = "��";
		 else sNewCustomer = "��";
	}
	rs2.getStatement().close();

	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType in('010','020') and CustomerID = '"+sCustomerID+"'");
	if(rs2.next()) 
	{
		if(rs2.getInt(1) >=1 ) sIsWarner = "��";
		else sIsWarner = "��";
	}
	rs2.getStatement().close();
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	
	sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='8' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2����������Ϣ</font></td>"); 	
	sTemp.append("   </tr>");
		
	sTemp.append("   <tr>");
	sTemp.append("   <td width=19% align=center class=td1 >�ͻ�����</td>");
	sTemp.append("   <td colspan=4 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
	sTemp.append("   <td width=14% align=center class=td1 >���õȼ�</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sCreditLevel+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >Ӫҵִ�պ���</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sLicenseNo+"&nbsp;</td>");
	sTemp.append("   <td width=24% align=center class=td1 >��֯��������</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sCorpID+"&nbsp;</td>");
	sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 > ע���ʱ�(��) </td>");
	sTemp.append("   <td width=14% align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
	sTemp.append("   <td width=7% align=center class=td1 > ����</td>");
	sTemp.append("   <td width=8% align=left class=td1 >"+sCurrency+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 > ʵ���ʱ�(��) </td>");
	sTemp.append("   <td align=left class=td1 >"+sPaiclUpCapital+"&nbsp;</td>");
	sTemp.append("   <td width=6% align=center class=td1 > ���� </td>");
	sTemp.append("   <td width=8% align=left class=td1 >"+sCurrency+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 > �Ƿ��¿ͻ� </td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sNewCustomer+"&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 > �Ƿ����з���<br>Ԥ���ͻ�</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sIsWarner+"&nbsp;</td>");
	sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left class=td1 > ��Ӫ��Χ��<br>"+sMostBusiness+"&nbsp;</td>");
	sTemp.append("   </tr>");
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

