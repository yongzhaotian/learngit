package com.amarsoft.proj.action;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GetMonthPayment {
	
	private String typeNo;//产品编号
	private double rate;//利率
	private double term;//期数
	private double financeAmount;//贷款金额
	private double finalPaymentSum;//尾款金额
	private double finalPaymentRate;//尾款比例
	
	public String getTypeNo() {
		return typeNo;
	}
	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}
	public double getRate() {
		return rate;
	}
	public void setRate(double rate) {
		this.rate = rate;
	}
	public double getTerm() {
		return term;
	}
	public void setTerm(double term) {
		this.term = term;
	}
	public double getFinanceAmount() {
		return financeAmount;
	}
	public void setFinanceAmount(double financeAmount) {
		this.financeAmount = financeAmount;
	}
	public double getFinalPaymentSum() {
		return finalPaymentSum;
	}
	public void setFinalPaymentSum(double finalPaymentSum) {
		this.finalPaymentSum = finalPaymentSum;
	}
	public double getFinalPaymentRate() {
		return finalPaymentRate;
	}
	public void setFinalPaymentRate(double finalPaymentRate) {
		this.finalPaymentRate = finalPaymentRate;
	}	
	
	

	//计算月还款金额  用于汽车金融
	public String getMonthPayment(Transaction Sqlca) throws Exception{
		//定义变量
		String sMonthPayment = "";//月还款金额
		String sReturnValues = "";//返回值
		//获取产品参数的“月供计算方式”
		String monthcalculationMethod = "";//月供计算方式： 
		//select termid,termname from PRODUCT_TERM_LIBRARY Where termid in('RPT17','RPT18','RPT19','RPT21','RPT22') and TermType = 'RPT' and ObjectType='Term' and SetFlag in ('SET','BAS')
		/*	RPT17	等额本息
			RPT18	尾款不计息
			RPT19	尾款计息
			RPT21	尾款不计息【合并还】
			RPT22	尾款计息【合并还】*/
	/*1.1.1.1.4.2.1尾款不计息
		注释：A+尾款=贷款金额
		A按照（贷款期限-1）等额本息的方式计算月供，最后一期月供=尾款
		1.1.1.1.4.2.2尾款计息
		注释：A+尾款=贷款金额
		（贷款期限-1）的月供=A按照（贷款期限-1），贷款利率等额本息的方式计算月供+尾款×月利率，最后一期月供=尾款+尾款×月利率
		月利率=尾款固定利率/12
		1.1.1.1.4.2.3尾款不计息【合并还】
		注释：A+尾款=贷款金额
		A按照（贷款期限）等额本息的方式计算月供，最后一期月供=A月供+尾款
		1.1.1.1.4.2.4尾款法（尾款计息）【合并还】
		注释：A+尾款=贷款金额
		（贷款期限）的月供=A按照（贷款期限）等额本息的方式计算月供+尾款×月利率，最后一期月供= A月供+尾款+尾款×月利率
		月利率=尾款固定利率/12
		*/
		String sSql = "select monthcalculationMethod from Business_Type where TypeNo = :TypeNo";
		monthcalculationMethod  = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo", typeNo));
		if(monthcalculationMethod==null)	{
			return "UnSuccess";
		}else{
			if(monthcalculationMethod.equals("RPT17")){
				sMonthPayment = DataConvert.toMoney(PMT(rate,term,financeAmount));	
				sReturnValues =  sMonthPayment;
			}else if(monthcalculationMethod.equals("RPT18")){
				sMonthPayment = DataConvert.toMoney(PMT(rate-1,term,financeAmount-finalPaymentSum));		
				sReturnValues =  "前"+DataConvert.toString(rate-1)+"期每期还款金额为人民币"+sMonthPayment+"元，最后一期还款金额为人民币"+DataConvert.toMoney(finalPaymentSum)+"元。";
			}else if(monthcalculationMethod.equals("RPT19")){				
				sMonthPayment = DataConvert.toMoney(PMT(rate-1,term,financeAmount-finalPaymentSum)+finalPaymentSum*(finalPaymentRate/12));		
				sReturnValues =  "前"+DataConvert.toString(rate-1)+"期每期还款金额为人民币"+sMonthPayment+"元，最后一期还款金额为人民币"+DataConvert.toMoney(finalPaymentSum+finalPaymentSum*finalPaymentRate/12)+"元。";
			}else if(monthcalculationMethod.equals("RPT21")){				
				sMonthPayment = DataConvert.toMoney(PMT(rate,term,financeAmount-finalPaymentSum));		
				sReturnValues =  "前"+DataConvert.toString(rate-1)+"期每期还款金额为人民币"+sMonthPayment+"元，最后一期还款金额为人民币"+DataConvert.toMoney(finalPaymentSum+PMT(rate,term,financeAmount-finalPaymentSum))+"元。";
			}else if(monthcalculationMethod.equals("RPT22")){				
				sMonthPayment = DataConvert.toMoney(PMT(rate,term,financeAmount-finalPaymentSum)+finalPaymentSum*(finalPaymentRate/12));		
				sReturnValues =  "前"+DataConvert.toString(rate-1)+"期每期还款金额为人民币"+sMonthPayment+"元，最后一期还款金额为人民币"+DataConvert.toMoney(finalPaymentSum+finalPaymentSum*finalPaymentRate/12+PMT(rate,term,financeAmount-finalPaymentSum)+finalPaymentSum*(finalPaymentRate/12))+"元。";
			}			
		}
		return sReturnValues;
	}
	
	/**
	 
	* 计算月供
	 
	* @param rate 年利率 年利率除以12就是月利率
	 
	* @param term 贷款期数，单位月
	 
	* @param financeAmount  贷款金额
	 
	* @return
	 
	*/
	 
	private double PMT(double rate,double term,double financeAmount)
	 
	{
	 
	    double v = (1+(rate/12)); 
	 
	    double t = (-(term/12)*12); 
	 
	    double result=(financeAmount*(rate/12))/(1-Math.pow(v,t));
	 
	    return result;
	 
	}


}
