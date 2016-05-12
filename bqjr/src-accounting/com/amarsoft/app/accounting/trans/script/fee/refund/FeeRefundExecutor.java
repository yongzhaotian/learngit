package com.amarsoft.app.accounting.trans.script.fee.refund;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.Arith;

public class FeeRefundExecutor implements ITransactionExecutor {
	
	@Override
	public int execute(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_log, transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		
		if(feeLog.getDouble("ActualFeeAmount")>fee.getDouble("ActualRecieveAmount") )
			throw new Exception("费用收取金额【"+Arith.round(feeLog.getMoney("ActualFeeAmount"),2)+"】超过费用应收取金额【"+Arith.round(fee.getDouble("ActualRecieveAmount"),2)+"】");
		
		if(feeLog.getDouble("ActualFeeAmount")>=fee.getDouble("AMORTIZEBALANCE") ){
			fee.setAttributeValue("AMORTIZEBALANCE", "0");
			fee.setAttributeValue("AMORTIZEENDDATE",  transaction.getString("TransDate"));
		}else {
			fee.setAttributeValue("AMORTIZEBALANCE", fee.getDouble("AMORTIZEBALANCE")-feeLog.getDouble("ActualFeeAmount"));
		}
		//如果没有费用计划就创建一条费用计划
		if(feeScheduleSerialNo == null || feeScheduleSerialNo.length() == 0){
			List<BusinessObject> feeScheduleList = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule);
			if(feeScheduleList == null || feeScheduleList.isEmpty())
			{
				throw new Exception("未找到对应的费用还款计划！");
			}
			else
			{
				double actualFeeAmount = feeLog.getDouble("ActualFeeAmount");
				
				for(BusinessObject bo:feeScheduleList)
				{
					String direction = bo.getString("FeeFlag");
					if(direction.equals(ACCOUNT_CONSTANTS.FEEFLAG_RECIEVE))
					{
						double balance = bo.getDouble("ActualAmount");
						if(balance - actualFeeAmount>0 )
						{
							balance = -actualFeeAmount;
							//actualFeeAmount = 0;
						}
						else
						{
							balance = -balance;
							actualFeeAmount += balance;
						}
						
						bo.setAttributeValue("ActualAmount", bo.getDouble("ActualAmount")+balance);
						if(bo.getDouble("AcutalAmount") >= bo.getDouble("Amount"))
							bo.setAttributeValue("FinishDate", transaction.getString("TransDate"));
						else 
							bo.setAttributeValue("FinishDate", "");
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bo);
					}
					if(Math.abs(actualFeeAmount) < 0.0000001) break;
				}
				
				if(actualFeeAmount > 0)
				{
					throw new Exception("退还金额不能超过费用计划已收取金额！");
				}
			}
		}else{
			BusinessObject feeSchedule = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			double amount = feeSchedule.getDouble("ActualAmount")-feeLog.getDouble("ActualFeeAmount");
			feeSchedule.setAttributeValue("ActualAmount", amount > 0 ? amount : 0);
			if(feeSchedule.getDouble("AcutalAmount") >= feeSchedule.getDouble("Amount"))
				feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
			else 
				feeSchedule.setAttributeValue("FinishDate", "");
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feeSchedule);
		
		}
		
		
		//处理费用
		fee.setAttributeValue("ActualRecieveAmount", fee.getDouble("ActualRecieveAmount") - feeLog.getDouble("ActualFeeAmount"));
		
		feeLog.setAttributeValue("TransDate", transaction.getString("TransDate"));
		feeLog.setAttributeValue("Status", "1");
		if(fee.getString("Status").equals("0") || "".equals(fee.getString("Status"))){
			fee.setAttributeValue("Status","1");
		}
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, fee);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feeLog);
		return 1;
	}
}
