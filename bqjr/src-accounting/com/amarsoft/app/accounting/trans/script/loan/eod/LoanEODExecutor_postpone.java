package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;

/**
 * @author xjzhao 2011/04/02
 * 垫款交易
 */
public class LoanEODExecutor_postpone implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String businessDate = loan.getString("BusinessDate");//贷款处理时间
			
			int graceDays = loan.getInt("GraceDays");//逾期宽限期天数
			//取未结清的正常还款计划，只取PayType=1的记录
			List<BusinessObject> paymentscheduleList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
			for(BusinessObject a:paymentscheduleList){//计算宽限期和节假日顺延后的有效日期
				String payDate=a.getString("PayDate");
				String inteDate=a.getString("InteDate");
				if(inteDate!=null&&inteDate.length()>0) continue;
				if(payDate.compareTo(businessDate) <= 0){//标示不是逾期的才计算
					//1.处理节假日
					String holidayInteDate=payDate;
					
					if(!DateFunctions.isWorkingDate2(payDate, loan.getString("HolidayPaymentFlag"))){//如果还款日是节假日
							holidayInteDate = DateFunctions.getNextWorkDate(payDate, loan.getString("HolidayPaymentFlag"));
					}
					
					//2.宽限期处理
					String graceInteDate = payDate;
					if(graceDays>0){
						graceInteDate = DateFunctions.getRelativeDate(payDate, DateFunctions.TERM_UNIT_DAY, graceDays);
					}
					
					//3.处理总的顺延日期，根据规则处理
					String postponePaymentFlag=loan.getString("PostponePaymentFlag");
					if(postponePaymentFlag==null||postponePaymentFlag.length()==0||postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_Max)){
						inteDate=holidayInteDate.compareTo(graceInteDate)<0?graceInteDate:holidayInteDate;
					}
					else if(postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_Min)){
						inteDate=holidayInteDate.compareTo(graceInteDate)>0?graceInteDate:holidayInteDate;
					}
					else if(postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_GRACE_HOLIDAY)){
						//如果宽限期后的首个日期是节假日，则自动继续顺延
						if(!DateFunctions.isWorkingDate2(graceInteDate, loan.getString("HolidayPaymentFlag"))){
							inteDate = DateFunctions.getNextWorkDate(graceInteDate, loan.getString("HolidayPaymentFlag"));
						}
						else{
							inteDate=holidayInteDate.compareTo(graceInteDate)<0?graceInteDate:holidayInteDate;
						}
					}
					else if(postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_HOLIDAY_GRACE)){
						//节假日后继续固定宽限期
						inteDate = DateFunctions.getRelativeDate(holidayInteDate, DateFunctions.TERM_UNIT_DAY, graceDays);
					}
					else if(postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_ANY)){
						String newHolidayInteDate = DateFunctions.getRelativeDate(holidayInteDate, DateFunctions.TERM_UNIT_DAY, graceDays);
						String newGraceInteDate = graceInteDate;
						if(!DateFunctions.isWorkingDate2(newGraceInteDate, loan.getString("HolidayPaymentFlag")))
							newGraceInteDate = DateFunctions.getNextWorkDate(newGraceInteDate, loan.getString("HolidayPaymentFlag"));
							inteDate = newHolidayInteDate.compareTo(newGraceInteDate)<0?newGraceInteDate:newHolidayInteDate;
					}
					else{
						throw new DataException("PostponePaymentFlag值无效！");
					}
			
					a.setAttributeValue("InteDate", inteDate);
					a.setAttributeValue("HolidayInteDate", holidayInteDate);
					a.setAttributeValue("GraceInteDate", graceInteDate);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, a);
				}
			}
			return 1;
	}
}
