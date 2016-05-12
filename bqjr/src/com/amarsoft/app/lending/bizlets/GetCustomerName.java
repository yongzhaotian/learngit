package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCustomerName extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sCustomerName = null;
		String sSql = null;
		
		if(sCustomerID!=null) {
			sSql = "select CustomerID from CUSTOMER_BELONG where CustomerID=:CustomerID";
			SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			sCustomerName = Sqlca.getString(so);
		}
		return sCustomerName;
	}

}
