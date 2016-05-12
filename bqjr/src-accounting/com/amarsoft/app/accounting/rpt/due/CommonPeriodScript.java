package com.amarsoft.app.accounting.rpt.due;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.PaymentFrequencyConfig;

public class CommonPeriodScript implements IPeriodScript{

	public int getTotalPeriod(BusinessObject loan,BusinessObject rptSegment) throws Exception {
		String SegFromDate = rptSegment.getString("SegFromDate");
		String SegToDate = rptSegment.getString("SegToDate");
		
		String loanMaturityDate = loan.getString("MaturityDate");
		String loanPutoutDate = loan.getString("PutoutDate");
		if(SegToDate == null || SegToDate.length() == 0) SegToDate = loanMaturityDate;
		if(SegFromDate == null || SegFromDate.length() == 0) SegFromDate = loanPutoutDate;
		
		String endDate = null;
		String segTermFlag=rptSegment.getString("SegTermFlag");//区段期限标志  1-贷款期限 2-区段期限 3-指定期限
		if(segTermFlag==null||segTermFlag.length()==0) segTermFlag="1";
		if(segTermFlag.equals("1")){//贷款期限
			endDate = loanMaturityDate;
		}
		else if(segTermFlag.equals("2")){//区段期限
			endDate = SegToDate;
		}
		else if(segTermFlag.equals("3")){//指定期限
			int segTerm=rptSegment.getInt("SegTerm");//指定区段期限
			String segTermUnit=rptSegment.getString("SegTermUnit");//指定区段期限单位，默认为月M
			endDate = DateFunctions.getRelativeDate(SegFromDate, segTermUnit, segTerm);
			if(endDate != null && endDate.compareTo(SegToDate) > 0)
				endDate = SegToDate;
		}
		else throw new Exception("贷款{"+loan.getObjectNo()+"}的还款属性SegTermFlag未定义！");
		
		String lastDueDate = rptSegment.getString("LastDueDate");
		if(lastDueDate==null||lastDueDate.length()==0||lastDueDate.compareTo(SegFromDate)<0)
			lastDueDate=SegFromDate;
		
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//偿还周期
		BusinessObject paymentFrequency = (BusinessObject) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(paymentFrequencyType);
		int term = paymentFrequency.getInt("Term");
		if(term<=0) return 1;
		else {
			if(lastDueDate.equals(endDate))
				return 1;
			else{
				int totalPeriod = 0;
				String defaultDueDay = rptSegment.getString("DefaultDueDay");//默认还款日
				if(defaultDueDay == null || "".equals(defaultDueDay) || "0".equals(defaultDueDay)) 
					defaultDueDay = loanPutoutDate.substring(8);
				else if(defaultDueDay.length() == 1) 
					defaultDueDay = "0" + defaultDueDay;
				String firstInstalmentFlag = loan.getString("FirstInstalmentFlag"); //首期还款标识
				/*if(firstInstalmentFlag.equals("01")) {
					if(defaultDueDay.compareTo(lastDueDate.substring(8)) > 0 && 
							!DateFunctions.getEndDateOfMonth(lastDueDate).substring(8).equals(lastDueDate.substring(8)))
					{
						lastDueDate = lastDueDate.substring(0,8) + defaultDueDay;
						if(lastDueDate.compareTo(DateFunctions.getEndDateOfMonth(lastDueDate.substring(0,8)+"01")) > 0)
							lastDueDate = DateFunctions.getEndDateOfMonth(lastDueDate.substring(0,8)+"01");
						totalPeriod = 1;
					}
					else if(defaultDueDay.compareTo(lastDueDate.substring(8)) < 0)
					{
						lastDueDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit"), term).substring(0,8) + defaultDueDay;
						if(lastDueDate.compareTo(DateFunctions.getEndDateOfMonth(lastDueDate.substring(0,8)+"01")) > 0)
							lastDueDate = DateFunctions.getEndDateOfMonth(lastDueDate.substring(0,8)+"01");
						totalPeriod = 1;
					}
				}
				if(firstInstalmentFlag.equals("02") && !defaultDueDay.equals(lastDueDate.substring(8))) {
					lastDueDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit"), term).substring(0,8) + defaultDueDay;
					if(lastDueDate.compareTo(DateFunctions.getEndDateOfMonth(lastDueDate.substring(0,8)+"01")) > 0)
						lastDueDate = DateFunctions.getEndDateOfMonth(lastDueDate.substring(0,8)+"01");
					totalPeriod = 1;
				}*/
				
				if(lastDueDate.compareTo(endDate) >= 0)
					return totalPeriod;
				int totalPeriod1 = DateFunctions.getTermPeriod(lastDueDate,endDate,paymentFrequency.getString("TermUnit"), term);//向下取整
				String finalDueDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit")
						, totalPeriod1*term);
				totalPeriod = totalPeriod1 + totalPeriod;
				String finalInstalmentFlag=loan.getString("FinalInstalmentFlag");//末期还款标识
				if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
					finalInstalmentFlag=rptSegment.getString("FinalInstalmentFlag");
				}
				
				if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
					finalInstalmentFlag="01";
				}
				if(finalInstalmentFlag.equals("01")){//贷款到期日
					return totalPeriod;
				}
				else if(finalInstalmentFlag.equals("02")){//不足一期算作一期的时候，则无需特殊处理
					if(finalDueDate.compareTo(SegToDate)>=0)
						return totalPeriod;
					else
						return totalPeriod+1;
				}
				else if(finalInstalmentFlag.equals("03")){//根据最后一期自动判断
					return totalPeriod;
				}
				else {
					throw new Exception("贷款{"+loan.getObjectNo()+"}的末期还款标识{FinalInstalmentFlag}未定义！");
				}
			}
				
		}
	}
}
