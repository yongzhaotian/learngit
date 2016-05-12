package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.trigger.TriggerTools;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

/**
 * 针对退货交易的更新loan状态处理
 */
public class UpdateLoanStatusExecutor implements ITransactionExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager bomanager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String transCode = transaction.getString("TransCode");
		if(transCode.equals("0052")){
			loan.setAttributeValue("LoanStatus", "7");
		}
		else return 1;
		TriggerTools.deal(bomanager,loan);//触发更新关联对象
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		return 1;
	}

}
