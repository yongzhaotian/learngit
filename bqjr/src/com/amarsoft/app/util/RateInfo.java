package com.amarsoft.app.util;

public class RateInfo {
	
	private String RateType;//��׼��������
	private String Currency;//����
	private String EfficientDate;//��Ч����
	private String TermUnit;//���޵�λ
	private int Term;//����ֵ
	private double Rate;//����ֵ

	
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
