package com.amarsoft.app.accounting.trans.script.loan.repay;

//还款，整合提前还款
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.interest.settle.InterestLogFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

public class PayExecutor_presettleinterest implements ITransactionExecutor{

	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));

		String settleDate = paymentBill.getString("EX_SettleDate");
		
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan, ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest);
		if(interestLogList==null||interestLogList.isEmpty()) return 1;
		
		double prepayPrincipalAmt = paymentBill.getMoney("PrepayPrincipalAmt");
		if(prepayPrincipalAmt<=0d) return 1;
		
		String prepayInterestBaseFlag = paymentBill.getString("PrepayInterestBaseFlag");//提前还款利息计算基础：1提前还款本金2贷款余额
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");
		
		if(prepayInterestDaysFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestFlag_NoneInterest)){//挂息处理
			for (BusinessObject interestLog: interestLogList) {
				InterestLogFunctions.settleInterestLog(loan, interestLog, settleDate, boManager);//结息后重新开始计息
			}
		}
		else{
			if(prepayInterestBaseFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestBaseFlag_NormalBalance)){//按照余额计息
				for (BusinessObject interestLog: interestLogList) {
					InterestLogFunctions.settleInterestLog(loan, interestLog, settleDate, boManager);//结息后重新开始计息
				}
			}
			else{
				for (BusinessObject interestLog: interestLogList) {//创建提前还款的InterestLog
					interestLog.setAttributeValue("BaseAmount",paymentBill.getMoney("PrepayPrincipalAmt"));
					BusinessObject newInterestLog = InterestLogFunctions.settleInterestLog(loan, interestLog, settleDate, boManager);//结息后重新开始计息
					if(newInterestLog!=null){
						newInterestLog.setAttributeValue("InterestDate", interestLog.getString("InterestDate"));
					}
				}
			}
		}
		return 1;
	}

}