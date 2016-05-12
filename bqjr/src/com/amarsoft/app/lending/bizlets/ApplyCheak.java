package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ApplyCheak {
	/**��ͬ��**/
	private String serialNo;
	/**���۾���**/
	private String salesManager;
	/**�����˱��**/
	private String creditID;
	/**���б���**/
	private String storeCityCode;
	/**��Ʒ������**/
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
			return "false@�����쳣���޷��ύ";
		}
		
		if (salesManager == null || "".equals(salesManager)){
			return "false@�ύʧ�ܣ����۾���Ϊ�գ�����ϵIT������";
		}
		if (creditID == null || "".equals(creditID)){
			return "false@�ύʧ�ܣ���ͬ������Ϊ�գ�����ϵIT������";
		}
		if (storeCityCode == null || "".equals(storeCityCode)){
			return "false@�ύʧ�ܣ����б���Ϊ�գ�����ϵIT������";
		}
		if (subProDuctType == null || "".equals(subProDuctType)){
			return "false@�ύʧ�ܣ���Ʒ����Ϊ�գ�����ϵIT������";
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
