package com.amarsoft.app.accounting.trans.script.loan.balancemigrate;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.Arith;

public class BalanceMigrateExecutor implements ITransactionExecutor{
	

	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		String changePrincipalType = loanChange.getString("ChangePrincipalType");
		if("".equals(changePrincipalType)) throw new Exception("本金的调整类型为空！");
		
		double amt = loanChange.getDouble("ChangePrincipalAmt");
		double inte = 0.0d;
		List<BusinessObject> rateSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		if(rateSegmentList != null)
		{
			for(BusinessObject rateSegment:rateSegmentList)
			{
				inte +=InterestFunctions.getInterest(amt, rateSegment,loan, rateSegment.getString("LastInteDate"), transaction.getString("TransDate"));
			}
		}
		
		double balance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo"
																	,ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal
																	,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		
		//正常转逾期
		if("010".equals(changePrincipalType)){
			
			//正常转逾期,需要将正常本金计提的利息转入到欠息
			//找最近一期欠的还款计划，如果有，将本金更新至上面，如没有，写如一条当天到期的计划
			//删除未来的还款计划，然后生成新的还款计划
			List<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			
			BusinessObject paymentScheduleTmp = null;
			if(paymentScheduleList!=null && paymentScheduleList.size()>0){
				int size = paymentScheduleList.size()-1;
				String businessDate = loan.getString("BusinessDate");
				for(int i=size;i>=0;i--){
					BusinessObject paymentSchedule = paymentScheduleList.get(i);
					
					//未来的还款计划，及不是一般还款计划的都跳过
					if(paymentSchedule.getString("PayDate").compareTo(businessDate)>0 ||
							!paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)) continue;
					paymentScheduleTmp = paymentSchedule;
					break;
				}
				
				//如果没有最近的还款计划，则新插入一条还款计划
				if(paymentScheduleTmp==null){
					BusinessObject newPaymentSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,boManager);
					newPaymentSchedule.setAttributeValue("ObjectType", loan.getObjectType());
					newPaymentSchedule.setAttributeValue("ObjectNo", loan.getObjectNo());
					newPaymentSchedule.setAttributeValue("SeqID", loan.getString("CurrentPeriod")+1);
					newPaymentSchedule.setAttributeValue("PayDate", businessDate);
					newPaymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
					newPaymentSchedule.setAttributeValue("InteDate", businessDate);
					newPaymentSchedule.setAttributeValue("PayPrincipalAmt", amt);
					newPaymentSchedule.setAttributeValue("PayInteAmt", inte);
					newPaymentSchedule.setAttributeValue("PrincipalBalance", Arith.round(balance-amt,2));
					newPaymentSchedule.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
					newPaymentSchedule.setAttributeValue("Remark", "正常本金转逾期本金");
					boManager.setBusinessObject(
							AbstractBusinessObjectManager.operateflag_new, newPaymentSchedule);
					
				}else{//如果有，将最近一期更的应还金额更新上
					paymentScheduleTmp.setAttributeValue("PayPrincipalAmt",Arith.round(paymentScheduleTmp.getDouble("PayPrincipalAmt")+amt,2));
					paymentScheduleTmp.setAttributeValue("PayInteAmt", Arith.round(paymentScheduleTmp.getDouble("PayInteAmt")+inte,2));
					paymentScheduleTmp.setAttributeValue("PrincipalBalance",Arith.round(paymentScheduleTmp.getDouble("PrincipalBalance")-amt,2) );
					paymentScheduleTmp.setAttributeValue("FinishDate","" );
					paymentScheduleTmp.setAttributeValue("SettleDate","" );
					
					boManager.setBusinessObject(
							AbstractBusinessObjectManager.operateflag_update, paymentScheduleTmp);
				}
			}
			
		}else if("020".equals(changePrincipalType)){ //逾期转正常
			List<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			double amtTemp=amt;
			if(paymentScheduleList!=null&&paymentScheduleList.size()>0){
				int size = paymentScheduleList.size()-1;
				String businessDate = loan.getString("BusinessDate");
				for(int i =size;i>=0;i-- ){
					if(amtTemp<=0) break;
					BusinessObject bo =  paymentScheduleList.get(i);
					if(businessDate.compareTo(bo.getString("PayDate"))<0 || !"".equals(bo.getString("FinishDate"))) continue;
					double payAmount = Arith.round(bo.getDouble("PayPrincipalAmt"),2) - Arith.round(bo.getDouble("ActualPayPrincipalAmt"),2);
					if(payAmount<=0d)continue;
					if(amtTemp-payAmount>0){
						bo.setAttributeValue("PayPrincipalAmt", bo.getDouble("ActualPayPrincipalAmt"));
						amtTemp-=payAmount;
						//bo.setAttributeValue("PrincipalBalance", bo.getDouble("ActualPayPrincipalAmt"));
						bo.setAttributeValue("PrincipalBalance",Arith.round(bo.getDouble("PrincipalBalance")+payAmount,2) );
					}else{
						bo.setAttributeValue("PayPrincipalAmt", bo.getDouble("PayPrincipalAmt")-amtTemp);
						bo.setAttributeValue("PrincipalBalance",Arith.round(bo.getDouble("PrincipalBalance")+amtTemp,2) );
						amtTemp=0;
					}
					//【设置为更新】
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bo);			
				}
			}
		}
		else
			throw new Exception("本金的调整类型不正确！");
				
		if(Math.abs(amt) > 0.0 ){
			loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");
			loan.setAttributeValue("UpdateInstalAmtFlag", "1");
		}
		
		return 1;
	}
}