<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0504页
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
	int iDescribeCount = 16;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	double dValue = 0;//应收总额
	double Unit=10000;//金额（单位）,默认为万元
	double d010 = 0.0;//应收帐款总额
	String[] sysValue = {"0","0","0","0"};
	String[] sProportion = {"0","0","0","0"};
	double d015 = 0.0;//其他应收款总额
	String[] sysValue1 = {"0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0"};
	//获得应收总额
	ASResultSet rs2 = Sqlca.getResultSet("select sum(FOASum) from ENT_FOA where FOAType in ('01','02') and CustomerID = '"+sCustomerID+"'");
	if(rs2.next())
	{
		dValue = rs2.getDouble(1)/Unit;
	}
	rs2.getStatement().close();
	
	if(dValue >0 )
	{
		String sAccountYears = "";
		//应收帐款分析(应收帐款总额)
		String sSql1="select sum(FOASum) from ENT_FOA" 
			         +" where FOAType='01'"
			         +" and CustomerID = '"+sCustomerID+"'";
		rs2 = Sqlca.getResultSet(sSql1);
		if(rs2.next())
		{
			d010 = rs2.getDouble(1)/Unit;
			sysValue[3] = DataConvert.toMoney(d010);
			sProportion[3] = DataConvert.toMoney(d010/dValue*100);
		}
		rs2.getStatement().close();   
		     
		String sSql2="select AccountYears,sum(FOASum) from ENT_FOA" 
			         +" where FOAType='01'"
			         +" and CustomerID = '"+sCustomerID+"'"  
			         +" group by AccountYears";
		if(d010>0)
		{
			rs2 = Sqlca.getResultSet(sSql2);
			while(rs2.next()) 
			{
				sAccountYears = rs2.getString(1);
				double dysValue = 0.0;
				if(sAccountYears.equals("01"))
				{
					sysValue[0] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
					dysValue = rs2.getDouble(2)/Unit;
					sProportion[0] = DataConvert.toMoney(dysValue/dValue*100);
				}
				else if(sAccountYears.equals("02"))
				{
					sysValue[1] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
					dysValue = rs2.getDouble(2)/Unit;
					sProportion[1] = DataConvert.toMoney(dysValue/dValue*100);
				}
				else if(sAccountYears.equals("03"))
				{
					sysValue[2] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
					dysValue = rs2.getDouble(2)/Unit;
					sProportion[2] = DataConvert.toMoney(dysValue/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
		
		//应收帐款分析(其他应收款)
		String sSql3="select sum(FOASum) from ENT_FOA" 
			         +" where FOAType='02'"
			         +" and CustomerID = '"+sCustomerID+"'";  
		rs2 = Sqlca.getResultSet(sSql3);
		if(rs2.next())
		{
			d015 = rs2.getDouble(1)/Unit;
			sysValue1[3] = DataConvert.toMoney(d015);
			sProportion1[3] = DataConvert.toMoney(d015/dValue*100);
		}
		rs2.getStatement().close(); 
		
		String sSql4="select AccountYears,sum(FOASum) from ENT_FOA" 
			         +" where FOAType='02'"
			         +" and CustomerID = '"+sCustomerID+"'"  
			         +" group by AccountYears";
		if(d015>0)
		{         
			rs2 = Sqlca.getResultSet(sSql4);
			while(rs2.next())
			{
				sAccountYears = rs2.getString(1);
				double dysValue = 0.0;
				if(sAccountYears.equals("01"))
				{
					sysValue1[0] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
					dysValue = rs2.getDouble(2)/Unit;
					sProportion1[0] = DataConvert.toMoney(dysValue/dValue*100);
				}
				else if(sAccountYears.equals("02"))
				{
					sysValue1[1] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
					dysValue = rs2.getDouble(2)/Unit;
					sProportion1[1] = DataConvert.toMoney(dysValue/dValue*100);
				}
				else if(sAccountYears.equals("03"))
				{
					sysValue1[2] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
					dysValue = rs2.getDouble(2)/Unit;
					sProportion1[2] = DataConvert.toMoney(dysValue/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0504.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("  <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='15' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.4、资产分析</font></td>"); 	
	sTemp.append("  </tr>");	
	//*********************************应收帐款分析**********************************
	sTemp.append("  <tr align='left'>");
  	sTemp.append("   <td colspan='15' class=td1 ><br><strong> (1)应收帐款分析 </strong><br>&nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td width='6%' colspan='3' rowspan='2' align=center class=td1 > 帐龄分析</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 > 1年（含）以下</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 > 1－2年（含）</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >2年以上</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 > 合计 </td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td width='12%' colspan='2' align=center class=td1 > 金额(万元) </td>");
    sTemp.append("   <td width=6% align=center class=td1 >%</td>");
    sTemp.append("   <td width='12%' colspan='2' align=center class=td1 > 金额(万元) </td>");
    sTemp.append("   <td width=6% align=center class=td1 >%</td>");
    sTemp.append("   <td width='12%' colspan='2' align=center class=td1 > 金额(万元) </td>");
    sTemp.append("   <td width=6% align=center class=td1 >%</td>");
    sTemp.append("   <td width='22%' colspan='2' align=center class=td1 > 金额(万元) </td>");
	sTemp.append("	 <td width=10% align=center class=td1 >%</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 > 应收帐款</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue[0]+"</td>");
    sTemp.append("   <td width=6% align=center class=td1 >"+sProportion[0]+"</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue[1]+"</td>");
    sTemp.append("   <td width=6% align=center class=td1 >"+sProportion[1]+"</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue[2]+"</td>");
    sTemp.append("   <td width=6% align=center class=td1 >"+sProportion[2]+"</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue[3]+"</td>");
	sTemp.append("	 <td width=10% align=center class=td1 >"+sProportion[3]+"</td>");
    sTemp.append("  </tr>");
   	
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 > 其他应收款</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue1[0]+"</td>");
    sTemp.append("   <td width=6% align=center class=td1 >"+sProportion1[0]+"</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue1[1]+"</td>");
    sTemp.append("   <td width=6% align=center class=td1 >"+sProportion1[1]+"</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue1[2]+"</td>");
    sTemp.append("   <td width=6% align=center class=td1 >"+sProportion1[2]+"</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >"+sysValue1[3]+"</td>");
	sTemp.append("	 <td width=10% align=center class=td1 >"+sProportion1[3]+"</td>");
    sTemp.append("  </tr>");
    
	sTemp.append("  <tr>");
	sTemp.append("   <td width=6% rowspan='4' align=center class=td1 > 应收帐款 </td>");
    sTemp.append("   <td colspan='4' align=center class=td1 > 大户名单名称</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >金额(万元)</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >%</td>");
    sTemp.append("   <td colspan='4' align=center class=td1 > 资金占用/变动原因</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 > 与本企业关系</td>");
    sTemp.append("  </tr>");
    
    String sSql7 = "select RelatedCorpName,FOASum,Remark,RelativeDescribe from ENT_FOA where FOAType='01' and CustomerID = '"+sCustomerID+"' "+"order by FOASum desc";
    rs2 = Sqlca.getResultSet(sSql7);
    int j=0;
    String sRelatedCorpName = ""; //应收帐款大户名单名称
    String sFOASum = "";		  //应收帐款金额(万元)
    String sRemark = "";		  //应收帐款资金占用/变动原因
    String sDigest = "";		  //应收帐款与本企业关系
    double dFOASum = 0;
    if(d010>0)
    {
    	while(true)
    	{
    	j++;
    	if(rs2.next())
    	{
    		sRelatedCorpName = rs2.getString(1);
    		if(sRelatedCorpName == null) sRelatedCorpName = " ";
    		sFOASum = DataConvert.toMoney(rs2.getDouble(2)/Unit);
    		dFOASum = rs2.getDouble(2)/Unit;
    		sRemark = rs2.getString(3);
    		if(sRemark == null) sRemark = " ";
    		sDigest = rs2.getString(4);
    		if(sDigest == null) sDigest = " ";
    		sProportion[0] = DataConvert.toMoney(dFOASum/d010*100);
			sTemp.append("  <tr>");
			sTemp.append("   <td width=2% align=center class=td1 >"+j+"&nbsp;</td>");
    		sTemp.append("   <td colspan='3' align=center class=td1 >"+sRelatedCorpName+"&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >"+sFOASum+"&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportion[0]+"&nbsp;</td>");
    		sTemp.append("   <td colspan='4' align=center class=td1 >"+sRemark+"&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >"+sDigest+"&nbsp;</td>");
    		sTemp.append("  </tr>");
    	}
    	else
    	{
    		sTemp.append("  <tr>");
			sTemp.append("   <td width=2% align=center class=td1 >"+j+"&nbsp;</td>");
    		sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("  </tr>");
    	}
    
    	if(j==3) break;
    	}
    	rs2.getStatement().close();
	}
	else
    {
    	j = 1;
    	while(j<=3)
    	{
    		sTemp.append("  <tr>");
			sTemp.append("   <td width=2% align=center class=td1 >"+j+"&nbsp;</td>");
    		sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("  </tr>");
    		j++;
    	}
    }
	sTemp.append("  <tr>");
	sTemp.append("   <td width=6% rowspan='4' align=center class=td1 > 其他应收款 </td>");
    sTemp.append("   <td colspan='4' align=center class=td1 > 大户名单名称</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >金额(万元)</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >%</td>");
    sTemp.append("   <td colspan='4' align=center class=td1 > 资金占用/变动原因</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 > 与本企业关系</td>");
    sTemp.append("  </tr>");
    
    String sSql8 = "select RelatedCorpName,FOASum,Remark,RelativeDescribe from ENT_FOA where FOAType='02' and CustomerID = '"+sCustomerID+"' "+"order by FOASum desc";
    rs2 = Sqlca.getResultSet(sSql8);
	j=0;
    if(d015>0)
    {
    	while(true)
    	{
    	j++;
    	if(rs2.next())
    	{
    		sRelatedCorpName = rs2.getString(1);
    		if(sRelatedCorpName == null) sRelatedCorpName = " ";
    		sFOASum = DataConvert.toMoney(rs2.getDouble(2)/Unit);
    		dFOASum = rs2.getDouble(2)/Unit;
    		sRemark = rs2.getString(3);
    		if(sRemark == null) sRemark = " ";
    		sDigest = rs2.getString(4);
    		if(sDigest == null) sDigest = " ";
    		sProportion1[0] = DataConvert.toMoney(dFOASum/d015*100);
			sTemp.append("  <tr>");
			sTemp.append("   <td width=2% align=center class=td1 >"+j+"&nbsp;</td>");
    		sTemp.append("   <td colspan='3' align=center class=td1 >"+sRelatedCorpName+"&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >"+sFOASum+"&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportion1[0]+"&nbsp;</td>");
    		sTemp.append("   <td colspan='4' align=center class=td1 >"+sRemark+"&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >"+sDigest+"&nbsp;</td>");
    		sTemp.append("  </tr>");
    	}
    	else
    	{
    		sTemp.append("  <tr>");
			sTemp.append("   <td width=2% align=center class=td1 >"+j+"&nbsp;</td>");
    		sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("  </tr>");
    	}
    
    	if(j==3) break;
    	}
    	rs2.getStatement().close();
	}
	else
    {
    	j = 1;
    	while(j<=3)
    	{
    		sTemp.append("  <tr>");
			sTemp.append("   <td width=2% align=center class=td1 >"+j+"&nbsp;</td>");
    		sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    		sTemp.append("  </tr>");
    		j++;
    	}
    }
	sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 "+myShowTips(sMethod)+" >应收帐款分析");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    //**********************************存货分析*************************************
	sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 ><br> <strong>(2) 存货分析</strong> <br>&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp; </td>");
    sTemp.append("   <td colspan='4' align=center class=td1 > 金额(万元) </td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >%</td>");
    sTemp.append("   <td colspan='6' align=center class=td1 > 存货是否正常</td>");
    sTemp.append("  </tr>");
    
    //存货合计
    String sSql91 = "select  sum(ValueSum) from ENT_INVENTORY where InventoryType in('01','02','03') and CustomerID = '"+sCustomerID+"'";
    rs2 = Sqlca.getResultSet(sSql91);
    double sum = 0.0;
    if(rs2.next())
    {
    	sum = rs2.getDouble(1)/Unit;
    }
    rs2.getStatement().close();
    //产成品
    String sSql9 = "select  ValueSum,getitemname('YesNo',QualityStatus) from ENT_INVENTORY where InventoryType = '03' and CustomerID = '"+sCustomerID+"'";
    rs2 = Sqlca.getResultSet(sSql9);
    String sValueSum = "";			//金额(万元)
    String sQualityStatus = "";		//存货是否正常
    if(rs2.next())
    {
	    sValueSum = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    sQualityStatus = rs2.getString(2);
	    if(sQualityStatus == null) sQualityStatus= " ";
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 > 产成品</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sValueSum+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='6' align=center class=td1 >"+sQualityStatus+"&nbsp;</td>");
	    sTemp.append("  </tr>");
    }
    else
    {
	    sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 > 产成品</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='6' align=center class=td1 >&nbsp;</td>");
	    sTemp.append("  </tr>");
    }
    rs2.getStatement().close();
    
    //在产品
    String sSql10 = "select  ValueSum,getitemname('YesNo',QualityStatus) from ENT_INVENTORY where InventoryType = '02' and CustomerID = '"+sCustomerID+"'";
    rs2 = Sqlca.getResultSet(sSql10);
    sValueSum = "";
    sQualityStatus = "";
    if(rs2.next())
    {
	    sValueSum = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    sQualityStatus = rs2.getString(2);
	    if(sQualityStatus == null) sQualityStatus= " ";
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 > 在产品</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sValueSum+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='6' align=center class=td1 >"+sQualityStatus+"&nbsp;</td>");
	    sTemp.append("  </tr>");
    }
    else
    {
	    sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 > 在产品</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='6' align=center class=td1 >&nbsp;</td>");
	    sTemp.append("  </tr>");
    }
    rs2.getStatement().close();
	
	//原材料
	String sSql11 = "select  ValueSum,getitemname('YesNo',QualityStatus) from ENT_INVENTORY where InventoryType = '01' and CustomerID = '"+sCustomerID+"'";
    rs2 = Sqlca.getResultSet(sSql11);
    sValueSum = "";
    sQualityStatus = "";
    if(rs2.next())
    {
	    sValueSum = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    sQualityStatus = rs2.getString(2);
	    if(sQualityStatus == null) sQualityStatus= " ";
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 > 原材料</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sValueSum+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='6' align=center class=td1 >"+sQualityStatus+"&nbsp;</td>");
	    sTemp.append("  </tr>");
    }
    else
    {
	    sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 > 原材料</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='6' align=center class=td1 >&nbsp;</td>");
	    sTemp.append("  </tr>");
    }
    rs2.getStatement().close();
	
	//合计
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 > 合计</td>");
    sTemp.append("   <td colspan='4' align=center class=td1 >"+DataConvert.toMoney(sum)+"&nbsp;</td>");
    sTemp.append("   <td colspan='8' align=center class=td1 >&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr align='left'>");
	sTemp.append("   <td colspan='15' class=td1 "+myShowTips(sMethod)+" >存货分析<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    //********************************固定资产分析*********************************
	sTemp.append("  <tr align='left'>");
	sTemp.append("   <td colspan='15' class=td1 ><strong> <br>（3）固定资产分析 </strong><br>&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
    sTemp.append("   <td colspan='4' align=center class=td1 >金额(万元)</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >%</td>");
    sTemp.append("   <td colspan='4' align=center class=td1 > 折旧方法</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 > 综合成新率</td>");
	sTemp.append("  </tr>");
	
	String sSql121 = "select sum(EvalValue) from ENT_FIXEDASSETS where FixedAssetsType in ('01','02','03','04') and CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql121);
	sum = 0.0;
	if(rs2.next())
		sum = rs2.getDouble(1)/Unit;
	rs2.getStatement().close();
	
	String sSql12 = "select EvalValue,Depreciation,Rate from ENT_FIXEDASSETS where FixedAssetsType = '01' and CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql12);
	String sEvalValue = "";				//固定资产金额(万元)
    String sDepreciation = "";			//固定资产折旧方法
    double dRate = 0.0;					//固定资产综合成新率
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    sDepreciation = rs2.getString(2);
	    if(sDepreciation == null) sDepreciation = " ";
	    dRate = rs2.getDouble(3);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >房屋建筑物</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sDepreciation+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+dRate+"&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >房屋建筑物</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//机器设备
	String sSql13 = "select EvalValue,Depreciation,Rate from ENT_FIXEDASSETS where FixedAssetsType = '02' and CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql13);
	sEvalValue = "";
    sDepreciation = "";
    dRate = 0.0;
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    sDepreciation = rs2.getString(2);
	    if(sDepreciation == null) sDepreciation = " ";
	    dRate = rs2.getDouble(3);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >机器设备</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sDepreciation+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+dRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >机器设备</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//运输工具
	String sSql14 = "select EvalValue,Depreciation,Rate from ENT_FIXEDASSETS where FixedAssetsType = '03' and CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql14);
	sEvalValue = "";
    sDepreciation = "";
    dRate = 0.0;
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    sDepreciation = rs2.getString(2);
	    if(sDepreciation == null) sDepreciation = " ";
	    dRate = rs2.getDouble(3);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >运输工具</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sDepreciation+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+dRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >运输工具</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//其他
	String sSql15 = "select EvalValue,Depreciation,Rate from ENT_FIXEDASSETS where FixedAssetsType = '04' and CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql15);
	sEvalValue = "";
    sDepreciation = "";
    dRate = 0.0;
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    sDepreciation = rs2.getString(2);
	    if(sDepreciation == null) sDepreciation = " ";
	    dRate = rs2.getDouble(3);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >其他</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sDepreciation+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+dRate+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >其他</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >0.0&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//合计
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 > 合计 </td>");
    sTemp.append("   <td colspan='4' align=center class=td1 >"+DataConvert.toMoney(sum)+"&nbsp;</td>");
    sTemp.append("   <td colspan='8' align=center class=td1 >&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr align='left'>");
	sTemp.append("   <td colspan='15' class=td1 "+myShowTips(sMethod)+" >固定资产分析");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    //********************************无形资产分析*************************
	sTemp.append("  <tr align='left'>");
	sTemp.append("   <td colspan='15' class=td1 ><br><strong> （4）无形资产分析</strong><br>&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 > 主要内容 </td>");
    sTemp.append("   <td colspan='4' align=center class=td1 > 入帐价值(万元) </td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >%</td>");
    sTemp.append("   <td colspan='6' align=center class=td1 > 评估方法 </td>");
    sTemp.append("  </tr>");
    //合计
    String sSql161 = "select sum(AccountValue) from CUSTOMER_IMASSET"+
				    " where CustomerID='"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql161);
	sum = 0.0;
	if(rs2.next()) sum = rs2.getDouble(1)/Unit;
	rs2.getStatement().close();
	
    String sSql16 = "select AssetName,AccountValue,EvaluateMethod from CUSTOMER_IMASSET"+
				    " where CustomerID='"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql16);
	String sAssetName = "";				//主要内容
	String sAccountValue = "";			//入帐价值
	String sEvaluateMethod = "";		//评估方法
	while(rs2.next())
	{
		sAssetName = rs2.getString(1);
		if(sAssetName == null) sAssetName = " ";
		sAccountValue = DataConvert.toMoney(rs2.getDouble(2)/Unit);
		sEvaluateMethod = rs2.getString(3);
		if(sEvaluateMethod == null) sEvaluateMethod = " ";
		String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(2)/Unit/sum*100);
		sTemp.append("  <tr>");
		sTemp.append("   <td colspan='3' align=center class=td1 >"+sAssetName+"&nbsp;</td>");
	    sTemp.append("   <td colspan='4' align=center class=td1 >"+sAccountValue+"&nbsp;</td>");
	    sTemp.append("   <td colspan='2' align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td colspan='6' align=center class=td1 >"+sEvaluateMethod+"&nbsp;</td>");
	    sTemp.append("  </tr>");
    }
    rs2.getStatement().close();
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
    sTemp.append("   <td colspan='4' align=center class=td1 >&nbsp;</td>");
    sTemp.append("   <td colspan='2' align=center class=td1 >&nbsp;</td>");
    sTemp.append("   <td colspan='6' align=center class=td1 >&nbsp;</td>");
    sTemp.append("  </tr>");
	
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='3' align=center class=td1 > 合计 </td>");
    sTemp.append("   <td colspan='4' align=center class=td1 >"+DataConvert.toMoney(sum)+"&nbsp;</td>");
    sTemp.append("   <td colspan='8' align=center class=td1 >&nbsp;</td>");
    sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 "+myShowTips(sMethod)+" >无形资产分析");
	sTemp.append("	 </td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    
	//对外担保和其他或有负债分析
	sTemp.append("  <tr align='left'>");
	sTemp.append("   <td colspan='15' class=td1 ><br><strong> （5）对外担保和其他或有负债分析</strong><br>&nbsp;</td>");
    sTemp.append("  </tr>");
    String sSql17 ="select distinct getItemName('GuarantyType',GuarantyType) as GuarantyTypeName from GUARANTY_CONTRACT"+
					" where GuarantorID ='"+sCustomerID+"' "+
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
    sTemp.append("   <td colspan='3' align=center class=td1 > 金额(万元) </td>");
    sTemp.append("   <td colspan='3' align=center class=td1 > 期限 </td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='6' align=center class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe5' style='width:100%;",getUnitData("describe5",sData)));
	sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe6' style='width:100%;",getUnitData("describe6",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe7' style='width:100%;",getUnitData("describe7",sData)));
    sTemp.append("	 &nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='6' align=center class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe8' style='width:100%;",getUnitData("describe8",sData)));
	sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe9' style='width:100%;",getUnitData("describe9",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe10' style='width:100%;",getUnitData("describe10",sData)));
    sTemp.append("	 &nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='6' align=center class=td1 > 合计 </td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe11' style='width:100%;",getUnitData("describe11",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='9' align=left class=td1 > 或有负债总计 </td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >");
    sTemp.append(myOutPut("0",sMethod,"name='describe12' style='width:100%;",getUnitData("describe12",sData)));
    sTemp.append("	 &nbsp;</td>");
    sTemp.append("   <td colspan='3' align=center class=td1 >&nbsp;</td>");
	sTemp.append("  </tr>");
	sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 "+myShowTips(sMethod)+" >对外担保和其他或有负债分析<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:150'",getUnitData("describe13",sData)));
	sTemp.append("<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");

	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='15' class=td1 "+myShowTips(sMethod)+" > 资产抵、质押情况 <br>");
	sTemp.append("   资产抵押、质押情况应调查企业以往贷款时将哪些资产做了抵押或质押，这些资产的帐面价值和评估价值是多少，包括货币资金、存货、固定资产、无形资产。");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe14' style='width:100%; height:150'",getUnitData("describe14",sData)));
	sTemp.append("<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='15' class=td1 "+myShowTips(sMethod)+" > 其他异常资产情况 <br>");
	sTemp.append("   其他数额较大、存在风险或不能正常运营的资产情况进行说明，如法律手续不全、停产或半停产、设备严重老化、涉及重组的资产等，以及其他需要补充说明的情况 ");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe15' style='width:100%; height:150'",getUnitData("describe15",sData)));
	sTemp.append("<br>");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    
	sTemp.append("  <tr>");
	sTemp.append("   <td colspan='15' class=td1 "+myShowTips(sMethod)+" > 其他资产情况分析 ");
	sTemp.append("	 </td>");
    sTemp.append("  </tr>");
    sTemp.append("  <tr>");
	sTemp.append("   <td align='left' colspan='15' class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe16' style='width:100%; height:150'",getUnitData("describe16",sData)));
	sTemp.append("<br>");
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
	editor_generate('describe1');		//需要html编辑,input是没必要
	editor_generate('describe2');		//需要html编辑,input是没必要
	editor_generate('describe3');		//需要html编辑,input是没必要
	editor_generate('describe4');		//需要html编辑,input是没必要
	editor_generate('describe13');		//需要html编辑,input是没必要
	editor_generate('describe14');		//需要html编辑,input是没必要
	editor_generate('describe15');		//需要html编辑,input是没必要
	editor_generate('describe16');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>