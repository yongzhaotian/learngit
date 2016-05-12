package com.amarsoft.app.accounting.trans.script.offbs.common;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;

public class OffBSTransactionCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject document = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject businessobject = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		document.setAttributeValue("ObjectNo", businessobject.getObjectNo());
		document.setAttributeValue("ObjectType", businessobject.getObjectType());
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, transaction);
		
		return transaction;
	}
	
}
