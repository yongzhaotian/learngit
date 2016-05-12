package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetFLowSerialno extends Bizlet{

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		// 获得业务对象编号
		String sSerialNo = (String) this.getAttribute("SerialNo");
		String sUserID = (String) this.getAttribute("UserID");
		String sReturn = "";
		String sSql = "";
		sSql = "select SerialNo,ObjectNo,ObjectType,FLowNo,PhaseNo from Flow_Task where ObjectNo =:ObjectNo and UserID =:UserID and (EndTime is null or EndTime = '')";
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", sSerialNo).setParameter("UserID", sUserID));
		if(rs.next()){
			sReturn = rs.getString("SerialNo")+"@"+rs.getString("ObjectNo")+"@"+rs.getString("ObjectType")+"@"+rs.getString("FLowNo")+"@"+rs.getString("PhaseNo");
		}
		rs.getStatement().close();
		return sReturn;
	}

}
