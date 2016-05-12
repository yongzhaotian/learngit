package com.amarsoft.app.accounting.rpt.pmt;


import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.rpt.RPTFunctions;

/**
 * �����ڹ���������
 */
public abstract class BasicPMTScript implements IPMTScript {
	
	public void nextInstalment(BusinessObject loan,BusinessObject rptSegment) throws Exception{
		//�����¹�
		String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
		if(updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){
			int totalPeriod = RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
			rptSegment.setAttributeValue("TotalPeriod", totalPeriod);
			rptSegment.setAttributeValue("SegInstalmentAmt",getInstalmentAmount(loan,rptSegment));
			rptSegment.setAttributeValue("UpdateInstalAmtFlag", "0");
		}
		
		//����ʣ�໹���
		double rptbalance = rptSegment.getDouble("SEGRPTBalance");
		double instalmentPrincipalAmtTemp=getPrincipalAmount(loan,rptSegment);
		if(rptbalance>=instalmentPrincipalAmtTemp){
			rptbalance-=instalmentPrincipalAmtTemp;
		}
		else rptbalance=0d;
		rptSegment.setAttributeValue("SEGRPTBalance", rptbalance);
		
		//�����´λ�����
		String nextDueDate = rptSegment.getString("NextDueDate");//�´λ�������
		rptSegment.setAttributeValue("LastDueDate", nextDueDate);
		rptSegment.setAttributeValue("NextDueDate", RPTFunctions.getDueDateScript(loan, rptSegment).getNextPayDate(loan, rptSegment));
		//���µ�ǰ�ڴ�
		rptSegment.setAttributeValue("CurrentPeriod",rptSegment.getInt("CurrentPeriod")+1);
	}
	
	public String getInstalmentAmountType(BusinessObject loan,BusinessObject rptSegment)
			throws LoanException, Exception {
		String termID=loan.getString("RPTTermID");
		String pmtType = ProductConfig.getTermParameterAttribute(termID, "PMTType", "DefaultValue");
		return pmtType;
	}
	
}
