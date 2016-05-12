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
		String segTermFlag=rptSegment.getString("SegTermFlag");//�������ޱ�־  1-�������� 2-�������� 3-ָ������
		if(segTermFlag==null||segTermFlag.length()==0) segTermFlag="1";
		if(segTermFlag.equals("1")){//��������
			endDate = loanMaturityDate;
		}
		else if(segTermFlag.equals("2")){//��������
			endDate = SegToDate;
		}
		else if(segTermFlag.equals("3")){//ָ������
			int segTerm=rptSegment.getInt("SegTerm");//ָ����������
			String segTermUnit=rptSegment.getString("SegTermUnit");//ָ���������޵�λ��Ĭ��Ϊ��M
			endDate = DateFunctions.getRelativeDate(SegFromDate, segTermUnit, segTerm);
			if(endDate != null && endDate.compareTo(SegToDate) > 0)
				endDate = SegToDate;
		}
		else throw new Exception("����{"+loan.getObjectNo()+"}�Ļ�������SegTermFlagδ���壡");
		
		String lastDueDate = rptSegment.getString("LastDueDate");
		if(lastDueDate==null||lastDueDate.length()==0||lastDueDate.compareTo(SegFromDate)<0)
			lastDueDate=SegFromDate;
		
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
		BusinessObject paymentFrequency = (BusinessObject) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(paymentFrequencyType);
		int term = paymentFrequency.getInt("Term");
		if(term<=0) return 1;
		else {
			if(lastDueDate.equals(endDate))
				return 1;
			else{
				int totalPeriod = 0;
				String defaultDueDay = rptSegment.getString("DefaultDueDay");//Ĭ�ϻ�����
				if(defaultDueDay == null || "".equals(defaultDueDay) || "0".equals(defaultDueDay)) 
					defaultDueDay = loanPutoutDate.substring(8);
				else if(defaultDueDay.length() == 1) 
					defaultDueDay = "0" + defaultDueDay;
				String firstInstalmentFlag = loan.getString("FirstInstalmentFlag"); //���ڻ����ʶ
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
				int totalPeriod1 = DateFunctions.getTermPeriod(lastDueDate,endDate,paymentFrequency.getString("TermUnit"), term);//����ȡ��
				String finalDueDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit")
						, totalPeriod1*term);
				totalPeriod = totalPeriod1 + totalPeriod;
				String finalInstalmentFlag=loan.getString("FinalInstalmentFlag");//ĩ�ڻ����ʶ
				if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
					finalInstalmentFlag=rptSegment.getString("FinalInstalmentFlag");
				}
				
				if(finalInstalmentFlag==null||finalInstalmentFlag.length()==0){
					finalInstalmentFlag="01";
				}
				if(finalInstalmentFlag.equals("01")){//�������
					return totalPeriod;
				}
				else if(finalInstalmentFlag.equals("02")){//����һ������һ�ڵ�ʱ�����������⴦��
					if(finalDueDate.compareTo(SegToDate)>=0)
						return totalPeriod;
					else
						return totalPeriod+1;
				}
				else if(finalInstalmentFlag.equals("03")){//�������һ���Զ��ж�
					return totalPeriod;
				}
				else {
					throw new Exception("����{"+loan.getObjectNo()+"}��ĩ�ڻ����ʶ{FinalInstalmentFlag}δ���壡");
				}
			}
				
		}
	}
}
