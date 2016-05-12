package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CommonTransationFix {

	public String contractRegistration(Transaction Sqlca) throws SQLException {
		
		try {
			String updateFOSql = "UPDATE FLOW_OBJECT SET PHASETYPE='1070' WHERE OBJECTTYPE='BusinessContract' AND OBJECTNO=:OBJECTNO ";
			String updateBCSql = "UPDATE BUSINESS_CONTRACT SET CONTRACTSTATUS='020',SIGNEDDATE=:SIGNEDDATE,SHIFTDOCDESCRIBE=:SHIFTDOCDESCRIBE WHERE SERIALNO=:SERIALNO";
			Sqlca.executeSQL(new SqlObject(updateFOSql).setParameter("OBJECTNO", objectno));
			Sqlca.executeSQL(new SqlObject(updateBCSql).setParameter("SERIALNO", objectno).setParameter("SIGNEDDATE", SystemConfig.getBusinessDate()).setParameter("SHIFTDOCDESCRIBE", DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")));
		} catch (Exception e) {
			e.printStackTrace();
			Sqlca.rollback();
			return "Failure";
		}
		
		return "Success";
	}
	
	private String objectno;
	public void setObjectno(String objectno) {
		this.objectno = objectno;
	}
	public String getObjectno() {
		return objectno;
	}

}
