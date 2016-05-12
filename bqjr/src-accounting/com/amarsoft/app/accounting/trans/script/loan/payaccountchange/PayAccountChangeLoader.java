package com.amarsoft.app.accounting.trans.script.loan.payaccountchange;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class PayAccountChangeLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//加载新Loan还款方式信息 
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan_change);
		as.setAttribute("ObjectNo",loanChange.getObjectNo());
		as.setAttribute("Status","0");
		List<BusinessObject> newAccountList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts, whereClauseSql,as);
		loanChange.setRelativeObjects(newAccountList);
		as = new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo",loan.getObjectNo());
		as.setAttribute("Status","1");
		newAccountList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts, whereClauseSql,as);
		loan.setRelativeObjects(newAccountList);
		
		return transaction;
	}
}
