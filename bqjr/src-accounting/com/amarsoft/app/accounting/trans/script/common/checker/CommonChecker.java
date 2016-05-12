package com.amarsoft.app.accounting.trans.script.common.checker;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionChecker;
import com.amarsoft.app.accounting.util.ExtendedFunctions;

public class CommonChecker implements ITransactionChecker {
	private ITransactionScript transactionScript;

	@Override
	public int check(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript=transactionScript;
		
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();

		String preRunCheck = TransactionConfig.getTransactionDef(transaction.getString("TransCode"), "PreRunCheck");
		if(preRunCheck != null && !"".equals(preRunCheck)){
			preRunCheck = ExtendedFunctions.getScriptStringValue(preRunCheck,transaction,boManager.getSqlca());
			if(!"true".equalsIgnoreCase(preRunCheck)){
				throw new Exception(preRunCheck);
			}
		}
		return 1;
	}
	
}
