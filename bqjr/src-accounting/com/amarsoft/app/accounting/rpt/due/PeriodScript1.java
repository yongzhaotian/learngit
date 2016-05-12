/**
 * 
 */
package com.amarsoft.app.accounting.rpt.due;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.util.Financial.PMT;

/**
 * �ȶϢ
 * @author yegang
 */
public class PeriodScript1 implements IPeriodScript {
	
	public int getTotalPeriod(BusinessObject loan, BusinessObject rptSegment)
			throws Exception {
		double instalmentAmount = rptSegment.getDouble("SegInstalmentAmt");
		double loanAmount = RPTFunctions.getOutStandingBalance(loan,rptSegment);
		
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);
		double instalmentInterestRate = 0.0d;
		if(rateList == null || rateList.isEmpty()){//������������Ĭ��Ϊ��
			instalmentInterestRate = 0.0d;
		}
		else{
			BusinessObject rateTerm = rateList.get(0);
			instalmentInterestRate = InterestFunctions.getInstalmentRate(1.0d,
					rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), paymentFrequencyType);
		}
		return PMT.getLoanPeriod(instalmentAmount, loanAmount, instalmentInterestRate);
	}
}
