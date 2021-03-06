<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   fhuang  2006.01.09
		Tester:
		Content: 中小企业调查报告
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
<%
	//获得调查报告数据
	String sDate = StringFunction.getToday();
	String sYear = sDate.substring(0,4);
	int iYear = Integer.parseInt(sYear);
	String sYearN = String.valueOf(iYear - 1)+"/12";
	String sYearN_1 = String.valueOf(iYear - 1)+"/01";
	String sSql = "select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
		  		+" where reportdate = '"+sYearN_1+"' and objectno = '"+sCustomerID+"' and ReportName ='现金流量表') and RowSubject = '813'";
	String sValue = "";
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sValue = DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();	
	String sRowName[] = {"810","811","812","813"};
	String sCol2Value[]={"","","",""};
	sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where reportdate = '"+sYearN+"' and objectno = '"+sCustomerID+"' and ReportName ='现金流量表')";
	
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("RowSubject");
		if(RowName.equals(sRowName[0])) sCol2Value[0]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[1])) sCol2Value[1]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[2])) sCol2Value[2]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[3])) sCol2Value[3]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0307.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.7、现金流量分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr align=center>");
  	sTemp.append("   <td width=10% class=td1 > 年份 </td>");
	sTemp.append("   <td width=18% class=td1 > 期初现金 </td>");
	sTemp.append("   <td width=18% class=td1 > 经营现金流量 </td>");
	sTemp.append("   <td width=18% class=td1 > 投资现金流量 </td>");
	sTemp.append("   <td width=18% class=td1 > 筹资现金流量 </td>");
	sTemp.append("   <td width=18% class=td1 > 期末现金 </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=10% align=center class=td1 >"+(iYear-1)+"&nbsp;</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sValue+"&nbsp;</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sCol2Value[0]+"&nbsp;</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sCol2Value[1]+"&nbsp;</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sCol2Value[2]+"&nbsp;</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sCol2Value[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=6 align=left class=td1 "+myShowTips(sMethod)+" > 分析该申请人的现金流");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=6 align=left class=td1 "+myShowTips(sMethod)+" ><p>1、未来现金流量预测：</p>");
  	sTemp.append("     2、另外须重点预测并分析该申请人贷款到期日的现金流情况。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=6 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
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
	//客户化3
	var config = new Object();    
	editor_generate('describe1');		//需要html编辑,input是没必要
	editor_generate('describe2');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>