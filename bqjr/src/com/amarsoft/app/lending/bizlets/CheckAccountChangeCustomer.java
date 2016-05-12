package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckAccountChangeCustomer extends Bizlet{
	
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sAccount = (String)this.getAttribute("Account");
		ASResultSet rs = null;
		String sExistAccount = "";
		String sFlag ="";
		
		String sSql = "select Account from ACCOUNT_INFO where Account =:Account ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Account", sAccount));
		if(rs.next())
		{
			sExistAccount = rs.getString("Account");
		}
		rs.getStatement().close();
		
		if(sExistAccount == null) sExistAccount = "";
		if(sExistAccount.equals(""))
		{
			sFlag = "true";
		}else
		{
			sFlag = "false";
		}
		
		return sFlag;
	}
}
