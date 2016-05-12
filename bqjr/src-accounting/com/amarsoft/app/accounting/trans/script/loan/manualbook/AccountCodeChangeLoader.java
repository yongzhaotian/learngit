package com.amarsoft.app.accounting.trans.script.loan.manualbook;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class AccountCodeChangeLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and LDStatus=:LDStatus " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",loanChange.getObjectType());
		as.setAttribute("ObjectNo",loanChange.getObjectNo());
		as.setAttribute("LDStatus","0");
		List<BusinessObject> subLedgerDetail = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subledger_detail, whereClauseSql,as);
		loanChange.setRelativeObjects(subLedgerDetail);
		return transaction;
	}
}
