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
	
	String sCustomerName = "";			//�ɶ�����
	String sCertID = "";				//��֯��������
	String sRelationShipName = "";		//���ʷ�ʽ
	double dOughtSum = 0.0;				//���ʽ��
	double dInvestmentProp = 0.0;		//ռ�ȣ�����OR �ֹɱ���
	String sInvestDate = "";			//����ʱ��
	String sRelativeID = "";			//��Ͷ����ҵID
	double dInvestmentSum = 0.0;		//Ͷ�ʽ��
	double dInvestYield = 0.0;			//��һ��Ͷ������
	String sOperateOrgName = "";		//���Ż���
	String sBusinessTypeName = "";		//����Ʒ��
	String sVouchTypeName = "";			//������ʽ
	double dBalance = 0.0;				//�������
	String sMaturity = "";				//������
	
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
	sTemp.append("<form method='post' action='060102.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[j]+".2����֤�˹�����ϵ����λ����Ԫ��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=19% align=center class=td1 > �ɶ�����  </td>");
    sTemp.append("  <td width=15% align=center class=td1 > ��֯�������� </td>");
    sTemp.append("  <td width=20% align=center class=td1 > ���ʷ�ʽ </td>");
    sTemp.append("  <td width=15% align=center class=td1 > ���ʽ�� </td>");
    sTemp.append("  <td width=15% align=center class=td1 > ռ�ȣ����� </td>");
    sTemp.append("  <td width=16% align=center class=td1 > ����ʱ�� </td>");
    sTemp.append(" </tr>");
    
    rs2 = Sqlca.getResultSet("select CustomerName,CertID,getItemName('RelationShip',RelationShip) as RelationShipName,"
							+"OughtSum,InvestmentProp,InvestDate from CUSTOMER_RELATIVE "
							+"where RelationShip like '52%' and length(RelationShip)>2 and EffStatus='1' and CustomerID ='"+sGuarangtorID+"'");
	
	while(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName = " ";
		sCertID = rs2.getString(2);
		if(sCertID == null) sCertID = " ";
		sRelationShipName = rs2.getString(3);
		if(sRelationShipName == null) sRelationShipName = " ";
		dOughtSum = rs2.getDouble(4)/10000;
		dInvestmentProp = rs2.getDouble(5);
		sInvestDate = rs2.getString(6);
		if(sInvestDate == null) sInvestDate = " ";
		
		sTemp.append("  <tr>");
  	    sTemp.append("  <td width=19% align=left class=td1 >"+sCustomerName+"&nbsp; </td>");
        sTemp.append("  <td width=15% align=left class=td1 >"+sCertID+"&nbsp;</td>");
        sTemp.append("  <td width=20% align=left class=td1 >"+sRelationShipName+"&nbsp;</td>");
        sTemp.append("  <td width=15% align=right class=td1 >"+DataConvert.toMoney(dOughtSum)+"&nbsp;</td>");
        sTemp.append("  <td width=15% align=right class=td1 >"+DataConvert.toMoney(dInvestmentProp)+"&nbsp;</td>");
        sTemp.append("  <td width=16% align=left class=td1 >"+sInvestDate+"&nbsp;</td>");
        sTemp.append("  </tr>");
	}
	rs2.getStatement().close();	
	
	sTemp.append("  <tr>");
  	sTemp.append(" <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > �����˶����ȨͶ��������ϲ�����Χ�ڣ�</font>  </td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=19% align=center class=td1 > ��Ͷ����ҵ  </td>");
    sTemp.append("  <td width=17% align=center class=td1 > ��֯�������� </td>");
    sTemp.append("  <td width=18% align=center class=td1 > Ͷ�ʽ��</td>");
    sTemp.append("  <td width=15% align=center class=td1 > �ֹɱ���% </td>");
    sTemp.append("  <td colspan='2' align=center class=td1 > ��һ��Ͷ������</td>");
    sTemp.append("  </tr>");
    
    rs2 = Sqlca.getResultSet("select CustomerName,CertID,InvestmentSum,InvestmentProp,InvestYield "
							+"from CUSTOMER_RELATIVE "
							+"where RelationShip like '02%' and length(RelationShip)>2 and EffStatus='1' and CustomerID ='"+sGuarangtorID+"'");
	while(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName = " ";
		sCertID = rs2.getString(2);
		if(sCertID == null) sCertID = " ";
		dInvestmentSum = rs2.getDouble(3)/10000;
		dInvestmentProp = rs2.getDouble(4);
		dInvestYield = rs2.getDouble(5)/10000;
		sTemp.append("  <tr>");
  		sTemp.append("  <td width=19% align=left class=td1 >"+sCustomerName+"&nbsp; </td>");
    	sTemp.append("  <td width=15% align=left class=td1 >"+sCertID+"&nbsp;</td>");
    	sTemp.append("  <td width=20% align=right class=td1 >"+DataConvert.toMoney(dInvestmentSum)+"&nbsp;</td>");
    	sTemp.append("  <td width=15% align=right class=td1 >"+DataConvert.toMoney(dInvestmentProp)+"&nbsp;</td>");
    	sTemp.append("  <td colspan='2' align=right class=td1 >"+DataConvert.toMoney(dInvestYield)+"&nbsp;</td>");
    	sTemp.append("  </tr>");
    }
	rs2.getStatement().close();	
	
	sTemp.append("  <tr>");
  	sTemp.append(" <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > �������������ſͻ���Ϣ  </font></td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=19% align=center class=td1 > ������ҵ����  </td>");
    sTemp.append("  <td width=15% align=center class=td1 > ��֯�������� </td>");
    sTemp.append("  <td colspan='4' align=center class=td1 > �������˹�ϵ</td>");
    sTemp.append("  </tr>");
  
    sSql = "select customername,certid,getItemname('relationship',relationship) "+
		          "from customer_relative where customerid in "+
		          "(select relativeid from customer_relative "+
		          "where customerid='"+sGuarangtorID+"' and relationship='5401') "+
		          "and relativeid not in('"+sGuarangtorID+"') order by customername ";
    	
    rs2 = Sqlca.getResultSet(sSql);
    
	while(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName = " ";
		sCertID = rs2.getString(2);
		if(sCertID == null) sCertID = " ";
		sRelationShipName = rs2.getString(3);
		if(sRelationShipName == null) sRelationShipName = " ";
		sTemp.append("  <tr>");
  		sTemp.append(" <td width=19% align=left class=td1 >"+sCustomerName+"&nbsp; </td>");
    	sTemp.append("  <td width=18% align=left class=td1 >"+sCertID+"&nbsp;</td>");
    	sTemp.append("  <td colspan='4' align=left class=td1 >"+sRelationShipName+"&nbsp;</td>");
    	sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	sTemp.append("  <tr>");
  	sTemp.append(" <td class=td1 align=left colspan=18 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > �����˵ļ��Ź�����ҵ�����е��������  </font></td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=19% align=center class=td1 > ���Ź�����ҵ  </td>");
    sTemp.append("  <td width=15% align=center class=td1 > ���Ż��� </td>");
    sTemp.append("  <td width=20% align=center class=td1 > ����Ʒ�� </td>");
    sTemp.append("  <td width=15% align=center class=td1 > ������� </td>");
    sTemp.append("  <td width=15% align=center class=td1 > ������ʽ </td>");
    sTemp.append("  <td width=16% align=center class=td1 > ������ </td>");
    sTemp.append("  </tr>");
    rs2 = Sqlca.getResultSet("select CustomerName,getOrgName(OperateOrgID) as OperateOrgName,"
								+"getBusinessName(BusinessType) as BusinessTypeName,"
								+"Balance,getItemName('VouchType',VouchType) as VouchTypeName,Maturity "
								+"from BUSINESS_CONTRACT where CustomerID in "
								+"(select relativeid from customer_relative where customerid in "
								+"(select relativeid from customer_relative "
								+"where customerid='"+sGuarangtorID+"' and relationship='5401') "
								+"and relativeid not in('"+sGuarangtorID+"') ) " 
								+"and (FinishDate is null or FinishDate = ' ') "
								+"and balance >= 0 order by CustomerName ");
	while(rs2.next())
	{
		sCustomerName = rs2.getString(1);
		if(sCustomerName == null) sCustomerName = "";
		sOperateOrgName = rs2.getString(2);
		if(sOperateOrgName == null) sOperateOrgName = "";
		sBusinessTypeName = rs2.getString(3);
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		dBalance = rs2.getDouble(4);
		String sBalance = DataConvert.toMoney(dBalance/10000);
		sVouchTypeName = rs2.getString(5);
		if(sVouchTypeName == null) sVouchTypeName = "";
		sMaturity = rs2.getString(6);
		if(sMaturity == null) sMaturity = "";
		sTemp.append("  <tr>");
  		sTemp.append("  <td width=19% align=left class=td1 nowrap >"+sCustomerName+"&nbsp; </td>");
    	sTemp.append("  <td width=15% align=left class=td1 >"+sOperateOrgName+"&nbsp;</td>");
    	sTemp.append("  <td width=20% align=left class=td1 nowrap >"+sBusinessTypeName+"&nbsp;</td>");
    	sTemp.append("  <td width=15% align=right class=td1 >"+sBalance+"&nbsp;</td>");
    	sTemp.append("  <td width=15% align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");
    	sTemp.append("  <td width=16% align=left class=td1 >"+sMaturity+"&nbsp;</td>");
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