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

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//�жϸñ����Ƿ����
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}

	String sBCSerialNo = "";		//�����ͬ���
	String sBusinessTypeName = "";	//ҵ��Ʒ��
	String sCurrency = "";			//����
	String sBusinessSum = "";		//������
	String sBalance = "";			//�������
	String sGuarantyName = "";		//����������
	String sGuarantyType = "";		//����������
	String sGuarantyAmount= "";		//����������
	String sEvalNetValue = "";		//������ֵ
	String sEvalDate = "";			//����ʱ��
	String sSumEval = "";			//��������
	String sOwnerName = "";			//Ȩ��������
	String sGuarantyRightID = "";	//Ȩ֤��
	String sInsureCertNo = "";		//��Ѻ�ﱣ�յ����

	sSql =  " select BC.SerialNo,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
			" getItemName('Currency',BC.BusinessCurrency) as Currency, "+
			" BC.BusinessSum,BC.Balance,GI.GUARANTYNAME,getItemName('GuarantyList',GI.GuarantyType) as GuarantyType, "+
			" GI.GuarantyAmount,GI.EvalNetValue,GI.EvalDate,BC.BusinessSum/GI.EvalNetValue as SumEval,GI.OWNERNAME, "+
			" GI.GUARANTYRIGHTID,GI.InsureCertNo "+
			" from GUARANTY_INFO GI,GUARANTY_RELATIVE GR,GUARANTY_CONTRACT GC,BUSINESS_CONTRACT BC "+
			" where GR.ObjectType = 'BusinessContract' "+
			" and GR.ObjectNo = BC.SerialNo "+
			" and GR.ContractNo = GC.SerialNo "+
			" and GI.GuarantyID = GR.GuarantyID "+
			" and GC.ContractStatus = '020' "+
			" and GC.CustomerID = '"+sObjectNo+"' ";
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<% 
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��¼��������Ѻ����Ϣ</font></td>"); 	
	sTemp.append("   </tr>");	
	
   	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sBCSerialNo =(String)rs.getString(1);
		if(sBCSerialNo == null) sBCSerialNo = " ";

		sBusinessTypeName =(String)rs.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName = " "; 

		sCurrency =(String)rs.getString(3);
		if(sCurrency == null) sCurrency = " ";

		sBusinessSum =DataConvert.toMoney(rs.getDouble(4));

		sBalance =DataConvert.toMoney(rs.getDouble(5));

		sGuarantyName =(String)rs.getString(6);
		if(sGuarantyName == null) sGuarantyName = " ";

		sGuarantyType =(String)rs.getString(7);
		if(sGuarantyType == null) sGuarantyType = " ";

		sGuarantyAmount =DataConvert.toMoney(rs.getDouble(8));

		sEvalNetValue =DataConvert.toMoney(rs.getDouble(9));
		
		sEvalDate =(String)rs.getString(10);
		if(sEvalDate == null) sEvalDate = " ";

		sSumEval =DataConvert.toMoney(rs.getDouble(11));

		sOwnerName =(String)rs.getString(12);
		if(sOwnerName == null) sOwnerName = " ";

		sGuarantyRightID =(String)rs.getString(13);
		if(sGuarantyRightID == null) sGuarantyRightID = " ";

		sInsureCertNo =(String)rs.getString(14);
		if(sInsureCertNo == null) sInsureCertNo = " ";
		
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >��ͬ��� </td>");
	    sTemp.append("   <td align=center class=td1 >"+sBCSerialNo+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >ҵ��Ʒ��</td>");
	    sTemp.append("   <td align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >���� </td>");
	    sTemp.append("   <td align=center class=td1 >"+sCurrency+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >��ͬ���</td>");
	    sTemp.append("   <td align=right class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >��ͬ���</td>");
	    sTemp.append("   <td align=right class=td1 >"+sBalance+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >����������</td>");
	    sTemp.append("   <td align=center class=td1 >"+sGuarantyName+"&nbsp;</td>");
	   	sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=22% align=center class=td1 >���������� </td>");
	    sTemp.append("   <td align=center class=td1 >"+sGuarantyType+"&nbsp;</td>");
	    sTemp.append("   <td width=22% align=center class=td1 >����������</td>");
	    sTemp.append("   <td align=right class=td1 >"+sGuarantyAmount+"&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >������ֵ</td>");
		sTemp.append("   <td align=right class=td1 >"+sEvalNetValue+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >����ʱ��</td>");
		sTemp.append("   <td align=center class=td1 >"+sEvalDate+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >��������</td>");
		sTemp.append("   <td align=right class=td1 >"+sSumEval+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >Ȩ��������</td>");
		sTemp.append("   <td align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >Ȩ֤��</td>");
		sTemp.append("   <td align=center class=td1 >"+sGuarantyRightID+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >��Ѻ�ﱣ�յ����</td>");
		sTemp.append("   <td align=center class=td1 >"+sInsureCertNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa >&nbsp;</td>");
	   	sTemp.append("   </tr>");
	}
	rs.getStatement().close();
	
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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

