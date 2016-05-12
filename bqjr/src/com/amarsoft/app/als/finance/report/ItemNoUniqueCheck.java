/**
 * 
 */
package com.amarsoft.app.als.finance.report;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng
 *
 */
public class ItemNoUniqueCheck 
{
	private String itemNo;
	
	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}
	
	/**
	 * 
	 */
	public ItemNoUniqueCheck() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * Ψһ�Լ���
	 */
	public String insertUniqueCheck(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;		
		boolean hasRecord = false;

		osql = new SqlObject("select count(*) as hasRecord from FINANCE_ITEM where ItemNo = :ItemNo ");
		osql.setParameter("ItemNo", itemNo);
		rs = Sqlca.getASResultSet(osql);
		if(rs.next()){
			if(Integer.parseInt(rs.getString("hasRecord")) > 0){  //�Ѿ����ڿ�Ŀ���
				hasRecord = true;
			}
		}
		rs.getStatement().close();
		
		return (hasRecord == true) ? "true": "false";
	}
}
