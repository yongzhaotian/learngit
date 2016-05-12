package com.amarsoft.app.accounting.trans.script.loan.eod;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.ARE;

/**
 * @author xjzhao 2011/04/02
 * 垫款交易
 */
public class LoanEODExecutor_start implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		
		String transactionDate = transaction.getString("TransDate");//交易日期
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String loanserialno = loan.getString("SerialNo");
		String businessDate = loan.getString("BusinessDate");//贷款处理时间
		
		if(!transactionDate.equals(businessDate)){//如果贷款
			ARE.getLog().warn("该条记录被忽略，贷款{"+loanserialno+"}处理日期与系统日期不一致" +
					",系统交易日期"+transactionDate+"，贷款处理日期businessDate="+businessDate);
			return 0;
		}
		ARE.getLog().debug("贷款流水号="+loanserialno+",处理日期businessDate="+businessDate);
		
		return 1;
	}
	
}
