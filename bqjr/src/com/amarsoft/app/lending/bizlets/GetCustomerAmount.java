/*
		Author: --CYHui 2005-12-13
		Tester:
		Describe: --ȡ�õ�ǰ�ͻ�����ܻ���δ���嵥��׻�����Ч���������Ŀͻ�����
		Input Param:
				UserID���û�����
		Output Param:
				iCustomerAmount������
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCustomerAmount extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//��ȡ��ǰ�û�
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���
		if(sUserID == null) sUserID = "";
		
		//���������SQL���
		String sSql = "";
		int iCustomerAmount = 0;
				
		sSql =  "select nvl(count(distinct CustomerID),0) from BUSINESS_CONTRACT where OperateUserID =:sUserID ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sUserID", sUserID));
		if(rs.next())
			iCustomerAmount = rs.getInt(1);
		rs.getStatement().close();
		
		sSql = "select nvl(count(distinct CustomerID),0) from BUSINESS_APPROVE where OperateUserID =:sUserID1 and CustomerID not in(select CustomerID from BUSINESS_CONTRACT where OperateUserID =:sUserID2)";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sUserID1", sUserID).setParameter("sUserID2", sUserID));
		if(rs.next())
			iCustomerAmount = iCustomerAmount + rs.getInt(1);
		rs.getStatement().close();
				
		return String.valueOf(iCustomerAmount);
	}
}