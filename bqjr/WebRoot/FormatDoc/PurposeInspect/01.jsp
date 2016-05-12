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
	int iDescribeCount = 3;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeIIHeader.jsp"%>

<%
	//取银行客户名称
	String sBankName = CurConfig.getConfigure("BankName");
	
	//判断该报告是否完成
	String sSql="select finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	String FinishFlag = "";
	if(rs.next())
	{
		FinishFlag = rs.getString("finishdate");			
	}
	rs.getStatement().close();
	if(FinishFlag == null)
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
	}
	else
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "true";
		sButtons[2][0] = "false";
	}
	
	String[] sName = new String[4];
	
	sSql =  " select BC.CustomerName as CustomerName,"+
		    " II.updatedate as updatedate,"+
			" getUserName(II.InputUserID) as InputUserName,"+
			" getOrgName(II.InputOrgID) as InputOrgName "+
			" from INSPECT_INFO II,BUSINESS_CONTRACT BC"+
			" where II.SerialNo='"+sSerialNo+"'"+
			" and II.ObjectNo=BC.SerialNo"+
			" and II.ObjectType='"+sObjectType+"'";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sName[0] =(String)rs.getString("CustomerName");
		sName[1] =(String)rs.getString("InputOrgName");
		sName[2] =(String)rs.getString("InputUserName");
		sName[3] =(String)rs.getString("updatedate");
	}
	rs.getStatement().close();	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='"+sWebRootPath+"/FormatDoc/PurposeInspect/01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=center colspan='7' bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><p>"+sBankName+"</p>贷款用途检查报告</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=2 width=15% align=center class=td1 >客户名称：</td>");
	sTemp.append("   <td colspan=5 align=left class=td1 >"+sName[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >经办机构：</td>");
	sTemp.append("   <td colspan=5 align=left class=td1 >"+sName[1]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >检查人：</td>");
	sTemp.append("   <td colspan=5 align=left class=td1 >"+sName[2]+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=2 align=center class=td1 >报告日期：</td>");
	sTemp.append("   <td colspan=5 align=left class=td1 >"+sName[3]+"&nbsp;</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa ><br><strong>一、客户申请的贷款用途和提供合同、发票等证明文件</strong><br>&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >"+getUnitData("describe1",sData)+"<br>&nbsp;<br>&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=19 bgcolor=#aaaaaa ><br><strong>二、提款记录</strong><br>&nbsp;</td>"); 	
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width=10% align=center class=td1 >序号</td>");
    sTemp.append("   <td colspan=2 width=15% align=center class=td1 > 日期 </td>");
    sTemp.append("   <td width=20% align=center class=td1 > 金额（元） </td>");
    sTemp.append("   <td width=19% align=center class=td1 > 入账账号 </td>");
    sTemp.append("   <td colspan=2 width=36% align=center class=td1 > 入账客户名称 </td>");
    sTemp.append("   </tr>");
    sSql = " select ItemDate,ItemSum,AccountNo,CustomerName from inspect_detail where ItemType='01' and SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' order by ItemDate";
	rs = Sqlca.getResultSet(sSql);
	int j = 1;
	String sSum = "";
	String sAccountNo = "";
	String sItemName = "";
	String sDescribe = "";
	String sDate = "";	
	while(rs.next())
	{
		sSum = DataConvert.toMoney(rs.getDouble(2));
		
		sAccountNo = rs.getString(3);
		if(sAccountNo == null) sAccountNo = "";
		
		sItemName = rs.getString(4);
		if(sItemName == null) sItemName = "";
		
		sDate = rs.getString(1);
		if(sDate == null) sDate = "";
		
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >"+j+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sDate+"&nbsp;</td>");
		sTemp.append("   <td align=right class=td1 >"+sSum+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sItemName+"&nbsp;</td>");
	    sTemp.append("   </tr>");
	    
	    j++;
    }
    rs.getStatement().close();
    
    if(j == 1)
    {
    	sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   </tr>");
    }
    
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=19 bgcolor=#aaaaaa ><br><strong>三、用款记录 </strong><br>&nbsp;</td>"); 	
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td width=10% align=center class=td1 >序号</td>");
    sTemp.append("   <td colspan=2 width=15% align=center class=td1 > 日期 </td>");
    sTemp.append("   <td width=20% align=center class=td1 > 金额（元） </td>");
    sTemp.append("   <td width=19% align=center class=td1 > 摘要代码 </td>");
    sTemp.append("   <td width=18% align=center class=td1 > 对方账号 </td>");
    sTemp.append("   <td width=18% align=center class=td1 > 对方用户名 </td>");
    
    sSql="select ItemSum,ItemAccountNO,ItemName,ItemDescribe,ItemDate from inspect_detail where ItemType='02' and SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
	rs = Sqlca.getResultSet(sSql);
	j = 1;
	while(rs.next())
	{
		sSum = DataConvert.toMoney(rs.getDouble(1));
		
		sAccountNo = rs.getString(2);
		if(sAccountNo == null) sAccountNo = "";
		
		sItemName = rs.getString(3);
		if(sItemName == null) sItemName = "";
		
		sDescribe = rs.getString(4);
		if(sDescribe == null) sDescribe = "";
		
		sDate = rs.getString(5);
		if(sDate == null) sDate = "";
		
	    sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >"+j+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sDate+"&nbsp;</td>");
		sTemp.append("   <td align=right class=td1 >"+sSum+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >"+sDescribe+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >"+sAccountNo+"&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >"+sItemName+"&nbsp;</td>");
	    sTemp.append("   </tr>");
	    
	    j++;
    }
    rs.getStatement().close();
    
    if(j == 1)
    {
    	sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   </tr>");
    }
    
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 bgcolor=#aaaaaa ><br><strong>四、实际用途及其合理性分析</strong><br>&nbsp;</td>");
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >"+getUnitData("describe2",sData)+"<br>&nbsp;<br>&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=7 class=td1 bgcolor=#aaaaaa ><br><strong>五、建议采取措施</strong><br>&nbsp;</td>");
	sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 >"+getUnitData("describe3",sData)+"<br>&nbsp;<br>&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><br><strong>检查人签章：</strong><br>&nbsp;&nbsp;</td>");
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

