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
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
		BusinessObject paymentFrequency = (BusinessObject) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(paymentFrequencyType);
		if("3".equals(paymentFrequencyType)){//һ�λ���
			return SegToDate;
		}
		
		if(!DateFunctions.TERM_UNIT_MONTH.equals(paymentFrequency.getString("TermUnit")))//���ڰ��µĲ���Ч
			throw new LoanException("�˽ű��������ڻ�������Ϊ���µ���������޸����������Ϣ��");
		
		String defaultDueDay = rptSegment.getString("DefaultDueDay");//Ĭ�ϻ�����
		if(defaultDueDay == null || "".equals(defaultDueDay) || "0".equals(defaultDueDay)) defaultDueDay = loanPutoutDate.substring(8);
		else if(defaultDueDay.length()==1) defaultDueDay="0"+defaultDueDay;
		
		String nextPayDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit"), paymentFrequency.getInt("Term"));
		
		//�ж�����
		if(lastDueDate.equals(SegFromDate)){//�״λ������ڣ���Ҫ�����״λ���Լ���жϵ����Ƿ񻹿�
			String firstInstalmentFlag=rptSegment.getString("FirstInstalmentFlag");//���ڻ���Լ��
			if(firstInstalmentFlag == null || "".equals(firstInstalmentFlag)) firstInstalmentFlag = loan.getString("FirstInstalmentFlag");//���ڻ���Լ��
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) {
				String productID = loan.getString("BusinessType");
				String productVersion = ProductConfig.getProductNewestVersionID(productID);
				firstInstalmentFlag = ProductConfig.getProductTermParameterAttribute(productID,productVersion, rptSegment.getString("RPTTermID"), "FirstInstalmentFlag", "DefaultValue");
			}
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) 
				firstInstalmentFlag="02";
			
			if(firstInstalmentFlag.equals("01")){//�ſ�»���̶����ڣ� ���� 3��6��9��12 ������ 6��12 ��˫�� 2��4��6��8��10��12
				if(Integer.valueOf(SegFromDate.substring(5, 7))%paymentFrequency.getInt("Term") == 0){//�ſ���+Ĭ�ϻ�����С�ڷſ����� �� �ſ���+Ĭ�ϻ����մ����µ׵����
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
			else if(firstInstalmentFlag.equals("02")){//�ſ�²�����̶����ڣ� ���� 3��6��9��12 ������ 6��12 ��˫�� 2��4��6��8��10��12
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
		if(defaultDueDay.length()>0){//�����µ�����Ĭ����
			if(Integer.parseInt(DateFunctions.getEndDateOfMonth(nextPayDate).substring(nextPayDate.length()-2))>Integer.parseInt(defaultDueDay)){
				nextPayDate=nextPayDate.substring(0,8)+defaultDueDay;
			}
			else{
				nextPayDate=DateFunctions.getEndDateOfMonth(nextPayDate);
			}
		}
		
		//�ж�ĩ������
		String finalInstalmentFlag=loan.getString("FinalInstalmentFlag");//ĩ�ڻ����ʶ
		if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
			finalInstalmentFlag=rptSegment.getString("FinalInstalmentFlag");
		}
		if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
			finalInstalmentFlag="01";
		}
		if(finalInstalmentFlag.equals("01")){//�������
			if(nextPayDate.compareTo(SegToDate)>=0){//�´λ����ճ���������գ����Դ������Ϊ׼
				nextPayDate = SegToDate;
			}
			else {
				String t = DateFunctions.getRelativeDate(nextPayDate, paymentFrequency.getString("TermUnit"), paymentFrequency.getInt("Term"));
				if (t.compareTo(SegToDate)>0&&nextPayDate.substring(0, 7).equals(SegToDate.substring(0, 7))){
					//˵��ʣ�����޲���һ�ڣ��������´λ������뵽����Ϊͬһ���£���ϲ�
					nextPayDate= SegToDate;
				}
			}
		}
		else if(finalInstalmentFlag.equals("02")){//����һ������һ�ڵ�ʱ�����������⴦��
			if(nextPayDate.compareTo(SegToDate)>=0){//�´λ����ճ���������գ����Դ������Ϊ׼
				nextPayDate = SegToDate;
			}
		}
		else if(finalInstalmentFlag.equals("03")){//�������һ���Զ��ж�
			
		}
		else {
			throw new Exception("����{"+loan.getObjectNo()+"}��ĩ�ڻ����ʶ{FinalInstalmentFlag}δ���壡");
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
