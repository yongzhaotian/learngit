package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.trigger.TriggerTools;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

/**
 * ����˻����׵ĸ���loan״̬����
 */
public class UpdateLoanStatusExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
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
		TriggerTools.deal(bomanager,loan);//�������¹�������
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		return 1;
	}

}
