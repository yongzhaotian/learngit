<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
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
	int iDescribeCount = 30;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//判断该报告是否完成
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next()){
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null){
		sButtons[1][0] = "false";
	}else{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	String[] sName = new String[4];
	sSql = " select ObjectNo,getCustomerName(ObjectNo) as CustomerName"+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[0] = DataConvert.toString(rs.getString("ObjectNo"));
		sName[1] = DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close();
	
	//商铺地址,联系电话,家庭地址,管户客户经理
	String sRegisterAdd = "",sRelativeType = "",sOfficeAdd = "",sUserName = "";
	sSql = " select RegisterAdd,RelativeType,OfficeAdd,getUserName(InputUserID) as UserName from ENT_INFO where CustomerID = '"+sName[0]+"' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sRegisterAdd = DataConvert.toString(rs.getString("RegisterAdd"));
		sRelativeType = DataConvert.toString(rs.getString("RelativeType"));
		sOfficeAdd = DataConvert.toString(rs.getString("OfficeAdd"));
		sUserName = DataConvert.toString(rs.getString("UserName"));
	}
	rs.getStatement().close();
	
	//贷款金额,贷款余额
	String sBusinessSum = "";
	String sBalance = "";
	sSql = " select sum(BusinessSum) as BusinessSum,sum(Balance) as Balance from BUSINESS_CONTRACT where CustomerID = '"+sName[0]+"' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sBusinessSum = DataConvert.toMoney(rs.getString(1));
		if(sBusinessSum.length() == 0) sBusinessSum = "0.00";
		sBalance = DataConvert.toMoney(rs.getString(2));
		if(sBalance.length() == 0) sBalance = "0.00";
	}
	rs.getStatement().close();
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/06.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=12 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>贷后检查表</p></font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 align=left class=td1 ><font style=' font-size: 12pt;' >&nbsp;&nbsp;检查阶段：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月&nbsp;&nbsp;日至&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月&nbsp;&nbsp;日</font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=center class=td1 >客户名称</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sName[1]+"&nbsp;</td>");
    sTemp.append("   <td colspan=3 align=center class=td1 >商铺地址</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");
    sTemp.append("   </tr>");
   	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=center class=td1 >联系电话</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sRelativeType+"&nbsp;</td>");
    sTemp.append("   <td colspan=3 align=center class=td1 >家庭地址</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sOfficeAdd+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=center class=td1 >家属姓名</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >&nbsp;</td>");
    sTemp.append("   <td colspan=3 align=center class=td1 >管户客户经理</td>");
    sTemp.append("   <td colspan=3 align=left class=td1 >"+sUserName+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='15%' colspan=2 align=center class=td1 >贷款金额</td>");
    sTemp.append("   <td width='15%' colspan=2 align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append("   <td width='20%' colspan=2 align=center class=td1 >贷款余额</td>");
    sTemp.append("   <td width='15%' colspan=2 align=left class=td1 >"+sBalance+"&nbsp;</td>");
    sTemp.append("   <td width='15%' colspan=2 align=center class=td1 >担保措施</td>");
    sTemp.append("   <td width='20%' colspan=2 align=left class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 class=td1 >");
	sTemp.append("<div id=reporttable3>");	
	sTemp.append("<table width='640' align=center border=0 cellspacing=0 cellpadding=2>	");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center>资料收集：</td>");
	sTemp.append("   <td>");    
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"销售合同"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"销售流水"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"销售发票"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"租金收据"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"物业管理费收据"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"水电费收据"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td align=center>&nbsp;</td>");
	sTemp.append("   <td>");
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"手机账单"));
	sTemp.append("   	"+myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"信用查询记录"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >序号</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >检查内容</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >直接观察</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >询问了解</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >说明</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >1</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >贷款资金用途</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe28'",getUnitData("describe28",sData),"真实@挪用")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe29'",getUnitData("describe29",sData),"真实@挪用")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >2</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >是否开门正常营业</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe9'",getUnitData("describe9",sData),"是@否")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe10'",getUnitData("describe10",sData),"是@否")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >3</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >老板是否在场</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe11'",getUnitData("describe11",sData),"是@否")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe12'",getUnitData("describe12",sData),"是@否")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >4</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >工作人员数量变动</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe13'",getUnitData("describe13",sData),"增加@稳定@减少")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe14'",getUnitData("describe14",sData),"增加@稳定@减少")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >5</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >工作人员精神面貌</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe15'",getUnitData("describe15",sData),"好@一般@差")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe16'",getUnitData("describe16",sData),"好@一般@差")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >6</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >经营场所内人流数量</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe17'",getUnitData("describe17",sData),"增加@稳定@减少")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe18'",getUnitData("describe18",sData),"增加@稳定@减少")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >7</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >仓库进出是否正常</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe19'",getUnitData("describe19",sData),"是@否")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe20'",getUnitData("describe20",sData),"是@否")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >8</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >仓库存货是否合理</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe21'",getUnitData("describe21",sData),"是@否")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe22'",getUnitData("describe22",sData),"是@否")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >9</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >货款回笼情况</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe23'",getUnitData("describe23",sData),"增加@稳定@减少")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe24'",getUnitData("describe24",sData),"增加@稳定@减少")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width='5%' colspan=1 align=center class=td1 >10</td>");
    sTemp.append("   <td width='30%' colspan=2 align=center class=td1 >借款人健康状况</td>");
    sTemp.append("   <td width='30%' colspan=3 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe25'",getUnitData("describe25",sData),"好@不好")+"</td>");
    sTemp.append("   <td width='30%' colspan=4 align=center class=td1 >"+myOutPutCheck("3",sMethod,"name='describe26'",getUnitData("describe26",sData),"好@不好")+"</td>");
    sTemp.append("   <td width='5%' colspan=2 align=center class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 align=left class=td1 >担保（抵押、质押、保证）情况分析：<br />"+myOutPut("2",sMethod,"name='describe30' style='width:700; height:80'",getUnitData("describe30",sData)));
    sTemp.append("   </tr>");    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=12 align=left class=td1 >检查人意见：<br />"+myOutPut("2",sMethod,"name='describe27' style='width:700; height:80'",getUnitData("describe27",sData))+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签名：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月&nbsp;&nbsp;日</td>");
    sTemp.append("   </tr>");
    sTemp.append("	<tr>");
  	sTemp.append(" 		<td align=left colspan=6 class=td1 >");
  	sTemp.append("        业务部经理意见：<br /><br /><br /><br />签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月&nbsp;&nbsp;日");
  	sTemp.append(" 		</td>");
  	sTemp.append(" 		<td align=left colspan=6 class=td1 >");
  	sTemp.append("        负责人意见：<br /><br /><br /><br />签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;月&nbsp;&nbsp;日");
  	sTemp.append(" 		</td>");
    sTemp.append(" 	</tr>");
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
	editor_generate('describe27');		//需要html编辑,input是没必要
	editor_generate('describe30');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

