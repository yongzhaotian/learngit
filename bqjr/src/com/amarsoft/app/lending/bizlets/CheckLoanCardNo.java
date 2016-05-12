package com.amarsoft.app.lending.bizlets;
/*
Author: --王业罡 2005-08-03
Tester:
Describe: --检查调查报告是否生成
Input Param:
		sObjectType：对象类型
		sObjectNo：对象编号
Output Param:

HistoryLog:
*/

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckLoanCardNo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		ASResultSet rs = null;
		if(sCustomerName == null) sCustomerName = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		
		//返回标志
		String sFlag = "";
		String sExistCustomerName ="";
		String sSql = " select CustomerName from CUSTOMER_INFO where  substr(LoanCardNo,1,16) = '"+sLoanCardNo.substring(0,16)+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sExistCustomerName = rs.getString("CustomerName");
		}
		rs.getStatement().close();

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
