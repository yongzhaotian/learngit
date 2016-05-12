package com.amarsoft.app.accounting.trans.script.loan.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class PSPaymentScheduleLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject fee = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		//HHCF新增,针对 费用减免时transaction的relativeobjecttype=fee加载该费用的还款计划
		String feeNo = fee.getObjectNo();
			
		ASValuePool asfee = new ASValuePool();
		asfee.setAttribute("ObjectType", fee.getObjectType());
		asfee.setAttribute("ObjectNo", feeNo);
		asfee.setAttribute("Status", "1");
		List<BusinessObject> feepaymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, "ObjectType=:ObjectType and ObjectNo=:ObjectNo order by paydate",asfee);
		fee.setRelativeObjects(feepaymentScheduleList);
		
		ASValuePool asWaive = new ASValuePool();
		asWaive.setAttribute("ObjectType", fee.getObjectType());
		asWaive.setAttribute("ObjectNo", feeNo);
		asWaive.setAttribute("Status", "1");
		List<BusinessObject> feewaiveList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive, "ObjectType=:ObjectType and ObjectNo=:ObjectNo",asWaive);
		fee.setRelativeObjects(feewaiveList);
		

		return transaction;
	}
}
