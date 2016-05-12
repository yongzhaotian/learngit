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
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log:  xhgao 2009/06/29	银行客户名称改为从配置信息取得
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//取银行客户名称
	String sBankName = CurConfig.getConfigure("BankName");
	
	//获得调查报告数据
	String sSql = "select CustomerID,CustomerName,getBusinessName(BusinessType) as BusinessTypeName,BusinessType,"+
				" getItemname('YesOrNo',ContractFlag) as ContractFlag,TermMonth,BailRatio,"+
				" getItemName('Currency',BusinessCurrency) as CurrencyName,BusinessSum,"+
				" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BusinessRate,PdgRatio,"+
				" getItemName('VouchType',VouchType) as VouchType,remark,getOrgName(InputOrgID) as OrgName "+
				" from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessType = "";
	String sCreditType = "";
	String sOrgName = "";
	String sUserName = "";
	String sContractFlag = "";
	String sRemark = "";
	String sCurrencyName = "";		    //币种
	String sBusinessSum = "";			//总额度
	String sBusinessRate = "";			//利/费率
	String sClassifyResult = "";		//五级分类
	String sBailRatio = "";
	String sTermMonth = "";
	String sVouchType = "";
	String sCreditLevel = "";
	String sPdgRatio = "";
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) 
	{
		sCustomerID = rs2.getString("CustomerID");
		if(sCustomerID == null) sCustomerID ="";
		
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName ="";
		
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType="";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName="";
		
		sContractFlag = rs2.getString("ContractFlag");
		if(sContractFlag == null)sContractFlag ="";
		
		sRemark = rs2.getString("Remark");
		if(sRemark == null) sRemark="";
		
		sCreditType = rs2.getString("BusinessTypeName");
		if(sCreditType == null) sCreditType="";
		
		sCurrencyName = rs2.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName="";
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(6);
        sBusinessSum = nf.format(rs2.getDouble("BusinessSum")/10000);
        
        NumberFormat nf1 = NumberFormat.getInstance();
        nf1.setMinimumFractionDigits(4);
        nf1.setMaximumFractionDigits(4);
		sBusinessRate = nf1.format(rs2.getDouble("BusinessRate"));
		
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));
		
		sPdgRatio = nf1.format(rs2.getDouble("PdgRatio"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if( sClassifyResult== null) sClassifyResult="";
		
		sTermMonth = DataConvert.toMoney(rs2.getDouble("TermMonth"));
		
		sVouchType = rs2.getString("VouchType");
		if( sVouchType== null) sVouchType="";
		
		sOrgName = rs2.getString("OrgName");
		if(sOrgName == null) sOrgName = "";
		
	}
	rs2.getStatement().close();	
	//审查意见
	sSql = "select PhaseOpinion,getUserName(UserID) as UserName,BeginTime,getItemName('ClassifyResult',Phaseopinion1),Phaseopinion2,getItemName('YesOrNo',Phaseopinion3) from FLOW_TASK where SerialNo = '"+sSerialNo+"'";
	String sPhaseOpinion = "";
	String sBeginTime = "";
	String sPhaseOpinion1 = "";
	String sPhaseOpinion2 = "";
	String sPhaseOpinion3 = "";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) 
	{
		sPhaseOpinion = rs2.getString(1);
		if(sPhaseOpinion == null) sPhaseOpinion = "";	
		
		sUserName = rs2.getString(2);
		if(sUserName == null) sUserName = "";
		
		sBeginTime = rs2.getString(3);
		if(sBeginTime == null) sBeginTime = "";
		
		sPhaseOpinion1 = rs2.getString(4);
		if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
		
		sPhaseOpinion2 = rs2.getString(5);
		if(sPhaseOpinion2 == null) sPhaseOpinion2 = "";
		
		sPhaseOpinion3 = rs2.getString(6);
		if(sPhaseOpinion3 == null) sPhaseOpinion3 = "";
	}
	rs2.getStatement().close();	
	//信用等级
	sSql = "select getItemName('CreditLevel',CreditLevel) from ENT_INFO where CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) 
	{
		sCreditLevel = rs2.getString(1);
		if(sCreditLevel == null) sCreditLevel = "";
	}
	rs2.getStatement().close();	
	//担保信息
	sSql = 	"select getItemName('GuarantyType',GuarantyType) from GUARANTY_CONTRACT " +
			" where serialno in " +
			"  (select objectno  from apply_relative "+
			"  where objecttype='GUARANTY_CONTRACT' and serialno='"+sObjectNo+"') group by GuarantyType";
	String sGuarantyType = " ";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantyType += DataConvert.toString(rs2.getString(1))+" ";
	}
	if(sGuarantyType.length()<=1) sGuarantyType = "信用";
	rs2.getStatement().close();
	//保证人
	sSql =  "select GuarantorName,getItemName('GuarantyType',GuarantyType) from GUARANTY_CONTRACT " +
			" where serialno in " +
			"  (select objectno  from apply_relative "+
			"    where objecttype='GUARANTY_CONTRACT' and serialno='"+sObjectNo+"') "+
			" and guarantytype like '010%' order by GuarantyType";
	String sGuarantorName = "&nbsp;";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sGuarantorName += rs2.getString(1)+"<br>";
	}
	
	rs2.getStatement().close();		
	//抵质押物名称
	sSql  = "select getItemName('GuarantyList',GuarantyType) from GUARANTY_INFO where objectno in ( " +
			"select serialno from GUARANTY_CONTRACT " +
			" where serialno in " +
			"  (select objectno  from apply_relative "+
			"    where objecttype='GUARANTY_CONTRACT' and serialno='"+sObjectNo+"') " +
			" and guarantytype in ('050','060'))";
	rs2 = Sqlca.getResultSet(sSql);
	String sGuarantyName = "";
	while(rs2.next()) 
	{
		sGuarantyName = rs2.getString(1);
		if(sGuarantyName == null) sGuarantyName = "";
		else sGuarantyName += "&nbsp;&nbsp;";
	}
	rs2.getStatement().close();	
	//表内业务余额
	sSql = "select getitemname('Currency',businesscurrency),sum(balance) "+ 
		   "from BUSINESS_CONTRACT where customerid = '"+sCustomerID+"' "+ 
		   "and OffSheetFlag in ('EntOn','IndOn') "+
		   "and balance >0 and (finishdate = ' ' or finishdate is null) group by businesscurrency";
	rs2 = Sqlca.getResultSet(sSql);
	String bnBalance = "&nbsp;";
	while(rs2.next())
	{
		bnBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}
	rs2.getStatement().close();	
	//表外业务敞口
	sSql = "select getitemname('Currency',businesscurrency),sum(balance-nvl(bailsum,0)) as balance "+ 
		   "from BUSINESS_CONTRACT where customerid = '"+sCustomerID+"' and OffSheetFlag in ('EntOff','IndOff') "+
		   "and balance >0 and (finishdate = ' ' or finishdate is null) group by businesscurrency ";
	rs2 = Sqlca.getResultSet(sSql);
	String bwBalance = "&nbsp;";
	while(rs2.next())
	{
		if(rs2.getDouble(2)>0)
			bwBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
		else
			bwBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+0+"<br>"; 
	}
	rs2.getStatement().close();	
	//当前后四类金额
	sSql = "select getitemname('Currency',businesscurrency),sum(balance) from BUSINESS_CONTRACT where customerid = '"+sCustomerID+"' "+ 
		   "and classifyresult  in ('02','03','04','05') and balance >0 and (finishdate = ' ' or finishdate is null) group by businesscurrency";
	rs2 = Sqlca.getResultSet(sSql);
	String sOtherBalance = "&nbsp;";
	while(rs2.next())
	{
		sOtherBalance += rs2.getString(1)+"&nbsp;&nbsp;&nbsp;"+DataConvert.toMoney(rs2.getString(2))+"<br>"; 
	}
	rs2.getStatement().close();	
	/*
	if(sBusinessTypeName.equals("授信额度") || sBusinessTypeName.equals("商业承兑汇票保贴"))
	{
		sBusinessTypeName = "综合授信额度";
	}
	else if(sContractFlag.equals("否")) 
	{
		sBusinessTypeName = "单笔单批";
	}
	else if(sContractFlag.equals("是"))
	{
		sBusinessTypeName = "授信额度项下业务";
	}
	*/
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr align=center>");	
	sTemp.append("   <td class=td1 colspan=8 bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sBankName+"审查报告</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=right>");	
	sTemp.append("   <td colspan=8 bgcolor=#aaaaaa class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >审查报告编号："+sObjectNo+"</font></td>"); 	
    sTemp.append("   </tr>");		
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=21% align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'> 申请人名称:</font></td>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sCustomerName+"&nbsp;</font></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'> 呈报行、部: </font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sOrgName+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>授信品种</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sCreditType+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>是否首笔</td>");
	sTemp.append("   <td width=18% colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sPhaseOpinion3+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>金额(万)</font></td>");
	sTemp.append("   <td width=21% colspan=2 align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sBusinessSum+"&nbsp;</font></td>");
	sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>币种</font></td>");
	sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sCurrencyName+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>信用评级</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sCreditLevel+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>保证金比例%</font></td>");
	sTemp.append("   <td colspan=2 align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sBailRatio+"&nbsp;</font></td>");
	sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>期限(月)</font></td>");
    sTemp.append("   <td width=12% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sTermMonth+"</font></td>");
    sTemp.append("   </tr>");    
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>风险度</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sPhaseOpinion2+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>担保方式</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sGuarantyType+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    /*
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>担保信息<br>"+sGuarantyType+"</font></td>");
    sTemp.append("   </tr>");
    */
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>客户经理五级分类</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sClassifyResult+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>保证人名称</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sGuarantorName+"</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>审查人五级分类</font></td>");
	sTemp.append("   <td colspan=2 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sPhaseOpinion1+"&nbsp;</font></td>");
	sTemp.append("   <td width=16% align=center class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>抵质押物</font></td>");
	sTemp.append("   <td colspan=4 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sGuarantyName+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>表内业务余额</font></td>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+bnBalance+"</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>表外业务敞口余额</font></td>");
	sTemp.append("   <td colspan=7 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+bwBalance+"</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=3 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>当前后四类金额（按币种折算）</font></td>");
	sTemp.append("   <td colspan=5 align=left class=td1 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sOtherBalance+"&nbsp;</font></td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
    String sDay = sBeginTime.replaceAll("/","");
    //sPhaseOpinion = StringFunction.replace(sPhaseOpinion,"\n","<br>");
    sPhaseOpinion = StringFunction.replace(sPhaseOpinion,"\r","<br>");
    sPhaseOpinion = StringFunction.replace(sPhaseOpinion," ","&nbsp;");
    sTemp.append("   <td colspan=8 align=center class=td1 ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >审&nbsp;&nbsp;查&nbsp;&nbsp;意&nbsp;&nbsp;见</font>&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left valign=top class=td1 style='word-break:break-all' ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'>"+sPhaseOpinion+"<br>&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审查人："+sUserName+"&nbsp;&nbsp;&nbsp;审查日期："+DataConvert.toDate_YMD(sDay)+"</font></td>");
    sTemp.append("   </tr>");
    /*
    sTemp.append("   <tr>");
    sTemp.append("   <td colspan=8 align=center class=td1 ><font style=' font-size: 14pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >备&nbsp;&nbsp;注&nbsp;&nbsp;栏</font>&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
	sTemp.append("   <td colspan=8 align=left valign=top class=td1 style='word-break:break-all' ><font style=' font-size: 12pt;FONT-FAMILY:宋体;'><br>&nbsp;<br>&nbsp;<br>&nbsp;</font></td>");
    sTemp.append("   </tr>");
    */
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
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

