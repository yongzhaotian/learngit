<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   fhuang  2006.10.19
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

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"' and ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"'";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	String sGuarantyNo = "";
	if(rs2.next())
	{
		sGuarantyNo = rs2.getString(1);
	}
	rs2.getStatement().close();	
	
	String sContractType = "";		//��ͬ����
	String sGuarantyType = "";		//��������
	String sCreditOrgName = "";		//Ͷ����
	String sOtherName = "";			//������
	String sGuarantorName = "";		//����ǩ������
	String sGuarantyCurrency = "";	//����
	String sGuarantyValue = "";		//���ս��
	String sOtherDescribe = "";		//�����ر�Լ��
	String sRemark = "";			//
	String sUserName = "";			//
	String sOrgName = "";			//
	String sInputDate = "";			//
	String sUpdateDate = "";		//
	
	sSql = "select getItemName('ContractType',ContractType) as ContractType,"+
		   "getItemName('GuarantyType',GuarantyType) as GuarantyType,CreditOrgName,"+
		   "OtherName,GuarantorName,getItemName('Currency',GuarantyCurrency) as GuarantyCurrency,"+
		   "GuarantyValue,OtherDescribe,Remark,getUserName(InputUserID) as UserName,"+
		   "getOrgName(InputOrgID) as OrgName,InputDate,UpdateDate "+
		   "from GUARANTY_CONTRACT where SerialNo = '"+sGuarantyNo+"'";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sContractType = rs2.getString("ContractType");
		if(sContractType == null) sContractType = "";
		
		sGuarantyType = rs2.getString("GuarantyType");
		if(sGuarantyType == null) sGuarantyType = "";
		
		sCreditOrgName = rs2.getString("CreditOrgName");
		if(sCreditOrgName == null) sCreditOrgName = "";
		
		sOtherName = rs2.getString("OtherName");
		if(sOtherName == null) sOtherName = "";
		
		sGuarantorName = rs2.getString("GuarantorName");
		if(sGuarantorName == null) sGuarantorName = "";
		
		sGuarantyCurrency = rs2.getString("GuarantyCurrency");
		if(sGuarantyCurrency == null) sGuarantyCurrency = "";
		
		sGuarantyValue = DataConvert.toMoney(rs2.getDouble("GuarantyValue"));
		
		sOtherDescribe = rs2.getString("OtherDescribe");
		if(sOtherDescribe == null) sOtherDescribe = "";
		
		sRemark =rs2.getString("Remark");
		if(sRemark == null) sRemark = "";
		
		sUserName = rs2.getString("UserName");
		if(sUserName == null) sUserName = "";
		
		sOrgName = rs2.getString("OrgName");
		if(sOrgName == null) sOrgName = "";
		
		sInputDate = rs2.getString("InputDate");
		if(sInputDate == null) sInputDate = "";
		
		sUpdateDate = rs2.getString("UpdateDate");
		if(sUpdateDate == null) sUpdateDate = "";
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
	sTemp.append("<form method='post' action='0640.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan�����ʵ��������������򵼳�ʱ��Ƚϲ���
	sTemp.append("   <td class=td1 align=left colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[j]+"��������֤</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=15% align=left class=td1 > ��������</td>");
	sTemp.append("   <td colspan=3 align=left class=td1 >"+sContractType+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > ������ʽ</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sGuarantyType+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > ����������</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sGuarantorName+"&nbsp; </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > ��֤�����</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sGuarantyCurrency+"&nbsp; </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 > ��֤����</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sGuarantyValue+"&nbsp; </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=4 align=left class=td1 > �����ر�Լ����<br>"+sOtherDescribe+"&nbsp;&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 > �Ǽ���</td>");
    sTemp.append("   <td width=15% align=center class=td1 >"+sUserName+"&nbsp;</td>");
    sTemp.append("   <td width=17% align=center class=td1 > �Ǽǻ���</td>");
    sTemp.append("   <td width=15% align=center class=td1 >"+sOrgName+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 > ��¼ʱ��</td>");
    sTemp.append("   <td align=center class=td1 >"+sInputDate+"&nbsp;</td>");
    sTemp.append("   <td align=center class=td1 > ����ʱ��</td>");
    sTemp.append("   <td align=center class=td1 >"+sUpdateDate+"&nbsp;</td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>