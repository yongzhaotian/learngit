package com.amarsoft.app.accounting.trans.script;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;

public interface ITransactionLoader {

	/**
	 * ���ؽ��׼������ҵ�����
	 * @throws Exception
	 */
	public BusinessObject load(String scriptID,ITransactionScript transactionScript) throws Exception;
	
}
