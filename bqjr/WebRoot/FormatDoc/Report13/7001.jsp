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
	String sCustomerName = "";
	String sCustomerID="";
	String sCommAdd="";
	String sEmailCountryside="";
	String sEmailStreet="";
	String sEmailPlot="";
	String sEmailRoom="";
	String sCommAddName = "";
		
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//��õ��鱨������
	String sSql = "select CustomerID,CustomerName from Business_Contract where SerialNo = '"+sObjectNo+"'";
	//��ȡ��Ӧ����

	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
	 sCustomerID = rs2.getString("CustomerID");
	 sCustomerName = rs2.getString("CustomerName");
	 
	 if(sCustomerID == null) sCustomerID="&nbsp;";
	 if(sCustomerName == null) sCustomerName="&nbsp;";

	}
	rs2.getStatement().close();	
	
	String path = request.getContextPath(); 
	String basePath = request.getScheme() + "://"  + request.getServerName() + ":" + request.getServerPort() + path + "/"; 
	
	String sSql3 = "SELECT ii.commadd,getItemName('AreaCode',ii.CommAdd) as CommAddName,ii.emailcountryside,ii.emailstreet,ii.emailplot,ii.emailroom FROM ind_info ii where CustomerID='"+sCustomerID+"'";
	ASResultSet rs3 = Sqlca.getResultSet(sSql3);
	if(rs3.next()){
		sCommAdd  =rs3.getString("CommAdd");
		sEmailCountryside  =rs3.getString("EmailCountryside");
		sEmailStreet  =rs3.getString("EmailStreet");
		sEmailPlot  =rs3.getString("EmailPlot");
		sEmailRoom  =rs3.getString("EmailRoom");
		sCommAddName = rs3.getString("CommAddName");

		 if(sCommAdd == null) sCommAdd="&nbsp;";
		 if(sEmailCountryside == null) sEmailCountryside="&nbsp;";
		 if(sEmailStreet == null) sEmailStreet="&nbsp;";
		 if(sEmailPlot == null) sEmailPlot="&nbsp;";
		 if(sEmailRoom == null) sEmailRoom="&nbsp;";
		 if(sCommAddName == null) sCommAddName="&nbsp;";
		 

	}

	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='7001.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
		sTemp.append("<table  width=640 align=center border='0' cellspacing='0' cellpadding='2'  >	");
		sTemp.append("   <td align=right colspan=4  ></td>");

		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left  ><img src='"+sWebRootPath+"/FormatDoc/Images/121.jpg' /></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=right  > <img src="+request.getContextPath()+"/barcode?msg="+sObjectNo+"&height=7 width='150' height='50' />&nbsp;</td>");
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
		sTemp.append("   <td align=left colspan=4  >"+sCommAdd+"&nbsp;�ʱ�</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >"+sCommAddName+""+sEmailCountryside+""+sEmailStreet+""+sEmailPlot+""+sEmailRoom+"</td>");
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
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >�𾴵Ŀͻ�&nbsp;"+sCustomerName+"&nbsp;����/Ůʿ��</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >&nbsp;&nbsp;&nbsp;���ĺ�ͬ��Ϊ&nbsp;"+sObjectNo+"&nbsp;�Ĵ����Ѿ����塣</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("   <td align=right colspan=4  >���ڰ�Ǫ���ڷ������޹�˾<br><br>"+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
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

