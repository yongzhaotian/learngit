/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.are.util.Arith;

/**
 * ����˫�ܹ����ȱ���
 * @author yegang
 */
public class PMTScript7 extends BasicPMTScript {
	
	public double getInstalmentAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
    	double instalmentAmt = rptSegment.getDouble("SegInstalmentAmt");
    	int totalPeriod=rptSegment.getInt("TotalPeriod");
    	if(instalmentAmt<=0d||updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){//�����Ҫ���£������¼���
    		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
    		rptSegment.setAttributeValue("PaymentFrequencyType", "1");//����
    		totalPeriod =  RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
    		rptSegment.setAttributeValue("PaymentFrequencyType", paymentFrequencyType);//��ԭ����
    		//���㱾�׶���Ҫ�����ı�����
    		double outstandingBalance= RPTFunctions.getOutStandingBalance(loan, rptSegment);
    		if(totalPeriod ==0) return 0.0d;
        	double instalmentAmount = outstandingBalance /totalPeriod;
        	return Arith.round(instalmentAmount/2d,2);
    	}
    	else{//����ֱ�ӷ���ԭ���Ľ��
    		return instalmentAmt;
    	}
	}
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception {
		return this.getInstalmentAmount(loan,rptSegment);
	}

}
