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

		History Log: xhgao 2009/06/29	贷款用途检查报告（摘要），银行客户名称改为从配置信息取得
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
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
	}else{
		sButtons[0][0] = "false";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
	}
	
	String[] sName = new String[10];
	sSql = " select getCustomerName(ObjectNo) as CustomerName,"+
		" II.updatedate as updatedate,"+
		" getUserName(II.InputUserID) as InputUserName,"+
		" getOrgName(II.InputOrgID) as InputOrgName "+
		" from INSPECT_INFO II"+
		" where II.SerialNo='"+sSerialNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[0] =DataConvert.toString(rs.getString("CustomerName"));
		if(sName[0] == null) sName[0] = "";
		sName[1] =DataConvert.toString(rs.getString("InputOrgName"));
		if(sName[1] == null) sName[1] = "";
		sName[2] =DataConvert.toString(rs.getString("InputUserName"));
		if(sName[2] == null) sName[2] = "";
		sName[3] =DataConvert.toString(rs.getString("updatedate"));
		if(sName[3] == null) sName[3] = "";
	}
	rs.getStatement().close();	
	//客户信用等级
	sSql="select CreditLevel from ENT_INFO where customerid='"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sName[4]=DataConvert.toString(rs.getString("CreditLevel"));
		if(sName[4] == null) sName[4] = " ";
	}
	rs.getStatement().close();	
	//预警信号
	sSql =	" select RS1.SignalNo || '' || RS1.SignalName || '' || getItemName('SignalType',RS1.SignalType) || '' || getItemName('SignalStatus',RS1.SignalStatus) as signalName "+
			" from RISK_SIGNAL RS1 "+
			" where RS1.ObjectType = 'Customer' "+
			" and RS1.ObjectNo = '"+sObjectNo+"' "+
			" and not exists(select RelativeSerialNo from RISK_SIGNAL RS2 "+
			" where RS2.RelativeSerialNo = RS1.SerialNo "+
			" and RS2.SignalType = '02' "+ //预警类型（01：发起；02：解除）
			" and RS2.SignalStatus = '30') "+//预警状态（10：待处理；20：审批中；30：批准；40：否决）
			" and RS1.SignalType = '01' "+ 
			" and RS1.SignalStatus <> '40' ";
	rs = Sqlca.getResultSet(sSql);
	sName[5]="";
	String sTemp1 = "";
	while(rs.next()){
		sTemp1 = rs.getString("signalName");
		if(sTemp1 == null) sTemp1 = "";
		else
			sName[5] += sTemp1+"<br>";
	}
	rs.getStatement().close();	

	//风险分类级别
	sSql="select getItemname('ClassifyResult',ClassifyResult) as ClassifyResult"+
		" from BUSINESS_CONTRACT"+
		" where CustomerID = '"+sObjectNo+"' "+
		" order by ClassifyResult desc";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sName[6] = rs.getString("ClassifyResult");
	}
	if(sName[6] == null) sName[6] = "";
	rs.getStatement().close();	
	/*
	if(sName[8].indexOf(",") != -1)
	{
		HashMap Opinion=new HashMap();
		Opinion.put("1","补办手续");
		Opinion.put("2","增强担保");
		Opinion.put("3","停止新增授信或提款");
		Opinion.put("4","压缩授信");
		Opinion.put("5","全部清收");
		Opinion.put("6","提起诉讼");
		Opinion.put("7","其他");
		String[] sChecked=sName[8].split(",");
		
		sName[8]="";
		for(int j=0; j<sChecked.length; j++)
		{
			sName[8]=sName[8]+(String)Opinion.get(sChecked[j])+"<br>";
		}
	}
	*/
	//授信金额和授信余额
	String sBusinessSum = "";
	String sBalance = "";
	sSql = " select sum(BusinessSum),sum(Balance) from BUSINESS_CONTRACT "+
		   " where CustomerID = '"+sObjectNo+"'";
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
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/BusinessInspect/00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=center colspan='3' bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>"+sBankName+"</p>客户检查报告（摘要）</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% align=center class=td1 >客户名称：</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >经办机构：</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[1]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >检查人：</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[2]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=center class=td1 >报告日期：</td>");
	sTemp.append("   <td colspan=2 align=left class=td1 >"+sName[3]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=left class=td1 ><br>一、基本业务信息<br>&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 ><p>（一）信用等级</p></td>");
	sTemp.append("   <td align=left class=td1 >"+sName[4]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >（二）授信额度</td>");
	sTemp.append("   <td align=left class=td1 >"+sBusinessSum+"(元)&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >（三）授信余额</td>");
	sTemp.append("   <td align=left class=td1 >"+sBalance+"(元)&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=3 class=td1 >二、预警信号</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=3 class=td1 >"+sName[5]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
	sTemp.append("   <td colspan=3 class=td1 > 三、建议风险分类最低级别 </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=3 class=td1 >"+sName[6]+"&nbsp;</td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

