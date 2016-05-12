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

		History Log: xhgao 2009/06/29	������;��鱨�棨ժҪ�������пͻ����Ƹ�Ϊ��������Ϣȡ��
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 36;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//ȡ���пͻ�����
	String sBankName = CurConfig.getConfigure("BankName");
	
	//�жϸñ����Ƿ����
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next()){
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null){
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
	}else{
		sButtons[0][0] = "false";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
	}
	
	String[] sName = new String[10];
	sSql = " select getCustomerName(ObjectNo) as CustomerName,"+
		" II.updatedate as updatedate,"+
		" getUserName(II.InputUserID) as InputUserName,"+
		" getOrgName(II.InputOrgID) as InputOrgName "+
		" from INSPECT_INFO II"+
		" where II.SerialNo='"+sSerialNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[0] =DataConvert.toString(rs.getString("CustomerName"));
		if(sName[0] == null) sName[0] = "";
		sName[1] =DataConvert.toString(rs.getString("InputOrgName"));
		if(sName[1] == null) sName[1] = "";
		sName[2] =DataConvert.toString(rs.getString("InputUserName"));
		if(sName[2] == null) sName[2] = "";
		sName[3] =DataConvert.toString(rs.getString("updatedate"));
		if(sName[3] == null) sName[3] = "";
	}
	rs.getStatement().close();	
	//�ͻ����õȼ�
	sSql="select CreditLevel from ENT_INFO where customerid='"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[4]=DataConvert.toString(rs.getString("CreditLevel"));
		if(sName[4] == null) sName[4] = " ";
	}
	rs.getStatement().close();	
	//Ԥ���ź�
	sSql =	" select RS1.SignalNo || '' || RS1.SignalName || '' || getItemName('SignalType',RS1.SignalType) || '' || getItemName('SignalStatus',RS1.SignalStatus) as signalName "+
			" from RISK_SIGNAL RS1 "+
			" where RS1.ObjectType = 'Customer' "+
			" and RS1.ObjectNo = '"+sObjectNo+"' "+
			" and not exists(select RelativeSerialNo from RISK_SIGNAL RS2 "+
			" where RS2.RelativeSerialNo = RS1.SerialNo "+
			" and RS2.SignalType = '02' "+ //Ԥ�����ͣ�01������02�������
			" and RS2.SignalStatus = '30') "+//Ԥ��״̬��10��������20�������У�30����׼��40�������
			" and RS1.SignalType = '01' "+ 
			" and RS1.SignalStatus <> '40' ";
	rs = Sqlca.getResultSet(sSql);
	sName[5]="";
	String sTemp1 = "";
	while(rs.next()){
		sTemp1 = rs.getString("signalName");
		if(sTemp1 == null) sTemp1 = "";
		else
			sName[5] += sTemp1+"<br>";
	}
	rs.getStatement().close();	

	//���շ��༶��
	sSql="select getItemname('ClassifyResult',ClassifyResult) as ClassifyResult"+
		" from BUSINESS_CONTRACT"+
		" where CustomerID = '"+sObjectNo+"' "+
		" order by ClassifyResult desc";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sName[6] = rs.getString("ClassifyResult");
	}
	if(sName[6] == null) sName[6] = "";
	rs.getStatement().close();	
	/*
	if(sName[8].indexOf(",") != -1)
	{
		HashMap Opinion=new HashMap();
		Opinion.put("1","��������");
		Opinion.put("2","��ǿ����");
		Opinion.put("3","ֹͣ�������Ż����");
		Opinion.put("4","ѹ������");
		Opinion.put("5","ȫ������");
		Opinion.put("6","��������");
		Opinion.put("7","����");
		String[] sChecked=sName[8].split(",");
		
		sName[8]="";
		for(int j=0; j<sChecked.length; j++)
		{
			sName[8]=sName[8]+(String)Opinion.get(sChecked[j])+"<br>";
		}
	}
	*/
	//���Ž����������
	String sBusinessSum = "";
	String sBalance = "";
	sSql = " select sum(BusinessSum),sum(Balance) from BUSINESS_CONTRACT "+
		   " where CustomerID = '"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sBusinessSum = DataConvert.toMoney(rs.getString(1));
		if(sBusinessSum.length() == 0) sBusinessSum = "0.00";
		sBalance = DataConvert.toMoney(rs.getString(2));
		if(sBalance.length() == 0) sBalance = "0.00";
	}
	rs.getStatement().close();
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=center colspan='3' bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>"+sBankName+"</p>�ͻ���鱨�棨ժҪ��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=center class=td1 >�ͻ����ƣ�</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >���������</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[1]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >����ˣ�</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[2]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >�������ڣ�</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[3]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=left class=td1 ><br>һ������ҵ����Ϣ<br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 ><p>��һ�����õȼ�</p></td>");
	sTemp.append("   <td align=left class=td1 >"+sName[4]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >���������Ŷ��</td>");
	sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"(Ԫ)&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >�������������</td>");
	sTemp.append("   <td align=left class=td1 >"+sBalance+"(Ԫ)&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=3 class=td1 >����Ԥ���ź�</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=3 class=td1 >"+sName[5]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
	sTemp.append("   <td colspan=3 class=td1 > ����������շ�����ͼ��� </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=3 class=td1 >"+sName[6]+"&nbsp;</td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

