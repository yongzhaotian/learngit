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
	String sSql = "select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'";
	String sCustomerID = Sqlca.getString(sSql);
	//��ȡ��Ӧ����
	String sCustomerName = Sqlca.getString("select CustomerName from Business_Contract where SerialNo = '"+sObjectNo+"'");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	//sSql = "select CustomerName,";
	
	rs2.getStatement().close();	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='7001.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("<table  width=640 align=center border='0' cellspacing='0' cellpadding='2'  >	");
		sTemp.append("   <td align=right colspan=4  ></td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4  > �㶫ʡ�����и����� </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >�����찲��ҵ԰B��801</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >"+sCustomerName+"&nbsp;����/Ůʿ&nbsp;&nbsp;��</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >��ͬ��/Reference&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;"+sObjectNo+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >����/Department/From&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;�ͻ���������</td>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >����/E-mail&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;Customer.Service@XXX com.cn</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >����/Date&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;"+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >��Ŀ/Subject&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;�����������֤��</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;������Ϣ</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left >���ƺţ�</td>");
		sTemp.append("   <td align=left >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left >���ܺţ�</td>");
		sTemp.append("   <td align=left >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;����"+DataConvert.toDate_YMD(sDay)+"������"+sCustomerName+"�����֤: xxxxxxxxxxxxxxxxxx���Ѿ���������������(�й�)���޹�˾��ǩ��֮�����������ͬ��(��ţ�"+sObjectNo+") ���µ�ȫ�����������ֹ�ú�ͬ������������ϡ�</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;�����ں�ͬ�����ڼ䣬���������ǹ����Ĵ���֧�ֺ���ϣ�����˾�ڴ�������ʾ��ֿ��л�⣬���Ļ�ӭ�������ǵĹ������ᱦ�����������ϵ�ϣ�����л����ٴ�Ϊ������</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;���ݺ�ͬԼ�����ֹ黹��ȫ���й����������������ļ����£�</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;�������Ǽ�֤��</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >����!</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=right colspan=2 >�ͻ���������</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=right colspan=2 >���ڰ�Ǫ���ڷ������޹�˾</td>");
		sTemp.append("   </tr>");
		//sTemp.append("   <tr>");
		//sTemp.append("   <td align=right colspan=4  ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>���ڰ�Ǫ���ڷ������޹�˾��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> ���ڣ�"+DataConvert.toDate_YMD(sDay)+"</td>");
		//sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4  >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");	
	    
	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='111'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='111'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='111'>");
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

