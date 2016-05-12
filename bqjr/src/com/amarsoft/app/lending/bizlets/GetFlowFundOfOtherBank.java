package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * Author: qfang 2011-06-16
 * Tester:
 * Describe: --��ȡ���������ʽ����
            ���෽�������������ʽ�����Ϊ�ÿͻ������������ڻ���ҵ���Ľ�
 * Input Param:
        ObjectType: ��������(���롢��������ͬ)
		ObjectNo: ���롢��������ͬ��ˮ��
 * Output Param:
		otherSum�����������ʽ�����
 * HistoryLog:
*/
public class GetFlowFundOfOtherBank extends Bizlet{
	
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
		double otherSum = 0.0;
		
		//ȡҵ�����
		sSql = 	"select nvl(sum(Balance),0) as Balance from CUSTOMER_OACTIVITY where CustomerID=:sObjectNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
		if(rs.next())
		{			
			otherSum = rs.getDouble("Balance");
		}
		rs.getStatement().close();	
		return otherSum+"";
	}
}
