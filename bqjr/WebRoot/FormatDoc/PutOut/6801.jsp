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
	
	String sSql = "select ContractSerialNo,getBusinessName(BusinessType) as BusinessTypeName,CustomerName,ContractSum,PutOutDate,Maturity,"+
				  " OpenBankName,OpenBankAdd,OpenBankZip,getItemName('CreditType1',PZType),Address3,getItemName('Type1',Type1),AboutBankID,AboutBankName,"+
				  " getItemName('Type1',Type2),AboutBankID2,AboutBankName2,getItemName('Type1',Type3),AboutBankID3,ThirdPartyAccounts,Name1,"+
				  " Address1,ThirdPartyID1,Name2,Address2,Zip2,BusinessSum,BailAccount,Term1,Term2,getItemName('CreditPayMethod',MFeePayMethod),TermDay,"+
				  " getItemName('IsAgree',Type4),getItemName('IsAgree',Type5),Type8,Type9,SecuritiesType,getItemName('SendType',Type6),getItemName('CostPerson',Type7),getOrgName(OperateOrgID)"+
				  " from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	
	String sContractSerialNo = "";
	String sBusinessTypeName = "";
	String sCustomerName = "";
	String sContractSum = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sOpenBankName = "";
	String sOpenBankAdd = "";
	String sOpenBankZip = "";
	String sPZType = "";
	String sAddress3 = "";
	String sType1 = "";
	String sAboutBankID = "";
	String sAboutBankName = "";
	String sType2 = "";
	String sAboutBankID2 = "";
	String sAboutBankName2 = "";
	String sType3 = "";
	String sAboutBankID3 = "";
	String sThirdPartyAccounts = "";
	String sName1 = "";
	String sAddress1 = "";
	String sThirdPartyID1 = "";
	String sName2 = "";
	String sAddress2 = "";
	String sZip2 = "";
	String sBusinessSum = "";
	String sBailAccount = "";
	String sTerm1 = "";
	String sTerm2 = "";
	String sMFeePayMethod = "";
	String sTermDay = "";
	String sType4 = "";
	String sType5 = "";
	String sType8 = "";
	String sType9 = "";
	String sSecuritiesType = "";
	String sType6 = "";
	String sType7 = "";
	String sOperateOrgID = "";
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6801.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if( sContractSerialNo==null) sContractSerialNo = "";
		
		sBusinessTypeName = rs2.getString(2);
		if( sBusinessTypeName==null) sBusinessTypeName = "";
		
		sCustomerName = rs2.getString(3);
		if( sCustomerName==null) sCustomerName = "";
		
		sContractSum = DataConvert.toMoney(rs2.getDouble(4));
		
		sPutOutDate = rs2.getString(5);
		if(sPutOutDate ==null) sPutOutDate = "";
		
		sMaturity = rs2.getString(6);
		if( sMaturity==null) sMaturity = "";
		
		sOpenBankName = rs2.getString(7);
		if( sOpenBankName ==null) sOpenBankName = "";
		
		sOpenBankAdd = rs2.getString(8);
		if( sOpenBankAdd==null) sOpenBankAdd = "";
		
		sOpenBankZip = rs2.getString(9);
		if( sOpenBankZip==null) sOpenBankZip = "";
		
		sPZType = rs2.getString(10);
		if( sPZType ==null) sPZType = "";
		
		sAddress3 = rs2.getString(11);
		if( sAddress3 ==null) sAddress3 = "";
		
		sType1 = rs2.getString(12);
		if( sType1==null) sType1= "";
		
		sAboutBankID = rs2.getString(13);
		if( sAboutBankID ==null) sAboutBankID = "";
		
		sAboutBankName = rs2.getString(14);
		if( sAboutBankName ==null) sAboutBankName = "";
		
		sType2 = rs2.getString(15);
		if( sType2 ==null) sType2 = "";
		
		sAboutBankID2 = rs2.getString(16);
		if( sAboutBankID2 ==null) sAboutBankID2 = "";
		
		sAboutBankName2 = rs2.getString(17);
		if( sAboutBankName2 ==null) sAboutBankName2 = "";
		
		sType3 = rs2.getString(18);
		if( sType3 ==null) sType3 = "";
		
		sAboutBankID3 = rs2.getString(19);
		if( sAboutBankID3 ==null) sAboutBankID3 = "";
		
		sThirdPartyAccounts = rs2.getString(20);
		if( sThirdPartyAccounts ==null) sThirdPartyAccounts = "";
		
		sName1 = rs2.getString(21);
		if( sName1 ==null) sName1 = "";
		
		sAddress1 = rs2.getString(22);
		if( sAddress1 ==null) sAddress1 = "";
		
		sThirdPartyID1 = rs2.getString(23);
		if( sThirdPartyID1 ==null) sThirdPartyID1 = "";
		
		sName2 = rs2.getString(24);
		if( sName2 ==null) sName2 = "";
		
		sAddress2 = rs2.getString(25);
		if( sAddress2 ==null) sAddress2 = "";
		
		sZip2 = rs2.getString(26);
		if( sZip2 ==null) sZip2 = "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(27));
		
		sBailAccount = rs2.getString(28);
		if( sBailAccount ==null) sBailAccount = "";
		
		sTerm1 = rs2.getString(29);
		if( sTerm1 ==null) sTerm1 = "";
		
		sTerm2 = rs2.getString(30);
		if( sTerm2 ==null) sTerm2 = "";
		
		sMFeePayMethod = rs2.getString(31);
		if( sMFeePayMethod ==null) sMFeePayMethod = "";
		
		sTermDay = rs2.getString(32);
		if( sTermDay ==null) sTermDay = "";
		
		sType4 = rs2.getString(33);
		if( sType4 ==null) sType4 = "";
		
		sType5 = rs2.getString(34);
		if( sType5 ==null) sType5 = "";
		
		sType8 = rs2.getString(35);
		if( sType8 ==null) sType8 = "";
		
		sType9 = rs2.getString(36);
		if( sType9 ==null) sType9 = "";
		
		sSecuritiesType = rs2.getString(37);
		if( sSecuritiesType ==null) sSecuritiesType = "";
		
		sType6 = rs2.getString(38);
		if( sType6==null) sType6 = "";
		
		sType7 = rs2.getString(39);
		if( sType7==null) sType7="";
		
		sOperateOrgID = rs2.getString(40);	
		if( sOperateOrgID==null) sOperateOrgID="";
		
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
		sTemp.append("   <td width=20% align=left class=td1 > ��ͬ��ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sContractSerialNo+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=left class=td1 >������ˮ��</td>");
		sTemp.append("   <td width=30% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�ͻ�����</td>");
		sTemp.append("   <td align=left class=td1 nowrap>"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��ͬ��Ԫ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sContractSum+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >ҵ������</td>");
		sTemp.append("   <td align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����֤��Ч��</td>");
		sTemp.append("   <td align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��֤������</td>");
		sTemp.append("   <td align=left class=td1 >"+sOpenBankName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤�е�ַ</td>");
		sTemp.append("   <td align=left class=td1 >"+sOpenBankAdd+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��֤���ʱ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sOpenBankZip+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����֤����</td>");
		sTemp.append("   <td align=left class=td1 >"+sPZType+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >����֤��Ч��</td>");
		sTemp.append("   <td align=left class=td1 >"+sAddress3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >֪ͨ�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sType1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >֪ͨ���к�</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >֪ͨ������</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankName+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���������</td>");
		sTemp.append("   <td align=left class=td1 >"+sType2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�������к�</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankID2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >����������</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankName2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�鸶�����</td>");
		sTemp.append("   <td align=left class=td1 >"+sType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�鸶���к�</td>");
		sTemp.append("   <td align=left class=td1 >"+sAboutBankID3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤�������˺�</td>");
		sTemp.append("   <td align=left class=td1 >"+sThirdPartyAccounts+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >��֤����������</td>");
		sTemp.append("   <td align=left class=td1 >"+sName1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤�����˵�ַ</td>");
		sTemp.append("   <td align=left class=td1 >"+sAddress1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�������˺�</td>");
		sTemp.append("   <td align=left class=td1 >"+sThirdPartyID1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >����������</td>");
		sTemp.append("   <td align=left class=td1 >"+sName2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >�����˵�ַ</td>");
		sTemp.append("   <td align=left class=td1 >"+sAddress2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >�������ʱ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sZip2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���׽��</td>");
		sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��֤���˺�</td>");
		sTemp.append("   <td align=left class=td1 >"+sBailAccount+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >����װ����</td>");
		sTemp.append("   <td align=left class=td1 >"+sTerm1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >������</td>");
		sTemp.append("   <td align=left class=td1 >"+sTerm2+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sMFeePayMethod+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��������(��)</td>");
		sTemp.append("   <td align=left class=td1 >"+sTermDay+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >����װ��</td>");
		sTemp.append("   <td align=left class=td1 >"+sType4+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >ת��</td>");
		sTemp.append("   <td align=left class=td1 >"+sType5+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >װ�˵�</td>");
		sTemp.append("   <td align=left class=td1 >"+sType8+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >��������Ŀ�ĵ�</td>");
		sTemp.append("   <td align=left class=td1 >"+sType9+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���䷽ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sSecuritiesType+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 >���ͷ�ʽ</td>");
		sTemp.append("   <td align=left class=td1 >"+sType6+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >���óе���</td>");
		sTemp.append("   <td align=left class=td1 >"+sType7+"&nbsp;</td>");
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

