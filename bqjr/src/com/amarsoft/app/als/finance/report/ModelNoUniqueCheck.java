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
public class ModelNoUniqueCheck 
{
	private String modelNo;
	
	public String getModelNo() {
		return modelNo;
	}

	public void setModelNo(String modelNo) {
		this.modelNo = modelNo;
	}

	/**
	 * 
	 */
	public ModelNoUniqueCheck() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * Ψһ�Լ���
	 */
	public String insertUniqueCheck(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;		
		boolean hasRecord = false;

		osql = new SqlObject("select count(*) as hasRecord from REPORT_CATALOG where ModelNo = :ModelNo ");
		osql.setParameter("ModelNo", modelNo);
		rs = Sqlca.getASResultSet(osql);
		if(rs.next()){
			if(Integer.parseInt(rs.getString("hasRecord")) > 0){  //�Ѿ����ڱ�����
				hasRecord = true;
			}
		}
		rs.getStatement().close();
		
		return (hasRecord == true) ? "true": "false";
	}
}
