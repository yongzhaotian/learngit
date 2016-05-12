package com.amarsoft.app.accounting.trans.script;

import com.amarsoft.app.accounting.trans.ITransactionScript;

public interface ITransactionChecker {
		
	public int check(String scriptID,ITransactionScript transactionScript) throws Exception;
	
	
}
