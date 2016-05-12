package com.amarsoft.app.accounting.trans.script.fee.waive;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.FeeFunctions;

public class FeeWaiveCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));
		
	
		if(fee.getDouble("ActualRecieveAmount") >= fee.getDouble("TotalAmount"))
			throw new Exception("��������ȡ��ϣ������ٷ�����⽻�ף�");
		
		feeLog.setAttributeValue("Direction", "R");
		
		BusinessObject feeSchedule=null;
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		if(!"".equals(feeScheduleSerialNo) && feeScheduleSerialNo != null){
			feeSchedule = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeSchedule!=null){
				transaction.setRelativeObject(feeSchedule);
				fee.setRelativeObject(feeSchedule);
				feeLog.setAttributeValue("FeeAmount", feeSchedule.getDouble("Amount"));
				feeLog.setAttributeValue("WaiveAmount", 0.0d);
				feeLog.setAttributeValue("WaiveType", "0");//���ս�����
			}
		}
		else{
			double feeAmount =fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount");//����ܽ��С�ڵ����������¼�������ܶ�ͷ��ü����ܶ�
			if(fee.getDouble("TotalAmount") <= 0.0d )
			{
				FeeFunctions.createFeeScheduleList(fee,fee.getRelativeObject(fee.getString("ObjectType"), fee.getString("ObjectNo")), boManager);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, fee);
			}
			feeLog.setAttributeValue("FeeAmount", feeAmount);
			feeLog.setAttributeValue("WaiveType", "0");//���ս�����
			feeLog.setAttributeValue("WaiveAmount", 0.0d);
		}
		
		return transaction;
	}
}
