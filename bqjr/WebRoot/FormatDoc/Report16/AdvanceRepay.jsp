<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xliu 20130322
		Tester:
		Content: 提前还款报价单
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
		
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='AdvanceRepay.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
		
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2 >	");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center colspan=100 width=100% ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'><br>深圳佰仟金融服务有限公司&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=right colspan=100 width=100% ><font style='font-size: 10pt;'>2013/05/06</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'><br>客户名称</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>中国 四川省 成都市</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>地址</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>邮政编码</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center colspan=100 width=100% ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'><br>提前还款报价<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>合同明细</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'>客户名称</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>合同号码</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>合同期限</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>还款频率：</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>合同生效日</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>利率 %</font></td>"); 
	sTemp.append("   <td align=left colspan=51 width=51% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>合同最后还款日</font></td>"); 
	sTemp.append("   <td align=left colspan=17 width=17% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>利率类型</font></td>"); 
	sTemp.append("   <td align=left colspan=51 width=51% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>车牌号码：</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'><br>应收账款</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>全部应收账款</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>免除利息总额</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;%</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>免除预付款总额</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>提前还款金额</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>逾期金额</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>罚息</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=100 width=100% ><font style='font-size: 10pt;'><br>提前还款手续费</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>杂费</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>额外费用</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;%</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>提前还款罚金</font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>补齐差额 </font></td>"); 
	sTemp.append("   <td align=left colspan=84 width=84% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 width=16% ><font style='font-size: 10pt;'>提前还款净收取金额</font></td>"); 
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
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

