package com.amarsoft.app.accounting.trans.script.loan.repay;

//���������ǰ����
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.interest.settle.InterestLogFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

public class PayExecutor_presettleinterest implements ITransactionExecutor{

	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));

		String settleDate = paymentBill.getString("EX_SettleDate");
		
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan, ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest);
		if(interestLogList==null||interestLogList.isEmpty()) return 1;
		
		double prepayPrincipalAmt = paymentBill.getMoney("PrepayPrincipalAmt");
		if(prepayPrincipalAmt<=0d) return 1;
		
		String prepayInterestBaseFlag = paymentBill.getString("PrepayInterestBaseFlag");//��ǰ������Ϣ���������1��ǰ�����2�������
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");
		
		if(prepayInterestDaysFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestFlag_NoneInterest)){//��Ϣ����
			for (BusinessObject interestLog: interestLogList) {
				InterestLogFunctions.settleInterestLog(loan, interestLog, settleDate, boManager);//��Ϣ�����¿�ʼ��Ϣ
			}
		}
		else{
			if(prepayInterestBaseFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestBaseFlag_NormalBalance)){//��������Ϣ
				for (BusinessObject interestLog: interestLogList) {
					InterestLogFunctions.settleInterestLog(loan, interestLog, settleDate, boManager);//��Ϣ�����¿�ʼ��Ϣ
				}
			}
			else{
				for (BusinessObject interestLog: interestLogList) {//������ǰ�����InterestLog
					interestLog.setAttributeValue("BaseAmount",paymentBill.getMoney("PrepayPrincipalAmt"));
					BusinessObject newInterestLog = InterestLogFunctions.settleInterestLog(loan, interestLog, settleDate, boManager);//��Ϣ�����¿�ʼ��Ϣ
					if(newInterestLog!=null){
						newInterestLog.setAttributeValue("InterestDate", interestLog.getString("InterestDate"));
					}
				}
			}
		}
		return 1;
	}

}