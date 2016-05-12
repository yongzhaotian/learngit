package com.amarsoft.app.accounting.interest.accrue;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;

public interface IInterestAccrue {
	public void accrueInterest(BusinessObject loan,BusinessObject interestObject,String accrueDate,String interestType,AbstractBusinessObjectManager boManager) throws Exception;
}
