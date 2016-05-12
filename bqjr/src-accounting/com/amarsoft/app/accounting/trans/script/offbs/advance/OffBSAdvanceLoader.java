package com.amarsoft.app.accounting.trans.script.offbs.advance;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class OffBSAdvanceLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject offBSBusiness = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));

		//加载表外业务的余额信息
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", offBSBusiness.getObjectType());
		as.setAttribute("ObjectNo", offBSBusiness.getObjectNo());
		offBSBusiness.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger, whereClauseSql + " and (CloseDate is null or CloseDate='' )",as));
		
		//加载垫款申请信息
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		as.setAttribute("ObjectType", businessPutout.getObjectType());
		as.setAttribute("ObjectNo", businessPutout.getObjectNo());
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,whereClauseSql,as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger,whereClauseSql,as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts,whereClauseSql,as));
		
		return transaction;
	}
}
