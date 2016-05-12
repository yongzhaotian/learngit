package com.amarsoft.app.als.flow.cfg.flowrule;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SampleRule extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String customerID = (String) this.getAttribute("ObjectNo");
		SqlObject so = new SqlObject("select corpid,loancardno from ent_info where customerID=:customerID");
		so.setParameter("customerID", customerID);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()&&rs.getString(1)!=null&&rs.getString(2)!=null) {
			rs.getStatement().close();
			return "false";
		}
		return "true";
	}

}
