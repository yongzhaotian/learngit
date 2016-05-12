package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.ArrayList;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.settle.IInterestSettle;
import com.amarsoft.app.accounting.interest.settle.InterestSettleFunctions;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.rpt.pmt.IPMTScript;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;

/**
 * @author xjzhao 2011/04/02
 * 
 */
public class LoanBODExecutor_settleinterest implements ITransactionExecutor{
	

	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		String businessDate=loan.getString("BusinessDate");
		
		/*//结算利息
		Object[] interestTypeList = RateConfig.getInterestConfigSet().getKeys();
		for(Object interstTypeO:interestTypeList){
			String interestType = (String)interstTypeO;
			
			IInterestSettle interestScript = InterestSettleFunctions.getSettleInterestScript(interestType);
			if(interestScript == null) throw new DataException("利率类型"+interestType+"未定义结息脚本!");
			
			String interestObjectType = RateConfig.getInterestConfig(interestType, "InterestObjectType");
			if(interestObjectType==null||interestObjectType.length()==0){
				//throw new DataException("利息类型InterestConfig="+interestType+"未找到定义的InterestObjectType属性!");
				continue;
			}
			
			if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.loan)){
				String nextSettleDate = InterestSettleFunctions.getNextInteSettleDate(loan, loan, interestType);
				if(nextSettleDate.equals(businessDate)){
					interestScript.settleInterest(loan,loan, businessDate,interestType,transactionScript.getBOManager());
				}
			}
			else if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)){
				//取未结清的正常还款计划，只取PayType=1的记录
				ArrayList<BusinessObject> paymentScheduleList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
				for(BusinessObject paymentSchedule:paymentScheduleList){
					String nextSettleDate = InterestSettleFunctions.getNextInteSettleDate(loan, paymentSchedule, interestType);
					String lastSettleDate = InterestSettleFunctions.getLastInteSettleDate(loan, paymentSchedule,interestType);
					if(nextSettleDate.compareTo(lastSettleDate)>0&&nextSettleDate.equals(businessDate)){
						interestScript.settleInterest(loan,paymentSchedule, businessDate,interestType,transactionScript.getBOManager());
					}
				}
			}
			else{
				throw new DataException("利息类型InterestConfig="+interestType+"定义的InterestObjectType属性无效!");
			}
		}*/
		
		//3、到了下次还款日,进行结息处理，更新还款信息，如RPT中的还款日期、剩余金额、期供等
		ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(rptList!=null&&!rptList.isEmpty()){
			for(BusinessObject rptSegment:rptList){
				if(!businessDate.equals(rptSegment.getString("NextDueDate"))) continue;//不处理
				
				//没有赋值的，都不重算，否则会将移植过来的期供值覆盖掉，造成提前还款保持期供时可能会发生变化。
				String updateInstalAmtFlag = rptSegment.getString("UpdateInstalAmtFlag");
				if(updateInstalAmtFlag==null||updateInstalAmtFlag.length()==0)
					rptSegment.setAttributeValue("UpdateInstalAmtFlag", "0");
				IPMTScript pmtScript = RPTFunctions.getPMTScript(loan, rptSegment);
				if(pmtScript!=null) pmtScript.nextInstalment(loan,rptSegment);//进入下一个还款期次，并更新下次还款日及其他属性
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rptSegment);
				loan.setAttributeValue("LastDueDate", businessDate);
			}
		}
	
		return 1;
	}
}
