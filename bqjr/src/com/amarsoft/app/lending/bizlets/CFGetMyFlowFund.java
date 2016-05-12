
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * Author: --qfang 2011-06-03
 * Tester:
 * Describe: --��ȡ���������ʽ����
            ���෽���б��������ʽ�����Ϊ�ÿͻ���δ����ҵ�������ܺ͡�
 * Input Param:
        ObjectType: ��������(���롢��������ͬ)
		ObjectNo: ���롢��������ͬ��ˮ��
 * Output Param:
		dTotalBalance�����������ʽ�����
 * HistoryLog:
*/

public class CFGetMyFlowFund extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��ö�������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��ö�����
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//���������SQL���
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs = null;
		//���������ʽ�����
		double dTotalBalance = 0.0;
		
		//ȡ��ͬ����ܺ�
		sSql = 	"select nvl(sum(Balance),0) as TotalBalance from BUSINESS_CONTRACT where BusinessType like '1010%' and CustomerID=:CustomerID";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sObjectNo));
		if(rs.next())
		{			
			dTotalBalance = rs.getDouble("TotalBalance");
		}
		rs.getStatement().close();	   	
		return dTotalBalance+"";
	}
	
}
