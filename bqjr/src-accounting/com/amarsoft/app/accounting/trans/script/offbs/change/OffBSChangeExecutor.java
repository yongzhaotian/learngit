package com.amarsoft.app.accounting.trans.script.offbs.change;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

/**
 * @author xjzhao 2011/04/02
 * 表外业务余额修改
 */
public class OffBSChangeExecutor implements ITransactionExecutor{
	
	
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
	
		BusinessObject transDocument = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取Loan对象
		BusinessObject bd = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		double businessSum = transDocument.getMoney("Amount");
		bd.setAttributeValue("BusinessSum", businessSum);
		bd.setAttributeValue("Balance", businessSum);
		bd.setAttributeValue("NormalBalance", businessSum);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bd);
		
		return 1;
	}
}
