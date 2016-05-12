package com.amarsoft.app.accounting.interest;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.PaymentFrequencyConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.Arith;

public class InterestFunctions {
	
	/**
	 * ��õ�ǰ��Ч��������Ϣ
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getRateSegmentList(BusinessObject loan,String rateType) throws Exception {		
		ArrayList<BusinessObject> rateSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);//������Ϣ
		ArrayList<BusinessObject> validRateSegmentList= new ArrayList<BusinessObject>();
		if(rateSegmentList!=null&&!rateSegmentList.isEmpty()){
			for(int i=0;i<rateSegmentList.size();i++){
				BusinessObject rateTerm = rateSegmentList.get(i);
				String status = rateTerm.getString("Status");
				if(rateType.indexOf(rateTerm.getString("RateType"))>=0&&status.equals("1"))
					validRateSegmentList.add(rateTerm);
			}
		}
		return validRateSegmentList;
	}
	
	/**
	 * ��õ�ǰ��Ч��������Ϣ
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getActiveRateSegment(BusinessObject loan,String rateType) throws Exception {		
		List<BusinessObject> rateSegmentList = getRateSegmentList(loan,rateType);//������Ϣ
		ArrayList<BusinessObject> validRateSegmentList= new ArrayList<BusinessObject>();
		String businessDate=loan.getString("BusinessDate");
		for(BusinessObject rateTerm:rateSegmentList){
			String status = rateTerm.getString("Status");
			if(rateType.indexOf(rateTerm.getString("RateType"))<0||!status.equals("1"))
				continue;
			String segFromDate = rateTerm.getString("SegFromDate");
			String segToDate = rateTerm.getString("SegToDate");
			if(segFromDate!=null&&segFromDate.length()>0&&segFromDate.compareTo(businessDate)>0)
				continue;
			if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(businessDate)<=0)
				continue;
			
			validRateSegmentList.add(rateTerm);
		}
		if(validRateSegmentList.isEmpty()&&!rateSegmentList.isEmpty()){
			validRateSegmentList.add(rateSegmentList.get(rateSegmentList.size()-1));
		}
		return validRateSegmentList;
	}
	
	
	/**
	 * ��õ�ǰ��Ч��������Ϣ
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getActiveRateSegment(BusinessObject loan,String rateType,String fromDate,String toDate) throws Exception {		
		List<BusinessObject> rateSegmentList = getRateSegmentList(loan,rateType);//������Ϣ
		List<BusinessObject> validRateSegmentList= new ArrayList<BusinessObject>();
		for(BusinessObject rateTerm:rateSegmentList){
			String status = rateTerm.getString("Status");
			if(rateType.indexOf(rateTerm.getString("RateType"))<0||!status.equals("1"))
				continue;
			String segFromDate = rateTerm.getString("SegFromDate");
			String segToDate = rateTerm.getString("SegToDate");
			if(segFromDate!=null&&segFromDate.length()>0&&segFromDate.compareTo(toDate)>0)//���ο�ʼ���ڱȽ������ڴ���Ч��¼
				continue;
			if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(fromDate)<=0)//���ν������ڱȿ�ʼ����С����Ч��¼
				continue;
			
			validRateSegmentList.add(rateTerm);
		}
		if(validRateSegmentList.isEmpty()&&!rateSegmentList.isEmpty()){
			validRateSegmentList.add(rateSegmentList.get(rateSegmentList.size()-1));
		}
		return validRateSegmentList;
	}
	
	
	
	/**
	 * ����������
	 * @param yearDays
	 * @param rateUnit
	 * @param rate
	 * @return
	 * @throws LoanException
	 */
	public static double getMonthlyRate(double baseAmount,double inteMonths,int yearDays,String rateUnit,double rate) throws LoanException{
		double monthlyRate = 0d;
		if(ACCOUNT_CONSTANTS.RateUnit_Year.equals(rateUnit)){
			monthlyRate = baseAmount*inteMonths*rate/12.0/100.0;
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Month.equals(rateUnit)){
			monthlyRate = baseAmount*inteMonths*rate/1000.0;
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Day.equals(rateUnit)){
			monthlyRate = baseAmount*inteMonths*rate*yearDays/12.0/10000.0;
		}
		else throw new LoanException("δ������ȷ�����ʵ�λ{RateUnit}!");
		return Arith.round(monthlyRate,12);
	}
	
	/**
	 * ����������
	 * @param yearDays
	 * @param rateUnit
	 * @param rate
	 * @return
	 * @throws LoanException
	 */
	public static double getDailyRate(double baseAmount,double inteDays,int yearDays,String rateUnit,double rate) throws LoanException{
		double dailyRate = 0d;
		if(ACCOUNT_CONSTANTS.RateUnit_Year.equals(rateUnit)){
			dailyRate = baseAmount*inteDays*rate/yearDays/100.00d;
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Month.equals(rateUnit)){
			dailyRate = baseAmount*inteDays*rate*12.0/yearDays/1000.00d;
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Day.equals(rateUnit)){
			dailyRate = baseAmount*inteDays*rate/10000.00d;
		}
		else throw new LoanException("δ������ȷ�����ʵ�λ{RateUnit}!");
		return Arith.round(dailyRate,15);
	}
	
	/**
	 * ���ݻ���Ƶ�ʼ�����������
	 * @param yearDays
	 * @param rateUnit
	 * @param rate
	 * @param paymentFrequenceCode
	 * @return
	 * @throws Exception
	 */
	public static double getInstalmentRate(double baseAmount,int yearDays,String rateUnit,double rate,String paymentFrequenceCode) throws Exception{
		BusinessObject paymentFrequency = (BusinessObject) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(paymentFrequenceCode);
		if(paymentFrequency==null) throw new Exception("δ�ҵ���������{"+paymentFrequenceCode+"}�Ķ��壡");
		double instalmentRate = 0d;
		String termUnit = paymentFrequency.getString("TermUnit");
		int term = paymentFrequency.getInt("Term");
		if(term<=0) term = 1;
		if(yearDays==0)yearDays=360;
		if(termUnit.equalsIgnoreCase(DateFunctions.TERM_UNIT_MONTH)){
			instalmentRate = getMonthlyRate(baseAmount,term,yearDays,rateUnit,rate);
		}
		else if(termUnit.equalsIgnoreCase(DateFunctions.TERM_UNIT_DAY)){
			instalmentRate = getDailyRate(baseAmount,term,yearDays,rateUnit,rate);
		}
		else throw new Exception("��������{"+paymentFrequenceCode+"}�����޵�λ{"+termUnit+"}���岻��ȷ��");
		return instalmentRate;
	}

	
	public static double getInterest(double baseAmount,BusinessObject rateSegment,BusinessObject loan,String beginDate,String endDate) throws Exception{
		double interest=InterestFunctions.getInterest(baseAmount,rateSegment, loan, beginDate, beginDate, endDate);
		return interest;
	}
	
	public static double getInterest(double baseAmount,BusinessObject rateSegment,BusinessObject loan,String payDate,String beginDate,String endDate) throws Exception{
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
		//�޸�ԭ���������ʱ��ȡ��Ϣ��ʽ��ʹ�û��ʽ���α�ȡֵ
		ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(rptList==null||rptList.isEmpty()) throw new Exception("����δ���廹�ʽ����ȷ�ϣ�");
		if(rptList!=null&&!rptList.isEmpty()){			
			for (BusinessObject rptSegment:rptList){
				if(rptSegment.getString("SegToDate") !=null&&rptSegment.getString("SegToDate").length()>0 && rptSegment.getString("SegToDate").compareTo(loan.getString("BusinessDate"))<=0 )
					continue;
				interestType = rptSegment.getString("InterestType");
				oddInterestType = rptSegment.getString("OddInterestType");
			}
		}
		
		if(interestType==null || "".equals(interestType) || !ACCOUNT_CONSTANTS.RateType_Normal.equals(rateSegment.getString("RateType"))) interestType = rateSegment.getString("InterestType");
		if(oddInterestType==null || "".equals(oddInterestType) || !ACCOUNT_CONSTANTS.RateType_Normal.equals(rateSegment.getString("RateType"))) oddInterestType = rateSegment.getString("OddInterestType");
		
		String nextMonthDate = DateFunctions.getRelativeDate(beginDate,DateFunctions.TERM_UNIT_MONTH,1);
		if(payDate.substring(8,10).compareTo(nextMonthDate.substring(8,10))>0){
			nextMonthDate=nextMonthDate.substring(0,8)+payDate.substring(8,10);
			if(nextMonthDate.compareTo(DateFunctions.getEndDateOfMonth(nextMonthDate))>0)
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);
		}
		//�жϼ�Ϣ�����Ƿ�����
		boolean isFullMonth = false;
		if(endDate.compareTo(nextMonthDate) >=0){
			if(nextMonthDate.equals(endDate))
				isFullMonth = true;
			if(DateFunctions.monthEnd(endDate) && DateFunctions.monthEnd(beginDate))
				isFullMonth = true;
		}
		if(DateFunctions.monthEnd(beginDate)){//�����ʼ�պͽ����ն�����ĩ
			if(DateFunctions.monthEnd(endDate))
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);
			else if(DateFunctions.monthEnd(endDate))
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);//��Ϣ�ն�����ĩ���������6��30��7��31
			else if(nextMonthDate.startsWith(endDate.substring(0, 8))&&nextMonthDate.compareTo(endDate)<0){
				//�����ͬһ���£����ҽ����մ��ڼ�������������ڣ���ȡEndDate
				nextMonthDate=endDate;
			}
		}

		int yearDays = rateSegment.getInt("YearDays");

		if(nextMonthDate.compareTo(endDate)>=0){//һ�����»���һ����
			//ƥ�����ʷֶ���Ϣ������ÿ�����ʶε�ʵ������
			String validBeginDate=rateSegment.getString("SegFromDate");
			if(validBeginDate == null || validBeginDate.length()==0 || validBeginDate.compareTo(beginDate) < 0)
				validBeginDate = beginDate;
			String validEndDate=rateSegment.getString("SegToDate");
			if(validEndDate == null || validEndDate.length()==0 || validEndDate.compareTo(endDate) > 0)
				validEndDate = endDate;
			if(validBeginDate.compareTo(validEndDate) > 0) throw new LoanException("������Ϣ��ʼ�ա�"+validBeginDate+"�����ڵ����ա�"+validEndDate+"�����������ݣ�");
			//������Ϣ
			int inteDays=DateFunctions.getDays(validBeginDate, validEndDate);
			if(interestType.equals(ACCOUNT_CONSTANTS.InterestType_Daily)){//���ռ�Ϣ
				double dailyRate = InterestFunctions.getDailyRate(baseAmount,inteDays,yearDays, rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));//������
				
				interest+=dailyRate;
			}
			else if(interestType.equals(ACCOUNT_CONSTANTS.InterestType_Monthly)){//���¼�Ϣ
				double monthDays = DateFunctions.getDays(beginDate, nextMonthDate);//��������
				String t= DateFunctions.getRelativeDate(validBeginDate,DateFunctions.TERM_UNIT_MONTH,1);
				
				
				if(DateFunctions.monthEnd(validBeginDate) && DateFunctions.monthEnd(endDate))
					t = DateFunctions.getEndDateOfMonth(t);
				
				/************************
				 * ������£��򰴱�����̯
				 */
				if(isFullMonth){
					oddInterestType=ACCOUNT_CONSTANTS.Odd_InterestType_Percent;
				}
				if(oddInterestType==null||oddInterestType.equals("")){
					oddInterestType=ACCOUNT_CONSTANTS.Odd_InterestType_Daily;//Ĭ��ʹ�ð��ռ�Ϣ
				}
				
				if(t.compareTo(validEndDate)<=0){//���£������������:2-28��3-28��29��30��31��Ϊһ������
					interest+=InterestFunctions.getMonthlyRate(baseAmount,1.0d,yearDays, rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));//������
				}
				else if(ACCOUNT_CONSTANTS.Odd_InterestType_Percent.equals(oddInterestType)){//��ͷ�찴������Ϣ
					double monthlyRate = InterestFunctions.getMonthlyRate(baseAmount,inteDays/monthDays,yearDays,rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));
					interest+=monthlyRate;//������̯
				}
				else if(ACCOUNT_CONSTANTS.Odd_InterestType_Daily.equals(oddInterestType)){//��ͷ�찴���Ϣ
					double dailyRate = InterestFunctions.getDailyRate(baseAmount,inteDays,yearDays, rateSegment.getString("RateUnit"), rateSegment.getDouble("BusinessRate"));//������
					interest+=dailyRate;
				}
				else throw new Exception("�Ҳ�����Ӧ����ͷ���Ϣ��ʽ{"+oddInterestType+"}��");			
			}
			else throw new Exception("�Ҳ�����Ӧ�ļ�Ϣ��ʽ{"+interestType+"}��");
		}
		else{//�ݹ����
			double monthInterest = baseAmount*InterestFunctions.getInterest(1.0d,rateSegment,loan, payDate,beginDate,nextMonthDate);
			interest+=monthInterest+baseAmount*InterestFunctions.getInterest(1.0d,rateSegment,loan, payDate,nextMonthDate,endDate);
		}
		return interest;
	}
}
