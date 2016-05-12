package com.amarsoft.app.accounting.trans.script.loan.rptchange;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.are.util.ASValuePool;

public class RPTChangeCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		loanChange.setAttributeValue("OLDRPTTermID",loan.getString("RPTTermID"));
		
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo",loan.getObjectNo());
		as.setAttribute("Status","1");
		List<BusinessObject> oldRptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, whereClauseSql,as);
		for(BusinessObject rpt:oldRptList)
		{
			BusinessObject newRpt = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment,boManager);
			newRpt.setValue(rpt);
			newRpt.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan_change);
			newRpt.setAttributeValue("ObjectNo", loanChange.getString("SerialNo"));
			newRpt.setAttributeValue("Status", "2");
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newRpt);
		}
		return transaction;
	}
}
