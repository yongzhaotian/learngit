package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SaveRetailApplyInfo extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		//自动获得传入的参数值	   
		String sRNo = (String)this.getAttribute("RNo");
		String sPermitType = (String)this.getAttribute("PermitType");
		
		if (sRNo == null) sRNo = "";
		if (sPermitType == null) sPermitType="";
		
		//RNo,PermitType,RName,OrgCode,RelativeNo
		SqlObject sqlObj = null;
		if(sPermitType.equals("01"))	{
			String	sRName = (String)this.getAttribute("RName");
			String  sOrgCode = (String)this.getAttribute("OrgCode");
			sqlObj = new SqlObject("insert into Retail_Info(RNo,PermitType,RName,OrgCode) values(:RNo,:PermitType,:RName,:OrgCode)")
				.setParameter("RNo", sRNo)
				.setParameter("PermitType", sPermitType)
				.setParameter("RName", sRName)
				.setParameter("OrgCode", sOrgCode);
		}else if (sPermitType.equals("02")){
			String  sRelativeNo	= (String)this.getAttribute("RelativeNo");
			sqlObj = new SqlObject("insert into Store_Info(SNo,RNo) values(:SNo,:RNo)")
			.setParameter("SNo", sRNo)
			.setParameter("RNo", sRelativeNo);
		}
  
		int execRows = Sqlca.executeSQL(sqlObj);
		if (execRows>0) return "SUCCESS";
		return "FAILE";
	}

}
