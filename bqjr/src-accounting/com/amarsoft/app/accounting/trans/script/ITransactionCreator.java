package com.amarsoft.app.accounting.trans.script;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;

public interface ITransactionCreator{

	/**
	 * 创建交易及交易单据信息
	 * @param relativeObject
	 * @return
	 * @throws Exception
	 */
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception;
}
