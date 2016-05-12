package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class DeleteUser extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ		
		String sUserID   = (String)this.getAttribute("UserID");
				
		//�������		
		String sSql = null;
		SqlObject so ;//��������
		//�߼�ɾ���û��������û�״̬��Ϊͣ��
		sSql="update USER_INFO set Status = '2' where UserID =:UserID";
		so = new SqlObject(sSql).setParameter("UserID", sUserID);
		Sqlca.executeSQL(so);
	    
		//ɾ���û��Ľ�ɫ
		 sSql = 	" delete from USER_ROLE where UserID =:UserID ";
		 so = new SqlObject(sSql).setParameter("UserID", sUserID);
		 Sqlca.executeSQL(so);
	    
	    //ɾ���û���Ȩ��
		sSql = 	" delete from USER_RIGHT where UserID =:UserID ";
		so = new SqlObject(sSql).setParameter("UserID", sUserID);
		Sqlca.executeSQL(so);
	    return "1";
	 }
}
