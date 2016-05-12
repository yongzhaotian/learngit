package com.amarsoft.app.accounting.trans.script.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class ReverseTransactionLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();

		String whereClauseSql ="";
		ASValuePool as = null;
		//原交易信息
		BusinessObject oldTransaction = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		oldTransaction = TransactionFunctions.loadTransaction(oldTransaction, boManager);
		
		//加载关联费用交易信息
		whereClauseSql =" ParentTransSerialNo=:TransactionSerialNo and TransStatus='1' " ;
		as = new ASValuePool();
		as.setAttribute("TransactionSerialNo", oldTransaction.getString("SerialNo"));
		List<BusinessObject> feeTransactionList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction, whereClauseSql,as);
		if(feeTransactionList!=null&&!feeTransactionList.isEmpty()){
			for(BusinessObject feeTransaction:feeTransactionList){
				feeTransaction = TransactionFunctions.loadTransaction(feeTransaction, boManager);
				oldTransaction.setRelativeObject(feeTransaction);
			}
		}
		oldTransaction.setRelativeObjects(feeTransactionList);
		
		//原交易分录
		whereClauseSql = " TransSerialNo=:TransSerialNo ";
		as = new ASValuePool();
		as.setAttribute("TransSerialNo", transaction.getString("StrikeSerialNo"));
		List<BusinessObject> oldDetailList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subledger_detail, whereClauseSql,as);
		oldTransaction.setRelativeObjects(oldDetailList);
		
		transaction.setRelativeObject(oldTransaction);
		return transaction;
	}
}
