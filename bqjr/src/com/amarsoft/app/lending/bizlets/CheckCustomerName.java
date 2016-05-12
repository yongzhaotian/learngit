package com.amarsoft.app.lending.bizlets;
/*
Author: --fwang 2009-11-09
Tester:
Describe: --���ɶ������Ƿ��޸�
Input Param:
		sObjectType����������
		sObjectNo��������
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
		//�Զ���ô���Ĳ���ֵ
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertID = (String)this.getAttribute("CertID");
		if(sCustomerName == null) sCustomerName = "";
		if(sCertID == null) sCertID = "";
		
		//���ر�־
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
