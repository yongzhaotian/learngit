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
	 * �ж�ĳ���̵ĵ�ǰ�ڵ��Ƿ�Ϊ�ַ��ڵ㣬�����Ƿ�ΪͶƱ�ڵ㡣
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
		
		//1.�õ�ͨ���ķ���״��:
		String selectNodeType = "select * from FLOW_MODEL where flowno = '"+sFlowNo+"' and phaseno= '"+sPhaseNo+"'";
		rs = Sqlca.getASResultSet(selectNodeType);
		if(rs.next()){
			phaseDescribe = rs.getString("PhaseDescribe");
			if(phaseDescribe == null) phaseDescribe = "";
			
			postScript = rs.getString("PostScript");
			if(postScript == null) postScript = "";
		}
		rs.getStatement().close();
		//�жϵ�ǰ�ڵ��Ƿַ��ڵ㻹��ͶƱ�ڵ㣺
		if(phaseDescribe.equals("distribute")){
			flowNodeType = "distribute";//��ǰ�ڵ�Ϊ�ַ��ڵ㡣
		}else if(postScript.indexOf("��������.ͶƱ����ж�")>-1){
			flowNodeType = "plot";//��ǰ�ڵ�ΪͶƱ�ڵ㡣
		}
		
		return flowNodeType;
	}
}
