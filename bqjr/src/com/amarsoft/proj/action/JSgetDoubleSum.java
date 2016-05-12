package com.amarsoft.proj.action;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;

/**
 * 该类主要用于解决JS计算double的精度问题
 * @author jli5
 *
 */
public class JSgetDoubleSum {
	private String attribute1 = "";
	private String attribute2 = "";
	private String attribute3 = "";
	private String attribute4 = "";
	private String attribute5 = "";
	private String attribute6 = "";
	private String attribute7 = "";
	private String attribute8 = "";
	
	
	/**
	 * 汇总催收金额
	 * @param Sqlca
	 * @return
	 */
	public String getDunSum(Transaction Sqlca){
		double dSumDefaultPrincipal = Double.valueOf(attribute1);
		double dSumDefaultInterest = Double.valueOf(attribute2);
		double dSumPenaltyInterest = Double.valueOf(attribute3);
		double dSumCompoundInterest = Double.valueOf(attribute4);
		double dElseFee = Double.valueOf(attribute5);
		double dErate = Double.valueOf(attribute6);
		
		double dDunSum = 0;
        dDunSum = Arith.add(Arith.add(Arith.add(Arith.add(dSumDefaultPrincipal, dSumDefaultInterest),dSumPenaltyInterest),dSumCompoundInterest),dElseFee);		
        
        dDunSum =  Arith.mul(dDunSum, dErate);
		ARE.getLog().debug("计算后的金额"+dDunSum);
		return DataConvert.toMoney(dDunSum);
	}
	/**
	 * 计算贴现比例总和
	 * @param Sqlca
	 * @return
	 */
	public String getDiscountRateSum(Transaction Sqlca){
		
		double rate1= Double.valueOf(attribute1);
		double rate2= Double.valueOf(attribute2);
		double rateSum = Arith.add(rate1,rate2);
		if(rateSum==100){
			return "true";
		}else{
			return "false";
		}		
	}
	
	/**
	 * 计算汽车总价
	 * @param Sqlca
	 * @return
	 */
	public String countCarTotal(Transaction Sqlca){
		
		double part1= Double.valueOf(attribute1);
		double part2= Double.valueOf(attribute2);
		double part3= Double.valueOf(attribute3);
		double part4= Double.valueOf(attribute4);
		double part5= Double.valueOf(attribute5);
		double Sum = Arith.add(part1, Arith.add(part2, Arith.add(part3, Arith.add(part4,part5))));
		
		
		return DataConvert.toMoney(Sum);
			
	}
	/**
	 * 计算拨款总额
	 * @param Sqlca
	 * @return
	 */
	public String countAppropriation(Transaction Sqlca){
		
		double part1= Double.valueOf(attribute1);
		double part2= Double.valueOf(attribute2);
		double part3= Double.valueOf(attribute3);
		double part4= Double.valueOf(attribute4);
		double part5= Double.valueOf(attribute5);
		double part6= Double.valueOf(attribute6);
		double Sum = Arith.sub(Arith.add(part1, Arith.add(part2, Arith.add(part3, Arith.add(part4,part5)))),part6);
			
		return DataConvert.toMoney(Sum);
			
	}
	
	
	/**
	 * 计算汽车总价
	 * @param Sqlca
	 * @return
	 */
	public String sumCarTotal(Transaction Sqlca){
		
		double part1= Double.valueOf(attribute1);
		double part2= Double.valueOf(attribute2);
		double part3= Double.valueOf(attribute3);
		double part4= Double.valueOf(attribute4);
		double part5= Double.valueOf(attribute5);
		double part6= Double.valueOf(attribute6);
		double Sum = Arith.add(Arith.add(part1, Arith.add(part2, Arith.add(part3, Arith.add(part4,part5)))),part6);
		
		
		return DataConvert.toMoney(Sum);
			
	}
	
	
	/**
	 * 计算每月费用
	 * @param Sqlca
	 * @return
	 */
	public String countMonthCost(Transaction Sqlca){
		
		double part1= Double.valueOf(attribute1);
		double part2= Double.valueOf(attribute2);

		double Sum = Arith.div(part1, part2);
		
		
		return DataConvert.toMoney(Sum);
			
	}
	
	/**
	 * 计算还款比例/还款金额
	 * @param Sqlca
	 * @return
	 */
	public String countPayment(Transaction Sqlca){
		
		double paymentRate= Double.valueOf(attribute1);
		double CarTotal= Double.valueOf(attribute2);

		double businessRate = Arith.sub(100, paymentRate);
		String sBusinessRate	=	DataConvert.toString(businessRate);
		String paymentSum = DataConvert.toString(Arith.div(Arith.mul(CarTotal, paymentRate), 100));
		String businessSum =  DataConvert.toString(Arith.div(Arith.mul(CarTotal, businessRate), 100));
		
		return paymentSum+"@"+sBusinessRate+"@"+businessSum;
			
	}
	/**
	 * 计算尾款金额
	 * @param Sqlca
	 * @return
	 */
	public String FinalPaymentSum(Transaction Sqlca){
		
		double part1= Double.valueOf(attribute1);
		double part2= Double.valueOf(attribute2);

		double Sum = Arith.div(Arith.mul(part1, part2),100);
		
		
		return DataConvert.toMoney(Sum);
			
	}
	
	/**
	 * 计算贷款年利率
	 * @param Sqlca
	 * @return
	 */
	public String CountCreditApr(Transaction Sqlca){
		
		double part1= Double.valueOf(attribute1);
		double part2= Double.valueOf(attribute2);
		double Sum = 0.0D;
		if(attribute3.equals("0")){
			Sum = Arith.mul(part1, Arith.add(1, part2));
		}
		if(attribute3.equals("1")){
			Sum = Arith.add(part1, part2);
		}

		return DataConvert.toString(Sum);
			
	}
	public String getAttribute1() {
		return attribute1;
	}

	public void setAttribute1(String attribute1) {
		this.attribute1 = attribute1;
	}

	public String getAttribute2() {
		return attribute2;
	}

	public void setAttribute2(String attribute2) {
		this.attribute2 = attribute2;
	}

	public String getAttribute3() {
		return attribute3;
	}

	public void setAttribute3(String attribute3) {
		this.attribute3 = attribute3;
	}

	public String getAttribute4() {
		return attribute4;
	}

	public void setAttribute4(String attribute4) {
		this.attribute4 = attribute4;
	}

	public String getAttribute5() {
		return attribute5;
	}

	public void setAttribute5(String attribute5) {
		this.attribute5 = attribute5;
	}

	public String getAttribute6() {
		return attribute6;
	}

	public void setAttribute6(String attribute6) {
		this.attribute6 = attribute6;
	}

	public String getAttribute7() {
		return attribute7;
	}

	public void setAttribute7(String attribute7) {
		this.attribute7 = attribute7;
	}

	public String getAttribute8() {
		return attribute8;
	}

	public void setAttribute8(String attribute8) {
		this.attribute8 = attribute8;
	}
	
}
