package com.amarsoft.app.lending.bizlets;
/*
Author: --fwang 2009-11-09
Tester:
Describe: --检查股东姓名是否被修改
Input Param:
		sObjectType：对象类型
		sObjectNo：对象编号
Output Param:

HistoryLog:
*/

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCustomerName extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertID = (String)this.getAttribute("CertID");
		if(sCustomerName == null) sCustomerName = "";
		if(sCertID == null) sCertID = "";
		
		//返回标志
		String sFlag = "";
		
		
		String sSql = " select CustomerName from CUSTOMER_INFO where CertID =:CertID ";
		SqlObject so = new SqlObject(sSql).setParameter("CertID", sCertID);
		String sExistCustomerName = Sqlca.getString(so);
		
		if(sExistCustomerName == null) sExistCustomerName = "";
		
		if(sExistCustomerName.equals(""))
			sFlag = "Only";
		else
		{
			if(sExistCustomerName.equals(sCustomerName))
				sFlag = "Only";
			else
				sFlag = "Many";
		}
		
		return sFlag;
	}
}
