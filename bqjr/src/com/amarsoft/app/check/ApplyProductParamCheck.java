package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.app.accounting.product.ProductManage;

public class ApplyProductParamCheck extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		String sSerialNo = (String)this.getAttribute("ObjectNo");
		if(sSerialNo == null) sSerialNo = "";
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		BusinessObject businessApply = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_apply, sSerialNo);
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectNo", sSerialNo);
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_apply);
		List <BusinessObject> rateList =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
		List <BusinessObject> rptList =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
		List <BusinessObject> feeList =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
		businessApply.setRelativeObjects(rateList);
		businessApply.setRelativeObjects(rptList);
		businessApply.setRelativeObjects(feeList);
		BusinessObject customer =  bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.customer,businessApply.getString("CustomerID"));
		businessApply.setAttributeValue("CustomerType", customer.getString("CustomerType"));
		
		ProductManage pm = new ProductManage(Sqlca);
		ASValuePool result = pm.checkBusinessObject(businessApply);
		
		Object[] keys = result.getKeys();
		for(Object k:keys)
		{
			this.putMsg(result.getString((String)k));
		}
		
		/* 返回结果处理 */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
	
}
