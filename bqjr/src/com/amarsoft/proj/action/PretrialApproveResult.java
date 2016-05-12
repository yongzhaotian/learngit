package com.amarsoft.proj.action;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 *   获取预审结果
 * @author Tayle
 *
 */
public class PretrialApproveResult {
	private String  serialNo = "";//合同编号
	private String customerID = "";//客户编号
	private String customerType = "";//客户类型
	private String sResult = "";//返回结果 01拒绝， 02通过 
	
	/**
	 * 调用规则引擎获取返回结果
	 * @param Sqlca
	 * @return
	 */
	public  String getResult(Transaction Sqlca){
		ARE.getLog().debug("====================调用规则引擎=======================");
		ARE.getLog().debug("====================serialNo="+serialNo+",customerID="+customerID+"========");
		sResult = "02";
		ARE.getLog().debug("==================规则引擎返回结果:"+sResult+"=======================");
		return sResult;
	}

	
	/**
	 * 判断是否存在未预审的记录
	 * @return
	 * @throws SQLException 
	 */
	public String isFinishAll(Transaction Sqlca) throws SQLException{
		int i=0;
		String sSql =  "select count(1) as  n  from contract_relative a where a.serialno=:serialno and (PRETRIALRESULT is null ) ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno", serialNo));
		if(rs.next()) 
		{
			i=rs.getInt("n");
		}
		rs.getStatement().close();
		
		if(i>0){//存在
			return "false";
		}else{//不存在
			return "true";
		}
	}
	
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	
}
