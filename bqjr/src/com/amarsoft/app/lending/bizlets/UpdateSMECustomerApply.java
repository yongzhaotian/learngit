package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/*
 * Author: jgao1 2009.10.19
 * Tester:
 * Describe: 修改中小企业认定申请时的逻辑
 * Input Param:
 * 			sSerialNo: 申请流水号
 * Output Param:
 * HistoryLog:
 */
public class UpdateSMECustomerApply extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception{
        
		String sSerialNo   = (String)this.getAttribute("SerialNo");
		//定义变量
		String sCustomerID = "";
		String sScope = "";
		String sSMEIndustryType = "";
		double dEmployeeNumber = 0.0;
		double dSellSum = 0.0;
		double dTOTALASSETS = 0.0;
		String sSql = "";
		ASResultSet rs = null;
		SqlObject so;

		sSql = 	" select CustomerID,Attribute6,Attribute7,Attribute1,Attribute2,Attribute3 "+
				" from SME_APPLY "+
				" where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getResultSet(so);
	    if(rs.next()){
	    	sCustomerID = rs.getString("CustomerID");
	    	sScope = rs.getString("Attribute6");
	    	sSMEIndustryType = rs.getString("Attribute7");
	    	dEmployeeNumber = rs.getDouble("Attribute1");
	    	dSellSum = rs.getDouble("Attribute2");
	    	dTOTALASSETS = rs.getDouble("Attribute3");
	    }	    
	    rs.getStatement().close(); 
	    
	    sSql=" update Customer_Info set Status='3' where CustomerID=:CustomerID ";
	    so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
	    Sqlca.executeSQL(so);
	    
	    sSql=" update ENT_INFO set Scope=:Scope,"+
		     " SMEIndustryType=:SMEIndustryType,"+
		     " EmployeeNumber=:EmployeeNumber,"+
		     " SellSum=:SellSum,"+
		     " TOTALASSETS=:TOTALASSETS"+
		     " where CustomerID=:CustomerID";	
	    so = new SqlObject(sSql).setParameter("Scope", sScope).setParameter("SMEIndustryType", sSMEIndustryType)
	    .setParameter("EmployeeNumber", dEmployeeNumber).setParameter("SellSum", dSellSum).setParameter("TOTALASSETS", dTOTALASSETS)
	    .setParameter("CustomerID", sCustomerID);
	    Sqlca.executeSQL(so);	 
	    return "1";
	 }

}
