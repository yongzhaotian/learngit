<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   tangyb  2015/5/20
		Content: 无预约现金贷《个人征信授权书》打印页面
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
		Output param:

		History Log: 
	 */
	 	String PG_TITLE = "个人征信查询授权书"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;个人征信查询授权书&nbsp;&nbsp;"; //默认的内容区标题
	%>
<%/*~END~*/%>

<%
	//int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化3
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//获得调查报告数据
	//String sSql = "select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'";
	//String sCustomerID = Sqlca.getString(sSql);
	//获取对应数据
	//String sCustomerName = Sqlca.getString("select CustomerName from Business_Contract where SerialNo = '"+sObjectNo+"'");
	//ASResultSet rs2 = Sqlca.getResultSet(sSql);
	//sSql = "select CustomerName,";
	
	//rs2.getStatement().close();	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=个人征信授权书;]~*/%>
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
		sTemp.append("<td align='center'><h2>个人征信查询授权书</h2></td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>哈尔滨银行_________________________：</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>");
		sTemp.append("<p style='font-size: 12pt; line-height: 30pt'>");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;本人授权贵行在办理以下业务时，可以向金融信用信息基础数据库查询本人信用报告，并将包括本人的个人基本信息、信贷交易信息等相关信息向金融信用信息基础数据库报送：");
		sTemp.append("</p>");
		sTemp.append("</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;审核贷款申请；</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;审核贷记卡、准贷记卡申请；</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;审核本人作为担保人；</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;对已发放的个人信贷进行贷后风险管理；</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;受理法人或其他组织的贷款申请或其作为担保人，需要查询其法定代表人及出资人信用状况；</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;异议核查；</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;发展特约商户进行实名审核。</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;授权查询期限为：业务申请日至业务终结日；</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;被授权人超出授权查询的一切后果及法律责任由被授权人承担。</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;授权人知悉并理解授权条款的内容，特此授权。</td>");
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
		sTemp.append("<td align='right'>授权人（签字）：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='right'>身份证件类型：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='right'>证件号码：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='right'>授权日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("</tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr><td>&nbsp;</td></tr>");
		sTemp.append("<tr>");
		sTemp.append("<td align='left'>（为保护您的合法权益，以上空白处请完整填写；授权条款请标注“√”，未授权条款请标注“×”）</td>");
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
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>


