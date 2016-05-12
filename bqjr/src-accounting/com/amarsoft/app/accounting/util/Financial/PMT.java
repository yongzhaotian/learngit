package com.amarsoft.app.accounting.util.Financial;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.PaymentFrequencyConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

/**
 * �ڲ������� ΪͶ�ʵĻ������ʣ����а�������֧������ֵ���Ͷ������루��ֵ��
 * @author jshen
 *
 */
public class PMT {
	
	/**
	 * �������ޣ�LOG��ÿ�ڻ��Ϣ��/��ÿ�ڻ��Ϣ������ܽ��*���ʣ���/LOG��1�����ʣ�
	 * @param instalmentAmount ÿ�ڻ��Ϣ��
	 * @param loanAmount �����ܽ��
	 * @param instalmentInterestRate ������������
	 * @return ��������
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
	 *  �������ʡ��������ޡ��¹��õ�������ܽ������ڵȶϢ
	 * @param instalmentAmount�¹�
	 * @param instalmentInterestRate	������������
	 * @param loanPeriod �������ڴ�
	 * @return �����ܽ��
	 */
	public double getLoanAmount(double instalmentAmount,double instalmentInterestRate, int loanPeriod) {
		return  Arith.round(
				instalmentAmount/(instalmentInterestRate+instalmentInterestRate /(java.lang.Math.pow(1+instalmentInterestRate,loanPeriod)-1)),2);
	}
	
	/**
	 * �жϵȱȡ��ȶ�ĵݱ���Ƿ����
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
		if(paymentFrequency.getString("TermUnit").equals(DateFunctions.TERM_UNIT_YEAR)){//�������ڵ�λΪ��
			instalmentRate = InterestFunctions.getDailyRate(corp,(yearDays*paymentFrequency.getInt("Term")),yearDays, rateUnit, rate);
		}
		else if(paymentFrequency.getString("TermUnit").equals(DateFunctions.TERM_UNIT_MONTH)){//�������ڵ�λΪ��
			instalmentRate =InterestFunctions.getMonthlyRate(corp,paymentFrequency.getInt("Term"),yearDays, rateUnit, rate);
		}
		else if(paymentFrequency.getString("TermUnit").equals(DateFunctions.TERM_UNIT_DAY)){//�������ڵ�λΪ��
			instalmentRate = InterestFunctions.getDailyRate(corp,paymentFrequency.getInt("Term"),yearDays, rateUnit, rate);
		}
		else{
			throw new LoanException("����Ƶ��"+paymentFrequency.getString("Name")+"��������޵�λ����ȷ��");
		}
		double interest = instalmentRate;
		if(instalmentAmt < Arith.round(interest,2)) return false;
		else return true;
	}
	
}
