package com.amarsoft.biz.workflow.action;

import java.sql.SQLException;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CheckID5TimeOut {
	private String ReqHeader = "";
	private String ReqData = "";
	
	public String CheckTimeOut(Transaction Sqlca) throws SQLException{
		String sSql = "";
		String sPare = ReqHeader+"#"+ReqData;
		String sCount = "";
		
		if("1A020201".equals(ReqHeader)){
			sSql = "select Count(1) as cnt from ID5_XML_ELE_VAL where serialno=:serialno";
		}else if("1C1G01".equals(ReqHeader)){
			sSql = "select Count(1) as cnt from ID5_XML_ELE_VAL where serialno=:serialno" +
				   " and (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30))<=0 ";
		}else{
			return sCount;
		}
		sCount = Sqlca.getString(new SqlObject(sSql).setParameter("serialno", sPare));
		return sCount;
	}

	public String getReqHeader() {
		return ReqHeader;
	}

	public void setReqHeader(String reqHeader) {
		ReqHeader = reqHeader;
	}

	public String getReqData() {
		return ReqData;
	}

	public void setReqData(String reqData) {
		ReqData = reqData;
	}
}
