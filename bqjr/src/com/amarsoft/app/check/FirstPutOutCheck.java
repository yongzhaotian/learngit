package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class FirstPutOutCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception{
		//获取参数：对象类型和对象编号
		String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
		String sSql = "";
		int i = 0;
		ASResultSet rs = null;
		sSql = " select count(*) "+
		       " from BUSINESS_PUTOUT "+
		       " where ContractSerialNo = :ContractSerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ContractSerialNo", sContractSerialNo));
		if(rs.next()){
			i = rs.getInt(1);
		}
		rs.getStatement().close();
		if(i==1){
			putMsg("此笔放贷申请为首次放贷申请，您提交本次申请后，如果想要修改合同信息，您需要将此笔申请“退回补充资料”并取消此笔申请才能修改！");
		}else{
			putMsg("此笔放贷申请不是首笔放贷申请，合同处于不能更改状态！");
		}
		return null;
	}
}
