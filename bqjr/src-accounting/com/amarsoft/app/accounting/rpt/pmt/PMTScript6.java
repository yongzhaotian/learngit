/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.are.util.Arith;

/**
 * ����˫�ܹ����ȶ
 * @author xjzhao
 */
public class PMTScript6 extends BasicPMTScript {
	
	/**
	 * ˫�ܹ��¹�����
	 * �����˫�ܹ������ڴΣ��¹����ǵȶϢ�¹���1/2
	 */
	public double getInstalmentAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		//�������ʵ���ʱ��Ҫ�ж����ڹ���ȡʲôģʽ
		String newPMTType=loan.getString("NewPMTType");
		if(newPMTType==null||newPMTType.length()==0){
			newPMTType=rptSegment.getString("NewPMTType");
		}
		if(newPMTType==null||newPMTType.length()==0){
			String rpttermID = loan.getString("RPTTermID");
			newPMTType=ProductConfig.getTermParameterAttribute(rpttermID, "NewPMTType", "DefaultValue");
		}
		if(newPMTType==null||newPMTType.length()==0){
			newPMTType="2";//Ĭ��ʹ�����ڹ�
		}
		
    	int totalPeriod=rptSegment.getInt("TotalPeriod");
    	String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
    	
    	double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
    	//�����Ҫ�����ڹ��������¼���
    	if(instalmentAmt<=0d||updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){
    		String lastDueDate = LoanFunctions.getLastDueDate(loan);
    		String nextDueDate = LoanFunctions.getNextDueDate(loan);
    		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
    		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal,lastDueDate,nextDueDate);
    		double installInterestRate = 0.0d;
    		double monthlyRate = 0.0d;
    		if(rateList == null || rateList.isEmpty()){//������������Ĭ��Ϊ��
    			installInterestRate = 0.0d;
    		}
    		else{
    			BusinessObject rateTerm = rateList.get(rateList.size()-1);
    			if(newPMTType.equals("2")){
    				rateTerm=rateList.get(rateList.size()-1);
    			}
    			//�������ʱ��ʱ����Ҫ�ж���μ����ڹ�
	    		installInterestRate = InterestFunctions.getInstalmentRate(1.0d,
	    				rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getRate("BusinessRate"), paymentFrequencyType);
	    		monthlyRate = InterestFunctions.getMonthlyRate(1.0d,1.0d,rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"));
    		}
    		//��������ڴ�
    		totalPeriod =  RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
    		//���㱾�׶���Ҫ�����ı�����
    		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
    		rptSegment.setAttributeValue("PaymentFrequencyType", "1");//����
    		int monthPeriod = RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan,rptSegment);
    		rptSegment.setAttributeValue("PaymentFrequencyType", paymentFrequencyType);//��ԭ
    		//�����ڴ�Ϊ��ʱ��˵����Ҫһ���Գ���
    		if(totalPeriod == 0){
    			instalmentAmt = outstandingBalance+outstandingBalance * installInterestRate;
    		}
    		else{
    			//���㹫ʽ
        		if(Math.abs(monthlyRate) < 0.000000001 )
        			instalmentAmt = outstandingBalance/monthPeriod;
        		else
        			instalmentAmt = outstandingBalance * monthlyRate * (1d + 1d / (java.lang.Math.pow(1d + monthlyRate,monthPeriod-DateFunctions.getDays(rptSegment.getString("SegFromDate"), lastDueDate)/28.0) - 1));
        		//�ȶϢ�㷨���¹���һ��
        		instalmentAmt = Arith.round(instalmentAmt/2d,2);
        		if(Math.abs(installInterestRate) < 0.000000001)
        		{
        			int cterm = (int)java.lang.Math.floor(outstandingBalance/instalmentAmt);
        			instalmentAmt = outstandingBalance/cterm;
        		}
        		else
        		{
    	    		int cterm = (int)java.lang.Math.floor(java.lang.Math.log10(instalmentAmt/
    					(instalmentAmt-outstandingBalance*installInterestRate))/java.lang.Math.log10(1+installInterestRate));
    			
    		    	instalmentAmt = outstandingBalance * installInterestRate * (1d + 1d / (java.lang.Math.pow(1d + installInterestRate,cterm) - 1));
        		}
    		}
        	return Arith.round(instalmentAmt,2);
    	}
    	else{//����ֱ�ӷ���ԭ���Ľ��
    		return instalmentAmt;
    	}
	}
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
		String interestType = rptSegment.getString("InterestType");
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);//�õ���������
		
		double installInterestRate = 0.0d;
		if(rateList == null || rateList.isEmpty()){//������������Ĭ��Ϊ��
			installInterestRate = 0.0d;
		}else if(ACCOUNT_CONSTANTS.InterestType_Daily.equals(interestType)){//���ռ�Ϣ
			BusinessObject rateTerm = rateList.get(0);
			int inteDays=DateFunctions.getDays(rptSegment.getString("LASTDUEDATE"), rptSegment.getString("NEXTDUEDATE"));
			installInterestRate = InterestFunctions.getDailyRate(1.0d,inteDays,rateTerm.getInt("YearDays"), rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"));//������
		}
		else{
			BusinessObject rateTerm = rateList.get(0);
			installInterestRate = InterestFunctions.getInstalmentRate(1.0d,rateTerm.getInt("YearDays"),
					 rateTerm.getString("RateUnit"), rateTerm.getDouble("BusinessRate"), paymentFrequencyType);
		}
		
    	double instalmentAmt = getInstalmentAmount(loan,rptSegment);
    	
    	if(instalmentAmt <= outstandingBalance * installInterestRate)
    		return Arith.round(outstandingBalance * installInterestRate,2);
    	else
    		return Arith.round(instalmentAmt-Arith.round(outstandingBalance * installInterestRate,2),2);
	}

}
