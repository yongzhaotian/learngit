package com.amarsoft.app.accounting.trans.script.loan.repayreverse;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class PaymentReverseLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		//原交易信息
		BusinessObject oldTransaction = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		transaction.setRelativeObject(oldTransaction);
						
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//加载Loan费用计划
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo", loan.getObjectNo());
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo order by PayDate " ;
		List<BusinessObject> feeScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule, whereClauseSql,as);
		loan.setRelativeObjects(feeScheduleList);
		//加载关联费用交易信息
		whereClauseSql =" ParentTransSerialNo=:TransactionSerialNo and TransStatus='1' " ;
		as = new ASValuePool();
		as.setAttribute("TransactionSerialNo", oldTransaction.getString("SerialNo"));
		List<BusinessObject> feeTransactionList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction, whereClauseSql,as);
		if(feeTransactionList!=null&&!feeTransactionList.isEmpty()){
			for(BusinessObject feeTransaction:feeTransactionList){
				TransactionFunctions.loadTransaction(feeTransaction, boManager);
			}
		}
		oldTransaction.setRelativeObjects(feeTransactionList);
		BusinessObject oldPaymentBill = oldTransaction.getRelativeObject(oldTransaction.getString("DocumentType"), oldTransaction.getString("DocumentSerialNo"));
		//获取原单据交易流水
		as = new ASValuePool();
		as.setAttribute("TransSerialNo", oldPaymentBill.getObjectNo());
		List<BusinessObject> paymentLogList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.PaymentLog, "TransSerialNo=:TransSerialNo", as);
		oldPaymentBill.setRelativeObjects(paymentLogList);
		
		BusinessObject bc = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract, loan.getString("ContractSerialNo"));
		loan.setRelativeObject(bc);
		
		return transaction;
	}
}
