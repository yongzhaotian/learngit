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
	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,OfficeAdd,getitemname('OrgType',OrgType) as OrgTypeName,"
							+"getitemName('IndustryType',IndustryType) as IndustryType,RegisterCapital,PaiclUpCapital,getitemname('Scope',Scope) as ScopeName,"
							+"getItemName('CreditLevel',CreditLevel),FictitiousPerson,SetupDate,getItemName('YesNo',GroupFlag) as GroupFlag,"
							+"MostBusiness,getItemname('ListingCorpType',ListingCorpOrNot) as ListingCorpType "
							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
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
	rs2 = Sqlca.getResultSet("select count(*) from BUSINESS_CONTRACT where CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		 if(rs2.getInt(1)>1)sNewCustomer = "��";
		 else sNewCustomer = "��";
	}
	rs2.getStatement().close();	
	
	String sIsDirector = " ";//�Ƿ����йɶ�
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '040' and CustomerID='"+sCustomerID+"'");
	if(rs2.next())
	{
		if(rs2.getInt(1)==0)sIsDirector = "��";
		else sIsDirector = "��";
	}
	rs2.getStatement().close();	
	
	String sIsWarner = "";	//�Ƿ����з���Ԥ���ͻ�
	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType in('010','020') and CustomerID = '"+sCustomerID+"'");
	if(rs2.next()) 
	{
		if(rs2.getInt(1) >=1 ) sIsWarner = "��";
		else sIsWarner = "��";
	}
	rs2.getStatement().close();
	
	String sBourseName = "";//���еص�
	String sIPODate = "";	//����ʱ��
	String sStockName = "";	//��Ʊ���
	String sStockCode = "";	//��Ʊ����
	
	rs2 = Sqlca.getResultSet("select getItemname('IPOName',BourseName) as BourseName,IPODate,StockName,StockCode from ENT_IPO where CustomerID='"+sCustomerID+"' Order by IPODate DESC");
	if(rs2.next())
	{
		sBourseName = rs2.getString(1);
		if(sBourseName == null) sBourseName=" ";
		sIPODate = rs2.getString(2);
		if(sIPODate == null) sIPODate=" ";
		sStockName = rs2.getString(3);
		if(sStockName == null) sStockName=" ";
		sStockCode = rs2.getString(4);
		if(sStockCode == null) sStockCode=" ";
	}
	rs2.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2�������˻�����Ϣ</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1���ſ�����λ����Ԫ��</font></td> ");	
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
    sTemp.append("     <td align=center class=td1 > �Ƿ����Ϳͻ� </td>");
    sTemp.append("     <td align=left class=td1 >"+GroupFlag+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > �Ƿ����йɶ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sIsDirector+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > �Ƿ����з���Ԥ���ͻ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sIsWarner+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td colspan='4' align=left class=td1 > ��Ӫ��Χ��<br>"+MostBusiness+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ���й�˾���� </td>");
    sTemp.append("     <td align=center class=td1 >"+ListingCorpType+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ���еص㼰���� </td>");
    sTemp.append("     <td align=center class=td1 >"+sBourseName+"<br>"+sIPODate+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��Ʊ��� </td>");
    sTemp.append("    <td align=center class=td1 >"+sStockName+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ��Ʊ���� </td>");
    sTemp.append("     <td align=center class=td1 >"+sStockCode+"&nbsp;</td>");
    sTemp.append(" </tr>");
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
