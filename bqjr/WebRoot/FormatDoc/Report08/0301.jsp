<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第?页
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
	int iDescribeCount = 4;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringTokenizer stx = null;
	stx = new StringTokenizer(sAttribute,",");
	String sDirID = "",sDirID1 = "",sDirID2 = "",sDirID3 = "",sDirID4 = "";
	while(stx.hasMoreTokens())
	{
		sDirID = stx.nextToken();
		if(sDirID.equals("0301")) sDirID1 = "true";
		if(sDirID.equals("0302")) sDirID2 = "true";
		if(sDirID.equals("0303")) sDirID3 = "true";
		if(sDirID.equals("0304")) sDirID4 = "true";
	}
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	if(sMethod.equals("4") && sDirID1.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3 申请人经营情况分析</font></td>"); 	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1、申请人历史沿革和经营战略</font></td>"); 	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" >描述申请人历史沿革、产权结构演变及历年经营战略方向的重大调整及内容。");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(sMethod.equals("1") || sMethod.equals("2") || sMethod.equals("3"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3 申请人经营情况分析</font></td>"); 	
		sTemp.append("   </tr>");
		if(sDirID1.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1、申请人历史沿革和经营战略(必填)</font></td>"); 	
			sTemp.append("   </tr>");
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1、申请人历史沿革和经营战略</font></td>"); 	
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" >描述申请人历史沿革、产权结构演变及历年经营战略方向的重大调整及内容。");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	} 
	
	if(sMethod.equals("4") && sDirID2.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2、申请人所处行业分析</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 根据所处行业，对行业进行宏观分析。说明国家对此行业的政策方针导向，分析申请人的行业地位和产品特性，国家行业、产业政策和我行信贷政策是否支持；");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(sMethod.equals("1") || sMethod.equals("2") || sMethod.equals("3"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID2.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2、申请人所处行业分析(必填)</font></td>"); 	
			sTemp.append("   </tr>");
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2、申请人所处行业分析</font></td>"); 	
			sTemp.append("   </tr>");
		}	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 根据所处行业，对行业进行宏观分析。说明国家对此行业的政策方针导向，分析申请人的行业地位和产品特性，国家行业、产业政策和我行信贷政策是否支持；");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	
	if(sMethod.equals("4") && sDirID3.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3、申请人经营情况分析 </font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" ><p>通过以下几个方面对申请人经营情况进行描述：</p>");
	  	sTemp.append("     <p>1、企业规模、主营业务；</p>");
	  	sTemp.append("     <p>2、生产设备、技术水平的先进性分析；如是生产类企业，进行研发能力分析；</p>");
	  	sTemp.append("     <p>3、企业竞争能力分析</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;A主要竞争对手的市场份额、竞争优势等；</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;B本企业的核心竞争优势，并与主要竞争对手相比较；</p>");
	  	sTemp.append("     &nbsp;&nbsp;&nbsp;&nbsp;C对于一般规模企业，如无法提供具体竞争对手、市场排名等信息，则应着重分析申请人的经营特色和在该行业中的核心竞争力。");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(!sMethod.equals("4"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID3.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3、申请人经营情况分析(必填) </font></td>"); 	
			sTemp.append("   </tr>");	
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3、申请人经营情况分析 </font></td>"); 	
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" ><p>通过以下几个方面对申请人经营情况进行描述：</p>");
	  	sTemp.append("     <p>1、企业规模、主营业务；</p>");
	  	sTemp.append("     <p>2、生产设备、技术水平的先进性分析；如是生产类企业，进行研发能力分析；</p>");
	  	sTemp.append("     <p>3、企业竞争能力分析</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;A主要竞争对手的市场份额、竞争优势等；</p>");
	  	sTemp.append("     <p>&nbsp;&nbsp;&nbsp;&nbsp;B本企业的核心竞争优势，并与主要竞争对手相比较；</p>");
	  	sTemp.append("     &nbsp;&nbsp;&nbsp;&nbsp;C对于一般规模企业，如无法提供具体竞争对手、市场排名等信息，则应着重分析申请人的经营特色和在该行业中的核心竞争力。");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	
	if(sMethod.equals("4") && sDirID4.equals("true"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.4、申请人经营模式分析</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 分析申请人生产、经营模式，如生产型企业的原材料是否进口、产品是否出口、是否来料加工、是否代工生产；贸易型企业是否特许经营、连锁经营、是否开展进出口贸易等。");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
	else if(!sMethod.equals("4"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID4.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.4、申请人经营模式分析(必填)</font></td>"); 	
			sTemp.append("   </tr>");	
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.4、申请人经营模式分析</font></td>"); 	
			sTemp.append("   </tr>");	
		}
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 分析申请人生产、经营模式，如生产型企业的原材料是否进口、产品是否出口、是否来料加工、是否代工生产；贸易型企业是否特许经营、连锁经营、是否开展进出口贸易等。");
	  	sTemp.append("   </td>");
	    sTemp.append("   </tr>");
	    sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 >");
	  	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	  	sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
	    sTemp.append("   </tr>");
		sTemp.append("</table>");
	}
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
	//客户化3
	var config = new Object();    
	editor_generate('describe1');		//需要html编辑,input是没必要
	editor_generate('describe2');
	editor_generate('describe3');
	editor_generate('describe4');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
