package com.amarsoft.app.accounting.trans.script.fee.recieve;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

public class FeeRecieveCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		
	
		if(fee.getDouble("ActualRecieveAmount") >= fee.getDouble("TotalAmount") && fee.getDouble("TotalAmount") > 0.0d  )
			throw new Exception("��������ȡ��ϣ������ٷ�����ȡ���ף�");
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
				feeLog.setAttributeValue("FeeAmount", feeSchedule.getDouble("Amount"));
				feeLog.setAttributeValue("ActualFeeAmount", feeSchedule.getDouble("Amount"));
				feeLog.setAttributeValue("WaiveAmount", feeSchedule.getDouble("WaiveAmount"));
				feeLog.setAttributeValue("WaiveType", feeSchedule.getDouble("0"));//���ս�����
			}
		}
		else{
			double feeAmount = 0.0d;
			if(fee.getDouble("TotalAmount") > 0.0d)
				feeAmount =fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount");//����ܽ��С�ڵ����������¼�������ܶ�ͷ��ü����ܶ�
			feeLog.setAttributeValue("FeeAmount", feeAmount);
			feeLog.setAttributeValue("WaiveType", "0");//���ս�����
			feeLog.setAttributeValue("WaiveAmount", 0.0d);
			feeLog.setAttributeValue("ActualFeeAmount", feeAmount);
		}
		
		
		return transaction;
	}
}
