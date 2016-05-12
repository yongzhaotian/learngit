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
 * ����
 */
public class LoanEODExecutor_finish implements ITransactionExecutor{
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String businessDate = loan.getString("BusinessDate");//�����ʱ��
		
		String nextBusinessDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);//��һ������
		
		loan.setAttributeValue("LockFlag", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		//������һ��
		loan.setAttributeValue("BusinessDate",nextBusinessDate);
		
		return 1;
	}
	
}
