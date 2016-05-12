package com.amarsoft.app.als.flow.cfg.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetFlowNodeType extends Bizlet{
	static String flowNodeType = "";
	static ASResultSet rs = null;
	public Object  run(Transaction Sqlca) throws Exception{
		flowNodeType = "normal";
		return flowNodeType;
	}
	/**
	 * 判断某流程的当前节点是否为分发节点，或者是否为投票节点。
	 * @param Sqlca
	 * @param sFlowNo
	 * @param sPhaseNo
	 * @return
	 * @throws Exception
	 */
	public static String getNodeType(Transaction Sqlca,String sFlowNo,String sPhaseNo) throws Exception{
		flowNodeType = "normal";
		String phaseDescribe = "";
		String postScript = "";
		
		//1.得到通道的发布状况:
		String selectNodeType = "select * from FLOW_MODEL where flowno = '"+sFlowNo+"' and phaseno= '"+sPhaseNo+"'";
		rs = Sqlca.getASResultSet(selectNodeType);
		if(rs.next()){
			phaseDescribe = rs.getString("PhaseDescribe");
			if(phaseDescribe == null) phaseDescribe = "";
			
			postScript = rs.getString("PostScript");
			if(postScript == null) postScript = "";
		}
		rs.getStatement().close();
		//判断当前节点是分发节点还是投票节点：
		if(phaseDescribe.equals("distribute")){
			flowNodeType = "distribute";//当前节点为分发节点。
		}else if(postScript.indexOf("审批流程.投票完成判断")>-1){
			flowNodeType = "plot";//当前节点为投票节点。
		}
		
		return flowNodeType;
	}
}
