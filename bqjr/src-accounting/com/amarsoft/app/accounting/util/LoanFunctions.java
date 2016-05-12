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
	 * ����������������������δʹ�ã���˸���PaymentSchedule�е�OverdueFlag�жϼ���
	 * @param loan
	 * @return
	 * @throws Exception
	 */
	public static int getOverDays(BusinessObject loan) throws Exception {
		//ȡδ����Ļ���ƻ�
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
			if(InteDate.compareTo(businessDate) >= 0 || paymentschedule.getString("SettleDate") != null && !paymentschedule.getString("SettleDate").equals("") )continue;//�����ڵĲ���
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
	 * ��ȡ��������ƻ�����δ��������С��һ�ڣ�
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
			if(paydate.compareTo(businessDate)>0){//�����ϴε�����
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
	 * ȡ�´λ�����
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
	 * ȡ�ϴλ�����
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
	 * �����������ε��״�Ӧ�����գ��ſ�ʱ����
	 */
	/*public static void setFirstDueDate(BusinessObject loan,BusinessObject rptSegment) throws LoanException, Exception{
		//������Ϣ
		String putoutDate = loan.getString("PutoutDate");//�������
		String maturitydate = loan.getString("MaturityDate");//�������
		String businessDate = loan.getString("BusinessDate");//���ǰ������������
		String defaultDueDay = rptSegment.getString("DefaultDueDay");//Ĭ�ϻ�����
		if(defaultDueDay == null || "".equals(defaultDueDay) || "0".equals(defaultDueDay)) defaultDueDay = putoutDate.substring(8);
		else if(defaultDueDay.length()<2) defaultDueDay="0"+defaultDueDay;
		
		
		//������Ϣ
		String SegFromDate = rptSegment.getString("SegFromDate");//������ʼ����
		if(SegFromDate==null||SegFromDate.length()==0) SegFromDate=loan.getString("PutOutDate");
		rptSegment.setAttributeValue("SegFromDate", SegFromDate);
		String segToDate = rptSegment.getString("SegToDate");//������ʼ����
		if(segToDate==null||segToDate.length()==0) segToDate=loan.getString("MATURITYDATE");
		String lastDueDate = rptSegment.getString("LastDueDate");//�����ϴλ�������
		if(lastDueDate==null||lastDueDate.length()==0){//�·��Ŵ���ϴ�Ӧ������ʹ�÷ſ���
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
		
		//�����´λ�����
		String nextDueDate = "";
		
		if(DateFunctions.TERM_UNIT_MONTH.equals(paymentcycle.getString("TermUnit"))){//���ڰ��µĲ�ʹ����Щ����
			String firstInstalmentFlag=rptSegment.getString("FirstInstalmentFlag");//���ڻ���Լ��
			if(firstInstalmentFlag == null || "".equals(firstInstalmentFlag)) firstInstalmentFlag = loan.getString("FirstInstalmentFlag");//���ڻ���Լ��
			else loan.setAttributeValue("FirstInstalmentFlag", firstInstalmentFlag);
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) {
				String productID = loan.getString("BusinessType");
				String productVersion = ProductConfig.getProductNewestVersionID(productID);
				firstInstalmentFlag = ProductConfig.getProductTermParameterAttribute(productID,productVersion, rptSegment.getString("RPTTermID"), "FirstInstalmentFlag", "DefaultValue");
			}
				
			if(firstInstalmentFlag==null||firstInstalmentFlag.length()==0) 
				throw new LoanException("δָ�����ڻ���Լ��{FirstInstalmentFlag}��");
			else if(firstInstalmentFlag.equals("01")){//�ſ�»���
				//�ſ���+Ĭ�ϻ�����С�ڷſ����� �� �ſ���+Ĭ�ϻ����մ����µ׵����
				if((SegFromDate.substring(0,8) + defaultDueDay).compareTo(SegFromDate)<=0 
					|| DateFunctions.getEndDateOfMonth(SegFromDate.substring(0,8) + defaultDueDay).compareTo(SegFromDate.substring(0,8) + defaultDueDay) < 0){
					nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
					nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
				}else{
					nextDueDate = SegFromDate.substring(0,8) + defaultDueDay;
				}
			}
			else if(firstInstalmentFlag.equals("02")){//�ſ�²�����
				nextDueDate = DateFunctions.getRelativeDate(SegFromDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
				nextDueDate = (nextDueDate.substring(0, 8)+defaultDueDay).compareTo(DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)) < 0 ? (nextDueDate.substring(0, 8)+defaultDueDay) : DateFunctions.getEndDateOfMonth(nextDueDate.substring(0, 8)+defaultDueDay)  ;
			}
			else if(firstInstalmentFlag.equals("03")){//�ſ�»���̶����ڣ� ���� 3��6��9��12 ������ 6��12 ��˫�� 2��4��6��8��10��12
				if(Integer.valueOf(SegFromDate.substring(5, 7))%paymentcycle.getInt("Term") == 0)
				{
					//�ſ���+Ĭ�ϻ�����С�ڷſ����� �� �ſ���+Ĭ�ϻ����մ����µ׵����
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
			else if(firstInstalmentFlag.equals("04")){//�ſ�²�����̶����ڣ� ���� 3��6��9��12 ������ 6��12 ��˫�� 2��4��6��8��10��12
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
			else if(firstInstalmentFlag.equals("05")){//�ſ��Ԥ��Ϣ
				nextDueDate=SegFromDate;
			}
		}
		
		//����������죬Ŀǰ��˫�ܹ�
		if(DateFunctions.TERM_UNIT_DAY.equals(paymentcycle.getString("TermUnit"))){
			if("".equals(nextDueDate)){
				nextDueDate = DateFunctions.getRelativeDate(businessDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
			}
		}
		//���������״λ�����С�ڴ���ĵ�ǰ���ڣ���ѭ����n���������ڣ�ֱ������BusinessDate
		while(DateFunctions.compareDate(nextDueDate, businessDate)<=0){
			nextDueDate=DateFunctions.getRelativeDate(nextDueDate,paymentcycle.getString("TermUnit"),paymentcycle.getInt("Term"));
		}
		
		if(DateFunctions.compareDate(nextDueDate, maturitydate)>0){
			nextDueDate = maturitydate;
		}
		rptSegment.setAttributeValue("LastDueDate", SegFromDate);
			rptSegment.setAttributeValue("FirstDueDate", segToDate);
			rptSegment.setAttributeValue("NextDueDate", segToDate);
		//�������ռ�����
		rptSegment.setAttributeValue("LastDueDate", lastDueDate);
		rptSegment.setAttributeValue("FirstDueDate", nextDueDate);
		rptSegment.setAttributeValue("NextDueDate", nextDueDate);
		rptSegment.setAttributeValue("DefaultDueDay", defaultDueDay);
	}*/
	
	/**
	 * ���»��ʽ����������
	 * @param loan
	 * @throws Exception
	 */
	public static void updateLoanRptSegment(BusinessObject loan,AbstractBusinessObjectManager bomanager) throws Exception {
		String businessDate = loan.getString("BusinessDate");
		List<BusinessObject> rptList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		
		if(rptList==null||rptList.isEmpty()) return;
		for(BusinessObject a:rptList){
			String status=a.getString("Status");//״̬
			if(status==null||status.equals("2")) continue;//��ʧЧ�ļ�¼
			
			String SegFromDate=a.getString("SegFromDate");
			String SegToDate=a.getString("SegToDate");
			
			if((SegFromDate==null||SegFromDate.compareTo(businessDate)<=0)&&status.equals("3")){//����Ч
				a.setAttributeValue("Status", "1");//��Ϊ��Ч
				bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, a);
			}
			
			if(SegToDate!=null&&SegToDate.length()>0&&SegToDate.compareTo(businessDate)<0){//��Ϊ��Ч
				a.setAttributeValue("Status", "2");//��Ϊ��Ч
				bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, a);
			}
		}
	}

	/**
	 * ���´����״̬,�����ͳ��˵���Ҫ�ڽ����н����жϣ����ܵ��ô˷���
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
		
		if(overDueDays>0 &&"0".equals(loanStatus) ){//�����������������������������״̬Ϊ����
			loan.setAttributeValue("LoanStatus", "1");
		}
		else if(overDueDays<=0&&"1".equals(loanStatus)){//û���������������������ڣ������״̬Ϊ����
			loan.setAttributeValue("LoanStatus", "0");
		}
		if(Arith.round(normalBalance+overdueBalance+overdueInterest+fineInterest+compInterest+accrueInteBalance, 2)<=0d
				&&("0".equals(loanStatus) || "1".equals(loanStatus) || "5".equals(loanStatus))){//���û��Ƿ������Ϊ����
			ArrayList<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			if(paymentScheduleList!=null&&!paymentScheduleList.isEmpty()){
				//������ƻ���������
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
		
		//���������Գ�����Ҫ���´���״̬,�����󻹿�û�г��˿��Բ����ǣ�ֻ��Ҫ��������������
		if(Arith.round(normalBalance+overdueBalance+overdueInterest+fineInterest+compInterest, 2)>0d
				&&( !"0".equals(loanStatus) && !"1".equals(loanStatus) && !"5".equals(loanStatus) )){
			if(overDueDays > 0) loanStatus = "1";
			else loanStatus = "0";
			loan.setAttributeValue("LoanStatus", loanStatus);
		}
				
		//���½���״̬�ͽ������ڣ���������Ϣ
		if(Arith.round(normalBalance+overdueBalance+overdueInterest+accrueInteBalance, 2)==0d
				&&("".equals(loan.getString("SettleDate")) || loan.getString("SettleDate") == null)){
			loan.setAttributeValue("SettleDate", businessDate);//��������Ϣ��������
		}
		else if(Arith.round(normalBalance+overdueBalance+overdueInterest+accrueInteBalance, 2)>0d){
			loan.setAttributeValue("SettleDate", "");//��������Ϣ��������
		}
		//������Ϣ�Ľ�������
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