package com.amarsoft.app.accounting.trans.script;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;

public interface ITransactionLoader {

	/**
	 * 加载交易及其关联业务对象
	 * @throws Exception
	 */
	public BusinessObject load(String scriptID,ITransactionScript transactionScript) throws Exception;
	
}
