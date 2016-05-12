package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.accrue.IInterestAccrue;
import com.amarsoft.app.accounting.interest.accrue.InterestAccrueFunctions;
import com.amarsoft.app.accounting.interest.settle.IInterestSettle;
import com.amarsoft.app.accounting.interest.settle.InterestSettleFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;

/**
 * @author xjzhao 2011/04/02
 * 
 */
public class LoanEODExecutor_accrueinterest implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();

		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String businessDate=loan.getString("BusinessDate");
		String accrueDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
		
		//扫描利率进行利息处理		
		Object[] interestTypeList = RateConfig.getInterestConfigSet().getKeys();
		for(Object interstTypeO:interestTypeList){
			String interestType = (String)interstTypeO;
			
			IInterestAccrue interestAccrueScript = InterestAccrueFunctions.getAccureInterestScript(interestType);
			if(interestAccrueScript == null) throw new DataException("利息类型"+interestType+"未定义结息脚本!");
			IInterestSettle interestSettleScript = InterestSettleFunctions.getSettleInterestScript(interestType);
			if(interestSettleScript == null) throw new DataException("利率类型"+interestType+"未定义结息脚本!");
			
			String interestObjectType = RateConfig.getInterestConfig(interestType, "InterestObjectType");
			if(interestObjectType==null||interestObjectType.length()==0){
				continue;
			}
			
			if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.loan)){
				interestAccrueScript.accrueInterest(loan,loan, accrueDate,interestType,transactionScript.getBOManager());
				String nextSettleDate = InterestSettleFunctions.getNextInteSettleDate(loan, loan, interestType);
				if(nextSettleDate.equals(accrueDate)){
					interestSettleScript.settleInterest(loan,loan, accrueDate,interestType,transactionScript.getBOManager());
				}
			}
			else if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)){
				//取未结清的正常还款计划，只取PayType=1的记录
				List<BusinessObject> paymentScheduleList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
				for(BusinessObject paymentSchedule:paymentScheduleList){
					interestAccrueScript.accrueInterest(loan,paymentSchedule, accrueDate,interestType,transactionScript.getBOManager());
					
					String nextSettleDate = InterestSettleFunctions.getNextInteSettleDate(loan, paymentSchedule, interestType);
					String lastSettleDate = InterestSettleFunctions.getLastInteSettleDate(loan, paymentSchedule,interestType);
					if(nextSettleDate.compareTo(lastSettleDate)>0&&nextSettleDate.equals(accrueDate)){
						interestSettleScript.settleInterest(loan,paymentSchedule, accrueDate,interestType,transactionScript.getBOManager());
					}
				}
			}
			else{
				throw new DataException("利息类型InterestConfig="+interestType+"定义的InterestObjectType属性无效!");
			}
		}
	
		return 1;
	}
	
}
