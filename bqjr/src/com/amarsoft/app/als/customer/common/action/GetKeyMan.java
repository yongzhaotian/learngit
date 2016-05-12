/**
 * 
 */
package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng 2013/05/29
 *
 */
public class GetKeyMan {
	private String customerID;
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	/**
	 * 
	 */
	public GetKeyMan() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @return hasKeyMan	是否已经存在一名法人代表（高管）
	 */
	public String hasKeyMan(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;		
		boolean hasKeyMan = false;

		osql = new SqlObject("select count(*) as keyManNum from CUSTOMER_RELATIVE where CustomerId = :CustomerId  and RelationShip = '0100'");
		osql.setParameter("CustomerId", customerID);
		rs = Sqlca.getASResultSet(osql);
		if(rs.next()){
			if(Integer.parseInt(rs.getString("keyManNum")) > 0){  //存在一名法人代表(高管)
				hasKeyMan = true;
			}
		}
		rs.getStatement().close();
		
		return (hasKeyMan == true) ? "true": "false";
	}
}
