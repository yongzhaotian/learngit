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
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	
	String sRelationName = "";
	String sCustomerName = "";
	String sHoldDate = "";
	String sEngageTerm = "";
	String sEduExperience = "";
	String sHoldStock = "";	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0401.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4、申请人管理能力分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan='6' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.1、管理层分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width=16% align=center class=td1 > 职位 </td>");
	sTemp.append("   <td width=18% align=center class=td1 > 姓名 </td>");
	sTemp.append("   <td width=20% align=center class=td1 > 担任该职务时间 </td>");
	sTemp.append("   <td width=22% align=center class=td1 > 相关行业从业年限</td>");
	sTemp.append("   <td width=12% align=center class=td1 > 学历 </td>");
	sTemp.append("   <td width=12% align=center class=td1 > 持股情况 </td>");
	sTemp.append("   </tr>");
	String sSql = "select  getItemName('RelationShip',RelationShip) as RelationName,"
				   +"CustomerName,HoldDate,EngageTerm,EduExperience,HoldStock "
                   +"from CUSTOMER_RELATIVE "
                   +"where CustomerID='"+sCustomerID+"' "
                   +"and RelationShip in('0100','01020','01030')";
                   
    ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sRelationName = rs2.getString(1);
		if(sRelationName == null) sRelationName=" ";
		sCustomerName = rs2.getString(2);
		if(sCustomerName == null) sCustomerName=" ";
		sHoldDate = rs2.getString(3);
		if(sHoldDate == null) sHoldDate=" ";
		sEngageTerm = rs2.getString(4);
		if(sEngageTerm == null) sEngageTerm=" ";
		sEduExperience = rs2.getString(5);
		if(sEduExperience == null) sEduExperience=" ";
		sHoldStock = rs2.getString(6);
		if(sHoldStock == null) sHoldStock=" ";
		sTemp.append("   <tr>");
		sTemp.append("   <td width=16% align=center class=td1 nowrap>"+sRelationName+"&nbsp;</td>");
		sTemp.append("   <td width=18% align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td width=20% align=center class=td1 >"+sHoldDate+"&nbsp;</td>");
		sTemp.append("   <td width=22% align=center class=td1 >"+sEngageTerm+"&nbsp;</td>");
		sTemp.append("   <td width=12% align=center class=td1 >"+sEduExperience+"&nbsp;</td>");
		sTemp.append("   <td width=12% align=center class=td1 >"+sHoldStock+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs2.getStatement().close();	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=6 align=left class=td1 "+myShowTips(sMethod)+" > <p>通过以下五个方面进行描述：</p>");
  	sTemp.append("     <p>1、高级管理层的经验，如领导能力、专业水平、管理经验、开拓创新能力；</p>");
  	sTemp.append("     <p>2、高级管理层过往诚信状况及经营业绩；</p>");
  	sTemp.append("     <p>3、在其他企业的兼职情况；</p>");
  	sTemp.append("     <p>4、管理层稳定性、近期有无重大人事变动等；</p>");
  	sTemp.append("     5、职工素质评价。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=6 align=left class=td1 >");
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
	editor_generate('describe1');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>