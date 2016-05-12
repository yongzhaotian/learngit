package com.amarsoft.app.accounting.rpt.ps;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;

public interface IPaymentScheduleScript {
	public List<BusinessObject> createPaymentScheduleList(BusinessObject loan,String toDate,AbstractBusinessObjectManager bom) throws Exception;
}
