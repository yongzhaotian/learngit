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

		History Log: xhgao 2009/06/29	������;��鱨�棬���пͻ����Ƹ�Ϊ��������Ϣȡ��
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
		sButtons[1][0] = "false";
	}else{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	String[] sName = new String[4];
	sSql = " select getCustomerName(ObjectNo) as CustomerName,"+
			" II.updatedate as updatedate,"+
			" getUserName(II.InputUserID) as InputUserName,"+
			" getOrgName(II.InputOrgID) as InputOrgName "+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[0] =DataConvert.toString(rs.getString("CustomerName"));
		sName[1] =DataConvert.toString(rs.getString("InputOrgName"));
		sName[2] =DataConvert.toString(rs.getString("InputUserName"));
		sName[3] =DataConvert.toString(rs.getString("updatedate"));
	}
	rs.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=center colspan='2' bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>"+sBankName+"</p>�ͻ���鱨��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 ><strong>�ͻ����ƣ�</strong> </td>");
    sTemp.append("   <td width=80% align=left class=td1 >"+sName[0]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 ><strong>���������</strong> </td>");
	sTemp.append("   <td align=left class=td1 >"+sName[1]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 ><strong>����ˣ�</strong> </td>");
	sTemp.append("   <td align=left class=td1 >"+sName[2]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 ><strong>�������ڣ�</strong> </td>");
	sTemp.append("   <td align=left class=td1 >"+sName[3]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br><strong>һ��ҵ��������</strong></font><br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>��һ��</strong>ҵ��Ϲ��ԡ������ļ���Ч��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>������</strong>��֤�𡢵�Ѻ����Ѻ����ʵ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>������</strong>��������ǰ����������ʵ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>���ģ�</strong>������;<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>���壩</strong>�������Ҫ�����ʵ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>������</strong>ҵ�����ϵ��걸��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>���ߣ�</strong>���ڿͻ���ϵ�����ʼ�¼<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:150'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br><strong>�������ſͻ�����</strong></font><br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>��һ����������䶯</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1����Ȩ���ʱ��䶯���ش�Ͷ�ʻ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:150'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2����Ҫ������Ա�䶯<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:150'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3����Ӫҵ����Ҫ��Ʒ�䶯<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:150'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4��������Ҫ�䶯<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:150'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>����������״������䶯���Ʒ���</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1���ֽ������ͻ�����Դ����<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:150'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2����Ҫ�ʲ�����ծ��Ŀ�ͳ�ծָ�����<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:150'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3�����롢�ɱ������õĹ��ɺ�ӯ������תָ�����<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:150'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4�����ⵣ�����ʲ���Ѻ�ȱ����������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:150'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;5��������ʵ�ԡ����������ϲ���Χ������������� <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:150'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>��������Ӫ������ش��������</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1����ҵ���г��������������Ͳ�Ʒ����������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:150'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2����Ӫ����ģʽ�ͷ�չս�Է���<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:150'",getUnitData("describe18",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3����Ա���ʺ��ڲ����Ʒ���<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe19' style='width:100%; height:150'",getUnitData("describe19",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4���ش��ͻ���¼�����<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe20' style='width:100%; height:150'",getUnitData("describe20",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;5��������Ŀ��������Ͷ�ʺ͹��̽������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe21' style='width:100%; height:150'",getUnitData("describe21",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>���ģ�������Ը����</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1����ͬԼ������ǰ��ŵ������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe22' style='width:100%; height:150'",getUnitData("describe22",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2�������ͻ������������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe23' style='width:100%; height:150'",getUnitData("describe23",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3���ⲿ���ü�¼���� <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe24' style='width:100%; height:150'",getUnitData("describe24",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br><strong>������������</strong></font><br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>��һ������/��֤�����</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1�����������ͱ���״��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe25' style='width:100%; height:150'",getUnitData("describe25",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2�������ֵ�䶯�ͱ������� <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe26' style='width:100%; height:150'",getUnitData("describe26",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>��������Ѻ�����</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1����Ѻ�������ͱ���ʹ��״��<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe27' style='width:100%; height:150'",getUnitData("describe27",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2����Ѻ���ֵ�䶯�ͱ�������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe28' style='width:100%; height:150'",getUnitData("describe28",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>��������֤�˷���</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1����֤�˻�������������ſͻ���ϵ<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe29' style='width:100%; height:150'",getUnitData("describe29",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2���˱��������֤��������ҵ�����<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe30' style='width:100%; height:150'",getUnitData("describe30",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3����֤�˵Ĳ������<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe31' style='width:100%; height:150'",getUnitData("describe31",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4����֤�˵ķǲ������ <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe32' style='width:100%; height:150'",getUnitData("describe32",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p><strong>�ġ�����������</strong></p></font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe33' style='width:100%; height:150'",getUnitData("describe33",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p><strong>�塢������ժҪ</strong></p></font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("1",sMethod,"name='describe34' style='width:100%; height:150'",getUnitData("describe34",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p><strong>���������ȡ�ķ��չ����ʩ</strong></p></font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >��һ����ʩ���<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe35' style='width:100%; height:150'",getUnitData("describe35",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >�����������ʩ <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe36' style='width:100%; height:150'",getUnitData("describe36",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><br><strong>�����ǩ�£�</strong><br>&nbsp;&nbsp;</td>");
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
	editor_generate('describe4');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe5');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe6');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe7');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe8');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe9');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe10');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe11');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe12');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe13');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe14');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe15');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe16');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe17');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe18');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe19');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe20');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe21');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe22');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe23');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe24');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe25');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe26');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe27');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe28');		//��Ҫhtml�༭,input��û��Ҫ   
	editor_generate('describe29');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe30');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe31');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe32');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe33');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe34');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe35');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe36');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

