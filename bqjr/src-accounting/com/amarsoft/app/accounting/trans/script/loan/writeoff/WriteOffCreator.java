package com.amarsoft.app.accounting.trans.script.loan.writeoff;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;

public class WriteOffCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject writOff = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		writOff.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
		writOff.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
		writOff.setAttributeValue("WoAmt",loan.getDouble("normalbalance")+loan.getDouble("overduebalance")+loan.getDouble("ODInteBalance")+loan.getDouble("CompdInteBalance")+loan.getDouble("FineInteBalance"));
		writOff.setAttributeValue("WoPrincipalAmt",loan.getDouble("normalbalance")+loan.getDouble("overduebalance"));
		writOff.setAttributeValue("WoInteAmt",loan.getDouble("ODInteBalance"));
		writOff.setAttributeValue("WoFineInteAmt",loan.getDouble("FineInteBalance"));
		writOff.setAttributeValue("WoCompdInteAmt",loan.getDouble("CompdInteBalance"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, writOff);
		
		return transaction;
	}
	
}
