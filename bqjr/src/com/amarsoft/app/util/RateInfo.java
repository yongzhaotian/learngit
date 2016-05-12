package com.amarsoft.app.util;

public class RateInfo {
	
	private String RateType;//基准利率类型
	private String Currency;//币种
	private String EfficientDate;//生效日期
	private String TermUnit;//期限单位
	private int Term;//期限值
	private double Rate;//利率值

	
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
	public String getEfficientDate() {
		return EfficientDate;
	}
	public void setEfficientDate(String efficientDate) {
		EfficientDate = efficientDate;
	}
	public String getTermUnit() {
		return TermUnit;
	}
	public void setTermUnit(String termUnit) {
		TermUnit = termUnit;
	}
	public int getTerm() {
		return Term;
	}
	public void setTerm(int term) {
		Term = term;
	}
	public double getRate() {
		return Rate;
	}
	public void setRate(double rate) {
		Rate = rate;
	}
}
