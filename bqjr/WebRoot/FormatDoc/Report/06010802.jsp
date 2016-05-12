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
	int iDescribeCount = 10;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
//***********************************************************************	
	String sGuarantyNo = "";
	ASResultSet rs2 = Sqlca.getResultSet("select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'");

	//取担保客户ID
	if(rs2.next())
	{
		sGuarantyNo = rs2.getString("GuarantyNo");
		if(sGuarantyNo == null) sGuarantyNo = "&nbsp;";
	}
	
	rs2.getStatement().close();
	
	//获得编号
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	String sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '06__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "6."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='06010802.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=28 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[j]+".8.2、或有负债分析</font></td>"); 
	sTemp.append("   </tr>");
	String sSql17 ="select getItemName('GuarantyType',GuarantyType) as GuarantyTypeName from GUARANTY_CONTRACT"+
					" where GuarantorID in (select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sGuarantyNo+"' and (RelationShip like '52%' or RelationShip like '02%'))"+
					" and ContractStatus = '020'";
	rs2 = Sqlca.getResultSet(sSql17);
	String sGuarantyTypeName = "";		//对外担保类型
	while(rs2.next())
	{
		sGuarantyTypeName +=rs2.getString(1)+" ";
	}
	rs2.getStatement().close();
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 > 对外担保</td>");
    sTemp.append("   <td colspan='12' align=left class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' rowspan='4' align=center class=td1 > 其他 </td>");
    sTemp.append("   <td colspan='6' align=center class=td1 > 主要内容 </td>");
    sTemp.append("   <td colspan='3' align=center class=td1 > 金额 </td>");
    sTemp.append("   <td colspan='3' align=center class=td1 > 期限 </td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='6' align=center class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe1' style='width:100%'",getUnitData("describe1",sData)));
	sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe2' style='width:100%'",getUnitData("describe2",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe3' style='width:100%'",getUnitData("describe3",sData)));
    sTemp.append("	 &nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='6' align=center class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe4' style='width:100%'",getUnitData("describe4",sData)));
	sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe5' style='width:100%'",getUnitData("describe5",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe6' style='width:100%'",getUnitData("describe6",sData)));
    sTemp.append("	 &nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='6' align=center class=td1 > 合计 </td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe7' style='width:100%'",getUnitData("describe7",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='9' align=left class=td1 > 或有负债总计 </td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe8' style='width:100%'",getUnitData("describe8",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 "+myShowTips(sMethod)+" >对外担保和其他或有负债分析");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:150'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='15' class=td1 "+myShowTips(sMethod)+" > 资产抵、质押情况 <br>");
	sTemp.append("   资产抵押、质押情况应调查企业以往贷款时将哪些资产做了抵押或质押，这些资产的帐面价值和评估价值是多少，包括货币资金、存货、固定资产、无形资产。");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:150'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='CustomerID' value='"+sCustomerID+"'>");
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
	editor_generate('describe9');		//需要html编辑,input是没必要
	editor_generate('describe10');		//需要html编辑,input是没必要
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>