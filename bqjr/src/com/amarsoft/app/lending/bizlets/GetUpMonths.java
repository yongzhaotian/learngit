package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.RateConfig;

public class GetUpMonths extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		String putoutDate = (String)this.getAttribute("putOutDate");System.out.println("putoutDate:"+putoutDate);
		String maturityDate = (String)this.getAttribute("maturityDate");System.out.println("maturityDate:"+maturityDate);

		if(putoutDate == null)
		{
			putoutDate = "";
		}
		if(maturityDate == null)
		{
			maturityDate = "";
		}

		return String.valueOf(DateFunctions.getUpMonths(putoutDate, maturityDate));
	}	
}
