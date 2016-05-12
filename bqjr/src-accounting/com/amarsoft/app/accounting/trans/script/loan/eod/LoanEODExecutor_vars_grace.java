package com.amarsoft.app.accounting.trans.script.loan.eod;


import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.are.util.Arith;

/**
 * @author qzhang 2014/06/04
 * �����ڽ���������ת����
 */
public class LoanEODExecutor_vars_grace implements ITransactionExecutor{
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		
		setGracePrincipalAmt(loan, transaction);
		
		return 1;
	}
	
	private void setGracePrincipalAmt(BusinessObject loan, BusinessObject transaction) throws Exception{
		String businessDate = loan.getString("BusinessDate");
		BusinessObject ps = PaymentScheduleFunctions.getPassDuePaymentSchedule(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		if(ps==null) {
			transaction.setAttributeValue("PSGracePrincipal", 0);
			return;
		}
		
		String inteDate = ps.getString("InteDate");
		if(inteDate == null || inteDate.equals("")) {
			transaction.setAttributeValue("PSGracePrincipal", 0);
			return;
		}
		String payDate = ps.getString("PayDate");
		
		if(businessDate.compareTo(payDate) < 0) throw new Exception("��ȡ�Ļ���ƻ�����ȷ��");
		else if(businessDate.compareTo(inteDate) < 0 && businessDate.compareTo(payDate) >= 0) {
			transaction.setAttributeValue("PSGracePrincipal", Arith.round(ps.getDouble("PayPrincipalAmt")-ps.getDouble("ActualPayPrincipalAmt")));
		}
		else if(businessDate.compareTo(inteDate) >= 0) {
			transaction.setAttributeValue("PSGracePrincipal", 0);
		}
		else {}
	}
	
}