package com.amarsoft.proj.action;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GetMonthPayment {
	
	private String typeNo;//��Ʒ���
	private double rate;//����
	private double term;//����
	private double financeAmount;//������
	private double finalPaymentSum;//β����
	private double finalPaymentRate;//β�����
	
	public String getTypeNo() {
		return typeNo;
	}
	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}
	public double getRate() {
		return rate;
	}
	public void setRate(double rate) {
		this.rate = rate;
	}
	public double getTerm() {
		return term;
	}
	public void setTerm(double term) {
		this.term = term;
	}
	public double getFinanceAmount() {
		return financeAmount;
	}
	public void setFinanceAmount(double financeAmount) {
		this.financeAmount = financeAmount;
	}
	public double getFinalPaymentSum() {
		return finalPaymentSum;
	}
	public void setFinalPaymentSum(double finalPaymentSum) {
		this.finalPaymentSum = finalPaymentSum;
	}
	public double getFinalPaymentRate() {
		return finalPaymentRate;
	}
	public void setFinalPaymentRate(double finalPaymentRate) {
		this.finalPaymentRate = finalPaymentRate;
	}	
	
	

	//�����»�����  ������������
	public String getMonthPayment(Transaction Sqlca) throws Exception{
		//�������
		String sMonthPayment = "";//�»�����
		String sReturnValues = "";//����ֵ
		//��ȡ��Ʒ�����ġ��¹����㷽ʽ��
		String monthcalculationMethod = "";//�¹����㷽ʽ�� 
		//select termid,termname from PRODUCT_TERM_LIBRARY Where termid in('RPT17','RPT18','RPT19','RPT21','RPT22') and TermType = 'RPT' and ObjectType='Term' and SetFlag in ('SET','BAS')
		/*	RPT17	�ȶϢ
			RPT18	β���Ϣ
			RPT19	β���Ϣ
			RPT21	β���Ϣ���ϲ�����
			RPT22	β���Ϣ���ϲ�����*/
	/*1.1.1.1.4.2.1β���Ϣ
		ע�ͣ�A+β��=������
		A���գ���������-1���ȶϢ�ķ�ʽ�����¹������һ���¹�=β��
		1.1.1.1.4.2.2β���Ϣ
		ע�ͣ�A+β��=������
		����������-1�����¹�=A���գ���������-1�����������ʵȶϢ�ķ�ʽ�����¹�+β��������ʣ����һ���¹�=β��+β���������
		������=β��̶�����/12
		1.1.1.1.4.2.3β���Ϣ���ϲ�����
		ע�ͣ�A+β��=������
		A���գ��������ޣ��ȶϢ�ķ�ʽ�����¹������һ���¹�=A�¹�+β��
		1.1.1.1.4.2.4β���β���Ϣ�����ϲ�����
		ע�ͣ�A+β��=������
		���������ޣ����¹�=A���գ��������ޣ��ȶϢ�ķ�ʽ�����¹�+β��������ʣ����һ���¹�= A�¹�+β��+β���������
		������=β��̶�����/12
		*/
		String sSql = "select monthcalculationMethod from Business_Type where TypeNo = :TypeNo";
		monthcalculationMethod  = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo", typeNo));
		if(monthcalculationMethod==null)	{
			return "UnSuccess";
		}else{
			if(monthcalculationMethod.equals("RPT17")){
				sMonthPayment = DataConvert.toMoney(PMT(rate,term,financeAmount));	
				sReturnValues =  sMonthPayment;
			}else if(monthcalculationMethod.equals("RPT18")){
				sMonthPayment = DataConvert.toMoney(PMT(rate-1,term,financeAmount-finalPaymentSum));		
				sReturnValues =  "ǰ"+DataConvert.toString(rate-1)+"��ÿ�ڻ�����Ϊ�����"+sMonthPayment+"Ԫ�����һ�ڻ�����Ϊ�����"+DataConvert.toMoney(finalPaymentSum)+"Ԫ��";
			}else if(monthcalculationMethod.equals("RPT19")){				
				sMonthPayment = DataConvert.toMoney(PMT(rate-1,term,financeAmount-finalPaymentSum)+finalPaymentSum*(finalPaymentRate/12));		
				sReturnValues =  "ǰ"+DataConvert.toString(rate-1)+"��ÿ�ڻ�����Ϊ�����"+sMonthPayment+"Ԫ�����һ�ڻ�����Ϊ�����"+DataConvert.toMoney(finalPaymentSum+finalPaymentSum*finalPaymentRate/12)+"Ԫ��";
			}else if(monthcalculationMethod.equals("RPT21")){				
				sMonthPayment = DataConvert.toMoney(PMT(rate,term,financeAmount-finalPaymentSum));		
				sReturnValues =  "ǰ"+DataConvert.toString(rate-1)+"��ÿ�ڻ�����Ϊ�����"+sMonthPayment+"Ԫ�����һ�ڻ�����Ϊ�����"+DataConvert.toMoney(finalPaymentSum+PMT(rate,term,financeAmount-finalPaymentSum))+"Ԫ��";
			}else if(monthcalculationMethod.equals("RPT22")){				
				sMonthPayment = DataConvert.toMoney(PMT(rate,term,financeAmount-finalPaymentSum)+finalPaymentSum*(finalPaymentRate/12));		
				sReturnValues =  "ǰ"+DataConvert.toString(rate-1)+"��ÿ�ڻ�����Ϊ�����"+sMonthPayment+"Ԫ�����һ�ڻ�����Ϊ�����"+DataConvert.toMoney(finalPaymentSum+finalPaymentSum*finalPaymentRate/12+PMT(rate,term,financeAmount-finalPaymentSum)+finalPaymentSum*(finalPaymentRate/12))+"Ԫ��";
			}			
		}
		return sReturnValues;
	}
	
	/**
	 
	* �����¹�
	 
	* @param rate ������ �����ʳ���12����������
	 
	* @param term ������������λ��
	 
	* @param financeAmount  ������
	 
	* @return
	 
	*/
	 
	private double PMT(double rate,double term,double financeAmount)
	 
	{
	 
	    double v = (1+(rate/12)); 
	 
	    double t = (-(term/12)*12); 
	 
	    double result=(financeAmount*(rate/12))/(1-Math.pow(v,t));
	 
	    return result;
	 
	}


}
