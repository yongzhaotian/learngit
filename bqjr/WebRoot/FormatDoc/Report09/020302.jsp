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
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	

	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020302.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.2�����ſͻ������е��������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=16% align=center class=td1 > ��� </td>");
	sTemp.append("   <td width=18% align=center class=td1 > ���Ż��� </td>");
	sTemp.append("   <td width=14% align=center class=td1 > ���(��) </td>");
	sTemp.append("   <td width=14% align=center class=td1 > ����(��)</td>");
	sTemp.append("   <td width=24% align=center class=td1 > ������ʽ </td>");
	sTemp.append("   <td width=14% align=center class=td1 > ������ </td>");
	sTemp.append("   </tr>");
	
	String sSql = "";
	ASResultSet rs = null;
	String sOrgName = "";//���Ż���
	double dBalance = 0.00;//���
	double dBusinessSum = 0.00;//����
	String sVouchTypeName = "";//������ʽ
	String sMaturity = "";//������
	
	int iCount = 0;//ͳ���Ƿ���ڼ�¼
	double dBalance1 = 0.00;//���ڴ������ϼ���
	double dBusinessSum1 = 0.00;//���ڴ���ںϼ���
	double dBalance2 = 0.00;//���гжһ�Ʊ���ϼ���
	double dBusinessSum2 = 0.00;//���гжһ�Ʊ���ںϼ���
	double dBalance3 = 0.00;//���ڽ�����ϼ���
	double dBusinessSum3 = 0.00;//���ڽ��ںϼ���
	double dBalance4 = 0.00;//���ڽ�����ϼ���
	double dBusinessSum4 = 0.00;//���ڽ��ںϼ���
	
	
	//----------------------------------���ڴ���-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='1010010' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance1 = rs.getDouble("Balance");
		dBusinessSum1 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> ���ڴ��� </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='1010010' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//���Ż���
		    dBalance = rs.getDouble("Balance");//���
			dBusinessSum = rs.getDouble("BusinessSum");//����
			sVouchTypeName = rs.getString("VouchTypeName");//������ʽ
			sMaturity = rs.getString("Maturity");//������
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> ���ڴ��� </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance1)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum1)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}
	
	//----------------------------------���гжһ�Ʊ-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='2010' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance2 = rs.getDouble("Balance");
		dBusinessSum2 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> ���гжһ�Ʊ </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='2010' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//���Ż���
		    dBalance = rs.getDouble("Balance");//���
			dBusinessSum = rs.getDouble("BusinessSum");//����
			sVouchTypeName = rs.getString("VouchTypeName");//������ʽ
			sMaturity = rs.getString("Maturity");//������
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> ���гжһ�Ʊ </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance2)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum2)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}

	//----------------------------------���ڽ��-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='1010020' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance3 = rs.getDouble("Balance");
		dBusinessSum3 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> ���ڽ�� </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='1010020' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//���Ż���
		    dBalance = rs.getDouble("Balance");//���
			dBusinessSum = rs.getDouble("BusinessSum");//����
			sVouchTypeName = rs.getString("VouchTypeName");//������ʽ
			sMaturity = rs.getString("Maturity");//������
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> ���ڽ�� </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance3)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum3)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}
	//----------------------------------��Ʊ����-----------------------------------------------
	sSql = "select Count(*),Round(Sum(Balance)/10000,2) as Balance,"+
		   "Round(Sum(BusinessSum-BailSum)/10000,2) as BusinessSum "+
		   "from Business_Contract "+
		   "where BusinessType='1020020' "+
		   "and CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		iCount = rs.getInt(1);
		dBalance4 = rs.getDouble("Balance");
		dBusinessSum4 = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	if(iCount == 0)
	{	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 rowspan=2> ��Ʊ���� </td>");
		sTemp.append("   <td width=18% align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=24% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 > &nbsp; </td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sSql = "select getOrgName(ManageOrgID) as ManageOrgName,Round(Balance/10000,2) as Balance,"+
			   "Round((BusinessSum-BailSum)/10000,2) as BusinessSum,"+
			   "getItemName('VouchType',VouchType) as VouchTypeName,"+
			   "Maturity "+
			   "from Business_Contract "+
		   		"where BusinessType='1020020' "+
		   		"and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		int j =0;
		while(rs.next())
		{
			sOrgName = rs.getString("ManageOrgName");//���Ż���
		    dBalance = rs.getDouble("Balance");//���
			dBusinessSum = rs.getDouble("BusinessSum");//����
			sVouchTypeName = rs.getString("VouchTypeName");//������ʽ
			sMaturity = rs.getString("Maturity");//������
			if(j==0)
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=16% align=center class=td1 rowspan="+(iCount+1)+"> ��Ʊ���� </td>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
				sTemp.append("   <td width=18% align=center class=td1 >"+sOrgName+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance)+"</td>");
				sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum)+"</td>");
				sTemp.append("   <td width=24% align=center class=td1 >"+sVouchTypeName+"</td>");
				sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"</td>");
				sTemp.append("   </tr>");
			}
			j++;			
		}
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   <td width=18% align=center class=td1 >С��</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBalance4)+"</td>");
		sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum4)+"</td>");
		sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
		sTemp.append("   </tr>");
	}
	sTemp.append("   <tr>");
	sTemp.append("   <td width=18% align=center colspan=3 class=td1 >�����ܼ�</td>");
	sTemp.append("   <td width=14% align=right class=td1 >"+DataConvert.toMoney(dBusinessSum1+dBusinessSum2+dBusinessSum3+dBusinessSum4)+"</td>");
	sTemp.append("   <td width=14% align=center class=td1 >&nbsp; </td>");
	sTemp.append("   <td width=24% align=center class=td1 >&nbsp; </td>");
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