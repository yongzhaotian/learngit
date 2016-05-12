package com.amarsoft.app.accounting.trans.script.fee.waive;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.trans.script.fee.common.CommonFeeScheduleCreator;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.Arith;

public class FeeWaiveExecutor implements ITransactionExecutor {
	
	@Override
	public int execute(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_log, transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee,feeLog.getString("FeeSerialNo"));		
		//HHCF������feeWaive�м�¼ȡ��ǰ�账����ڴ�
		List<BusinessObject>  feeWaiveList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive);
		BusinessObject feeWaive = null;
		for(BusinessObject feewaive:feeWaiveList){
			if(feewaive.getString("Status").equals("1") && feeLog.getString("SeqID").equals(feewaive.getString("WaiveFromStage")) )
			{
				feeWaive = feewaive;
				break;
			}
		}
		if(feeWaive == null)throw new Exception("Fee_Waive��û����Ӧ�ļ����¼��");
		int seqID = feeWaive.getInt("WaiveFromStage");
		//
		
		
		String feeScheduleSerialNo = feeLog.getString("FeeScheduleSerialNo");
		
		String waiveType = feeLog.getString("WaiveType");
		if("0".equals(waiveType)) //������
		{
			
		}
		else if("1".equals(waiveType))//��������
		{
			feeLog.setAttributeValue("WaiveAmount", Arith.round(feeLog.getDouble("FeeAmount")*feeLog.getDouble("WaivePercent")/100.00d,2));
		}
		else
			throw new Exception("���ü������Ͳ���ȷ���飡");
		
		
		//if(feeLog.getDouble("WaiveAmount") > fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount"))
		//	throw new Exception("���ü����"+feeLog.getMoney("WaiveAmount")+"����������Ӧ��ȡ��"+Arith.round(fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount"),2)+"��");
		//HHCF�������ڴ�ȷ������ƻ���¼
		List<BusinessObject> feePSList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		BusinessObject FeePS = null;
		for(BusinessObject feePS:feePSList){
			if(feePS.getInt("SeqID")==seqID){
				FeePS = feePS;
				break;
			}
		}
		if(FeePS == null)throw new Exception("�����ڴβ���ȷ��");
		//
		//HHCF:���»���ƻ�
		if(feeLog.getDouble("WaiveAmount") > FeePS.getDouble("PayPrincipalAmt")-FeePS.getDouble("ActualPayPrincipalAmt"))
			throw new Exception("���ü����"+feeLog.getMoney("WaiveAmount")+"���������üƻ�Ӧ��ȡ��"+Arith.round(FeePS.getDouble("PayPrincipalAmt")-FeePS.getDouble("ActualPayPrincipalAmt"),2)+"��");
		FeePS.setAttributeValue("PayPrincipalAmt", FeePS.getDouble("PayPrincipalAmt")-feeLog.getDouble("WaiveAmount"));
		if(FeePS.getDouble("ActualPayPrincipalAmt") >= FeePS.getDouble("PayPrincipalAmt"))
			FeePS.setAttributeValue("FinishDate", transaction.getString("TransDate"));
		else 
			FeePS.setAttributeValue("FinishDate", "");
		feeWaive.setAttributeValue("Status", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, FeePS);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feeWaive);
		//
		/*BusinessObject feeSchedule = null;
		//���û�з��üƻ��ʹ���һ�����üƻ�
		if(feeScheduleSerialNo == null || feeScheduleSerialNo.length() == 0)
		{
			//��ȡ���üƻ�
			List<BusinessObject> feeScheduleList = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule);
			if(feeScheduleList == null || feeScheduleList.isEmpty())
			{
				CommonFeeScheduleCreator c =new CommonFeeScheduleCreator();
				feeSchedule=c.init("",transactionScript);
				if(feeSchedule.getDouble("AcutalAmount") >= feeSchedule.getDouble("Amount"))
					feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
				else 
					feeSchedule.setAttributeValue("FinishDate", "");
			}
			else
			{
				double waiveAmount = feeLog.getDouble("WaiveAmount");
				for(BusinessObject bo:feeScheduleList)
				{
					String direction = bo.getString("FeeFlag");
					if(direction.equals(ACCOUNT_CONSTANTS.FEEFLAG_RECIEVE))
					{
						double balance = bo.getDouble("Amount")-bo.getDouble("ActualAmount");
						if(balance - waiveAmount>0 )
						{
							balance = waiveAmount;
							waiveAmount = 0;
						}
						else
						{
							waiveAmount -= balance;
						}
						
						bo.setAttributeValue("Amount", bo.getDouble("Amount") - balance);
						bo.setAttributeValue("WaiveAmount", bo.getDouble("WaiveAmount") + balance);
						if(bo.getDouble("AcutalAmount") >= bo.getDouble("Amount"))
							bo.setAttributeValue("FinishDate", transaction.getString("TransDate"));
						else 
							bo.setAttributeValue("FinishDate", "");
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bo);
					}
					if(Math.abs(waiveAmount) < 0.0000001) break;
				}
				
				if(waiveAmount > 0)
				{
					throw new Exception("������ܳ������üƻ�Ӧ��δ��ȡ��");
				}
			}
			
		}
		else
		{
			feeSchedule = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeLog.getDouble("WaiveAmount") > feeSchedule.getDouble("Amount")-feeSchedule.getDouble("ActualAmount"))
				throw new Exception("���ü����"+feeLog.getMoney("WaiveAmount")+"���������üƻ�Ӧ��ȡ��"+Arith.round(feeSchedule.getDouble("Amount")-feeSchedule.getDouble("ActualAmount"),2)+"��");
			feeSchedule.setAttributeValue("Amount", feeSchedule.getDouble("Amount") - feeLog.getDouble("WaiveAmount"));
			feeSchedule.setAttributeValue("WaiveAmount", feeSchedule.getDouble("WaiveAmount") + feeLog.getDouble("WaiveAmount"));
			if(feeSchedule.getDouble("AcutalAmount") >= feeSchedule.getDouble("Amount"))
				feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
			else 
				feeSchedule.setAttributeValue("FinishDate", "");
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feeSchedule);
		}*/
		//�������
		fee.setAttributeValue("WaiveAmount", feeLog.getDouble("WaiveAmount")+fee.getDouble("WaiveAmount"));
		fee.setAttributeValue("TotalAmount", fee.getDouble("TotalAmount")-feeLog.getDouble("WaiveAmount"));
		
		feeLog.setAttributeValue("TransDate", transaction.getString("TransDate"));
		feeLog.setAttributeValue("Status", "1");
		if(fee.getString("Status").equals("0") || "".equals(fee.getString("Status"))){
			fee.setAttributeValue("Status","1");
		}
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, fee);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feeLog);
		return 1;
	}
}
