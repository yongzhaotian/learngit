package com.amarsoft.app.accounting.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;
//TODO:工具类继承？
public class PaymentScheduleFunctionsForHead extends PaymentScheduleFunctions {
	
	/**
	 * 获取paydate >= businessDate的指定类型的未来的还款计划
	 * @param loan
	 * @param payType
	 * @return 
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public static   List<BusinessObject> getFuturePaymentScheduleList(BusinessObject loan,String payType) throws Exception {	
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", loan.getObjectType());
		List<BusinessObject> psList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, as);
		List<BusinessObject> activeList= new ArrayList<BusinessObject>();
		if(psList==null) return activeList;
		
		String businessDate=loan.getString("BusinessDate");
		for(BusinessObject a:psList){
			String payType_T = a.getString("PayType");
			if(payType!=null&&payType.length()>0&&payType.indexOf(payType_T)<0)	continue;
			String finishDate = a.getString("FinishDate");
			if(finishDate!=null&&finishDate.length()>0)	continue;
			String payDate = a.getString("PayDate");
			if(payDate.compareTo(businessDate)>=0)//含等于，即当期也包含
				activeList.add(a);
		}
		return activeList;
	}
}