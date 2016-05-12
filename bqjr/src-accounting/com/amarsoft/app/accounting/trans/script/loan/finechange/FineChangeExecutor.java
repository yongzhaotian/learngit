package com.amarsoft.app.accounting.trans.script.loan.finechange;

import java.util.List;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.RateFunctions;

public class FineChangeExecutor implements ITransactionExecutor{
	
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));

		List<BusinessObject> rateList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		List<BusinessObject> newRateList=loanChange.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);

		//对旧罚息利率处理
		String businessDate = loan.getString("BusinessDate");
		if(rateList!=null){
			for (BusinessObject a:rateList){
				if(!"1".equals(a.getString("Status")) && !"3".equals(a.getString("Status"))) continue;
				String ratetype = a.getString("RateType");
				if(ratetype==null || !ratetype.equals(ACCOUNT_CONSTANTS.RateType_Overdue)) continue;
				String segToDate=a.getString("SegToDate");
				//将原生效利率信息到期日置为当前日期
				if(segToDate==null||"".equals(segToDate)){
					a.setAttributeValue("SegToDate", businessDate);
				}
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,a);
			}
		}
		
		double businessRate = 0d;
		//对新罚息利率处理
		if(newRateList!=null&&!newRateList.isEmpty()){
			for(BusinessObject bo: newRateList){
				String ratetype = bo.getString("RateType");
				if(ratetype==null || !ACCOUNT_CONSTANTS.RateType_Overdue.equals(ratetype)) continue;
				bo.setAttributeValue("Status", "1");
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bo);
				BusinessObject newRate = new BusinessObject(bo.getObjectType(),boManager);
				newRate.setValue(bo);
				newRate.setAttributeValue("SegFromDate", businessDate);
				newRate.setAttributeValue("ObjectNo", loan.getObjectNo());
				newRate.setAttributeValue("ObjectType", loan.getObjectType());
				if(newRate.getString("RateUnit") == null || "".equals(newRate.getString("RateUnit"))){
					newRate.setAttributeValue("RateUnit", "01");
				}
				int yearDays = newRate.getInt("YearDays");
				if(yearDays<=0){
					yearDays=RateFunctions.getBaseDays(loan.getString("Currency"));
					newRate.setAttributeValue("YearDays",yearDays);
				}
				
				double baseRate = RateFunctions.getBaseRate(loan,newRate);
				newRate.setAttributeValue("BaseRate", baseRate);//基准利率
				businessRate = RateFunctions.getBusinessRate(loan,newRate);
				newRate.setAttributeValue("BusinessRate", RateFunctions.getRate(yearDays,ACCOUNT_CONSTANTS.RateUnit_Year,businessRate,newRate.getString("RateUnit")));//执行利率
								
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newRate);
				loan.setRelativeObject(newRate);
			}			
		}
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loanChange);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		return 1;
	}	
}