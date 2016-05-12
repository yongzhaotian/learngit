package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 在进行五级分类模型评估后，将最新的人工认定结果更新到CLASSIFY_RECORD表的FinallyResult字段。
 * @author jgao1
 * @date 2009/10/15
 */
public class UpdateCRFinally extends Bizlet {

	/**
	 * 将人工评估结果更新到CLASSIFY_RECORD表中。
	 * @param ObjectNo CLASSIFY_RECORD表中的流水号
	 * @param SerialNo FLOW_OPINION表中的流水号
	 */
	public Object run(Transaction Sqlca) throws Exception{
		//申请流水号   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//任务流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
		SqlObject so; //声明对象
		String sSql = "";
		String sPhaseOpinion= "";
		//取得该阶段人工认定结果
		sSql = "select PhaseOpinion from FLOW_OPINION where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		sPhaseOpinion = Sqlca.getString(so);
		//更新人工认定结果
		sSql="update CLASSIFY_RECORD set FinallyResult  =:FinallyResult where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("FinallyResult", sPhaseOpinion).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "1";
	}
}
