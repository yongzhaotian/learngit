package com.amarsoft.app.accounting.trans.script.loan.eod;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

/**
 * @author xjzhao 2011/04/02
 * 垫款交易
 */
public class LoanEODExecutor_finish implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String businessDate = loan.getString("BusinessDate");//贷款处理时间
		
		String nextBusinessDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);//下一处理日
		
		loan.setAttributeValue("LockFlag", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		//换到下一日
		loan.setAttributeValue("BusinessDate",nextBusinessDate);
		
		return 1;
	}
	
}
