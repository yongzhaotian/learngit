package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.are.util.ASValuePool;

/**
 * @author xjzhao 2011/04/02
 * 
 */
public class UpdateInterestObjectExecutor implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		HashMap<String,Double> loanInterest = new HashMap<String,Double>();
		HashMap<String,HashMap<String,Double>> psInterestList = new HashMap<String,HashMap<String,Double>>();
		
		//扫描利率进行利息处理
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan);
		if(interestLogList==null) return 1;
		
		for(BusinessObject interestLog:interestLogList){
			String interestType = interestLog.getString("BaseAmountFlag");
			String interestObjectType = interestLog.getString("ObjectType");

			String interestAmtType = RateConfig.getInterestConfig(interestType, "InterestLogAmtFlag");
			if(interestAmtType==null||interestAmtType.equals(""))
				throw new LoanException("未定义利息是按照余额存储还是按照累计额存储！");
			String interestAttribute = null;
			
			
			String interestBalanceAttribute = RateConfig.getInterestConfig(interestType, "InterestBalanceAttribute");
			String interestPayAttribute = RateConfig.getInterestConfig(interestType, "InterestPayAttribute");
			if(interestAmtType.equals(ACCOUNT_CONSTANTS.INTEREST_LOG_AMT_FLAG_Balance))
				interestAttribute = interestBalanceAttribute;
			else if(interestAmtType.equals(ACCOUNT_CONSTANTS.INTEREST_LOG_AMT_FLAG_Total))
				interestAttribute = interestPayAttribute;
			else if(interestAmtType.equals(ACCOUNT_CONSTANTS.INTEREST_LOG_AMT_FLAG_Amt))
				interestAttribute = interestBalanceAttribute;
			else throw new LoanException("未定义利息是按照余额存储还是按照累计额存储！");
			
			double accrueInterest=0d;
			if(interestAmtType.equals(ACCOUNT_CONSTANTS.INTEREST_LOG_AMT_FLAG_Balance))
				accrueInterest = interestLog.getDouble("InterestSuspense")+interestLog.getDouble("InterestBalance");
			else if(interestAmtType.equals(ACCOUNT_CONSTANTS.INTEREST_LOG_AMT_FLAG_Total))
				accrueInterest = interestLog.getDouble("InterestSuspense")+interestLog.getDouble("InterestTotal");
			else if(interestAmtType.equals(ACCOUNT_CONSTANTS.INTEREST_LOG_AMT_FLAG_Amt))
				accrueInterest = interestLog.getDouble("InterestSuspense")+interestLog.getDouble("InterestAmt")+interestLog.getDouble("InterestBase");
			else throw new LoanException("未定义利息是按照余额存储还是按照累计额存储！");
			
			if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.loan)){
				double d = 0d;
				Double d1 =  loanInterest.get(interestAttribute);
				if(d1!=null) d=d1.doubleValue();
				d+=accrueInterest;
				loanInterest.put(interestAttribute, d);
			}
			else if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)){
				//取未结清的正常还款计划，只取PayType=1的记录
			    BusinessObject paymentSchedule = loan.getRelativeObject(interestLog.getString("ObjectType"), interestLog.getString("ObjectNo"));
			    if(paymentSchedule == null) continue;
			    HashMap<String,Double> a = psInterestList.get(paymentSchedule.getString("SerialNo"));
				if(a==null) {
					a=new HashMap<String,Double>();
					psInterestList.put(paymentSchedule.getString("SerialNo"), a);
				}
				
				double d = 0d; 
				Double d1 =  a.get(interestAttribute);
				if(d1!=null) d=d1.doubleValue();
				d+=accrueInterest;
				a.put(interestAttribute, d);
			}
		}
			
		Iterator<String> i = loanInterest.keySet().iterator();
		while(i.hasNext()){
			String key = i.next();
			loan.setAttributeValue(key, loanInterest.get(key));
		}
		transactionScript.getBOManager().setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		List<BusinessObject> paymentScheduleList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		for(BusinessObject paymentSchedule:paymentScheduleList){
			HashMap<String, Double> a = psInterestList.get(paymentSchedule.getString("SerialNo"));
			if(a == null || a.isEmpty()){
				ASValuePool asf = new ASValuePool();
				asf.setAttribute("ObjectNo", loan.getObjectNo());
				asf.setAttribute("ObjectType", loan.getObjectType());
				asf.setAttribute("RateType", "03");
				BusinessObject paymentFilter = new BusinessObject(asf);
				List<BusinessObject> ratelist = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, paymentFilter);
				if(ratelist == null || ratelist.isEmpty()) continue;
			}
			Iterator<String> iterator = a.keySet().iterator();
			while(iterator.hasNext()){
				String key = iterator.next();
				paymentSchedule.setAttributeValue(key, a.get(key));
			}
			transactionScript.getBOManager().setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentSchedule);
		}
		
		return 1;
	}
}
