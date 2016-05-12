package com.amarsoft.app.accounting.trans.script.offbs.common;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

/**
 * @author xjzhao 2011/04/02
 * 贷款核销交易
 */
public class OffBSExecutor_updatebd implements ITransactionExecutor{
	
	
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject bd = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		double balance = AccountCodeConfig.getBusinessObjectBalance(bd, "BookType,"+AccountCodeConfig.accountcode_type_las+",AccountCodeNo,LAS60101", ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		if(balance==0) {
			bd.setAttributeValue("FinishDate", transaction.getString("TransDate"));
			bd.setAttributeValue("FinishType", "010");
		}
		else{
			bd.setAttributeValue("FinishDate", "");
			bd.setAttributeValue("FinishType", "");
		}
		bd.setAttributeValue("Balance", balance);
		bd.setAttributeValue("NormalBalance", balance);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bd);
		
		return 1;
	}
}
