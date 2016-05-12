package com.amarsoft.app.accounting.trans.script.loan.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class LoanAccountLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//加载Loan信息
		ASValuePool as = new ASValuePool();
		String whereClauseSql =" ObjectType = :ObjectType and ObjectNo = :ObjectNo and Status=:Status " ;
		
		//加载账户信息
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo", loan.getObjectNo());
		as.setAttribute("Status", "1");
		List<BusinessObject> accountsList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts, whereClauseSql,as);
		loan.setRelativeObjects(accountsList);
		return transaction;
	}
}
