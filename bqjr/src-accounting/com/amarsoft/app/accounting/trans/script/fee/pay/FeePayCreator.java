package com.amarsoft.app.accounting.trans.script.fee.pay;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.FeeFunctions;

public class FeePayCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		
		if(fee.getDouble("ActualPayAmount") >= fee.getDouble("TotalAmount"))
			throw new Exception("������֧����ϣ������ٷ���֧�����ף�");
		List<BusinessObject> depositAccounts =  fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		if(depositAccounts!=null)
		{
			for(BusinessObject da:depositAccounts)
			{
				String accountIndicator = da.getString("AccountIndicator");//�˻�����
				if(ACCOUNT_CONSTANTS.AccountIndicator_04.equals(accountIndicator))//�����˻�
				{
					feeLog.setAttributeValue("PayAccountFlag", da.getString("AccountFlag"));
					feeLog.setAttributeValue("PayAccountType", da.getString("AccountType"));
					feeLog.setAttributeValue("PayAccountNo", da.getString("AccountNo"));
					feeLog.setAttributeValue("PayAccountName", da.getString("AccountName"));
					feeLog.setAttributeValue("PayAccountCCY", da.getString("AccountCurrency"));
					break;
				}
			}
		}
		
		feeLog.setAttributeValue("Direction", "P");
		
		BusinessObject feeSchedule=null;
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		if(!"".equals(feeScheduleSerialNo) && feeScheduleSerialNo != null){
			feeSchedule = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeSchedule!=null){
				transaction.setRelativeObject(feeSchedule);
				fee.setRelativeObject(feeSchedule);
				feeLog.setAttributeValue("FeeAmount", feeSchedule.getDouble("Amount"));
				feeLog.setAttributeValue("ActualFeeAmount", feeSchedule.getDouble("Amount"));
				feeLog.setAttributeValue("WaiveAmount", 0.0d);
				feeLog.setAttributeValue("WaiveType", "");//���ս�����
			}
		}
		else{
			double feeAmount =fee.getDouble("TotalAmount")-fee.getDouble("ActualPayAmount");//����ܽ��С�ڵ����������¼�������ܶ�ͷ��ü����ܶ�
			if(fee.getDouble("TotalAmount") <= 0.0d )
			{
				FeeFunctions.createFeeScheduleList(fee,fee.getRelativeObject(fee.getString("ObjectType"), fee.getString("ObjectNo")), boManager);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, fee);
			}
			feeLog.setAttributeValue("FeeAmount", feeAmount);
			feeLog.setAttributeValue("WaiveType", "");//���ս�����
			feeLog.setAttributeValue("WaiveAmount", 0.0d);
			feeLog.setAttributeValue("ActualFeeAmount", feeAmount);
		}
		
		return transaction;
	}
}
