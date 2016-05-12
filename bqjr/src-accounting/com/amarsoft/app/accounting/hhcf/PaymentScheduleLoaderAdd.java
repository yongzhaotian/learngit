package com.amarsoft.app.accounting.hhcf;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class PaymentScheduleLoaderAdd implements ITransactionLoader {
	
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
		//HHCF新增,将费用对应的还款计划关联给指定费用
		List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList!=null&&feeList.size()>0){
			for(BusinessObject fee:feeList){
				String feeNo = fee.getObjectNo();
				
				ASValuePool asfee = new ASValuePool();
				asfee.setAttribute("ObjectType", fee.getObjectType());
				asfee.setAttribute("ObjectNo", feeNo);
				asfee.setAttribute("Status", "1");
				List<BusinessObject> feepaymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, "ObjectType=:ObjectType and ObjectNo=:ObjectNo order by paydate",asfee);
				fee.setRelativeObjects(feepaymentScheduleList);
			}
		}
		return transaction;
	}
}
