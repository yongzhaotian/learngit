package com.amarsoft.app.accounting.interest.settle;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.util.ExtendedFunctions;

public class CommonSettleInterest implements IInterestSettle {
	
	public List<BusinessObject> settleInterest(BusinessObject loan,BusinessObject interestObject,String settleDate,String interestType,AbstractBusinessObjectManager bomanager) throws Exception{
		
		ArrayList<BusinessObject> r= new ArrayList<BusinessObject>();
		String interestObjectType = RateConfig.getInterestConfig(interestType, "InterestObjectType");
		if(interestObjectType==null||interestObjectType.length()==0){
			throw new DataException("利率InterestConfig="+interestType+"未找到定义的InterestObjectType属性!");
		}
		if(!interestObjectType.equals(interestObject.getObjectType())) return r;
		
		String interestEffectScript =RateConfig.getInterestConfig(interestType, "InterestEffectScript");
		if(interestEffectScript!=null&&interestEffectScript.length()>0) {
			interestEffectScript = ExtendedFunctions.getScript(interestEffectScript, interestObject, null);
			boolean b = ExtendedFunctions.getScriptBooleanValue(interestEffectScript, loan,null);
			if(!b) return r;
		}
		
		String rateType = RateConfig.getInterestConfig(interestType, "RateType");
		if(rateType==null||rateType.length()==0){
			throw new DataException("利率InterestConfig="+interestType+"未找到定义的RateType属性!");
		}
		
		List<BusinessObject> rateSegmentList = InterestFunctions.getRateSegmentList(loan, rateType);
		for(BusinessObject rateSegment:rateSegmentList){
			BusinessObject interestLog = InterestLogFunctions.getActiveInterestLog(loan, interestObject,interestType,rateSegment);
			
			if(interestLog==null){//首次计算利息
				String lastSettleDate = InterestSettleFunctions.getLastInteSettleDate(loan, interestObject,interestType);
				if(settleDate.equals(lastSettleDate)) return r;
				interestLog = InterestLogFunctions.createInterestLog(loan, interestObject, rateSegment, lastSettleDate, interestType, bomanager);
				if(interestLog==null) return r;
			}
			r.add(interestLog);
			
			String nextSettleDate=InterestSettleFunctions.getNextInteSettleDate(loan, interestObject,interestType);//下次结息日			
			while(nextSettleDate.compareTo(settleDate)<0){
				InterestLogFunctions.settleInterestLog(loan, interestLog, nextSettleDate, bomanager);
				
				interestLog = InterestLogFunctions.createInterestLog(loan, interestObject, rateSegment, nextSettleDate, interestType, bomanager);
				if(interestLog!=null){
					interestLog.setAttributeValue("InterestBalance", interestLog.getDouble("InterestBalance"));
					interestLog.setAttributeValue("SuspenseBalance", interestLog.getDouble("SuspenseBalance"));
					r.add(interestLog);
				}
				nextSettleDate=InterestSettleFunctions.getNextInteSettleDate(loan, interestObject,interestType);//下次结息日	
			}
			if(interestLog!=null){
				InterestLogFunctions.settleInterestLog(loan, interestLog, settleDate, bomanager);
			}
		}
		
		return r;
	}

}
