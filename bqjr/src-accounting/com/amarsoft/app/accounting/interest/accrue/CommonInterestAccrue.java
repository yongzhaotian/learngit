package com.amarsoft.app.accounting.interest.accrue;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.interest.settle.InterestLogFunctions;
import com.amarsoft.app.accounting.interest.settle.InterestSettleFunctions;
import com.amarsoft.app.accounting.util.ExtendedFunctions;

public class CommonInterestAccrue implements IInterestAccrue {

	@Override
	public void accrueInterest(BusinessObject loan,BusinessObject interestObject, String accrueDate,String interestType,AbstractBusinessObjectManager bomanager) throws Exception {
		String interestObjectType = RateConfig.getInterestConfig(interestType, "InterestObjectType");
		if(interestObjectType==null||interestObjectType.length()==0){
			throw new DataException("利率InterestConfig="+interestType+"未找到定义的InterestObjectType属性!");
		}
		if(!interestObjectType.equals(interestObject.getObjectType())) return;
		
		String rateType = RateConfig.getInterestConfig(interestType, "RateType");
		if(rateType==null||rateType.length()==0){
			throw new DataException("利率InterestConfig="+interestType+"未找到定义的RateType属性!");
		}
		
		boolean b = false;
		String accrueEffectScript =RateConfig.getInterestConfig(interestType, "AccureEffectScript");
		if(accrueEffectScript==null||accrueEffectScript.length()==0) return;//不计提
		
		accrueEffectScript = ExtendedFunctions.getScript(accrueEffectScript, interestObject, null);
		b = ExtendedFunctions.getScriptBooleanValue(accrueEffectScript, loan,null);
		if(!b) return ;
		
		String interestEffectScript =RateConfig.getInterestConfig(interestType, "InterestEffectScript");
		if(interestEffectScript!=null&&interestEffectScript.length()>0) {
			interestEffectScript = ExtendedFunctions.getScript(interestEffectScript, interestObject, null);
			b = ExtendedFunctions.getScriptBooleanValue(interestEffectScript, loan,null);
			if(!b) return ;
		}
		List<BusinessObject> rateSegmentList = InterestFunctions.getRateSegmentList(loan, rateType);
		for(BusinessObject rateSegment:rateSegmentList){
			BusinessObject interestLog = InterestLogFunctions.getActiveInterestLog(loan, interestObject,interestType, rateSegment);
			if(interestLog==null){
				String interestDate = InterestSettleFunctions.getLastInteSettleDate(loan, interestObject, interestType);
				interestLog = InterestLogFunctions.createInterestLog(loan, interestObject, rateSegment, interestDate, interestType, bomanager);
			}
			if(interestLog!=null){
				InterestLogFunctions.accrueInterestLog(loan, interestLog, accrueDate, bomanager);
			}
		}
	}
}
