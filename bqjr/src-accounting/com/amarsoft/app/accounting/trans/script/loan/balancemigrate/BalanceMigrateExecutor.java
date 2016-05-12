package com.amarsoft.app.accounting.trans.script.loan.balancemigrate;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.Arith;

public class BalanceMigrateExecutor implements ITransactionExecutor{
	

	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		String changePrincipalType = loanChange.getString("ChangePrincipalType");
		if("".equals(changePrincipalType)) throw new Exception("����ĵ�������Ϊ�գ�");
		
		double amt = loanChange.getDouble("ChangePrincipalAmt");
		double inte = 0.0d;
		List<BusinessObject> rateSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		if(rateSegmentList != null)
		{
			for(BusinessObject rateSegment:rateSegmentList)
			{
				inte +=InterestFunctions.getInterest(amt, rateSegment,loan, rateSegment.getString("LastInteDate"), transaction.getString("TransDate"));
			}
		}
		
		double balance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo"
																	,ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal
																	,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		
		//����ת����
		if("010".equals(changePrincipalType)){
			
			//����ת����,��Ҫ����������������Ϣת�뵽ǷϢ
			//�����һ��Ƿ�Ļ���ƻ�������У���������������棬��û�У�д��һ�����쵽�ڵļƻ�
			//ɾ��δ���Ļ���ƻ���Ȼ�������µĻ���ƻ�
			List<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			
			BusinessObject paymentScheduleTmp = null;
			if(paymentScheduleList!=null && paymentScheduleList.size()>0){
				int size = paymentScheduleList.size()-1;
				String businessDate = loan.getString("BusinessDate");
				for(int i=size;i>=0;i--){
					BusinessObject paymentSchedule = paymentScheduleList.get(i);
					
					//δ���Ļ���ƻ���������һ�㻹��ƻ��Ķ�����
					if(paymentSchedule.getString("PayDate").compareTo(businessDate)>0 ||
							!paymentSchedule.getString("PayType").equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)) continue;
					paymentScheduleTmp = paymentSchedule;
					break;
				}
				
				//���û������Ļ���ƻ������²���һ������ƻ�
				if(paymentScheduleTmp==null){
					BusinessObject newPaymentSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,boManager);
					newPaymentSchedule.setAttributeValue("ObjectType", loan.getObjectType());
					newPaymentSchedule.setAttributeValue("ObjectNo", loan.getObjectNo());
					newPaymentSchedule.setAttributeValue("SeqID", loan.getString("CurrentPeriod")+1);
					newPaymentSchedule.setAttributeValue("PayDate", businessDate);
					newPaymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
					newPaymentSchedule.setAttributeValue("InteDate", businessDate);
					newPaymentSchedule.setAttributeValue("PayPrincipalAmt", amt);
					newPaymentSchedule.setAttributeValue("PayInteAmt", inte);
					newPaymentSchedule.setAttributeValue("PrincipalBalance", Arith.round(balance-amt,2));
					newPaymentSchedule.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
					newPaymentSchedule.setAttributeValue("Remark", "��������ת���ڱ���");
					boManager.setBusinessObject(
							AbstractBusinessObjectManager.operateflag_new, newPaymentSchedule);
					
				}else{//����У������һ�ڸ���Ӧ����������
					paymentScheduleTmp.setAttributeValue("PayPrincipalAmt",Arith.round(paymentScheduleTmp.getDouble("PayPrincipalAmt")+amt,2));
					paymentScheduleTmp.setAttributeValue("PayInteAmt", Arith.round(paymentScheduleTmp.getDouble("PayInteAmt")+inte,2));
					paymentScheduleTmp.setAttributeValue("PrincipalBalance",Arith.round(paymentScheduleTmp.getDouble("PrincipalBalance")-amt,2) );
					paymentScheduleTmp.setAttributeValue("FinishDate","" );
					paymentScheduleTmp.setAttributeValue("SettleDate","" );
					
					boManager.setBusinessObject(
							AbstractBusinessObjectManager.operateflag_update, paymentScheduleTmp);
				}
			}
			
		}else if("020".equals(changePrincipalType)){ //����ת����
			List<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			double amtTemp=amt;
			if(paymentScheduleList!=null&&paymentScheduleList.size()>0){
				int size = paymentScheduleList.size()-1;
				String businessDate = loan.getString("BusinessDate");
				for(int i =size;i>=0;i-- ){
					if(amtTemp<=0) break;
					BusinessObject bo =  paymentScheduleList.get(i);
					if(businessDate.compareTo(bo.getString("PayDate"))<0 || !"".equals(bo.getString("FinishDate"))) continue;
					double payAmount = Arith.round(bo.getDouble("PayPrincipalAmt"),2) - Arith.round(bo.getDouble("ActualPayPrincipalAmt"),2);
					if(payAmount<=0d)continue;
					if(amtTemp-payAmount>0){
						bo.setAttributeValue("PayPrincipalAmt", bo.getDouble("ActualPayPrincipalAmt"));
						amtTemp-=payAmount;
						//bo.setAttributeValue("PrincipalBalance", bo.getDouble("ActualPayPrincipalAmt"));
						bo.setAttributeValue("PrincipalBalance",Arith.round(bo.getDouble("PrincipalBalance")+payAmount,2) );
					}else{
						bo.setAttributeValue("PayPrincipalAmt", bo.getDouble("PayPrincipalAmt")-amtTemp);
						bo.setAttributeValue("PrincipalBalance",Arith.round(bo.getDouble("PrincipalBalance")+amtTemp,2) );
						amtTemp=0;
					}
					//������Ϊ���¡�
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bo);			
				}
			}
		}
		else
			throw new Exception("����ĵ������Ͳ���ȷ��");
				
		if(Math.abs(amt) > 0.0 ){
			loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");
			loan.setAttributeValue("UpdateInstalAmtFlag", "1");
		}
		
		return 1;
	}
}