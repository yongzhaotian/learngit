<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
	
	String sSql = " select ContractSerialNo,CustomerID,CustomerName,BailAccount,"+
				  " getItemName('GuaranteeType',VouchType) as VouchType,getItemName('KeapOrder',CorpusPayMethod),"+
				  " SecondPayAccount,BusinessSum,PutOutDate,Maturity,getBusinessName(BusinessType) as BusinessTypeName,getOrgName(OperateOrgID),SerialNo,DuebillSerialNo "+
				  " from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	String sContractSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBailAccount = "";
	String sVouchType = "";
	String sCorpusPayMethod = "";
	String sSecondPayAccount = "";
	String sBusinessSum = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sBusinessTypeName = "";
	String sOperateOrgID = "";
	String sSerialNo1 = "";
	String sGatheringName = "";
	String sAccountNo = "";
	String sAboutBankName = "";
	String sBillSum = "";
	String sUserName = "";
	String sOrgName = "";
	String sDuebillSerialNo = "";
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='8315.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo= "";
		
		sCustomerID = rs2.getString(2);
		if( sCustomerID==null) sCustomerID= "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName= "";
		
		sBailAccount = rs2.getString(4);
		if(sBailAccount ==null) sBailAccount= "";
		
		sVouchType = rs2.getString(5);
		if(sVouchType ==null) sVouchType= "";
		
		sCorpusPayMethod = rs2.getString(6);
		if(sCorpusPayMethod ==null) sCorpusPayMethod= "";
		
		sSecondPayAccount = rs2.getString(7);
		if(sSecondPayAccount ==null) sSecondPayAccount= "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(8));
		
		sPutOutDate = rs2.getString(9);
		if(sPutOutDate ==null) sPutOutDate= "";
		
		sMaturity = rs2.getString(10);
		if( sMaturity==null) sMaturity= "";
		
		sBusinessTypeName = rs2.getString(11);
		
		sOperateOrgID = rs2.getString(12);
		
		sSerialNo1 = rs2.getString(13);
		
		sDuebillSerialNo = rs2.getString(14);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
		sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>�ſ�֪ͨ��<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgID+"&nbsp;&nbsp;</u>֧�У�������Ʋ��ţ� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>�������ˣ�������ҵ��:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ�������ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰������������	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=24% align=left class=td1 > �ж�Э����ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >������ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ͻ���</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >"+sCustomerID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ͻ�����</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 nowrap>"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤���ʺ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sBailAccount+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		/*
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤���ڿۿ�˳��</td>");
		sTemp.append("   <td align=left class=td1 >"+sCorpusPayMethod+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		*/
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤��ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sVouchType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��Ʊ�ܽ��(Ԫ)</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ǩ������</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��������</td>");
		sTemp.append("   <td align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 > �ſ���������ǩ�֣� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4 class=td1 ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>�ſ�ר���£�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> ���ڣ�"+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >����֪ͨ�鹲���������ͻ�������ƺ��ĵ�����Ա��һ�ݣ�</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
		sTemp.append("   </tr>");
	  sSql = "select GatheringName,AccountNo,AboutBankName,BillSum,"+
	   		   "getUserName(inputuserid),getOrgName(inputorgid) from bill_info "+
			     "where objectno in (select CONTRACTSERIALNO from BUSINESS_PUTOUT where serialno = '"+sSerialNo1+"')";
		ASResultSet rs3 = Sqlca.getResultSet(sSql);
		while(rs3.next())
		{
						
			sBillSum = DataConvert.toMoney(rs3.getDouble(5));
			
			sGatheringName = rs3.getString(2);
			if(sGatheringName == null) sGatheringName = "";
			
			sAccountNo = rs3.getString(3);
			if(sAccountNo == null) sAccountNo = "";
			
			sAboutBankName = rs3.getString(4);
			if(sAboutBankName == null) sAboutBankName = "";
			
			sUserName = rs3.getString(6);
			if(sUserName == null) sUserName = "";
			
			sOrgName = rs3.getString(7);
			if(sOrgName == null) sOrgName = "";
				
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left class=td1 >�տ��˻���</td>");
			sTemp.append("   <td align=left class=td1 nowrap>"+sGatheringName+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >�տ����ʺ�</td>");
			sTemp.append("   <td align=left class=td1 >"+sAccountNo+"&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left class=td1 >�տ�������</td>");
			sTemp.append("   <td align=left class=td1 >"+sAboutBankName+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >���(Ԫ)</td>");
			sTemp.append("   <td align=left class=td1 >"+sBillSum+"&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left class=td1 >�Ǽ���</td>");
			sTemp.append("   <td align=left class=td1 >"+sUserName+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >�Ǽǻ���</td>");
			sTemp.append("   <td align=left class=td1 >"+sOrgName+"&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=4 align=center class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
			sTemp.append("   </tr>");
    }
    rs3.getStatement().close();	
		sTemp.append("</table>");	
	    	
	}
	
	rs2.getStatement().close();	
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

