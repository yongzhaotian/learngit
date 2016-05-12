package com.amarsoft.app.accounting.interest.settle;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.util.LoanFunctions;

public class InterestSettleFunctions {
	
	public static IInterestSettle getSettleInterestScript(String interestType) throws Exception{
		String classname=RateConfig.getInterestConfig(interestType, "SettleInterestScript");
		if(classname!=null && !"".equals(classname)){
			Class<?> c = Class.forName(classname);
			IInterestSettle scriptClass=((IInterestSettle)c.newInstance());
			return scriptClass;
		}
		else return new CommonSettleInterest();
	}

	public static String getLastInteSettleDate(BusinessObject loan,BusinessObject interestObject,String interestType)throws Exception{
		if(interestObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)){
			return InterestSettleFunctions.getLastInteSettleDate_Loan(loan,interestType);
		}
		else if(interestObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)){
			return InterestSettleFunctions.getLastInteSettleDate_PS(loan,interestObject,interestType);
		}
		else throw new DataException("无效的计利对象"+interestObject.getObjectType()+"！");
	}
	
	public static String getNextInteSettleDate(BusinessObject loan,BusinessObject interestObject,String interestType)throws Exception{
		String nextSettleDate = LoanFunctions.getNextDueDate(loan);
		
		if(interestObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)){
			if(nextSettleDate==null||nextSettleDate.length()==0) return "";
			else return nextSettleDate;
		}
		else if(interestObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)){
			if(nextSettleDate==null||nextSettleDate.length()==0) {
				int m = DateFunctions.getUpMonths(interestObject.getString("PayDate"), loan.getString("BusinessDate"));
				if(m==0) m=1;
				return DateFunctions.getRelativeDate(interestObject.getString("PayDate"), DateFunctions.TERM_UNIT_MONTH, m);
			}
			else return nextSettleDate;
		}
		else throw new DataException("无效的计利对象"+interestObject.getObjectType()+"！");
	}
	
	private static String getLastInteSettleDate_Loan(BusinessObject loan,String interestType)throws Exception{
		String lastSettleDate = "";
		
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan,loan,interestType);
		if(interestLogList!=null){
			for(BusinessObject interestLog:interestLogList){
				String interestDate = interestLog.getString("InterestDate");
				if(lastSettleDate==null||lastSettleDate.length()==0||lastSettleDate.compareTo(interestDate)<0)lastSettleDate = interestDate;
			}
		}
		
		if(lastSettleDate==null||lastSettleDate.length()==0) {
			lastSettleDate = LoanFunctions.getLastDueDate(loan);
				if(lastSettleDate==null||lastSettleDate.length()==0)
					return loan.getString("PutoutDate");
				else return lastSettleDate;
		}
		return lastSettleDate;
	}
	
	private static String getLastInteSettleDate_PS(BusinessObject loan,BusinessObject paymentSchedule,String interestType)throws Exception{
		String lastSettleDate = "";
		
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan,loan,interestType);
		if(interestLogList!=null){
			for(BusinessObject interestLog:interestLogList){
				String interestDate = interestLog.getString("InterestDate");
				if(lastSettleDate==null||lastSettleDate.length()==0||lastSettleDate.compareTo(interestDate)<0)lastSettleDate = interestDate;
			}
		}
		
		if(lastSettleDate==null||lastSettleDate.length()==0) {
			lastSettleDate = paymentSchedule.getString("PayDate");
		}
		return lastSettleDate;
		}
	}
