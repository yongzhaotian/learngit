/*
		Author: --ccxie 2010/03/16
		Tester:
		Describe: --完成流程调整操作
		Input Param:
					SerialNo：流程流水号
					ObjectNo: 业务申请号
					ObjectType:对象类型
		Output Param:
					returnResult：操作是否成功标志
		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ChangeFlowPhase extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {

		// 获取参数
		String sSerialNo = (String) this.getAttribute("SerialNo");
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		String sObjectType = (String) this.getAttribute("ObjectType");
		if (sSerialNo == null) sSerialNo = "";
		if (sObjectNo == null)  sObjectNo = "";
		if (sObjectType == null) sObjectType = "";
		// 定义变量
		String sSql = "";
		SqlObject so ;//声明对象
		// 定义返回变量 
		String returnResult = "success";
		//获取当前流程的最大流水序列号作为新记录的RelativeSerialNo
		so = new SqlObject("select max(SerialNo) from FLOW_TASK F1 where ObjectNo =:ObjectNo and ObjectType =:ObjectType ").setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		String maxSerialNo = Sqlca.getString(so);
		
		//获取新的流水号
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		String newSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK", "SerialNo",Sqlca);*/
		String newSerialNo = DBKeyHelp.getWorkNo();
		/** --end --*/

		//更新调整前的最新阶段信息
		sSql =  " update FLOW_TASK set EndTime =:EndTime ,PhaseOpinion1='同意',PhaseAction = '流程调整' where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("EndTime", StringFunction.getTodayNow()).setParameter("SerialNo", maxSerialNo);
		Sqlca.executeSQL(so);
		
		//插入一条流程调整后的新记录
		sSql =  " INSERT INTO FLOW_TASK(SerialNo,ObjectNO,ObjectType,RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,UserID,UserName,OrgID,OrgName,BeginTime,EndTime) " +
				" select '"+newSerialNo+"' as SerialNo,ObjectNo,ObjectType,'"+maxSerialNo+"' as RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,UserID,UserName,OrgID,OrgName,'"+StringFunction.getTodayNow()+"' as BeginTime,'' as EndTime " +
				" from FLOW_TASK where SerialNo='"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
		//更新流程对象表的阶段信息
		sSql = 	" update FLOW_OBJECT FO set (PhaseNo, PhaseType,PhaseName) = (select PhaseNo, PhaseType,PhaseName from FLOW_TASK where SerialNo =:SerialNo) " +
		" where ObjectNo =:ObjectNo and ObjectType =:ObjectType ";
        so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
        Sqlca.executeSQL(so);
		return returnResult;
	}
}
