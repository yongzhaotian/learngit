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
		
		if(interestType==null || "".equals(interestType)) interestType = rateSegment.getString("InterestType");
		if(oddInterestType==null || "".equals(oddInterestType)) oddInterestType = rateSegment.getString("OddInterestType");
		
		String compdInterestFlag = rateSegment.getString("CompdInterestFlag");//�Ƹ�����ʾ
		if(compdInterestFlag==null||compdInterestFlag.length()==0) compdInterestFlag="2";//Ĭ�ϲ��Ƹ���
		
		
		String nextMonthDate = DateFunctions.getRelativeDate(beginDate,DateFunctions.TERM_UNIT_MONTH,1);
		if(payDate.substring(8,10).compareTo(nextMonthDate.substring(8,10))>0){
			nextMonthDate=nextMonthDate.substring(0,8)+payDate.substring(8,10);
			if(nextMonthDate.compareTo(DateFunctions.getEndDateOfMonth(nextMonthDate))>0)
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);
		}
		
		//�жϼ�Ϣ�����Ƿ�����
		boolean isFullMonth = false;
		if(nextPayDate.compareTo(nextMonthDate) >=0){
			if(nextMonthDate.equals(nextPayDate))
				isFullMonth = true;
			if(DateFunctions.monthEnd(nextPayDate) && DateFunctions.monthEnd(beginDate))
				isFullMonth = true;
		}
		
		if(DateFunctions.monthEnd(beginDate)){//�����ʼ�պͽ����ն�����ĩ
			if(DateFunctions.monthEnd(endDate))
				nextMonthDate=DateFunctions.getEndDateOfMonth(nextMonthDate);
			else if(DateFunctions.monthEnd(nextPayDate))
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
				
				/************************
				 * ����������Ϣ������û�����ʱ������Ϊ���¼�Ϣ�������´ν�Ϣ��Ϊ���գ��򰴱�����̯
				 */
				
				if(DateFunctions.monthEnd(validBeginDate) && DateFunctions.monthEnd(nextPayDate))
					t = DateFunctions.getEndDateOfMonth(t);
				if(validBeginDate.equals(beginDate)&&validEndDate.equals(endDate)
						&&nextPayDate.equals(t)){
					oddInterestType=ACCOUNT_CONSTANTS.Odd_InterestType_Daily;
				}
				
				/************************
				 * ���Ϊ���£��򰴱�����̯
				 */
				if(isFullMonth){
					oddInterestType=ACCOUNT_CONSTANTS.Odd_InterestType_Daily;
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
