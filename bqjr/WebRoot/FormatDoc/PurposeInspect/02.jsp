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

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//�жϸñ����Ƿ����
	String sSql="select FinishDate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("FinishDate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[0][0] = "true";
	}
	else
	{
		sButtons[1][0] = "true";
	}
	
	sSql =  "select getBusinessName(BusinessType) as BusinessType,"+
			" getItemname('OccurType',OccurType) as OccurType,"+
			" getItemname('Currency',BusinessCurrency) as bc,"+
			" ArtificialNo, BusinessSum, Balance,BusinessRate,PutOutDate,Maturity,"+
			" getItemname('VouchType',VouchType) as VouchType,"+
			" RiskRate,getItemname('ClassifyResult',ClassifyResult) as ClassifyResult,"+
			" getUserName(OperateUserID) as username,"+
			" getOrgName(OperateOrgID)as orgname"+
			" from BUSINESS_CONTRACT" +
			" where SerialNo='"+sObjectNo+"'";
	String sBusinessType = "";
	String sOccurType = "";
	String sCurrency = "";
	String sArtificialNo = "";
	String sBusinessSum = "";
	String sBalance = "";
	String sBusinessRate = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sVouchType = "";
	String sRiskRate = "";
	String sClassifyResult = "";
	String sUserName = "";
	String sOrgName = "";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sBusinessType = rs.getString(1);
		if(sBusinessType == null) sBusinessType = "";
		
		sOccurType = rs.getString(2);
		if(sOccurType == null) sOccurType = "";
		
		sCurrency = rs.getString(3);
		if(sCurrency == null) sCurrency = "";
		
		sArtificialNo = rs.getString(4);
		if(sArtificialNo == null) sArtificialNo = "";
		
		sBusinessSum = DataConvert.toMoney(rs.getDouble(5));
		
		sBalance = DataConvert.toMoney(rs.getDouble(6));
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs.getDouble(7));
		
		sPutOutDate = rs.getString(8);
		if(sPutOutDate == null) sPutOutDate = "";
		
		sMaturity = rs.getString(9);
		if(sMaturity == null) sMaturity = "";
		
		sVouchType = rs.getString(10);
		if(sVouchType == null) sVouchType = "";
		
		sRiskRate = rs.getString(11);
		if(sRiskRate == null) sRiskRate = "";
		
		sClassifyResult = rs.getString(12);
		if(sClassifyResult == null) sClassifyResult = "";
		
		sUserName = rs.getString(13);
		if(sUserName == null) sUserName = "";
		
		sOrgName = rs.getString(14);
		if(sOrgName == null) sOrgName = "";
	}
	rs.getStatement().close();	

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/PurposeInspect/02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=center colspan='2' bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>������;��鱨��</p>��¼һ��������ϸ</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >����Ʒ�֣�</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sBusinessType+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >�������ͣ�</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sOccurType+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >���֣�</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sCurrency+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >��ͬ��ˮ�ţ�</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >��ͬ���:</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >��</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sBalance+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >����(��)��</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >�������ڣ�</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >�������ڣ�</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sMaturity+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >������ʽ��</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sVouchType+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >���նȣ�</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sRiskRate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >���շ��ࣺ</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sClassifyResult+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >�ͻ�����</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sUserName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=left class=td1 >���������</td>");
	sTemp.append("   <td width=85% align=left class=td1 >"+sOrgName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=19 bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��¼�� ��������ͬ��ƾ֤�ȣ�</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=2 align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150; '",getUnitData("describe3",sData)));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
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
	editor_generate('describe1');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

