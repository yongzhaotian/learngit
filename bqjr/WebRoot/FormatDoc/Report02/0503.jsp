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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	int k = 0;   
	String sRowSubject = "";		//列主题 
	String sNewReportDate1 = "××年×月";		//最近资产负债表日期
	String sNewReportDate2 = "××年×月";		//最近损益表日期
	String sNewReportDate3 = "××年×月";		//最近现金流量表日期
	String sYear="",sMonth="";	

	String [] sYearReportDate = {"××年","××年","××年"};  	 //资产负债表年报日期
	String [] sYearReportNo = {"0","0","0"};     			//资产负债表年报号
	String [] ssyYearReportDate = {"××年","××年","××年"};   //损益表年报日期
	String [] ssyYearReportNo = {"0","0","0"};     			//损益表年报号
	String [] sxjYearReportDate = {"××年","××年","××年"};   //现金流量表年报日期
	String [] sxjYearReportNo = {"0","0","0"};     			//现金流量表年报号

	String sNewReportNo1 = "";		//最近资产负债表号
	String sNewReportNo2 = "";		//最近损益表表号
	String sNewReportNo3 = "";		//最近现金流量表号
	
	double dValue = 0 ;  //最近月报资产负债表中资产总计
	double dFValue = 0 ; //最近月报资产负债表中负债合计
	//最近月报资产负债表中资产总计,流动资产合计,货币资金,应收帐款净额,其他应收款,存货,长期投资淨额,固定资产净值,无形资产淨额,流动负债,短期借款及一年内到期的长期负债,应付票据,应付帐款,长期负债合计,所有者权益,实收资本 值
	String[] sValue = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//最近年报资产负债表中资产总计,流动资产合计,货币资金,应收帐款净额,其他应收款,存货,长期投资淨额,固定资产净值,无形资产淨额,流动负债,短期借款及一年内到期的长期负债,应付票据,应付帐款,长期负债合计,所有者权益,实收资本 值
	String[] sValue1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//最近第二年报资产负债表中资产总计,流动资产合计,货币资金,应收帐款净额,其他应收款,存货,长期投资淨额,固定资产净值,无形资产淨额,流动负债,短期借款及一年内到期的长期负债,应付票据,应付帐款,长期负债合计,所有者权益,实收资本 值
	String[] sValue2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//最近第三年报资产负债表中资产总计,流动资产合计,货币资金,应收帐款净额,其他应收款,存货,长期投资淨额,固定资产净值,无形资产淨额,流动负债,短期借款及一年内到期的长期负债,应付票据,应付帐款,长期负债合计,所有者权益,实收资本 值
	String[] sValue3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//最近损益表月报
	double dsyValue = 0;
	String ssyValue[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion[] = {"0","0","0","0","0","0","0","0","0"};

	//最近第一年损益表年报
	String ssyValue1[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion1[] = {"0","0","0","0","0","0","0","0","0"};

	//最近第二年损益表年报
	String ssyValue2[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion2[] = {"0","0","0","0","0","0","0","0","0"};

	//最近第三年损益表年报
	String ssyValue3[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion3[] = {"0","0","0","0","0","0","0","0","0"};

	//最近现金流量表月报
	double dxjValue = 0;
	String sxjValue[] = {"0","0","0","0","0","0"};

	//最近第一年现金流量表年报
	String sxjValue1[] = {"0","0","0","0","0","0"};

	//最近第二年现金流量表年报
	String sxjValue2[] = {"0","0","0","0","0","0"};

	//最近第三年现金流量表年报
	String sxjValue3[] = {"0","0","0","0","0","0"};

//****************************资产负债表***********************************************

	
//取最新资产负债表日期
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD "+
						" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1') order by reportscope asc");
	//通过order by reportscope asc查询到的第一条记录就是最小口径的财务报表数据，以下的if(rs2.next())取到的记录就是最新月份的最小口径的报表数据。
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//日期
		if(sYear == null) 
		{
			sNewReportDate1 = "××年×月";
		}
		else
		{
			sMonth = rs2.getString("Month");	//日期
			sNewReportDate1 = sYear + " 年" +sMonth+" 月";
		}
		sNewReportNo1 = rs2.getString("ReportNo");	//最近资产负债表号
	}
	rs2.getStatement().close();
	
	if(!sNewReportDate1.equals("××年×月"))
	{
		//资产总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='804'");
		if(rs2.next())
		{
			sValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));
			sProportion[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		//负债总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='809'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//短期借款及一年内到期的长期负债
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('201','211')");
			if(rs2.next())
			{
				sValue[10] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				sProportion[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();

			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('801','101','106','108','110','19h','119','19m','805','202','203','806','808','301')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("801"))	//流动资产合计 
				{
					sValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("101"))	//货币资金
				{		
					sValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//应收帐款净额
				{
					sValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//其他应收款
				{
					sValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("110"))	//存货
				{
					sValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19h"))	//长期投资淨额
				{
					sValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//固定资产净值
				{
					sValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//无形资产淨额
				{
					sValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("805"))	//流动负债
				{
					sValue[9] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("202"))	//应付票据
				{
					sValue[11] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("203"))	//应付帐款
				{
					sValue[12] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("806"))	//长期负债合计
				{
					sValue[13] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("808"))	//所有者权益
				{
					sValue[14] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("301"))	//实收资本
				{
					sValue[15] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
	}
	
//年报
	//取最新资产负债表年报日期,如果有年报日期相同的记录，则取最小口径的年报数据。
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%1'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04')"+
		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1')"+
		" order by Year Desc,ReportScope Asc");
	k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			//如果日期重复,说明该月份有多种口径的报表,这里取第一个日期就是最小口径的报表,因为在查询的时候是根据口径的升序来排列的结果。
			if(k !=0 && sYear.equals(sYearReportDate[k-1].substring(0, 4)))
				continue;
			if(sYear == null) 
			{
				sYearReportDate[k] = "××年";
			}
			else
			{
				sYearReportDate[k] = sYear + " 年";
			}
			sYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号
		}
		k ++;
	}
	rs2.getStatement().close();

//第一年
	if(!sYearReportDate[0].equals("××年"))
	{
		//资产总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			sValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));
			sProportion1[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		else sProportion1[0] = "100";
		rs2.getStatement().close();
		
		//负债总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='809'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//短期借款及一年内到期的长期负债
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('201','211')");
			if(rs2.next())
			{
				sValue1[10] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				sProportion1[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();

			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('801','101','106','108','110','19h','119','19m','805','202','203','806','808','301')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("801"))	//流动资产合计 
				{
					sValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("101"))	//货币资金
				{		
					sValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//应收帐款净额
				{
					sValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//其他应收款
				{
					sValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("110"))	//存货
				{
					sValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19h"))	//长期投资淨额
				{
					sValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//固定资产净值
				{
					sValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//无形资产淨额
				{
					sValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("805"))	//流动负债
				{
					sValue1[9] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("202"))	//应付票据
				{
					sValue1[11] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("203"))	//应付帐款
				{
					sValue1[12] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("806"))	//长期负债合计
				{
					sValue1[13] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("808"))	//所有者权益
				{
					sValue1[14] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("301"))	//实收资本
				{
					sValue1[15] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
//第二年
		if(!sYearReportDate[1].equals("××年"))
		{
			//资产总计
			rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='804'");
			if(rs2.next())
			{
				sValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				sProportion2[0] = "100";
				dValue = rs2.getDouble("Col2value");
			}
			else sProportion2[0] = "100";
	 		rs2.getStatement().close();
			//负债总计
			rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='809'");
			if(rs2.next())
			{
				dFValue = rs2.getDouble("Col2value");
			}
			rs2.getStatement().close();
			if (dValue > 0.008)
			{
				//短期借款及一年内到期的长期负债
				rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('201','211')");
				if(rs2.next())
				{
					sValue2[10] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				rs2.getStatement().close();

				rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('801','101','106','108','110','19h','119','19m','805','202','203','806','808','301')");
				while(rs2.next())
				{
					sRowSubject = rs2.getString("RowSubject");
					if (sRowSubject.equals("801"))	//流动资产合计 
					{
						sValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("101"))	//货币资金
					{		
						sValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("106"))	//应收帐款净额
					{
						sValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("108"))	//其他应收款
					{
						sValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("110"))	//存货
					{
						sValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("19h"))	//长期投资淨额
					{
						sValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("119"))	//固定资产净值
					{
						sValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("19m"))	//无形资产淨额
					{
						sValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("805"))	//流动负债
					{
						sValue2[9] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("202"))	//应付票据
					{
						sValue2[11] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("203"))	//应付帐款
					{
						sValue2[12] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("806"))	//长期负债合计
					{
						sValue2[13] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("808"))	//所有者权益
					{
						sValue2[14] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("301"))	//实收资本
					{
						sValue2[15] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion2[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
				}
				rs2.getStatement().close();
			}
//第三年
			if(!sYearReportDate[2].equals("××年"))
			{
				//资产总计
				rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='804'");
				if(rs2.next())
				{
					sValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[0] = "100";
					dValue = rs2.getDouble("Col2value");
				}
				rs2.getStatement().close();
				//负债总计
				rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='809'");
				if(rs2.next())
				{
					dFValue = rs2.getDouble("Col2value");
				}
				rs2.getStatement().close();
				if (dValue > 0.008)
				{
					//短期借款及一年内到期的长期负债
					rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject in ('201','211')");
					if(rs2.next())
					{
						sValue3[10] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						sProportion3[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					rs2.getStatement().close();
					
					rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject in ('801','101','106','108','110','19h','119','19m','805','202','203','806','808','301')");
					while(rs2.next())
					{
						sRowSubject = rs2.getString("RowSubject");
						if (sRowSubject.equals("801"))	//流动资产合计 
						{
							sValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("101"))	//货币资金
						{		
							sValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("106"))	//应收帐款净额
						{
							sValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("108"))	//其他应收款
						{
							sValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("110"))	//存货
						{
							sValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("19h"))	//长期投资淨额
						{
							sValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("119"))	//固定资产净值
						{
							sValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("19m"))	//无形资产淨额
						{
							sValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("805"))	//流动负债
						{
							sValue3[9] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("202"))	//应付票据
						{
							sValue3[11] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("203"))	//应付帐款
						{
							sValue3[12] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("806"))	//长期负债合计
						{
							sValue3[13] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("808"))	//所有者权益
						{
							sValue3[14] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("301"))	//实收资本
						{
							sValue3[15] = DataConvert.toMoney(rs2.getDouble("Col2value"));
							sProportion3[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
					}
					rs2.getStatement().close();
				}
			}
		}
	}

//*****************************************损益表结构和对比*****************************
	//取最近损益表日期
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%2' And ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%2') order by reportscope asc");
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//日期
		if(sYear == null) 
		{
			sNewReportDate2 = "××年×月";
		}
		else
		{
			sMonth = rs2.getString("Month");	//日期
			sNewReportDate2 = sYear + " 年" +sMonth+" 月";
		}
		sNewReportNo2 = rs2.getString("ReportNo");	//最近损益表号
	}	
	rs2.getStatement().close();

	if(!sNewReportDate2.equals("××年×月"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo2+"' And RowSubject in ('501','502','505','503','507','508','509','515','517')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//主营业务收入
			{
				ssyValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion[0] = "100";		
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//主营业务成本
			{
				ssyValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);	
			}
			else if (sRowSubject.equals("505"))	//主营业务利润
			{
				ssyValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("503"))	//营业费用
			{
				ssyValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("507"))	//管理费用
			{
				ssyValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("508"))	//财务费用
			{
				ssyValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("509"))	//营业利润
			{
				ssyValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//利润总额
			{
				ssyValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//净利润
			{
				ssyValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
  	}
	
//年报
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%2'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04')"+
		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%2')"+
		" order by Year Desc,ReportScope Asc");
	k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			if(k !=0 && sYear.equals(ssyYearReportDate[k-1].substring(0, 4)))
				continue;
			if(sYear == null) 
			{
				ssyYearReportDate[k] = "××年";
			}
			else
			{
				ssyYearReportDate[k] = sYear + " 年";
			}
			ssyYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号
		}
		k ++;
	}
	rs2.getStatement().close();

//第一年
	if (!ssyYearReportDate[0].equals("××年"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[0]+"' And RowSubject in ('501','502','505','503','507','508','509','515','517')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//主营业务收入
			{
				ssyValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion1[0] = "100";		
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//主营业务成本
			{
				ssyValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//主营业务利润
			{
				ssyValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("503"))	//营业费用
			{
				ssyValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("507"))	//管理费用
			{
				ssyValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("508"))	//财务费用
			{
				ssyValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("509"))	//营业利润
			{
				ssyValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//利润总额
			{
				ssyValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//净利润
			{
				ssyValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
				ssyProportion1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
//第二年	
		if (!ssyYearReportDate[1].equals("××年"))
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[1]+"' And RowSubject in ('501','502','505','503','507','508','509','515','517')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("501"))		//主营业务收入
				{
					ssyValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					dsyValue = rs2.getDouble("Col2value");
					ssyProportion2[0] = "100";			
				}
				if( dsyValue == 0) continue;
				if (sRowSubject.equals("502"))	//主营业务成本
				{
					ssyValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("505"))	//主营业务利润
				{
					ssyValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("503"))	//营业费用
				{
					ssyValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("507"))	//管理费用
				{
					ssyValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("508"))	//财务费用
				{
					ssyValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("509"))	//营业利润
				{
					ssyValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("515"))	//利润总额
				{
					ssyValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("517"))	//净利润
				{
					ssyValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					ssyProportion2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
			}
//第三年		rs2.getStatement().close();

			if (!ssyYearReportDate[2].equals("××年"))
			{
				rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[2]+"' And RowSubject in ('501','502','505','503','507','508','509','515','517')");
				while(rs2.next())
				{
					sRowSubject = rs2.getString("RowSubject");
					if (sRowSubject.equals("501"))		//主营业务收入
					{
						ssyValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
						dsyValue = rs2.getDouble("Col2value");
						ssyProportion3[0] = "100";
					}
					if( dsyValue == 0) continue;
					if (sRowSubject.equals("502"))	//主营业务成本
					{
						ssyValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						ssyProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("505"))	//主营业务利润
					{
						ssyValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
						ssyProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);
					}
					else if (sRowSubject.equals("503"))	//营业费用
					{
						ssyValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						ssyProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("507"))	//管理费用
					{
						ssyValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						ssyProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("508"))	//财务费用
					{
						ssyValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						ssyProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("509"))	//营业利润
					{
						ssyValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						ssyProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("515"))	//利润总额
					{
						ssyValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						ssyProportion3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("517"))	//净利润
					{
						ssyValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value"));
						ssyProportion3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
				}
				rs2.getStatement().close();
			}
		}
	}

//*****************************************现金流量表*****************************
	//取最近现金流量表日期
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8' And ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8') order by reportscope asc");
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//日期
		if(sYear == null) 
		{
			sNewReportDate3 = "××年×月";
		}
		else
		{
			sMonth = rs2.getString("Month");	//日期
			sNewReportDate3 = sYear + " 年" +sMonth+" 月";
		}
		sNewReportNo3 = rs2.getString("ReportNo");	//最近现金流量表号
	}
	rs2.getStatement().close();

	if (!sNewReportDate3.equals("××年×月"))
	{
	 	//经营活动现金流入量	RowSubject 为a20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject ='a20'");
		if(rs2.next())
		{
			sxjValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
		}
		rs2.getStatement().close();
	
		//经营活动现金流出量	RowSubject 为a27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject ='a27'");
		if(rs2.next())
		{
			sxjValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject in ('810','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("813"))	//净现金流量
			{
				sxjValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
		}
		rs2.getStatement().close();
	}
//年报
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%8'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04')"+
		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8')"+
		" order by Year Desc,ReportScope Asc");
	k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			if(k !=0 && sYear.equals(sxjYearReportDate[k-1].substring(0, 4)))
				continue;
			if(sYear == null) 
			{
				sxjYearReportDate[k] = "××年";
			}
			else
			{
				sxjYearReportDate[k] = sYear + " 年";
			}
			sxjYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号
		}
		k ++;
	}
	rs2.getStatement().close();

//第一年
	if (!sxjYearReportDate[0].equals("××年"))
	{
	 	//经营活动现金流入量	RowSubject 为a20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject = 'a20'");
		if(rs2.next())
		{
			sxjValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
		}
		rs2.getStatement().close();
	
		//经营活动现金流出量	RowSubject 为a27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject = 'a27'");
		if(rs2.next())
		{
			sxjValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject in ('810','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			else if (sRowSubject.equals("813"))	//净现金流量
			{
				sxjValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
		}
		rs2.getStatement().close();

//第二年
		if (!sxjYearReportDate[1].equals("××年"))
		{
		 	//经营活动现金流入量	RowSubject 为a20
			rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject = 'a20'");
			if(rs2.next())
			{
				sxjValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			rs2.getStatement().close();
		
			//经营活动现金流出量	RowSubject 为a27
			rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject = 'a27'");
			if(rs2.next())
			{
				sxjValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
			}
			rs2.getStatement().close();
		
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject in ('810','811','812','813')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("810"))		//经营活动现金流净额
				{
					sxjValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
				}
				else if (sRowSubject.equals("811"))	//投资活动现金流净额
				{
					sxjValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
				}
				else if (sRowSubject.equals("812"))	//筹资活动现金流净额
				{
					sxjValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
				}
				else if (sRowSubject.equals("813"))	//净现金流量
				{
					sxjValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
				}
			}
			rs2.getStatement().close();

//第三年
			if (!sxjYearReportDate[2].equals("××年"))
			{
			 	//经营活动现金流入量	RowSubject 为a20
				rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject = 'a20'");
				if(rs2.next())
				{
					sxjValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
				}
				rs2.getStatement().close();
			
				//经营活动现金流出量	RowSubject 为a27
				rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject = 'a27'");
				if(rs2.next())
				{
					sxjValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
				}
				rs2.getStatement().close();
			
				rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject in ('810','811','812','813')");
				while(rs2.next())
				{
					sRowSubject = rs2.getString("RowSubject");
					if (sRowSubject.equals("810"))		//经营活动现金流净额
					{
						sxjValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
					}
					else if (sRowSubject.equals("811"))	//投资活动现金流净额
					{
						sxjValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
					}
					else if (sRowSubject.equals("812"))	//筹资活动现金流净额
					{
						sxjValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
					}
					else if (sRowSubject.equals("813"))	//净现金流量
					{
						sxjValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));		
					}
				}
				rs2.getStatement().close();
			}
		}
	}

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0503.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td class=td1 align=left colspan='9' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.3、财务简表分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("   <td width=18% colspan='9' align=center class=td1 > <br><strong>资产负债简表结构和对比</strong> <br>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
    sTemp.append("<td rowspan=2 align=center class=td1 > 项目</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sNewReportDate1+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[0]+"</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[1]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=15% align=center class=td1 > 数值 </td>");
	sTemp.append("<td width=5% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 > 数值 </td>");
	sTemp.append("<td width=5% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 >数值</td>");
	sTemp.append("<td width=5% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 >数值</td>");
	sTemp.append("<td width=5% align=center class=td1 >%</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 总资产 </td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue3[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 流动资产 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 货币资金 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应收帐款淨额 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 其他应收款 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[4]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 存货 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[5]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 长期投资淨额 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[6]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 固定资产净值 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[7]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 无形资产淨额 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[8]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 流动负债 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[9]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 短期借款及一年内到期的长期负债 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[10]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应付票据 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[11]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应付帐款 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[12]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 长期负债合计 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[13]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 所有者权益 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[14]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 实收资本 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[15]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td colspan='9' align=left class=td1 ><br><strong> 损益表结构和对比 </strong><br>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > 项目 </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sNewReportDate2+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[0]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[1]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=center class=td1 > 数值 </td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("<td align=center class=td1 >数值</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("<td align=center class=td1 >数值</td>");
	sTemp.append("<td align=center class=td1 >&nbsp;</td>");
	sTemp.append("<td align=center class=td1 >数值</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 主营业务收入 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 主营业务成本 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 主营业务利润 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 营业费用 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 管理费用 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[4]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 财务费用 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[5]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 营业利润 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[6]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 利润总额 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[7]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 净利润 </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[8]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	//colspan需根据实际情况调整，否则导出时会比较不雅
	sTemp.append("   <td colspan='9' align=left class=td1 > <br><strong>现金流</strong><br>&nbsp; </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > 项目 </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sNewReportDate3+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[0]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[1]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流入量 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue[0]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[0]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[0]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流出量 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue[1]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[1]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[1]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流净额 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue[2]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[2]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[2]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 投资活动现金流净额 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue[3]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[3]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[3]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 筹资活动现金流净额 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue[4]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[4]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[4]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[4]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 净现金流量 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue[5]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[5]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[5]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[5]+"</td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
