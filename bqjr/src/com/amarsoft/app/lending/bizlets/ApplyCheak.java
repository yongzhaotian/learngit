package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ApplyCheak {
	/**合同号**/
	private String serialNo;
	/**销售经理**/
	private String salesManager;
	/**贷款人编号**/
	private String creditID;
	/**城市编码**/
	private String storeCityCode;
	/**产品子类型**/
	private String subProDuctType;
	
	public String cheakMangees(Transaction transaction){
		StringBuffer sb = new StringBuffer("SELECT SALESMANAGER,CREDITID,STORECITYCODE,SUBPRODUCTTYPE ");
		sb.append("FROM BUSINESS_CONTRACT BC WHERE SERIALNO = :SERIALNO");
		ASResultSet srs;
		try {
			srs = transaction.getASResultSet(new SqlObject(sb.toString())
					.setParameter("SERIALNO", serialNo));
			while(srs.next()){
				salesManager = srs.getString("SALESMANAGER");
				creditID = srs.getString("CREDITID");
				storeCityCode = srs.getString("STORECITYCODE");
				subProDuctType = srs.getString("SUBPRODUCTTYPE");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return "false@数据异常，无法提交";
		}
		
		if (salesManager == null || "".equals(salesManager)){
			return "false@提交失败，销售经理为空，请联系IT部处理";
		}
		if (creditID == null || "".equals(creditID)){
			return "false@提交失败，合同贷款人为空，请联系IT部处理";
		}
		if (storeCityCode == null || "".equals(storeCityCode)){
			return "false@提交失败，城市编码为空，请联系IT部处理";
		}
		if (subProDuctType == null || "".equals(subProDuctType)){
			return "false@提交失败，产品类型为空，请联系IT部处理";
		}
		return "true";
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getSalesManager() {
		return salesManager;
	}

	public void setSalesManager(String salesManager) {
		this.salesManager = salesManager;
	}

	public String getCreditID() {
		return creditID;
	}

	public void setCreditID(String creditID) {
		this.creditID = creditID;
	}

	public String getStoreCityCode() {
		return storeCityCode;
	}

	public void setStoreCityCode(String storeCityCode) {
		this.storeCityCode = storeCityCode;
	}

	public String getSubProDuctType() {
		return subProDuctType;
	}

	public void setSubProDuctType(String subProDuctType) {
		this.subProDuctType = subProDuctType;
	}
	
}
