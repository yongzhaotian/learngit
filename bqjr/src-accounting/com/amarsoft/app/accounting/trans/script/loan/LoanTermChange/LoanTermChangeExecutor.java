package com.amarsoft.app.accounting.trans.script.loan.LoanTermChange;

//���������ǰ����
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.are.ARE;

public class LoanTermChangeExecutor implements ITransactionExecutor{
	
	
	private ITransactionScript transactionScript;

	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		this.transactionScript = transactionScript;
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		BusinessObject oldLoan = loan.cloneObject();
		String oldMaturityDate = loan.getString("MaturityDate");
		loanChange.setAttributeValue("OLDMaturityDate", oldMaturityDate);
		//�����Ĵ������
		String newMaturityDate = loanChange.getString("MaturityDate"); 
		if(oldMaturityDate.equals(newMaturityDate)){
			ARE.getLog().info("�¾ɵ�������ͬ�����������");
			return 1;
		}
		loan.setAttributeValue("MaturityDate", newMaturityDate);
		
		List<BusinessObject> rateList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		for (BusinessObject a:rateList){	
			String status = a.getString("Status");
			if(!status.equals("1")) continue; 
			String oldSegToDate=a.getString("SegToDate");
			if(oldSegToDate!=null&&(oldSegToDate.compareTo(newMaturityDate)>0||oldSegToDate.equals(oldMaturityDate))){
				a.setAttributeValue("SegToDate", newMaturityDate);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,a);
			}
		}
		
		if("1".equals(loanChange.getString("RepriceRateFlag"))){//����������׼����
			updateSegment();
		}
		//�����ڹ�
		List<BusinessObject> rptList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		for (BusinessObject a:rptList){	
			String status = a.getString("Status");
			if(!status.equals("1")) continue; 
			String oldSegToDate=a.getString("SegToDate");
			if(oldSegToDate!=null&&(oldSegToDate.compareTo(newMaturityDate)>0||oldSegToDate.equals(oldMaturityDate))){
				a.setAttributeValue("SegToDate", newMaturityDate);
			}
			
			int t=RPTFunctions.getPeriodScript(oldLoan, a).getTotalPeriod(loan,a);
			a.setAttributeValue("TotalPeriod", t);
			a.setAttributeValue("NextDueDate", RPTFunctions.getDueDateScript(loan, a).getNextPayDate(loan,a));
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,a);
		}
		
		
		//���»���ƻ�
		loan.setAttributeValue("UpdateInstalAmtFlag", "1");
		loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loanChange);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
	
		return 1;
	}
	
	//����
	private void updateSegment() throws  Exception{
		BusinessObject transaction = transactionScript.getTransaction();
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		String putoutDate = loan.getString("PutoutDate");
		String lastRepriceDate = loan.getString("LastRepriceDate");
		String businessDate = loan.getString("BusinessDate");
		if(lastRepriceDate==null||lastRepriceDate.length()==0)
			lastRepriceDate=putoutDate;
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Normal);

		for(BusinessObject rateSegment:rateList){
			String status = rateSegment.getString("Status");
			String segToDate=rateSegment.getString("SegToDate");
			if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(businessDate)<=0){//����(��)�ѵ���,���ٸ���
				continue;
			}
			if(status==null||!status.equals("1")) continue;
			if(!ACCOUNT_CONSTANTS.RateType_Normal.equals(rateSegment.getString("RateType"))  && !ACCOUNT_CONSTANTS.RateType_Discount.equals(rateSegment.getString("RateType")) || ACCOUNT_CONSTANTS.RateMode_Fix.equals(rateSegment.getString("RateMode"))) continue;
			rateSegment.setAttributeValue("BaseRateGrade", "");
			double newBaseRate = RateFunctions.getBaseRate(loan, rateSegment);
			createRateSegment(loan,rateSegment,newBaseRate);
		}
		
		rateList = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Overdue);
		for(BusinessObject rateSegment:rateList){
			String status = rateSegment.getString("Status");
			String rateType = rateSegment.getString("RateType");
			String segToDate=rateSegment.getString("SegToDate");
			if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(businessDate)<=0){//�����ѵ���,���ڸ���
				continue;
			}
			if(status==null||!status.equals("1")) continue;
			if(rateType.equals(ACCOUNT_CONSTANTS.RateType_Overdue) && !ACCOUNT_CONSTANTS.RateMode_Fix.equals(rateSegment.getString("RateMode"))) {//����ִ������
				rateSegment.setAttributeValue("BaseRateGrade", "");
				double fineBaseRate = RateFunctions.getBaseRate(loan,rateSegment);
				createRateSegment(loan,rateSegment,fineBaseRate);
			}
		}
	}
	
	private BusinessObject createRateSegment(BusinessObject loan,BusinessObject rateSegment,double newBaseRate) throws Exception{
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		double baseRate = rateSegment.getDouble("BaseRate");
		double businessRate = rateSegment.getDouble("BusinessRate");
		double newBusinessRate = businessRate;//Ĭ�����
		if(Math.abs(baseRate-newBaseRate) >= 0.0000000001){//����ִ������
			BusinessObject newRateSegment = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,boManager);
			newRateSegment.setValue(rateSegment);
			newRateSegment.setAttributeValue("BaseRate", newBaseRate);
			String businessDate = loan.getString("BusinessDate");//���������
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
			
			return newRateSegment;
		}
		return null;
	}


}