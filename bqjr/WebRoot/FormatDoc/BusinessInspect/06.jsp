<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
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
	int iDescribeCount = 30;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//�жϸñ����Ƿ����
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next()){
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null){
		sButtons[1][0] = "false";
	}else{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	String[] sName = new String[4];
	sSql = " select ObjectNo,getCustomerName(ObjectNo) as CustomerName"+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[0] = DataConvert.toString(rs.getString("ObjectNo"));
		sName[1] = DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close();
	
	//���̵�ַ,��ϵ�绰,��ͥ��ַ,�ܻ��ͻ�����
	String sRegisterAdd = "",sRelativeType = "",sOfficeAdd = "",sUserName = "";
	sSql = " select RegisterAdd,RelativeType,OfficeAdd,getUserName(InputUserID) as UserName from ENT_INFO where CustomerID = '"+sName[0]+"' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sRegisterAdd = DataConvert.toString(rs.getString("RegisterAdd"));
		sRelativeType = DataConvert.toString(rs.getString("RelativeType"));
		sOfficeAdd = DataConvert.toString(rs.getString("OfficeAdd"));
		sUserName = DataConvert.toString(rs.getString("UserName"));
	}
	rs.getStatement().close();
	
	//������,�������
	String sBusinessSum = "";
	String sBalance = "";
	sSql = " select sum(BusinessSum) as BusinessSum,sum(Balance) as Balance from BUSINESS_CONTRACT where CustomerID = '"+sName[0]+"' ";
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
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/06.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=12 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>�������</p></font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 align=left class=td1 ><font style=' font-size: 12pt;' >&nbsp;&nbsp;���׶Σ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=center class=td1 >�ͻ�����</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sName[1]+"&nbsp;</td>");
    sTemp.append("   <td colspan=3 align=center class=td1 >���̵�ַ</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=center class=td1 >��ϵ�绰</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sRelativeType+"&nbsp;</td>");
    sTemp.append("   <td colspan=3 align=center class=td1 >��ͥ��ַ</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sOfficeAdd+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=center class=td1 >��������</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >&nbsp;</td>");
    sTemp.append("   <td colspan=3 align=center class=td1 >�ܻ��ͻ�����</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sUserName+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='15%' colspan=2 align=center class=td1 >������</td>");
    sTemp.append("   <td width='15%' colspan=2 align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append("   <td width='20%' colspan=2 align=center class=td1 >�������</td>");
    sTemp.append("   <td width='15%' colspan=2 align=left class=td1 >"+sBalance+"&nbsp;</td>");
    sTemp.append("   <td width='15%' colspan=2 align=center class=td1 >������ʩ</td>");
    sTemp.append("   <td width='20%' colspan=2 align=left class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 class=td1 >");
	sTemp.append("<div id=reporttable3>");	
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2>	");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center>�����ռ���</td>");
	sTemp.append("   <td>");    
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"���ۺ�ͬ"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"������ˮ"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"���۷�Ʊ"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"����վ�"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"��ҵ������վ�"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"ˮ����վ�"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td align=center>&nbsp;</td>");
	sTemp.append("   <td>");
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"�ֻ��˵�"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"���ò�ѯ��¼"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >���</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >�������</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >ֱ�ӹ۲�</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >ѯ���˽�</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >˵��</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >1</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >�����ʽ���;</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe28'",getUnitData("describe28",sData),"��ʵ@Ų��")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe29'",getUnitData("describe29",sData),"��ʵ@Ų��")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >2</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >�Ƿ�������Ӫҵ</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe9'",getUnitData("describe9",sData),"��@��")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe10'",getUnitData("describe10",sData),"��@��")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >3</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >�ϰ��Ƿ��ڳ�</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe11'",getUnitData("describe11",sData),"��@��")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe12'",getUnitData("describe12",sData),"��@��")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >4</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >������Ա�����䶯</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe13'",getUnitData("describe13",sData),"����@�ȶ�@����")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe14'",getUnitData("describe14",sData),"����@�ȶ�@����")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >5</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >������Ա������ò</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe15'",getUnitData("describe15",sData),"��@һ��@��")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe16'",getUnitData("describe16",sData),"��@һ��@��")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >6</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >��Ӫ��������������</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe17'",getUnitData("describe17",sData),"����@�ȶ�@����")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe18'",getUnitData("describe18",sData),"����@�ȶ�@����")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >7</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >�ֿ�����Ƿ�����</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe19'",getUnitData("describe19",sData),"��@��")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe20'",getUnitData("describe20",sData),"��@��")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >8</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >�ֿ����Ƿ����</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe21'",getUnitData("describe21",sData),"��@��")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe22'",getUnitData("describe22",sData),"��@��")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >9</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >����������</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe23'",getUnitData("describe23",sData),"����@�ȶ�@����")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe24'",getUnitData("describe24",sData),"����@�ȶ�@����")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >10</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >����˽���״��</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe25'",getUnitData("describe25",sData),"��@����")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe26'",getUnitData("describe26",sData),"��@����")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 align=left class=td1 >��������Ѻ����Ѻ����֤�����������<br />"+myOutPut("2",sMethod,"name='describe30' style='width:700; height:80'",getUnitData("describe30",sData)));
    sTemp.append("   </tr>");    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 align=left class=td1 >����������<br />"+myOutPut("2",sMethod,"name='describe27' style='width:700; height:80'",getUnitData("describe27",sData))+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǩ����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</td>");
    sTemp.append("   </tr>");
    sTemp.append("	<tr>");
  	sTemp.append(" 		<td align=left colspan=6 class=td1 >");
  	sTemp.append("        ҵ�񲿾��������<br /><br /><br /><br />ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��");
  	sTemp.append(" 		</td>");
  	sTemp.append(" 		<td align=left colspan=6 class=td1 >");
  	sTemp.append("        �����������<br /><br /><br /><br />ǩ�֣�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��");
  	sTemp.append(" 		</td>");
    sTemp.append(" 	</tr>");
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
	editor_generate('describe27');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe30');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

