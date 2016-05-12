package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.RunJavaMethodAssistant;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateContractRecord extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	    
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerRole = (String)this.getAttribute("CustomerRole");
		String sBirthDay = (String)this.getAttribute("BirthDay");
		
		//更新关联表数据
		String sSql="update Contract_Relative  set RelationStatus=:relationstatus,CustomerRole=:customerrole,BirthDay=:birthday where SerialNo=:serialno and ObjectType=:objecttype and ObjectNo=:objectno";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("relationstatus", sCustomerType).setParameter("customerrole", sCustomerRole).setParameter("serialno", sSerialNo).setParameter("objecttype", sObjectType).setParameter("objectno", sObjectNo).setParameter("birthday", sBirthDay);
		Sqlca.executeSQL(so);
		
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}

}
