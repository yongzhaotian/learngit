package com.amarsoft.app.accounting.trans.script.fee.change;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class FeeChangeLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject feeRelativeObject = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		ASValuePool rela = new ASValuePool();
		rela.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
		rela.setAttribute("ObjectNo", "${SerialNo}");
		//加载新Loan现有费用方案
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan_change);
		as.setAttribute("ObjectNo",loanChange.getObjectNo());
		as.setAttribute("Status","0");
		List<BusinessObject> newFeeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, whereClauseSql,as,BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		newFeeList = boManager.loadBusinessObjects(newFeeList, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		loanChange.setRelativeObjects(newFeeList);
		as = new ASValuePool();
		as.setAttribute("ObjectType",transaction.getString("RelativeObjectType"));
		as.setAttribute("ObjectNo",transaction.getString("RelativeObjectNo"));
		as.setAttribute("Status","1");
		List<BusinessObject> oldFeeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, whereClauseSql,as,BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		oldFeeList = boManager.loadBusinessObjects(oldFeeList, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		rela = new ASValuePool();
		rela.setAttribute("FeeSerialNo", "${SerialNo}");
		oldFeeList = boManager.loadBusinessObjects(oldFeeList, BUSINESSOBJECT_CONSTATNTS.fee_schedule," FeeSerialNo=:FeeSerialNo ",rela);
		feeRelativeObject.setRelativeObjects(oldFeeList);
		
		return transaction;
	}
}
