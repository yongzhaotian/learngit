package com.amarsoft.app.accounting.trans.script.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class RelativeObjectSubledgerLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));

		//加载Loan的余额信息
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", loan.getObjectType());
		as.setAttribute("ObjectNo", loan.getObjectNo());
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo " ;
		List<BusinessObject> subLedgerList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger, whereClauseSql + " and (CloseDate is null or CloseDate='' )",as);
		if(subLedgerList==null||subLedgerList.isEmpty()) throw new Exception("该业务无余额信息！无法修改"); 
		loan.setRelativeObjects(subLedgerList);
		return transaction;
	}
}
