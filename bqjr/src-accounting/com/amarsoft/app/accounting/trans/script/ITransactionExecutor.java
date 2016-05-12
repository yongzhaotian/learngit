package com.amarsoft.app.accounting.trans.script;

import com.amarsoft.app.accounting.trans.ITransactionScript;

public interface ITransactionExecutor {
		
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception;
	
	
}
