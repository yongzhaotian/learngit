package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.are.util.Arith;

/**
 * @author xjzhao 2011/04/02
 * 垫款交易
 */
public class LoanEODExecutor_vars implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String businessDate = loan.getString("BusinessDate");//贷款处理时间
		
		
		//取还款计划金额
		double ps_OverduePrincipalBalance = getPaymentSchdAmt(loan,businessDate, "PayPrincipalAmt","ActualPayPrincipalAmt");
		double ps_OverdueInterestBalance = getPaymentSchdAmt(loan,businessDate, "PayInteAmt","ActualPayInteAmt");
		double ps_GraceInterestBalance = getPaymentSchdAmt(loan,businessDate, "PayGraceInteAmt","ActualPayGraceInteAmt");
		double ps_FineInterestBalance = getPaymentSchdAmt(loan,businessDate, "PayFineAmt","ActualPayFineAmt");
		double ps_CompdInterestBalance = getPaymentSchdAmt(loan,businessDate, "PayCompdInteAmt","ActualPayCompdInteAmt");
	
		
		transaction.setAttributeValue("PSOverduePrincipal", ps_OverduePrincipalBalance);
		transaction.setAttributeValue("PSOverdueInterest", ps_OverdueInterestBalance);
		transaction.setAttributeValue("PSFineInterest", ps_FineInterestBalance);
		transaction.setAttributeValue("PSCompdInterest", ps_CompdInterestBalance);
		transaction.setAttributeValue("PSGraceInterest", ps_GraceInterestBalance);
		return 1;
	}
	
	private double getPaymentSchdAmt(BusinessObject loan,String businessdate,String payAmtAttribute,String actualPayAmtAttribute) throws Exception{
		double result=0d;
		//等于当天的也参与计算
		List<BusinessObject> psList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		if(psList==null) return 0d;
		for(BusinessObject a:psList){
			double payAmt=a.getDouble(payAmtAttribute);
			double actualPayAmt=a.getDouble(actualPayAmtAttribute);
			result+=Arith.round(payAmt-actualPayAmt,2);
		}
		return result;
	}
	
}
