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
				Method:   ���� 1:display;2:save;3:preview;6:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//��õ��鱨������
	String sSql = "select CustomerID,CustomerName,BusinessType,BusinessSum "+
					" from Business_Contract where SerialNo = '"+sObjectNo+"'";

	String sCustomerID = "";//�ͻ����
	String sBusinessType = "";//��Ʒ���
	String sCustomerName = "";//�ͻ�����
	String sCertID = "";//֤������
	String sBusinessSum = "";//������
	String sEndTime = "";//���ʱ��
	String BUSINESSTYPE1 = "";//��Ʒ����1
	String BRANDTYPE1 = "";//Ʒ���ͺ�1
	//�ۺ���Ʒ�ܼۣ�Ԫ��
	String sPRICE1 = "";//�۸�1��
	String sBUSINESSTYPE2 = "";//��Ʒ���ͣ�2��
	String BUSINESSTYPE2 = "";//��Ʒ�ͺţ�2��
	String sBRANDTYPE2 = "";//Ʒ�ƣ�2��
	
	
	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	String sDay = StringFunction.getToday();
	sTemp.append("	<form method='post' action='7004.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		sCustomerID = rs2.getString("CustomerID");
		sCustomerName = rs2.getString("CustomerName");
		sBusinessType = rs2.getString("BusinessType");
		sBusinessSum = DataConvert.toMoney(rs2.getString("BusinessSum"));
	}
	sCertID = Sqlca.getString("select CertID from Customer_Info where CustomerID = '"+sCustomerID+"'");
	//sEndTime = Sqlca.getString("");
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=2  >");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=center colspan=4 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;background-color:#FFFFFF' >����ת����������</font></td>");	
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		sTemp.append("<table class=table1 width='660' align=center border=0 cellspacing=0 cellpadding=2  >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td class=td1 align=left colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͻ���Ϣ</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >��ͬ����&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >������&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >��Ƿ���(�۳�δ������Ϣ)&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td class=td1 align=left colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >������Ϣ</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >�����ͺ�&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >�������&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >���ƺ�&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >������ֵ&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >ת�ۼ۸�&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >����۸�(ǰ5����߼۸�)</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center width=7% class=td1 >���&nbsp;</td>");
		sTemp.append("   <td align=center width=43% class=td1 >����������&nbsp;</td>");
		sTemp.append("   <td align=center width=25% class=td1 >�����(�����)&nbsp;</td>");
		sTemp.append("   <td align=center width=25% class=td1 >�ԱȲ�(%)&nbsp;</td>");
		sTemp.append("   </tr>");
		//forѭ��ȡ����Ӧ�߼�
		for(int i = 1;i <= 5; i++){
			sTemp.append("   <tr>");
			sTemp.append("   <td align=center width=7% class=td1 >"+i+"&nbsp;</td>");
			sTemp.append("   <td align=left width=43% class=td1 >&nbsp;</td>");
			sTemp.append("   <td align=right width=25% class=td1 >&nbsp;</td>");
			sTemp.append("   <td align=right width=25% class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >ժҪ</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >��߳����&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >��ת�ۼ۸�ԱȲ�&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >�̿�/ӯ�� (������ת��������)&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�������</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >������<123123>�ĳ����Ϊ�����<345345345> Ԫ���˼۸�Ϊ��߾���ۡ� �˽���˲���Ϊ����ת�۽��׼۸�</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=2  >");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=4>&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left >�����ˣ�&nbsp;</td>");	
		sTemp.append("   <td align=left >&nbsp;</td>");	
		sTemp.append("   <td align=left >�����ˣ�&nbsp;</td>");	
		sTemp.append("   <td align=left >&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=4 >ǩ����&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 ><hr style=�趨��ʽ /></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=2 ><����������>&nbsp;</td>");	
		sTemp.append("   <td align=left colspan=2 ><������>&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=2 ><ְλ>&nbsp;</td>");	
		sTemp.append("   <td align=left colspan=2 ><ְλ>&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=2 ><����>&nbsp;"+sDay+"</td>");	
		sTemp.append("   <td align=left colspan=2 ><����>&nbsp;"+sDay+"</td>");	
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		
	sTemp.append("</div>");	
	
	rs2.getStatement().close();	
	
	sTemp.append("</form>");	
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");
	
	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

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

