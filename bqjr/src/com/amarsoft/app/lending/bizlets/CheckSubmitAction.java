package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckSubmitAction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sSerialNo=(String)this.getAttribute("SerialNo");
		if(sSerialNo==null)sSerialNo="";
		String UnfinishCount="";
		//获取上一阶段RelativeSerialNo相同而未提交的流程阶段
		String sSql="select count(SerialNo) from Flow_Task"+
					" where RelativeSerialNo in("+
					" select RelativeSerialNo from Flow_Task"+
					" where SerialNo=:sSerialNo"+
					" )"+
					" and (EndTime is null or length(EndTime)<=0)";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sSerialNo", sSerialNo));
		
		if(rs.next())
			UnfinishCount=""+rs.getInt(1);
		if (UnfinishCount==null || UnfinishCount.trim().equals("")) UnfinishCount="0";
		rs.getStatement().close();
		return UnfinishCount;
	}

}