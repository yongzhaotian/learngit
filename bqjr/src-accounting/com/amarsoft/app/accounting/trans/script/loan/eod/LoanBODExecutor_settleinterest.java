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
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		String businessDate=loan.getString("BusinessDate");
		
		/*//������Ϣ
		Object[] interestTypeList = RateConfig.getInterestConfigSet().getKeys();
		for(Object interstTypeO:interestTypeList){
			String interestType = (String)interstTypeO;
			
			IInterestSettle interestScript = InterestSettleFunctions.getSettleInterestScript(interestType);
			if(interestScript == null) throw new DataException("��������"+interestType+"δ�����Ϣ�ű�!");
			
			String interestObjectType = RateConfig.getInterestConfig(interestType, "InterestObjectType");
			if(interestObjectType==null||interestObjectType.length()==0){
				//throw new DataException("��Ϣ����InterestConfig="+interestType+"δ�ҵ������InterestObjectType����!");
				continue;
			}
			
			if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.loan)){
				String nextSettleDate = InterestSettleFunctions.getNextInteSettleDate(loan, loan, interestType);
				if(nextSettleDate.equals(businessDate)){
					interestScript.settleInterest(loan,loan, businessDate,interestType,transactionScript.getBOManager());
				}
			}
			else if(interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)){
				//ȡδ�������������ƻ���ֻȡPayType=1�ļ�¼
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
				throw new DataException("��Ϣ����InterestConfig="+interestType+"�����InterestObjectType������Ч!");
			}
		}*/
		
		//3�������´λ�����,���н�Ϣ�������»�����Ϣ����RPT�еĻ������ڡ�ʣ����ڹ���
		ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(rptList!=null&&!rptList.isEmpty()){
			for(BusinessObject rptSegment:rptList){
				if(!businessDate.equals(rptSegment.getString("NextDueDate"))) continue;//������
				
				//û�и�ֵ�ģ��������㣬����Ὣ��ֲ�������ڹ�ֵ���ǵ��������ǰ������ڹ�ʱ���ܻᷢ���仯��
				String updateInstalAmtFlag = rptSegment.getString("UpdateInstalAmtFlag");
				if(updateInstalAmtFlag==null||updateInstalAmtFlag.length()==0)
					rptSegment.setAttributeValue("UpdateInstalAmtFlag", "0");
				IPMTScript pmtScript = RPTFunctions.getPMTScript(loan, rptSegment);
				if(pmtScript!=null) pmtScript.nextInstalment(loan,rptSegment);//������һ�������ڴΣ��������´λ����ռ���������
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rptSegment);
				loan.setAttributeValue("LastDueDate", businessDate);
			}
		}
	
		return 1;
	}
}
