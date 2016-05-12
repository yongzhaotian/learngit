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

		History Log:  xhgao 2009/06/29	���пͻ����Ƹ�Ϊ��������Ϣȡ��
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//ȡ���пͻ�����
	String sBankName = CurConfig.getConfigure("BankName");
	
	//��õ��鱨������
	String sSql = "select CustomerID,CustomerName,getBusinessName(BusinessType) as BusinessTypeName,BusinessType,"+
				" getItemname('YesOrNo',ContractFlag) as ContractFlag,TermMonth,BailRatio,"+
				" getItemName('Currency',BusinessCurrency) as CurrencyName,BusinessSum,"+
				" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BusinessRate,PdgRatio,"+
				" getItemName('VouchType',VouchType) as VouchType,remark,getOrgName(InputOrgID) as OrgName "+
				" from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessType = "";
	String sCreditType = "";
	String sOrgName = "";
	String sUserName = "";
	String sContractFlag = "";
	String sRemark = "";
	String sCurrencyName = "";		    //����
	String sBusinessSum = "";			//�ܶ��
	String sBusinessRate = "";			//��/����
	String sClassifyResult = "";		//�弶����
	String sBailRatio = "";
	String sTermMonth = "";
	String sVouchType = "";
	String sCreditLevel = "";
	String sPdgRatio = "";
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) 
	{
		sCustomerID = rs2.getString("CustomerID");
		if(sCustomerID == null) sCustomerID ="";
		
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName ="";
		
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType="";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName="";
		
		sContractFlag = rs2.getString("ContractFlag");
		if(sContractFlag == null)sContractFlag ="";
		
		sRemark = rs2.getString("Remark");
		if(sRemark == null) sRemark="";
		
		sCreditType = rs2.getString("BusinessTypeName");
		if(sCreditType == null) sCreditType="";
		
		sCurrencyName = rs2.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName="";
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(6);
        sBusinessSum = nf.format(rs2.getDouble("BusinessSum")/10000);
        
        NumberFormat nf1 = NumberFormat.getInstance();
        nf1.setMinimumFractionDigits(4);
        nf1.setMaximumFractionDigits(4);
		sBusinessRate = nf1.format(rs2.getDouble("BusinessRate"));
		
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));
		
		sPdgRatio = nf1.format(rs2.getDouble("PdgRatio"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if( sClassifyResult== null) sClassifyResult="";
		
		sTermMonth = DataConvert.toMoney(rs2.getDouble("TermMonth"));
		
		sVouchType = rs2.getString("VouchType");
		if( sVouchType== null) sVouchType="";
		
		sOrgName = rs2.getString("OrgName");
		if(sOrgName == null) sOrgName = "";
		
	}
	rs2.getStatement().close();	
	//������
	sSql = "select PhaseOpinion,getUserName(UserID) as UserName,BeginTime,getItemName('ClassifyResult',Phaseopinion1),Phaseopinion2,getItemName('YesOrNo',Phaseopinion3) from FLOW_TASK where SerialNo = '"+sSerialNo+"'";
	String sPhaseOpinion = "";
	String sBeginTime = "";
	String sPhaseOpinion1 = "";
	String sPhaseOpinion2 = "";
	String sPhaseOpinion3 = "";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) 
	{
		sPhaseOpinion = rs2.getString(1);
		if(sPhaseOpinion == null) sPhaseOpinion = "";	
		
		sUserName = rs2.getString(2);
		if(sUserName == null) sUserName = "";
		
		sBeginTime = rs2.getString(3);
		if(sBeginTime == null) sBeginTime = "";
		
		sPhaseOpinion1 = rs2.getString(4);
		if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
		
		sPhaseOpinion2 = rs2.getString(5);
		if(sPhaseOpinion2 == null) sPhaseOpinion2 = "";
		
		sPhaseOpinion3 = rs2.getString(6);
		if(sPhaseOpinion3 == null) sPhaseOpinion3 = "";
	}
	rs2.getStatement().close();	
	//���õȼ�
	sSql = "select getItemName('CreditLevel',CreditLevel) from ENT_INFO where CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) 
	{
		sCreditLevel = rs2.getString(1);
		if(sCreditLevel == null) sCreditLevel = "";
	}
	rs2.getStatement().close();	
	//������Ϣ
	sSql = 	"select getItemName('GuarantyType',GuarantyType) from GUARANTY_CONTRACT " +
			" where serialno in " +
			"  (select objectno  from apply_relative "+
			"  where objecttype='GUARANTY_CONTRACT' and serialno='"+sObjectNo+"') group by GuarantyType";
	String sGuarantyType = " ";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantyType += DataConvert.toString(rs2.getString(1))+" ";
	}
	if(sGuarantyType.length()<=1) sGuarantyType = "����";
	rs2.getStatement().close();
	//��֤��
	sSql =  "select GuarantorName,getItemName('GuarantyType',GuarantyType) from GUARANTY_CONTRACT " +
			" where serialno in " +
			"  (select objectno  from apply_relative "+
			"    where objecttype='GUARANTY_CONTRACT' and serialno='"+sObjectNo+"') "+
			" and guarantytype like '010%' order by GuarantyType";
	String sGuarantorName = "&nbsp;";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantorName += rs2.getString(1)+"<br>";
	}
	
	rs2.getStatement().close();		
	//����Ѻ������
	sSql  = "select getItemName('GuarantyList',GuarantyType) from GUARANTY_INFO where objectno in ( " +
			"select serialno from GUARANTY_CONTRACT " +
			" where serialno in " +
			"  (select objectno  from apply_relative "+
			"    where objecttype='GUARANTY_CONTRACT' and serialno='"+sObjectNo+"') " +
			" and guarantytype in ('050','060'))";
	rs2 = Sqlca.getResultSet(sSql);
	String sGuarantyName = "";
	while(rs2.next()) 
	{
		sGuarantyName = rs2.getString(1);
		if(sGuarantyName == null) sGuarantyName = "";
		else sGuarantyName += "&nbsp;&nbsp;";
	}
	rs2.getStatement().close();	
	//����ҵ�����
	sSql = "select getitemname('Currency',businesscurrency),sum(balance) "+ 
		   "from BUSINESS_CONTRACT where customerid = '"+sCustomerID+"' "+ 
		   "and OffSheetFlag in ('EntOn','IndOn') "+
		   "and balance >0 and (finishdate = ' ' or finishdate is null) group by businesscurrency";
	rs2 = Sqlca.getResultSet(sSql);
	String bnBalance = "&nbsp;";
	while(rs2.next())
	{
		bnBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}
	rs2.getStatement().close();	
	//����ҵ�񳨿�
	sSql = "select getitemname('Currency',businesscurrency),sum(balance-nvl(bailsum,0)) as balance "+ 
		   "from BUSINESS_CONTRACT where customerid = '"+sCustomerID+"' and OffSheetFlag in ('EntOff','IndOff') "+
		   "and balance >0 and (finishdate = ' ' or finishdate is null) group by businesscurrency ";
	rs2 = Sqlca.getResultSet(sSql);
	String bwBalance = "&nbsp;";
	while(rs2.next())
	{
		if(rs2.getDouble(2)>0)
			bwBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
		else
			bwBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+0+"<br>"; 
	}
	rs2.getStatement().close();	
	//��ǰ��������
	sSql = "select getitemname('Currency',businesscurrency),sum(balance) from BUSINESS_CONTRACT where customerid = '"+sCustomerID+"' "+ 
		   "and classifyresult  in ('02','03','04','05') and balance >0 and (finishdate = ' ' or finishdate is null) group by businesscurrency";
	rs2 = Sqlca.getResultSet(sSql);
	String sOtherBalance = "&nbsp;";
	while(rs2.next())
	{
		sOtherBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}
	rs2.getStatement().close();	
	/*
	if(sBusinessTypeName.equals("���Ŷ��") || sBusinessTypeName.equals("��ҵ�жһ�Ʊ����"))
	{
		sBusinessTypeName = "�ۺ����Ŷ��";
	}
	else if(sContractFlag.equals("��")) 
	{
		sBusinessTypeName = "���ʵ���";
	}
	else if(sContractFlag.equals("��"))
	{
		sBusinessTypeName = "���Ŷ������ҵ��";
	}
	*/
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr align=center>");	
	sTemp.append("   <td class=td1 colspan=8 bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sBankName+"��鱨��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=right>");	
	sTemp.append("   <td colspan=8 bgcolor=#aaaaaa class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >��鱨���ţ�"+sObjectNo+"</font></td>"); 	
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=21% align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'> ����������:</font></td>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sCustomerName+"&nbsp;</font></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'> �ʱ��С���: </font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sOrgName+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>����Ʒ��</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sCreditType+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>�Ƿ��ױ�</td>");
	sTemp.append("   <td width=18% colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sPhaseOpinion3+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>���(��)</font></td>");
	sTemp.append("   <td width=21% colspan=2 align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sBusinessSum+"&nbsp;</font></td>");
	sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>����</font></td>");
	sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sCurrencyName+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>��������</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sCreditLevel+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>��֤�����%</font></td>");
	sTemp.append("   <td colspan=2 align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sBailRatio+"&nbsp;</font></td>");
	sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>����(��)</font></td>");
    sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sTermMonth+"</font></td>");
    sTemp.append("   </tr>");    
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>���ն�</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sPhaseOpinion2+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>������ʽ</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sGuarantyType+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    /*
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>������Ϣ<br>"+sGuarantyType+"</font></td>");
    sTemp.append("   </tr>");
    */
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>�ͻ������弶����</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sClassifyResult+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>��֤������</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sGuarantorName+"</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>������弶����</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sPhaseOpinion1+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>����Ѻ��</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sGuarantyName+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>����ҵ�����</font></td>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+bnBalance+"</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>����ҵ�񳨿����</font></td>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+bwBalance+"</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>��ǰ����������������㣩</font></td>");
	sTemp.append("   <td colspan=5 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sOtherBalance+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
    String sDay = sBeginTime.replaceAll("/","");
    //sPhaseOpinion = StringFunction.replace(sPhaseOpinion,"\n","<br>");
    sPhaseOpinion = StringFunction.replace(sPhaseOpinion,"\r","<br>");
    sPhaseOpinion = StringFunction.replace(sPhaseOpinion," ","&nbsp;");
    sTemp.append("   <td colspan=8 align=center class=td1 ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</font>&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left valign=top class=td1 style='word-break:break-all' ><font style=' font-size: 12pt;FONT-FAMILY:����;'>"+sPhaseOpinion+"<br>&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ˣ�"+sUserName+"&nbsp;&nbsp;&nbsp;������ڣ�"+DataConvert.toDate_YMD(sDay)+"</font></td>");
    sTemp.append("   </tr>");
    /*
    sTemp.append("   <tr>");
    sTemp.append("   <td colspan=8 align=center class=td1 ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >��&nbsp;&nbsp;ע&nbsp;&nbsp;��</font>&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left valign=top class=td1 style='word-break:break-all' ><font style=' font-size: 12pt;FONT-FAMILY:����;'><br>&nbsp;<br>&nbsp;<br>&nbsp;</font></td>");
    sTemp.append("   </tr>");
    */
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
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

