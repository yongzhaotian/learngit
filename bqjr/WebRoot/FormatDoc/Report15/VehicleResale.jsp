<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;6:export
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
	//获得调查报告数据
	String sSql = "select CustomerID,CustomerName,BusinessType,BusinessSum "+
					" from Business_Contract where SerialNo = '"+sObjectNo+"'";

	String sCustomerID = "";//客户编号
	String sBusinessType = "";//产品编号
	String sCustomerName = "";//客户名称
	String sCertID = "";//证件号码
	String sBusinessSum = "";//贷款金额
	String sEndTime = "";//审核时间
	String BUSINESSTYPE1 = "";//商品类型1
	String BRANDTYPE1 = "";//品牌型号1
	//折后商品总价（元）
	String sPRICE1 = "";//价格（1）
	String sBUSINESSTYPE2 = "";//商品类型（2）
	String BUSINESSTYPE2 = "";//商品型号（2）
	String sBRANDTYPE2 = "";//品牌（2）
	
	
	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	String sDay = StringFunction.getToday();
	sTemp.append("	<form method='post' action='7004.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		sCustomerID = rs2.getString("CustomerID");
		sCustomerName = rs2.getString("CustomerName");
		sBusinessType = rs2.getString("BusinessType");
		sBusinessSum = DataConvert.toMoney(rs2.getString("BusinessSum"));
	}
	sCertID = Sqlca.getString("select CertID from Customer_Info where CustomerID = '"+sCustomerID+"'");
	//sEndTime = Sqlca.getString("");
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=2  >");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=center colspan=4 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;background-color:#FFFFFF' >车辆转售审批报告</font></td>");	
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		sTemp.append("<table class=table1 width='660' align=center border=0 cellspacing=0 cellpadding=2  >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td class=td1 align=left colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >客户信息</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >合同号码&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >主借人&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >尚欠金额(扣除未到期利息)&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td class=td1 align=left colspan=4 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >车辆信息</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >车辆型号&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >出厂年份&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >车牌号&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >车辆市值&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >转售价格&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >竞标价格(前5个最高价格)</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center width=7% class=td1 >序号&nbsp;</td>");
		sTemp.append("   <td align=center width=43% class=td1 >竞标人名称&nbsp;</td>");
		sTemp.append("   <td align=center width=25% class=td1 >出标价(人民币)&nbsp;</td>");
		sTemp.append("   <td align=center width=25% class=td1 >对比差(%)&nbsp;</td>");
		sTemp.append("   </tr>");
		//for循环取出相应逻辑
		for(int i = 1;i <= 5; i++){
			sTemp.append("   <tr>");
			sTemp.append("   <td align=center width=7% class=td1 >"+i+"&nbsp;</td>");
			sTemp.append("   <td align=left width=43% class=td1 >&nbsp;</td>");
			sTemp.append("   <td align=right width=25% class=td1 >&nbsp;</td>");
			sTemp.append("   <td align=right width=25% class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >摘要</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >最高出标价&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >与转售价格对比差&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >短款/盈余 (不包括转售手续费)&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 10pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >审批结果</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 >竞标人<123123>的出标价为人民币<345345345> 元，此价格为最高竞标价。 此金额经审核并做为汽车转售交易价格。</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=2  >");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=4>&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left >申请人：&nbsp;</td>");	
		sTemp.append("   <td align=left >&nbsp;</td>");	
		sTemp.append("   <td align=left >批核人：&nbsp;</td>");	
		sTemp.append("   <td align=left >&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=4 >签名：&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 ><hr style=设定样式 /></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=2 ><申请人名称>&nbsp;</td>");	
		sTemp.append("   <td align=left colspan=2 ><批核人>&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=2 ><职位>&nbsp;</td>");	
		sTemp.append("   <td align=left colspan=2 ><职位>&nbsp;</td>");	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append("   <td align=left colspan=2 ><日期>&nbsp;"+sDay+"</td>");	
		sTemp.append("   <td align=left colspan=2 ><日期>&nbsp;"+sDay+"</td>");	
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		
	sTemp.append("</div>");	
	
	rs2.getStatement().close();	
	
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

