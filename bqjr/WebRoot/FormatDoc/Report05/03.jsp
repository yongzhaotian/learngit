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
	String sCustomerName = "";			//����������
	String sBusinessType = "";			//ҵ��Ʒ��
	String sBusinessTypeName = "";		//����ҵ��Ʒ������
	String sBusinessSum = "";			//���
	String sCurrency = "";				//����
	String sBailRatio = "";				//��֤�������
	String sBusinessRate = "";			//����
	String sPdgRatio = "";				//��������
	String sClassifyResult = "";		//�弶����
	String sVouchType = "";				//������ʽ
	String sPurpose = "";				//�ʽ���;
						
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,BusinessType,getBusinessName(BusinessType)as BusinessTypeName,BusinessSum,"
						+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BailRatio,BusinessRate,PdgRatio, "
						+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
						+"getitemname('VouchType',VouchType) as VouchTypeName,purpose "
						+"from business_Apply where SerialNo='"+sObjectNo+"'");
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == null) sCurrency = " ";
		
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));

		sBusinessRate = rs2.getString("BusinessRate");
		if(sBusinessRate == null) sBusinessRate = "0.000000";
		
		sPdgRatio = DataConvert.toMoney(rs2.getDouble("PdgRatio"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == null) sVouchType = " ";
		
		sPurpose = rs2.getString("purpose");
		if(sPurpose == null) sPurpose = "  ";
	}
	rs2.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3��ҵ�������Ϣ</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("  <tr>");	
	sTemp.append(" <td width=15% align=center class=td1 >���������ƣ�</td>");
	sTemp.append(" <td colspan='5' align=left class=td1 >"+sCustomerName+"</td>");
	sTemp.append(" </tr>");
    
	sTemp.append("  <tr>");
	sTemp.append(" <td width=18% align=center class=td1 > ����ҵ��Ʒ��</td>");
	sTemp.append(" <td width=18% align=center class=td1 > ���� </td>");
	sTemp.append(" <td width=10% align=center class=td1 > ���� </td>");
	sTemp.append(" <td width=17% align=center class=td1 > ��֤�������</td>");
	sTemp.append(" <td width=15% align=center class=td1 > ����/���ʡ�</td>");
	sTemp.append(" <td width=20% align=center class=td1 > �弶���� </td>");
	sTemp.append("  </tr>");
    
	sTemp.append("  <tr>");
	sTemp.append(" <td width=18% align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	sTemp.append(" <td width=15% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
	sTemp.append(" <td width=10% align=center class=td1 >"+sCurrency+"&nbsp;</td>");
	sTemp.append(" <td width=20% align=center class=td1 >"+sBailRatio+"&nbsp;</td>");
    
	//����ҵ��ȡ�����ʣ�����ҵ��ȡ��������
	if(sBusinessType.substring(0,1).equals("1"))	//����ҵ��
		sTemp.append(" <td width=15% align=center class=td1 >"+sBusinessRate+"&nbsp;</td>");
	else if(sBusinessType.substring(0,1).equals("2"))	//����ҵ��
		sTemp.append(" <td width=15% align=center class=td1 >"+sPdgRatio+"&nbsp;</td>");
	else	//����ҵ��
		sTemp.append(" <td width=15% align=center class=td1 >0.00</td>");
	
	sTemp.append(" <td width=20% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
	sTemp.append("  </tr>");
	
	//��֤��
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��֤��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=18%  align=center class=td1 > �ʺ� </td>");
	sTemp.append("   <td width=8% align=center class=td1 >����</td>");
	sTemp.append("   <td width=15% align=center class=td1 > ���(��) </td>");
	sTemp.append("   <td width=10% align=center class=td1 > ��ʼ�� </td>");
	sTemp.append("   <td width=10% align=center class=td1 > ������ </td>");
	sTemp.append("   <td width=20% align=center class=td1 >��֤�����%</td>");
	sTemp.append("   </tr>");
	
	String sCONTRACTNO="";
	String sGUARANTYINFO="";
	String sGuarantyCurrencyName="";
	String sGUARANTYVALUE="";
	String sSql="";
	if(sBusinessType.substring(0,1).equals("1") || sBusinessType.substring(0,1).equals("9"))	//����ҵ��
	{
		sSql = " select CONTRACTNO,GUARANTYINFO,"+
			" getItemName('Currency',GuarantyCurrency) as GuarantyCurrencyName,GUARANTYVALUE "+
			" from GUARANTY_CONTRACT "+                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
			" where SerialNo in (select AR.ObjectNo from APPLY_RELATIVE AR "+
						" where  AR.SerialNo = '"+sObjectNo+"' "+
						"  and  AR.ObjectType='GUARANTY_CONTRACT' )"+
				" and GuarantyType = '010040' ";  //��֤��
		rs2 = Sqlca.getResultSet(sSql);
		while(rs2.next())
		{
			sCONTRACTNO = rs2.getString("CONTRACTNO");
			if(sCONTRACTNO == null) sCONTRACTNO = "&nbsp;";
			
			sGUARANTYVALUE = DataConvert.toMoney(rs2.getDouble("GUARANTYVALUE")/10000);
			if(sGUARANTYVALUE == null) sGUARANTYVALUE = "&nbsp;";
			
			sGUARANTYINFO = DataConvert.toMoney(rs2.getDouble("GUARANTYINFO"));
			if(sGUARANTYINFO == null) sGUARANTYINFO = "&nbsp;";
			
			sGuarantyCurrencyName = rs2.getString("GuarantyCurrencyName");
			if(sGuarantyCurrencyName == null) sGuarantyCurrencyName ="&nbsp;";
				
			sTemp.append("  <tr>");
			sTemp.append("   <td width=18%  align=left class=td1 >"+sCONTRACTNO+"&nbsp;</td>");
			sTemp.append("   <td width=8% align=left class=td1 >"+sGuarantyCurrencyName+"&nbsp;</td>");
			sTemp.append("   <td width=15% align=right class=td1 > "+sGUARANTYVALUE+"&nbsp;</td>");
			sTemp.append("   <td width=10% align=left class=td1 > &nbsp; </td>");
			sTemp.append("   <td width=10% align=left class=td1 > &nbsp; </td>");
			sTemp.append("   <td width=20% align=right class=td1 >"+sGUARANTYINFO+"</td>");
			sTemp.append("  </tr>");
	    }
	    rs2.getStatement().close();
	}
	else if(sBusinessType.substring(0,1).equals("2"))	//����ҵ��
	{
		sSql = " select BailAccount as CONTRACTNO,BailSum as GUARANTYVALUE,"+
			" getItemName('Currency',BailCurrency) as GuarantyCurrencyName,BailRatio as GUARANTYINFO "+
			" from business_Apply where SerialNo='"+sObjectNo+"' ";
		rs2 = Sqlca.getResultSet(sSql);
		while(rs2.next())
		{
			sCONTRACTNO = rs2.getString("CONTRACTNO");
			if(sCONTRACTNO == null) sCONTRACTNO = "&nbsp;";
			
			sGUARANTYVALUE = DataConvert.toMoney(rs2.getDouble("GUARANTYVALUE")/10000);
			if(sGUARANTYVALUE == null) sGUARANTYVALUE = "&nbsp;";
			
			sGUARANTYINFO = DataConvert.toMoney(rs2.getDouble("GUARANTYINFO"));
			if(sGUARANTYINFO == null) sGUARANTYINFO = "&nbsp;";
			
			sGuarantyCurrencyName = rs2.getString("GuarantyCurrencyName");
			if(sGuarantyCurrencyName == null) sGuarantyCurrencyName ="&nbsp;";
				
			sTemp.append("  <tr>");
			sTemp.append("   <td width=18%  align=left class=td1 >"+sCONTRACTNO+"&nbsp;</td>");
			sTemp.append("   <td width=8% align=left class=td1 >"+sGuarantyCurrencyName+"&nbsp;</td>");
			sTemp.append("   <td width=15% align=right class=td1 > "+sGUARANTYVALUE+"&nbsp;</td>");
			sTemp.append("   <td width=10% align=left class=td1 > &nbsp; </td>");
			sTemp.append("   <td width=10% align=left class=td1 > &nbsp; </td>");
			sTemp.append("   <td width=20% align=right class=td1 >"+sGUARANTYINFO+"</td>");
			sTemp.append("  </tr>");
	    }
	    rs2.getStatement().close();
	
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td width=18%  align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=8% align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td width=15% align=right class=td1 > &nbsp;</td>");
		sTemp.append("   <td width=10% align=left class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=10% align=left class=td1 > &nbsp; </td>");
		sTemp.append("   <td width=20% align=right class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	
	//���д浥
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���д浥</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=18%  align=center class=td1 > ƾ֤�� </td>");
	sTemp.append("   <td width=8% align=center class=td1 >����</td>");
	sTemp.append("   <td width=15% align=center class=td1 > ���(��) </td>");
	sTemp.append("   <td width=10% align=center class=td1 > ��ʼ�� </td>");
	sTemp.append("   <td width=10% align=center class=td1 > ������ </td>");
	sTemp.append("   <td width=20% align=center class=td1 >��Ѻ��%</td>");
	sTemp.append("   </tr>");
	
	String sGuarantyRightID="";
	String sBeginDate="";
	String sOwnerTime="";
	String sGuarantySubTypeName="";
	String sAboutSum1="";
	String sAboutSum2="";
	
	sSql = " select GuarantyID,GuarantyRightID,BeginDate,OwnerTime,"+
			" getItemName('Currency',GuarantySubType) as GuarantySubTypeName,AboutSum1 "+
			" from GUARANTY_INFO  "+                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
			" where GuarantyID in (select GR.GuarantyID from Guaranty_Relative GR "+
						" where  GR.ObjectNo = '"+sObjectNo+"' "+
						"  and  GR.ObjectType='CreditApply' )"+
				" and GuarantyType = '020010' ";  //��Ѻ�浥
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantyRightID = rs2.getString("GuarantyRightID");
		if(sGuarantyRightID == null) sGuarantyRightID = "&nbsp;";
		
		sAboutSum1 = DataConvert.toMoney(rs2.getDouble("AboutSum1")/10000);
		if(sAboutSum1 == null) sAboutSum1 = "&nbsp;";
		
		sBeginDate = rs2.getString("BeginDate");
		if(sBeginDate == null) sBeginDate = "&nbsp;";
		
		sOwnerTime = rs2.getString("OwnerTime");
		if(sOwnerTime == null) sOwnerTime = "&nbsp;";
		
		sGuarantySubTypeName = rs2.getString("GuarantySubTypeName");
		if(sGuarantySubTypeName == null) sGuarantySubTypeName ="&nbsp;";
		
		sTemp.append("  <tr>");
		sTemp.append("   <td width=18%  align=left class=td1 >"+sGuarantyRightID+" </td>");
		sTemp.append("   <td width=8% align=left class=td1 >"+sGuarantySubTypeName+"</td>");
		sTemp.append("   <td width=15% align=right class=td1 > "+sAboutSum1+" </td>");
		sTemp.append("   <td width=10% align=left class=td1 > "+sBeginDate+" </td>");
		sTemp.append("   <td width=10% align=left class=td1 > "+sOwnerTime+" </td>");
		sTemp.append("   <td width=20% align=right class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
    }
    rs2.getStatement().close();
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=10 align=left class=td1 "+myShowTips(sMethod)+" ><p>1������������;��</p>");
  	sTemp.append("   2������Ѻ����Ʒ�������:");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",sData[0][0]));
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

