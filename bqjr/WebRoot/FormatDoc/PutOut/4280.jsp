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
	String sSql = "select ContractSerialNo,CustomerID,CustomerName,getBusinessName(BusinessType) as BusinessTypeName,"+
				  " BusinessSubType,getitemname('Currency',BusinessCurrency) as BusinessCurrency,BusinessSum,PutOutDate,Maturity, "+
				  " getItemName('BHVouchType',VouchType) as VouchTypeName,BillNo,Purpose,FZANBalance,AboutBankName2,"+
				  " getitemname('Currency',BailCurrency) as BailCurrency,BailRatio,BailAccount,OperateOrgID ,PdgSum,getOrgName(OperateOrgID) as OperateOrgName, "+
				   " getitemname('ChargeTypeBH',PdgPayMethod) as PdgPayMethod"+
				  " from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	
	String sContractSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessSubType = "";
	String sBusinessCurrency = "";
	String sBusinessSum = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sVouchTypeName = "";
	String sBillNo = "";
	String sPurpose = "";
	String sFZANBalance = "";
	String sAboutBankName2 = "";
	String sBailCurrency = "";
	String sBailRatio = "";
	String sBailAccount = "";
	String sOperateOrgID = "";
	String sPdgSum = "";
	String sOperateOrgName ="";

	String sSql1 ="",sSql3="";
	String sAKEHHAO ="",sAKEHZWM="";
	ASResultSet rs1 = null;
	ASResultSet rs4 = null;
	ASResultSet rs7 = null;
	String ssSreialNo="";
	String sPdgPayMethod="";

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='A002.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo = "";
		
		sCustomerID = rs2.getString(2);
		if( sCustomerID==null) sCustomerID = "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName = "";
		
		sBusinessTypeName = rs2.getString(4);
		if( sBusinessTypeName==null) sBusinessTypeName = "";
		
		sBusinessSubType = rs2.getString(5);
		if(sBusinessSubType == null) sBusinessSubType = "";
		
		sBusinessCurrency = rs2.getString(6);
		if( sBusinessCurrency==null) sBusinessCurrency = "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(7));
		
		sPutOutDate = rs2.getString(8);
		if(sPutOutDate ==null) sPutOutDate = "";
		
		sMaturity = rs2.getString(9);
		if( sMaturity==null) sMaturity = "";
		
		sVouchTypeName = rs2.getString(10);
		if( sVouchTypeName==null) sVouchTypeName = "";
		
		sBillNo = rs2.getString(11);
		if( sBillNo==null) sBillNo = "";
		
		sPurpose = rs2.getString("Purpose");
		if( sPurpose==null) sPurpose = "";
		
		sFZANBalance = DataConvert.toMoney(rs2.getDouble(13));
		
		sAboutBankName2 = rs2.getString(14);
		if( sAboutBankName2==null) sAboutBankName2 = "";
		
		
		sOperateOrgID = rs2.getString(19);
		if(sOperateOrgID == null) sOperateOrgID = "";
		
		sPdgSum = DataConvert.toMoney(rs2.getDouble("PdgSum"));
		
		sOperateOrgName = rs2.getString("OperateOrgName");
		if(sOperateOrgName == null) sOperateOrgName = "";
		
		sPdgPayMethod = rs2.getString("PdgPayMethod");
		if(sPdgPayMethod == null) sPdgPayMethod = "";
		
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
		sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br>�ſ�֪ͨ��<br>&nbsp;</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 > <u>&nbsp;&nbsp;"+sOperateOrgName+"&nbsp;&nbsp;</u>֧�У�������Ʋ��ţ� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><u>&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;</u>�������ˣ�������ҵ��:<u>&nbsp;&nbsp;"+sBusinessTypeName+"&nbsp;&nbsp;</u><br>�Ѿ�������ҵ���������򱨾���Ȩ����������ͬ�⣬��ͨ���ſ�������ˣ����㲿���ձ�֪ͨ��Ҫ�󣬰������������	   </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");		
		sTemp.append("   <tr>");
		sTemp.append("   <td width=20% align=left class=td1 > ��ͬ��ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >������ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ͻ���</td>");
		sTemp.append("   <td align=left class=td1 >"+sCustomerID+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�ͻ�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��������</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�������</td>");
		sTemp.append("   <td align=left class=td1 >"+sBillNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ҵ�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessCurrency+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ҫ��������ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >������</td>");
		sTemp.append("   <td align=left class=td1 >"+sPdgSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�շѷ�ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sPdgPayMethod+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�������</td>");
		sTemp.append("   <td align=left class=td1 >"+sOperateOrgName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��Ч����</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >ʧЧ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����������Ҫ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sPurpose+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��������(��)</td>");
		sTemp.append("   <td align=left class=td1 >"+sFZANBalance+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����������</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankName2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <tr>");
		
		sSql1=" select CONTRACTNO,getitemname('Currency',GuarantyCurrency) as GuarantyCurrency,GUARANTYINFO "+
		  	 " from GUARANTY_CONTRACT  where ContractStatus <>'030' and SerialNo in"+ 
			 " (Select ObjectNo from CONTRACT_RELATIVE where SerialNo='"+sContractSerialNo+"'"+
			 " and ObjectType='GuarantyContract') and GuarantyType = '010040'";
		rs1=Sqlca.getResultSet(sSql1);
		while(rs1.next())
		{	
			sBailAccount = rs1.getString(1);
			if( sBailAccount==null) sBailAccount = "";
			sBailCurrency = rs1.getString(2);
			if( sBailCurrency==null) sBailCurrency = "";
			sBailRatio = rs1.getString(3);
			if( sBailRatio==null) sBailRatio="0.0";

			if(sBailRatio.equals("0.0"))
			{
				double dBailRatio=0.00;
				sSql =  " select AssureScale from GUARANTY_CONTRACT  where GuarantyType = '010040'"+
				        " and SerialNo in (Select ObjectNo from CONTRACT_RELATIVE where SerialNo='"+ssSreialNo+"'"+
						" and ObjectType='GUARANTY_CONTRACT') ";
			    rs7 = Sqlca.getResultSet(sSql);
				while(rs7.next())
				{
					dBailRatio +=rs7.getDouble("AssureScale");
				}
				rs7.getStatement().close();

				NumberFormat nf = NumberFormat.getInstance();
				nf.setMinimumFractionDigits(2);
				nf.setMaximumFractionDigits(2);
				sBailRatio = nf.format(dBailRatio);
			}
			
			sTemp.append("   <tr>");
			sTemp.append("   <td width=20% align=left class=td1 >��֤���ʺ�</td>");
			sTemp.append("   <td width=20% align=left class=td1 >"+sBailAccount+"&nbsp;</td>");
			sTemp.append("   <td width=15% align=left class=td1 >��֤�����</td>");
			sTemp.append("   <td width=15% align=left class=td1 >"+sBailCurrency+"&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td width=15% align=left class=td1 >��֤�����(%)</td>");
			sTemp.append("   <td width=15% align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");		
		}
		rs1.getStatement().close();
		
		sSql3 = " select GC.GuarantorID, GC.GuarantorName from Guaranty_Contract GC,Contract_Relative CR "+
		   " where CR.ObjectNo=GC.SerialNo "+
		   " and GC.ContractStatus <>'030' and GC.Guarantytype in ('010010','010020','010030') and CR.ObjectType = 'GuarantyContract'"+
		   " and CR.SerialNo = '"+sContractSerialNo+"'"+
		   " and GC.Guarantorid<>' ' and GC.Guarantorid is not null ";
		rs4 = Sqlca.getASResultSet(sSql3);
		while(rs4.next())
		{
			sAKEHHAO = rs4.getString("GuarantorID");    //�ͻ���
			if(sAKEHHAO==null) sAKEHHAO="";
			sAKEHZWM = rs4.getString("GuarantorName");  //�ͻ�����
			if(sAKEHZWM==null) sAKEHZWM="";

			sTemp.append("   <tr>");
			sTemp.append("   <td align=left class=td1 >�����ͻ����</td>");
			sTemp.append("   <td align=left class=td1 >"+sAKEHHAO+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >�����ͻ�����</td>");
			sTemp.append("   <td align=left class=td1 >"+sAKEHZWM+"&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		rs4.getStatement().close();

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

