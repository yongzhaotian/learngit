package com.amarsoft.app.accounting.rpt.due;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.PaymentFrequencyConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.exception.LoanException;

public class FixDueDateScript implements IDueDateScript{

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
		if("3".equals(paymentFrequencyType)){//一次还款
			return SegToDate;
		}
		
		if(!DateFunctions.TERM_UNIT_MONTH.equals(paymentFrequency.getString("TermUnit")))//对于按月的才有效
			throw new LoanException("此脚本仅适用于还款周期为整月的情况，请修改组件配置信息！");
		
		String defaultDueDay = rptSegment.getString("DefaultDueDay");//默认还款日
		if(defaultDueDay == null || "".equals(defaultDueDay) || "0".equals(defaultDueDay)) defaultDueDay = loanPutoutDate.substring(8);
		else if(defaultDueDay.length()==1) defaultDueDay="0"+defaultDueDay;
		
		String nextPayDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit"), paymentFrequency.getInt("Term"));
		
		//判断首期
		if(lastDueDate.equals(SegFromDate)){//首次还款日期，需要根据首次还款约定判断当月是否还款
			String firstInstalmentFlag=rptSegment.getString("FirstInstalmentFlag");//首期还款约定
			if(firstInstalmentFlag == null || "".equals(firstInstalmentFlag)) firstInstalmentFlag = loan.getString("FirstInstalmentFlag");//首期还款约定
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) {
				String productID = loan.getString("BusinessType");
				String productVersion = ProductConfig.getProductNewestVersionID(productID);
				firstInstalmentFlag = ProductConfig.getProductTermParameterAttribute(productID,productVersion, rptSegment.getString("RPTTermID"), "FirstInstalmentFlag", "DefaultValue");
			}
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) 
				firstInstalmentFlag="02";
			
			if(firstInstalmentFlag.equals("01")){//放款当月还款（固定周期） 按季 3、6、9、12 按半年 6、12 按双月 2、4、6、8、10、12
				if(Integer.valueOf(SegFromDate.substring(5, 7))%paymentFrequency.getInt("Term") == 0){//放款月+默认还款日小于放款日期 且 放款月+默认还款日大于月底的情况
					if((SegFromDate.substring(0,8) + defaultDueDay).compareTo(SegFromDate)<=0 
						|| DateFunctions.getEndDateOfMonth(SegFromDate.substring(0,8) + defaultDueDay).equals(SegFromDate)){
						nextPayDate = DateFunctions.getRelativeDate(SegFromDate,paymentFrequency.getString("TermUnit"),paymentFrequency.getInt("Term"));
						nextPayDate = (nextPayDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextPayDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay);
					}else{
						nextPayDate = (nextPayDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextPayDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay);
					}
				}
				else
				{
					nextPayDate = DateFunctions.getRelativeDate(SegFromDate,paymentFrequency.getString("TermUnit"),paymentFrequency.getInt("Term")-Integer.valueOf(SegFromDate.substring(5, 7))%paymentFrequency.getInt("Term"));
					nextPayDate = (nextPayDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextPayDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay);
				}
			}
			else if(firstInstalmentFlag.equals("02")){//放款当月不还款（固定周期） 按季 3、6、9、12 按半年 6、12 按双月 2、4、6、8、10、12
				if(Integer.valueOf(SegFromDate.substring(5, 7))%paymentFrequency.getInt("Term") == 0)
				{
					nextPayDate = DateFunctions.getRelativeDate(SegFromDate,paymentFrequency.getString("TermUnit"),paymentFrequency.getInt("Term"));
					nextPayDate = (nextPayDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextPayDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay);
				}
				else
				{
					nextPayDate = DateFunctions.getRelativeDate(SegFromDate,paymentFrequency.getString("TermUnit"),paymentFrequency.getInt("Term")-Integer.valueOf(SegFromDate.substring(5, 7))%paymentFrequency.getInt("Term"));
					nextPayDate = (nextPayDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextPayDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextPayDate.substring(0, 8)+defaultDueDay);
				}
			}
		}
		
		if(defaultDueDay.compareTo("28")>0){
			nextPayDate = nextPayDate.substring(0,8)+defaultDueDay;
			String tmp = DateFunctions.getEndDateOfMonth(nextPayDate);
			if(tmp.compareTo(nextPayDate)<0)nextPayDate=tmp;
		}
		if(defaultDueDay.length()>0){//超过月底则不用默认日
			if(Integer.parseInt(DateFunctions.getEndDateOfMonth(nextPayDate).substring(nextPayDate.length()-2))>Integer.parseInt(defaultDueDay)){
				nextPayDate=nextPayDate.substring(0,8)+defaultDueDay;
			}
			else{
				nextPayDate=DateFunctions.getEndDateOfMonth(nextPayDate);
			}
		}
		
		//判断末期日期
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
