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
	int iDescribeCount = 6;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	String sGuarantyNo = "";//������
	ASResultSet rs2 = Sqlca.getResultSet("select GuarantyNo from FORMATDOC_DATA where SerialNo='"+sSerialNo+"' and ObjectNo ='"+sObjectNo+"'");
	//out.println("select GuarantyNo from FORMATDOC_DATA where SerialNo='"+sObjectNo+"' and ObjectNo ='"+sSerialNo+"'");
	if(rs2.next())
	{
		sGuarantyNo = rs2.getString(1);
	}
	rs2.getStatement().close();	
	
	
	String sSql = "select getItemName('GuarantyList',GuarantyType) as GuarantyTypeName,GuarantyID,"+
				  "GuarantyName,GuarantyLocation,OwnerName,GuarantyRightID,"+
				  "GuarantyDescript,GuarantyPrice,BeginDate,GuarantyAmount1,"+
				  "AboutRate,OwnerTime,EvalNetValue,EvalOrgName,EvalDate,ConfirmValue,GuarantyRate "+
				  "from GUARANTY_INFO where GuarantyID = '"+sGuarantyNo+"'";
	
	String sGuarantyTypeName = "";	//��Ѻ�����
	String sGuarantyID = "";		//��Ѻ����
	String sGuarantyName = "";		//��Ѻ������
	String sGuarantyLocation = "";	//��Ѻ��λ��
	String sOwnerName = "";			//��Ѻ�������Ȩ��
	String sGuarantyRightID = "";	//��Ѻ�����֤���ļ�
	String sGuarantyDescript = "";	//��Ѻ����ϸ����
	String sGuarantyPrice = "";		//��Ѻ��ԭֵ
	String sGuarantyAmount1 = "";	//����
	String sAboutRate = "";			//�۾���
	String sOwnerTime = "";			//��Ѻ��ʹ������
	String sBeginDate = "";			//����ʱ��
	String sEvalNetValue = "";		//��ʽ������ֵ
	String sEvalOrgName = "";		//��Ѻ����������
	String sEvalDate = "";			//����ʱ��
	String sConfirmValue = "";		//����ȷ�ϼ�ֵ
	String sGuarantyRate = "";		//��Ѻ��
	
	rs2= Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sGuarantyTypeName = rs2.getString("GuarantyTypeName");
		if(sGuarantyTypeName == null) sGuarantyTypeName = "";
		
		sGuarantyID = rs2.getString("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		
		sGuarantyName = rs2.getString("GuarantyName");
		if(sGuarantyName == null) sGuarantyName = "";
		
		sGuarantyLocation = rs2.getString("GuarantyLocation");
		if(sGuarantyLocation == null) sGuarantyLocation = "";
		
		sOwnerName = rs2.getString("OwnerName");
		if(sOwnerName == null) sOwnerName = "";
		
		sGuarantyRightID = rs2.getString("GuarantyRightID");
		if(sGuarantyRightID == null) sGuarantyRightID = "";
		
		sGuarantyDescript = rs2.getString("GuarantyDescript");
		if(sGuarantyDescript == null) sGuarantyDescript = "";
		
		sGuarantyPrice = DataConvert.toMoney(rs2.getDouble("GuarantyPrice")/10000);
		
		sGuarantyAmount1 = DataConvert.toMoney(rs2.getDouble("GuarantyAmount1"));

		sAboutRate = DataConvert.toMoney(rs2.getDouble("AboutRate"));
		
		sOwnerTime = rs2.getString("OwnerTime");
		if(sOwnerTime == null) sOwnerTime = "";
		
		sBeginDate = rs2.getString("BeginDate");
		if(sBeginDate == null) sBeginDate = "";
		
		sEvalNetValue = DataConvert.toMoney(rs2.getDouble("EvalNetValue")/10000);
		
		sEvalOrgName = rs2.getString("EvalOrgName");
		if(sEvalOrgName == null) sEvalOrgName = "";
		
		sEvalDate = rs2.getString("EvalDate");
		if(sEvalDate == null) sEvalDate = "";
		
		sConfirmValue = DataConvert.toMoney(rs2.getDouble("ConfirmValue")/10000);
		
		sGuarantyRate = DataConvert.toMoney(rs2.getDouble("GuarantyRate"));
		
	}
	rs2.getStatement().close();
	
	//��ñ��
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '06__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "6."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0660.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[j]+"����Ѻ��ʽ</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=34% align=center class=td1 > ��Ѻ�����</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > ��Ѻ���� </td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sGuarantyID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > ��Ѻ������</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > ��Ѻ��λ��/��ŵص� </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyLocation+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > ��Ѻ�������Ȩ�� </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > ��Ѻ�����֤���ļ� </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyRightID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
  	sTemp.append("   <td colspan=4 class=td1 > ��Ѻ����ϸ����: <br>"+sGuarantyDescript+"</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 >��Ѻ��ԭֵ/���üۣ���Ԫ��</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyPrice+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > ����ʱ��/����ʱ�� </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > ���/���� </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyAmount1+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > �۾��� </td>");
	sTemp.append("   <td width=22% align=center class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > ��Ѻ��ʹ������ </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sOwnerTime+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > ʣ������ </td>");
	sTemp.append("   <td width=22% align=center class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
  	sTemp.append("   <td colspan=4 class=td1 > ��Ѻ���������� <br>"+sEvalOrgName+"</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > ��ʽ������ֵ(��Ԫ)</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sEvalNetValue+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > ����ʱ��</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sEvalDate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > ����ȷ�ϼ�ֵ(��Ԫ)</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sConfirmValue+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > ��Ѻ��</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyRate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" >������Ѻ���Ƿ��вƲ������ˣ��������Ƿ����ͬ���Ѻ�������ļ���<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>��λ�ָ��Ѻ״��</p>");
  	sTemp.append("     <p>1������ͬһ��Ѻ���趨���ɵ�Ѻ�ģ����ύ�Ѹ�֪��ծȨ�˵�����֤�������ṩ������ծȨ�˵��峥˳��</p>");
  	sTemp.append("     <p>2������Ѻ��Ϊ���彨����һ���֣�Ӧ�������彨���������������Ȩ�������</p>");
  	sTemp.append("     3������ǰ������Ѻ��Ӧ���ܵ�ʱ��Ѻ�����ծ���Ƿ���塣");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 "+myShowTips(sMethod)+" ><p>��Ѻ��ĸ����������</p>");
  	sTemp.append("    ��Ѻ��ĸ��������ơ���������ʣ��Ƿ񻮲����ػ��Ƿ����Խ�������");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 "+myShowTips(sMethod)+" ><p>��Ѻ���ֵ�ȶ��Է���</p>");
  	sTemp.append("   �Ե�Ѻ��ĳ�����(�������뿼���۾���)���ضΡ��г��۸񲨶��Խ��з�������Ѻ���Ԥ�ڼ�ֵ���ǻ����½����ƣ��Ƿ��ܸ��Ǵ�������²���ȱ�ڡ�");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>��Ѻ�������������</p>");
  	sTemp.append("   �Ե�Ѻ����г�������������Ԥ��������Ƿ����Ѹ�ٵĳ��ۣ��г��Ե�Ѻ��������С�������峥ʱ�Ƿ�����һЩ���ɼ����۷��õȡ�");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>�Ե�Ѻ��ķ��ɿ�������</p>");
  	sTemp.append("   ������Ѻ�����Դ��Σ���Ȩ�Ƿ����������޷��ɾ��ף��Ƿ�ӵ�������ܳ�Ȩ��");
  	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>�����������</p>");
  	sTemp.append("   �Ե�Ѻ������δ��������з�����"); 
  	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150'",getUnitData("describe6",sData)));
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
	editor_generate('describe2');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe3');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe4');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe5');		//��Ҫhtml�༭,input��û��Ҫ
	editor_generate('describe6');		//��Ҫhtml�༭,input��û��Ҫ
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>