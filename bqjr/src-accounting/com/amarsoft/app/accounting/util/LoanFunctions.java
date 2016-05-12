package com.amarsoft.app.accounting.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

public class LoanFunctions {
	
	
	/**
	 * 计算逾期天数，个人征信未使用，因此根据PaymentSchedule中的OverdueFlag判断即可
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public static int getOverDays(BusinessObject loan) throws Exception {
		//取未结清的还款计划
		List<BusinessObject> paymentschedules
					=PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		if(paymentschedules==null||paymentschedules.isEmpty())
			return 0;
		String businessDate=loan.getString("BusinessDate");
		String minPayDate=businessDate;
		for(BusinessObject paymentschedule:paymentschedules){
			String InteDate=paymentschedule.getString("InteDate");
			String payDate=paymentschedule.getString("PayDate");
			if(InteDate == null || "".equals(InteDate)) 
				InteDate = paymentschedule.getString("PayDate");
			if(InteDate.compareTo(businessDate) >= 0 || paymentschedule.getString("SettleDate") != null && !paymentschedule.getString("SettleDate").equals("") )continue;//非逾期的不算
			if(payDate.compareTo(minPayDate)<0){
				minPayDate=payDate;
			}
		}

		int overdueDays = DateFunctions.getDays(minPayDate,businessDate);
		if(overdueDays<0) overdueDays=0;
		return overdueDays;	
	}
	
	/**
	 * @param loan
	 * @return
	 * @throws AccountingException
	 * @throws Exception
	 * 获取正常还款计划对象（未还款中最小的一期）
	 */
	public static BusinessObject getNextPaymentSchedule(BusinessObject loan) throws LoanException, Exception{
		String businessDate=loan.getString("BusinessDate");
		ArrayList<BusinessObject> paymentScheduleList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		for(BusinessObject a:paymentScheduleList){
			String paydate=a.getString("PayDate");
			String payType=a.getString("PayType");
			String finishDate =a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0) continue;
			if(payType!=null&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)) continue;
			if(paydate.compareTo(businessDate)>0){//计算上次到期日
				return a;
			}
		}
		return null;
	}
	
	/**
	 * @param loan
	 * @return
	 * @throws AccountingException
	 * @throws Exception
	 * 取下次还款日
	 */
	public static String getNextDueDate(BusinessObject loan) throws LoanException, Exception{
		String nextDueDate="";
		ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(rptList == null || rptList.isEmpty()) return loan.getString("NextDueDate");
		for(BusinessObject a:rptList){
			String status = a.getString("Status");
			if(status==null||!status.equals("1")) continue;
			String nextDueDateTemp = a.getString("NextDueDate");
			if(a.getString("SegToDate") !=null&&a.getString("SegToDate").length()>0 && a.getString("SegToDate").compareTo(loan.getString("BusinessDate"))<=0 )
				continue;
			if(a.getString("SegFromDate") !=null&&a.getString("SegFromDate").length()>0 && a.getString("SegFromdate").compareTo(loan.getString("BusinessDate"))>0 )
				continue;
			
			if(nextDueDate==null||nextDueDate.length()==0)
				nextDueDate = nextDueDateTemp;
			if(nextDueDateTemp==null||nextDueDateTemp.length()==0||nextDueDateTemp.compareTo(loan.getString("BusinessDate"))<0)
				continue;
			if(nextDueDateTemp.compareTo(nextDueDate)<=0) nextDueDate=nextDueDateTemp;
		}

		if(nextDueDate==null||nextDueDate.length()==0||nextDueDate.compareTo(loan.getString("BusinessDate"))<0)
			return "";
		else return nextDueDate;
	}
	
	/**
	 * @param loan
	 * @return
	 * @throws AccountingException
	 * @throws Exception
	 * 取上次还款日
	 */
	public static String getLastDueDate(BusinessObject loan) throws LoanException, Exception{
		String lastDueDate="";
		ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		for(BusinessObject a:rptList){
			String status = a.getString("Status");
			if(status==null||!status.equals("1")) continue;
			
			if(a.getString("SegFromDate") != null && !a.getString("SegFromDate").equals("") && a.getString("SegFromDate").compareTo(loan.getString("BusinessDate"))>=0)
				continue;
			
			String lastDueDateTemp = a.getString("LastDueDate");
			if(lastDueDateTemp==null||lastDueDateTemp.length()==0)
				continue;
			if(lastDueDate==null||lastDueDate.length()==0)
				lastDueDate = lastDueDateTemp;
			
			if(lastDueDateTemp.compareTo(lastDueDate)>=0 && lastDueDateTemp.compareTo(loan.getString("BusinessDate"))<=0) 
				lastDueDate=lastDueDateTemp;
		}
		if(lastDueDate.equals("")) lastDueDate = loan.getString("LastDueDate");
		return lastDueDate;
	}

	
	/**
	 * @param termSeg
	 * @return
	 * @throws AccountingException
	 * @throws Exception
	 * 计算贷款还款区段的首次应还款日，放款时调用
	 */
	/*public static void setFirstDueDate(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception{
		//贷款信息
		String putoutDate = loan.getString("PutoutDate");//贷款发放日
		String maturitydate = loan.getString("MaturityDate");//贷款到期日
		String businessDate = loan.getString("BusinessDate");//贷款当前所处交易日期
		String defaultDueDay = rptSegment.getString("DefaultDueDay");//默认还款日
		if(defaultDueDay == null || "".equals(defaultDueDay) || "0".equals(defaultDueDay)) defaultDueDay = putoutDate.substring(8);
		else if(defaultDueDay.length()<2) defaultDueDay="0"+defaultDueDay;
		
		
		//区段信息
		String SegFromDate = rptSegment.getString("SegFromDate");//区段起始日期
		if(SegFromDate==null||SegFromDate.length()==0) SegFromDate=loan.getString("PutOutDate");
		rptSegment.setAttributeValue("SegFromDate", SegFromDate);
		String segToDate = rptSegment.getString("SegToDate");//区段起始日期
		if(segToDate==null||segToDate.length()==0) segToDate=loan.getString("MATURITYDATE");
		String lastDueDate = rptSegment.getString("LastDueDate");//区段上次还款日期
		if(lastDueDate==null||lastDueDate.length()==0){//新发放贷款，上次应还款日使用放款日
			lastDueDate= SegFromDate;
		}
		String pamentFrequencyCode = rptSegment.getString("PaymentFrequencyType");
		BusinessObject paymentcycle=(BusinessObject) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(pamentFrequencyCode);
		if(paymentcycle.getInt("Term")==0)
		{
			rptSegment.setAttributeValue("LastDueDate", SegFromDate);
			rptSegment.setAttributeValue("FirstDueDate", segToDate);
			rptSegment.setAttributeValue("NextDueDate", segToDate);
			return;
		}
		
		//定义下次还款日
		String nextDueDate = "";
		
		if(DateFunctions.TERM_UNIT_MONTH.equals(paymentcycle.getString("TermUnit"))){//对于按月的才使用这些参数
			String firstInstalmentFlag=rptSegment.getString("FirstInstalmentFlag");//首期还款约定
			if(firstInstalmentFlag == null || "".equals(firstInstalmentFlag)) firstInstalmentFlag = loan.getString("FirstInstalmentFlag");//首期还款约定
			else loan.setAttributeValue("FirstInstalmentFlag", firstInstalmentFlag);
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) {
				String productID = loan.getString("BusinessType");
				String productVersion = ProductConfig.getProductNewestVersionID(productID);
				firstInstalmentFlag = ProductConfig.getProductTermParameterAttribute(productID,productVersion, rptSegment.getString("RPTTermID"), "FirstInstalmentFlag", "DefaultValue");
			}
				
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) 
				throw new LoanException("未指定首期还款约定{FirstInstalmentFlag}！");
			else if(firstInstalmentFlag.equals("01")){//放款当月还款
				//放款月+默认还款日小于放款日期 且 放款月+默认还款日大于月底的情况
				if((SegFromDate.substring(0,8) + defaultDueDay).compareTo(SegFromDate)<=0 
					|| DateFunctions.getEndDateOfMonth(SegFromDate.substring(0,8) + defaultDueDay).compareTo(SegFromDate.substring(0,8) + defaultDueDay) < 0){
					nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
					nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
				}else{
					nextDueDate = SegFromDate.substring(0,8) + defaultDueDay;
				}
			}
			else if(firstInstalmentFlag.equals("02")){//放款当月不还款
				nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
				nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
			}
			else if(firstInstalmentFlag.equals("03")){//放款当月还款（固定周期） 按季 3、6、9、12 按半年 6、12 按双月 2、4、6、8、10、12
				if(Integer.valueOf(SegFromDate.substring(5, 7))%paymentcycle.getInt("Term") == 0)
				{
					//放款月+默认还款日小于放款日期 且 放款月+默认还款日大于月底的情况
					if((SegFromDate.substring(0,8) + defaultDueDay).compareTo(SegFromDate)<=0 
						|| DateFunctions.getEndDateOfMonth(SegFromDate.substring(0,8) + defaultDueDay).compareTo(SegFromDate.substring(0,8) + defaultDueDay) < 0){
						nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
						nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
					}else{
						nextDueDate = SegFromDate.substring(0,8) + defaultDueDay;
					}
				}
				else
				{
					nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),Integer.valueOf(SegFromDate.substring(5, 7))%paymentcycle.getInt("Term"));
					nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
				}
			}
			else if(firstInstalmentFlag.equals("04")){//放款当月不还款（固定周期） 按季 3、6、9、12 按半年 6、12 按双月 2、4、6、8、10、12
				if(Integer.valueOf(SegFromDate.substring(5, 7))%paymentcycle.getInt("Term") == 0)
				{
					nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
					nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
				}
				else
				{
					nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term")-Integer.valueOf(SegFromDate.substring(5, 7))%paymentcycle.getInt("Term"));
					nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
				}
			}
			else if(firstInstalmentFlag.equals("05")){//放款当日预收息
				nextDueDate=SegFromDate;
			}
		}
		
		//如果周期是天，目前是双周供
		if(DateFunctions.TERM_UNIT_DAY.equals(paymentcycle.getString("TermUnit"))){
			if("".equals(nextDueDate)){
				nextDueDate = DateFunctions.getRelativeDate(businessDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
			}
		}
		//如果计算的首次还款日小于贷款的当前日期，则循环加n个还款周期，直到大于BusinessDate
		while(DateFunctions.compareDate(nextDueDate, businessDate)<=0){
			nextDueDate=DateFunctions.getRelativeDate(nextDueDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
		}
		
		if(DateFunctions.compareDate(nextDueDate, maturitydate)>0){
			nextDueDate = maturitydate;
		}
		rptSegment.setAttributeValue("LastDueDate", SegFromDate);
			rptSegment.setAttributeValue("FirstDueDate", segToDate);
			rptSegment.setAttributeValue("NextDueDate", segToDate);
		//更新最终计算结果
		rptSegment.setAttributeValue("LastDueDate", lastDueDate);
		rptSegment.setAttributeValue("FirstDueDate", nextDueDate);
		rptSegment.setAttributeValue("NextDueDate", nextDueDate);
		rptSegment.setAttributeValue("DefaultDueDay", defaultDueDay);
	}*/
	
	/**
	 * 更新还款方式，还款周期
	 * @param loan
	 * @throws Exception
	 */
	public static void updateLoanRptSegment(BusinessObject loan,AbstractBusinessObjectManager bomanager) throws Exception {
		String businessDate = loan.getString("BusinessDate");
		List<BusinessObject> rptList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		
		if(rptList==null||rptList.isEmpty()) return;
		for(BusinessObject a:rptList){
			String status=a.getString("Status");//状态
			if(status==null||status.equals("2")) continue;//已失效的记录
			
			String SegFromDate=a.getString("SegFromDate");
			String SegToDate=a.getString("SegToDate");
			
			if((SegFromDate==null||SegFromDate.compareTo(businessDate)<=0)&&status.equals("3")){//待生效
				a.setAttributeValue("Status", "1");//置为无效
				bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, a);
			}
			
			if(SegToDate!=null&&SegToDate.length()>0&&SegToDate.compareTo(businessDate)<0){//置为无效
				a.setAttributeValue("Status", "2");//置为无效
				bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, a);
			}
		}
	}

	/**
	 * 更新贷款的状态,核销和冲账的需要在交易中进行判断，不能调用此方法
	 * @param loan
	 * @throws Exception 
	 * @throws NumberFormatException 
	 */
	public static void updateLoanStatus(BusinessObject loan,AbstractBusinessObjectManager bomanager) throws NumberFormatException, Exception {
		double normalBalance =loan.getDouble("NormalBalance");
		double overdueBalance=loan.getDouble("OverdueBalance");
		double overdueInterest=loan.getDouble("ODInteBalance");
		double fineInterest=loan.getDouble("FineInteBalance");
		double compInterest=loan.getDouble("CompdInteBalance");
		double accrueInteBalance=loan.getDouble("AccrueInteBalance");
		String businessDate = loan.getString("BusinessDate");
		String maturityDate  = loan.getString("MaturityDate");
		String loanStatus = loan.getString("LoanStatus");
		int overDueDays = loan.getInt("OverdueDays");
		
		if(overDueDays>0 &&"0".equals(loanStatus) ){//有逾期天数，但是是正常，则更改状态为逾期
			loan.setAttributeValue("LoanStatus", "1");
		}
		else if(overDueDays<=0&&"1".equals(loanStatus)){//没有逾期天数，但是是逾期，则更改状态为正常
			loan.setAttributeValue("LoanStatus", "0");
		}
		if(Arith.round(normalBalance+overdueBalance+overdueInterest+fineInterest+compInterest+accrueInteBalance, 2)<=0d
				&&("0".equals(loanStatus) || "1".equals(loanStatus) || "5".equals(loanStatus))){//如果没有欠款，则更新为结清
			ArrayList<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			if(paymentScheduleList!=null&&!paymentScheduleList.isEmpty()){
				//将还款计划正序排序
				bomanager.sortBusinessObject(paymentScheduleList, "PayDate");
				BusinessObject a=paymentScheduleList.get(paymentScheduleList.size()-1);
				
				String payDate = a.getString("PayDate");
				if(payDate.compareTo(maturityDate)>0) maturityDate=payDate;
			}
			
			if(businessDate.compareTo(maturityDate)==0) loanStatus="2";
			if(businessDate.compareTo(maturityDate)<0) loanStatus="3";
			if(businessDate.compareTo(maturityDate)>0) loanStatus="4";
			
			loan.setAttributeValue("LoanStatus", loanStatus);
		}
		
		//此种情况针对冲账需要更新贷款状态,核销后还款没有冲账可以不考虑，只需要考虑正常和逾期
		if(Arith.round(normalBalance+overdueBalance+overdueInterest+fineInterest+compInterest, 2)>0d
				&&( !"0".equals(loanStatus) && !"1".equals(loanStatus) && !"5".equals(loanStatus) )){
			if(overDueDays > 0) loanStatus = "1";
			else loanStatus = "0";
			loan.setAttributeValue("LoanStatus", loanStatus);
		}
				
		//更新结清状态和结清日期，不含罚复息
		if(Arith.round(normalBalance+overdueBalance+overdueInterest+accrueInteBalance, 2)==0d
				&&("".equals(loan.getString("SettleDate")) || loan.getString("SettleDate") == null)){
			loan.setAttributeValue("SettleDate", businessDate);//不含罚复息结清日期
		}
		else if(Arith.round(normalBalance+overdueBalance+overdueInterest+accrueInteBalance, 2)>0d){
			loan.setAttributeValue("SettleDate", "");//不含罚复息结清日期
		}
		//含罚复息的结清日期
		if(Arith.round(normalBalance+overdueBalance+overdueInterest+fineInterest+compInterest+accrueInteBalance, 2)<=0d
				&&("".equals(loan.getString("FinishDate")) || loan.getString("FinishDate") == null ) ){
			loan.setAttributeValue("FinishDate", businessDate);
		}
		else if(Arith.round(normalBalance+overdueBalance+overdueInterest+fineInterest+compInterest+accrueInteBalance, 2)>0d){
			loan.setAttributeValue("FinishDate", "");
		}
	}

	private static boolean isFeeListFinished(BusinessObject loan, AbstractBusinessObjectManager bom) throws Exception {
		boolean flag = true;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", loan.getObjectType());
		as.setAttribute("ObjectNo", loan.getObjectNo());
		as.setAttribute("Status", ACCOUNT_CONSTANTS.STATUS_EFFECTIVE);
		String whereClause = "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status";
		List<BusinessObject> feeList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, whereClause, as);
		if (feeList == null || feeList.size() == 0)
			return flag;
		for (BusinessObject fee : feeList) {
			if (fee.getDouble("ActualPayAmount") < fee.getDouble("TotalAmount")) {
				flag = false;
				break;
			}
		}
		return flag;
	}
}