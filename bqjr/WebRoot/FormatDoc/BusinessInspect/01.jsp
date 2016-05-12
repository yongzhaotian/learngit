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

		History Log: xhgao 2009/06/29	贷款用途检查报告，银行客户名称改为从配置信息取得
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 36;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//取银行客户名称
	String sBankName = CurConfig.getConfigure("BankName");
	
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
	sSql = " select getCustomerName(ObjectNo) as CustomerName,"+
			" II.updatedate as updatedate,"+
			" getUserName(II.InputUserID) as InputUserName,"+
			" getOrgName(II.InputOrgID) as InputOrgName "+
			" from INSPECT_INFO II"+
			" where II.SerialNo='"+sSerialNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[0] =DataConvert.toString(rs.getString("CustomerName"));
		sName[1] =DataConvert.toString(rs.getString("InputOrgName"));
		sName[2] =DataConvert.toString(rs.getString("InputUserName"));
		sName[3] =DataConvert.toString(rs.getString("updatedate"));
	}
	rs.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=center colspan='2' bgcolor=#aaaaaa ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>"+sBankName+"</p>客户检查报告</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 ><strong>客户名称：</strong> </td>");
    sTemp.append("   <td width=80% align=left class=td1 >"+sName[0]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 ><strong>经办机构：</strong> </td>");
	sTemp.append("   <td align=left class=td1 >"+sName[1]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 ><strong>检查人：</strong> </td>");
	sTemp.append("   <td align=left class=td1 >"+sName[2]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 ><strong>报告日期：</strong> </td>");
	sTemp.append("   <td align=left class=td1 >"+sName[3]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br><strong>一、业务操作检查</strong></font><br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>（一）</strong>业务合规性、法律文件有效性<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>（二）</strong>保证金、抵押、质押的落实<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>（三）</strong>其他授信前提条件的落实<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>（四）</strong>贷款用途<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>（五）</strong>贷后管理要求的落实<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>（六）</strong>业务资料的完备性<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><strong>（七）</strong>近期客户联系、访问纪录<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:150'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br><strong>二、授信客户分析</strong></font><br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>（一）基本情况变动</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1、股权、资本变动和重大投资活动<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:150'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2、重要管理人员变动<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:150'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3、主营业务、主要产品变动<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:150'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4、其他重要变动<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:150'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>（二）财务状况及其变动趋势分析</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1、现金流量和还款来源分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:150'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2、重要资产、负债项目和偿债指标分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:150'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3、收入、成本、费用的构成和盈利、周转指标分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:150'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4、对外担保、资产抵押等表外事项分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:150'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;5、报表真实性、审计意见、合并范围等其他事项分析 <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:150'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>（三）经营管理和重大事项分析</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1、行业（市场）、供销渠道和产品竞争力分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:150'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2、经营管理模式和发展战略分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:150'",getUnitData("describe18",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3、人员素质和内部控制分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe19' style='width:100%; height:150'",getUnitData("describe19",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4、重大或突发事件分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe20' style='width:100%; height:150'",getUnitData("describe20",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;5、建设项目的审批、投资和工程进度情况<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe21' style='width:100%; height:150'",getUnitData("describe21",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>（四）还款意愿分析</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1、合同约定、事前承诺的履行<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe22' style='width:100%; height:150'",getUnitData("describe22",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2、其他客户诚信情况分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe23' style='width:100%; height:150'",getUnitData("describe23",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3、外部信用记录分析 <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe24' style='width:100%; height:150'",getUnitData("describe24",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><br><strong>三、担保分析</strong></font><br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>（一）质物/保证金分析</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1、质物描述和保管状况<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe25' style='width:100%; height:150'",getUnitData("describe25",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2、质物价值变动和变现难易 <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe26' style='width:100%; height:150'",getUnitData("describe26",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>（二）抵押物分析</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1、抵押物描述和保管使用状况<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe27' style='width:100%; height:150'",getUnitData("describe27",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2、抵押物价值变动和变现难易<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe28' style='width:100%; height:150'",getUnitData("describe28",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><p><strong>（三）保证人分析</strong></p></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;1、保证人基本情况及与授信客户关系<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe29' style='width:100%; height:150'",getUnitData("describe29",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;2、核保情况及保证人与我行业务合作<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe30' style='width:100%; height:150'",getUnitData("describe30",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;3、保证人的财务分析<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe31' style='width:100%; height:150'",getUnitData("describe31",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;&nbsp;4、保证人的非财务分析 <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe32' style='width:100%; height:150'",getUnitData("describe32",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p><strong>四、其他检查意见</strong></p></font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe33' style='width:100%; height:150'",getUnitData("describe33",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p><strong>五、检查结论摘要</strong></p></font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("1",sMethod,"name='describe34' style='width:100%; height:150'",getUnitData("describe34",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p><strong>六、建议采取的风险管理措施</strong></p></font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >（一）措施类别<br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe35' style='width:100%; height:150'",getUnitData("describe35",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 >（二）具体措施 <br>");
	sTemp.append(myOutPut("1",sMethod,"name='describe36' style='width:100%; height:150'",getUnitData("describe36",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><br><strong>检查人签章：</strong><br>&nbsp;&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
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
	editor_generate('describe3');		//需要html编辑,input是没必要
	editor_generate('describe4');		//需要html编辑,input是没必要   
	editor_generate('describe5');		//需要html编辑,input是没必要
	editor_generate('describe6');		//需要html编辑,input是没必要
	editor_generate('describe7');		//需要html编辑,input是没必要
	editor_generate('describe8');		//需要html编辑,input是没必要   
	editor_generate('describe9');		//需要html编辑,input是没必要
	editor_generate('describe10');		//需要html编辑,input是没必要
	editor_generate('describe11');		//需要html编辑,input是没必要
	editor_generate('describe12');		//需要html编辑,input是没必要   
	editor_generate('describe13');		//需要html编辑,input是没必要
	editor_generate('describe14');		//需要html编辑,input是没必要
	editor_generate('describe15');		//需要html编辑,input是没必要
	editor_generate('describe16');		//需要html编辑,input是没必要   
	editor_generate('describe17');		//需要html编辑,input是没必要
	editor_generate('describe18');		//需要html编辑,input是没必要
	editor_generate('describe19');		//需要html编辑,input是没必要
	editor_generate('describe20');		//需要html编辑,input是没必要   
	editor_generate('describe21');		//需要html编辑,input是没必要
	editor_generate('describe22');		//需要html编辑,input是没必要
	editor_generate('describe23');		//需要html编辑,input是没必要
	editor_generate('describe24');		//需要html编辑,input是没必要   
	editor_generate('describe25');		//需要html编辑,input是没必要
	editor_generate('describe26');		//需要html编辑,input是没必要
	editor_generate('describe27');		//需要html编辑,input是没必要
	editor_generate('describe28');		//需要html编辑,input是没必要   
	editor_generate('describe29');		//需要html编辑,input是没必要
	editor_generate('describe30');		//需要html编辑,input是没必要
	editor_generate('describe31');		//需要html编辑,input是没必要
	editor_generate('describe32');		//需要html编辑,input是没必要
	editor_generate('describe33');		//需要html编辑,input是没必要
	editor_generate('describe34');		//需要html编辑,input是没必要
	editor_generate('describe35');		//需要html编辑,input是没必要
	editor_generate('describe36');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

