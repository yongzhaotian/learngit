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

		History Log: xhgao 2009/06/29	������;��鱨����˱����пͻ����Ƹ�Ϊ��������Ϣȡ��
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 3;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//ȡ���пͻ�����
	String sBankName = CurConfig.getConfigure("BankName");
	
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
		sButtons[0][0] = "true";
	}
	else
	{
		sButtons[1][0] = "true";
	}
	
	String[] sName = new String[4];
	sSql = " select getCustomerName(ObjectNo) as CustomerName,"+
			" II.updatedate as updatedate,"+
			" getUserName(II.InputUserID) as InputUserName,"+
			" getOrgName(II.InputOrgID) as InputOrgName "+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"' and II.ObjectNo='"+sObjectNo+"' and II.ObjectType='"+sObjectType+"'";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sName[0] =(String)rs.getString("CustomerName");
		sName[1] =(String)rs.getString("InputOrgName");
		sName[2] =(String)rs.getString("InputUserName");
		sName[3] =(String)rs.getString("updatedate");
	}
	rs.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=center colspan='3' bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>"+sBankName+"</p>������;��鱨����˱�</font></td>"); 	
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
	sTemp.append("   <td colspan=2 align=celeftnter class=td1 >"+sName[3]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
sTemp.append("   <td colspan=3 align=left class=td1 ><strong>һ�����첿�š�֧�����</strong><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >����ˣ�</td>");
	sTemp.append("   <td align=center class=td1 >������ڣ�</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
sTemp.append("   <td colspan=3 align=left class=td1 ><strong>�������з��չ��������</strong><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >����ˣ�</td>");
	sTemp.append("   <td align=center class=td1 >������ڣ�</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
sTemp.append("   <td colspan=3 align=left class=td1 ><strong>�����������</strong><br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
	sTemp.append("   <td align=center class=td1 >����ˣ�</td>");
	sTemp.append("   <td align=center class=td1 >������ڣ�</td>");
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
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe3');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

