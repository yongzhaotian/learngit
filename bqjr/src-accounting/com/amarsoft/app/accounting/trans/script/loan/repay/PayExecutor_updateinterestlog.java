package com.amarsoft.app.accounting.trans.script.loan.repay;

//还款，整合提前还款
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

public class PayExecutor_updateinterestlog implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		double actualPayInteAmt =0d;
		List<BusinessObject> paymentLogList = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.PaymentLog);
		for(BusinessObject paymentLog:paymentLogList){
			BusinessObject paymentSchedule = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,paymentLog.getString("PSSerialNo"));
			//排除费用还款计划的处理
			if(paymentSchedule==null) continue;
			actualPayInteAmt += paymentLog.getMoney("ActualPayInteAmt");
			
			List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan,paymentSchedule);
			if(interestLogList==null||interestLogList.isEmpty()) continue;
			for(BusinessObject interestLog:interestLogList){
				String interestType = interestLog.getString("BaseAmountFlag");
				String actualPayAttribute = RateConfig.getInterestConfig(interestType, "InterestActualPayAttribute");
				double actualPayBalance = paymentLog.getMoney("TMP_"+actualPayAttribute);
				if(actualPayBalance<0d) break;
				
				double amount = 0d;
				if(actualPayBalance==0d) {
					actualPayBalance = paymentLog.getMoney(actualPayAttribute);
				}
				double interestBalance = interestLog.getMoney("InterestBalance");
				if(actualPayBalance>interestBalance){
					amount=interestBalance;
				}
				else{
					amount=actualPayBalance;
				}
				InterestLogFunctions.updateBalance(loan, interestLog, amount, boManager);
				actualPayBalance=actualPayBalance-amount;
				if(actualPayBalance<=0d){
					paymentLog.setAttributeValue("TMP_"+actualPayAttribute,-1);
				}
				else{
					paymentLog.setAttributeValue("TMP_"+actualPayAttribute,actualPayBalance);
				}
			}
		}
		//结正常利息
		if(actualPayInteAmt>0){
			InterestLogFunctions.updateBalance(loan,loan, ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest, actualPayInteAmt, boManager);
		}
		
		return 1;
	}
}