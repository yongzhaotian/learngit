<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xliu 20130322
		Tester:
		Content: 车辆转售审批报告
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
	sTemp.append("	<form method='post' action='CarReport.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
		
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2 >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=center colspan=100 width=100% ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;'><br>车辆转售审批报告<br>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("</table>");	
	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >客户信息</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >合同号码</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >主借人</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >尚欠金额(扣除未到期利息)</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");	
	
	sTemp.append("</br>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >车辆信息</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >车辆型号:</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >出厂年份</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >车牌号</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >车辆市值</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >转售价格</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");	
	
	sTemp.append("</br>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >竞标价格(前5个最高价格)</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 width=10% >序号</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=28 width=28% >竞标人名称</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >出标价(人民币)</td>"); 
	sTemp.append("   <td class=td1 align=left colspan=31 width=31% >对比差(%)</td>");
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
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >摘要</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >最高出标价</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >与转售价格对比差:</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=40 width=40% >短款/盈余 (不包括转售手续费):</td>"); 	
	sTemp.append("   <td class=td1 align=left colspan=60 width=60% >&nbsp;</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");
	
	sTemp.append("</br>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% bgcolor=#aaaaaa ><font style='FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >审批结果</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=100 width=100% >竞标人&lt;XXXX&gt;的出标价为人民币&lt;xxxxx&gt;元，此价格为最高竞标价。 此金额经审核并做为汽车转售交易价格。</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("</table>");
	
	sTemp.append("</br>");
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2 >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>申请人:</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>批核人:</font></td>"); 	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>签名：</font></td>"); 	
	sTemp.append("   <td align=left colspan=80 width=80% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=80 width=80% >________________________________________</td>"); 
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;申请人名称&gt;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;批核人&gt;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;职位&gt;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;职位&gt;</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td align=left colspan=20 width=20% ><font style='font-size: 10pt;'>&nbsp;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;日期&gt;</font></td>"); 	
	sTemp.append("   <td align=left colspan=40 width=40% ><font style='font-size: 10pt;'>&lt;日期&gt;</font></td>"); 	
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

