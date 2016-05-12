/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.are.util.Arith;

/**
 * 等额本金
 * @author yegang
 */
public class PMTScript2 extends BasicPMTScript {
	
	public double getInstalmentAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
    	double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
    	int totalPeriod=rptSegment.getInt("TotalPeriod");
    	if(instalmentAmt<=0d||updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){//如果需要更新，则重新计算
    		totalPeriod =  RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
    		//计算本阶段需要偿还的本金金额
    		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
    		if(totalPeriod ==0) return 0.0d;
        	double instalmentAmount = outstandingBalance /totalPeriod;
        	return Arith.round(instalmentAmount,2);
    	}
    	else{//否则直接返回原来的结果
    		return instalmentAmt;
    	}
	}
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		if(rptSegment.getString("NEXTDUEDATE") != null && !"".equals(rptSegment.getString("NEXTDUEDATE")) 
    			&& (rptSegment.getString("SegToDate")!= null && !"".equals(rptSegment.getString("SegToDate")) 
    			&& rptSegment.getString("NEXTDUEDATE").compareTo(rptSegment.getString("SegToDate")) >= 0 
    			|| rptSegment.getString("NEXTDUEDATE").compareTo(loan.getString("MaturityDate")) >= 0 )) 
			return RPTFunctions.getOutStandingBalance(loan, rptSegment);
		return this.getInstalmentAmount(loan,rptSegment);
	}

}
