<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/* Author:   djia  2009.10.22
	 * Tester:
	 * Content: ���ſͻ�����������ʽ������ĵ�0ҳ
	 * Input Param:
	 * 		���봫��Ĳ�����
	 * 			DocID:	  �ĵ�template
	 * 			ObjectNo��ҵ���
	 * 			SerialNo: ���鱨����ˮ��
	 * 		��ѡ�Ĳ�����
	 * 			Method:   ���� 1:display;2:save;3:preview;4:export
	 * 			FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
	 * Output param:
	 *      	 
	 * History Log: 
	 */	
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	String sCustomerID = "";
	String sRelaMaCustID = "";
	String sRelaChildCustID = "";
	String sSENTERPRISENAME = "";
	String sMaENTERPRISENAME = "";
	String sMaCORPID = "";
	String sMaFICTITIOUSPERSON = "";
	String sMaUnfinishedBusiness = "";
	String sManageOrgName = "";
	String sManageUserName = "";
	String sChildENTERPRISENAME = "";
	String sChildCORPID = "";
	String sChildFICTITIOUSPERSON = "";
	String sChildUnfinishedBusiness = "";
	String sChildManageOrgName = "";
	String sChildManageUserName = "";
	String listItem[];

	//���ĸ��˾���ӹ�˾���
    String sSql = "select CustomerID,RelaMaCustID,RelaChildCustID from group_result where SerialNo = '"+sObjectNo.substring(0,16)+"'";
	ASResultSet rss = Sqlca.getASResultSet(sSql);
	if(rss.next())
	{
		sCustomerID = rss.getString("CustomerID");
		sRelaMaCustID = rss.getString("RelaMaCustID");
		sRelaChildCustID = rss.getString("RelaChildCustID");
	}
	rss.getStatement().close();
	listItem = sRelaChildCustID.split("@");
	
	//���Դ��˾����
    String sSqls = "select ENTERPRISENAME from ENT_INFO where CUSTOMERID = '"+sCustomerID+"'";
	ASResultSet rss1 = Sqlca.getASResultSet(sSqls);
	if(rss1.next())
	{
		sSENTERPRISENAME = rss1.getString("ENTERPRISENAME");
		if( sSENTERPRISENAME==null) sSENTERPRISENAME= "";
	}
	rss1.getStatement().close();
	
	//����϶���ĸ��˾����
    //String sSql0 = "select ENTERPRISENAME,CORPID,FICTITIOUSPERSON from ENT_INFO where CUSTOMERID = '"+sCustomerID+"'";
    String sSql0 = "select CustomerID,ENTERPRISENAME,CORPID,FICTITIOUSPERSON,getItemName('HaveNot',getNotEndBusiness(CustomerID)) as UnfinishedBusiness,getManageOrgName(CustomerID) as ManageOrgName,  getManageUserName(CustomerID) as ManageUserName  from ENT_INFO where CUSTOMERID = '"+sRelaMaCustID+"'";
	ASResultSet rs0 = Sqlca.getASResultSet(sSql0);
	if(rs0.next())
	{
		sMaENTERPRISENAME = rs0.getString("ENTERPRISENAME");
		if( sMaENTERPRISENAME==null) sMaENTERPRISENAME= "";
		
		sMaCORPID = rs0.getString("CORPID");
		if( sMaCORPID==null) sMaCORPID= "";
		
		sMaFICTITIOUSPERSON = rs0.getString("FICTITIOUSPERSON");
		if( sMaFICTITIOUSPERSON==null) sMaFICTITIOUSPERSON= "";
		
		sMaUnfinishedBusiness = rs0.getString("UnfinishedBusiness");
		if( sMaUnfinishedBusiness==null) sMaUnfinishedBusiness= "";
		
		sManageOrgName = rs0.getString("ManageOrgName");
		if( sManageOrgName==null) sManageOrgName= "";
		
		sManageUserName = rs0.getString("ManageUserName");
		if( sManageUserName==null) sManageUserName= "";
	}
	rs0.getStatement().close();
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<style type=\"text/css\"> p.thicker {font-weight: 900} </style>");
	sTemp.append("	<form method='post' action='7502.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=center colspan=28 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>���ſͻ��϶�������<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 ><u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>:<br> &nbsp;&nbsp;&nbsp;&nbsp;����/���ڶ�&nbsp;'"+sSENTERPRISENAME+"'&nbsp;��������ǰ�ڵ���ʱ�������ռ�������Ϣ��ȷ���ÿͻ����м��Ź�ϵ�������ְ��ա��й�XX���з��˿ͻ��Ŵ������ֲᡷ�Ĺ涨��������ϱ������������±������϶��Ƿ��ռ��ſͻ��������Ź�������ϸ˵�������ϸ���</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 > <p class=\"thicker\"> �������� </p></td>");
		sTemp.append("   <td colspan=11 align=left class=td1 nowrap>&nbsp;</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=5% align=left class=td1 > <p class=\"thicker\"> ���ż�� </p> </td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=5% align=left class=td1 > <p class=\"thicker\"> �����ܲ���ĸ��˾�����ڵ� </p> </td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 > <p class=\"thicker\"> ĸ��˾��Ϣ </p> </td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> ��Ա��˾���� </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> ֤�����ͺ��� </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> ���������� </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> �Ƿ�������������δ����ҵ�񣨲����ͷ���ҵ��</p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> �ܻ����� </p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> �ܻ��ͻ����� </p> </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaENTERPRISENAME+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaCORPID+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaFICTITIOUSPERSON+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >"+sMaUnfinishedBusiness+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=left class=td1 >"+sManageOrgName+"&nbsp;</td>");
		sTemp.append("   <td width=10% align=left class=td1 >"+sManageUserName+"&nbsp;</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 > <p class=\"thicker\"> �ӹ�˾��Ա���� </p> </td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> ��Ա��˾���� </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> ֤�����ͺ��� </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> ���������� </p> </td>");
		sTemp.append("   <td width=20% align=left class=td1 > <p class=\"thicker\"> �Ƿ�������������δ����ҵ�񣨲����ͷ���ҵ��</p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> �ܻ����� </p> </td>");
		sTemp.append("   <td width=10% align=left class=td1 > <p class=\"thicker\"> �ܻ��ͻ����� </p> </td>");
		sTemp.append("   </tr>");
		
		
	for(int k=0; k<listItem.length; k++){
		String sSql2 = "select CustomerID,ENTERPRISENAME,CORPID,FICTITIOUSPERSON,getItemName('HaveNot',getNotEndBusiness(CustomerID)) as UnfinishedBusiness,getManageOrgName(CustomerID) as ManageOrgName,  getManageUserName(CustomerID) as ManageUserName from ENT_INFO where CUSTOMERID = '"+listItem[k]+"'";
		ASResultSet rs2 = Sqlca.getASResultSet(sSql2);
		if(rs2.next())
		{	
			sChildENTERPRISENAME = rs2.getString("ENTERPRISENAME");
			if( sChildENTERPRISENAME==null) sChildENTERPRISENAME= "";
			
			sChildCORPID = rs2.getString("CORPID");
			if( sChildCORPID==null) sChildCORPID= "";
			
			sChildFICTITIOUSPERSON = rs2.getString("FICTITIOUSPERSON");
			if( sChildFICTITIOUSPERSON==null) sChildFICTITIOUSPERSON= "";
			
			sChildUnfinishedBusiness = rs2.getString("UnfinishedBusiness");
			if( sChildUnfinishedBusiness==null) sChildUnfinishedBusiness= "";
			
			sChildManageOrgName = rs2.getString("ManageOrgName");
			if( sChildManageOrgName==null) sChildManageOrgName= "";
			
			sChildManageUserName = rs2.getString("ManageUserName");
			if( sChildManageUserName==null) sChildManageUserName= "";
		}
		rs2.getStatement().close();
	
		sTemp.append("   <tr>");		
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildENTERPRISENAME+"&nbsp;</td>");	
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildCORPID+"&nbsp;</td>");		
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildFICTITIOUSPERSON+"&nbsp;</td>");	
		sTemp.append("   <td width=20% align=left class=td1 >"+sChildUnfinishedBusiness+"&nbsp;</td>");	
		sTemp.append("   <td width=10% align=left class=td1 >"+sChildManageOrgName+"&nbsp;</td>");	
		sTemp.append("   <td width=10% align=left class=td1 >"+sChildManageUserName+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
		
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=12 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>���λ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> ��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</td>");
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
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");

	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

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

