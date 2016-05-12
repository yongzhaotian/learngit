package com.amarsoft.app.accounting.rpt.due;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
//重写期次计算脚本，用于气球贷尾款不合并
public class MergePeriodScript extends CommonPeriodScript{

	public int getTotalPeriod(BusinessObject loan,BusinessObject rptSegment) throws Exception {
		int totalperiod = super.getTotalPeriod(loan, rptSegment);
		return totalperiod - 1;
	}
}