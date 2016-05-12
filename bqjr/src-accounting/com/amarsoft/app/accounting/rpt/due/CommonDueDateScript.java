package com.amarsoft.app.accounting.rpt.due;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.PaymentFrequencyConfig;

public class CommonDueDateScript implements IDueDateScript{

	public String getNextPayDate(BusinessObject loan, BusinessObject rptSegment)
			throws Exception {
		String SegFromDate = rptSegment.getString("SegFromDate");
		String SegToDate = rptSegment.getString("SegToDate");
		
		String loanMaturityDate = loan.getString("MaturityDate");
		String loanPutoutDate = loan.getString("PutoutDate");
		if(SegToDate==null||SegToDate.length()==0) SegToDate = loanMaturityDate;
		if(SegFromDate==null||SegFromDate.length()==0) SegFromDate = loanPutoutDate;
		String lastDueDate = rptSegment.getString("LastDueDate");
		if(lastDueDate==null||lastDueDate.length()==0) lastDueDate = SegFromDate;
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//偿还周期
		BusinessObject paymentFrequency = (BusinessObject) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(paymentFrequencyType);
		
		String nextPayDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit"), paymentFrequency.getInt("Term"));
		if("3".equals(paymentFrequencyType)){//一次还款
			return SegToDate;
		}
		
		//处理超过28号还款日的情况,双周供的不做处理，只有月的才处理
		if(!paymentFrequency.getString("TermUnit").equals(DateFunctions.TERM_UNIT_DAY)){
			String defaultDueDay = rptSegment.getString("DefaultDueday");
			if(defaultDueDay == null) defaultDueDay = "";
			String putoutDate = loan.getString("PutOutDate");
			if("".equals(defaultDueDay)||"0".equals(defaultDueDay)) defaultDueDay=putoutDate.substring(8, 10);
			else if(defaultDueDay.length()<2) defaultDueDay="0"+defaultDueDay;
			if(defaultDueDay.compareTo("28")>0){
				nextPayDate = nextPayDate.substring(0,8)+defaultDueDay;
				String tmp = DateFunctions.getEndDateOfMonth(nextPayDate);
				if(tmp.compareTo(nextPayDate)<0)nextPayDate=tmp;
			}
			if(defaultDueDay.length()>0){
				if(defaultDueDay.length() == 1) 
					defaultDueDay = "0"+defaultDueDay;
				//超过月底则不用默认日
				if(Integer.parseInt(DateFunctions.getEndDateOfMonth(nextPayDate).substring(nextPayDate.length()-2))>Integer.parseInt(defaultDueDay)){
					nextPayDate=nextPayDate.substring(0,8)+defaultDueDay;
				}
				else{
					nextPayDate=DateFunctions.getEndDateOfMonth(nextPayDate);
				}
			}
			
			String sFirstDueDate = rptSegment.getString("FirstDueDate");
			String sNextDueDate = rptSegment.getString("NextDueDate");
			if(sFirstDueDate != null && sNextDueDate == null) nextPayDate = sFirstDueDate;
			
		}
		String finalInstalmentFlag=loan.getString("FinalInstalmentFlag");//末期还款标识
		if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
			finalInstalmentFlag=rptSegment.getString("FinalInstalmentFlag");
		}
		if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
			finalInstalmentFlag="01";
		}
		if(finalInstalmentFlag.equals("01")){//贷款到期日
			if(nextPayDate.compareTo(SegToDate)>=0){//下次还款日超过贷款到期日，则以贷款到期日为准
				nextPayDate = SegToDate;
			}
			else {
				String t = DateFunctions.getRelativeDate(nextPayDate, paymentFrequency.getString("TermUnit"), paymentFrequency.getInt("Term"));
				if (t.compareTo(SegToDate)>0&&nextPayDate.substring(0, 7).equals(SegToDate.substring(0, 7))){
					//说明剩余期限不足一期，而且是下次还款日与到期日为同一个月，则合并
					nextPayDate= SegToDate;
				}
			}
		}
		else if(finalInstalmentFlag.equals("02")){//不足一期算作一期的时候，则无需特殊处理
			if(nextPayDate.compareTo(SegToDate)>=0){//下次还款日超过贷款到期日，则以贷款到期日为准
				nextPayDate = SegToDate;
			}
		}
		else if(finalInstalmentFlag.equals("03")){//根据最后一期自动判断
			
		}
		else {
			throw new Exception("贷款{"+loan.getObjectNo()+"}的末期还款标识{FinalInstalmentFlag}未定义！");
		}
		return nextPayDate;
	}

	public List<String> getPayDateList(BusinessObject loan,
			BusinessObject rptSegment_T) throws Exception {
		BusinessObject rptSegment=rptSegment_T.cloneObject();
		ArrayList<String> payDateList=new ArrayList<String>();
		
		String segFromDate = rptSegment.getString("SegFromDate");
		String segToDate = rptSegment.getString("SegToDate");
		
		String loanMaturityDate = loan.getString("MaturityDate");
		String loanPutoutDate = loan.getString("PutoutDate");
		if(segToDate==null||segToDate.length()==0) segToDate = loanMaturityDate;
		if(segFromDate==null||segFromDate.length()==0) segFromDate = loanPutoutDate;
		
		while(true){
			String payDate=this.getNextPayDate(loan, rptSegment);
			rptSegment.setAttributeValue("LastDueDate", payDate);;
			if(payDate.compareTo(segToDate)>=0){
				payDateList.add(payDate);
				break;
			}
			else{
				payDateList.add(payDate);
			}
		}
		return payDateList;
	}
}
