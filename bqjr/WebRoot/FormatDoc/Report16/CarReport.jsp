<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xliu 20130322
		Tester:
		Content: ����ת����������
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
	sTemp.append("	<form method='post' action='CarReport.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
		
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2 >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=center colspan=100 width=100% ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;'><br>����ת����������<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("</table>");	
	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͻ���Ϣ</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >��ͬ����</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >������</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >��Ƿ���(�۳�δ������Ϣ)</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");	
	
	sTemp.append("</br>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >������Ϣ</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >�����ͺ�:</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >�������</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >���ƺ�</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >������ֵ</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >ת�ۼ۸�</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");	
	
	sTemp.append("</br>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >����۸�(ǰ5����߼۸�)</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 width=10% >���</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=28 width=28% >����������</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >�����(�����)</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >�ԱȲ�(%)</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 width=10% >1</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=28 width=28% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 width=10% >2</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=28 width=28% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 width=10% >3</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=28 width=28% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 width=10% >4</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=28 width=28% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 width=10% >5</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=28 width=28% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("</table>");
	
	sTemp.append("</br>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >ժҪ</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >��߳����</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >��ת�ۼ۸�ԱȲ�:</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >�̿�/ӯ�� (������ת��������):</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");
	
	sTemp.append("</br>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�������</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% >������&lt;XXXX&gt;�ĳ����Ϊ�����&lt;xxxxx&gt;Ԫ���˼۸�Ϊ��߾���ۡ� �˽���˲���Ϊ����ת�۽��׼۸�</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");
	
	sTemp.append("</br>");
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2 >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>������:</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>������:</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>ǩ����</font></td>"); 	
	sTemp.append("   <td align=left colspan=80 width=80% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=80 width=80% >________________________________________</td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;����������&gt;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;������&gt;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;ְλ&gt;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;ְλ&gt;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;����&gt;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;����&gt;</font></td>"); 	
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

