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
		
		double dSales=0;	//��Ӫҵ������(��Ԫ)
		double dG=0;		//��Ӫҵ������������(%)
		double dCost=0;		//��Ӫҵ��ɱ�/��Ӫҵ������(%)
		double dOper_tax=0;		//��Ӫҵ��˰�𼰸���/��Ӫҵ������(%)
		double dSale_fee=0;		//��Ӫҵ����+������Ӫҵ��ɱ���/��Ӫҵ������(%)
		double dGeneral_fee=0;		//�������/��Ӫҵ������(%)
		double dOther_income=0;		//����ҵ������/��Ӫҵ������(%)
		double dCurrA1=0;		//�������ʲ��������ʽ�Ͷ���Ͷ�ʣ�/��Ӫҵ������(%)
		double dCurrA0=0;
		double dCurr_L1=0;		//��������ծ�����ڽ���һ���ڵ��ڵĳ��ڸ�ծ��/��Ӫҵ������(%)
		double dCurr_L0=0;
		double dLong_asset1=0;		//�̶��ʲ���ֵ�������ʲ�/��Ӫҵ������(%)
		double dLong_asset0=0;
		double dD_A=0;		//�����۾ɺ�̯���ܶ�/�����ĩƽ��(�̶��ʲ���ֵ+�����ʲ�)(%)
		double dTax=0;		//����˰��(%)
		double ddebt=0;		//��Ϣծ���ܶ�(��Ԫ)
		double dinterest=0;		//ƽ������(%)
		
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
		
		d1 = dSales*(1+dG);		//��������
		d2 = d1*dCost;			//��Ӫҵ��ɱ�
		d3 = d1*dOper_tax;		//��Ӫҵ��˰��͸���
		d4 = d1*dSale_fee;		//Ӫҵ���ú�������Ӫҵ��ɱ�
		d5 = d1*dGeneral_fee;	//�������
		d6 = d1*dOther_income;	//����ҵ������
		d7 = d1-d2-d3-d4-d5+d6;	//EBIT
		d8 = d7*(1-dTax)+ddebt*dinterest*dTax;	//Ϣǰ������
		d9 = 0.5*dD_A*d1*(dLong_asset1+dLong_asset0/(1+dG));	//�۾ɺ�̯��
		d10 = d1/(1+dG)*((1+dG)*dCurrA1-dCurrA0-(1+dG)*dCurr_L1+dCurr_L0);	//Ӫ���ʽ�仯
		d11 = d8+d9-d10;		//��Ӫ��������ֽ���
		d12 = d1*(dLong_asset1-dLong_asset0/(1+dG));		//�ʱ�֧������
		d13 = d11-d12;
		
		try
	    {
			//��ɾ������
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

			//�ٲ�������
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
				" values(:customerid,:baseyear,:reportscope,:fcn,1,'��������',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d1);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,2,'��Ӫҵ��ɱ�',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d2);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
				 	  " values(:customerid,:baseyear,:reportscope,:fcn,3,'��Ӫҵ��˰��͸���',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d3);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,4,'Ӫҵ���ú�������Ӫҵ��ɱ�',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d4);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,5,'�������',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d5);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,6,'����ҵ������',:itemvalue)";
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
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,8,'Ϣǰ������',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d8);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,9,'�۾ɺ�̯��',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d9);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  		  " values(:customerid,:baseyear,:reportscope,:fcn,10,'Ӫ���ʽ�仯',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d10);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,11,'��Ӫ��������ֽ���',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d11);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,12,'�ʱ�֧������',:itemvalue)";
			so = new SqlObject(sNewSql);
			so.setParameter("customerid",customerID);
			so.setParameter("baseyear",baseYear);
			so.setParameter("reportscope",reportScope);
			so.setParameter("fcn",yearCount);
			so.setParameter("itemvalue",d12);
			Sqlca.executeSQL(so);
			sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
					  " values(:customerid,:baseyear,:reportscope,:fcn,13,'�����ֽ���',:itemvalue)";
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
