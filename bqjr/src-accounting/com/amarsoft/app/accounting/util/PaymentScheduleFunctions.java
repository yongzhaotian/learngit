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
	 * 获取paydate<=businessDate的指定类型的未还清的还款计划
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
			if(payType_T==null||payType_T.length()==0) throw new Exception("还款计划｛SerialNo="+a.getObjectNo()+"｝的PayType为空！");
			if(payType!=null&&payType.length()>0&&payType.indexOf(payType_T)<0)	continue;
			String finishDate = a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0)	continue;
			String payDate = a.getString("PayDate");
			if(payDate.compareTo(businessDate)<=0)//含等于，即当期也包含
				activeList.add(a);
		}
		return activeList;
	}

	/**
	 * 获取已到期未结清还款计划中，与当前会计日期最近的还款计划。<br/>
	 * 调用方法前需保证所有还款计划都是按应还日期从小到达排序好的
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
	 * 获取指定还款类型的，应还日期范围为[fromDate,toDate]之间的未结清还款计划列表。</br>
	 * NOTE:本方法并没有要求返回的是未来还款计划还是逾期还款计划
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
			//Assertions.notEmpty("还款计划的还款类型", psPayType);

			finishDate = paymentSchedule.getString("FinishDate");
			payDate = paymentSchedule.getString("PayDate");

			// 类型符合、未结清且应还日期在指定范围内
			if ((AccountingHelper.contains(payType, psPayType) || AccountingHelper.isEmpty(payType))
					&& AccountingHelper.isEmpty(finishDate) && payDate.compareTo(fromDate) >= 0
					&& (AccountingHelper.isEmpty(toDate) || payDate.compareTo(toDate) <= 0)) {
				result.add(paymentSchedule);
			}

		}
		return result;
	}

	/**
	 * 获取paydate<=businessDate的指定类型的未还清的还款计划
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
			if(payType_T==null||payType_T.length()==0) throw new Exception("还款计划｛SerialNo="+a.getObjectNo()+"｝的PayType为空！");
			if(payType!=null&&payType.length()>0&&payType.indexOf(payType_T)<0)	continue;
			String finishDate = a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0)	continue;
			String payDate = a.getString("PayDate");
			if(payDate.compareTo(fromDate)>=0){//含等于，即当期也包含
				if(toDate==null||toDate.length()==0||payDate.compareTo(toDate)<=0){
					activeList.add(a);
				}
			}
		}
		return activeList;
	}
	
	/**
	 * 获取paydate > businessDate的指定类型的未来的还款计划
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
			if(payDate.compareTo(businessDate)>0)//含等于，即当期也包含
				activeList.add(a);
		}
		return activeList;
	}
	
	/**
	 * 获取paydate > businessDate的指定类型的未来的还款计划
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
	 * 获取intedate<=businessDate的指定类型的未还清的还款计划，考虑节假日顺延后的本金
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
			if(payDate.compareTo(businessDate)<=0)//含等于，即当期也包含
				activeList.add(a);
		}
		return activeList;
	}
	
	public static List<BusinessObject> createLoanPaymentScheduleList(BusinessObject loan,String toDate,AbstractBusinessObjectManager bomanager) throws Exception{
		IPaymentScheduleScript paymentScheduleScript = RPTFunctions.getPaymentScheduleScript(loan);
		return (ArrayList<BusinessObject>)paymentScheduleScript.createPaymentScheduleList(loan, toDate, bomanager);
	}

}