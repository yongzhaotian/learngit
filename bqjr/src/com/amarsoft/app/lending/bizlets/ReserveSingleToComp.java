/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: 单项计提转组合计提逻辑，更新计提模式字段及认定阶段
 *	Input Param: 	
 *			ObjectNo：单项计提减值准备申请流水号		
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReserveSingleToComp extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception {
		//申请流水号
		SqlObject so;
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "",sAccountMonth="",sDuebillNo="";
		ASResultSet rs=null;
		//根据申请流水号，取得会计月份及借据号
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
		
		//更新Reserve_Total的申请字段，认定阶段，采集模式，现金流折现值，计提模式，减值准备值
		sSql = " update RESERVE_TOTAL set CognizanceFlag=null,AvailAbilityFlag=null,PrdDiscount=0.0, "+
		   " CalculateFlag='10' "+
	       " where AccountMonth=:AccountMonth and DuebillNo=:DuebillNo ";
		so = new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
		Sqlca.executeSQL(so);
		//更新Reserve_Apply的申请字段，使该条记录自动归档
		sSql = " update RESERVE_APPLY set PigeonholeDate=:PigeonholeDate "+
	       " where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("PigeonholeDate", StringFunction.getToday()).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "1";	    
	 }
}
