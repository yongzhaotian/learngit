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
	int iDescribeCount = 1;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	String sSql = "select BusinessType from Business_Apply where serialNo = '"+sObjectNo+"'";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	String sBusinessType = "";
	if(rs2.next()) sBusinessType = rs2.getString(1);
	rs2.getStatement().close();	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='08.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7������������;</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" ><p>�����˱�����ҵ����ʽ���;���漰��ó�����ʲ�Ʒʱ����ϸ������ó�ױ������Ϸ��Ϲ��ԣ������ݲ�ͬ��ó�����ʵĴ���Ʒ�֣���ϸ������ι�ܷ��ա�</p>");
  	if(sBusinessType.equals("1020010"))
  		sTemp.append("     �жһ�Ʊ���֣�Ҫ��˵�������˺���ֱ��ǰ�ֻ��Ʊ��֮���ó�׹�ϵ��ó�ױ�ġ��������������Ƿ��н��׺�ͬ����ֵ˰��Ʊ�����˵��ݣ�����Ʊ�ĳжһ������жҽ�Ʊ�ݺ��롢�����ա�����Ʊ�Ƿ񾭱���ת�ã������Ƿ�����������Ʊ�����׺�ͬ����ֵ˰��Ʊ�ϵĽ��׺�ͬ�����Ƿ�һ�£����ڡ�����Ҫ���Ƿ�ƥ�䡣����ȱ����ֵ˰��Ʊ��ӡ���ģ�Ҫ��˵��ԭ��</p>");
  	if(sBusinessType.equals("2010") || sBusinessType.equals("1090010"))
  		sTemp.append("     �����жһ�Ʊ��Ҫ��˵�������˺��տ��˵�ó�׹�ϵ����ó�ױ�ġ��������������Ƿ��н��׺�ͬ���ջ�ƾ֤����Ҫ��жһ�Ʊ���տ��ˡ������������������Ƿ��뽻�׺�ͬһ�¡��տ��˵ľ�Ӫ��Χ�ͽ��׺�ͬ�����������Ƿ�ƥ�䡣��������ṩ�ջ�ƾ֤��Ҫ��˵�����׺�ͬĿǰ������״̬��");
  	if(sBusinessType.equals("1020010"))
  		sTemp.append("     ��������֤��Ҫ��˵�������˺�����֤�����˵�ó�׹�ϵ��ó�ױ�ġ�������������������֤�Ĺ涨��������֤�����ˡ���װ�ڡ��������Ƿ��뽻�׺�ͬһ�¡�����֤�������Ƿ�������������ʷó�׼�¼���ջ��¼�����Ϊ����֤����Ҫ���ύ�����ͬ��˵�������ϵ������Ԥ���Ԥ�������Ƿ��Ѷ���֧����");
  	if(sBusinessType.equals("1080020010") || sBusinessType.equals("1080020020") || sBusinessType.equals("1080020030"))
  		sTemp.append("     ����Ѻ�㣺Ҫ��˵�������˺ͽ��ڷ���ó�׺�ͬ��ϵ��ó�ױ�ġ��������������������ڡ��������ڣ���˵������Ѻ�����µ�����֤Ҫ�أ���֤�С���š���Ч�ڡ������������֤��ó�׺�ͬ����ҪҪ���Ƿ�ƥ�䣬�������Ƿ��Ѱ�����֤Ҫ���ṩ��ȫ�����񵥾ݣ�������ʵ���ԵĲ����㣬����֤�Ƿ����Ӱ���ջ�������������Ѻ������Ľ��������Ƿ�������֤����ƥ�䡣");
  	if(sBusinessType.equals("1080040010") || sBusinessType.equals("1080040020") || sBusinessType.equals("1080040030"))
  		sTemp.append("     ����͢��Ҫ��˵�������˺ͽ��ڷ���ó�׺�ͬ��ϵ��ó�ױ�ġ��������������������ڡ��������ڣ����˽������˺ͽ��ڷ�����Զ�ڽ��㷽ʽ��ԭ��ȷ�ϳ������Ƿ��Ѱ�����֤Ҫ���ṩ��ȫ�����񵥾ݣ�ȷ�ϵ����Ƿ�������֤һ�£���֤���Ƿ��Ѿ�ͬ�⳥������֤�����ҳж�����Ӧ��Զ��Ʊ�ݡ�");
  	if(sBusinessType.equals("1080030010") || sBusinessType.equals("1080030020"))
  		sTemp.append("     ����Ѻ�㣺Ҫ��˵�������˺ͽ��ڷ���ó�׹�ϵ�������Ƿ��Ѿ��˴�����״̬�������˺͹�����ҵ����ۺ�ͬ�����У�������Ѻ��Ľ��������Ƿ�ʹ�ó�׺�ͬ���µ��տ���ƥ�䣻ȷ�������˽���Ѻ��Ķ����������Ķ����ʽ���ͨ��������֤������֧�����Է����б��ȵ���ȷ�Ͽͻ��Ƿ�Ҫ����л�����ǣ��ͻ��Ƿ�������ǩ�������վݣ����ṩһ���ĵ��������������Ƿ���л�����ᵥ���ֵ�������������Ƿ��ױ��ʡ��Ѵ�����ױ�ֵ��");
  	if(",1080310,1080320,1090060,1090070".indexOf(sBusinessType)>0)
  		sTemp.append("     ����Ҫ��˵���������µ�Ӧ���ʿ���嵥����������Ӧ���ʿ�Ľ�ծ���ˣ����޺�Լ�������ա�������Ӧ�տ���Ľ��׺�ͬ����ֵ˰��Ʊ�ͷ���ƾ֤����������ṩ��Ҫ��˵��ԭ�򡣵�����Ӧ�տ��ծ���˵ľ�Ӫ��Χ�Ƿ�ͽ��׺�ͬ��һ�¡�������Ӧ�տ��ծ���˺������˵���ʷó�׼�¼�͸����¼��");
  	if(sBusinessType.equals("2050020010"))
  		sTemp.append("     Ͷ�걣����Ҫ���ṩ�б������飬�����б��������Ͷ�걣���Ĺ涨���˽��б귽��������ںͷ�ʽ�������б������Ƿ���������˵ľ�Ӫ��Χ��");
  	if(sBusinessType.equals("2050020020"))
  		sTemp.append("     ��Լ������Ҫ���ṩ�����ͬ�����������ͬ����Լ�����Ĺ涨���˽������ͬ���������ޡ�������Ⱥ���Ҫ�ڵ㡣���������˵����ʺ���Լ����");
  	if(sBusinessType.equals("2050020030"))
  		sTemp.append("     Ԥ�������Ҫ���ṩ�����ͬ��Ԥ�����վݡ����������ͬ��Ԥ������Ĺ涨���˽�Ԥ�����ȥ�����;�����������˵����ʺ���Լ������");

  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>