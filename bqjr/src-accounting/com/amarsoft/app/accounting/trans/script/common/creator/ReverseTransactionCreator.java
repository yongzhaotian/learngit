package com.amarsoft.app.accounting.trans.script.common.creator;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;

public class ReverseTransactionCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject oldTransaction = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		paymentBill.setAttributeValue("ObjectNo", oldTransaction.getString("RelativeObjectNo"));
		paymentBill.setAttributeValue("ObjectType", oldTransaction.getString("RelativeObjectType"));
		transaction.setAttributeValue("RelativeObjectType", oldTransaction.getString("RelativeObjectType"));
		transaction.setAttributeValue("RelativeObjectNo", oldTransaction.getString("RelativeObjectNo"));
		transaction.setAttributeValue("StrikeSerialNo", oldTransaction.getObjectNo());
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,transaction);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,paymentBill);
		
		return transaction;
	}
	
}
