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
	String sRegisterAdd = "";		//ע���ַ
	String sRegisterCapital = "";	//ע���ʱ�
	String sPaiclUpCapital = "";	//ʵ���ʱ�
	String SetupDate = "";			//����ʱ��
	String MostBusiness = "";		//��Ӫҵ��
	String sCustomerName = "";//��ҵ����
	String sWebAdd = "";//��ַ
	String sLicenseNo = "";//Ӫҵִ�պ���
	String sYearCheck = "��";//�Ƿ���죨�����ҵ��Ϣ����������ֶ�������ȡֵ��
	String sIndustryTypeName = "";//��ҵ
	int iEmployeeNumber = 0;//ְ������
	String sPerson = "";//����������
	String sBasicBank = "";//�����˻���
	String sLoanCardNo = "";//�������

	String sControlPerson = "";//ʵ�ʿ�����(ĿǰĬ�Ϸ��������ˣ�����ʵ�ʿ�����������ȡֵ)
	int iCountYear = 10;//��ҵ����(Ŀǰ��û������ֶ�)
	String sBadRecord = "��";//�Ƿ��в�����¼(Ŀǰ��û������ֶ�)

	String sOfficeTel = "";//��˾�绰
	String sOfficeFax = "";//��˾����	
	//�����˻�����Ϣ
	ASResultSet rs2 = Sqlca.getResultSet("select RegisterAdd,RegisterCapital,PaiclUpCapital,"
							+"SetupDate,MostBusiness,EnterpriseName,WebAdd,LicenseNo,"
							+"getItemName('IndustryType',IndustryType) as IndustryTypeName,"
							+"EmployeeNumber,FictitiousPerson,BasicBank,LoanCardNo,"
							+"OfficeTel,OfficeFax "
							+"from ENT_INFO where CustomerID='"+sCustomerID+"'");
	
	if(rs2.next())
	{
		sRegisterAdd = rs2.getString("RegisterAdd");
		if(sRegisterAdd == null) sRegisterAdd=" ";
				
		sRegisterCapital = DataConvert.toMoney(rs2.getDouble("RegisterCapital")/10000);
		
		sPaiclUpCapital = DataConvert.toMoney(rs2.getDouble("PaiclUpCapital")/10000);
		
		SetupDate = rs2.getString("SetupDate");
		if(SetupDate == null) SetupDate=" ";
		
		
		MostBusiness = rs2.getString("MostBusiness");
		if(MostBusiness == null) MostBusiness=" ";
		
		sCustomerName = rs2.getString("EnterpriseName");
		if(sCustomerName == null) sCustomerName=" ";
		
		sWebAdd = rs2.getString("WebAdd");
		if(sWebAdd == null) sWebAdd=" ";
		
		sLicenseNo = rs2.getString("LicenseNo");
		if(sLicenseNo == null) sLicenseNo=" ";
		
		sIndustryTypeName = rs2.getString("IndustryTypeName");
		if(sIndustryTypeName == null) sIndustryTypeName=" ";
		
		iEmployeeNumber = rs2.getInt("EmployeeNumber");
		
		sPerson = rs2.getString("FictitiousPerson");
		if(sPerson == null) sPerson=" ";
		
		sBasicBank = rs2.getString("BasicBank");
		if(sBasicBank == null) sBasicBank=" ";
		
		sLoanCardNo = rs2.getString("LoanCardNo");
		if(sLoanCardNo == null) sLoanCardNo=" ";
		
		sOfficeTel = rs2.getString("OfficeTel");
		if(sOfficeTel == null) sOfficeTel=" ";
		
		sOfficeFax = rs2.getString("OfficeFax");
		if(sOfficeFax == null) sOfficeFax=" ";
	}
	rs2.getStatement().close();	
	
	String sFictitiousPerson = "";//�ɶ�����
	double  dInvestmentSum = 0.00;//Ͷ�ʽ��
	double  dInvestmentProp = 0.00;//Ͷ�ʱ���
	String sSql = "";
	
	sSql = "select CustomerName,round(InvestmentSum/10000,2) as InvestmentSum,InvestmentProp "+
	       " from CUSTOMER_RELATIVE " +
		   " where CustomerID = '"+sCustomerID+"' "+
		   " and RelationShip like '52%' "+
		   " and length(RelationShip)>2 "+
		   " and EffStatus='1'";
    rs2 = Sqlca.getASResultSet(sSql);
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2���ͻ��������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1���������</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=12 align=center class=td1 > <B>�������</B> </td>");
    sTemp.append(" </tr>");	
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > ���� </td>");
    sTemp.append("     <td colspan=6 class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append("     <td colspan=2  class=td1 > �������� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+SetupDate+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("   <tr>");
    sTemp.append("     <td colspan=2 class=td1 > ע���ַ </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sRegisterAdd+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > ע���ʱ� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sRegisterCapital+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > ��ַ </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sWebAdd+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > ��Ӫ��Χ</td>");
	sTemp.append("     <td colspan=2 class=td1 >"+MostBusiness+"&nbsp;</td>");
	sTemp.append("     <td colspan=2 class=td1 > ��ҵ </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sIndustryTypeName+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > ���� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+iEmployeeNumber+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > Ӫҵִ�� </td>");
    sTemp.append("     <td colspan=6 class=td1 >"+sLicenseNo+"&nbsp;</td>");
    sTemp.append("     <td colspan=2  class=td1 > �Ƿ���� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sYearCheck+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
    sTemp.append("     <td colspan=2 class=td1 > ���������� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sPerson+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > ���������� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sBasicBank+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > ������� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sLoanCardNo+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
    sTemp.append("     <td colspan=2 class=td1 > ʵ�ʿ����� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sPerson+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > ��ҵ���� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+iCountYear+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > �Ƿ��в�����¼ </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sBadRecord+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=2 class=td1 > ������ </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sPerson+"&nbsp;</td>");
    sTemp.append("     <td colspan=2  class=td1 > �绰 </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sOfficeTel+"&nbsp;</td>");
    sTemp.append("     <td colspan=2 class=td1 > ���� </td>");
    sTemp.append("     <td colspan=2 class=td1 >"+sOfficeFax+"&nbsp;</td>");
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=12 align=center class=td1 > <B>��Ȩ���</B> </td>");
    sTemp.append(" </tr>");	
    sTemp.append("   <tr>");
    sTemp.append("     <td colspan=4 class=td1 align=center > ��Ҫ�ɶ� </td>");
    sTemp.append("     <td colspan=4 class=td1 align=center> Ͷ�ʽ���Ԫ�� </td>");
    sTemp.append("     <td colspan=4 class=td1 align=center> ռ��(%) </td>");
    sTemp.append("  </tr>");
    while(rs2.next())
    {
    	sFictitiousPerson = rs2.getString("CustomerName");
    	dInvestmentSum = rs2.getDouble("InvestmentSum");
    	dInvestmentProp = rs2.getDouble("InvestmentProp");
    	if(sFictitiousPerson == null) sFictitiousPerson = " ";
    	sTemp.append("   <tr>");
	    sTemp.append("     <td colspan=4 class=td1 align=center> "+sFictitiousPerson+"&nbsp;</td>");
	    sTemp.append("     <td colspan=4 class=td1 align=center> "+DataConvert.toMoney(dInvestmentSum)+"&nbsp;</td>");
	    sTemp.append("     <td colspan=4 class=td1 align=center>  "+DataConvert.toMoney(dInvestmentProp)+"&nbsp;</td>");
	    sTemp.append("  </tr>");
	}
    rs2.getStatement().close();
    
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
