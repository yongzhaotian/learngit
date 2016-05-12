package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.RunJavaMethodAssistant;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteRelativeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	    
		String sSerialNo = (String)this.getAttribute("SerialNo");

		
		//ɾ��������contract_relative����
		String sSql="delete from contract_relative where SerialNo=:serialno";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("serialno", sSerialNo);
		Sqlca.executeSQL(so);
		
		//ɾ��������contract_relative����
		String sSql2="delete from business_contract where SerialNo=:serialno";
		SqlObject so2 = new SqlObject(sSql2);
		so2.setParameter("serialno", sSerialNo);
		Sqlca.executeSQL(so2);
		
		
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}

}
