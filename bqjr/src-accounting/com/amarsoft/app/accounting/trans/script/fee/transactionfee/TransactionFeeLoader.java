package com.amarsoft.app.accounting.trans.script.fee.transactionfee;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class TransactionFeeLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		//加载费用交易
		String whereClauseSql =" ParentTransSerialNo=:TransactionSerialNo and TransStatus='0' " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("TransactionSerialNo", transaction.getString("SerialNo"));
		List<BusinessObject> feeTransactionList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction, whereClauseSql,as);
		if(feeTransactionList!=null&&!feeTransactionList.isEmpty()){
			for(BusinessObject feeTransaction:feeTransactionList){
				TransactionFunctions.loadTransaction(feeTransaction, boManager);
			}
		}
		transaction.setRelativeObjects(feeTransactionList);
		
		return transaction;
	}
}
