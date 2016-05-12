package com.amarsoft.app.accounting.trans.script.loan.balancemigrate;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;

public class BalanceMigrateCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanchange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		

		loanchange.setAttributeValue("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		loanchange.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
		loanchange.setAttributeValue("OLDNormalBalance", loan.getDouble("NormalBalance"));
		loanchange.setAttributeValue("OLDOverdueBalance", loan.getDouble("OverdueBalance"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loanchange);
		
		return transaction;
	}
	
}
