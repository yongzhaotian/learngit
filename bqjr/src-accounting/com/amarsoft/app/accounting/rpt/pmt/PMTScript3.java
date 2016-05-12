/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.are.util.Arith;

/**
 * 等额递变
 * @author yegang
 */
public class PMTScript3 extends BasicPMTScript {
	
	public double getInstalmentAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		int totalPeriod=rptSegment.getInt("TotalPeriod");
    	String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
    	double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
    	if(instalmentAmt<=0d||updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){//如果需要更新，则重新计算
    		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//偿还周期
    		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);
    		
    		double installInterestRate = 0.0d;
    		if(rateList == null || rateList.isEmpty())
    			installInterestRate = 0.d;
    		else
    		{
    			BusinessObject rateTerm = rateList.get(0);
    			installInterestRate = InterestFunctions.getInstalmentRate(1.0d,
        				rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), paymentFrequencyType);
    		}
    		
    		totalPeriod =  RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
    		
    		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
    		double instalmentAmount=0d;
        	
        	int gainCyc = rptSegment.getInt("GainCyc");
    		double gainAmount = rptSegment.getDouble("GainAmount");
    		
    		//********************************
    		//int pAtt03 = loan.getAttributeIntValue("STerm") - loan.getAttributeIntValue("LastTerm")-1;  //当前期次-1-最近一次变化期次
    		//算法有问题，后续修复
    		int pAtt03 =1;
    		if(gainCyc>0){
    			pAtt03 = rptSegment.getInt("CurrentPeriod")-(rptSegment.getInt("CurrentPeriod")/gainCyc)*gainCyc;  //当前期次-1-最近一次变化期次
    		}
    			
    		//********************************
    		int iCTerm = totalPeriod+pAtt03;
    		double dN3 = 0d;
    		double dN4 = 0d;
    		double dN5 = 0d;
    		double dN6 = 0d;
    		if(installInterestRate <= 0.0d)
    		{
    			double n;
				if(gainCyc > 0)
					n = Math.ceil((totalPeriod-rptSegment.getInt("CurrentPeriod")-pAtt03)/(gainCyc*1.0));
				else
				{
					n=totalPeriod-rptSegment.getInt("CurrentPeriod");
					gainCyc=1;
					gainAmount = 0;
				}
    			instalmentAmount = (outstandingBalance*2/n-(n-1)*gainAmount*gainCyc)/2.0/gainCyc;
    		}
    		else
    		{
	    		if(iCTerm-gainCyc <= 0){
	    	    	dN3 = outstandingBalance*java.lang.Math.pow((1+installInterestRate),totalPeriod)+gainAmount*
	    	    		getFV(installInterestRate,totalPeriod);
	    	    	dN4 = 0d;
	    	    	dN5 = 1d;
	    	    	dN6 = 0d;
	    	    	instalmentAmount = (dN3-dN4/dN5)/(dN6+getFV(installInterestRate,totalPeriod))-gainAmount;
	    		}else{
	    			dN3 = outstandingBalance*java.lang.Math.pow((1+installInterestRate),gainCyc-pAtt03)+
	    				gainAmount*getFV(installInterestRate,gainCyc-pAtt03);
	        		dN4 = gainAmount*(java.lang.Math.pow((1+installInterestRate),iCTerm-gainCyc)-
	        			(iCTerm-gainCyc)*
	        			(java.lang.Math.pow((1+installInterestRate),gainCyc)-1d)/gainCyc-1);
	        		dN5 = (java.lang.Math.pow((1+installInterestRate),gainCyc)-1d)*installInterestRate*
	        			java.lang.Math.pow((1+installInterestRate),iCTerm-gainCyc);
	        		dN6 = (java.lang.Math.pow((1+installInterestRate),iCTerm-gainCyc)-1d)/
	        			(installInterestRate*java.lang.Math.pow((1+installInterestRate),iCTerm-gainCyc));
	        		instalmentAmount = (dN3-dN4/dN5)/(dN6+getFV(installInterestRate,gainCyc-pAtt03))-gainAmount;
	    		}
    		}
    		
    		if(instalmentAmount<0d) instalmentAmount=0d;
        	return Arith.round(instalmentAmount,2);
    	}
    	else{//否则直接返回原来的结果
    		return getFactMAmt(rptSegment);
    	}
	}
	
	private double getFV(double rate,int periods){
		return (Math.pow((1d+rate), periods)-1d)/rate;
	}
		
	private double getFactMAmt(BusinessObject rptSegment) throws Exception {
		int m = 0;
		double dComp = 0d;
		double mAmt = 0d;
		
		int gainCyc = rptSegment.getInt("GainCyc");
		double gainAmount = rptSegment.getDouble("GainAmount");
		if(gainAmount != 0 && gainCyc != 0){
			//当前期次是递变期次的整数倍时，判断是否对月供增加递变幅度
			dComp = rptSegment.getInt("CurrentPeriod")%gainCyc;
			if(dComp == 0 && rptSegment.getInt("CurrentPeriod") != 0) m = 1;
			else m = 0;
		}
		//等额递增(减)还款法
		mAmt = rptSegment.getDouble("SegInstalmentAmt") + gainAmount * m;
		
		if(mAmt<0d) mAmt = 0d;
		return Arith.round(mAmt,2);
	}
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
		String interestType = rptSegment.getString("InterestType");
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//偿还周期
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);//得到正常利率
		
		double installInterestRate = 0.0d;
		if(rateList == null || rateList.isEmpty())
			installInterestRate = 0.d;
		else if(ACCOUNT_CONSTANTS.InterestType_Daily.equals(interestType)){//按日计息
			BusinessObject rateTerm = rateList.get(0);
			int inteDays=DateFunctions.getDays(rptSegment.getString("LASTDUEDATE"), rptSegment.getString("NEXTDUEDATE"));
			installInterestRate = InterestFunctions.getDailyRate(1.0d,inteDays,rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"));//日利率
		}else
		{
			BusinessObject rateTerm = rateList.get(0);
			installInterestRate =  InterestFunctions.getInstalmentRate(outstandingBalance,
					rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), paymentFrequencyType);
		}
		
    	double instalmentAmt = this.getInstalmentAmount(loan,rptSegment);
    	return instalmentAmt- installInterestRate ;
	}

}
