package com.amarsoft.app.lending.bizlets;


import com.amarsoft.awe.util.Transaction;

public class InsertEvalue {

	private String colName;
	private String colValue;
	public String getColName() {
		return colName;
	}
	public void setColName(String colName) {
		this.colName = colName;
	}
	public String getColValue() {
		return colValue;
	}
	public void setColValue(String colValue) {
		this.colValue = colValue;
	}

	/**
	 * �����¼���¼
	 * @param Sqlca
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String recordEvent(Transaction Sqlca)  {
		//��������
		
		String sCols = colName.replaceAll("@", ",");
		String sVals = "'"+colValue.replaceAll("@", "','")+"'";
		
		//�������
		String sSql = "";
		sSql = "insert into EVENT_INFO("+sCols+") values("+sVals+")";
		try {
			Sqlca.executeSQL(sSql);
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		return "Success";
	}
	
}
