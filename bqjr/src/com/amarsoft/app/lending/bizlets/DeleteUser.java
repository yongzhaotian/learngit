package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class DeleteUser extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值		
		String sUserID   = (String)this.getAttribute("UserID");
				
		//定义变量		
		String sSql = null;
		SqlObject so ;//声明对象
		//逻辑删除用户，即将用户状态置为停用
		sSql="update USER_INFO set Status = '2' where UserID =:UserID";
		so = new SqlObject(sSql).setParameter("UserID", sUserID);
		Sqlca.executeSQL(so);
	    
		//删除用户的角色
		 sSql = 	" delete from USER_ROLE where UserID =:UserID ";
		 so = new SqlObject(sSql).setParameter("UserID", sUserID);
		 Sqlca.executeSQL(so);
	    
	    //删除用户的权限
		sSql = 	" delete from USER_RIGHT where UserID =:UserID ";
		so = new SqlObject(sSql).setParameter("UserID", sUserID);
		Sqlca.executeSQL(so);
	    return "1";
	 }
}
