/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: 设置归档日期
 *	Input Param: 	
 *			ObjectNo：单项计提减值准备申请流水号		
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReservePigeonHoleDate extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception {
		//申请流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		String sSql = "";
		
		//更新Reserve_Apply的申请字段，使该条记录自动归档
		sSql = " update RESERVE_APPLY set PigeonholeDate=:PigeonholeDate "+
	       " where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("PigeonholeDate", StringFunction.getToday()).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "1";	    
	 }
}
