<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xliu 20130322
		Tester:
		Content: ��ǰ����۵�
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
	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='AdvanceRepay.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
		
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2 >	");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center colspan=100 width=100% ><font style=' font-size: 12pt;FONT-FAMILY:����;'><br>���ڰ�Ǫ���ڷ������޹�˾&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=right colspan=100 width=100% ><font style='font-size: 10pt;'>2013/05/06</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'><br>�ͻ�����</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>�й� �Ĵ�ʡ �ɶ���</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>��ַ</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>��������</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center colspan=100 width=100% ><font style=' font-size: 12pt;FONT-FAMILY:����;'><br>��ǰ�����<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>��ͬ��ϸ</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>�ͻ�����</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��ͬ����</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��ͬ����</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>����Ƶ�ʣ�</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��ͬ��Ч��</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>���� %</font></td>"); 
	sTemp.append("   <td align=left colspan=51 width=51% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��ͬ��󻹿���</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��������</font></td>"); 
	sTemp.append("   <td align=left colspan=51 width=51% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>���ƺ��룺</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'><br>Ӧ���˿�</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>ȫ��Ӧ���˿�</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>�����Ϣ�ܶ�</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;%</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>���Ԥ�����ܶ�</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��ǰ������</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>���ڽ��</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��Ϣ</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'><br>��ǰ����������</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>�ӷ�</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>�������</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;%</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��ǰ�����</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>������ </font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>��ǰ�����ȡ���</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
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

