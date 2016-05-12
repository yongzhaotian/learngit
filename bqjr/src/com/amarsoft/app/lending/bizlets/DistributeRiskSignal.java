/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: 更新抵质押物状态，并保存入库/出库痕迹
		Input Param:
			GuarantyID：抵质押物编号
			GuarantyStatus：抵质押物状态
			UserID：登记人编号	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class DistributeRiskSignal extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	 {
		SqlObject so ;//声明对象
		//自动获得传入的参数值
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";			
		String sCheckUser   = (String)this.getAttribute("CheckUser");
		if(sCheckUser == null) sCheckUser = "";		
				
		//定义变量
		String sCheckOrg = "",sCheckDate = "",sUpdateSql = "",sInsertSql = "";
				
		//获取系统日期
		sCheckDate = StringFunction.getToday();
		//获取用户所在机构
		ASUser CurUser = ASUser.getUser(sCheckUser,Sqlca);
		sCheckOrg = CurUser.getOrgID();
		//获得预警信息分发流水号
		String sROSerialNo = DBKeyHelp.getSerialNo("RISKSIGNAL_OPINION","SerialNo","",Sqlca);
		
		//更新预警信号的预警状态
		sUpdateSql = " update RISK_SIGNAL set SignalStatus = '20' "+
		 " where SerialNo =:SerialNo ";
		so = new SqlObject(sUpdateSql).setParameter("SerialNo", sObjectNo);
        Sqlca.executeSQL(so);
        sInsertSql = " insert into RISKSIGNAL_OPINION(ObjectNo,SerialNo,CheckUser,CheckOrg,CheckDate) "+
		 " values (:ObjectNo,:SerialNo,:CheckUser,:CheckOrg,:CheckDate) ";	
        so = new SqlObject(sInsertSql).setParameter("ObjectNo", sObjectNo).setParameter("SerialNo", sROSerialNo).setParameter("CheckUser", sCheckUser)
                .setParameter("CheckOrg", sCheckOrg).setParameter("CheckDate", sCheckDate);
        Sqlca.executeSQL(so); 
		return "1";
	 }
}
