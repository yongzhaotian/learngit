/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.are.util.Arith;

/**
 * 快速双周供（等本）
 * @author yegang
 */
public class PMTScript7 extends BasicPMTScript {
	
	public double getInstalmentAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
    	double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
    	int totalPeriod=rptSegment.getInt("TotalPeriod");
    	if(instalmentAmt<=0d||updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){//如果需要更新，则重新计算
    		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//偿还周期
    		rptSegment.setAttributeValue("PaymentFrequencyType", "1");//按月
    		totalPeriod =  RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
    		rptSegment.setAttributeValue("PaymentFrequencyType", paymentFrequencyType);//还原周期
    		//计算本阶段需要偿还的本金金额
    		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
    		if(totalPeriod ==0) return 0.0d;
        	double instalmentAmount = outstandingBalance /totalPeriod;
        	return Arith.round(instalmentAmount/2d,2);
    	}
    	else{//否则直接返回原来的结果
    		return instalmentAmt;
    	}
	}
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		return this.getInstalmentAmount(loan,rptSegment);
	}

}
