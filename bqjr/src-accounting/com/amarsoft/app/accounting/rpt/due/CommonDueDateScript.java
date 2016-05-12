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
		String paymentFrequencyType=rptSegment.getString("PaymentFrequencyType");//��������
		BusinessObject paymentFrequency = (BusinessObject) PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(paymentFrequencyType);
		
		String nextPayDate = DateFunctions.getRelativeDate(lastDueDate, paymentFrequency.getString("TermUnit"), paymentFrequency.getInt("Term"));
		if("3".equals(paymentFrequencyType)){//һ�λ���
			return SegToDate;
		}
		
		//������28�Ż����յ����,˫�ܹ��Ĳ�������ֻ���µĲŴ���
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
				//�����µ�����Ĭ����
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
