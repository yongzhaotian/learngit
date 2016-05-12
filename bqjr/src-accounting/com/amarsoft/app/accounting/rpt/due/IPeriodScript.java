/**
 * 
 */
package com.amarsoft.app.accounting.rpt.due;

import com.amarsoft.app.accounting.businessobject.BusinessObject;

/**
 * @author yegang
 * 期供计算引擎
 */
public interface IPeriodScript {

	public int getTotalPeriod(BusinessObject loan,BusinessObject rptSegment) throws Exception;

}
