/**
 * 该类处理针对还款计划的本金利息调整，每次调整金额采用覆盖的方式处理，不是叠加
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
		
		//获取贷款对象Loan
		BusinessObject loan =transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.loan, transaction.getString("RelativeObjectNo"));
		//获取本金利息减免记录
		BusinessObject paymentBill =transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取利息调整对应的还款计划
		BusinessObject paymentSchedule = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule, paymentBill.getString("PSSerialNo"));
		if(paymentSchedule == null) throw new LoanException("还款计划未找到，请检查！");
		//获取贷款交易日期
		String businessDate = loan.getString("BusinessDate");
		//检查期供本金
		double waivePrincipalAmt = paymentBill.getDouble("WaivePrincipalAmt");
		double principalAmt = paymentSchedule.getDouble("PayPrincipalAmt")-paymentSchedule.getDouble("ActualPayPrincipalAmt");
		if(waivePrincipalAmt+principalAmt < 0) throw new LoanException("减免期供本金金额不能超过未还本金金额，请检查！");
		if(businessDate.compareTo(paymentSchedule.getString("PayDate")) >= 0 && waivePrincipalAmt >  paymentSchedule.getDouble("PrincipalBalance")+paymentSchedule.getDouble("WaivePrinaipalAmt"))
			throw new LoanException("增加本金金额不能超过剩余本金余额（不包含本期次）！");
		//检查期供利息
		double waiveInteAmt = paymentBill.getDouble("WaiveInteAmt");
		double inteAmt = paymentSchedule.getDouble("PayInteAmt")-paymentSchedule.getDouble("ActualPayInteAmt");
		if(waiveInteAmt+inteAmt < 0) throw new LoanException("减免期供利息金额不能超过未还期供利息金额，请检查！");
		//检查逾期罚息
		double waiveFineAmt = paymentBill.getDouble("WaiveFineAmt");
		double fineAmt = paymentSchedule.getDouble("PayFineAmt")-paymentSchedule.getDouble("ActualPayFineAmt");
		if(waiveFineAmt+fineAmt < 0) throw new LoanException("减免逾期罚息金额不能超过未还逾期罚息金额，请检查！");
		//检查逾期复利
		double waiveCompdInteAmt = paymentBill.getDouble("WaiveCompdInteAmt");
		double compdInteAmt = paymentSchedule.getDouble("PayCompdInteAmt")-paymentSchedule.getDouble("ActualPayCompdInteAmt");
		if(waiveCompdInteAmt+compdInteAmt < 0) throw new LoanException("减免逾期复利金额不能超过未还逾期复利金额，请检查！");
		
		paymentSchedule.setAttributeValue("PayPrincipalAmt", Arith.round(paymentSchedule.getDouble("PayPrincipalAmt")-paymentSchedule.getDouble("WaivePrincipalAmt")+waivePrincipalAmt,2));
		paymentSchedule.setAttributeValue("PayInteAmt", Arith.round(paymentSchedule.getDouble("PayInteAmt")-paymentSchedule.getDouble("WaiveInteAmt")+waiveInteAmt,2));
		paymentSchedule.setAttributeValue("PayFineAmt", Arith.round(paymentSchedule.getDouble("PayFineAmt")-paymentSchedule.getDouble("WaiveFineAmt")+waiveFineAmt,2));
		paymentSchedule.setAttributeValue("PayCompdInteAmt", Arith.round(paymentSchedule.getDouble("PayCompdInteAmt")-paymentSchedule.getDouble("WaiveCompdInteAmt")+waiveCompdInteAmt,2));
		paymentSchedule.setAttributeValue("WaivePrincipalAmt", Arith.round(waivePrincipalAmt,2));
		paymentSchedule.setAttributeValue("WaiveInteAmt",  Arith.round(waiveInteAmt,2));
		paymentSchedule.setAttributeValue("WaiveFineAmt",  Arith.round(waiveFineAmt,2));
		paymentSchedule.setAttributeValue("WaiveCompdInteAmt",  Arith.round(waiveCompdInteAmt,2));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentSchedule);
		
		//调整未来还款计划则重新生成还款计划
		if(paymentSchedule.getString("PayDate").compareTo(businessDate) > 0 || Math.abs(waivePrincipalAmt) >= 0.0d)
		{
			loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");
			loan.setAttributeValue("UpdateInstalAmtFlag", "1");
		}
		
		return 1;
	}
	
}