package com.amarsoft.app.accounting.rpt.fee;


import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

public class TransactionFeePSExcute implements ITransactionExecutor {
	private ITransactionScript transactionScript;

	@Override
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript=transactionScript; 
		
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();

		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		List<BusinessObject> feelist = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feelist!=null&&!feelist.isEmpty()){
			for(BusinessObject fee:feelist){
				String feePayDateFlag=fee.getString("FeePayDateFlag");
				//if(!"05".equals(feePayDateFlag))continue;
				List<BusinessObject> feePSNew = CommonFeePaymentScheduleList.createFeePaymentScheduleList(loan,fee,boManager);
				fee.setRelativeObjects(feePSNew);
				//loan.setRelativeObjects(feePSNew);//赋值新的费用还款计划
				boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, feePSNew);
			}
		}
		return 1;
	}
	
}
