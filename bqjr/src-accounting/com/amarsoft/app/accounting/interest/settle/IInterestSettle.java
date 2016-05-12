package com.amarsoft.app.accounting.interest.settle;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;

public interface IInterestSettle {
	public List<BusinessObject> settleInterest(BusinessObject loan,BusinessObject interestObject,String settleDate,String interestType,AbstractBusinessObjectManager bomanager) throws Exception;
}
