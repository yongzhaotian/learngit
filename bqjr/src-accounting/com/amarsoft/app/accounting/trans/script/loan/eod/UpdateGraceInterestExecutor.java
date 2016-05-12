package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.settle.InterestLogFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;

/**
 * @author xjzhao 2011/04/02
 * 
 */
public class UpdateGraceInterestExecutor implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		AbstractBusinessObjectManager bomanager = transactionScript.getBOManager();
		String transDate = transaction.getString("TransDate");
		
		
		List<BusinessObject> paymentScheduleList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		for(BusinessObject paymentSchedule:paymentScheduleList){
			String inteDate = paymentSchedule.getString("InteDate");
			if(inteDate==null||inteDate.length()==0) continue;
			if(!transDate.equals(inteDate)) continue;
			
			List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(
					loan, paymentSchedule, ACCOUNT_CONSTANTS.INTEREST_TYPE_GraceInterest);
			if(interestLogList==null) continue;
			for(BusinessObject interestLog:interestLogList){
				InterestLogFunctions.settleInterestLog(loan, interestLog, transDate, bomanager);
			}
			
			double actualGraceInteAmt = paymentSchedule.getMoney("ActualPayGraceInteAmt");
			if(actualGraceInteAmt<=0) continue;
			
			double payFineInteAmt = paymentSchedule.getMoney("PayFineAmt")-actualGraceInteAmt;
			if(payFineInteAmt<0)
				payFineInteAmt=0;
			
			paymentSchedule.setAttributeValue("PayFineAmt", payFineInteAmt);
			if(payFineInteAmt>0d){
				paymentSchedule.setAttributeValue("PayGraceInteAmt", actualGraceInteAmt);
			}
			
			transactionScript.getBOManager().setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentSchedule);
		}
		
		return 1;
	}
}
