package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CancelFlow extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "";
		SqlObject so = null;//��������
		//ɾ�����̶�����Ϣ
		sSql =  " delete from FLOW_OBJECT where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
			
		//ɾ�����̹�����Ϣ	
		sSql =  " delete from FLOW_TASK where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
				
		return "1";
	}		
}
