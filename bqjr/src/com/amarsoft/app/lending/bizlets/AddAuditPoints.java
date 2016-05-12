package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * Author: xswang 20150505
 * Tester:
 * Describe: 新增审核要点信息,往auditpoints插入数据
 * Input Param:
 * Output Param:
 * HistoryLog: 
 */
public class AddAuditPoints extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception{
		//获取BizSort类所需的参数
		//流程编号
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//阶段编号
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		//审核要点信息
		String sAuditPoints = (String)this.getAttribute("AuditPoints");
		String sql = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		
		sql = "insert into auditpoints(" +
										"flowno," +
										"phaseno," +
										"auditpoints," +
										"filename," +
										"time) " +
										"values('"+sFlowNo+"','"+sPhaseNo+"','"+sAuditPoints+"','',to_char(sysdate,'YYYY/MM/DD HH24:MI:SS'))";
		
		Sqlca.executeSQL(sql);
		return "SUCCESS";	
	}
}
