package com.amarsoft.app.accounting.trans.script.loan.repricetypechange;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;

public class RepriceTypeChangeCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		//把原来的利率调整信息保存到loanchange中
		loanChange.setAttributeValue("OLDRepriceType",loan.getString("RepriceType"));
		loanChange.setAttributeValue("OLDRepriceDate",loan.getString("RepriceDate"));
		loanChange.setAttributeValue("OLDRepriceCyc",loan.getString("RepriceCyc"));
		loanChange.setAttributeValue("OLDRepriceFlag",loan.getString("RepriceFlag"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loanChange);
		return transaction;
	}
}
