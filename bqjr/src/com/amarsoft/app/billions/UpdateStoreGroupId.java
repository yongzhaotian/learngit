package com.amarsoft.app.billions;

import com.amarsoft.awe.util.Transaction;

public class UpdateStoreGroupId {

	String sSNos;
	String sGroupNo;
	
	public String getSSNos() {
		return sSNos;
	}
	public void setSSNos(String sSNos) {
		this.sSNos = sSNos;
	}
	public String getSGroupNo() {
		return sGroupNo;
	}
	public void setSGroupNo(String sGroupNo) {
		this.sGroupNo = sGroupNo;
	}

	public UpdateStoreGroupId(){}
	
	public String updateGroupNos(Transaction Sqlca) {
		String sRetVal = "FAIL";
		String sSNo = sSNos.replace("@", "','");
		
		String sSql = "update Store_Info set GroupNo='"+sGroupNo+"' where SNo in ('"+sSNo+"')";
		try {
			int rows = Sqlca.executeSQL(sSql); 
			if (rows>0) sRetVal = "SUCCESS";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sRetVal;
	}
}