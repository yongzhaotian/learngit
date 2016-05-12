package com.amarsoft.app.accounting.trans.script.fee.common;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;

public class CommonFeeScheduleCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_log, transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		BusinessObject feeSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,boManager);
		feeSchedule.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
		feeSchedule.setAttributeValue("Amount", feeLog.getDouble("ActualFeeAmount") > (feeLog.getDouble("FEEAMOUNT")+feeLog.getDouble("WaiveAmount")) ? feeLog.getDouble("ActualFeeAmount") : (feeLog.getDouble("FEEAMOUNT")+feeLog.getDouble("WaiveAmount")));
		feeSchedule.setAttributeValue("WaiveAmount", feeLog.getDouble("WaiveAmount"));
		feeSchedule.setAttributeValue("ActualAmount", feeLog.getDouble("ActualFeeAmount"));
		feeSchedule.setAttributeValue("Currency", feeLog.getString("Currency"));
		feeSchedule.setAttributeValue("Status", "0");
		feeSchedule.setAttributeValue("ObjectType", fee.getString("ObjectType"));
		feeSchedule.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
		feeSchedule.setAttributeValue("FeeType", fee.getString("FeeType"));
		feeSchedule.setAttributeValue("FeeFlag", feeLog.getString("Direction"));
		feeLog.setAttributeValue("FeeScheduleSerialNo", feeSchedule.getObjectNo());
		feeSchedule.setAttributeValue("PayDate", transaction.getString("TransDate"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,feeLog);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,feeSchedule);
		return feeSchedule;
	}
}
