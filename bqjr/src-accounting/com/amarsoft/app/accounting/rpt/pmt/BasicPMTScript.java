package com.amarsoft.app.accounting.rpt.pmt;


import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.rpt.RPTFunctions;

/**
 * 基础期供计算引擎
 */
public abstract class BasicPMTScript implements IPMTScript {
	
	public void nextInstalment(BusinessObject loan,BusinessObject rptSegment) throws Exception{
		//重算月供
		String updateInstalAmtFlag=rptSegment.getString("UpdateInstalAmtFlag");
		if(updateInstalAmtFlag!=null&&updateInstalAmtFlag.equals("1")){
			int totalPeriod = RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
			rptSegment.setAttributeValue("TotalPeriod", totalPeriod);
			rptSegment.setAttributeValue("SegInstalmentAmt",getInstalmentAmount(loan,rptSegment));
			rptSegment.setAttributeValue("UpdateInstalAmtFlag", "0");
		}
		
		//更新剩余还款额
		double rptbalance = rptSegment.getDouble("SEGRPTBalance");
		double instalmentPrincipalAmtTemp=getPrincipalAmount(loan,rptSegment);
		if(rptbalance>=instalmentPrincipalAmtTemp){
			rptbalance-=instalmentPrincipalAmtTemp;
		}
		else rptbalance=0d;
		rptSegment.setAttributeValue("SEGRPTBalance", rptbalance);
		
		//更新下次还款日
		String nextDueDate = rptSegment.getString("NextDueDate");//下次还款日期
		rptSegment.setAttributeValue("LastDueDate", nextDueDate);
		rptSegment.setAttributeValue("NextDueDate", RPTFunctions.getDueDateScript(loan, rptSegment).getNextPayDate(loan, rptSegment));
		//更新当前期次
		rptSegment.setAttributeValue("CurrentPeriod",rptSegment.getInt("CurrentPeriod")+1);
	}
	
	public String getInstalmentAmountType(BusinessObject loan,BusinessObject rptSegment)
			throws LoanException, Exception {
		String termID=loan.getString("RPTTermID");
		String pmtType = ProductConfig.getTermParameterAttribute(termID, "PMTType", "DefaultValue");
		return pmtType;
	}
	
}
