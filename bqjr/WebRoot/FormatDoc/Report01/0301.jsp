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
	int iDescribeCount = 2;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%!
	//获得机构所在的分行
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString("select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"'");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		}
		return sOrgID;
	}
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	String sOrgID = getBranchOrgID(CurOrg.getOrgID(),Sqlca);
	String sDefaultValue = "",sDirID1 = "false",sDirID2 = "false";
	String sSql = "select DefaultValue from FORMATDOC_PARA where orgid = '"+sOrgID+"' and docid = '"+sDocID+"'"; 
	ASResultSet rs2 = Sqlca.getASResultSet(sSql);
	if(rs2.next()) sDefaultValue = rs2.getString(1);
	rs2.getStatement().close();
	StringTokenizer stx = null;
	stx = new StringTokenizer(sDefaultValue,",");
	String sDirID = "";
	while(stx.hasMoreTokens())
	{
		sDirID = stx.nextToken();
		if(sDirID.equals("0301")) sDirID1 = "true";
		if(sDirID.equals("0302")) sDirID2 = "true";
	}
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	if(sMethod.equals("4") && sDirID1.equals("true"))
	{	
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1、申请人所处行业分析</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 根据所处行业，对行业进行宏观分析。说明国家对此行业的政策方针导向，分析申请人的行业地位和产品特性，国家行业、产业政策和我行信贷政策是否支持；");
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
	else if(!sMethod.equals("4"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID1.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1、申请人所处行业分析(必填)</font></td>"); 	
			sTemp.append("   </tr>");	
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.1、申请人所处行业分析</font></td>"); 	
			sTemp.append("   </tr>");	
		}
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 根据所处行业，对行业进行宏观分析。说明国家对此行业的政策方针导向，分析申请人的行业地位和产品特性，国家行业、产业政策和我行信贷政策是否支持；");
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
		sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2、申请人经营管理分析</font></td>"); 	
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 根据目前申请人的经营状况，说明该公司的经营管理状况是否与前次授信时相比发生较大变化。");
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
	else if(!sMethod.equals("4"))
	{
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		if(sDirID2.equals("true"))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2、申请人经营管理分析(必填)</font></td>"); 	
			sTemp.append("   </tr>");
		}
		else
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.2、申请人经营管理分析</font></td>"); 	
			sTemp.append("   </tr>");
		}	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" > 根据目前申请人的经营状况，说明该公司的经营管理状况是否与前次授信时相比发生较大变化。");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
