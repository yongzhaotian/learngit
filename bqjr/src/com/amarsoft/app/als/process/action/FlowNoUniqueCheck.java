/**
 * 
 */
package com.amarsoft.app.als.process.action;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng 2013-7-5
 *
 */
public class FlowNoUniqueCheck 
{
	private String flowNo;
	private String tableName;
	private String phaseNo = "";
	
	public String getPhaseNo() {
		return phaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	
	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	/**
	 * 
	 */
	public FlowNoUniqueCheck() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * 唯一性检验
	 */
	public String insertUniqueCheck(Transaction Sqlca) throws Exception{
		SqlObject osql = null;
		ASResultSet rs = null;		
		boolean hasRecord = false;

		String sql = "select count(*) as hasRecord from " + tableName +" where FlowNo = :FlowNo ";
		if (phaseNo.length() > 0){
			sql += " and PhaseNo = '" + phaseNo +"' ";
		}
		
		osql = new SqlObject(sql);
		osql.setParameter("FlowNo", flowNo);
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