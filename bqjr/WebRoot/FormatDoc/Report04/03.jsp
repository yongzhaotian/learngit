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
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='10' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3������Ʊ����Ϣ</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 > ��� </td>");
	sTemp.append("   <td width=18% align=center class=td1 > ���(��Ԫ)</td>");
	sTemp.append("   <td width=8% align=center class=td1 > ��Ʊ�� </td>");
	sTemp.append("   <td width=10% align=center class=td1 > ������ </td>");
	sTemp.append("   <td width=15% align=center class=td1 > �������ʡ� </td>");
	sTemp.append("   <td colspan=4 align=center class=td1 > �ж����� </td>");
	sTemp.append("  </tr>");
	
	String sBillNo="";
	String sBillSum="";
	String sWriteDate="";
	String sMaturity="";
	String sAboutBankName="";
	String sRate="";
	
	ASResultSet rs2 = Sqlca.getResultSet("select BillNo,BillSum,"					
					+"WriteDate,Maturity,Rate,Acceptor "
					+"from BILL_INFO "
					+" where ObjectNo = '"+sObjectNo+"' "
					+" and ObjectType = 'CreditApply' "
					+" order by BillNo ");
	while(rs2.next())
	{
		sBillNo = rs2.getString("BillNo");
		if(sBillNo == null) sBillNo = "&nbsp;";
		
		sBillSum = DataConvert.toMoney(rs2.getDouble("BillSum")/10000);
		if(sBillSum == null) sBillSum = "&nbsp;";
		
		sWriteDate = rs2.getString("WriteDate");
		if(sWriteDate == null) sWriteDate = "&nbsp;";
		
		sMaturity = rs2.getString("Maturity");
		if(sMaturity == null) sMaturity = "&nbsp;";
		
		sRate = DataConvert.toMoney(rs2.getDouble("Rate"));
		if(sRate == null) sRate = "&nbsp;";
		
		
		sAboutBankName = rs2.getString("Acceptor");
		if(sAboutBankName == null) sAboutBankName ="&nbsp;";
		
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 > "+sBillNo+" </td>");
		sTemp.append("   <td width=18% align=right class=td1 > "+sBillSum+"</td>");
		sTemp.append("   <td width=8% align=left class=td1 > "+sWriteDate+" </td>");
		sTemp.append("   <td width=10% align=left class=td1 > "+sMaturity+" </td>");
		sTemp.append("   <td width=15% align=right class=td1 >"+sRate+" </td>");
		sTemp.append("   <td colspan=4 align=left class=td1 > "+sAboutBankName+" </td>");
		sTemp.append("  </tr>");
    }
    rs2.getStatement().close();
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=10 align=left class=td1 "+myShowTips(sMethod)+" ><p>1������ҵ��ó�ױ�����</p>");
  	sTemp.append("   2����Ʊ��ѯ���:");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
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
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ 
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

