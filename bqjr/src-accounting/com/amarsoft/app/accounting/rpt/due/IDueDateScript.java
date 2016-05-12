/**
 * 
 */
package com.amarsoft.app.accounting.rpt.due;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;

/**
 * @author yegang
 * �ڹ���������
 */
public interface IDueDateScript {

	public String getNextPayDate(BusinessObject loan,BusinessObject rptSegment) throws Exception;

	public List<String> getPayDateList(BusinessObject loan,BusinessObject rptSegment) throws Exception;
	
}
