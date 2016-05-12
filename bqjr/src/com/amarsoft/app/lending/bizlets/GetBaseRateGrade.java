package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.accounting.config.loader.RateConfig;

public class GetBaseRateGrade extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		String currency = (String)this.getAttribute("currency");
		String baseRateType = (String)this.getAttribute("baseRateType");System.out.println("baseRateType:"+baseRateType);
		String termUnit = (String)this.getAttribute("termUnit");System.out.println("termUnit:"+termUnit);
		int termMonth = Integer.parseInt((String)this.getAttribute("termMonth"));System.out.println("termMonth:"+termMonth);
		String today = (String)this.getAttribute("today");
		
		if(currency == null)
		{
			currency = "";
		}
		if(baseRateType == null)
		{
			baseRateType = "";
		}
		if(termUnit == null)
		{
			termUnit = "";
		}
		if((String)this.getAttribute("termMonth") == null || ((String)this.getAttribute("termMonth")).length() == 0)
		{
			termMonth = -1;
		}
		if(today == null)
		{
			today = "";
		}
		
		return RateConfig.getBaseRateGrade(currency, baseRateType, termUnit, termMonth, today);
	}	
}
