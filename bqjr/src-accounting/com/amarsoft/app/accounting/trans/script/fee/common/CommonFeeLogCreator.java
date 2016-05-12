package com.amarsoft.app.accounting.trans.script.fee.common;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.are.util.ASValuePool;

public class CommonFeeLogCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject fee = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
		as.setAttribute("ObjectNo", "${SerialNo}");
		fee = boManager.loadBusinessObject(fee, BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as);
		fee = boManager.loadBusinessObject(fee, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType order by ACCOUNTINDICATOR,PRI",as);
		
		
		String businessDate = transaction.getString("TransDate");
		BusinessObject feeLog = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		feeLog.setAttributeValue("ObjectType",fee.getString("ObjectType"));
		feeLog.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
		feeLog.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
		feeLog.setAttributeValue("Currency", fee.getString("Currency"));
		feeLog.setAttributeValue("FeeType", fee.getString("FeeType"));
		feeLog.setAttributeValue("Status", "0");
		feeLog.setAttributeValue("CashOnLineFlag", fee.getString("CashOnLineFlag"));
		feeLog.setAttributeValue("AccountingOrgID", fee.getString("AccountingOrgID"));
		feeLog.setAttributeValue("TransDate", businessDate);
		
		return transaction;
	}
}
