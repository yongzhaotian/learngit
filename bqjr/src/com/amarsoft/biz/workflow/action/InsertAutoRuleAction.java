package com.amarsoft.biz.workflow.action;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
public class InsertAutoRuleAction {

	private String serialNo = null;

	/**
	 * 记录提单时间与更新状态为0701  待批量状态
	 * @param Sqlca
	 * @throws Exception
	 */
	public void updateBusinssConByserialNo(Transaction Sqlca) throws Exception {
		 Date date = new Date(); 
		 SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");//其中yyyy-MM-dd是你要表示的格式 
		 String str=sdf.format(date); 
		 String sSql = "update business_contract set  ContractStatus='0701' where  SerialNo = :SERIALNO";
		 String insersql = "insert into batch_bc_engine(CONTRACTNO,CONTRACTSTATUS,INPUTDATE) VALUES(:SERIALNO,'0701',:STRDATE)";
		 Sqlca.executeSQL(new SqlObject(sSql).setParameter("SERIALNO", serialNo));
		 Sqlca.executeSQL(new SqlObject(insersql).setParameter("SERIALNO", serialNo).setParameter("STRDATE", str));
		 Sqlca.commit();
		ARE.getLog().debug(this.getClass().getName()+"把提单的流水号:"+serialNo+"状态改为0701");
	}
   
	/**
	 * 
	 * 后期规则引擎提交插入任务池
	 * @param serialNo
	 * @param objectType
	 * @param objectNo
	 * @param oldPhaseNo
	 * @param userID
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */	
	protected String addData(String serialNo,String objectType,String objectNo,String oldPhaseNo,String userID,Transaction sqlca) throws Exception{
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str="";
		int count=0;
		String selectSQL="SELECT count(*) as count FROM BATCH_AFTER_RULE WHERE objectno=:objectno";
		ASResultSet rs = sqlca.getASResultSet(new SqlObject(selectSQL)
		.setParameter("objectno", objectNo));
		if(rs.next())count=rs.getInt("count");
		if(count>0){
			str="exits";
		}else{
		String sql="insert into BATCH_AFTER_RULE(serialno,objectType,objectNo,userID,oldPhaseNo,inputdate,Status)values(:serialno,:objectType,:objectno,:userID,:oldPhaseNo,:inputdate,:Status)";
		SqlObject so=new SqlObject(sql);
		so.setParameter("serialno", serialNo);
		so.setParameter("objectType", objectType);
		so.setParameter("objectno", objectNo);
		so.setParameter("userID", userID);
		so.setParameter("oldPhaseNo", oldPhaseNo);
		so.setParameter("inputdate", sdf.format(new Date()));
		so.setParameter("Status", "0");
		sqlca.executeSQL(so);
		   str="noexits";
		}
		   rs.getStatement().close();
		   return str;
	}
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
 


}
