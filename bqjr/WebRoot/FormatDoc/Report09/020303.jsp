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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='020303.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	    
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3.3�����ſͻ����������ڻ������������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=16% align=center class=td1 > ��� </td>");
	sTemp.append("   <td width=18% align=center class=td1 > ���Ż��� </td>");
	sTemp.append("   <td width=16% align=center class=td1 > ���(��) </td>");
	sTemp.append("   <td width=16% align=center class=td1 > ����(��)</td>");
	sTemp.append("   <td width=16% align=center class=td1 > ��ʼ�� </td>");
	sTemp.append("   <td width=16% align=center class=td1 > ������ </td>");
	sTemp.append("   </tr>");

	String sSql = "";
	ASResultSet rs = null;
	String sOrgName = "";//���Ż���
	String sBusinessName = "";//Ʒ��
	double dBalance = 0.00;//���
	double dBusinessSum = 0.00;//����
	String sBeginDate = "";// ��ʼ��
	String sMaturity = "";//������
	
	double dBalance1 = 0.00;//�������ϼ���
	double dBusinessSum1 = 0.00;//����ںϼ���

	sSql = "select OccurOrg,Round(Balance/10000,2) as Balance,"+
		   "Round(BusinessSum/10000,2) as BusinessSum, "+
		   "getItemName('OtherBusinessType',BusinessType) as BusinessName,"+
		   "BeginDate,Maturity "+
		   "from CUSTOMER_OACTIVITY "+
		   "where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next())
	{
		sOrgName = rs.getString("OccurOrg");
		dBalance = rs.getDouble("Balance");
		dBusinessSum = rs.getDouble("BusinessSum");
		sBusinessName = rs.getString("BusinessName");
		sBeginDate = rs.getString("BeginDate");
		sMaturity = rs.getString("Maturity");
		dBalance1 += dBalance;
		dBusinessSum1 += dBusinessSum;
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 > "+sBusinessName+" </td>");
		sTemp.append("   <td width=18% align=center class=td1 > "+sOrgName+"</td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBalance)+" </td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBusinessSum)+"</td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+sBeginDate+" </td>");
		sTemp.append("   <td width=16% align=center class=td1 > "+sMaturity+" </td>");
		sTemp.append("   </tr>");
	}
	rs.getStatement().close();
	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=16% align=center class=td1 colspan=2 > �ϼ� </td>");
	sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBalance1)+" </td>");
	sTemp.append("   <td width=16% align=center class=td1 > "+DataConvert.toMoney(dBusinessSum1)+"</td>");
	sTemp.append("   <td width=16% align=center class=td1 > &nbsp; </td>");
	sTemp.append("   <td width=16% align=center class=td1 >&nbsp; </td>");
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