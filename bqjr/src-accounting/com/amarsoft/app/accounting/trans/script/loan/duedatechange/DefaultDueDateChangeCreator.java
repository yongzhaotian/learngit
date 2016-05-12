package com.amarsoft.app.accounting.trans.script.loan.duedatechange;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.are.util.ASValuePool;

public class DefaultDueDateChangeCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		//加载Loan还款信息
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo", loanChange.getString("ObjectNo"));
		as.setAttribute("Status1", "1");
		as.setAttribute("Status2", "3");
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status in(:Status1,:Status2) " ;
		List<BusinessObject> rptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, whereClauseSql,as);
		loan.setRelativeObjects(rptList);
		//把原来的还款日保存到loanchange中
		loanChange.setAttributeValue("OLDDefaultDueDay", rptList.get(0).getString("DefaultDueDay"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loanChange);
		
		return transaction;
	}
	
}
