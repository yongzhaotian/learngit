package com.amarsoft.app.accounting.trans.script.fee.refund;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

public class FeeRefundCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		
	
		if(fee.getDouble("ActualRecieveAmount") <= 0.0d)
			throw new Exception("���û�δ��ȡ��ϣ����ܷ����˻����ף�");
		List<BusinessObject> depositAccounts =  fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		if(depositAccounts!=null)
		{
			for(BusinessObject da:depositAccounts)
			{
				String accountIndicator = da.getString("AccountIndicator");//�˻�����
				if(ACCOUNT_CONSTANTS.AccountIndicator_01.equals(accountIndicator))//�����˻�
				{
					feeLog.setAttributeValue("RecieveAccountFlag", da.getString("AccountFlag"));
					feeLog.setAttributeValue("RecieveAccountType", da.getString("AccountType"));
					feeLog.setAttributeValue("RecieveAccountNo", da.getString("AccountNo"));
					feeLog.setAttributeValue("RecieveAccountName", da.getString("AccountName"));
					feeLog.setAttributeValue("RecieveAccountCCY", da.getString("AccountCurrency"));
					break;
				}
			}
		}
		
		feeLog.setAttributeValue("Direction", "R");
		
		BusinessObject feeSchedule=null;
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		if(!"".equals(feeScheduleSerialNo) && feeScheduleSerialNo != null){
			feeSchedule = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeSchedule!=null){
				transaction.setRelativeObject(feeSchedule);
				fee.setRelativeObject(feeSchedule);
				feeLog.setAttributeValue("FeeAmount", feeSchedule.getDouble("ActualAmount"));
				feeLog.setAttributeValue("ActualFeeAmount", feeSchedule.getDouble("ActualAmount"));
				feeLog.setAttributeValue("WaiveAmount", 0.0d);
				feeLog.setAttributeValue("WaiveType", "");
			}
		}
		else{
			double feeAmount =fee.getDouble("ActualRecieveAmount");//����ܽ��С�ڵ����������¼�������ܶ�ͷ��ü����ܶ�
			feeLog.setAttributeValue("FeeAmount", feeAmount);
			feeLog.setAttributeValue("WaiveType", "");
			feeLog.setAttributeValue("WaiveAmount", 0.0d);
			feeLog.setAttributeValue("ActualFeeAmount", feeAmount);
		}
		
		
		return transaction;
	}
}
