/**
 * 
 */
package com.amarsoft.app.als.product;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng 2013-7-5
 *
 */
public class BusinessTypeUniqueCheck 
{
	private String typeNo;
	
	public String getTypeNo() {
		return typeNo;
	}

	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}

	/**
	 * 
	 */
	public BusinessTypeUniqueCheck() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * 唯一性检验
	 */
	public String insertUniqueCheck(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;		
		boolean hasRecord = false;

		osql = new SqlObject("select count(*) as hasRecord from BUSINESS_TYPE where TypeNo = :TypeNo ");
		osql.setParameter("TypeNo", typeNo);
		rs = Sqlca.getASResultSet(osql);
		if(rs.next()){
			if(Integer.parseInt(rs.getString("hasRecord")) > 0){  //已经存在一类
				hasRecord = true;
			}
		}
		rs.getStatement().close();
		
		return (hasRecord == true) ? "true": "false";
	}
}
