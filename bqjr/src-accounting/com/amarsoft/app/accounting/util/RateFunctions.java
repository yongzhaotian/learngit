package com.amarsoft.app.accounting.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.are.util.Arith;

/**
 * @author yegang
 * 利息及利率相关函数
 *
 */
public class RateFunctions {
	
	public static double getInterestRate(BusinessObject loan,String payDate,String fromDate,String toDate,String rateType) throws Exception{
		double interestRate=0d;
		List<BusinessObject> rateSegmentList = InterestFunctions.getRateSegmentList(loan, rateType);//利率定义信息
		for(BusinessObject rateSegment : rateSegmentList){//当出现多个利率时，需要将利率加起来
			if(!"1".equals(rateSegment.getString("Status"))) continue;
			interestRate += InterestFunctions.getInterest(1, rateSegment,loan, payDate,fromDate, toDate);
		}
		return interestRate;
	}
	
	
	
	
	/**
	 * 计算日利率
	 * @param yearDays
	 * @param rateUnit
	 * @param rate
	 * @return
	 * @throws LoanException
	 */
	public static double getRate(int yearDays,String rateUnit,double rate,String newRateUnit) throws LoanException{
		if(rateUnit.equals(newRateUnit)) return rate;
		if(ACCOUNT_CONSTANTS.RateUnit_Year.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Month.equals(newRateUnit)){
			return rate/100/12*1000;//月利率，千分比
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Year.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Day.equals(newRateUnit)){
			return rate/100/yearDays*10000;//日利率，万分比
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Month.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Year.equals(newRateUnit)){
			return rate/1000*12*100;//年利率，百分比
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Month.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Day.equals(newRateUnit)){
			return rate/1000*12/yearDays*10000;//日利率，万分比
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Day.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Month.equals(newRateUnit)){
			return rate/10000*yearDays/12*1000;//月利率，千分比
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Day.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Year.equals(newRateUnit)){
			return rate/10000*yearDays*100;//年利率，百分比
		}
		else throw new LoanException("未传入正确的利率单位{RateUnit}!");
	}
	
	/**
	 * 根据币种的不同，返回不同的计息天数，英镑和港币是365，其他币种是360
	 * @throws Exception 
	 * 
	 */
	public static int getBaseDays(String Currency) throws Exception{
		int baseDays = 360;
		if("".equals(Currency) || Currency == null) throw new Exception("币种为空，请查证");
		if("02".equals(Currency) || "03".equals(Currency)) baseDays = 365;
		
		return baseDays;
	}
	
	/**
	 * 根据币种的不同，返回不同的计息天数，英镑和港币是365，其他币种是360
	 * @throws Exception 
	 * 
	 */
	public static int getBaseDays(BusinessObject loan) throws Exception{
		return getBaseDays(loan.getString("Currency"));
	}
		
	/**
	 * 通过利率调整方式等计算重定价日期
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public static String getNextRepriceDate(BusinessObject loan) throws Exception{
		String repriceType = loan.getString("RepriceType");
		String lastRepriceDate = loan.getString("LastRepriceDate");
		String putoutDate = loan.getString("PutoutDate");
		String sMaturityDate = loan.getString("MaturityDate");
		if(lastRepriceDate==null||lastRepriceDate.length()==0)lastRepriceDate=putoutDate;
		String nextRepriceDate="";

		String businessDate = loan.getString("BusinessDate");
		//立即调整 ——由于利率调整换日后执行，日期置为明日
		if("1".equals(repriceType)){
			nextRepriceDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
		//次年初
		}else if("2".equals(repriceType)){
			nextRepriceDate = DateFunctions.getRelativeDate(businessDate,DateFunctions.TERM_UNIT_YEAR,1).substring(0,4)+"/01/01";
		}
		//次年对月对日
		else if("3".equals(repriceType)){
			nextRepriceDate = DateFunctions.getRelativeDate(lastRepriceDate,DateFunctions.TERM_UNIT_YEAR,DateFunctions.getYears(lastRepriceDate, businessDate)+1);
			while(nextRepriceDate.compareTo(businessDate) <= 0)
				nextRepriceDate = DateFunctions.getRelativeDate(nextRepriceDate,DateFunctions.TERM_UNIT_YEAR,1);
		}
		//按月调
		else if("4".equals(repriceType)){
			//防止单月累加，大小月问题
			int iMonth = DateFunctions.getMonths(lastRepriceDate, businessDate);
			nextRepriceDate = DateFunctions.getRelativeDate(lastRepriceDate,DateFunctions.TERM_UNIT_MONTH,iMonth);
			while(nextRepriceDate.compareTo(businessDate) <= 0) 
				nextRepriceDate = DateFunctions.getRelativeDate(lastRepriceDate,DateFunctions.TERM_UNIT_MONTH,iMonth+1);
		}
		//下一还款日调整
		else if("5".equals(repriceType)){
			String maturityDate=loan.getString("MaturityDate");
			if(maturityDate.compareTo(businessDate)<0){//到期后立即调整
				nextRepriceDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
			}
			else
				nextRepriceDate = LoanFunctions.getNextDueDate(loan);
			if(nextRepriceDate.length()==0)
				nextRepriceDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
		}
		//次年首个还款日调整
		else if("6".equals(repriceType)){
			String nextYear = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_YEAR, 1).substring(0,5)+"01/01";
			ArrayList<BusinessObject> a = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			for(BusinessObject rpt:a){
				if(nextYear.compareTo(rpt.getString("PayDate")) <=0 ){
					nextRepriceDate = rpt.getString("PayDate");
					break;
				}
			}
			if("".equals(nextRepriceDate))nextRepriceDate =loan.getString("MaturityDate");
		}
		//手工指定调整日
		else if("8".equals(repriceType)){
			String firstRepriceDate = loan.getString("RepriceDate");//首次利率重定价日期	
			if("".equals(firstRepriceDate))	firstRepriceDate=loan.getString("LastRepriceDate");
			String fren = loan.getString("RepriceFlag");//重定价周期单位
			int cyc = loan.getInt("REPRICECYC");//重定价周期
			if("".equals(firstRepriceDate) || "".equals(fren) || cyc<=0) 
				throw new Exception("自定义调整周期的参数不全，请查证：首次重定价日期:"+firstRepriceDate+",重定价周期单位:"+fren+",重定价周期:"+cyc);
			//如果输入的首次调整日期比当前日期大则直接取值
			if(firstRepriceDate.compareTo(businessDate) >0) nextRepriceDate = firstRepriceDate;
			else{
				if( fren.equals(DateFunctions.TERM_UNIT_DAY)){
					int iDay = DateFunctions.getDays(firstRepriceDate, businessDate);
					nextRepriceDate = DateFunctions.getRelativeDate(firstRepriceDate,DateFunctions.TERM_UNIT_DAY,(iDay/cyc)*cyc);
					while(nextRepriceDate.compareTo(businessDate)<=0)
						nextRepriceDate = DateFunctions.getRelativeDate(firstRepriceDate,DateFunctions.TERM_UNIT_DAY,(iDay/cyc)*cyc +cyc);
				}else if(fren.equals(DateFunctions.TERM_UNIT_MONTH)){
					int month = DateFunctions.getMonths(firstRepriceDate, businessDate);
					nextRepriceDate = DateFunctions.getRelativeDate(firstRepriceDate,DateFunctions.TERM_UNIT_MONTH,(month/cyc)*cyc);
					//修复，如果是首次调整日期是月底就取月底
					/*if(DateFunctions.monthEnd(firstRepriceDate))
						nextRepriceDate = DateFunctions.getEndDateOfMonth(nextRepriceDate);*/
					while(nextRepriceDate.compareTo(businessDate)<=0)
						nextRepriceDate = DateFunctions.getRelativeDate(firstRepriceDate,DateFunctions.TERM_UNIT_MONTH,(month/cyc)*cyc + cyc);
				}else if(fren.equals(DateFunctions.TERM_UNIT_YEAR)){
					int year = DateFunctions.getYears(firstRepriceDate, businessDate);
					nextRepriceDate = DateFunctions.getRelativeDate(firstRepriceDate,DateFunctions.TERM_UNIT_YEAR,(year/cyc)*cyc);
					while(nextRepriceDate.compareTo(businessDate)<=0)
						nextRepriceDate = DateFunctions.getRelativeDate(firstRepriceDate,DateFunctions.TERM_UNIT_YEAR,(year/cyc)*cyc + cyc);
				}
			}
			
		}
		else
			nextRepriceDate = lastRepriceDate;
		
		//BEA到期后不再调整利息
		if(!nextRepriceDate.equals("") && nextRepriceDate.compareTo(sMaturityDate) >=0)
			nextRepriceDate = "";
		//不调整利率的贷款下次重定价日期赋值为空 
		if("7".equals(repriceType))	
			nextRepriceDate = "";
		
		return nextRepriceDate;
	}

	
	
	/**
	 * @param termSeg
	 * @return
	 * @throws AccountingException
	 * @throws Exception
	 * 计算基准利率
	 */
	public static double getBaseRate(BusinessObject loan,BusinessObject rateSegment) throws LoanException, Exception{
		double baseRate=0d;
		String baseRateType=rateSegment.getString("BaseRateType");
		if(baseRateType==null||baseRateType.equals("")) return 0d;
		if(baseRateType.equals("999")){//hhcf基准利率
			List<BusinessObject> a=InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal) ;//取贷款正常利率
			return a.get(0).getDouble("BaseRate");
		}
		if(baseRateType.equals("060") || ACCOUNT_CONSTANTS.RateMode_Fix.equals(rateSegment.getString("RateMode"))) return 0d;//EIR不存在基准利率
		if(baseRateType.equals("100")){//取贷款利率
			List<BusinessObject> a=InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal) ;//取贷款正常利率
			return a.get(0).getDouble("BusinessRate");
		}
		if(baseRateType.equals("030")){//取贴现利率
			List<BusinessObject> a=InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Discount) ;//取贷款贴现利率
			return a.get(0).getDouble("BusinessRate");
		}
		String rateUnit=rateSegment.getString("RateUnit");
		String putoutDate=loan.getString("PutoutDate");
		String MaturityDate=loan.getString("MaturityDate");
		String baseRateGrade = rateSegment.getString("BaseRateGrade");
		if(baseRateGrade == null || "".equals(baseRateGrade) || baseRateGrade.split("@").length <2)
		{
			baseRateGrade = RateConfig.getBaseRateGrade(loan.getString("Currency"), baseRateType, putoutDate, MaturityDate, loan.getString("BusinessDate"));
			rateSegment.setAttributeValue("BaseRateGrade", baseRateGrade);
		}
		
		int term = Integer.valueOf(baseRateGrade.split("@")[0]);
		String termUnit = baseRateGrade.split("@")[1];
		baseRate = RateConfig.getBaseRate(loan.getString("Currency"),rateSegment.getInt("YearDays"), baseRateType, rateUnit, termUnit, term,loan.getString("BusinessDate"));
		return baseRate;
	}
	
	/**
	 * @param termSeg
	 * @return
	 * @throws AccountingException
	 * @throws Exception
	 * 计算贷款利率
	 */
	public static double getBusinessRate(BusinessObject loan,BusinessObject rateSegment) throws Exception{		
		//如果是固定模式,则执行利率不变
		//String rateMode = rateSegment.getString("RateMode");
		String rateFloatType = rateSegment.getString("RateFloatType");
		double baseRate = rateSegment.getDouble("BaseRate");
		double rateFloat = rateSegment.getDouble("rateFloat");
		double businessRate = rateSegment.getDouble("BusinessRate");
		
		if(baseRate==0d){
			return businessRate;
		}
		else{
			if(ACCOUNT_CONSTANTS.RateFloatType_PRECISION.equals(rateFloatType)){
				businessRate = baseRate + baseRate*rateFloat*0.01 ;
			}
			//当利率浮动类型为基点时,执行利率 = 基准利率+浮动幅度
			else if(ACCOUNT_CONSTANTS.RateFloatType_POINTS.equals(rateFloatType)){
				businessRate = baseRate + rateFloat/100.0;
			}else{
				throw new Exception("利率计算所需参数[利率浮动类型]录入有误！");
			}
			if(businessRate<0d){
				throw new Exception("执行利率不能为负数{"+businessRate+"}！");
			}
			return Arith.round(businessRate,ACCOUNT_CONSTANTS.Number_Precision_Rate);
		}
	}
	
	
	
}
