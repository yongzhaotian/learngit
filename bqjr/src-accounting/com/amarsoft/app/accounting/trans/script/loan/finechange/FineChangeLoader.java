package com.amarsoft.app.accounting.trans.script.loan.finechange;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class FineChangeLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//加载新Loan利率信息 
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan_change);
		as.setAttribute("ObjectNo",loanChange.getString("SerialNo"));
		as.setAttribute("Status","0");
		List<BusinessObject> newRateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, whereClauseSql,as);
		loanChange.setRelativeObjects(newRateList);
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		as = new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo",loanChange.getString("ObjectNo"));
		as.setAttribute("Status","1");
		List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, whereClauseSql,as);
		loan.setRelativeObjects(rateList);
		return transaction;
	}
}
