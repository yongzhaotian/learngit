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
/*
'	String sRegisterAdd = "";		//ע���ַ
'	String sOfficeAdd = "";			//�칫��ַ
'	String sOrgType = "";		//��ҵ����
'	String sIndustryType = "";		//��ҵ����
'	String sRegisterCapital = "";	//ע���ʱ�
'	String sPaiclUpCapital = "";	//ʵ���ʱ�
'	String sScopeName = "";			//��ҵ��ģ
'	String CreditLevel = "";		//���õȼ�
'	String FictitiousPerson = "";	//���˴���
'	String SetupDate = "";			//����ʱ��
'	String GroupFlag = "";			//�Ƿ����ű�׼���ſͻ�
'	String MostBusiness = "";		//��Ӫҵ��
'	String ListingCorpType = "";	//���й�˾����
	
'	//�����˻�����Ϣ
'	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,OfficeAdd,getitemname('OrgType',OrgType) as OrgTypeName,"
'							+"getitemName('IndustryType',IndustryType) as IndustryType,RegisterCapital,PaiclUpCapital,getitemname('Scope',Scope) as ScopeName,"
'							+"getItemName('CreditLevel',CreditLevel),FictitiousPerson,SetupDate,getItemName('YesNo',GroupFlag) as GroupFlag,"
'							+"MostBusiness,getItemname('ListingCorpType',ListingCorpOrNot) as ListingCorpType "
'							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
'	
'	if(rs2.next())
'	{
'		sRegisterAdd = rs2.getString(1);
'		if(sRegisterAdd == null) sRegisterAdd=" ";
'		
'		sOfficeAdd = rs2.getString(2);
'		if(sOfficeAdd == null) sOfficeAdd=" ";
'		
'		sOrgType = rs2.getString(3);
'		if(sOrgType == null) sOrgType=" ";
'		
'		sIndustryType = rs2.getString(4);
'		if(sIndustryType == null) sIndustryType=" ";
'		
'		sRegisterCapital = DataConvert.toMoney(rs2.getDouble(5)/10000);
'		
'		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble(6)/10000);
'		
'		sScopeName = rs2.getString(7);
'		if(sScopeName == null) sScopeName=" ";
'		
'		CreditLevel = rs2.getString(8);
'		if(CreditLevel == null) CreditLevel=" ";
'		
'		FictitiousPerson = rs2.getString(9);
'		if(FictitiousPerson == null) FictitiousPerson=" ";
'		
'		SetupDate = rs2.getString(10);
'		if(SetupDate == null) SetupDate=" ";
'		
'		GroupFlag = rs2.getString(11);
'		if(GroupFlag == null) GroupFlag=" ";
'		
'		MostBusiness = rs2.getString(12);
'		if(MostBusiness == null) MostBusiness=" ";
'		
'		ListingCorpOrNot = rs2.getString(13);
'		if(ListingCorpOrNot == null) ListingCorpOrNot=" ";
'	}
'	rs2.getStatement().close();	

'String sNewCustomer = " ";//�Ƿ��¿ͻ�
'	rs2 = Sqlca.getResultSet("select count(*) from BUSINESS_CONTRACT where CustomerID='"+sCustomerID+"'");
'	if(rs2.next())
'	{
'		 if(rs2.getInt(1)>1)sNewCustomer = "��";
'		 else sNewCustomer = "��";
'	}
'	rs2.getStatement().close();	
'	
'	String sIsDirector = " ";//�Ƿ����йɶ�
'	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType = '040' and CustomerID='"+sCustomerID+"'");
'	if(rs2.next())
'	{
'		 if(rs2.getInt(1)==0)sIsDirector = "��";
'		 else sIsDirector = "��";
'	}
'	rs2.getStatement().close();	
'	
'	String sIsWarner = "";	//�Ƿ����з���Ԥ���ͻ�
'	rs2 = Sqlca.getResultSet("select count(*) from CUSTOMER_SPECIAL where SpecialType in('010','020') and CustomerID = '"+sCustomerID+"'");
'	if(rs2.next()) 
'	{
'		if(rs2.getInt(1) >=1 ) sIsWarner = "��";
'		else sIsWarner = "��";
'	}
'	rs2.getStatement().close();
'	
'	String sBourseName = "";//���еص�
'	String sIPODate = "";	//����ʱ��
'	String sStockName = "";	//��Ʊ���
'	String sStockCode = "";	//��Ʊ����
'	
'	rs2 = Sqlca.getResultSet("select BourseName,IPODate,StockName,StockCode from ENT_IPO where CustomerID='"+sCustomerID+"' Order by IPODate DESC");
'	if(rs2.next())
'	{
'		sBourseName = rs2.getString(1);
'		if(sBourseName == null) sBourseName=" ";
'		sIPODate = rs2.getString(2);
'		if(sIPODate == null) sIPODate=" ";
'		sStockName = rs2.getString(3);
'		if(sStockName == null) sStockName=" ";
'		sStockCode = rs2.getString(4);
'		if(sStockCode == null) sStockCode=" ";
'	}
'	rs2.getStatement().close();
*/

//Add by zhaominglei 060308

	String sCustomerName = "";			//����
	String sCertType = "";			//֤������
	String sCertID = "";				//֤������
	String sSex = "";						//�Ա�
	String sBirthday = "";			//��������
	String sEduExperience = "";	//���ѧ��
	String sEduDegree = "";			//���ѧλ
	String sNativePlace = "";		//������ַ
	String sMarriage = "";			//����״��
	String sFamilyAdd = "";			//��ס��ַ
	String sFamilyZIP = "";		//��ס��ַ�ʱ�
	String sCommAdd = "";				//ͨѶ��ַ
	String sCommZip = "";				//ͨѶ��ַ�ʱ�
	String sOccupation = "";		//ְҵ	
	String sHeadShip = "";			//ְ��
	String sPosition = "";			//ְ��
	String sIndustryTypeName = "";	//Ŀǰ������ҵ
	String sWorkCorp = "";			//��λ����
	
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getItemName('CertType',CertType) as CertType,CertID,getItemName('Sex',Sex) as Sex,Birthday,getItemName('EducationExperience',EduExperience) as EduExperience,getItemName('EducationDegree',EduDegree) as EduDegree,"
							+"NativePlace,getItemName('Marriage',Marriage) as Marriage,FamilyAdd,FamilyZIP,CommAdd,CommZip,getItemName('Occupation',Occupation) as Occupation,getItemName('HeadShip',HeadShip) as HeadShip,"
							+"getItemName('TechPost',Position) as Position,getItemName('IndustryType',UnitKind) as IndustryTypeName,WorkCorp "
							+"from IND_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName=" ";
		
		sCertType = rs2.getString(2);
		if(sCertType == null) sCertType=" ";
		
		sCertID = rs2.getString(3);
		if(sCertID == null) sCertID=" ";
		
		sSex = rs2.getString(4);
		if(sSex == null) sSex=" ";
		
		sBirthday = rs2.getString(5);
		if(sBirthday == null) sBirthday=" ";
		
		sEduExperience = rs2.getString(6);
		if(sEduExperience == null) sEduExperience=" ";
		
		sEduDegree = rs2.getString(7);
		if(sEduDegree == null) sEduDegree=" ";
		
		sNativePlace = rs2.getString(8);
		if(sNativePlace == null) sNativePlace=" ";
		
		sMarriage = rs2.getString(9);
		if(sMarriage == null) sMarriage=" ";
		
		sFamilyAdd = rs2.getString(10);
		if(sFamilyAdd == null) sFamilyAdd=" ";
		
		sFamilyZIP = rs2.getString(11);
		if(sFamilyZIP == null) sFamilyZIP=" ";
		
		sCommAdd = rs2.getString(12);
		if(sCommAdd == null) sCommAdd=" ";
		
		sCommZip = rs2.getString(13);
		if(sCommZip == null) sCommZip=" ";
		
		sOccupation = rs2.getString(14);
		if(sOccupation == null) sOccupation=" ";
		
		sHeadShip = rs2.getString(15);
		if(sHeadShip == null) sHeadShip=" ";
		
		sPosition = rs2.getString(16);
		if(sPosition == null) sPosition=" ";
		
		sIndustryTypeName = rs2.getString(17);
		if(sIndustryTypeName == null) sIndustryTypeName=" ";
		
		sWorkCorp = rs2.getString(18);
		if(sWorkCorp == null) sWorkCorp=" ";

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
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2 �����˻�����Ϣ</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1���ſ�</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 > ���� </td>");
    sTemp.append(" <td colspan='3' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ֤������ </td>");
    sTemp.append("     <td colspan='1' align=left class=td1 >"+sCertType+"&nbsp;</td>");
	sTemp.append("     <td align=center class=td1 > ֤������ </td>");
	sTemp.append("     <td width=15% align=left class=td1 >"+sCertID+"&nbsp;</td>");
	 sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td width=17% align=center class=td1 > �Ա� </td>");
    sTemp.append("     <td width=15% align=left class=td1 >"+sSex+"&nbsp;</td>");
   	sTemp.append("     <td align=center class=td1 > �������� </td>");
    sTemp.append("     <td align=left class=td1 >"+sBirthday+"&nbsp;</td>");
     sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ���ѧ�� </td>");
    sTemp.append("     <td align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
	sTemp.append("     <td align=center class=td1 > ���ѧλ </td>");
    sTemp.append("     <td align=left class=td1 >"+sEduDegree+"&nbsp;</td>");
   sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ������ַ </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ����״�� </td>");
    sTemp.append("     <td colspan='3' align=left class=td1 >"+sMarriage+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ��ס��ַ </td>");
    sTemp.append("     <td align=left class=td1 >"+sFamilyAdd+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ��ס��ַ�ʱ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sFamilyZIP+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ͨѶ��ַ </td>");
    sTemp.append("     <td align=left class=td1 >"+sCommAdd+"&nbsp;</td>");
    sTemp.append("     <td align=center class=td1 > ͨѶ��ַ�ʱ� </td>");
    sTemp.append("     <td align=left class=td1 >"+sCommZip+"&nbsp;</td>");
    sTemp.append("  </tr>");
//	sTemp.append("   <tr>");
//	sTemp.append("     <td colspan='4' align=left class=td1 > ��Ӫ��Χ��<br>"+MostBusiness+"&nbsp;</td>");
//    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ְҵ </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sOccupation+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ְ�� </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sHeadShip+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
	sTemp.append("     <td align=center class=td1 > ְ�� </td>");
    sTemp.append("    <td colspan='3' align=center class=td1 >"+sPosition+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > Ŀǰ������ҵ </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sIndustryTypeName+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append("     <td align=center class=td1 > ��λ���� </td>");
    sTemp.append("     <td colspan='3' align=center class=td1 >"+sWorkCorp+"&nbsp;</td>");
//End by zhaominglei 060308
    
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
