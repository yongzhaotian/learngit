/**
 * ���ദ����Ի���ƻ�����Ϣ��Ϣ����
 */
package com.amarsoft.app.accounting.trans.script.loan.waive;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.Arith;

public class PSIntWaiveExecutor implements ITransactionExecutor{

	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		//��ȡ�������Loan
		BusinessObject loan =transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.loan, transaction.getString("RelativeObjectNo"));
		//��ȡ������Ϣ�����¼
		BusinessObject paymentBill =transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//ȡ��Ϣ������Ӧ�Ļ���ƻ�
		BusinessObject paymentSchedule = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule, paymentBill.getString("PSSerialNo"));
		if(paymentSchedule == null) throw new LoanException("����ƻ�δ�ҵ������飡");
		//����ڹ���Ϣ
		double waiveInteAmt = paymentBill.getDouble("WaiveInteAmt");
		double inteAmt = paymentSchedule.getDouble("PayInteAmt")-paymentSchedule.getDouble("ActualPayInteAmt");
		if(inteAmt-waiveInteAmt < 0) throw new LoanException("�����ڹ���Ϣ���ܳ���δ���ڹ���Ϣ�����飡");
		//������ڷ�Ϣ
		double waiveFineAmt = paymentBill.getDouble("WaiveFineAmt");
		double fineAmt = paymentSchedule.getDouble("PayFineAmt")-paymentSchedule.getDouble("ActualPayFineAmt");
		if(fineAmt-waiveFineAmt < 0) throw new LoanException("�������ڷ�Ϣ���ܳ���δ�����ڷ�Ϣ�����飡");
		
		paymentSchedule.setAttributeValue("PayInteAmt", Arith.round(paymentSchedule.getDouble("PayInteAmt")-waiveInteAmt,2));
		paymentSchedule.setAttributeValue("WaiveInteAmt",  Arith.round(paymentSchedule.getDouble("WaiveInteAmt")+waiveInteAmt,2));
		paymentSchedule.setAttributeValue("PayFineAmt", Arith.round(paymentSchedule.getDouble("PayFineAmt")-waiveFineAmt,2));
		paymentSchedule.setAttributeValue("WaiveFineAmt",  Arith.round(paymentSchedule.getDouble("WaiveFineAmt")+waiveFineAmt,2));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentSchedule);
		
		return 1;
	}
	
}