<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   tangyb  2015/5/20
		Content: ��ԤԼ�ֽ��������������Ȩ�顷��ӡҳ��
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
		Output param:

		History Log: 
	 */
	 	String PG_TITLE = "�������Ų�ѯ��Ȩ��"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;�������Ų�ѯ��Ȩ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	%>
<%/*~END~*/%>

<%
	//int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���3
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//��õ��鱨������
	//String sSql = "select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'";
	//String sCustomerID = Sqlca.getString(sSql);
	//��ȡ��Ӧ����
	//String sCustomerName = Sqlca.getString("select CustomerName from Business_Contract where SerialNo = '"+sObjectNo+"'");
	//ASResultSet rs2 = Sqlca.getResultSet(sSql);
	//sSql = "select CustomerName,";
	
	//rs2.getStatement().close();	
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=����������Ȩ��;]~*/%>
<%
		StringBuffer sTemp=new StringBuffer();
		sTemp.append("<div id=reporttable>");
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=0 >	");
		sTemp.append("<tr>");
		sTemp.append("<td colspan=1 rowspan=2 style='margin-left:30%' align=left><img src='"+sWebRootPath+"/FormatDoc/Images/121.jpg' /></td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("</table>");
	
		sTemp.append("<table width='660' border=0 cellspacing=0 cellpadding=0>");
		sTemp.append("<tr>");
		sTemp.append("<td align='center'><h2>�������Ų�ѯ��Ȩ��</h2></td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>����������_________________________��</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>");
		sTemp.append("<p style='font-size: 12pt; line-height: 30pt'>");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;������Ȩ�����ڰ�������ҵ��ʱ�����������������Ϣ�������ݿ��ѯ�������ñ��棬�����������˵ĸ��˻�����Ϣ���Ŵ�������Ϣ�������Ϣ�����������Ϣ�������ݿⱨ�ͣ�");
		sTemp.append("</p>");
		sTemp.append("</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��˴������룻</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��˴��ǿ���׼���ǿ����룻</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��˱�����Ϊ�����ˣ�</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;���ѷ��ŵĸ����Ŵ����д�����չ���</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;�����˻�������֯�Ĵ������������Ϊ�����ˣ���Ҫ��ѯ�䷨�������˼�����������״����</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;����˲飻</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;��չ��Լ�̻�����ʵ����ˡ�</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��Ȩ��ѯ����Ϊ��ҵ����������ҵ���ս��գ�</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;����Ȩ�˳�����Ȩ��ѯ��һ�к�������������ɱ���Ȩ�˳е���</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;��Ȩ��֪Ϥ�������Ȩ��������ݣ��ش���Ȩ��</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='right'>��Ȩ�ˣ�ǩ�֣���&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='right'>���֤�����ͣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='right'>֤�����룺&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='right'>��Ȩ���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>��Ϊ�������ĺϷ�Ȩ�棬���Ͽհ״���������д����Ȩ�������ע���̡���δ��Ȩ�������ע��������</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("</table>");
		sTemp.append("</div>");	
	
		//rs2.getStatement().close();	
	
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


