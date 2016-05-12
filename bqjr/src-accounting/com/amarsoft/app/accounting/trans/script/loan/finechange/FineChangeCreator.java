package com.amarsoft.app.accounting.trans.script.loan.finechange;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.ASValuePool;

public class FineChangeCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status and (SegToDate is null or SegToDate='') and RateType=:RateType" ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo",loan.getObjectNo());
		as.setAttribute("Status","1");
		as.setAttribute("RateType", ACCOUNT_CONSTANTS.RateType_Overdue);
		List<BusinessObject> oldRateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, whereClauseSql,as);
		for(BusinessObject rate:oldRateList)
		{
			BusinessObject newRate = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,boManager);
			newRate.setValue(rate);
			newRate.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan_change);
			newRate.setAttributeValue("ObjectNo", loanChange.getString("SerialNo"));
			newRate.setAttributeValue("Status", "2");
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newRate);
		}
		
		return transaction;
	}
}
