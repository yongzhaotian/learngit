package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SelFlowTast extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		//获取参数：对象类型和对象编号
		String sUserID = (String)this.getAttribute("UserID");
		String sFlowNo = (String)this.getAttribute("FlowNo");
		String sCount = "";
		String sSql = "";
		
		sFlowNo = sFlowNo.replace("@", ",");
		
		sSql = "select count(1) as sCount from FLOW_TASK, BUSINESS_CONTRACT where 1 = 1 and FLOW_TASK.ObjectType = 'BusinessContract' "
				+ " and FLOW_TASK.ObjectNo = BUSINESS_CONTRACT.SerialNo and FLOW_TASK.UserID = '"+sUserID+"' "
				+ " and (FLOW_TASK.EndTime is null or FLOW_TASK.EndTime = '') "
				+ "  and FLOW_TASK.TaskState = '1' and flowNo in "+sFlowNo+" order by objectno desc ";
		sCount = Sqlca.getString(sSql);
		return sCount;
	}

}
