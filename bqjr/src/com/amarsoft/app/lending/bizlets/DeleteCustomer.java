package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCustomer extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		SqlObject so ;//��������
		String sSql = "",sCustomerType = "";//Sql���		
		sSql = "select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		sCustomerType = Sqlca.getString(so);
		
		if(sCustomerType!=null)
		{
			//ɾ���ͻ�������Ϣ			
			sSql = 	" delete from CUSTOMER_INFO where CustomerID =:CustomerID ";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			Sqlca.executeSQL(so);
			
			if(sCustomerType.startsWith("01"))
			{	
				//ɾ����˾�ͻ���Ϣ
				sSql = 	" delete from ENT_INFO where CustomerID =:CustomerID ";
				so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
				Sqlca.executeSQL(so);
			}else if(sCustomerType.startsWith("03"))
			{
				//ɾ�����˿ͻ���Ϣ
				sSql = 	" delete from IND_INFO where CustomerID =:CustomerID ";
				so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
				Sqlca.executeSQL(so);
			}
		}
		
		return "1";
	}		
}
