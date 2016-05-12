/**
 * 该类处理针对还款计划的利息罚息减免
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
		
		//获取贷款对象Loan
		BusinessObject loan =transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.loan, transaction.getString("RelativeObjectNo"));
		//获取本金利息减免记录
		BusinessObject paymentBill =transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取利息调整对应的还款计划
		BusinessObject paymentSchedule = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule, paymentBill.getString("PSSerialNo"));
		if(paymentSchedule == null) throw new LoanException("还款计划未找到，请检查！");
		//检查期供利息
		double waiveInteAmt = paymentBill.getDouble("WaiveInteAmt");
		double inteAmt = paymentSchedule.getDouble("PayInteAmt")-paymentSchedule.getDouble("ActualPayInteAmt");
		if(inteAmt-waiveInteAmt < 0) throw new LoanException("减免期供利息金额不能超过未还期供利息金额，请检查！");
		//检查逾期罚息
		double waiveFineAmt = paymentBill.getDouble("WaiveFineAmt");
		double fineAmt = paymentSchedule.getDouble("PayFineAmt")-paymentSchedule.getDouble("ActualPayFineAmt");
		if(fineAmt-waiveFineAmt < 0) throw new LoanException("减免逾期罚息金额不能超过未还逾期罚息金额，请检查！");
		
		paymentSchedule.setAttributeValue("PayInteAmt", Arith.round(paymentSchedule.getDouble("PayInteAmt")-waiveInteAmt,2));
		paymentSchedule.setAttributeValue("WaiveInteAmt",  Arith.round(paymentSchedule.getDouble("WaiveInteAmt")+waiveInteAmt,2));
		paymentSchedule.setAttributeValue("PayFineAmt", Arith.round(paymentSchedule.getDouble("PayFineAmt")-waiveFineAmt,2));
		paymentSchedule.setAttributeValue("WaiveFineAmt",  Arith.round(paymentSchedule.getDouble("WaiveFineAmt")+waiveFineAmt,2));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentSchedule);
		
		return 1;
	}
	
}