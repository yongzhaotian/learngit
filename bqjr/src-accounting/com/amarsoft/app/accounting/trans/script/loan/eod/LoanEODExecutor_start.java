package com.amarsoft.app.accounting.trans.script.loan.eod;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.ARE;

/**
 * @author xjzhao 2011/04/02
 * ����
 */
public class LoanEODExecutor_start implements ITransactionExecutor{
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		
		String transactionDate = transaction.getString("TransDate");//��������
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String loanserialno = loan.getString("SerialNo");
		String businessDate = loan.getString("BusinessDate");//�����ʱ��
		
		if(!transactionDate.equals(businessDate)){//�������
			ARE.getLog().warn("������¼�����ԣ�����{"+loanserialno+"}����������ϵͳ���ڲ�һ��" +
					",ϵͳ��������"+transactionDate+"�����������businessDate="+businessDate);
			return 0;
		}
		ARE.getLog().debug("������ˮ��="+loanserialno+",��������businessDate="+businessDate);
		
		return 1;
	}
	
}
