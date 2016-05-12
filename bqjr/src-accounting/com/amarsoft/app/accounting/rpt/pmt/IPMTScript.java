/**
 * 
 */
package com.amarsoft.app.accounting.rpt.pmt;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;

/**
 * @author yegang
 * 期供计算引擎
 */
public interface IPMTScript {
	
	
	public double getInstalmentAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception;
	
	public void nextInstalment(BusinessObject loan,BusinessObject rptSegment) throws Exception;
	
	
	public double getPrincipalAmount(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception;
	
}
