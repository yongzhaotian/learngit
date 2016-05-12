package com.amarsoft.app.accounting.trans.script.loan.repay;

//还款，整合提前还款
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.settle.InterestLogFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.ExtendedFunctions;

public class PayExecutor_settleinterest implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		
		String transDate=transaction.getString("TransDate");
		
		double prepayPrincipalAmt = paymentBill.getMoney("PrepayPrincipalAmt");
		
		//结算利息
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan);
		if(interestLogList==null||interestLogList.isEmpty()) return 1;
		for(BusinessObject interestLog:interestLogList){
			double baseAmount = interestLog.getMoney("BaseAmount");
			String interestType = interestLog.getString("BaseAmountFlag");
			if(prepayPrincipalAmt>0d&&ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest.equals(interestType)) continue;
			
			BusinessObject interestObject=null;
			if(loan.getObjectType().equals(interestLog.getString("ObjectType"))) interestObject = loan;
			else interestObject = loan.getRelativeObject(interestLog.getString("ObjectType"), interestLog.getString("ObjectNo"));
			if(interestObject==null) throw new Exception("未找到计息对象，"+interestLog.getString("ObjectType")+ interestLog.getString("ObjectNo")+"！");
			
			String baseAmountScript=ExtendedFunctions.getScript(RateConfig.getInterestConfig(interestType,"InterestBaseAmountScript"), interestObject, null);
			double newBaseAmount = ExtendedFunctions.getScriptDoubleValue(baseAmountScript, loan,null);
			if(baseAmount!=newBaseAmount){
				InterestLogFunctions.settleInterestLog(loan, interestLog, transDate, boManager);
			}
		}
	
		return 1;
	}
}