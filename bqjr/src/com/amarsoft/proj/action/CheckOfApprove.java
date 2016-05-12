package com.amarsoft.proj.action;

import java.sql.SQLException;

import sun.security.krb5.internal.crypto.dk.DkCrypto;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 汽车金融流程审批校验
 * @author Tayle
 *
 */
public class CheckOfApprove {
	private String  TRUE = "true"; 
	private String  FALSE = "false";
	private String serialNo="";
	private String objectNo="";

	/**
	 * 检查项是否已检查完成
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String isSubmit(Transaction Sqlca) throws SQLException{
		int n=0;
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select count(1) as n from  Flow_opinion where Serialno = '"+serialNo+"'  and (ATTRIBUTE1='2' or ATTRIBUTE2='2' or ATTRIBUTE3='2' or ATTRIBUTE4='2' or ATTRIBUTE5='2' or ATTRIBUTE6='2'  or  ATTRIBUTE1 is null  or ATTRIBUTE2 is null  or ATTRIBUTE3 is null  or ATTRIBUTE4 is null  or ATTRIBUTE5 is null  or ATTRIBUTE6 is null   )"));
		if(rs.next()){
			n = rs.getInt("n");
		}
		rs.getStatement().close();
		if(n<=0){
			return TRUE;
		}else{
			return FALSE;
		}
	}
	
	/**
	 * 判断是否需要家访
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String insertHomeInfo(Transaction Sqlca) throws Exception{
		//判断是否需要家访
		if(true){
			int i= 0;
			String sSql = " select Count(1)  as n from home_info where APPLYSERIALNO='"+objectNo+"'";
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql));
			if(rs.next()){
				i = rs.getInt("n");
			}
			rs.getStatement().close();
			if(i<=0){
				String HSerialNo = DBKeyHelp.getSerialNo("home_info","SerialNo","");
				String CUSTOMERNAME = Sqlca.getString(new SqlObject("select CUSTOMERNAME from BUsiness_contract where SerialNo='"+objectNo+"'"));
				String SERVICEUSER = "";//服务商
				
				sSql = "insert into home_info (SERIALNO, CUSTOMERNAME, HOMETYPE, STARTDATE, ENDDATE, ORDERDATE, SERVICEUSER, INPUTDATE, HOMEMODEL, HOMESTATUS, DESCRIPTION, REMARK, APPLYSERIALNO) "+
						"  values ('"+HSerialNo+"', '"+CUSTOMERNAME+"', '01', :STARTDATE, '', '', '"+SERVICEUSER+"', :INPUTDATE, '02', '1', '', '', '"+objectNo+"')";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("INPUTDATE", StringFunction.getTodayNow()).setParameter("STARTDATE", StringFunction.getToday()));
				Sqlca.commit();
			}
			return TRUE;
		}else{
			return FALSE;
		}
		
	}
	
	
	
	/**
	 * 家访判断
	 * @param Sqlca
	 * @return
	 * @throws SQLException 
	 */
	public String isHomeCheck(Transaction Sqlca) throws SQLException{
		String sHomeStatus = "";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select HomeStatus from home_info where APPLYSERIALNO='"+objectNo+"'"));
		if(rs.next()){
			sHomeStatus = rs.getString("HomeStatus");
		}
		rs.getStatement().close();
		if("2".equals(sHomeStatus)){//已完成家访
			return TRUE;
		}else{
			return FALSE;
		}
	}
	
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	
}
