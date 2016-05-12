/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;

/**
 * 灵活等额本息
 * @author yegang
 */
public class PMTScript5 extends BasicPMTScript {
	
	public double getInstalmentAmount(BusinessObject loan_T,BusinessObject rptSegment) throws LoanException, Exception {
		BusinessObject loan =loan_T.cloneObject();
		double installmentAmt = rptSegment.getMoney("SegInstalmentAmt");
		
		String updateInstalAmtFlag=loan.getString("UpdateInstalAmtFlag");
    	if(updateInstalAmtFlag==null||updateInstalAmtFlag.length()==0||!updateInstalAmtFlag.equals("1")){
    		updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
    	}
    	String updatePSFlag=loan.getString("UpdatePMTSchdFlag");//微贷如果重算还款计划，则强制重算期供
		if(updatePSFlag!=null&&updatePSFlag.equals("1")){
			updateInstalAmtFlag="1";
		}
    	if(installmentAmt>0d&&(updateInstalAmtFlag==null||updateInstalAmtFlag.length()==0||!updateInstalAmtFlag.equals("1"))) 
    		return installmentAmt;
		
		List<BusinessObject> paymentScheduleList = PaymentScheduleFunctions.getFuturePaymentScheduleList(loan, "1");
		double principalBalance_O = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal
				,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		if(principalBalance_O<=0d) return 0d;
		
		
		double installmentAmt_Max=principalBalance_O;
		double installmentAmt_Min=0.01;
		int j=0;
		while(j++<1000){
			double principalBalance=principalBalance_O;
			installmentAmt = Arith.round((installmentAmt_Max+installmentAmt_Min)/2,2);
	    	String lastDueDate = LoanFunctions.getLastDueDate(loan);
	    	
	    	for(BusinessObject ps:paymentScheduleList){
	    		String payDate = ps.getString("PayDate");
	    		//计算利息
	    		double installmentInterestRate=RateFunctions.getInterestRate(loan, lastDueDate, lastDueDate, payDate,ACCOUNT_CONSTANTS.RateType_Normal);
	    		double interestAmount = Arith.round(
	    				Math.floor(principalBalance*installmentInterestRate*100)/100.0,2);
	    		/*double interestAmount = Arith.round(
	    				principalBalance*installmentInterestRate,2);*/
				ps.setAttributeValue("PayInteAmt", interestAmount);
				
				//计算本金
				double principalAmount=0d;
	    		double fixInstallmentAmt=ps.getMoney("FixInstallmentAmt");
	    		if(fixInstallmentAmt<0d){
	    			continue;
	    		}
	    		else if(fixInstallmentAmt>0d){
	    			principalAmount=fixInstallmentAmt-interestAmount;
	    		}
	    		else{//如果未指定还款金额，则判断是否指定了还本金额
	    			double fixPrincipalAmt=ps.getMoney("FixPrincipalAmt");
		    		if(fixPrincipalAmt==0d){
	    				principalAmount=Arith.round(installmentAmt-interestAmount,2);
	    			}
		    		else{
		    			principalAmount=fixPrincipalAmt;	
		    		}
	    		}
	    		
	    		ps.setAttributeValue("PayPrincipalAmt", principalAmount);
	    		if(principalAmount<0d)principalAmount=0d;
	    		principalBalance = Arith.round(principalBalance-principalAmount,2);

				lastDueDate = payDate;
	    	}
	    	
	    	if(Math.abs(principalBalance)<0.01*(paymentScheduleList.size()-1)){
	    		ARE.getLog().debug(principalBalance);
	    		break;
	    	}
	    	else if(principalBalance<0d){
	    		installmentAmt_Max = installmentAmt;
	    	}
	    	else {
	    		installmentAmt_Min = installmentAmt;
	    	}
	    	
		}
		return Arith.round(installmentAmt,2);
	}
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		return 0d;
	}

}
