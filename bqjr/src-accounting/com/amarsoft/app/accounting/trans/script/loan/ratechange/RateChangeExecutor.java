package com.amarsoft.app.accounting.trans.script.loan.ratechange;

//���������ǰ����
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.RateFunctions;

public class RateChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));

		List<BusinessObject> rateList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		List<BusinessObject> newRateList=loanChange.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		loan.setAttributeValue("LoanRateTermID", loanChange.getString("LoanRateTermID"));

		//�Ծ����ʴ���
		String businessDate = loan.getString("BusinessDate");
		if(rateList!=null){
			for (BusinessObject a:rateList){
				if(!"1".equals(a.getString("Status")) && !"3".equals(a.getString("Status"))) continue;
				String ratetype = a.getString("RateType");
				if(ratetype==null || !ratetype.equals(ACCOUNT_CONSTANTS.RateType_Normal)) continue;
				String segToDate=a.getString("SegToDate");
				//��ԭ��Ч������Ϣ��������Ϊ��ǰ����
				if(segToDate==null||"".equals(segToDate)){
					a.setAttributeValue("SegToDate", businessDate);
				}
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,a);
			}
		}
		
		double businessRate = 0d;
		//�������ʴ���
		if(newRateList!=null&&!newRateList.isEmpty()){
			//��������
			for(BusinessObject bo: newRateList){
				String ratetype = bo.getString("RateType");
				if(ratetype==null || !ACCOUNT_CONSTANTS.RateType_Normal.equals(ratetype) && !ACCOUNT_CONSTANTS.RateType_Discount.equals(ratetype) ) continue;
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
				newRate.setAttributeValue("BaseRate", baseRate);//��׼����
				businessRate = RateFunctions.getBusinessRate(loan,newRate);
				newRate.setAttributeValue("BusinessRate", RateFunctions.getRate(yearDays,ACCOUNT_CONSTANTS.RateUnit_Year,businessRate,newRate.getString("RateUnit")));//ִ������
								
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newRate);
				loan.setRelativeObject(newRate);
			}
			
			
			//���㻹��ƻ���ʶ
			loan.setAttributeValue("UpdateInstalAmtFlag", "1");
			loan.setAttributeValue("UpdatePMTSchdFlag", "1");
		}
		//���·�Ϣ
		updateFinRateSegment(loan,boManager);
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loanChange);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		return 1;
	}
	
	private void updateFinRateSegment(BusinessObject loan, AbstractBusinessObjectManager boManager) throws Exception{
		List<BusinessObject>rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Overdue);
		String businessDate = loan.getString("BusinessDate");
		for(BusinessObject rateSegment : rateList) {
			String status = rateSegment.getString("Status");
			String rateType = rateSegment.getString("RateType");
			String segToDate=rateSegment.getString("SegToDate");
			if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(businessDate)<=0){//�����ѵ���,���ڸ���
				continue;
			}
			if(status==null||!status.equals("1")) continue;
			if(!rateType.equals(ACCOUNT_CONSTANTS.RateType_Overdue) || ACCOUNT_CONSTANTS.RateMode_Fix.equals(rateSegment.getString("RateMode"))) continue;
			rateSegment.setAttributeValue("BaseRateGrade", "");
			double fineBaseRate = RateFunctions.getBaseRate(loan,rateSegment);
			double baseRate = rateSegment.getDouble("BaseRate");
			double businessRate = rateSegment.getDouble("BusinessRate");
			double newBusinessRate = businessRate;//Ĭ�����
			if(Math.abs(baseRate-fineBaseRate) >= 0.0000000001){//����ִ������
				BusinessObject newRateSegment = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,boManager);
				newRateSegment.setValue(rateSegment);
				newRateSegment.setAttributeValue("BaseRate", fineBaseRate);
				newRateSegment.setAttributeValue("SegFromDate", businessDate);
				newBusinessRate = RateFunctions.getBusinessRate(loan, newRateSegment);
				if(Math.abs(newBusinessRate-businessRate) >= 0.0000000001){
					//�����ʲ���һ�ʼ�¼
					newRateSegment.setAttributeValue("BusinessRate", newBusinessRate);
					//�����ʼ�¼�޸������䵽����Ϊ���������
					rateSegment.setAttributeValue("SegToDate", businessDate);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rateSegment);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newRateSegment);
					loan.setRelativeObject(newRateSegment);
				}		
			}
		}
	}
	
}