/**
 * 
 */
package com.amarsoft.app.accounting.rpt.due;

import com.amarsoft.app.accounting.businessobject.BusinessObject;

/**
 * @author yegang
 * �ڹ���������
 */
public interface IPeriodScript {

	public int getTotalPeriod(BusinessObject loan,BusinessObject rptSegment) throws Exception;

}
