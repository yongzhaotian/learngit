package com.amarsoft.app.accounting.trans.script.loan.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class ActivePaymentScheduleLoader implements ITransactionLoader {
	
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
		
		//加载Loan还款计划
		List<BusinessObject> paymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and (finishdate is null  or finishdate = ' ') order by paydate",as);
		loan.setRelativeObjects(paymentScheduleList);

		//取计息信息
		as = new ASValuePool();
		as.setAttribute("RelativeObjectNo", objectNo);
		as.setAttribute("RelativeObjectType", loan.getObjectType());
		List<BusinessObject> interestLogList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.interest_log, "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo and (SettleDate is null or SettleDate = ' ') ",as);
		transaction.setRelativeObjects(interestLogList);
		loan.setRelativeObjects(interestLogList);
		
		for(BusinessObject interestLog:interestLogList){
			String interestObjectType=interestLog.getString("ObjectType");
			String interestObjectNo=interestLog.getString("ObjectNo");
			if(!interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)) continue;
			
			BusinessObject paymentSchedule = loan.getRelativeObject(interestObjectType, interestObjectNo);
			if(paymentSchedule==null) continue;
			paymentSchedule.setRelativeObject(interestLog);
		}
		
		return transaction;
	}
}
