/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: 组合计提转单项计提的置位逻辑
 *	Input Param: 
 *			SerialNo:申请流水号			
 *	Output Param:			
 *	HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReserveCompToSingle extends Bizlet {
	
	public Object  run(Transaction Sqlca) throws Exception {
	 	//组合计提转单项计提申请流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		String sSql = "",sAccountMonth="",sDuebillNo="";
		ASResultSet rs =null;
		SqlObject so;
		//根据组合计提转单项计提的申请流水号，在表RESERVE_COMPTOSIN取得会计月份和借据号
		sSql = "select AccountMonth,DuebillNo from RESERVE_COMPTOSIN where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if (rs.next()){
			sAccountMonth = rs.getString("AccountMonth");
			sDuebillNo = rs.getString("DuebillNo");	
		}
		rs.getStatement().close();
		if(sAccountMonth == null) sAccountMonth = "";
		if(sDuebillNo == null) sDuebillNo = "";	
		
		//执行更新语句，把计提模式CalculateFlag更新为20，单项计提，更新认定阶段为空，现金流折现值为0
		sSql = " update Reserve_Total set CalculateFlag = '20',CognizanceFlag = null,PrdDiscount=0.0,AvailabilityFlag=null "+
		" where AccountMonth =:AccountMonth and DuebillNo =:DuebillNo ";
		 //执行更新语句
		so= new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
		Sqlca.executeSQL(so);
	    return "1";
	 }
}
