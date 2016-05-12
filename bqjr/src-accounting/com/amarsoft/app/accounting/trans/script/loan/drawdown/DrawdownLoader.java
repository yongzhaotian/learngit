package com.amarsoft.app.accounting.trans.script.loan.drawdown;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.ASValuePool;

public class DrawdownLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		String objectType=transaction.getString("DocumentType");
		String objectNo=transaction.getString("DocumentSerialNo");
		
		BusinessObject businessPutout = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", objectType);
		as.setAttribute("ObjectNo", objectNo);
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment," ObjectNo=:ObjectNo and ObjectType=:ObjectType order by segno ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee_log," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.feeAmortize_schedule," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subledger_detail," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.acct_transfer," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		businessPutout.setRelativeObjects(boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as));
		//加载约定还款信息
		as = new ASValuePool();
		as.setAttribute("ObjectType", objectType);
		as.setAttribute("ObjectNo", objectNo);
		as.setAttribute("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		List<BusinessObject> psList=boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule," ObjectNo=:ObjectNo and ObjectType=:ObjectType and PayType=:PayType",as);
		businessPutout.setRelativeObjects(psList);
		
		if(businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract,businessPutout.getString("ContractSerialNo"))==null){
			businessPutout.setRelativeObject(boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract,businessPutout.getString("SerialNo")));
		}
			
		as = new ASValuePool();
		as.setAttribute("ObjectType", objectType);
		as.setAttribute("ObjectNo", objectNo);
		List<BusinessObject> feeLists = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, " ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as);
		businessPutout.setRelativeObjects(feeLists);
		List<BusinessObject> feeList = null; 
		if(feeLists !=null || !feeLists.isEmpty()){
			for(BusinessObject fee:feeLists){
				ASValuePool rela = new ASValuePool();
				rela.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				rela.setAttribute("ObjectNo", fee.getString("SerialNo"));
				List<BusinessObject> feeListwaive = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive, " ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
				fee.setRelativeObjects(feeListwaive);
			}
		}
		
		ASValuePool rela = new ASValuePool();
		rela.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
		rela.setAttribute("ObjectNo", "${SerialNo}");
		//List<BusinessObject> feeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as,BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		feeList = boManager.loadBusinessObjects(feeLists, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		businessPutout.setRelativeObjects(feeList);
		//加载客户信息
		transaction.setRelativeObject(boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.customer, businessPutout.getString("CustomerID")));
		
		transaction.setRelativeObject(businessPutout);
		
		return transaction;
	}
}
