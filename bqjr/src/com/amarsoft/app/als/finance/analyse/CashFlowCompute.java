package com.amarsoft.app.als.finance.analyse;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CashFlowCompute {
	
	private String customerID = "";  
	private String baseYear = ""; 
	private String yearCount = ""; 
	private String reportScope = ""; 

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getBaseYear() {
		return baseYear;
	}

	public void setBaseYear(String baseYear) {
		this.baseYear = baseYear;
	}

	public String getYearCount() {
		return yearCount;
	}

	public void setYearCount(String yearCount) {
		this.yearCount = yearCount;
	}

	public String getReportScope() {
		return reportScope;
	}

	public void setReportScope(String reportScope) {
		this.reportScope = reportScope;
	}

	public String compute(Transaction Sqlca) throws Exception{
	    String sSql  = "",sReturnValue="";
		ASResultSet rs = null;
		
		double dSales=0;	//主营业务收入(万元)
		double dG=0;		//主营业务收入增长率(%)
		double dCost=0;		//主营业务成本/主营业务收入(%)
		double dOper_tax=0;		//主营业务税金及附加/主营业务收入(%)
		double dSale_fee=0;		//（营业费用+其他主营业务成本）/主营业务收入(%)
		double dGeneral_fee=0;		//管理费用/主营业务收入(%)
		double dOther_income=0;		//其他业务利润/主营业务收入(%)
		double dCurrA1=0;		//（流动资产－货币资金和短期投资）/主营业务收入(%)
		double dCurrA0=0;
		double dCurr_L1=0;		//（流动负债－短期借款和一年内到期的长期负债）/主营业务收入(%)
		double dCurr_L0=0;
		double dLong_asset1=0;		//固定资产净值和无形资产/主营业务收入(%)
		double dLong_asset0=0;
		double dD_A=0;		//本年折旧和摊销总额/年初年末平均(固定资产净值+无形资产)(%)
		double dTax=0;		//所得税率(%)
		double ddebt=0;		//有息债务总额(万元)
		double dinterest=0;		//平均利率(%)
		
		sSql = ("select parametercode,value0,value1 from CashFlow_Parameter "+
				"  where CustomerID = :CustomerID "+
				"    and BaseYear = :BaseYear "+
				"    and ReportScope = :ReportScope " +
				"  order by parameterno");	
		SqlObject so=new SqlObject(sSql);
		so.setParameter("CustomerID",customerID);
		so.setParameter("BaseYear",baseYear);
		so.setParameter("ReportScope",reportScope);
	    rs = Sqlca.getResultSet(so);
	    while(rs.next())
	    {
	    	if(rs.getString(1).equals("Sales")) dSales = rs.getDouble(2);
	    	if(rs.getString(1).equals("G")) dG = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("Cost")) dCost = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("Oper_tax")) dOper_tax = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("Sale_fee")) dSale_fee = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("General_fee")) dGeneral_fee = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("Other_income")) dOther_income = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("CurrA")) {dCurrA1 = rs.getDouble(2)/100;dCurrA0 = rs.getDouble(3)/100;}
	    	if(rs.getString(1).equals("Curr_L")) {dCurr_L1 = rs.getDouble(2)/100;dCurr_L0 = rs.getDouble(3)/100;}
	    	if(rs.getString(1).equals("Long_asset")) {dLong_asset1 = rs.getDouble(2)/100;dLong_asset0 = rs.getDouble(3)/100;}
	    	if(rs.getString(1).equals("D&A")) dD_A = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("Tax")) dTax = rs.getDouble(2)/100;
	    	if(rs.getString(1).equals("debt")) ddebt = rs.getDouble(2);
	    	if(rs.getString(1).equals("interest")) dinterest = rs.getDouble(2)/100;
	    }
	    rs.getStatement().close();

		double d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13;
		
		d1 = dSales*(1+dG);		//销售收入
		d2 = d1*dCost;			//主营业务成本
		d3 = d1*dOper_tax;		//主营业务税金和附加
		d4 = d1*dSale_fee;		//营业费用和其他主营业务成本
		d5 = d1*dGeneral_fee;	//管理费用
		d6 = d1*dOther_income;	//其他业务利润
		d7 = d1-d2-d3-d4-d5+d6;	//EBIT
		d8 = d7*(1-dTax)+ddebt*dinterest*dTax;	//息前净利润
		d9 = 0.5*dD_A*d1*(dLong_asset1+dLong_asset0/(1+dG));	//折旧和摊销
		d10 = d1/(1+dG)*((1+dG)*dCurrA1-dCurrA0-(1+dG)*dCurr_L1+dCurr_L0);	//营运资金变化
		d11 = d8+d9-d10;		//经营活动产生的现金流
		d12 = d1*(dLong_asset1-dLong_asset0/(1+dG));		//资本支出增加
		d13 = d11-d12;
		
		try
	    {
			//先删除数据
			String sNewSql = "delete from CashFlow_Data "+
							"  where CustomerID = :CustomerID "+
							"    and BaseYear = :BaseYear "+
							"    and ReportScope = :ReportScope " +
							"    and FCN = :FCN" ;
			so = new SqlObject(sNewSql);
			so.setParameter("CustomerID",customerID);
			so.setParameter("BaseYear",baseYear);
			so.setParameter("ReportScope",reportScope);
			so.setParameter("FCN",yearCount);
			Sqlca.executeSQL(so);

			//再插入数据
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
				" values(:customerid,:baseyear,:reportscope,:fcn,1,'销售收入',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d1);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,2,'主营业务成本',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d2);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
				 	  " values(:customerid,:baseyear,:reportscope,:fcn,3,'主营业务税金和附加',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d3);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,4,'营业费用和其他主营业务成本',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d4);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,5,'管理费用',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d5);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,6,'其他业务利润',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d6);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  " values(:customerid,:baseyear,:reportscope,:fcn,7,'EBIT',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d7);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,8,'息前净利润',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d8);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,9,'折旧和摊销',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d9);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,10,'营运资金变化',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d10);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,11,'经营活动产生的现金流',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d11);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,12,'资本支出增加',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d12);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,13,'自由现金流',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d13);
			Sqlca.executeSQL(so);
			sReturnValue="succeed";
	    }catch(Exception exception){
	    	ARE.getLog().info(exception);
	    	sReturnValue="failed";
	    }	
		return sReturnValue;
	}
}
