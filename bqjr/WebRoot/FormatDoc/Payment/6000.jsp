<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   smiao 2011.06.02
		Tester:
		Content: ����ĵ�0ҳ
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

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//��õ��鱨������
	//String sSql2 = "select SerialNo,CustomerName,getOrgName(OperateOrgID) from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";

	
	
	
	String sSql10 =  "select PutoutSerialNo,getItemName('Currency',Currency),PaymentSum,CapitalUse from PAYMENT_INFO  where SerialNo = '"+sObjectNo+"'";
	
	String sContractSerialNo = "";
	String sBCSerialNo = "";
	String sCustomerName = "";
	String sOperateOrgID = "";
	String sPutoutSerialNo = "";

	String sCurrency = "";
	double PaymentSum = 0;
	String sCapitalUse = "";
	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6000.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	

	ASResultSet rs1 = Sqlca.getResultSet(sSql10);

	if(rs1.next()){
		sPutoutSerialNo = rs1.getString(1);
		if(sPutoutSerialNo == null) sPutoutSerialNo = "";
		
		sCurrency = rs1.getString(2);
		if(sCurrency == null) sCurrency = "";
		
		PaymentSum = rs1.getDouble(3);
		
		sCapitalUse = rs1.getString(4);
		if(sCapitalUse == null) sCapitalUse = "";
		
	}
	
	rs1.getStatement().close();
	
	String sSql20 = "select ContractSerialNo,getItemName('Currency',BusinessCurrency) as BusinessCurrency ,BusinessSum,Purpose from BUSINESS_PUTOUT where SerialNo = '"+sPutoutSerialNo+"'";
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql20);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if(sContractSerialNo == null) sContractSerialNo = "";
	}
	rs2.getStatement().close();
	
	String sSql30 = "select SerialNo,CustomerName,getOrgName(OperateOrgID) from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"'";
	ASResultSet rs3 = Sqlca.getResultSet(sSql30);
	if(rs3.next()){
		sBCSerialNo = rs3.getString(1);
		if(sBCSerialNo == null) sBCSerialNo = "";
		
		sCustomerName = rs3.getString(2);
		if(sCustomerName == null) sCustomerName = "";
		
		sOperateOrgID = rs3.getString(3);
		if(sOperateOrgID == null) sOperateOrgID = "";
	}
	rs3.getStatement().close();
	
	
		
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");		
		sTemp.append("   <tr>");
		//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
		sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>����֧������������<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > �����ˣ�ί���ˡ��׷�����<u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u> </td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > �����ˣ����з����ҷ�����<u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u> </td>");
		sTemp.append("   </tr>");		
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > &nbsp;&nbsp;&nbsp;&nbsp;���ڼ׷����ҷ�ǩ���ı��Ϊ<u>&nbsp;&nbsp;"+sBCSerialNo+"&nbsp;&nbsp;</u>������ͬ���׷�����֧�������֣�<u>&nbsp;&nbsp;"+sCurrency+"&nbsp;&nbsp;</u>����д��<u>&nbsp;&nbsp;"+StringFunction.numberToChinese(PaymentSum)+"&nbsp;&nbsp;</u>����<u>&nbsp;&nbsp;"+sCapitalUse+"&nbsp;&nbsp;</u>��<br>&nbsp;&nbsp;&nbsp;&nbsp;�׷����ɳ�����ί���ҷ����ñ��Ŵ��ʽ��������֧����ϸ���Զ���֧������������ñ��ÿ���������в��ϸ��ڱ�������֮���ҷ���ˣ��׷���ŵ�����Ŵ��ʽ����������ί���ҷ�����֧����;�⣬���������κ���ʽ����֧ȡ������ת��֧�������򽫹��ɼ׷��Խ���ͬ��ΥԼ���ҷ���Ȩ���ݽ���ͬ��Լ��Ҫ��׷��е���Ӧ��ΥԼ���Ρ�   </td>");
		sTemp.append("   </tr>");		

		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >�����ˣ�ί���ˣ����Ӹ�Ԥ��ӡ���� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>�ſ�ר���£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> "+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		
		
		
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ͻ��������</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >           &nbsp;�ͻ�����         ��           ��          ��</td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���Ÿ��������</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >           &nbsp;��   ��  �ˣ�           ��           ��          ��</td>");
		sTemp.append("   </tr>");
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�����г����</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >           &nbsp;�����г���           ��          ��          ��</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >��ע��������������һʽ��������һ��Ӫҵ�������棬�ڶ���Ӫ���������档��</td>");
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

