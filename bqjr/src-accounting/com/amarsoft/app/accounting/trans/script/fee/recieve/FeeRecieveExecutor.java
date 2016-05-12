package com.amarsoft.app.accounting.trans.script.fee.recieve;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.trans.script.fee.common.CommonFeeScheduleCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

public class FeeRecieveExecutor implements ITransactionExecutor {
	
	@Override
	public int execute(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_log, transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		BusinessObject relativeBusinessObject = transaction.getRelativeObject(fee.getString("ObjectType"),fee.getString("ObjectNo"));
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		
		String waiveType = feeLog.getString("WaiveType");
		if("0".equals(waiveType)) //金额减免
		{
		}
		else if("1".equals(waiveType))//比例减免
		{
			feeLog.setAttributeValue("WaiveAmount", Arith.round(feeLog.getDouble("FeeAmount")*feeLog.getDouble("WaivePercent")/100.00d,2));
		}
		else
			throw new Exception("费用减免类型不正确请检查！");
		
		
		if(feeLog.getDouble("ActualFeeAmount") > fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount") && fee.getDouble("TotalAmount") > 0)
			throw new Exception("费用收取金额【"+Arith.round(feeLog.getMoney("ActualFeeAmount")-fee.getDouble("WaiveAmount"),2)+"】超过费用应收取金额【"+Arith.round(fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount"),2)+"】");
		
		BusinessObject feeSchedule = null;
		//如果没有费用计划就创建一条费用计划
		if(feeScheduleSerialNo == null || feeScheduleSerialNo.length() == 0)
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("FeeFlag", ACCOUNT_CONSTANTS.FEEFLAG_RECIEVE);
			List<BusinessObject> feeScheduleList = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule,as);
			if(feeScheduleList == null || feeScheduleList.isEmpty())
			{
				CommonFeeScheduleCreator c =new CommonFeeScheduleCreator();
				feeSchedule=c.init("",transactionScript);
				if(feeSchedule.getDouble("ActualAmount") >= feeSchedule.getDouble("Amount"))
					feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
				else 
					feeSchedule.setAttributeValue("FinishDate", "");
			}
			else
			{
				double actualFeeAmount = feeLog.getDouble("ActualFeeAmount");
				
				for(BusinessObject bo:feeScheduleList)
				{
					if(fee.getDouble("TotalAmount") > 0)
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
					}
					else
					{
						bo.setAttributeValue("ActualAmount", bo.getDouble("ActualAmount")+actualFeeAmount);
						bo.setAttributeValue("Amount", bo.getDouble("Amount")+actualFeeAmount);
						actualFeeAmount = 0.0d;
						feeLog.setAttributeValue("FeeScheduleSerialNo", bo.getObjectNo());
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,feeLog);
					}
					if(bo.getDouble("ActualAmount") >= bo.getDouble("Amount"))
						bo.setAttributeValue("FinishDate", transaction.getString("TransDate"));
					else 
						bo.setAttributeValue("FinishDate", "");
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bo);
					if(Math.abs(actualFeeAmount) < 0.0000001) break;
				}
				
				if(actualFeeAmount > 0)
				{
					throw new Exception("收取金额不能超过费用计划应收未收取金额！");
				}
				
				double waiveAmount = feeLog.getDouble("WaiveAmount");
				for(BusinessObject bo:feeScheduleList)
				{
					String direction = bo.getString("FeeFlag");
					if(direction.equals(ACCOUNT_CONSTANTS.FEEFLAG_RECIEVE))
					{
						double balance = bo.getDouble("Amount")-bo.getDouble("ActualAmount");
						if(balance+waiveAmount>0 )
						{
							balance = waiveAmount;
							waiveAmount = 0;
						}
						else
						{
							balance = -balance;
							waiveAmount += balance;
						}
						
						bo.setAttributeValue("Amount", bo.getDouble("Amount")+balance);
						bo.setAttributeValue("WaiveAmount", bo.getDouble("WaiveAmount")+balance);
						if(bo.getDouble("ActualAmount") >= bo.getDouble("Amount"))
							bo.setAttributeValue("FinishDate", transaction.getString("TransDate"));
						else 
							bo.setAttributeValue("FinishDate", "");
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bo);
					}
					if(Math.abs(waiveAmount) < 0.0000001) break;
				}
				
				if(waiveAmount > 0)
				{
					throw new Exception("减免金额不能超过费用计划应收未收取金额！");
				}
			}
		}
		else
		{
			feeSchedule = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeLog.getDouble("ActualFeeAmount")-fee.getDouble("WaiveAmount") > feeSchedule.getDouble("Amount")-feeSchedule.getDouble("ActualAmount") && fee.getDouble("TotalAmount") > 0)
				throw new Exception("费用收取金额【"+Arith.round(feeLog.getMoney("ActualFeeAmount")-fee.getDouble("WaiveAmount"),2)+"】超过费用计划应收取金额【"+Arith.round(feeSchedule.getDouble("Amount")-feeSchedule.getDouble("ActualAmount"),2)+"】");
			
			feeSchedule.setAttributeValue("WaiveAmount", feeSchedule.getDouble("WaiveAmount")+feeLog.getDouble("WaiveAmount"));
			feeSchedule.setAttributeValue("ActualAmount", feeSchedule.getDouble("ActualAmount")+feeLog.getDouble("ActualFeeAmount"));
			feeSchedule.setAttributeValue("Amount", feeSchedule.getDouble("Amount")+feeLog.getDouble("WaiveAmount"));
			if(feeSchedule.getDouble("ActualAmount") >= feeSchedule.getDouble("Amount"))
				feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
			else 
				feeSchedule.setAttributeValue("FinishDate", "");
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feeSchedule);
		}
		//处理费用
		fee.setAttributeValue("ActualRecieveAmount", fee.getDouble("ActualRecieveAmount")+feeLog.getDouble("ActualFeeAmount"));
		fee.setAttributeValue("WaiveAmount", feeLog.getDouble("WaiveAmount")+fee.getDouble("WaiveAmount"));
		fee.setAttributeValue("TotalAmount", feeLog.getDouble("WaiveAmount")+fee.getDouble("TotalAmount"));
		
		//如果费用需要摊销,赋值摊销金额和摊销到期日		
		if(!ACCOUNT_CONSTANTS.AMORTIZE_NO.equals(fee.getString("FeeAmortizeType")) && fee.getString("FeeAmortizeType") != null && !"".equals(fee.getString("FeeAmortizeType")))
		{
			ASValuePool asPool = ProductConfig.getProductTermParameter(relativeBusinessObject.getString("BusinessType"), relativeBusinessObject.getString("ProductVersion"),fee.getString("FeeTermID"),"AmortizeBeginBalance");
			 //转汇后大于配置金额的才摊销
			if(asPool!=null){
				double amBeginBalance =Double.valueOf(asPool.getString("DefaultValue"));
				double amortizeBeginBalance = Arith.round(fee.getDouble("TotalAmount")
						 *RateConfig.getExchangeRate(fee.getString("Currency"), "01"),2);
				if(amortizeBeginBalance>=amBeginBalance){
					if(ACCOUNT_CONSTANTS.AMORTIZE_LINE_DAY_AMOUNT.equals(fee.getString("FeeAmortizeType")) 
							||ACCOUNT_CONSTANTS.AMORTIZE_LINE_MONTH_AMOUNT.equals(fee.getString("FeeAmortizeType")))
						fee.setAttributeValue("Amortizebalance",fee.getDouble("Amortizebalance")+feeLog.getDouble("ActualFeeAmount"));
					else if(ACCOUNT_CONSTANTS.AMORTIZE_LINE_DAY_RAMOUNT.equals(fee.getString("FeeAmortizeType")) 
							||ACCOUNT_CONSTANTS.AMORTIZE_LINE_MONTH_RAMOUNT.equals(fee.getString("FeeAmortizeType")))
						fee.setAttributeValue("Amortizebalance",(fee.getDouble("Amortizebalance")==0 ? fee.getDouble("TotalAmount") : fee.getDouble("Amortizebalance")));
					else
						throw new Exception("未定义的摊销方式【"+fee.getString("FeeAmortizeType")+"】，请检查！");
					
					if (relativeBusinessObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)) {
						fee.setAttributeValue("AMORTIZEENDDATE",relativeBusinessObject.getString("MaturityDate"));
					} else if(relativeBusinessObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.Orgment)){
						fee.setAttributeValue("AMORTIZEENDDATE",fee.getString("SEGTODATE"));
					}
					else{
						fee.setAttributeValue("AMORTIZEENDDATE",relativeBusinessObject.getString("MATURITY"));
					}
					fee.setAttributeValue("AmortizeOccurDate",transaction.getString("TransDate"));
				 }
			}
		}
		

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
