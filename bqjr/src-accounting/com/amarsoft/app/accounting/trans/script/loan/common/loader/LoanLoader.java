package com.amarsoft.app.accounting.trans.script.loan.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class LoanLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));

		String objectNo = loan.getObjectNo();
		//加载Loan利率信息
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", loan.getObjectType());
		as.setAttribute("ObjectNo", objectNo);
		as.setAttribute("Status", "1");
		List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status order by SegFromDate desc",as);
		loan.setRelativeObjects(rateList);
		//加载Loan还款信息
		List<BusinessObject> rptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
		loan.setRelativeObjects(rptList);
		//加载Loan贴息信息
		List<BusinessObject> sptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
		loan.setRelativeObjects(sptList);
		//hhcf：加载费用信息
		List<BusinessObject> feeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
		loan.setRelativeObjects(feeList);
		
		return transaction;
	}
}
