package com.amarsoft.app.billions;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class InsertFormatDocLog {
	
	
	private String serialNo;
	private String userID;
	private String orgID;
	private String occurType;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getOccurType() {
		return occurType;
	}

	public void setOccurType(String occurType) {
		this.occurType = occurType;
	}

	/**
	 * 插入格式化报告生成或查看记录
	 * @param Sqlca
	 * @return docID
	 */
	public String recordFormatDocLog(Transaction Sqlca) {

		try {
			//定义变量
			String sSql = "";
			
			/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
			String  sSerialNo = DBKeyHelp.getSerialNo("FormatDoc_Log", "SerialNo");*/
			
			String  sSerialNo = DBKeyUtils.getSerialNo("FL");
			/** --end --*/
			
			String  sOccurTime = StringFunction.getTodayNow();
			//判断当前处理类型
			if("produce".equals(occurType)){
				occurType = "1";
			}else{
				occurType = "2";
			}
			sSql = "insert into  FormatDoc_Log (SERIALNO,RELATIVESERIALNO,OBJECTNO,OBJECTTYPE,DOCID,ORGID,USERID,OCCURTYPE,OCCURTIME)   select "+
					"'"+sSerialNo+"',"+
					"SERIALNO,"+
					"OBJECTNO,"+
					"OBJECTTYPE,"+
					"DOCID,"+
					"'"+orgID+"',"+
					"'"+userID+"',"+
					"'"+occurType+"',"+
					"'"+sOccurTime+"'"+
					" from FormatDoc_Record where SerialNo = '"+serialNo+"'" ;
			
			Sqlca.executeSQL(sSql);
			    

			return "Success";
		} catch (Exception e) { 
			e.printStackTrace(); 
			return "Failure";
		}
	}
}
