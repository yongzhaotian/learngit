package com.amarsoft.app.accounting.trans.script.fee.refund;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

public class FeeRefundCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		
	
		if(fee.getDouble("ActualRecieveAmount") <= 0.0d)
			throw new Exception("费用还未收取完毕，不能发起退还交易！");
		List<BusinessObject> depositAccounts =  fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		if(depositAccounts!=null)
		{
			for(BusinessObject da:depositAccounts)
			{
				String accountIndicator = da.getString("AccountIndicator");//账户性质
				if(ACCOUNT_CONSTANTS.AccountIndicator_01.equals(accountIndicator))//还款账户
				{
					feeLog.setAttributeValue("RecieveAccountFlag", da.getString("AccountFlag"));
					feeLog.setAttributeValue("RecieveAccountType", da.getString("AccountType"));
					feeLog.setAttributeValue("RecieveAccountNo", da.getString("AccountNo"));
					feeLog.setAttributeValue("RecieveAccountName", da.getString("AccountName"));
					feeLog.setAttributeValue("RecieveAccountCCY", da.getString("AccountCurrency"));
					break;
				}
			}
		}
		
		feeLog.setAttributeValue("Direction", "R");
		
		BusinessObject feeSchedule=null;
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		if(!"".equals(feeScheduleSerialNo) && feeScheduleSerialNo != null){
			feeSchedule = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeSchedule!=null){
				transaction.setRelativeObject(feeSchedule);
				fee.setRelativeObject(feeSchedule);
				feeLog.setAttributeValue("FeeAmount", feeSchedule.getDouble("ActualAmount"));
				feeLog.setAttributeValue("ActualFeeAmount", feeSchedule.getDouble("ActualAmount"));
				feeLog.setAttributeValue("WaiveAmount", 0.0d);
				feeLog.setAttributeValue("WaiveType", "");
			}
		}
		else{
			double feeAmount =fee.getDouble("ActualRecieveAmount");//如果总金额小于等于零则重新计算费用总额和费用减免总额
			feeLog.setAttributeValue("FeeAmount", feeAmount);
			feeLog.setAttributeValue("WaiveType", "");
			feeLog.setAttributeValue("WaiveAmount", 0.0d);
			feeLog.setAttributeValue("ActualFeeAmount", feeAmount);
		}
		
		
		return transaction;
	}
}
