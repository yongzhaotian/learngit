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
	String sReportScopeName = "";	//����ھ�
	String sAuditFlag = "";			//�����Ƿ��Ѿ������
	String sAuditOffice = "";		//�������������
	String sAuditOpinion = "";		//������
	String sReportDate = "";		//���һ�ڽ�ֹ����
	
	String sSql = "select getItemName('ReportScope',ReportScope) as ReportScopeName,"+
				  "getItemName('Y/N',AuditFlag) as AuditFlag,AuditOffice,AuditOpinion,ReportDate "+
				  "from CUSTOMER_FSRECORD where CustomerID = '"+sCustomerID+"' order by ReportDate DESC";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sReportScopeName = rs2.getString("ReportScopeName");
		if(sReportScopeName == null) sReportScopeName = " ";
		
		sAuditFlag = rs2.getString("AuditFlag");
		if(sAuditFlag == null) sAuditFlag = " ";
		
		sAuditOffice = rs2.getString("AuditOffice");
		if(sAuditOffice == null) sAuditOffice = " ";
		
		sAuditOpinion = rs2.getString("AuditOpinion");
		if(sAuditOpinion == null) sAuditOpinion = " ";
		
		sReportDate = rs2.getString("ReportDate");
		if(sReportDate == null) sReportDate = " ";
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0501.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5�������˲������</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.1�����񱨱�˵��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=center class=td1 > ����ھ� </td>");
	sTemp.append("   <td width=75% colspan='6' align=center class=td1 >"+sReportScopeName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=center class=td1 > �����Ƿ��Ѿ������</td>");
	sTemp.append("   <td width=25% colspan=2 align=left class=td1 >"+sAuditFlag+"&nbsp;</td>");
	sTemp.append("   <td width=25% colspan=2 align=center class=td1 > ������������� </td>");
	sTemp.append("   <td width=25% colspan=2 align=left class=td1 >"+sAuditOffice+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=center class=td1 > ������</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sAuditOpinion+"&nbsp;</td>");
	sTemp.append("   <td colspan=2 align=center class=td1 > ���һ�ڽ�ֹ���� </td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sReportDate+"&nbsp;</td>");
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