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
 * ����
 */
public class LoanEODExecutor_postpone implements ITransactionExecutor{
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String businessDate = loan.getString("BusinessDate");//�����ʱ��
			
			int graceDays = loan.getInt("GraceDays");//���ڿ���������
			//ȡδ�������������ƻ���ֻȡPayType=1�ļ�¼
			List<BusinessObject> paymentscheduleList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
			for(BusinessObject a:paymentscheduleList){//��������ںͽڼ���˳�Ӻ����Ч����
				String payDate=a.getString("PayDate");
				String inteDate=a.getString("InteDate");
				if(inteDate!=null&&inteDate.length()>0) continue;
				if(payDate.compareTo(businessDate) <= 0){//��ʾ�������ڵĲż���
					//1.����ڼ���
					String holidayInteDate=payDate;
					
					if(!DateFunctions.isWorkingDate2(payDate, loan.getString("HolidayPaymentFlag"))){//����������ǽڼ���
							holidayInteDate = DateFunctions.getNextWorkDate(payDate, loan.getString("HolidayPaymentFlag"));
					}
					
					//2.�����ڴ���
					String graceInteDate = payDate;
					if(graceDays>0){
						graceInteDate = DateFunctions.getRelativeDate(payDate, DateFunctions.TERM_UNIT_DAY, graceDays);
					}
					
					//3.�����ܵ�˳�����ڣ����ݹ�����
					String postponePaymentFlag=loan.getString("PostponePaymentFlag");
					if(postponePaymentFlag==null||postponePaymentFlag.length()==0||postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_Max)){
						inteDate=holidayInteDate.compareTo(graceInteDate)<0?graceInteDate:holidayInteDate;
					}
					else if(postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_Min)){
						inteDate=holidayInteDate.compareTo(graceInteDate)>0?graceInteDate:holidayInteDate;
					}
					else if(postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_GRACE_HOLIDAY)){
						//��������ں���׸������ǽڼ��գ����Զ�����˳��
						if(!DateFunctions.isWorkingDate2(graceInteDate, loan.getString("HolidayPaymentFlag"))){
							inteDate = DateFunctions.getNextWorkDate(graceInteDate, loan.getString("HolidayPaymentFlag"));
						}
						else{
							inteDate=holidayInteDate.compareTo(graceInteDate)<0?graceInteDate:holidayInteDate;
						}
					}
					else if(postponePaymentFlag.equals(ACCOUNT_CONSTANTS.POSTPONE_PAYMENT_FLAG_HOLIDAY_GRACE)){
						//�ڼ��պ�����̶�������
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
						throw new DataException("PostponePaymentFlagֵ��Ч��");
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
