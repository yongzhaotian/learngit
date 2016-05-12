package com.amarsoft.app.accounting.trans.script.common.executor;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.are.util.Arith;

public class ReverseTransactionExecutor extends BookKeepExecutor{

	@Override
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript=transactionScript;
		
		List<BusinessObject> detailList = createRushDetail();
		//检查账务信息
		checkbalance(detailList);
		//更新分户账
		updateLedgerAccount(detailList);
		reverseFee();
		return 1;
	}
	
	
	/**
	 * 根据原交易流水创建冲账的流水
	 * @return 
	 * @throws Exception 
	 */
	private List<BusinessObject> createRushDetail() throws Exception{
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();
		
		String transFlag = TransactionConfig.getTransactionDef(transaction.getString("TransCode"), "TransFlag");
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		if(transFlag==null||transFlag.length()==0) {//当年红字，以前年份蓝字
			String transDate=transaction.getString("TransDate");
			if(transDate==null||transDate.length()==0) transDate=SystemConfig.getBusinessDate();
			String oldTransDate = oldTransaction.getString("TransDate");
			if(transDate.substring(0,4).equals(oldTransDate.substring(0,4)))//当年红字
				transFlag="R";
			else transFlag="B";//以前年份蓝字
		}
		
		List<BusinessObject> oldDetailList = oldTransaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subledger_detail);
		ArrayList<BusinessObject> rushDetailList=new ArrayList<BusinessObject>();
		if(oldDetailList!=null&&!oldDetailList.isEmpty()){
			for (int i = oldDetailList.size() - 1; i >= 0; i--) {
				BusinessObject subledgerDetailTemp = oldDetailList.get(i);
				String accountCodeNo = subledgerDetailTemp.getString("AccountCodeNo");
				String bookType = subledgerDetailTemp.getString("BookType");
				double creditAmt = subledgerDetailTemp.getMoney("CreditAmt");
				double debitAmt = subledgerDetailTemp.getMoney("DebitAmt");
				
				BusinessObject subledgerDetail = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
				
				//String类型的赋值
				subledgerDetail.setAttributeValue("BASECURRENCY",subledgerDetailTemp.getString("BASECURRENCY"));
				subledgerDetail.setAttributeValue("ACCOUNTINGORGID",subledgerDetailTemp.getString("ACCOUNTINGORGID"));
				subledgerDetail.setAttributeValue("SORTNO",subledgerDetailTemp.getString("SORTNO"));
				subledgerDetail.setAttributeValue("TRANSSERIALNO",transaction.getObjectNo());
				subledgerDetail.setAttributeValue("SUBLEDGERSERIALNO",subledgerDetailTemp.getString("SUBLEDGERSERIALNO"));
				subledgerDetail.setAttributeValue("OCCURDATE",transaction.getString("TransDate"));
				subledgerDetail.setAttributeValue("CURRENCY",subledgerDetailTemp.getString("CURRENCY"));
				subledgerDetail.setAttributeValue("LDSTATUS","0");
				subledgerDetail.setAttributeValue("DESCRIPTION","冲销");
				subledgerDetail.setAttributeValue("ACCOUNTCODENO",accountCodeNo);
				subledgerDetail.setAttributeValue("OBJECTNO",subledgerDetailTemp.getString("OBJECTNO"));
				subledgerDetail.setAttributeValue("OBJECTTYPE",subledgerDetailTemp.getString("OBJECTTYPE"));
				subledgerDetail.setAttributeValue("BOOKTYPE",bookType);
				
				//反冲需要根据原始分录的借贷方向判断，增加此字段，以区分借贷红字和收付蓝字反冲，如果未找到发生方向，则根据科目属性判断
				String directionTmp = subledgerDetailTemp.getString("Direction");
				if(directionTmp==null||directionTmp.equals("")){//兼容目前没有增加此字段的版本
					if("S".equals(bookType)) continue;//核心分录跳过，否则下句报错
					String  onBalanceSheetFlag= AccountCodeConfig.getAccountCodeDefinition(bookType, accountCodeNo).getString("OnBalanceSheetFlag");
					if(onBalanceSheetFlag!=null&&onBalanceSheetFlag.equals("2")){//表外科目
						if(debitAmt>0){
							directionTmp="R";
						}
						else if((creditAmt>0)){
							directionTmp="P";
						}
						else continue;//理论上不存在此种情况
					}
					else{//表内科目
						if(debitAmt>0){
							directionTmp="D";
						}
						else if((creditAmt>0)){
							directionTmp="C";
						}
						else continue;//理论上不存在此种情况
					}
				}
				
				String direction = null;
				if(transFlag.equals("R")&&(directionTmp.equals("D")||directionTmp.equals("C"))){//如果交易中指定了反冲时使用红字，则同向反冲；默认使用红字
					subledgerDetail.setAttributeValue("CREDITAMT",Arith.round(0-creditAmt,2));
					subledgerDetail.setAttributeValue("DEBITAMT",Arith.round(0-debitAmt,2));
					direction = directionTmp;
				}
				else{//蓝字反冲
					if(directionTmp.equals("D")||directionTmp.equals("R")){
						subledgerDetail.setAttributeValue("CREDITAMT",debitAmt);
						subledgerDetail.setAttributeValue("DEBITAMT",0d);
					}else if(directionTmp.equals("C")||directionTmp.equals("P")){
						subledgerDetail.setAttributeValue("DEBITAMT",creditAmt);
						subledgerDetail.setAttributeValue("CREDITAMT",0d);
					}else{
						continue;
					}
					
					if(directionTmp.equals("D")) direction="C";
					else if(directionTmp.equals("C")) direction="D";
					else if(directionTmp.equals("P")) direction="R";
					else if(directionTmp.equals("R")) direction="P";
				}
				subledgerDetail.setAttributeValue("Direction", direction);
				
				if(!AccountCodeConfig.accountcode_type_s.equals(subledgerDetailTemp.getString("BOOKTYPE")))//不是发送核心分录才计算折本币金额
				{
					//汇率
					double exchangeRate = RateConfig.getExchangeRate(subledgerDetailTemp.getString("CURRENCY"), subledgerDetailTemp.getString("BASECURRENCY"));
					double baseCurrencyAmount =(debitAmt+ creditAmt)*exchangeRate;
					//FMS负数标示贷方
					if(creditAmt >0 ){
						baseCurrencyAmount  = 0 - baseCurrencyAmount;
					}
					
					//金额字段的赋值
					subledgerDetail.setAttributeValue("BASECURRENCYAMOUNT",Arith.round(baseCurrencyAmount,2));
					
					
					subledgerDetail.setAttributeValue("EXCHANGERATE",subledgerDetailTemp.getDouble("EXCHANGERATE"));
				}
				
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,subledgerDetail);	
				rushDetailList.add(subledgerDetail);
			}
		}
		
		return rushDetailList;
	}
	
	public void reverseFee() throws Exception 
	{
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();
		//取原交易对象
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		List<BusinessObject> feeTransactionList = oldTransaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.transaction);
		if(feeTransactionList != null && !feeTransactionList.isEmpty())
		{
			for(BusinessObject feeTransaction:feeTransactionList)
			{
				BusinessObject document = feeTransaction.getRelativeObject(feeTransaction.getString("DocumentType"), feeTransaction.getString("DocumentSerialNo"));
				BusinessObject fee = feeTransaction.getRelativeObject(feeTransaction.getString("RelativeObjectType"), feeTransaction.getString("RelativeObjectNo"));
				double feeAmt = document.getDouble("ActualFeeAmount");
				String feeFlag = document.getString("Direction");
				if(feeFlag==null||feeFlag.length()==0) continue;
				else if(feeFlag.equals("R")){
					fee.setAttributeValue("ActualRecieveAmount", Arith.round(fee.getDouble("ActualRecieveAmount")-feeAmt,2));
				}
				else if(feeFlag.equals("P")){
					fee.setAttributeValue("ActualPayAmount", Arith.round(fee.getDouble("ActualPayAmount")-feeAmt,2));
				}
				document.setAttributeValue("ActualFeeAmount", 0.0d);
				if(document.getString("FeeScheduleSerialNo") == null || "".equals(document.getString("FeeScheduleSerialNo")))
				{
					List<BusinessObject> feeScheduleList = feeTransaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule);
					if(feeScheduleList != null)
					{
						for(BusinessObject bo:feeScheduleList)
						{
							double actualAmount = bo.getDouble("ActualAmount");
							if(feeAmt > actualAmount)
							{
								bo.setAttributeValue("ActualAmount", 0.0d);
								feeAmt -= actualAmount;
								if(Math.abs(fee.getDouble("TotalAmount")) < 0.0000001)
								{
									bo.setAttributeValue("Amount", 0.0d);
								}
							}
							else
							{
								bo.setAttributeValue("ActualAmount", actualAmount-feeAmt);
								feeAmt = 0.0d;
								if(Math.abs(fee.getDouble("TotalAmount")) < 0.0000001)
								{
									bo.setAttributeValue("Amount", actualAmount-feeAmt);
								}
							}
							
							if(bo.getDouble("ActualAmount") < bo.getDouble("Amount"))
								bo.setAttributeValue("FinishDate", "");
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bo);
							if(Math.abs(actualAmount) < 0.0000001) break;
						}
					}
				}
				else
				{
					BusinessObject paymentSchedule = feeTransaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule, document.getString("FeeScheduleSerialNo"));
					if(Math.abs(fee.getDouble("TotalAmount")) < 0.0000001)
					{
						paymentSchedule.setAttributeValue("Amount", paymentSchedule.getDouble("Amount")-feeAmt);
					}
					paymentSchedule.setAttributeValue("ActualAmount", paymentSchedule.getDouble("ActualAmount")-feeAmt);
					if(paymentSchedule.getDouble("ActualAmount") < paymentSchedule.getDouble("Amount"))
						paymentSchedule.setAttributeValue("FinishDate", "");
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentSchedule);
				}
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, document);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, fee);
			}
		}
	}

}
