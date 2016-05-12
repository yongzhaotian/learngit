package com.amarsoft.app.lending.bizlets;
/*
Author: --��ҵ� 2005-08-03
Tester:
Describe: --�����鱨���Ƿ�����
Input Param:
		sObjectType����������
		sObjectNo��������
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
		//�Զ���ô���Ĳ���ֵ
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		ASResultSet rs = null;
		if(sCustomerName == null) sCustomerName = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		
		//���ر�־
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
