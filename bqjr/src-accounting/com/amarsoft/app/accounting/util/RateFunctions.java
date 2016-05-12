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
 * ��Ϣ��������غ���
 *
 */
public class RateFunctions {
	
	public static double getInterestRate(BusinessObject loan,String payDate,String fromDate,String toDate,String rateType) throws Exception{
		double interestRate=0d;
		List<BusinessObject> rateSegmentList = InterestFunctions.getRateSegmentList(loan, rateType);//���ʶ�����Ϣ
		for(BusinessObject rateSegment : rateSegmentList){//�����ֶ������ʱ����Ҫ�����ʼ�����
			if(!"1".equals(rateSegment.getString("Status"))) continue;
			interestRate += InterestFunctions.getInterest(1, rateSegment,loan, payDate,fromDate, toDate);
		}
		return interestRate;
	}
	
	
	
	
	/**
	 * ����������
	 * @param yearDays
	 * @param rateUnit
	 * @param rate
	 * @return
	 * @throws LoanException
	 */
	public static double getRate(int yearDays,String rateUnit,double rate,String newRateUnit) throws LoanException{
		if(rateUnit.equals(newRateUnit)) return rate;
		if(ACCOUNT_CONSTANTS.RateUnit_Year.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Month.equals(newRateUnit)){
			return rate/100/12*1000;//�����ʣ�ǧ�ֱ�
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Year.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Day.equals(newRateUnit)){
			return rate/100/yearDays*10000;//�����ʣ���ֱ�
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Month.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Year.equals(newRateUnit)){
			return rate/1000*12*100;//�����ʣ��ٷֱ�
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Month.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Day.equals(newRateUnit)){
			return rate/1000*12/yearDays*10000;//�����ʣ���ֱ�
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Day.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Month.equals(newRateUnit)){
			return rate/10000*yearDays/12*1000;//�����ʣ�ǧ�ֱ�
		}
		else if(ACCOUNT_CONSTANTS.RateUnit_Day.equals(rateUnit)&&ACCOUNT_CONSTANTS.RateUnit_Year.equals(newRateUnit)){
			return rate/10000*yearDays*100;//�����ʣ��ٷֱ�
		}
		else throw new LoanException("δ������ȷ�����ʵ�λ{RateUnit}!");
	}
	
	/**
	 * ���ݱ��ֵĲ�ͬ�����ز�ͬ�ļ�Ϣ������Ӣ���͸۱���365������������360
	 * @throws Exception 
	 * 
	 */
	public static int getBaseDays(String Currency) throws Exception{
		int baseDays = 360;
		if("".equals(Currency) || Currency == null) throw new Exception("����Ϊ�գ����֤");
		if("02".equals(Currency) || "03".equals(Currency)) baseDays = 365;
		
		return baseDays;
	}
	
	/**
	 * ���ݱ��ֵĲ�ͬ�����ز�ͬ�ļ�Ϣ������Ӣ���͸۱���365������������360
	 * @throws Exception 
	 * 
	 */
	public static int getBaseDays(BusinessObject loan) throws Exception{
		return getBaseDays(loan.getString("Currency"));
	}
		
	/**
	 * ͨ�����ʵ�����ʽ�ȼ����ض�������
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
		//�������� �����������ʵ������պ�ִ�У�������Ϊ����
		if("1".equals(repriceType)){
			nextRepriceDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
		//�����
		}else if("2".equals(repriceType)){
			nextRepriceDate = DateFunctions.getRelativeDate(businessDate,DateFunctions.TERM_UNIT_YEAR,1).substring(0,4)+"/01/01";
		}
		//������¶���
		else if("3".equals(repriceType)){
			nextRepriceDate = DateFunctions.getRelativeDate(lastRepriceDate,DateFunctions.TERM_UNIT_YEAR,DateFunctions.getYears(lastRepriceDate, businessDate)+1);
			while(nextRepriceDate.compareTo(businessDate) <= 0)
				nextRepriceDate = DateFunctions.getRelativeDate(nextRepriceDate,DateFunctions.TERM_UNIT_YEAR,1);
		}
		//���µ�
		else if("4".equals(repriceType)){
			//��ֹ�����ۼӣ���С������
			int iMonth = DateFunctions.getMonths(lastRepriceDate, businessDate);
			nextRepriceDate = DateFunctions.getRelativeDate(lastRepriceDate,DateFunctions.TERM_UNIT_MONTH,iMonth);
			while(nextRepriceDate.compareTo(businessDate) <= 0) 
				nextRepriceDate = DateFunctions.getRelativeDate(lastRepriceDate,DateFunctions.TERM_UNIT_MONTH,iMonth+1);
		}
		//��һ�����յ���
		else if("5".equals(repriceType)){
			String maturityDate=loan.getString("MaturityDate");
			if(maturityDate.compareTo(businessDate)<0){//���ں���������
				nextRepriceDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
			}
			else
				nextRepriceDate = LoanFunctions.getNextDueDate(loan);
			if(nextRepriceDate.length()==0)
				nextRepriceDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
		}
		//�����׸������յ���
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
		//�ֹ�ָ��������
		else if("8".equals(repriceType)){
			String firstRepriceDate = loan.getString("RepriceDate");//�״������ض�������	
			if("".equals(firstRepriceDate))	firstRepriceDate=loan.getString("LastRepriceDate");
			String fren = loan.getString("RepriceFlag");//�ض������ڵ�λ
			int cyc = loan.getInt("REPRICECYC");//�ض�������
			if("".equals(firstRepriceDate) || "".equals(fren) || cyc<=0) 
				throw new Exception("�Զ���������ڵĲ�����ȫ�����֤���״��ض�������:"+firstRepriceDate+",�ض������ڵ�λ:"+fren+",�ض�������:"+cyc);
			//���������״ε������ڱȵ�ǰ���ڴ���ֱ��ȡֵ
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
					//�޸���������״ε����������µ׾�ȡ�µ�
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
		
		//BEA���ں��ٵ�����Ϣ
		if(!nextRepriceDate.equals("") && nextRepriceDate.compareTo(sMaturityDate) >=0)
			nextRepriceDate = "";
		//���������ʵĴ����´��ض������ڸ�ֵΪ�� 
		if("7".equals(repriceType))	
			nextRepriceDate = "";
		
		return nextRepriceDate;
	}

	
	
	/**
	 * @param termSeg
	 * @return
	 * @throws AccountingException
	 * @throws Exception
	 * �����׼����
	 */
	public static double getBaseRate(BusinessObject loan,BusinessObject rateSegment) throws LoanException, Exception{
		double baseRate=0d;
		String baseRateType=rateSegment.getString("BaseRateType");
		if(baseRateType==null||baseRateType.equals("")) return 0d;
		if(baseRateType.equals("999")){//hhcf��׼����
			List<BusinessObject> a=InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal) ;//ȡ������������
			return a.get(0).getDouble("BaseRate");
		}
		if(baseRateType.equals("060") || ACCOUNT_CONSTANTS.RateMode_Fix.equals(rateSegment.getString("RateMode"))) return 0d;//EIR�����ڻ�׼����
		if(baseRateType.equals("100")){//ȡ��������
			List<BusinessObject> a=InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal) ;//ȡ������������
			return a.get(0).getDouble("BusinessRate");
		}
		if(baseRateType.equals("030")){//ȡ��������
			List<BusinessObject> a=InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Discount) ;//ȡ������������
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
	 * �����������
	 */
	public static double getBusinessRate(BusinessObject loan,BusinessObject rateSegment) throws Exception{		
		//����ǹ̶�ģʽ,��ִ�����ʲ���
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
			//�����ʸ�������Ϊ����ʱ,ִ������ = ��׼����+��������
			else if(ACCOUNT_CONSTANTS.RateFloatType_POINTS.equals(rateFloatType)){
				businessRate = baseRate + rateFloat/100.0;
			}else{
				throw new Exception("���ʼ����������[���ʸ�������]¼������");
			}
			if(businessRate<0d){
				throw new Exception("ִ�����ʲ���Ϊ����{"+businessRate+"}��");
			}
			return Arith.round(businessRate,ACCOUNT_CONSTANTS.Number_Precision_Rate);
		}
	}
	
	
	
}
