package com.amarsoft.app.accounting.interest.accrue;

import java.util.ArrayList;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

public class InterestAccrueFunctions {
	
	public static IInterestAccrue getAccureInterestScript(String interestType) throws Exception{
		String classname=RateConfig.getInterestConfig(interestType, "AccrueInterestScript");
		if(classname!=null && !"".equals(classname)){
			Class<?> c = Class.forName(classname);
			IInterestAccrue scriptClass=((IInterestAccrue)c.newInstance());
			return scriptClass;
		}
		else return new CommonInterestAccrue();
	}
	
 	public static double getAccrueInterest(double baseAmount,BusinessObject rateSegment,BusinessObject loan,String payDate,String nextPayDate,String beginDate,String endDate) throws Exception{
		double interest=0d;
		String rateSegmentBeginDate=rateSegment.getString("SegFromDate");
		if(rateSegmentBeginDate!=null&&rateSegmentBeginDate.length()>0&&rateSegmentBeginDate.compareTo(beginDate)>0){
			beginDate=rateSegmentBeginDate;
		}
		String rateSegmentEndDate=rateSegment.getString("SegToDate");
		if(rateSegmentEndDate!=null&&rateSegmentEndDate.length()>0&&rateSegmentEndDate.compareTo(endDate)<0){
			endDate=rateSegmentEndDate;
		}
		if(beginDate.compareTo(endDate)>0) return 0d;
		String interestType = "";
		String oddInterestType = "";
		//修改原来根据利率表获取计息方式，使用还款方式区段表取值
		ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(rptList==null||rptList.isEmpty()) throw new Exception("贷款未定义还款方式，请确认！");
		if(rptList!=null&&!rptList.isEmpty()){			
			for (BusinessObject rptSegment:rptList){
				if(rptSegment.getString("SegToDate") !=null&&rptSegment.getString("SegToDate").length()>0 && rptSegment.getString("SegToDate").compareTo(loan.getString("BusinessDate"))<=0 )
					continue;
				interestType = rptSegment.getString("InterestType");
				oddInterestType = rptSegment.getString("OddInterestType");
			}
		}
		
		if(interestType==null || "".equals(interestType)) interestType = rateSegment.getString("InterestType");
		if(oddInterestType==null || "".equals(oddInterestType)) oddInterestType = rateSegment.getString("OddInterestType");
		
		String compdInterestFlag = rateSegment.getString("CompdInterestFlag");//计复利标示
		if(compdInterestFlag==null||compdInterestFlag.length()==0) compdInterestFlag="2";//默认不计复利
		
		
		String nextMonthDate = DateFunctions.getRelativeDate(beginDate,DateFunctions.TERM_UNIT_MONTH,1);
		if(payDate.substring(8,10).compareTo(nextMonthDate.substring(8,10))>0){
			nextMonthDate=nextMonthDate.substring(0,8)+payDate.substring(8,10);
			if(nextMonthDate.compareTo(DateFunctions.getEndDateOfMonth(nextMonthDate))>0)
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);
		}
		
		//判断计息周期是否满月
		boolean isFullMonth = false;
		if(nextPayDate.compareTo(nextMonthDate) >=0){
			if(nextMonthDate.equals(nextPayDate))
				isFullMonth = true;
			if(DateFunctions.monthEnd(nextPayDate) && DateFunctions.monthEnd(beginDate))
				isFullMonth = true;
		}
		
		if(DateFunctions.monthEnd(beginDate)){//如果起始日和结束日都是月末
			if(DateFunctions.monthEnd(endDate))
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);
			else if(DateFunctions.monthEnd(nextPayDate))
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);//结息日都是月末的情况，如6月30和7月31
			else if(nextMonthDate.startsWith(endDate.substring(0, 8))&&nextMonthDate.compareTo(endDate)<0){
				//如果是同一个月，而且结束日大于计算出的下月日期，则取EndDate
				nextMonthDate=endDate;
			}
		}

		int yearDays = rateSegment.getInt("YearDays");

		if(nextMonthDate.compareTo(endDate)>=0){//一个整月或不足一个月
			//匹配利率分段信息，计算每个利率段的实际天数
			String validBeginDate=rateSegment.getString("SegFromDate");
			if(validBeginDate == null || validBeginDate.length()==0 || validBeginDate.compareTo(beginDate) < 0)
				validBeginDate = beginDate;
			String validEndDate=rateSegment.getString("SegToDate");
			if(validEndDate == null || validEndDate.length()==0 || validEndDate.compareTo(endDate) > 0)
				validEndDate = endDate;
			if(validBeginDate.compareTo(validEndDate) > 0) throw new LoanException("计算利息起始日【"+validBeginDate+"】大于到期日【"+validEndDate+"】，请检查数据！");
			
			//计算利息
			int inteDays=DateFunctions.getDays(validBeginDate, validEndDate);
			if(interestType.equals(ACCOUNT_CONSTANTS.InterestType_Daily)){//按日计息
				double dailyRate = InterestFunctions.getDailyRate(baseAmount,inteDays,yearDays, rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));//日利率
				
				interest+=dailyRate;
			}
			else if(interestType.equals(ACCOUNT_CONSTANTS.InterestType_Monthly)){//按月计息
				
				double monthDays = DateFunctions.getDays(beginDate, nextMonthDate);//当月天数
				
				String t= DateFunctions.getRelativeDate(validBeginDate,DateFunctions.TERM_UNIT_MONTH,1);
				
				/************************
				 * 按如果贷款计息区间内没有利率变更，且为按月计息，而且下次结息日为对日，则按比例分摊
				 */
				
				if(DateFunctions.monthEnd(validBeginDate) && DateFunctions.monthEnd(nextPayDate))
					t = DateFunctions.getEndDateOfMonth(t);
				if(validBeginDate.equals(beginDate)&&validEndDate.equals(endDate)
						&&nextPayDate.equals(t)){
					oddInterestType=ACCOUNT_CONSTANTS.Odd_InterestType_Daily;
				}
				
				/************************
				 * 如果为整月，则按比例分摊
				 */
				if(isFullMonth){
					oddInterestType=ACCOUNT_CONSTANTS.Odd_InterestType_Daily;
				}
				
				if(t.compareTo(validEndDate)<=0){//整月，考虑两种情况:2-28至3-28、29、30、31都为一个整月
					interest+=InterestFunctions.getMonthlyRate(baseAmount,1.0d,yearDays, rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));//月利率
				}
				else if(ACCOUNT_CONSTANTS.Odd_InterestType_Percent.equals(oddInterestType)){//零头天按比例计息
					double monthlyRate = InterestFunctions.getMonthlyRate(baseAmount,inteDays/monthDays,yearDays,rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));
					interest+=monthlyRate;//比例分摊
				}
				else if(ACCOUNT_CONSTANTS.Odd_InterestType_Daily.equals(oddInterestType)){//零头天按天计息
					double dailyRate = InterestFunctions.getDailyRate(baseAmount,inteDays,yearDays, rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));//日利率
					interest+=dailyRate;
				}
				else throw new Exception("找不到对应的零头天计息方式{"+oddInterestType+"}！");			
			}
			else throw new Exception("找不到对应的计息方式{"+interestType+"}！");
		}
		else{//递归调用

			double monthInterest = InterestAccrueFunctions.getAccrueInterest(baseAmount,rateSegment, loan, payDate,nextMonthDate,beginDate,nextMonthDate);
			/*if(compdInterestFlag.equals("1")){
				interest+=monthInterest+(1+monthInterest)*InterestFunctions.getInterest(rateSegment, nextMonthDate,endDate, rateLogList);
			}
			else*/
			interest+=monthInterest+InterestAccrueFunctions.getAccrueInterest(baseAmount,rateSegment, loan, payDate,nextPayDate,nextMonthDate,endDate);
		}
		return interest;
	}
}
