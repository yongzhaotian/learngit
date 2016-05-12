package com.amarsoft.app.accounting.trans.script.fee.pay;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.trans.script.fee.common.CommonFeeScheduleCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

public class FeePayExecutor implements ITransactionExecutor {
	
	@Override
	public int execute(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_log, transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		
		if(feeLog.getDouble("ActualFeeAmount") > fee.getDouble("TotalAmount")-fee.getDouble("ActualPayAmount"))
			throw new Exception("费用支出金额【"+feeLog.getMoney("ActualFeeAmount")+"】超过费用应支出金额【"+Arith.round(fee.getDouble("TotalAmount")-fee.getDouble("ActualPayAmount"),2)+"】");
		
		
		BusinessObject feeSchedule = null;
		//如果没有费用计划就创建一条费用计划
		if(feeScheduleSerialNo == null || feeScheduleSerialNo.length() == 0)
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("FeeFlag", ACCOUNT_CONSTANTS.FEEFLAG_PAY);
			List<BusinessObject> feeScheduleList = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule,as);
			if(feeScheduleList == null || feeScheduleList.isEmpty())
			{
				CommonFeeScheduleCreator c =new CommonFeeScheduleCreator();
				feeSchedule=c.init("",transactionScript);
				if(feeSchedule.getDouble("AcutalAmount") >= feeSchedule.getDouble("Amount"))
					feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
				else 
					feeSchedule.setAttributeValue("FinishDate", "");
			}
			else
			{
				double actualFeeAmount = feeLog.getDouble("ActualFeeAmount");
				
				for(BusinessObject bo:feeScheduleList)
				{
					double balance = bo.getDouble("Amount")-bo.getDouble("ActualAmount");
					if(balance>actualFeeAmount )
					{
						balance = actualFeeAmount;
						actualFeeAmount = 0;
					}
					else
					{
						actualFeeAmount -= balance;
					}
					
					bo.setAttributeValue("ActualAmount", bo.getDouble("ActualAmount")+balance);
					if(bo.getDouble("AcutalAmount") >= bo.getDouble("Amount"))
						bo.setAttributeValue("FinishDate", transaction.getString("TransDate"));
					else 
						bo.setAttributeValue("FinishDate", "");
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bo);
					if(Math.abs(actualFeeAmount) < 0.0000001) break;
				}
			}
		}
		else
		{
			feeSchedule = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeLog.getDouble("ActualFeeAmount") > feeSchedule.getDouble("Amount")-feeSchedule.getDouble("ActualAmount"))
				throw new Exception("费用支出金额【"+feeLog.getMoney("ActualFeeAmount")+"】超过费用计划应支出金额【"+Arith.round(feeSchedule.getDouble("Amount")-feeSchedule.getDouble("ActualAmount"),2)+"】");
		
			feeSchedule.setAttributeValue("ActualAmount", feeSchedule.getDouble("ActualAmount")+feeLog.getDouble("ActualFeeAmount"));
			
			if(feeSchedule.getDouble("AcutalAmount") >= feeSchedule.getDouble("Amount"))
				feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
			else 
				feeSchedule.setAttributeValue("FinishDate", "");
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feeSchedule);
		}
		//处理费用
		fee.setAttributeValue("ActualPayAmount", fee.getDouble("ActualPayAmount")+feeLog.getDouble("ActualFeeAmount"));
		
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
