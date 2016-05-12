package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.RunJavaMethodAssistant;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteRelativeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	    
		String sSerialNo = (String)this.getAttribute("SerialNo");

		
		//删除关联表contract_relative数据
		String sSql="delete from contract_relative where SerialNo=:serialno";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("serialno", sSerialNo);
		Sqlca.executeSQL(so);
		
		//删除关联表contract_relative数据
		String sSql2="delete from business_contract where SerialNo=:serialno";
		SqlObject so2 = new SqlObject(sSql2);
		so2.setParameter("serialno", sSerialNo);
		Sqlca.executeSQL(so2);
		
		
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}

}
