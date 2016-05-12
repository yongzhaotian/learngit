package com.amarsoft.app.accounting.interest.suspense;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.interest.settle.InterestLogFunctions;

public class InterestSuspenseFunctions {
	
		//取暂记利息
		public static double getSuspenseInterest(BusinessObject loan,BusinessObject interestObject,BusinessObject rateSegment,String interestType)throws Exception{

			BusinessObject interestLog = InterestLogFunctions.getActiveInterestLog(loan, interestObject,interestType, rateSegment);
			if(interestLog==null) {
				return 0.0d;
			}
			return interestLog.getDouble("InterestSuspense");
		}
}
