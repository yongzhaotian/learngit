package com.amarsoft.app.lending.bizlets;

/* Author: djia 2009-10-29
 * Tester:
 * Describe: 更新Reserve_total和Reserve_apply认定阶段号
 * Input Param:
 *        PhaseNo  阶段编号
 *        ObjectNo 申请流水号
 * Output Param:
 * 
 * HistoryLog:
 */
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class ReserverUpdateCflag extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		if(sPhaseNo == null) sPhaseNo = "";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		String sAccountMonth = null;
		String sDUEBILLNO = null;
		String sSql = "";
	    SqlObject so; //声明对象			
		//取会计月份和借据号
		sSql = 	" select AccountMonth,DUEBILLNO from RESERVE_APPLY "+
		" where SERIALNO=:SERIALNO";
		so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sAccountMonth = rs.getString("AccountMonth");
			sDUEBILLNO = rs.getString("DUEBILLNO");	
		}
		rs.getStatement().close();

		sSql = 	" UPDATE RESERVE_TOTAL SET Cognizanceflag=:Cognizanceflag WHERE ACCOUNTMONTH=:ACCOUNTMONTH "+
		" AND DUEBILLNO=:DUEBILLNO ";
		so = new SqlObject(sSql).setParameter("Cognizanceflag", sPhaseNo).setParameter("ACCOUNTMONTH", sAccountMonth).setParameter("DUEBILLNO", sDUEBILLNO);
		Sqlca.executeSQL(so);
		sSql = 	" UPDATE RESERVE_APPLY SET Cognizanceflag=:Cognizanceflag WHERE SerialNo=:SerialNo ";	
		so = new SqlObject(sSql).setParameter("Cognizanceflag", sPhaseNo).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "1";
	 }

}
