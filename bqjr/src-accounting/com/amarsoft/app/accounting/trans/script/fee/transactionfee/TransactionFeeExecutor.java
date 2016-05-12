package com.amarsoft.app.accounting.trans.script.fee.transactionfee;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;

public class TransactionFeeExecutor implements ITransactionExecutor {
	private ITransactionScript transactionScript;

	@Override
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript=transactionScript;
		
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();

		BusinessObject currentRelativeObject = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		List<BusinessObject> subsidiaryLedgers = currentRelativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger,new ASValuePool());
		//此交易关联的其他交易（费用）
		List<BusinessObject> relativeTransactionList = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.transaction);
		if(relativeTransactionList!=null&&!relativeTransactionList.isEmpty()){
			for(BusinessObject relativeTransaction:relativeTransactionList){
				BusinessObject fee = relativeTransaction.getRelativeObject(relativeTransaction.getString("RelativeObjectType"), relativeTransaction.getString("RelativeObjectNo"));
				BusinessObject relativeObject = relativeTransaction.getRelativeObject(fee.getString("ObjectType"), fee.getString("ObjectNo"));
				//多交易同时加载分账余额，采用统一内存对象
				if(subsidiaryLedgers!=null && !subsidiaryLedgers.isEmpty()){
					relativeTransaction.removeRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
					relativeObject.removeRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
					relativeTransaction.setRelativeObjects(subsidiaryLedgers);
					relativeObject.setRelativeObjects(subsidiaryLedgers);
				}
				
				String relativeTransCode = relativeTransaction.getString("TransCode");
				ITransactionScript scriptClass = TransactionConfig.getTransactionSript(relativeTransCode, boManager);
				scriptClass.setTransaction(relativeTransaction);
				scriptClass.run();
				subsidiaryLedgers = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger,new ASValuePool());
				List<BusinessObject> detailList = relativeTransaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subledger_detail);
				if(detailList != null && !detailList.isEmpty()){
					for(BusinessObject detail:detailList){
						detail.setAttributeValue("TransSerialNo", transaction.getObjectNo());
						transaction.setRelativeObject(detail);
					}
				}
			}
		}
		return 1;
	}
	
}
