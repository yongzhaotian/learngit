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
 * �ȱȵݱ�
 * @author yegang
 */
public class PMTScript4 extends BasicPMTScript {
	
	public double getInstalmentAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		int totalPeriod=rptSegment.getInt("TotalPeriod");
		String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
    	double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
    	if(instalmentAmt<=0d||updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){//�����Ҫ���£������¼���
    		
    		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
    		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);//�õ���������
    		double installInterestRate = 0.0d;
    		if(rateList == null || rateList.isEmpty())//������������Ĭ��Ϊ��
    		{
    			installInterestRate = 0.0d;
    		}
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
			//int pAtt03 = loan.getAttributeIntValue("STerm") - loan.getAttributeIntValue("LastTerm")-1;  //��ǰ�ڴ�-1-���һ�α仯�ڴ�
			//�㷨�����⣬�����޸�
			int pAtt03 =1;
			if(gainCyc>0)
				pAtt03 = rptSegment.getInt("CurrentPeriod")-(rptSegment.getInt("CurrentPeriod")/gainCyc)*gainCyc;  //��ǰ�ڴ�-1-���һ�α仯�ڴ�
			//********************************
			
			
			int iCTerm = totalPeriod+pAtt03;
			double dN3 = 0d;
			double dN4 = 0d;	
			
			if(installInterestRate<=0.0d)
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
				if(Math.abs(gainAmount) < 0.0000001)
				{
					instalmentAmount = outstandingBalance/n;
				}
				else
				{
					instalmentAmount = outstandingBalance*(1-(1.0+gainAmount/100.0d))/(1-Math.pow((1.0+gainAmount/100.0d), n))/gainCyc;
				}
			}
			else
			{
			
				if(iCTerm-gainCyc <= 0){
					dN3 = java.lang.Math.pow((1d+installInterestRate),totalPeriod);
					dN4 = getFV(installInterestRate,totalPeriod)/(1+gainAmount/100d);
				}else{
					dN3 = java.lang.Math.pow((1d+installInterestRate),gainCyc-pAtt03);
			    	dN4 = 1d/getBaseAmt(1d,installInterestRate,iCTerm-gainCyc,gainAmount,
			    			gainCyc) + 
			    			getFV(installInterestRate,gainCyc-pAtt03)/(1d+gainAmount/100d);
				}
				instalmentAmount = (outstandingBalance)*dN3/dN4/(1d+gainAmount/100d);
			}
			if(instalmentAmount<0d) instalmentAmount=0d;
			return Arith.round(instalmentAmount,2);
    	}
    	else{//����ֱ�ӷ���ԭ���Ľ��
    		return getFactMAmt(rptSegment);
    	}
	}
	
	private double getFV(double rate,int periods){
		return (Math.pow((1d+rate), periods)-1d)/rate;
	}
	
	/**
	 * ���ܣ��ȶ�ȱȵĻ�׼��ʽ 
	 * pCorp    		���
	 * pRate       		��������
	 * pTTerm      		������
	 * pReturnType 		���ʽ  5 �ȶ����(��)  6 �ȱȵ���(��)
	 * pAdj 			�ȶ��������������仯��Ȼ��ߵȱȵ�������������仯����
	 * pFV  			�ȶ����(��)/�ȱȵ���(��)���仯Ƶ��
	 */
	private static double getBaseAmt(double dCorp,double dRate,int iCTerm,
			double dAdj,double dFV) throws Exception {
		double dMonthPay = 0d;
		double dN0 = 0d;
		double dN3 = 0d;
		double dN4 = 0d;
		
		dN0 = java.lang.Math.pow(1d + dRate,iCTerm);
    	dN4 = java.lang.Math.pow(1d + dRate,dFV);
    	dN3 = dCorp * dRate * dN0 * (dN4 - (1d + dAdj / 100d));
		dMonthPay = dN3 / ((dN4 - 1d) * (dN0 - java.lang.Math.pow(1d + dAdj / 100d,iCTerm / dFV)));
		
		return dMonthPay;
	}
	
	/**
	 * ��ʵ�¹�
	 */
	private double getFactMAmt(BusinessObject rptSegment) throws Exception {
		int m = 0;
		double dComp = 0d;
		double mAmt = 0d;
		
		int gainCyc = rptSegment.getInt("GainCyc");
		double gainAmount = rptSegment.getDouble("GainAmount");
		if(gainAmount != 0 && gainCyc != 0){
			//��ǰ�ڴ��ǵݱ��ڴε�������ʱ���ж��Ƿ���¹����ӵݱ����
			dComp = (rptSegment.getInt("CurrentPeriod"))%gainCyc;
			if(dComp == 0 && rptSegment.getInt("CurrentPeriod") != 0) m = 1;
			else m = 0;
		}
		mAmt = rptSegment.getDouble("SegInstalmentAmt") * java.lang.Math.pow(1 + gainAmount / 100d ,m);
		
		if(mAmt<0d) mAmt = 0d;
		return Arith.round(mAmt,2);
	}
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
		String interestType = rptSegment.getString("InterestType");
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);//�õ���������
		
		double installInterestRate = 0.0d;
		if(rateList == null || rateList.isEmpty())
			installInterestRate = 0.d;
		else if(ACCOUNT_CONSTANTS.InterestType_Daily.equals(interestType)){//���ռ�Ϣ
			BusinessObject rateTerm = rateList.get(0);
			int inteDays=DateFunctions.getDays(rptSegment.getString("LASTDUEDATE"), rptSegment.getString("NEXTDUEDATE"));
			installInterestRate = InterestFunctions.getDailyRate(1.0d,inteDays,rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"));//������
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
