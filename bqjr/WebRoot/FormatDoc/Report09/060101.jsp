<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   fhuang  2006.01.09
		Tester:
		Content: ��С��ҵ���鱨��
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
	String sGuarangtorID = "";//�����ͻ�ID��
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	//��ñ�֤�˿ͻ�����
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = '"+sGuarangtorID+"'";
	String sCustomerType = "";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sCustomerType = rs2.getString(1);
	rs2.getStatement().close();
	if(sCustomerType==null) sCustomerType="";
	sCustomerType=sCustomerType.substring(0,2);
	
	String sRegisterAdd = "";		//ע���ַ
	String sOfficeAdd = "";			//�칫��ַ
	String sOrgType = "";		//��ҵ����
	String sIndustryType = "";		//��ҵ����
	String sRegisterCapital = "";	//ע���ʱ�
	String sPaiclUpCapital = "";	//ʵ���ʱ�
	String sScopeName = "";			//��ҵ��ģ
	String CreditLevel = "";		//���õȼ�
	String FictitiousPerson = "";	//���˴���
	String SetupDate = "";			//����ʱ��
	String GroupFlag = "";			//�Ƿ����ű�׼���ſͻ�
	String MostBusiness = "";		//��Ӫҵ��
	String ListingCorpType = "";	//���й�˾����
	
	//�����˻�����Ϣ
	rs2 = Sqlca.getResultSet("select RegisterAdd,OfficeAdd,getitemname('OrgType',OrgType) as OrgTypeName,"
							+"getitemName('IndustryType',IndustryType) as IndustryType,RegisterCapital,PaiclUpCapital,getitemname('Scope',Scope) as ScopeName,"
							+"CreditLevel,FictitiousPerson,SetupDate,getItemName('YesNo',GroupFlag) as GroupFlag,"
							+"MostBusiness,getItemname('ListingCorpType',ListingCorpOrNot) as ListingCorpType "
							+"from ENT_INFO where CustomerID='"+sGuarangtorID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString(1);
		if(sRegisterAdd == null) sRegisterAdd=" ";
		
		sOfficeAdd = rs2.getString(2);
		if(sOfficeAdd == null) sOfficeAdd=" ";
		
		sOrgType = rs2.getString(3);
		if(sOrgType == null) sOrgType=" ";
		
		sIndustryType = rs2.getString(4);
		if(sIndustryType == null) sIndustryType=" ";
		
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(5)/10000);
		
		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble(6)/10000);
		
		sScopeName = rs2.getString(7);
		if(sScopeName == null) sScopeName=" ";
		
		CreditLevel = rs2.getString(8);
		if(CreditLevel == null) CreditLevel=" ";
		
		FictitiousPerson = rs2.getString(9);
		if(FictitiousPerson == null) FictitiousPerson=" ";
		
		SetupDate = rs2.getString(10);
		if(SetupDate == null) SetupDate=" ";
		
		GroupFlag = rs2.getString(11);
		if(GroupFlag == null) GroupFlag=" ";
		
		MostBusiness = rs2.getString(12);
		if(MostBusiness == null) MostBusiness=" ";
		
		ListingCorpType = rs2.getString(13);
		if(ListingCorpType == null) ListingCorpType=" ";
	}
	rs2.getStatement().close();	
	
	String sNewCustomer = " ";//�Ƿ��¿ͻ�
	rs2 = Sqlca.getResultSet("select count(*) from BUSINESS_CONTRACT where CustomerID='"+sGuarangtorID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)>1)sNewCustomer = "��";
		 else sNewCustomer = "��";
	}
	rs2.getStatement().close();	
	
	String sIsDirector = " ";//�Ƿ����йɶ�
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '040' and CustomerID='"+sGuarangtorID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)==0)sIsDirector = "��";
		 else sIsDirector = "��";
	}
	rs2.getStatement().close();	
	
	String sIsWarner = "";	//�Ƿ����з���Ԥ���ͻ�
	
	
	String sBourseName = "";//���еص�
	String sIPODate = "";	//����ʱ��
	String sStockName = "";	//��Ʊ���
	String sStockCode = "";	//��Ʊ����
	
	
	
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
	sTemp.append("<form method='post' action='060101.jsp' name='reportInfo'>");
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	if(j==0)
	{
		sTemp.append("   <tr>");
		sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6 ������ʽ����</font></td> ");	
		sTemp.append("   </tr>");
	}	
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6.1����֤��ʽ</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6.1.1����֤�˻�����Ϣ����λ����Ԫ��</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 > ע���ַ </td>");
    sTemp.append(" <td colspan='3' align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > �칫��ַ </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sOfficeAdd+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��ҵ���� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sOrgType+"&nbsp;</td>");
    sTemp.append("     <td width=17% align=center class=td1 > ��ҵ���� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sIndustryType+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ע���ʱ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ʵ���ʱ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sPaiclUpCapital+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��ҵ��ģ </td>");
    sTemp.append("     <td align=left class=td1 >"+sScopeName+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ���õȼ� </td>");
    sTemp.append("     <td align=left class=td1 >"+CreditLevel+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ���˴��� </td>");
    sTemp.append("     <td align=left class=td1 >"+FictitiousPerson+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ����ʱ�� </td>");
    sTemp.append("     <td align=left class=td1 >"+SetupDate+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > �Ƿ��¿ͻ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sNewCustomer+"&nbsp;</td>");
    
	sTemp.append("     <td align=center class=td1 > �Ƿ����йɶ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sIsDirector+"&nbsp;</td>");
    
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td colspan='4' align=left class=td1 > ��Ӫ��Χ��<br>"+MostBusiness+"&nbsp;</td>");
    sTemp.append("  </tr>");
	
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