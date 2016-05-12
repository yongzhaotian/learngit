package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.dict.als.cache.CodeCache;

public class DelayFineExecutor implements ITransactionExecutor {
	//���ɽ���
	@Override
	public int execute(String scriptID, ITransactionScript transactionScript)
			throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));

		List<BusinessObject> paymentScheduleList = loan .getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		String businessdate = transaction.getString("TransDate");
		String feeType = "A10";//���ɽ���ô���
		int seqID = 9999;
		BusinessObject FeePS = null;
		//�ӻ���ƻ��л�ȡ�������ڵ���һ�ڵ�Ӧ������
		for(BusinessObject paymentSchedule:paymentScheduleList){
			String payDate = paymentSchedule.getString("PayDate");
			if(payDate.compareTo(businessdate)>=0)continue;
			else{
				int seqId = paymentSchedule.getInt("SeqID");
				if(seqId<seqID)seqID = seqId;
				FeePS = paymentSchedule;
			}
		}
		if(seqID == 9999)return 1;
		String ODdate = FeePS.getString("PayDate");
		int days = DateFunctions.getDays(ODdate, businessdate);
		//ͨ��������ȡ���ɽ���ȡʱ��ͽ����Ϣ
		String payorders = CodeCache.getItem("DelayFine","01").getItemDescribe();
		if(payorders == null || "".equals(payorders)) throw new LoanException("��Ч�����ɽ������Ϣ�����飡");
		String[] amtOrderArray = payorders.substring(payorders.indexOf("@")+1).trim().split("@");
		int i = 0;//������ʾ����ĳһ�ڵ����ɽ���30��Ϊ��һ�ڣ�60��Ϊ�ڶ��ڵȵȣ�
		for(String amtOrder:amtOrderArray){
			i++;
			String[] rules = amtOrder.split(",");
			String ruleDate = rules[0];
			String addAmount = rules[1];
			if(days >= Integer.parseInt(ruleDate))//ת�����Ƚϵ�ǰ������������������õ�����
			{
				//�жϵ�ǰ������Ӧ��fee��¼�ͻ���ƻ���¼�Ƿ�����,����δ�������������߼�����fee��ps��¼
				int isChecked = ischecked(loan,feeType,ruleDate,i);
				if(isChecked == 0){
					addFeeandPS(loan,feeType,ruleDate,addAmount,businessdate,boManager,i);
				}
				else continue;
			}
			else break;
		}
		
		
		return 1;
	}
	//���ݵ�ǰ���ɽ����Ϣ�ж��Ƿ����Ӧ���Ӽ�¼
		private int ischecked(BusinessObject loan, String feeType, String ruleDate, int i) throws Exception {
			
			List<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
			for(BusinessObject fee:feeList){
				String feeTypeNew = fee.getString("FeeType");
				if(feeType.equals(feeTypeNew)){
					List<BusinessObject> feePSList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
					for(BusinessObject feePS:feePSList){
						int seqID = feePS.getInt("SeqID");
						if(i == seqID)return 1;
						else continue;
					}
					break;
				}
				else continue;
			}
			return 0;
		}

		private void addFeeandPS(BusinessObject loan, String feeType, String ruleDate, String addAmount, String businessdate, AbstractBusinessObjectManager boManager, int i) throws Exception {
			//�ж��Ƿ���Ҫ��������
			List<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
			BusinessObject dffee = null;
			for(BusinessObject fee:feeList){
				String feeTypeNew = fee.getString("FeeType");
				if(feeType.equals(feeTypeNew)){
					dffee = fee;
					break;
				}
				else continue;
			}
			if(dffee == null){//�����ɽ��¼Ϊ�գ��������ü�¼
				dffee = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee,boManager);
				dffee.setAttributeValue("ObjectNo", loan.getObjectNo());
				dffee.setAttributeValue("ObjectType", loan.getObjectType());
				dffee.setAttributeValue("FeeType", "A10");
				dffee.setAttributeValue("FeeTermID", "");//���ɽ������ţ�
				dffee.setAttributeValue("Currency", "01");
				dffee.setAttributeValue("Amount", Double.parseDouble(addAmount));
				dffee.setAttributeValue("FeeFlag", "R");
				dffee.setAttributeValue("FeeCalType", "01");
				dffee.setAttributeValue("FeeFrequency", "3");
				dffee.setAttributeValue("FeePayDateFlag", "03");
				dffee.setAttributeValue("Status", "1");
				dffee.setAttributeValue("TransCode", "9091");
				loan.setRelativeObject(dffee);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, dffee);
			}
			else{
				dffee.setAttributeValue("Amount", dffee.getDouble("Amount")+Double.parseDouble(addAmount));
				dffee.setAttributeValue("TotalAmount", dffee.getDouble("TotalAmount")+Double.parseDouble(addAmount));
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, dffee);
			}
			BusinessObject feepS = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,boManager);
			
			feepS.setAttributeValue("ObjectType", dffee.getObjectType());
			feepS.setAttributeValue("ObjectNo", dffee.getString("SerialNo"));
			feepS.setAttributeValue("SeqID", i);
			feepS.setAttributeValue("PayType", dffee.getString("FeeType"));
			feepS.setAttributeValue("PayDate", businessdate);
			feepS.setAttributeValue("PayIntAmt", Integer.parseInt(addAmount));
			feepS.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			feepS.setAttributeValue("RelativeObjectType", loan.getObjectType());
			feepS.setAttributeValue("RelativeObjectNo", loan.getString("SerialNo"));
			dffee.setRelativeObject(feepS);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, feepS);
		}
}
