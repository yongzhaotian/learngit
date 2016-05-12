package com.amarsoft.app.accounting.trans.script.loan.eod;
 
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.RateFunctions;

public class LoanBODExecutor_reprice implements ITransactionExecutor{
	
	private ITransactionScript transactionScript;


	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		BusinessObject transaction = transactionScript.getTransaction();
		
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		
		//4、更新利率重定价信息
		this.updateRepriceLog(loan);
		
		return 1;
	}
	
	private void updateRepriceLog(BusinessObject loan) throws Exception{
		//利率调整，当为利率调整日时，则获取最新利率，并计算下次调整日
		String businessdate = loan.getString("BusinessDate");//贷款处理时间
		String nextRepriceDate = loan.getString("NextRepriceDate"); //下次利率调整日期

		List<BusinessObject> rateSegmentList = InterestFunctions.getRateSegmentList(loan
				, ACCOUNT_CONSTANTS.RateType_Normal+","+ACCOUNT_CONSTANTS.RateType_Overdue);//利率信息
		if(rateSegmentList==null||rateSegmentList.isEmpty()) return;
			//throw new LoanException("贷款{"+loan.getObjectNo()+"}不存在利率信息!");
		//基准利率重定价
		if(businessdate.equals(nextRepriceDate)){
			for(BusinessObject rateSegment:rateSegmentList){
				String status = rateSegment.getString("Status");
				String segToDate=rateSegment.getString("SegToDate");
				if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(businessdate)<=0){//当天(含)已到期,则不再更新
					continue;
				}
				if(status==null||!status.equals("1")) continue;
				if(!ACCOUNT_CONSTANTS.RateType_Normal.equals(rateSegment.getString("RateType")) && !ACCOUNT_CONSTANTS.RateType_Discount.equals(rateSegment.getString("RateType")) || ACCOUNT_CONSTANTS.RateMode_Fix.equals(rateSegment.getString("RateMode"))) continue;
				double newBaseRate = RateFunctions.getBaseRate(loan,rateSegment);
				createRepriceLog(loan,rateSegment,newBaseRate);
			}
			
			loan.setAttributeValue("NextRepriceDate", RateFunctions.getNextRepriceDate(loan));
			
			//更新罚息
			List<BusinessObject> ls = InterestFunctions.getActiveRateSegment(loan, ACCOUNT_CONSTANTS.RateType_Overdue);
			if(ls != null && !ls.isEmpty())
			{
				for(BusinessObject rateSegment:rateSegmentList){
					String status = rateSegment.getString("Status");
					String rateType = rateSegment.getString("RateType");
					String segToDate=rateSegment.getString("SegToDate");
					if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(businessdate)<=0){//当天已到期,则不在更新
						continue;
					}
					
					if(status==null||!status.equals("1")) continue;
					if(rateType.equals(ACCOUNT_CONSTANTS.RateType_Overdue) && !ACCOUNT_CONSTANTS.RateMode_Fix.equals(rateSegment.getString("RateMode"))) {//贷款执行利率
						double fineBaseRate = RateFunctions.getBaseRate(loan,rateSegment);
						createRepriceLog(loan,rateSegment,fineBaseRate);
					}
				}
			}
		}
	}
	
	private void createRepriceLog(BusinessObject loan,BusinessObject rateSegment,double newBaseRate) throws Exception{
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		double baseRate = rateSegment.getDouble("BaseRate");
		double businessRate = rateSegment.getDouble("BusinessRate");
		String businessdate = loan.getString("BusinessDate");//贷款处理时间
		
		double newBusinessRate = businessRate;//默认相等
		if(Math.abs(baseRate-newBaseRate) >= 0.0000000001){//重算执行利率
			BusinessObject newRateSegment = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,boManager);
			newRateSegment.setValue(rateSegment);
			if(rateSegment.getString("SegFromDate") == null || businessdate.compareTo(rateSegment.getString("SegFromDate")) > 0)
				newRateSegment.setAttributeValue("SegFromDate", businessdate);
			newRateSegment.setAttributeValue("BaseRate", newBaseRate);
			newBusinessRate = RateFunctions.getBusinessRate(loan, newRateSegment);
			if(Math.abs(newBusinessRate-businessRate) >= 0.000000001){
				newRateSegment.setAttributeValue("BusinessRate", newBusinessRate);
				rateSegment.setAttributeValue("SegToDate", businessdate);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, rateSegment);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newRateSegment);
				loan.setRelativeObject(newRateSegment);
				//如果
				if(ACCOUNT_CONSTANTS.RateType_Normal.equals(rateSegment.getString("RateType"))
						&& loan.getString("maturitydate").compareTo(businessdate) >= 0 ){
					loan.setAttributeValue("LastRepriceDate", businessdate);
					loan.setAttributeValue("UpdatePMTSchdFlag", "1");
					loan.setAttributeValue("UpdateInstalAmtFlag", "1");
				}
			}
		}
	}


}