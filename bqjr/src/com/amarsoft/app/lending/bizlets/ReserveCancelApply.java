/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: 单项计提减值准备取消认定申请逻辑：更新Reserve_Total认定标志字段
 *	Input Param: 	
 *			ObjectNo：单项计提减值准备申请流水号		
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReserveCancelApply extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception {	
		//申请流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "",sAccountMonth="",sDuebillNo="";
		ASResultSet rs=null;
		SqlObject so;
		//查询减值准备申请的会计月份与借据号
		sSql = "select AccountMonth,DuebillNo from RESERVE_APPLY where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if (rs.next()){
			sAccountMonth = rs.getString("AccountMonth");
			sDuebillNo = rs.getString("DuebillNo");	
		}
		rs.getStatement().close();
		if(sAccountMonth == null) sAccountMonth = "";
		if(sDuebillNo == null) sDuebillNo = "";
		
		//更新Reserve_Total的申请字段，认定阶段为空，现金流折现值为0
		sSql = " update RESERVE_TOTAL set CognizanceFlag=null,AvailAbilityFlag=null,PrdDiscount=0.0 "+
	       " where AccountMonth=:AccountMonth and DuebillNo=:DuebillNo ";
		so = new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
		Sqlca.executeSQL(so);
		return "1";	    
	 }
}
