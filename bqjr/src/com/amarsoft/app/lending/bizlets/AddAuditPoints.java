package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * Author: xswang 20150505
 * Tester:
 * Describe: �������Ҫ����Ϣ,��auditpoints��������
 * Input Param:
 * Output Param:
 * HistoryLog: 
 */
public class AddAuditPoints extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception{
		//��ȡBizSort������Ĳ���
		//���̱��
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//�׶α��
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		//���Ҫ����Ϣ
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
