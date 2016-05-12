package com.amarsoft.app.accounting.util.Financial;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.PaymentFrequencyConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

/**
 * 内部收益率 为投资的回收利率，其中包含定期支付（负值）和定期收入（正值）
 * @author jshen
 *
 */
public class PMT {
	
	/**
	 * 贷款期限＝LOG（每期还款本息额/（每期还款本息额－贷款总金额*利率））/LOG（1＋利率）
	 * @param instalmentAmount 每期还款本息额
	 * @param loanAmount 贷款总金额
	 * @param instalmentInterestRate 贷款周期利率
	 * @return 贷款期限
	 */
	public static int getLoanPeriod(double instalmentAmount, double loanAmount,double instalmentInterestRate) {
		double value = Arith.round(Math.log10(
				instalmentAmount/(instalmentAmount-loanAmount*instalmentInterestRate))/Math.log10(1+instalmentInterestRate),2);
		int cterm = (int)Math.ceil(value);
		return cterm;
	}
	
	
	public static double getLoanInstallmentAmount(double loanAmount, int loanPeriod,double instalmentInterestRate) {
		double instalmentAmount= Arith.round(
				loanAmount * instalmentInterestRate * (1 + 1 / (java.lang.Math.pow(1 + instalmentInterestRate,loanPeriod) - 1)),2);
		return instalmentAmount;
	}
	
	/**
	 *  根据利率、贷款期限、月供得到贷款的总金额，仅限于等额本息
	 * @param instalmentAmount月供
	 * @param instalmentInterestRate	贷款周期利率
	 * @param loanPeriod 贷款总期次
	 * @return 贷款总金额
	 */
	public double getLoanAmount(double instalmentAmount,double instalmentInterestRate, int loanPeriod) {
		return  Arith.round(
				instalmentAmount/(instalmentInterestRate+instalmentInterestRate /(java.lang.Math.pow(1+instalmentInterestRate,loanPeriod)-1)),2);
	}
	
	/**
	 * 判断等比、等额的递变额是否过大
	 * @param instalmentAmt
	 * @param corp
	 * @param rateUnit
	 * @param rate
	 * @param yearDays
	 * @param paymentFrequencyID
	 * @return
	 * @throws Exception
	 */
	public static boolean getCoin(double instalmentAmt,double corp,String rateUnit,double rate,
			int yearDays,String paymentFrequencyID) throws Exception {
		ASValuePool paymentFrequency=(ASValuePool) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(paymentFrequencyID);

		double instalmentRate=0;
		if(paymentFrequency.getString("TermUnit").equals(DateFunctions.TERM_UNIT_YEAR)){//还款周期单位为年
			instalmentRate = InterestFunctions.getDailyRate(corp,(yearDays*paymentFrequency.getInt("Term")),yearDays, rateUnit, rate);
		}
		else if(paymentFrequency.getString("TermUnit").equals(DateFunctions.TERM_UNIT_MONTH)){//还款周期单位为月
			instalmentRate =InterestFunctions.getMonthlyRate(corp,paymentFrequency.getInt("Term"),yearDays, rateUnit, rate);
		}
		else if(paymentFrequency.getString("TermUnit").equals(DateFunctions.TERM_UNIT_DAY)){//还款周期单位为日
			instalmentRate = InterestFunctions.getDailyRate(corp,paymentFrequency.getInt("Term"),yearDays, rateUnit, rate);
		}
		else{
			throw new LoanException("还款频率"+paymentFrequency.getString("Name")+"定义的期限单位不正确！");
		}
		double interest = instalmentRate;
		if(instalmentAmt < Arith.round(interest,2)) return false;
		else return true;
	}
	
}
