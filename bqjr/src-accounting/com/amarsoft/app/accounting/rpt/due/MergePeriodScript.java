package com.amarsoft.app.accounting.rpt.due;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
//��д�ڴμ���ű������������β��ϲ�
public class MergePeriodScript extends CommonPeriodScript{

	public int getTotalPeriod(BusinessObject loan,BusinessObject rptSegment) throws Exception {
		int totalperiod = super.getTotalPeriod(loan, rptSegment);
		return totalperiod - 1;
	}
}