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
	String sDate = StringFunction.getToday();
	String sYear = sDate.substring(0,4);
	int iYear = Integer.parseInt(sYear);
	String sYearN = String.valueOf(iYear - 1)+"/12";
	String sYearN_1 = String.valueOf(iYear - 2)+"/12";
	String sYearN_2 = String.valueOf(iYear - 3)+"/12";
	String sRowName[] = {"914","915","916","911"};
	String sCol2Value[]={"","","",""};
	String sCol2Value1[]={"","","",""};
	String sCol2Value2[]={"","","",""};
	
	String sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"+
				  " where objectno = '"+sCustomerID+"' and ModelNo like '%9' and reportdate = '"+sYearN+"' and reportscope in (select min(reportscope) from REPORT_RECORD where objectno = '"+sCustomerID+"' and reportdate = '"+sYearN+"'))";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName[0])) sCol2Value[0]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[1])) sCol2Value[1]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[2])) sCol2Value[2]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[3])) sCol2Value[3]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();	
	
	sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"+
		   " where objectno = '"+sCustomerID+"' and ModelNo like '%9' and reportdate = '"+sYearN_1+"'  and reportscope in (select min(reportscope) from REPORT_RECORD where objectno = '"+sCustomerID+"' and reportdate = '"+sYearN_1+"'))";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName[0])) sCol2Value1[0]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[1])) sCol2Value1[1]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[2])) sCol2Value1[2]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[3])) sCol2Value1[3]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();
	
	sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"+
		   " where objectno = '"+sCustomerID+"' and ModelNo like '%9' and reportdate = '"+sYearN_2+"' and reportscope in (select min(reportscope) from REPORT_RECORD where objectno = '"+sCustomerID+"' and reportdate = '"+sYearN_2+"'))";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName[0])) sCol2Value2[0]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[1])) sCol2Value2[1]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[2])) sCol2Value2[2]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[3])) sCol2Value2[3]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0506.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.6����ծ��������</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% height='34' align=center class=td1 >��Ŀ</td>");
	sTemp.append("   <td width=25% align=center class=td1 >"+(iYear-1)+"��</td>");
	sTemp.append("   <td width=25% align=center class=td1 >"+(iYear-2)+"��</td>");
	sTemp.append("   <td width=25% align=center class=td1 >"+(iYear-3)+"��</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >Ϣ˰ǰ������Ϣ���ϱ���</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[0]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[0]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >�������� (%)</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[1]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[1]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[1]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >�ٶ����� (%)</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[2]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[2]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >�ʲ���ծ�� (%)</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[3]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[3]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" > ������ <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
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