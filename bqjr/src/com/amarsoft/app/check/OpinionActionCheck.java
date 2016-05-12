package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.lending.bizlets.UpdateFlowOpinion;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 检查意见是否签署，一般在任务提交前检查
 * @author djia
 * @since 2009/10/29
 */

public class OpinionActionCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		String sSerialNo = (String)this.getAttribute("ObjectNo");
		String sTaskNo = (String)this.getAttribute("TaskNo");
		String sApplyType1 = (String)this.getAttribute("ApplyType1");
		if(sSerialNo == null) sSerialNo = "";
		if(sTaskNo == null) sTaskNo = "";
		if(sApplyType1 == null) sApplyType1 = "";
		
		
		//定义变量：SQL语句、意见详情
		String sSql = "",sPhaseOpinion = "";
		
		//根据任务流水号从流程意见记录表中查询签署的意见
		sSql = "select PhaseOpinion from FLOW_OPINION where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sTaskNo);
		sPhaseOpinion = Sqlca.getString(so);
		
		//将空值转化成空字符串
		if (sPhaseOpinion == null || sPhaseOpinion.equals("")) 
			sPhaseOpinion = "";
		else 
			sPhaseOpinion = "已经签署意见";//防止有回车传输出错
		
		/** 返回结果处理 **/
		if(sPhaseOpinion == null || sPhaseOpinion.equals("")) {
			setPass(false);
		}else{
			setPass(true);
			
			//只对授信业务申请时，更新调查阶段的申请详情到流程意见表中
			if(!sApplyType1.equals("")){
				UpdateFlowOpinion ufo = new UpdateFlowOpinion();
				ufo.setAttribute("ObjectNo", sSerialNo);
				ufo.setAttribute("SerialNo", sTaskNo);
				ufo.run(Sqlca);
			}
		}
		
		return null;
	}

}
