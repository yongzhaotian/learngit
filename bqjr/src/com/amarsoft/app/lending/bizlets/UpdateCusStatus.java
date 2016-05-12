package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/*
 * Author: jgao1 2009.10.19
 * Tester:
 * Describe: ������С��ҵ�϶�������status�ֶε�ֵ
 * Input Param:
 * 			ObjectNo: ������
 * 			Status:   ״ֵ̬
 * Output Param:
 * HistoryLog:
 */
public class UpdateCusStatus extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sStatus = (String)this.getAttribute("Status");
		//�϶��ͻ����
		String sCustomerID="";

		String sSql = "";
		ASResultSet rs=null;
		SqlObject so;
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		//��ѯ�϶���ɺ������϶��˵���������������
		sSql = 	" select CustomerID from SME_APPLY"+
				" where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sCustomerID=rs.getString("CustomerID");
		}
		if(sCustomerID==null) sCustomerID="";
		rs.getStatement().close();

		//������С��ҵ�϶���¼�� 0����δ�϶���1�������϶���2���������3�����϶���
		sSql = " UPDATE CUSTOMER_INFO SET Status=:Status "+
		 		" WHERE CustomerID=:CustomerID";
		so = new SqlObject(sSql).setParameter("Status", sStatus).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		return "1";
	}
}

