package com.amarsoft.app.accounting.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.rpt.ps.IPaymentScheduleScript;

public class PaymentScheduleFunctions {
	
	/**
	 * ��ȡpaydate<=businessDate��ָ�����͵�δ����Ļ���ƻ�
	 * @param loan
	 * @param payType
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getPassDuePaymentScheduleList(BusinessObject loan,String payType) throws Exception {	
		List<BusinessObject> psList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		List<BusinessObject> activeList= new ArrayList<BusinessObject>();
		if(psList==null) return activeList;
		
		String businessDate=loan.getString("BusinessDate");
		for(BusinessObject a:psList){
			String payType_T = a.getString("PayType");
			if(payType_T==null||payType_T.length()==0) throw new Exception("����ƻ���SerialNo="+a.getObjectNo()+"����PayTypeΪ�գ�");
			if(payType!=null&&payType.length()>0&&payType.indexOf(payType_T)<0)	continue;
			String finishDate = a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0)	continue;
			String payDate = a.getString("PayDate");
			if(payDate.compareTo(businessDate)<=0)//�����ڣ�������Ҳ����
				activeList.add(a);
		}
		return activeList;
	}

	/**
	 * ��ȡ�ѵ���δ���廹��ƻ��У��뵱ǰ�����������Ļ���ƻ���<br/>
	 * ���÷���ǰ�豣֤���л���ƻ����ǰ�Ӧ�����ڴ�С��������õ�
	 * 
	 * @param loan
	 * @param payType
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getPassDuePaymentSchedule(BusinessObject loan, String payType) throws Exception {
		List<BusinessObject> paymentSchedules = getPassDuePaymentScheduleList(loan, payType);
		if (AccountingHelper.isEmpty(paymentSchedules)) {
			return null;
		}
		return paymentSchedules.get(paymentSchedules.size() - 1);
	}
	
		/**
	 * ��ȡָ���������͵ģ�Ӧ�����ڷ�ΧΪ[fromDate,toDate]֮���δ���廹��ƻ��б�</br>
	 * NOTE:��������û��Ҫ�󷵻ص���δ������ƻ��������ڻ���ƻ�
	 * 
	 * @param loan
	 * @param payType
	 * @param fromDate
	 * @param toDate
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getPaymentScheduleList(BusinessObject loan, String payType, String fromDate,
			String toDate) throws Exception {
		List<BusinessObject> paymentSchedules = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		List<BusinessObject> result = new ArrayList<BusinessObject>();

		if (AccountingHelper.isEmpty(paymentSchedules)) {
			return result;
		}

		String psPayType = null;
		String finishDate = null;
		String payDate = null;
		for (BusinessObject paymentSchedule : paymentSchedules) {
			psPayType = paymentSchedule.getString("PayType");
			//Assertions.notEmpty("����ƻ��Ļ�������", psPayType);

			finishDate = paymentSchedule.getString("FinishDate");
			payDate = paymentSchedule.getString("PayDate");

			// ���ͷ��ϡ�δ������Ӧ��������ָ����Χ��
			if ((AccountingHelper.contains(payType, psPayType) || AccountingHelper.isEmpty(payType))
					&& AccountingHelper.isEmpty(finishDate) && payDate.compareTo(fromDate) >= 0
					&& (AccountingHelper.isEmpty(toDate) || payDate.compareTo(toDate) <= 0)) {
				result.add(paymentSchedule);
			}

		}
		return result;
	}

	/**
	 * ��ȡpaydate<=businessDate��ָ�����͵�δ����Ļ���ƻ�
	 * @param loan
	 * @param payType
	 * @return
	 * @throws Exception
	 */
	public static ArrayList<BusinessObject> getPaymentScheduleList(BusinessObject loan,String payType,String fromDate,String toDate,String indicator) throws Exception {	
		ArrayList<BusinessObject> psList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		ArrayList<BusinessObject> activeList= new ArrayList<BusinessObject>();
		if(psList==null) return activeList;
		for(BusinessObject a:psList){
			String payType_T = a.getString("PayType");
			if(payType_T==null||payType_T.length()==0) throw new Exception("����ƻ���SerialNo="+a.getObjectNo()+"����PayTypeΪ�գ�");
			if(payType!=null&&payType.length()>0&&payType.indexOf(payType_T)<0)	continue;
			String finishDate = a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0)	continue;
			String payDate = a.getString("PayDate");
			if(payDate.compareTo(fromDate)>=0){//�����ڣ�������Ҳ����
				if(toDate==null||toDate.length()==0||payDate.compareTo(toDate)<=0){
					activeList.add(a);
				}
			}
		}
		return activeList;
	}
	
	/**
	 * ��ȡpaydate > businessDate��ָ�����͵�δ���Ļ���ƻ�
	 * @param loan
	 * @param payType
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getFuturePaymentScheduleList(BusinessObject loan,String payType) throws Exception {	
		List<BusinessObject> psList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		List<BusinessObject> activeList= new ArrayList<BusinessObject>();
		if(psList==null) return activeList;
		
		String businessDate=loan.getString("BusinessDate");
		for(BusinessObject a:psList){
			String payType_T = a.getString("PayType");
			if(payType!=null&&payType.length()>0&&payType.indexOf(payType_T)<0)	continue;
			String finishDate = a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0)	continue;
			String payDate = a.getString("PayDate");
			if(payDate.compareTo(businessDate)>0)//�����ڣ�������Ҳ����
				activeList.add(a);
		}
		return activeList;
	}
	
	/**
	 * ��ȡpaydate > businessDate��ָ�����͵�δ���Ļ���ƻ�
	 * @param loan
	 * @param payType
	 * @return
	 * @throws Exception
	 */
	public static void removeFuturePaymentScheduleList(BusinessObject loan,String payType,AbstractBusinessObjectManager bom) throws Exception {	
		List<BusinessObject> psList = PaymentScheduleFunctions.getFuturePaymentScheduleList(loan, payType);
		loan.removeRelativeObjects(psList);
		if(bom!=null){
			bom.setBusinessObjects(AbstractBusinessObjectManager.operateflag_delete, psList);
		}
	}
	
	/**
	 * ��ȡintedate<=businessDate��ָ�����͵�δ����Ļ���ƻ������ǽڼ���˳�Ӻ�ı���
	 * @param loan
	 * @param payType
	 * @return
	 * @throws Exception
	 */
	public static ArrayList<BusinessObject> getOverDuePaymentScheduleList(BusinessObject loan,String payType) throws Exception {	
		ArrayList<BusinessObject> psList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		ArrayList<BusinessObject> activeList= new ArrayList<BusinessObject>();
		if(psList==null) return activeList;
		
		String businessDate=loan.getString("BusinessDate");
		for(BusinessObject a:psList){
			String payType_T = a.getString("PayType");
			if(payType!=null&&payType.length()>0&&payType.indexOf(payType_T)<0)	continue;
			String finishDate = a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0)	continue;
			String payDate = a.getString("HolidayinteDate");
			if(payDate == null || payDate.equals("")) payDate = a.getString("PayDate");
			if(payDate.compareTo(businessDate)<=0)//�����ڣ�������Ҳ����
				activeList.add(a);
		}
		return activeList;
	}
	
	public static List<BusinessObject> createLoanPaymentScheduleList(BusinessObject loan,String toDate,AbstractBusinessObjectManager bomanager) throws Exception{
		IPaymentScheduleScript paymentScheduleScript = RPTFunctions.getPaymentScheduleScript(loan);
		return (ArrayList<BusinessObject>)paymentScheduleScript.createPaymentScheduleList(loan, toDate, bomanager);
	}

}