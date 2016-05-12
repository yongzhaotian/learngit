package com.amarsoft.app.util;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.util.RateFunctions;

public class CalcBaseRate {
	
	private String TermDay;
	private String RateType;
	private String Currency;
	private String FromDate;
	private String ToDate;
	private String RateUnit;

	public String getTermDay() {
		return TermDay;
	}

	public void setTermDay(String termDay) {
		TermDay = termDay;
	}

	public String getRateType() {
		return RateType;
	}

	public void setRateType(String rateType) {
		RateType = rateType;
	}
	
	public String getCurrency() {
		return Currency;
	}

	public void setCurrency(String currency) {
		Currency = currency;
	}
	
	public String getFromDate() {
		return FromDate;
	}

	public void setFromDate(String fromDate) {
		FromDate = fromDate;
	}

	public String getRateUnit() {
		return RateUnit;
	}

	public void setRateUnit(String rateUnit) {
		RateUnit = rateUnit;
	}

	public String getToDate() {
		return ToDate;
	}

	public void setToDate(String toDate) {
		ToDate = toDate;
	}

	public String getBaseRate() throws Exception
	{
		if(RateUnit == null || "".equals(RateUnit)) RateUnit = "01";
		String svalue="";
		try{
			if(FromDate == null || "".equals(FromDate) || ToDate == null || "".equals(ToDate))
				svalue=String.valueOf(getBaseRate(Currency,RateType,RateUnit,Integer.parseInt(this.TermDay)));
			else
				svalue=String.valueOf(RateConfig.getBaseRate(Currency,RateFunctions.getBaseDays(Currency),RateType, RateUnit, FromDate,ToDate,SystemConfig.getBusinessDate()));
		}catch(Exception e)
		{
			e.printStackTrace();
			svalue="-9999";
		} 
		return svalue;
	}
	
	public static double getBaseRate(String Currency,String RateType,String RateUnit,int TermDay) throws Exception
	{
		double dRate = 0.0;
		if(TermDay <= 0 ) throw new Exception("期限天数必须大于零！");
		
		dRate = RateConfig.getBaseRate(Currency,RateFunctions.getBaseDays(Currency),RateType, RateUnit, DateFunctions.TERM_UNIT_DAY, TermDay, SystemConfig.getBusinessDate());
		
		return dRate;
	}
}
