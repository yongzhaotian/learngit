package com.amarsoft.app.accounting.trans.script.loan.fineflagchange;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.ASValuePool;

public class FineFlagChangeCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		loanChange.setAttributeValue("OLDAutoPayFlag", loan.getString("AutoPayFlag"));
		
		//加载Loan利率信息 
		ASValuePool as =  new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo",loan.getString("SerialNo"));
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status in('1','3') and RateType = '"+ACCOUNT_CONSTANTS.RateType_Overdue+"' " ;
		List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, whereClauseSql,as);
		if(rateList == null || rateList.size() == 0) throw new Exception("未取到对应罚息利率！");
		loanChange.setAttributeValue("OLDStopInteFlag", (!"1".equals(rateList.get(0).getString("Status")) ? "2" : "1"));
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loanChange);
		
		return transaction;
	}
	
}
