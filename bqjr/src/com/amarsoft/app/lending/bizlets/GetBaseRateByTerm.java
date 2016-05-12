package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetBaseRateByTerm extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		String objectType = (String) this.getAttribute("ObjectType");
		String objectNo = (String) this.getAttribute("ObjectNo");
		String baseRateType = (String) this.getAttribute("BaseRateType");
		String rateUnit = (String) this.getAttribute("RateUnit");
		String baseRateGrade = (String) this.getAttribute("BaseRateGrade");
		String currency = (String)this.getAttribute("Currency");
		
		if(objectType == null || objectNo == null)throw new Exception("�������Ͳ���Ϊ�գ�");
		if(objectType == null || objectNo == null)throw new Exception("�����Ų���Ϊ�գ�");
		if(baseRateType == null || baseRateType == null)throw new Exception("��׼�������Ͳ���Ϊ�գ�");
		if(rateUnit == null || rateUnit == null)throw new Exception("���ʵ�λ����Ϊ�գ�");
		double baseRate = 0.0;
		if("100".equals(baseRateType))
		{
			BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(objectType, objectNo, Sqlca);
			AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", objectNo);
			as.setAttribute("ObjectType", businessObject.getObjectType());
			as.setAttribute("RateType", "01");
			as.setAttribute("RateUnit", rateUnit);
			as.setAttribute("Status", "2");
			List<BusinessObject> rateList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType and RateType=:RateType and RateUnit=:RateUnit and Status<>:Status", as);
			if(rateList.size()==0) baseRate = 0;
			else baseRate = rateList.get(0).getDouble("BusinessRate");
		}
		else if("060".equals(baseRateType)){
			return "";
		}
		else
		{
			if(baseRateGrade == null || baseRateGrade == null)throw new Exception("��׼���ʵ��β���Ϊ�գ�");
			int term = Integer.parseInt(baseRateGrade.split("@")[0]);
			String termUnit = baseRateGrade.split("@")[1];
			
			baseRate = RateConfig.getBaseRate(currency,RateFunctions.getBaseDays(currency),baseRateType,rateUnit,termUnit,term,SystemConfig.getBusinessDate());
		}
		return String.valueOf(baseRate);
	}

}
