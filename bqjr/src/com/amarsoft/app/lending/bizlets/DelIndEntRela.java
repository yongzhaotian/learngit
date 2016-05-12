package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �ڸ��徭Ӫ��������ɾ���û�������С��ҵʱ�������Ӵ�����ҵ��û�������ϵ������
 * @author pwang
 *
 */
public class DelIndEntRela extends Bizlet {
	/**
	 * @param  CustomerID
	 * @param  UserID
	 * @author pwang
	 */
	public Object run(Transaction Sqlca) throws Exception{
		//�������
		String sReturnValue = "";		
		
		//��ȡҳ��������ͻ�ID,�û�ID
		String sCustomerID   = (String)this.getAttribute("CustomerID");	

		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
	
		try{
			//ɾ��sme_custrela������ϵ��
			//��Ϊcustomeridֻ���ܸ�һ��relativeserialno�й�ϵ
			SqlObject so = new SqlObject("Delete from  SME_CUSTRELA where CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID);
			Sqlca.executeSQL(so);
			//����ֵ
			sReturnValue = "1";
		}catch(Exception e)
		{
			throw new Exception("ɾ������ʧ�ܣ�"+e.getMessage());
		}
		return sReturnValue ;
	}
	
}
