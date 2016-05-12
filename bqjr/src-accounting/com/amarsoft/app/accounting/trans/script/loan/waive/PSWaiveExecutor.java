/**
 * ���ദ����Ի���ƻ��ı�����Ϣ������ÿ�ε��������ø��ǵķ�ʽ�������ǵ���
 */
package com.amarsoft.app.accounting.trans.script.loan.waive;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.Arith;

public class PSWaiveExecutor implements ITransactionExecutor{

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
		//��ȡ���������
		String businessDate = loan.getString("BusinessDate");
		//����ڹ�����
		double waivePrincipalAmt = paymentBill.getDouble("WaivePrincipalAmt");
		double principalAmt = paymentSchedule.getDouble("PayPrincipalAmt")-paymentSchedule.getDouble("ActualPayPrincipalAmt");
		if(waivePrincipalAmt+principalAmt < 0) throw new LoanException("�����ڹ�������ܳ���δ����������飡");
		if(businessDate.compareTo(paymentSchedule.getString("PayDate")) >= 0 && waivePrincipalAmt >  paymentSchedule.getDouble("PrincipalBalance")+paymentSchedule.getDouble("WaivePrinaipalAmt"))
			throw new LoanException("���ӱ�����ܳ���ʣ�౾�������������ڴΣ���");
		//����ڹ���Ϣ
		double waiveInteAmt = paymentBill.getDouble("WaiveInteAmt");
		double inteAmt = paymentSchedule.getDouble("PayInteAmt")-paymentSchedule.getDouble("ActualPayInteAmt");
		if(waiveInteAmt+inteAmt < 0) throw new LoanException("�����ڹ���Ϣ���ܳ���δ���ڹ���Ϣ�����飡");
		//������ڷ�Ϣ
		double waiveFineAmt = paymentBill.getDouble("WaiveFineAmt");
		double fineAmt = paymentSchedule.getDouble("PayFineAmt")-paymentSchedule.getDouble("ActualPayFineAmt");
		if(waiveFineAmt+fineAmt < 0) throw new LoanException("�������ڷ�Ϣ���ܳ���δ�����ڷ�Ϣ�����飡");
		//������ڸ���
		double waiveCompdInteAmt = paymentBill.getDouble("WaiveCompdInteAmt");
		double compdInteAmt = paymentSchedule.getDouble("PayCompdInteAmt")-paymentSchedule.getDouble("ActualPayCompdInteAmt");
		if(waiveCompdInteAmt+compdInteAmt < 0) throw new LoanException("�������ڸ������ܳ���δ�����ڸ��������飡");
		
		paymentSchedule.setAttributeValue("PayPrincipalAmt", Arith.round(paymentSchedule.getDouble("PayPrincipalAmt")-paymentSchedule.getDouble("WaivePrincipalAmt")+waivePrincipalAmt,2));
		paymentSchedule.setAttributeValue("PayInteAmt", Arith.round(paymentSchedule.getDouble("PayInteAmt")-paymentSchedule.getDouble("WaiveInteAmt")+waiveInteAmt,2));
		paymentSchedule.setAttributeValue("PayFineAmt", Arith.round(paymentSchedule.getDouble("PayFineAmt")-paymentSchedule.getDouble("WaiveFineAmt")+waiveFineAmt,2));
		paymentSchedule.setAttributeValue("PayCompdInteAmt", Arith.round(paymentSchedule.getDouble("PayCompdInteAmt")-paymentSchedule.getDouble("WaiveCompdInteAmt")+waiveCompdInteAmt,2));
		paymentSchedule.setAttributeValue("WaivePrincipalAmt", Arith.round(waivePrincipalAmt,2));
		paymentSchedule.setAttributeValue("WaiveInteAmt",  Arith.round(waiveInteAmt,2));
		paymentSchedule.setAttributeValue("WaiveFineAmt",  Arith.round(waiveFineAmt,2));
		paymentSchedule.setAttributeValue("WaiveCompdInteAmt",  Arith.round(waiveCompdInteAmt,2));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentSchedule);
		
		//����δ������ƻ����������ɻ���ƻ�
		if(paymentSchedule.getString("PayDate").compareTo(businessDate) > 0 || Math.abs(waivePrincipalAmt) >= 0.0d)
		{
			loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");
			loan.setAttributeValue("UpdateInstalAmtFlag", "1");
		}
		
		return 1;
	}
	
}