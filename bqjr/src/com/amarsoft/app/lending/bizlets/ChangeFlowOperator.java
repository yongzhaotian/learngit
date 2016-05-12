/*
		Author: --ccxie 2010/03/16
		Tester:
		Describe: --完成流程调整操作
		Input Param:
					SerialNo：流程流水号
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
import com.amarsoft.context.ASUser;

public class ChangeFlowOperator extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		SqlObject so = null;//声明对象
		// 获取参数	
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		String sObjectType = (String) this.getAttribute("ObjectType");
		String sUserID = (String) this.getAttribute("UserID");
		if (sObjectNo == null) sObjectNo = "";
		if (sObjectType == null) sObjectType = "";
		if (sUserID == null) sUserID = "";
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		so = new SqlObject("select max(SerialNo) from FLOW_TASK where ObjectNo =:ObjectNo  and ObjectType =:ObjectType ").setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		String sSerialNo = Sqlca.getString(so);
		// 定义变量
		String sSql = "";
		// 定义返回变量
		String returnResult = "success";
		//获取新流水号
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		String newSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK", "SerialNo",Sqlca);*/
		String newSerialNo = DBKeyHelp.getWorkNo();
		/** --end --*/
		
		//更新调整前的最新阶段信息
		sSql = " update FLOW_TASK set EndTime =:EndTime ,PhaseOpinion1='同意',PhaseAction = '业务移交' where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("EndTime", StringFunction.getTodayNow()).setParameter("SerialNo", sSerialNo);
		Sqlca.executeSQL(so);
		//插入一条流程调整后的新记录
		sSql =  " INSERT INTO FLOW_TASK(SerialNo,ObjectNO,ObjectType,RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,UserID,UserName,OrgID,OrgName,BeginTime,EndTime) " +
				" select '"+newSerialNo+"' as SerialNo,ObjectNo,ObjectType,'"+sSerialNo+"' as RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,'"+CurUser.getUserID()+"','"+CurUser.getUserName()+"','"+CurUser.getOrgID()+"','"+CurUser.getOrgName()+"','"+StringFunction.getTodayNow()+"' as BeginTime,'' as EndTime " +
				" from FLOW_TASK where SerialNo='"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
	
		return returnResult;
	}
}
