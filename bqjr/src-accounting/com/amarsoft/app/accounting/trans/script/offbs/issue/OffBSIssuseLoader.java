package com.amarsoft.app.accounting.trans.script.offbs.issue;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class OffBSIssuseLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		
		BusinessObject businessPutout = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", businessPutout.getObjectType());
		as.setAttribute("ObjectNo", businessPutout.getObjectNo());
		ASValuePool rela = new ASValuePool();
		rela.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
		rela.setAttribute("ObjectNo", "${SerialNo}");
		List<BusinessObject> feeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as,BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		feeList = boManager.loadBusinessObjects(feeList, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		businessPutout.setRelativeObjects(feeList);
		
		//没取到时加载
		if(businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract,businessPutout.getString("ContractSerialNo"))==null){
			businessPutout.setRelativeObject(boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract,businessPutout.getString("ContractSerialNo")));
		}
		return transaction;
	}
}
